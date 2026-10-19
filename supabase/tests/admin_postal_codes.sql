-- Pruebas de public.admin_set_postal_codes(): solo administradores, validación del código y de su provincia, y modo de solo rellenar vacíos.
-- Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/admin_postal_codes.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

-- Un único administrador activo (a1); los de otros datos se desactivan solo en esta transacción.
set local session_replication_role = replica;
update public.profiles set is_active = false where role = 'admin';
set local session_replication_role = origin;

select set_config('request.jwt.claim.sub', pg_temp.u('f1')::text, true);
insert into auth.users (id, raw_user_meta_data, email) values
  (pg_temp.u('f1'), '{}', 'admin@prueba.invalid'),
  (pg_temp.u('f2'), '{}', 'usuario@prueba.invalid');
update public.profiles set role = 'admin' where id = pg_temp.u('f1');

insert into public.provinces (id, code, name) values (pg_temp.u('b1'), '96', 'CP Prov 1'), (pg_temp.u('b2'), '97', 'CP Prov 2');
insert into public.municipalities (id, province_id, name, normalized_name) values
  (pg_temp.u('c1'), pg_temp.u('b1'), 'CP Mun 1', 'cp mun 1'), (pg_temp.u('c2'), pg_temp.u('b2'), 'CP Mun 2', 'cp mun 2');
insert into public.categories (id, code, name) values (pg_temp.u('d1'), 'cp_cat', 'CP Cat');
insert into public.user_provinces (user_id, province_id, assigned_by) values (pg_temp.u('f2'), pg_temp.u('b1'), pg_temp.u('f1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, postal_code, latitude, longitude, created_by, updated_by) values
  (pg_temp.u('e1'), pg_temp.u('b1'), pg_temp.u('c1'), pg_temp.u('d1'), 'CP Est 1', 'cp est 1', 'Calle 1', null, 37.1, -3.6, pg_temp.u('f1'), pg_temp.u('f1')),
  (pg_temp.u('e2'), pg_temp.u('b1'), pg_temp.u('c1'), pg_temp.u('d1'), 'CP Est 2', 'cp est 2', 'Calle 2', '', 37.2, -3.6, pg_temp.u('f1'), pg_temp.u('f1')),
  (pg_temp.u('e3'), pg_temp.u('b1'), pg_temp.u('c1'), pg_temp.u('d1'), 'CP Est 3', 'cp est 3', 'Calle 3', '96003', 37.3, -3.6, pg_temp.u('f1'), pg_temp.u('f1')),
  (pg_temp.u('e4'), pg_temp.u('b2'), pg_temp.u('c2'), pg_temp.u('d1'), 'CP Est 4', 'cp est 4', 'Calle 4', null, 36.8, -2.4, pg_temp.u('f1'), pg_temp.u('f1'));

create temp table cp_results (name text, ok boolean, detail text);
grant all on cp_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into cp_results values (p_name, coalesce(p_ok, false), p_detail) $$;

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

-- Ejecuta una consulta que devuelve texto (jsonb::text) bajo el rol y usuario indicados.
create function pg_temp.txt(p_role text, p_actor text, p_sql text) returns text language plpgsql as $$
declare r text;
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_actor)::text, true);
  execute 'set local role ' || p_role;
  execute p_sql into r;
  execute 'reset role';
  return r;
exception when others then
  execute 'reset role';
  return 'ERROR ' || sqlstate;
end $$;

-- Permisos y forma de la función.
select pg_temp.check('es SECURITY INVOKER con search_path vacío', (select not prosecdef and coalesce(proconfig, '{}') @> array['search_path=""'] from pg_proc where oid = 'public.admin_set_postal_codes(jsonb, boolean)'::regprocedure));
select pg_temp.check('anon sin EXECUTE; authenticated con EXECUTE',
  not has_function_privilege('anon', 'public.admin_set_postal_codes(jsonb, boolean)', 'execute') and has_function_privilege('authenticated', 'public.admin_set_postal_codes(jsonb, boolean)', 'execute'));
select pg_temp.check('anon recibe 42501', pg_temp.sqlstate_of('anon', 'f1', 'select public.admin_set_postal_codes(''[]''::jsonb)') = '42501');
select pg_temp.check('usuario normal recibe 42501', pg_temp.sqlstate_of('authenticated', 'f2', 'select public.admin_set_postal_codes(''[]''::jsonb)') = '42501');

-- Entradas no válidas.
select pg_temp.check('un objeto en lugar de un array da 22023', pg_temp.sqlstate_of('authenticated', 'f1', 'select public.admin_set_postal_codes(''{}''::jsonb)') = '22023');
select pg_temp.check('un array vacío no falla', pg_temp.txt('authenticated', 'f1', 'select public.admin_set_postal_codes(''[]''::jsonb)::text') = '{"omitidos": [], "actualizados": 0}');

-- Rellena vacíos: e1 (null) y e2 (cadena vacía) del mismo prefijo de provincia 96.
select pg_temp.check('rellena dos puntos sin código postal',
  (pg_temp.txt('authenticated', 'f1', 'select (public.admin_set_postal_codes(jsonb_build_array(jsonb_build_object(''id'', pg_temp.u(''e1''), ''postal_code'', ''96001''), jsonb_build_object(''id'', pg_temp.u(''e2''), ''postal_code'', ''96002''))) ->> ''actualizados'')')) = '2');
select pg_temp.check('e1 y e2 quedan con su código', (select postal_code from public.establishments where id = pg_temp.u('e1')) = '96001' and (select postal_code from public.establishments where id = pg_temp.u('e2')) = '96002');

-- Por defecto no pisa un código existente; con p_only_empty = false sí.
select pg_temp.check('no pisa un código existente por defecto: resultado', pg_temp.txt('authenticated', 'f1', 'select (public.admin_set_postal_codes(jsonb_build_array(jsonb_build_object(''id'', pg_temp.u(''e3''), ''postal_code'', ''96999''))) ->> ''actualizados'')') = '0');
select pg_temp.check('no pisa un código existente por defecto: valor guardado', (select postal_code from public.establishments where id = pg_temp.u('e3')) = '96003');
select pg_temp.check('con p_only_empty = false lo cambia: resultado', pg_temp.txt('authenticated', 'f1', 'select (public.admin_set_postal_codes(jsonb_build_array(jsonb_build_object(''id'', pg_temp.u(''e3''), ''postal_code'', ''96999'')), false) ->> ''actualizados'')') = '1');
select pg_temp.check('con p_only_empty = false lo cambia: valor guardado', (select postal_code from public.establishments where id = pg_temp.u('e3')) = '96999');

-- Validación del código y de la provincia.
select pg_temp.check('rechaza un código de otra provincia (e4 es de la 97): resultado', pg_temp.txt('authenticated', 'f1', 'select (public.admin_set_postal_codes(jsonb_build_array(jsonb_build_object(''id'', pg_temp.u(''e4''), ''postal_code'', ''96001''))) ->> ''actualizados'')') = '0');
select pg_temp.check('rechaza un código de otra provincia (e4 es de la 97): valor guardado', (select postal_code from public.establishments where id = pg_temp.u('e4')) is null);
select pg_temp.check('acepta el código de su provincia (e4 con 97001)',
  pg_temp.txt('authenticated', 'f1', 'select (public.admin_set_postal_codes(jsonb_build_array(jsonb_build_object(''id'', pg_temp.u(''e4''), ''postal_code'', ''97001''))) ->> ''actualizados'')') = '1');
select pg_temp.check('rechaza formatos no válidos y ids no válidos sin fallar',
  pg_temp.txt('authenticated', 'f1', 'select jsonb_array_length(public.admin_set_postal_codes(jsonb_build_array(jsonb_build_object(''id'', pg_temp.u(''e1''), ''postal_code'', ''9600''), jsonb_build_object(''id'', pg_temp.u(''e1''), ''postal_code'', ''abcde''), jsonb_build_object(''id'', ''no-es-un-uuid'', ''postal_code'', ''96001''), jsonb_build_object(''id'', pg_temp.u(''ff''), ''postal_code'', ''96001''))) -> ''omitidos'')') = '4');
select pg_temp.check('más de 2000 elementos da 22023',
  pg_temp.sqlstate_of('authenticated', 'f1', 'select public.admin_set_postal_codes((select jsonb_agg(jsonb_build_object(''id'', pg_temp.u(''e1''), ''postal_code'', ''96001'')) from generate_series(1, 2001)))') = '22023');

-- El resto de campos no cambia y queda rastro en la auditoría.
select pg_temp.check('solo cambia postal_code (la dirección sigue igual)', (select address from public.establishments where id = pg_temp.u('e1')) = 'Calle 1');
select pg_temp.check('las actualizaciones quedan en audit_log', (select count(*) from public.audit_log where table_name = 'establishments' and action = 'update' and record_id in (pg_temp.u('e1'), pg_temp.u('e2'), pg_temp.u('e3'), pg_temp.u('e4'))) >= 4);

select name, case when ok then 'OK' else 'FALLO' end as resultado, detail from cp_results order by name;
do $$
begin
  if exists (select 1 from cp_results where not ok) then
    raise exception 'admin_postal_codes: hay pruebas fallidas';
  end if;
end $$;
rollback;
