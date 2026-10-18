-- Carga sintética de volumen (50.000 puntos en las 52 provincias) para medir consultas y políticas RLS.
-- SOLO para una base PostgreSQL LOCAL reconstruida con scripts/dev/rebuild-local-db.sh; nunca sobre Supabase.
-- Uso: psql -v ON_ERROR_STOP=1 -f supabase/tools/volume/load_synthetic_volume.sql   (después, measure_catalogue_load.sql)
\timing on
\set ON_ERROR_STOP 1

-- Usuarios: 1 administrador y 1 usuario con dos provincias (Granada y Almería).
insert into auth.users (id, raw_user_meta_data) values
  ('00000000-0000-4000-8000-0000000000a1', '{"full_name":"Vol Admin"}'),
  ('00000000-0000-4000-8000-0000000000a2', '{"full_name":"Vol Dos provincias"}'),
  ('00000000-0000-4000-8000-0000000000a3', '{"full_name":"Vol Una provincia"}');
update public.profiles set role = 'admin' where id = '00000000-0000-4000-8000-0000000000a1';
insert into public.user_provinces (user_id, province_id, assigned_by)
select '00000000-0000-4000-8000-0000000000a2', id, '00000000-0000-4000-8000-0000000000a1' from public.provinces where code in ('18','04');
insert into public.user_provinces (user_id, province_id, assigned_by)
select '00000000-0000-4000-8000-0000000000a3', id, '00000000-0000-4000-8000-0000000000a1' from public.provinces where code = '18';

-- 40 municipios por provincia.
insert into public.municipalities (province_id, name, normalized_name)
select p.id, 'Municipio ' || p.code || '-' || g, 'municipio ' || p.code || '-' || g
from public.provinces p, generate_series(1, 40) g;

-- 50.000 puntos (unos 960 por provincia), con la misma forma que los reales.
insert into public.establishments (province_id, municipality_id, category_id, name, normalized_name, subtype, address, postal_code,
                                    latitude, longitude, location_precision, location_source, source_ref, status, created_by, updated_by)
select p.id, m.id, c.id,
       'Punto sintético ' || n, 'punto sintetico ' || n, null,
       'Calle Ficticia ' || (n % 300) || ', ' || m.name, lpad((10000 + n % 80000)::text, 5, '0'),
       36.0 + random() * 7.5, -9.0 + random() * 12.5, 'address', 'volumen-sintetico', 'vol-' || n, 'active',
       '00000000-0000-4000-8000-0000000000a1', '00000000-0000-4000-8000-0000000000a1'
from generate_series(1, 50000) n
join lateral (select id from public.provinces order by code offset (n % 52) limit 1) p on true
join lateral (select id, name from public.municipalities where province_id = p.id order by normalized_name offset (n % 40) limit 1) m on true
join lateral (select id from public.categories order by code offset (n % 28) limit 1) c on true;

-- Estado compartido de 3.000 puntos.
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
select id, province_id, '{"estado":"solicitado","notas":"sintético","solicitudes":[{"desde":"2026-11-01","hasta":"2026-11-10","captadores":2,"ong":"ONG Vol"}]}', '00000000-0000-4000-8000-0000000000a1'
from public.establishments order by id limit 3000;

analyze;
select count(*) as puntos, count(distinct province_id) as provincias from public.establishments;
select pg_size_pretty(pg_database_size(current_database())) as base_total,
       pg_size_pretty(pg_total_relation_size('public.establishments')) as tabla_establecimientos,
       pg_size_pretty(pg_total_relation_size('public.audit_log')) as audit_log;
