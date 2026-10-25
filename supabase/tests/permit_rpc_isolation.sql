-- Aislamiento de las funciones RPC de expedientes (approve/resolve/cancel/create) en ambos sentidos entre provincias y con usuarios sin acceso
-- (sin provincia asignada y desactivado). Cada intento denegado debe devolver el error esperado y dejar el expediente exactamente como estaba;
-- los controles positivos demuestran que la prueba no es vacía. Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/permit_rpc_isolation.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-00000000d4' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('a0')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Iso ' || s) from unnest(array['a0','a1','a2','a3','a4']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('a0');
-- a1: Granada; a2: Málaga; a3: sin ninguna provincia; a4: Granada pero desactivado; a0: administrador.
update public.profiles set is_active = false where id = pg_temp.u('a4');

insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '91', 'Iso Granada'), (pg_temp.u('f2'), '90', 'Iso Malaga');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'Iso Mun G', 'iso mun g'), (pg_temp.u('f4'), pg_temp.u('f2'), 'Iso Mun M', 'iso mun m');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'iso_cat', 'Iso Cat');
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('a0')), (pg_temp.u('a2'), pg_temp.u('f2'), pg_temp.u('a0')), (pg_temp.u('a4'), pg_temp.u('f1'), pg_temp.u('a0'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('e1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Iso Gr', 'iso gr', 'Calle 1', 37.1, -3.6, pg_temp.u('a0'), pg_temp.u('a0')),
       (pg_temp.u('e2'), pg_temp.u('f2'), pg_temp.u('f4'), pg_temp.u('f5'), 'Iso Ma', 'iso ma', 'Calle 2', 36.7, -4.4, pg_temp.u('a0'), pg_temp.u('a0'));

create temp table iso_results (name text, ok boolean, detail text);
grant all on iso_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into iso_results values (p_name, coalesce(p_ok, false), p_detail) $$;
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

-- Expedientes: kg (Granada, pendiente con seguimiento), km (Málaga, pendiente con seguimiento), kga (Granada aprobada con concesión), kma (Málaga aprobada con concesión).
select pg_temp.as_user('a1', format($q$select public.create_permit_application(%L, %L, 'G', 1, '2026-11-02', '2026-11-03', null, null, null, '2026-10-30')$q$, pg_temp.u('b1'), pg_temp.u('e1')));
select pg_temp.as_user('a1', format($q$select public.create_permit_application(%L, %L, 'GA', 1, '2026-11-02', '2026-11-03')$q$, pg_temp.u('b2'), pg_temp.u('e1')));
select pg_temp.as_user('a1', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b2')));
select pg_temp.as_user('a2', format($q$select public.create_permit_application(%L, %L, 'M', 1, '2026-11-02', '2026-11-03', null, null, null, '2026-10-30')$q$, pg_temp.u('b3'), pg_temp.u('e2')));
select pg_temp.as_user('a2', format($q$select public.create_permit_application(%L, %L, 'MA', 1, '2026-11-02', '2026-11-03')$q$, pg_temp.u('b4'), pg_temp.u('e2')));
select pg_temp.as_user('a2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b4')));

create function pg_temp.estado() returns text language sql as $$
  select md5(coalesce((select string_agg(id::text || status::text || updated_at::text, '|' order by id) from public.permit_applications where id in (pg_temp.u('b1'), pg_temp.u('b2'), pg_temp.u('b3'), pg_temp.u('b4'))), '')
    || coalesce((select string_agg(id::text || status::text || updated_at::text, '|' order by id) from public.permit_grants where application_id in (pg_temp.u('b2'), pg_temp.u('b4'))), '')
    || coalesce((select string_agg(id::text || coalesce(completed_at::text, '') || updated_at::text, '|' order by id) from public.followups where application_id in (pg_temp.u('b1'), pg_temp.u('b3'))), '')) $$;
create temp table iso_ref (v text);
grant all on iso_ref to public;
insert into iso_ref values (pg_temp.estado());
select pg_temp.check('hay 4 expedientes, 2 concesiones y 2 seguimientos de partida', (select count(*) = 4 from public.permit_applications where id in (pg_temp.u('b1'), pg_temp.u('b2'), pg_temp.u('b3'), pg_temp.u('b4')))
  and (select count(*) = 2 from public.permit_grants where application_id in (pg_temp.u('b2'), pg_temp.u('b4'))) and (select count(*) = 2 from public.followups where application_id in (pg_temp.u('b1'), pg_temp.u('b3'))));

-- Intentos denegados: approve/resolve/cancel no revelan que el registro existe (P0002); crear viola la política de inserción (42501).
create function pg_temp.sql_de(p_funcion text, p_objetivo uuid) returns text language sql as $$
  select case p_funcion
    when 'approve' then format('select public.approve_permit_application(%L)', p_objetivo)
    when 'resolve' then format('select public.resolve_permit_application(%L, ''denied'', ''x'')', p_objetivo)
    when 'cancel'  then format('select public.cancel_permit_grant(%L)', (select id from public.permit_grants where application_id = p_objetivo))
    when 'create'  then format('select public.create_permit_application(%L, %L, ''INTRUSA'')', gen_random_uuid(), p_objetivo)
  end $$;
create temp table iso_neg (actor text, funcion text, esperado text, obtenido text);
grant all on iso_neg to public;
insert into iso_neg
select t.actor, t.funcion, t.esperado, pg_temp.as_user(t.actor, pg_temp.sql_de(t.funcion, t.objetivo))
from (values
  ('a2', 'approve', pg_temp.u('b1'), 'P0002'), ('a2', 'resolve', pg_temp.u('b1'), 'P0002'), ('a2', 'cancel', pg_temp.u('b2'), 'P0002'), ('a2', 'create', pg_temp.u('e1'), '42501'),
  ('a1', 'approve', pg_temp.u('b3'), 'P0002'), ('a1', 'resolve', pg_temp.u('b3'), 'P0002'), ('a1', 'cancel', pg_temp.u('b4'), 'P0002'), ('a1', 'create', pg_temp.u('e2'), '42501'),
  ('a3', 'approve', pg_temp.u('b1'), 'P0002'), ('a3', 'resolve', pg_temp.u('b1'), 'P0002'), ('a3', 'cancel', pg_temp.u('b2'), 'P0002'), ('a3', 'create', pg_temp.u('e1'), '42501'),
  ('a3', 'approve', pg_temp.u('b3'), 'P0002'), ('a3', 'resolve', pg_temp.u('b3'), 'P0002'), ('a3', 'cancel', pg_temp.u('b4'), 'P0002'), ('a3', 'create', pg_temp.u('e2'), '42501'),
  ('a4', 'approve', pg_temp.u('b1'), 'P0002'), ('a4', 'resolve', pg_temp.u('b1'), 'P0002'), ('a4', 'cancel', pg_temp.u('b2'), 'P0002'), ('a4', 'create', pg_temp.u('e1'), '42501')
) t(actor, funcion, objetivo, esperado);
select pg_temp.check('20 intentos denegados (Málaga→Granada, Granada→Málaga, sin provincia, desactivado)', (select count(*) = 20 from iso_neg));
select pg_temp.check('todos fallan con el código esperado y sin revelar el registro',
  (select count(*) = 0 from iso_neg where obtenido is distinct from esperado), (select string_agg(actor || ':' || funcion || '=' || obtenido, ', ') from iso_neg where obtenido is distinct from esperado));
select pg_temp.check('ningún intento denegado cambió nada (solicitudes, concesiones ni seguimientos)', pg_temp.estado() = (select v from iso_ref));
select pg_temp.check('ningún intento creó una solicitud', (select count(*) = 0 from public.permit_applications where organization = 'INTRUSA'));

-- Controles positivos: la prueba no es vacía. Quien tiene acceso a su provincia sí puede, y la administración en ambas.
select pg_temp.check('g1 resuelve una solicitud de Granada', pg_temp.as_user('a1', format($q$select public.resolve_permit_application(%L, 'denied', 'ok')$q$, pg_temp.u('b1'))) = 'ok');
select pg_temp.check('g1 cancela una concesión de Granada', pg_temp.as_user('a1', format($q$select public.cancel_permit_grant(%L)$q$, (select id from public.permit_grants where application_id = pg_temp.u('b2')))) = 'ok');
select pg_temp.check('m1 aprueba una solicitud de Málaga', pg_temp.as_user('a2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b3'))) = 'ok');
select pg_temp.check('m1 cancela una concesión de Málaga', pg_temp.as_user('a2', format($q$select public.cancel_permit_grant(%L)$q$, (select id from public.permit_grants where application_id = pg_temp.u('b4')))) = 'ok');
select pg_temp.check('la administración crea en ambas provincias',
  pg_temp.as_user('a0', format($q$select public.create_permit_application(%L, %L, 'ADM')$q$, pg_temp.u('c1'), pg_temp.u('e1'))) = 'ok'
  and pg_temp.as_user('a0', format($q$select public.create_permit_application(%L, %L, 'ADM')$q$, pg_temp.u('c2'), pg_temp.u('e2'))) = 'ok');
select pg_temp.check('las cuatro funciones son SECURITY INVOKER y anon no puede ejecutarlas',
  (select count(*) = 4 and bool_and(not prosecdef) and bool_and(not has_function_privilege('anon', oid, 'execute')) from pg_proc
    where pronamespace = 'public'::regnamespace and proname in ('approve_permit_application', 'resolve_permit_application', 'cancel_permit_grant', 'create_permit_application')));

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from iso_results;
  for r in select * from iso_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'permit_rpc_isolation: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'permit_rpc_isolation: % comprobaciones correctas', total;
end $$;
rollback;
