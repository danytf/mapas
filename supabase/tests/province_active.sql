-- Pruebas de la provincia activa en la autorización (H-22) y de usuarios con varias provincias.
-- Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/province_active.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('1a')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Act ' || s) from unnest(array['1a','1b','1c','1d']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('1a');

-- p1 y p2 activas. 1b tiene las dos provincias; 1c solo p2; 1d ninguna.
insert into public.provinces (id, code, name) values (pg_temp.u('2a'), '92', 'Act P1'), (pg_temp.u('2b'), '93', 'Act P2');
insert into public.municipalities (id, province_id, name, normalized_name) values
  (pg_temp.u('3a'), pg_temp.u('2a'), 'Act Mun 1', 'act mun 1'), (pg_temp.u('3b'), pg_temp.u('2b'), 'Act Mun 2', 'act mun 2');
insert into public.categories (id, code, name) values (pg_temp.u('4a'), 'act_cat', 'Act Cat');
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('1b'), pg_temp.u('2a'), pg_temp.u('1a')), (pg_temp.u('1b'), pg_temp.u('2b'), pg_temp.u('1a')),
  (pg_temp.u('1c'), pg_temp.u('2b'), pg_temp.u('1a'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by) values
  (pg_temp.u('5a'), pg_temp.u('2a'), pg_temp.u('3a'), pg_temp.u('4a'), 'Act Est 1', 'act est 1', 'Calle 1', 37.1, -3.6, pg_temp.u('1a'), pg_temp.u('1a')),
  (pg_temp.u('5b'), pg_temp.u('2b'), pg_temp.u('3b'), pg_temp.u('4a'), 'Act Est 2', 'act est 2', 'Calle 2', 36.8, -2.4, pg_temp.u('1a'), pg_temp.u('1a'));
insert into public.permit_applications (id, establishment_id, created_by, updated_by) values
  (pg_temp.u('6a'), pg_temp.u('5a'), pg_temp.u('1a'), pg_temp.u('1a')), (pg_temp.u('6b'), pg_temp.u('5b'), pg_temp.u('1a'), pg_temp.u('1a'));
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by) values
  (pg_temp.u('5a'), pg_temp.u('2a'), '{"notas":"p1"}', pg_temp.u('1a')), (pg_temp.u('5b'), pg_temp.u('2b'), '{"notas":"p2"}', pg_temp.u('1a'));

create temp table act_results (name text, ok boolean, detail text);
grant all on act_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into act_results values (p_name, coalesce(p_ok, false), p_detail) $$;

-- Ejecuta una consulta que devuelve un contador bajo el rol de la API y el usuario indicado.
create function pg_temp.cnt(p_actor text, p_sql text) returns bigint language plpgsql as $$
declare n bigint;
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_actor)::text, true);
  execute 'set local role authenticated';
  execute p_sql into n;
  execute 'reset role';
  return n;
exception when others then
  execute 'reset role';
  return -1;
end $$;
-- Ejecuta una sentencia y dice si la base la rechaza por falta de permiso (RLS, 42501).
create function pg_temp.denied(p_actor text, p_sql text) returns boolean language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_actor)::text, true);
  execute 'set local role authenticated';
  execute p_sql;
  execute 'reset role';
  return false;
exception when insufficient_privilege then
  execute 'reset role';
  return true;
when others then
  execute 'reset role';
  return false;
end $$;

-- Contadores sobre los datos de esta prueba.
create function pg_temp.est(p_actor text) returns bigint language sql as $$
  select pg_temp.cnt(p_actor, 'select count(*) from public.establishments where id in (pg_temp.u(''5a''), pg_temp.u(''5b''))') $$;
create function pg_temp.app(p_actor text) returns bigint language sql as $$
  select pg_temp.cnt(p_actor, 'select count(*) from public.permit_applications where id in (pg_temp.u(''6a''), pg_temp.u(''6b''))') $$;
create function pg_temp.st(p_actor text) returns bigint language sql as $$
  select pg_temp.cnt(p_actor, 'select count(*) from public.establishment_app_state where establishment_id in (pg_temp.u(''5a''), pg_temp.u(''5b''))') $$;
create function pg_temp.upd_est(p_actor text, p_est text) returns bigint language sql as $$
  select pg_temp.cnt(p_actor, format('with u as (update public.establishments set address = ''Calle nueva'', updated_by = pg_temp.u(%L) where id = pg_temp.u(%L) returning 1) select count(*) from u', p_actor, p_est)) $$;
create function pg_temp.upd_st(p_actor text, p_est text) returns bigint language sql as $$
  select pg_temp.cnt(p_actor, format('with u as (update public.establishment_app_state set state = ''{"notas":"editado"}'', updated_by = pg_temp.u(%L) where establishment_id = pg_temp.u(%L) returning 1) select count(*) from u', p_actor, p_est)) $$;

-- Estructura: las tres políticas de estado compartido siguen existiendo con las mismas operaciones.
select pg_temp.check('establishment_app_state conserva sus 3 políticas',
  (select count(*) = 3 from pg_policies where schemaname = 'public' and tablename = 'establishment_app_state'));
select pg_temp.check('las políticas de estado usan has_province_access',
  (select bool_and(coalesce(qual, '') ilike '%has_province_access%' or coalesce(with_check, '') ilike '%has_province_access%')
     from pg_policies where schemaname = 'public' and tablename = 'establishment_app_state'));
select pg_temp.check('has_province_access sigue sin EXECUTE para anon',
  not has_function_privilege('anon', 'public.has_province_access(uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'private.has_province_access(uuid)', 'EXECUTE'));

-- Fase A: las dos provincias activas.
select pg_temp.check('A: usuario con 2 provincias ve los 2 puntos', pg_temp.est('1b') = 2, pg_temp.est('1b')::text);
select pg_temp.check('A: usuario con 2 provincias ve 2 solicitudes y 2 estados', pg_temp.app('1b') = 2 and pg_temp.st('1b') = 2);
select pg_temp.check('A: usuario de solo p2 ve 1 punto', pg_temp.est('1c') = 1, pg_temp.est('1c')::text);
select pg_temp.check('A: usuario sin provincias ve 0', pg_temp.est('1d') = 0 and pg_temp.st('1d') = 0);
select pg_temp.check('A: usuario con 2 provincias modifica puntos de ambas', pg_temp.upd_est('1b', '5a') = 1 and pg_temp.upd_est('1b', '5b') = 1);
select pg_temp.check('A: usuario con 2 provincias modifica el estado de ambas', pg_temp.upd_st('1b', '5a') = 1 and pg_temp.upd_st('1b', '5b') = 1);
select pg_temp.check('A: el administrador ve los 2 puntos', pg_temp.est('1a') = 2);

-- Fase B: se desactiva p2.
update public.provinces set is_active = false where id = pg_temp.u('2b');
select pg_temp.check('B: usuario con 2 provincias solo ve el punto de la activa', pg_temp.est('1b') = 1, pg_temp.est('1b')::text);
select pg_temp.check('B: solo ve la solicitud y el estado de la activa', pg_temp.app('1b') = 1 and pg_temp.st('1b') = 1, pg_temp.app('1b')::text || '/' || pg_temp.st('1b')::text);
select pg_temp.check('B: usuario de solo p2 ve 0 puntos, 0 solicitudes y 0 estados', pg_temp.est('1c') = 0 and pg_temp.app('1c') = 0 and pg_temp.st('1c') = 0);
select pg_temp.check('B: no puede modificar el punto de la provincia inactiva', pg_temp.upd_est('1b', '5b') = 0 and pg_temp.upd_est('1c', '5b') = 0);
select pg_temp.check('B: sigue pudiendo modificar el de la activa', pg_temp.upd_est('1b', '5a') = 1);
select pg_temp.check('B: no puede modificar el estado de la provincia inactiva', pg_temp.upd_st('1b', '5b') = 0 and pg_temp.upd_st('1c', '5b') = 0);
select pg_temp.check('B: no puede crear estado en la provincia inactiva',
  pg_temp.denied('1c', 'insert into public.establishment_app_state (establishment_id, province_id, state, updated_by) values (pg_temp.u(''5b''), pg_temp.u(''2b''), ''{}'', pg_temp.u(''1c''))'));
select pg_temp.check('B: no puede crear una solicitud en la provincia inactiva',
  pg_temp.denied('1c', 'insert into public.permit_applications (establishment_id, created_by, updated_by) values (pg_temp.u(''5b''), pg_temp.u(''1c''), pg_temp.u(''1c''))'));
select pg_temp.check('B: el administrador sigue viendo y modificando la inactiva',
  pg_temp.est('1a') = 2 and pg_temp.upd_est('1a', '5b') = 1 and pg_temp.upd_st('1a', '5b') = 1);
select pg_temp.check('B: el usuario sigue viendo su propia asignación (user_provinces)',
  pg_temp.cnt('1c', 'select count(*) from public.user_provinces where user_id = pg_temp.u(''1c'')') = 1);

-- Fase C: se reactiva p2.
update public.provinces set is_active = true where id = pg_temp.u('2b');
select pg_temp.check('C: al reactivar, el usuario con 2 provincias vuelve a ver los 2 puntos', pg_temp.est('1b') = 2, pg_temp.est('1b')::text);
select pg_temp.check('C: al reactivar, el de solo p2 vuelve a ver su punto y su estado', pg_temp.est('1c') = 1 and pg_temp.st('1c') = 1);
select pg_temp.check('C: al reactivar, vuelve a poder modificar', pg_temp.upd_est('1c', '5b') = 1 and pg_temp.upd_st('1c', '5b') = 1);

do $$
declare bad int; r record;
begin
  select count(*) into bad from act_results where not ok;
  for r in select * from act_results order by (not ok) desc, name loop
    raise notice '% | %', case when r.ok then 'OK ' else 'FALLO' end, r.name || case when r.detail <> '' then ' [' || r.detail || ']' else '' end;
  end loop;
  if bad > 0 or (select count(*) from act_results) < 23 then
    raise exception 'province_active: % fallos de % comprobaciones', bad, (select count(*) from act_results);
  end if;
  raise notice 'province_active: % comprobaciones correctas', (select count(*) from act_results);
end $$;

rollback;
