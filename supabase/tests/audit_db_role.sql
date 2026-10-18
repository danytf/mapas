-- Pruebas de H-03 (search_path de set_updated_at) y del rol de base de datos en la auditoría sin usuario.
-- Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/audit_db_role.sql
begin;

create temp table adr_results (name text, ok boolean, detail text);
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into adr_results values (p_name, coalesce(p_ok, false), p_detail) $$;

-- H-03: search_path vacío en set_updated_at y en write_audit_log.
select pg_temp.check('set_updated_at con search_path vacío',
  (select coalesce(proconfig, '{}') @> array['search_path=""'] from pg_proc where oid = 'public.set_updated_at()'::regprocedure),
  (select coalesce(proconfig::text, 'sin config') from pg_proc where oid = 'public.set_updated_at()'::regprocedure));
select pg_temp.check('write_audit_log con search_path vacío',
  (select coalesce(proconfig, '{}') @> array['search_path=""'] from pg_proc where oid = 'public.write_audit_log()'::regprocedure), '');

-- Sin usuario de aplicación: se registra db_role (profiles está auditada).
select set_config('request.jwt.claim.sub', '', true);
insert into auth.users (id, raw_user_meta_data) values ('00000000-0000-4000-8000-00000000f0a1', '{"full_name":"Aud A"}');
select pg_temp.check('sin usuario: actor_id nulo y db_role presente',
  exists (select 1 from public.audit_log where table_name = 'profiles' and action = 'insert'
          and record_id = '00000000-0000-4000-8000-00000000f0a1'
          and actor_id is null and details ->> 'db_role' = session_user::text), '');

-- El JWT de service_role se refleja en jwt_role.
select set_config('request.jwt.claim.role', 'service_role', true);
update public.profiles set display_name = 'Aud A b' where id = '00000000-0000-4000-8000-00000000f0a1';
select pg_temp.check('sin usuario con JWT service_role: jwt_role presente',
  exists (select 1 from public.audit_log where table_name = 'profiles' and action = 'update'
          and record_id = '00000000-0000-4000-8000-00000000f0a1' and details ->> 'jwt_role' = 'service_role'), '');

-- Con usuario de aplicación: sin db_role (registro idéntico al de antes).
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-00000000f0a1', true);
update public.profiles set display_name = 'Aud A c' where id = '00000000-0000-4000-8000-00000000f0a1';
select pg_temp.check('con usuario: actor_id informado y sin db_role',
  exists (select 1 from public.audit_log where table_name = 'profiles' and action = 'update'
          and record_id = '00000000-0000-4000-8000-00000000f0a1'
          and actor_id = '00000000-0000-4000-8000-00000000f0a1' and not (details ? 'db_role')), '');

-- set_updated_at sigue actualizando updated_at (profiles tiene el disparador).
select pg_temp.check('set_updated_at actualiza updated_at',
  (select updated_at >= created_at from public.profiles where id = '00000000-0000-4000-8000-00000000f0a1'), '');

select name, case when ok then 'OK' else 'FALLO' end as resultado, detail from adr_results order by name;
do $$
begin
  if exists (select 1 from adr_results where not ok) then
    raise exception 'audit_db_role: hay pruebas fallidas';
  end if;
end $$;
rollback;
