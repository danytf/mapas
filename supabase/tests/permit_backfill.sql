-- Pruebas del volcado del JSON a las tablas relacionales y de la reconciliación. Una transacción que termina en ROLLBACK.
-- Ejecución (desde la raíz del repositorio): psql -v ON_ERROR_STOP=1 -f supabase/tests/permit_backfill.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data) values (pg_temp.u('e1'), '{"full_name":"BF admin"}');
update public.profiles set role = 'admin' where id = pg_temp.u('e1');
insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '89', 'BF Granada');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'BF Mun', 'bf mun');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'bf_cat', 'BF Cat');
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
select pg_temp.u(s), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'BF ' || s, 'bf ' || s, 'Calle', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1')
from unnest(array['a1','a2','a3','a4']) s;

-- Formas reales: solicitud sin ID con seguimiento; punto con concesiones antiguas (sin id) y una duplicada exacta; solicitud aprobada con enlace;
-- formato antiguo de una sola solicitud; punto con seguimiento antiguo y sin solicitudes.
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by) values
 (pg_temp.u('a1'), pg_temp.u('f1'), '{"estado":"solicitado","fecha":"2026-10-22","seguimiento":"2026-10-23","solicitudes":[{"seg":"2026-10-23","desde":"2026-11-02","fecha":"2026-10-22","captadores":4}]}', pg_temp.u('e1')),
 (pg_temp.u('a2'), pg_temp.u('f1'), '{"estado":"concedido","historial":[{"ong":"AECC","desde":"2026-10-01","hasta":"2026-10-31","captadores":2},{"ong":"AECC","desde":"2026-10-01","hasta":"2026-10-31","captadores":2},{"ong":"WWF","desde":"2026-09-01","hasta":"2026-09-30","captadores":1,"cancelada":true}]}', pg_temp.u('e1')),
 (pg_temp.u('a3'), pg_temp.u('f1'), '{"solicitudes":[{"id":"sol-aaaa-0001","desde":"2026-10-01","hasta":"2026-10-31","ong":"Cruz Roja","captadores":3,"fecha":"2026-10-01","res":"aprobada","resFecha":"2026-10-05","conc":"con-aaaa-0001"},{"id":"sol-aaaa-0002","desde":"2026-11-01","ong":"AECC","captadores":1,"fecha":"2026-10-02","res":"denegada","resFecha":"2026-10-06","motivo":"Sin cupo"}],"historial":[{"id":"con-aaaa-0001","sol":"sol-aaaa-0001","desde":"2026-10-01","hasta":"2026-10-31","ong":"Cruz Roja","captadores":3,"alta":"2026-10-05"}]}', pg_temp.u('e1')),
 (pg_temp.u('a4'), pg_temp.u('f1'), '{"solicitud":{"desde":"2026-12-01","hasta":"2026-12-05","ong":"FJC","captadores":2},"seguimiento":"2026-10-30"}', pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a5'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'BF a5', 'bf a5', 'Calle', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1'));
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
values (pg_temp.u('a5'), pg_temp.u('f1'), '{"seguimiento":"2026-10-28","estado":"sin"}', pg_temp.u('e1'));

create temp table bf_results (name text, ok boolean, detail text);
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into bf_results values (p_name, coalesce(p_ok, false), p_detail) $$;

select set_config('request.jwt.claim.sub', '', true);
\ir ../tools/backfill_permits_from_state.sql
create temp view bf_e as select id from public.establishments where name like 'BF %';
create temp view bf_a as select * from public.permit_applications where establishment_id in (select id from bf_e);
create temp view bf_g as select * from public.permit_grants where establishment_id in (select id from bf_e);
create temp view bf_f as select * from public.followups where establishment_id in (select id from bf_e);

select pg_temp.check('solicitudes volcadas: 1 + 0 + 2 + 1',
  (select count(*) from bf_a where legacy_ref like 'jsonb:%') = 4, (select count(*)::text from bf_a));
select pg_temp.check('concesiones volcadas: 3 + 1 (la duplicada exacta se conserva)', (select count(*) from bf_g where legacy_ref like 'jsonb:%') = 4, (select count(*)::text from bf_g));
select pg_temp.check('estados de solicitud mapeados',
  (select string_agg(status, ',' order by status) from bf_a) = 'approved,denied,pending,pending');
select pg_temp.check('la solicitud denegada guarda motivo y fecha de decisión',
  exists (select 1 from bf_a where status = 'denied' and resolution_reason = 'Sin cupo' and resolved_at = timestamptz '2026-10-06 00:00 Europe/Madrid'));
select pg_temp.check('la solicitud sin fecha de alta usa la de creación de la fila y la que la tiene, la suya',
  exists (select 1 from bf_a where requested_from = '2026-12-01' and requested_at = current_date)
  and exists (select 1 from bf_a where requested_from = '2026-11-02' and requested_at = '2026-10-22'));
select pg_temp.check('la concesión enlazada por «sol» apunta a su solicitud aprobada',
  (select a.status = 'approved' and a.legacy_ref = 'jsonb:' || a.establishment_id || ':sol:sol-aaaa-0001'
     from bf_g g join bf_a a on a.id = g.application_id where g.organization = 'Cruz Roja'));
select pg_temp.check('las concesiones antiguas sin vínculo demostrable quedan sin solicitud (no se inventa)',
  (select count(*) from bf_g where application_id is null) = 3);
select pg_temp.check('la concesión cancelada conserva su estado y cancelled_at',
  exists (select 1 from bf_g where status = 'cancelled' and organization = 'WWF' and cancelled_at is not null));
select pg_temp.check('seguimientos: uno por solicitud pendiente con fecha, y el antiguo del punto sin solicitudes',
  (select count(*) from bf_f) = 3 and exists (select 1 from bf_f where application_id is null and due_on = '2026-10-28')
  and exists (select 1 from bf_f where application_id is not null and due_on = '2026-10-23'));
select pg_temp.check('el JSON original no se ha tocado',
  (select state->'solicitudes'->0->>'seg' from public.establishment_app_state where establishment_id = pg_temp.u('a1')) = '2026-10-23');

-- Segunda ejecución: ninguna fila nueva (idempotente).
create temp table bf_before as select (select count(*) from bf_a) a, (select count(*) from bf_g) g, (select count(*) from bf_f) f;
\ir ../tools/backfill_permits_from_state.sql
select pg_temp.check('segunda ejecución: 0 filas nuevas',
  (select a = (select count(*) from bf_a) and g = (select count(*) from bf_g) and f = (select count(*) from bf_f) from bf_before));

-- La aplicación pone un id a una entrada que ya se había volcado sin id: no se duplica.
update public.establishment_app_state set state = jsonb_set(state, '{solicitudes,0,id}', '"sol-bbbb-0001"') where establishment_id = pg_temp.u('a1');
\ir ../tools/backfill_permits_from_state.sql
select pg_temp.check('una entrada que gana un id entre dos volcados no se duplica', (select count(*) from bf_a where establishment_id = pg_temp.u('a1')) = 1);

-- Reconciliación: todo en cero.
\ir ../tools/reconcile_permits.sql
select pg_temp.check('reconciliación: ' || comprobacion, diferencias = 0, diferencias::text) from _reconcile;
update public.permit_grants set capturer_count = 99 where organization = 'Cruz Roja';
select pg_temp.check('... capturadores alterados en la tabla: se detecta', (select diferencias > 0 from _reconcile where n = 6));

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from bf_results;
  for r in select * from bf_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'permit_backfill: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'permit_backfill: % comprobaciones correctas', total;
end $$;
rollback;
