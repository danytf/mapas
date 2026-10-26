-- Pruebas de la regla «una concesión necesita al menos una fecha» (migración 20261026190927_permit_grants_require_date). Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/permit_grant_dates.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-00000000d7' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Fecha ' || s) from unnest(array['e1','e2']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('e1');
insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '93', 'Fecha Granada');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'Fecha Mun', 'fecha mun');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'fecha_cat', 'Fecha Cat');
insert into public.user_provinces (user_id, province_id, assigned_by) values (pg_temp.u('e2'), pg_temp.u('f1'), pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Fecha Gr', 'fecha gr', 'Calle 1', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1'));

create temp table fd_results (name text, ok boolean, detail text);
grant all on fd_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into fd_results values (p_name, coalesce(p_ok, false), p_detail) $$;
create function pg_temp.as_user(p_user text, p_sql text) returns text language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_user)::text, true);
  set local role authenticated;
  begin
    execute p_sql;
  exception when others then
    reset role;
    return sqlstate;
  end;
  reset role;
  return 'ok';
end $$;
create temp table fd_r (k text primary key, v text);
grant all on fd_r to public;

-- 1. Altas directas: sin ninguna fecha falla; con solo inicio, solo fin o ambas, funciona.
insert into fd_r values ('sin', pg_temp.as_user('e2', format($q$insert into public.permit_grants (id, establishment_id, created_by, updated_by) values (%L, %L, %L, %L)$q$, pg_temp.u('c1'), pg_temp.u('a1'), pg_temp.u('e2'), pg_temp.u('e2'))));
insert into fd_r values ('ini', pg_temp.as_user('e2', format($q$insert into public.permit_grants (id, establishment_id, valid_from, created_by, updated_by) values (%L, %L, '2026-11-02', %L, %L)$q$, pg_temp.u('c2'), pg_temp.u('a1'), pg_temp.u('e2'), pg_temp.u('e2'))));
insert into fd_r values ('fin', pg_temp.as_user('e2', format($q$insert into public.permit_grants (id, establishment_id, valid_until, created_by, updated_by) values (%L, %L, '2026-11-30', %L, %L)$q$, pg_temp.u('c3'), pg_temp.u('a1'), pg_temp.u('e2'), pg_temp.u('e2'))));
insert into fd_r values ('ambas', pg_temp.as_user('e2', format($q$insert into public.permit_grants (id, establishment_id, valid_from, valid_until, created_by, updated_by) values (%L, %L, '2026-11-02', '2026-11-30', %L, %L)$q$, pg_temp.u('c4'), pg_temp.u('a1'), pg_temp.u('e2'), pg_temp.u('e2'))));
select pg_temp.check('una concesión sin ninguna fecha se rechaza (23514)', (select v = '23514' from fd_r where k = 'sin') and (select count(*) = 0 from public.permit_grants where id = pg_temp.u('c1')));
select pg_temp.check('con solo la fecha de inicio (fin abierto) funciona', (select v = 'ok' from fd_r where k = 'ini'));
select pg_temp.check('con solo la fecha de fin funciona', (select v = 'ok' from fd_r where k = 'fin'));
select pg_temp.check('con las dos fechas funciona', (select v = 'ok' from fd_r where k = 'ambas'));
select pg_temp.check('la restricción existe y está validada', (select count(*) = 1 from pg_constraint where conrelid = 'public.permit_grants'::regclass and conname = 'permit_grants_has_date' and convalidated));

-- 2. Cambios: quitar la única fecha que tiene una concesión se rechaza; quitar una de dos, no.
insert into fd_r values ('quita_unica', pg_temp.as_user('e2', format($q$update public.permit_grants set valid_from = null where id = %L$q$, pg_temp.u('c2'))));
insert into fd_r values ('quita_una_de_dos', pg_temp.as_user('e2', format($q$update public.permit_grants set valid_until = null where id = %L$q$, pg_temp.u('c4'))));
select pg_temp.check('dejar una concesión sin su única fecha se rechaza', (select v = '23514' from fd_r where k = 'quita_unica') and (select valid_from is not null from public.permit_grants where id = pg_temp.u('c2')));
select pg_temp.check('quitar una de las dos fechas (dejar el fin abierto) sigue permitido', (select v = 'ok' from fd_r where k = 'quita_una_de_dos'));

-- 3. Concesión importada del modelo antiguo (legacy_ref): exenta, porque ese modelo admitía concesiones sin fechas y no se inventan.
insert into public.permit_grants (id, establishment_id, legacy_ref, created_by, updated_by) values (pg_temp.u('c5'), pg_temp.u('a1'), 'jsonb:prueba:con:1', pg_temp.u('e1'), pg_temp.u('e1'));
select pg_temp.check('una concesión importada del modelo antiguo (legacy_ref) sin fechas se admite', (select count(*) = 1 from public.permit_grants where id = pg_temp.u('c5')));

-- 4. Aprobar una solicitud: sin fechas en la solicitud ni en la aprobación falla con mensaje claro y la solicitud sigue pendiente (una sola transacción).
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'Sin fechas', 1)$q$, pg_temp.u('b1'), pg_temp.u('a1')));
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'Con fechas', 1, '2026-12-01', '2026-12-05')$q$, pg_temp.u('b2'), pg_temp.u('a1')));
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'Solo fin', 1, null, '2026-12-20')$q$, pg_temp.u('b3'), pg_temp.u('a1')));
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'Fecha al aprobar', 1)$q$, pg_temp.u('b4'), pg_temp.u('a1')));
select pg_temp.check('las solicitudes pueden crearse sin fechas (no cambia)', (select count(*) = 4 from public.permit_applications where id in (pg_temp.u('b1'), pg_temp.u('b2'), pg_temp.u('b3'), pg_temp.u('b4'))));

insert into fd_r values ('ap_sin', pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b1'))));
select pg_temp.check('aprobar sin fechas en la solicitud ni en la aprobación falla (23514)', (select v = '23514' from fd_r where k = 'ap_sin'));
select pg_temp.check('…y la solicitud sigue pendiente y no se crea concesión', (select status = 'pending' from public.permit_applications where id = pg_temp.u('b1')) and (select count(*) = 0 from public.permit_grants where application_id = pg_temp.u('b1')));
do $$
declare m text;
begin
  perform set_config('request.jwt.claim.sub', ('00000000-0000-4000-8000-00000000d7e2'), true);
  begin
    set local role authenticated;
    perform public.approve_permit_application('00000000-0000-4000-8000-00000000d7b1');
  exception when others then
    reset role;
    m := sqlerrm;
  end;
  reset role;
  insert into fd_results values ('el mensaje es claro', m = 'La concesión necesita al menos una fecha (inicio o fin)', coalesce(m, 'sin error'));
end $$;

insert into fd_r values ('ap_con', pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b2'))));
select pg_temp.check('aprobar usando las fechas de la solicitud funciona', (select v = 'ok' from fd_r where k = 'ap_con')
  and (select valid_from = '2026-12-01' and valid_until = '2026-12-05' from public.permit_grants where application_id = pg_temp.u('b2')));
insert into fd_r values ('ap_fin', pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b3'))));
select pg_temp.check('aprobar una solicitud que solo tiene fecha de fin funciona', (select v = 'ok' from fd_r where k = 'ap_fin')
  and (select valid_from is null and valid_until = '2026-12-20' from public.permit_grants where application_id = pg_temp.u('b3')));
insert into fd_r values ('ap_param', pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L, null, '2026-12-10')$q$, pg_temp.u('b4'))));
select pg_temp.check('aprobar dando la fecha en la propia aprobación funciona', (select v = 'ok' from fd_r where k = 'ap_param')
  and (select valid_from = '2026-12-10' and valid_until is null from public.permit_grants where application_id = pg_temp.u('b4')));
-- Idempotente: aprobar de nuevo una solicitud ya aprobada devuelve su concesión sin error.
insert into fd_r values ('ap_otra_vez', pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b2'))));
select pg_temp.check('aprobar de nuevo una solicitud ya aprobada sigue siendo idempotente', (select v = 'ok' from fd_r where k = 'ap_otra_vez') and (select count(*) = 1 from public.permit_grants where application_id = pg_temp.u('b2')));

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from fd_results;
  for r in select * from fd_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'permit_grant_dates: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'permit_grant_dates: % comprobaciones correctas', total;
end $$;
rollback;
