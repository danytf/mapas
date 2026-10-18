-- Tiempos de la carga del catálogo y del estado compartido con 50.000 puntos y las políticas RLS reales.
-- Imita las consultas de la app: recuento exacto + páginas de 1.000 por clave, y un IN directo por provincia.
-- Requiere haber ejecutado load_synthetic_volume.sql en una base LOCAL. Usuarios: administrador, dos provincias (18 y 04), una provincia (18).
-- Se ejecutan como SQL dinámico para que el plan sea el de una consulta sin parámetros.
\set ON_ERROR_STOP 1
\pset format unaligned
\pset tuples_only on

create or replace function pg_temp.cat_sql(p_ids uuid[], p_ultimo uuid) returns text language sql as $$
  select 'select e.id, e.province_id, e.name, e.address, e.latitude, e.longitude, e.location_precision, e.source_ref, e.status, e.subtype,
          c.name as cat, m.name as muni, pr.name as prov, pr.code
     from public.establishments e
     left join public.categories c on c.id = e.category_id
     left join public.municipalities m on m.id = e.municipality_id
     left join public.provinces pr on pr.id = e.province_id
    where e.status = ''active'' and e.latitude is not null and e.longitude is not null'
    || case when p_ids is null then '' else ' and e.province_id = any (' || quote_literal(p_ids::text) || '::uuid[])' end
    || case when p_ultimo is null then '' else ' and e.id > ' || quote_literal(p_ultimo) end
    || ' order by e.id limit 1000' $$;

create or replace function pg_temp.count_sql(p_ids uuid[]) returns text language sql as $$
  select 'select count(*) from public.establishments e where e.status = ''active'' and e.latitude is not null and e.longitude is not null'
    || case when p_ids is null then '' else ' and e.province_id = any (' || quote_literal(p_ids::text) || '::uuid[])' end $$;

-- Carga completa como lo hace la app: recuento exacto + páginas por clave.
create or replace function pg_temp.carga(p_actor text, p_codigos text[])
returns text language plpgsql as $$
declare ids uuid[]; ult uuid := null; n int; pg int := 0; tot int := 0; mx numeric := 0; t0 timestamptz; tp timestamptz; ms_cuenta numeric; total numeric; cnt bigint;
begin
  if p_codigos is not null then select array_agg(id) into ids from public.provinces where code = any(p_codigos); end if;
  perform set_config('request.jwt.claim.sub', p_actor, true);
  execute 'set local role authenticated';
  t0 := clock_timestamp();
  execute pg_temp.count_sql(ids) into cnt;
  ms_cuenta := round((extract(epoch from clock_timestamp() - t0) * 1000)::numeric, 0);
  loop
    tp := clock_timestamp();
    execute 'select count(*), (array_agg(q.id order by q.id desc))[1] from (' || pg_temp.cat_sql(ids, ult) || ') q' into n, ult;
    exit when n = 0;
    pg := pg + 1; tot := tot + n; mx := greatest(mx, round((extract(epoch from clock_timestamp() - tp) * 1000)::numeric, 0));
    exit when n < 1000;
  end loop;
  total := round((extract(epoch from clock_timestamp() - t0) * 1000)::numeric, 0);
  execute 'reset role';
  return 'filas=' || tot || ' (recuento exacto ' || cnt || ') | recuento ' || ms_cuenta || ' ms | ' || pg || ' paginas, la mas lenta ' || mx || ' ms | TOTAL ' || total || ' ms';
end $$;

select 'administrador, 50.000 puntos:      ' || pg_temp.carga('00000000-0000-4000-8000-0000000000a1', null);
select 'dos provincias (Granada, Almeria): ' || pg_temp.carga('00000000-0000-4000-8000-0000000000a2', array['18','04']);
select 'una provincia (Granada):           ' || pg_temp.carga('00000000-0000-4000-8000-0000000000a3', array['18']);

-- Estado compartido (3.000 filas), como administrador y como usuario de dos provincias.
create or replace function pg_temp.estado(p_actor text) returns text language plpgsql as $$
declare t0 timestamptz; n bigint;
begin
  perform set_config('request.jwt.claim.sub', p_actor, true);
  execute 'set local role authenticated';
  t0 := clock_timestamp();
  select count(*) into n from (select establishment_id, province_id, state, version from public.establishment_app_state order by establishment_id) q;
  execute 'reset role';
  return 'filas=' || n || ' | ' || round((extract(epoch from clock_timestamp() - t0) * 1000)::numeric, 0) || ' ms';
end $$;
select 'estado compartido, administrador:  ' || pg_temp.estado('00000000-0000-4000-8000-0000000000a1');
select 'estado compartido, dos provincias: ' || pg_temp.estado('00000000-0000-4000-8000-0000000000a2');
