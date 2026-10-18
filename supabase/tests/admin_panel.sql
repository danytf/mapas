-- Pruebas del panel de administración: admin_list_users() y protección del último administrador.
-- Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/admin_panel.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

-- Para que haya un único administrador activo en esta prueba, se desactivan los de otros datos
-- (la transacción se deshace). Se hace antes de que exista la protección de último administrador activa
-- sobre los nuevos: se usa session_replication_role para saltar el trigger solo en esta preparación.
set local session_replication_role = replica;
update public.profiles set is_active = false where role = 'admin';
set local session_replication_role = origin;

select set_config('request.jwt.claim.sub', pg_temp.u('c1')::text, true);
insert into auth.users (id, raw_user_meta_data, email, last_sign_in_at) values
  (pg_temp.u('c1'), '{}', 'admin1@prueba.invalid', now()),
  (pg_temp.u('c2'), '{}', 'admin2@prueba.invalid', null),
  (pg_temp.u('c3'), '{}', 'usuario@prueba.invalid', null),
  (pg_temp.u('c4'), '{}', 'inactivo@prueba.invalid', null);
update public.profiles set role = 'admin' where id in (pg_temp.u('c1'), pg_temp.u('c2'));
update public.profiles set is_active = false where id = pg_temp.u('c4');
update public.profiles set role = 'admin' where id = pg_temp.u('c4');
insert into public.provinces (id, code, name) values (pg_temp.u('d1'), '94', 'Adm P1');
insert into public.user_provinces (user_id, province_id, assigned_by) values (pg_temp.u('c3'), pg_temp.u('d1'), pg_temp.u('c1'));

create temp table adm_results (name text, ok boolean, detail text);
grant all on adm_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into adm_results values (p_name, coalesce(p_ok, false), p_detail) $$;

-- Devuelve el SQLSTATE con el que falla la sentencia bajo el rol y usuario indicados ('' si no falla).
create function pg_temp.sqlstate_of(p_role text, p_actor text, p_sql text) returns text language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', coalesce(pg_temp.u(p_actor)::text, ''), true);
  execute 'set local role ' || p_role;
  execute p_sql;
  execute 'reset role';
  return '';
exception when others then
  execute 'reset role';
  return sqlstate;
end $$;

create function pg_temp.cnt(p_role text, p_actor text, p_sql text) returns bigint language plpgsql as $$
declare n bigint;
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_actor)::text, true);
  execute 'set local role ' || p_role;
  execute p_sql into n;
  execute 'reset role';
  return n;
exception when others then
  execute 'reset role';
  return -1;
end $$;

-- admin_list_users: permisos de ejecución y autorización interna.
select pg_temp.check('anon no puede ejecutar admin_list_users', pg_temp.sqlstate_of('anon', 'c1', 'select * from public.admin_list_users()') = '42501');
select pg_temp.check('usuario normal recibe 42501', pg_temp.sqlstate_of('authenticated', 'c3', 'select * from public.admin_list_users()') = '42501');
select pg_temp.check('administrador inactivo recibe 42501', pg_temp.sqlstate_of('authenticated', 'c4', 'select * from public.admin_list_users()') = '42501');
select pg_temp.check('administrador activo lee los usuarios', pg_temp.cnt('authenticated', 'c1', 'select count(*) from public.admin_list_users() where id in (pg_temp.u(''c1''), pg_temp.u(''c2''), pg_temp.u(''c3''), pg_temp.u(''c4''))') = 4,
  pg_temp.cnt('authenticated', 'c1', 'select count(*) from public.admin_list_users() where id in (pg_temp.u(''c1''), pg_temp.u(''c2''), pg_temp.u(''c3''), pg_temp.u(''c4''))')::text);
select pg_temp.check('devuelve el correo', pg_temp.cnt('authenticated', 'c1', 'select count(*) from public.admin_list_users() where email = ''usuario@prueba.invalid''') = 1);
select pg_temp.check('devuelve las provincias asignadas', pg_temp.cnt('authenticated', 'c1', 'select cardinality(province_ids) from public.admin_list_users() where id = pg_temp.u(''c3'')') = 1);
select pg_temp.check('la lógica privilegiada está en private (SECURITY DEFINER, search_path vacío)', (select prosecdef and coalesce(proconfig, '{}') @> array['search_path=""'] from pg_proc where oid = 'private.admin_list_users()'::regprocedure));
select pg_temp.check('la función pública es un envoltorio SECURITY INVOKER', (select not prosecdef from pg_proc where oid = 'public.admin_list_users()'::regprocedure));
select pg_temp.check('anon sin EXECUTE en private.admin_list_users', not has_function_privilege('anon', 'private.admin_list_users()', 'execute'));
select pg_temp.check('anon y PUBLIC sin EXECUTE; authenticated con EXECUTE',
  not has_function_privilege('anon', 'public.admin_list_users()', 'execute') and has_function_privilege('authenticated', 'public.admin_list_users()', 'execute'));

-- El administrador gestiona perfiles y provincias con las políticas existentes.
select pg_temp.check('admin cambia el nombre visible de otro: sin error', pg_temp.sqlstate_of('authenticated', 'c1', 'update public.profiles set display_name = ''Nombre'' where id = pg_temp.u(''c3'')') = '');
select pg_temp.check('admin cambia el nombre visible de otro: valor guardado', (select display_name from public.profiles where id = pg_temp.u('c3')) = 'Nombre');
select pg_temp.check('usuario normal no cambia roles (0 filas afectadas)', pg_temp.cnt('authenticated', 'c3', 'with u as (update public.profiles set role = ''admin'' where id = pg_temp.u(''c3'') returning 1) select count(*) from u') = 0);
select pg_temp.check('admin asigna una provincia', pg_temp.sqlstate_of('authenticated', 'c1', 'insert into public.user_provinces (user_id, province_id, assigned_by) values (pg_temp.u(''c2''), pg_temp.u(''d1''), pg_temp.u(''c1''))') = '');
select pg_temp.check('admin quita una provincia', pg_temp.cnt('authenticated', 'c1', 'with d as (delete from public.user_provinces where user_id = pg_temp.u(''c2'') and province_id = pg_temp.u(''d1'') returning 1) select count(*) from d') = 1);
select pg_temp.check('admin desactiva una provincia', pg_temp.cnt('authenticated', 'c1', 'with u as (update public.provinces set is_active = false where id = pg_temp.u(''d1'') returning 1) select count(*) from u') = 1);
select pg_temp.check('usuario normal no desactiva provincias', pg_temp.cnt('authenticated', 'c3', 'with u as (update public.provinces set is_active = true where id = pg_temp.u(''d1'') returning 1) select count(*) from u') = 0);

-- Protección del último administrador.
select pg_temp.check('con dos administradores se puede degradar a uno', pg_temp.sqlstate_of('authenticated', 'c1', 'update public.profiles set role = ''user'' where id = pg_temp.u(''c2'')') = '');
select pg_temp.check('el último administrador no puede degradarse', pg_temp.sqlstate_of('authenticated', 'c1', 'update public.profiles set role = ''user'' where id = pg_temp.u(''c1'')') = '23514');
select pg_temp.check('el último administrador no puede desactivarse', pg_temp.sqlstate_of('authenticated', 'c1', 'update public.profiles set is_active = false where id = pg_temp.u(''c1'')') = '23514');
select pg_temp.check('el último administrador no puede borrarse', pg_temp.sqlstate_of('postgres', 'c1', 'delete from public.profiles where id = pg_temp.u(''c1'')') = '23514');
select pg_temp.check('un usuario normal sí puede desactivarse (por el administrador)', pg_temp.sqlstate_of('authenticated', 'c1', 'update public.profiles set is_active = false where id = pg_temp.u(''c3'')') = '');
select pg_temp.check('reactivar y volver a hacer administrador a c2', pg_temp.sqlstate_of('authenticated', 'c1', 'update public.profiles set role = ''admin'' where id = pg_temp.u(''c2'')') = '');
select pg_temp.check('de nuevo con dos, c1 puede degradarse', pg_temp.sqlstate_of('authenticated', 'c1', 'update public.profiles set role = ''user'' where id = pg_temp.u(''c1'')') = '');

-- Las funciones de disparador no son ejecutables por la API.
select pg_temp.check('protect_last_admin sin EXECUTE para anon ni authenticated',
  not has_function_privilege('anon', 'public.protect_last_admin()', 'execute') and not has_function_privilege('authenticated', 'public.protect_last_admin()', 'execute'));

select name, case when ok then 'OK' else 'FALLO' end as resultado, detail from adm_results order by name;
do $$
begin
  if exists (select 1 from adm_results where not ok) then
    raise exception 'admin_panel: hay pruebas fallidas';
  end if;
end $$;
rollback;
