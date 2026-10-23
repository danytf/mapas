-- Pruebas de list_establishment_assignees. Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/permit_assignees.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data, email) values
  (pg_temp.u('e1'), '{"full_name":"AS admin"}', 'admin.as@wesser.test'), (pg_temp.u('e2'), '{"full_name":"AS dos"}', 'dos.as@wesser.test'),
  (pg_temp.u('e3'), '{"full_name":"AS tres"}', 'tres.as@wesser.test'), (pg_temp.u('e4'), '{"full_name":"AS cuatro"}', 'cuatro.as@wesser.test'),
  (pg_temp.u('e5'), '{"full_name":"AS cinco"}', 'cinco.as@wesser.test');
update public.profiles set role = 'admin' where id = pg_temp.u('e1');
update public.profiles set display_name = 'Ana Dos' where id = pg_temp.u('e2');
update public.profiles set display_name = null where id in (pg_temp.u('e1'), pg_temp.u('e3'));
update public.profiles set is_active = false where id = pg_temp.u('e5');
insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '88', 'AS Granada'), (pg_temp.u('f2'), '87', 'AS Malaga');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'AS Mun', 'as mun');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'as_cat', 'AS Cat');
-- e2, e3, e5 (inactivo): Granada; e4: Málaga.
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('e2'), pg_temp.u('f1'), pg_temp.u('e1')), (pg_temp.u('e3'), pg_temp.u('f1'), pg_temp.u('e1')),
  (pg_temp.u('e5'), pg_temp.u('f1'), pg_temp.u('e1')), (pg_temp.u('e4'), pg_temp.u('f2'), pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'AS Est', 'as est', 'Calle', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1'));

create temp table as_results (name text, ok boolean, detail text);
create temp table as_seen (id uuid, label text);
grant all on as_results, as_seen to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into as_results values (p_name, coalesce(p_ok, false), p_detail) $$;
create function pg_temp.as_user(p_user text, p_sql text) returns text language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_user)::text, true);
  set local role authenticated;
  begin execute p_sql; exception when others then reset role; return sqlstate; end;
  reset role;
  return 'ok';
end $$;

select pg_temp.as_user('e2', format('insert into as_seen select * from public.list_establishment_assignees(%L)', pg_temp.u('a1')));
select pg_temp.check('un usuario de Granada ve a los administradores y a los usuarios activos de Granada',
  (select count(*) = 3 from as_seen where id in (pg_temp.u('e1'), pg_temp.u('e2'), pg_temp.u('e3'))) and (select count(*) = 3 from as_seen), (select count(*)::text from as_seen));
select pg_temp.check('no aparecen usuarios de otra provincia ni inactivos', not exists (select 1 from as_seen where id in (pg_temp.u('e4'), pg_temp.u('e5'))));
select pg_temp.check('la etiqueta es el nombre, o la parte local del correo',
  (select label from as_seen where id = pg_temp.u('e2')) = 'Ana Dos' and (select label from as_seen where id = pg_temp.u('e3')) = 'tres.as', (select string_agg(label, ',') from as_seen));
select pg_temp.check('nunca se devuelve un correo completo', not exists (select 1 from as_seen where label like '%@%'));
select pg_temp.check('un usuario de Málaga no puede listar un establecimiento de Granada (42501)',
  pg_temp.as_user('e4', format('select * from public.list_establishment_assignees(%L)', pg_temp.u('a1'))) = '42501');
select pg_temp.check('un establecimiento inexistente tampoco (42501)',
  pg_temp.as_user('e2', format('select * from public.list_establishment_assignees(%L)', pg_temp.u('a4'))) = '42501');
select pg_temp.check('anon no puede ejecutarla',
  not has_function_privilege('anon', 'public.list_establishment_assignees(uuid)', 'execute') and not has_function_privilege('anon', 'private.list_establishment_assignees(uuid)', 'execute'));
select pg_temp.check('el administrador puede listar', pg_temp.as_user('e1', format('select * from public.list_establishment_assignees(%L)', pg_temp.u('a1'))) = 'ok');

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from as_results;
  for r in select * from as_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'permit_assignees: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'permit_assignees: % comprobaciones correctas', total;
end $$;
rollback;
