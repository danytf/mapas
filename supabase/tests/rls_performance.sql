-- Rendimiento de las políticas de lectura (H-26): misma regla que has_province_access, evaluada una vez por consulta.
-- Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/rls_performance.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('6a')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Perf ' || s) from unnest(array['6a','6b','6c','6d','6e','6f']) s;
-- 6a administrador activo; 6b administrador desactivado con una provincia; 6c usuario con dos provincias;
-- 6d usuario desactivado con una provincia; 6e usuario sin provincias; 6f usuario con una provincia activa y una inactiva.
update public.profiles set role = 'admin' where id in (pg_temp.u('6a'), pg_temp.u('6b'));
update public.profiles set is_active = false where id in (pg_temp.u('6b'), pg_temp.u('6d'));

insert into public.provinces (id, code, name, is_active) values
  (pg_temp.u('7a'), '88', 'Perf A', true), (pg_temp.u('7b'), '89', 'Perf B', true),
  (pg_temp.u('7c'), '90', 'Perf C', true), (pg_temp.u('7d'), '91', 'Perf D', false);
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('6b'), pg_temp.u('7a'), pg_temp.u('6a')),
  (pg_temp.u('6c'), pg_temp.u('7a'), pg_temp.u('6a')), (pg_temp.u('6c'), pg_temp.u('7b'), pg_temp.u('6a')),
  (pg_temp.u('6d'), pg_temp.u('7c'), pg_temp.u('6a')),
  (pg_temp.u('6f'), pg_temp.u('7a'), pg_temp.u('6a')), (pg_temp.u('6f'), pg_temp.u('7d'), pg_temp.u('6a'));
insert into public.municipalities (id, province_id, name, normalized_name) values
  (pg_temp.u('8a'), pg_temp.u('7a'), 'Perf M A', 'perf m a'), (pg_temp.u('8b'), pg_temp.u('7b'), 'Perf M B', 'perf m b'),
  (pg_temp.u('8c'), pg_temp.u('7c'), 'Perf M C', 'perf m c'), (pg_temp.u('8d'), pg_temp.u('7d'), 'Perf M D', 'perf m d');
insert into public.categories (id, code, name) values (pg_temp.u('9a'), 'perf_cat', 'Perf Cat');
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
select pg_temp.u('a' || n), pg_temp.u('7' || p), pg_temp.u('8' || p), pg_temp.u('9a'), 'Perf Est ' || n, 'perf est ' || n, 'Calle ' || n, 37.1, -3.6, pg_temp.u('6a'), pg_temp.u('6a')
from (values ('1', 'a'), ('2', 'b'), ('3', 'c'), ('4', 'd')) v(n, p);
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
select id, province_id, '{}', pg_temp.u('6a') from public.establishments where id in (pg_temp.u('a1'), pg_temp.u('a2'), pg_temp.u('a3'), pg_temp.u('a4'));

create temp table perf_results (name text, ok boolean, detail text);
grant all on perf_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into perf_results values (p_name, coalesce(p_ok, false), p_detail) $$;

-- Equivalencia con la regla anterior: para cada actor y provincia, has_province_access coincide con
-- «administrador o provincia en el conjunto accesible».
create function pg_temp.equivalencia(p_actor text, p_prov text) returns text language plpgsql as $$
declare vieja boolean; nueva boolean;
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_actor)::text, true);
  execute 'set local role authenticated';
  execute format('select public.has_province_access(pg_temp.u(%L))', p_prov) into vieja;
  execute format('select (select private.is_admin()) or pg_temp.u(%L) in (select private.accessible_province_ids())', p_prov) into nueva;
  execute 'reset role';
  return case when vieja = nueva then 'ok' else p_actor || '/' || p_prov || ' vieja=' || vieja || ' nueva=' || nueva end;
exception when others then
  execute 'reset role';
  return p_actor || '/' || p_prov || ' error ' || sqlerrm;
end $$;

do $$
declare a text; p text; r text; malos text := ''; n int := 0;
begin
  foreach a in array array['6a','6b','6c','6d','6e','6f'] loop
    foreach p in array array['7a','7b','7c','7d'] loop
      r := pg_temp.equivalencia(a, p); n := n + 1;
      if r <> 'ok' then malos := malos || ' ' || r; end if;
    end loop;
  end loop;
  perform pg_temp.check('equivalencia con has_province_access en ' || n || ' combinaciones (actor x provincia)', malos = '', malos);
end $$;

-- Definiciones: las cinco políticas usan el conjunto y ya no llaman a has_province_access por fila.
select pg_temp.check('las 5 políticas usan private.accessible_province_ids',
  (select count(*) = 5 from pg_policies where schemaname = 'public'
     and ((tablename = 'establishments' and policyname in ('establishments_select_scope', 'establishments_update_scope'))
       or (tablename = 'establishment_app_state'))
     and (coalesce(qual, '') || coalesce(with_check, '')) ilike '%accessible_province_ids%'));
select pg_temp.check('esas políticas ya no llaman a has_province_access',
  not exists (select 1 from pg_policies where schemaname = 'public'
     and ((tablename = 'establishments' and policyname in ('establishments_select_scope', 'establishments_update_scope'))
       or (tablename = 'establishment_app_state'))
     and (coalesce(qual, '') || coalesce(with_check, '')) ilike '%has_province_access%'));
select pg_temp.check('establishments conserva sus 4 políticas y el estado compartido sus 3',
  (select count(*) from pg_policies where schemaname = 'public' and tablename = 'establishments') = 4
  and (select count(*) from pg_policies where schemaname = 'public' and tablename = 'establishment_app_state') = 3);
select pg_temp.check('la condición updated_by se conserva en la modificación y el alta',
  (select bool_and(with_check ilike '%updated_by%') from pg_policies where schemaname = 'public'
     and policyname in ('establishments_update_scope', 'Users can insert state for assigned provinces', 'Users can update state for assigned provinces')));

-- Permisos de la función nueva.
select pg_temp.check('accessible_province_ids: sin EXECUTE para anon y con EXECUTE para authenticated',
  not has_function_privilege('anon', 'private.accessible_province_ids()', 'EXECUTE')
  and has_function_privilege('authenticated', 'private.accessible_province_ids()', 'EXECUTE'));
select pg_temp.check('accessible_province_ids es SECURITY DEFINER con search_path fijo',
  (select prosecdef and coalesce(proconfig::text, '') like '%search_path%' from pg_proc where oid = 'private.accessible_province_ids()'::regprocedure));

-- Comportamiento visible: lo que ve y puede modificar cada actor.
create function pg_temp.cnt(p_actor text, p_sql text) returns bigint language plpgsql as $$
declare n bigint;
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_actor)::text, true);
  execute 'set local role authenticated';
  execute p_sql into n;
  execute 'reset role';
  return n;
exception when others then execute 'reset role'; return -1;
end $$;
create function pg_temp.est(p_actor text) returns bigint language sql as $$
  select pg_temp.cnt(p_actor, 'select count(*) from public.establishments where name like ''Perf Est %''') $$;
create function pg_temp.st(p_actor text) returns bigint language sql as $$
  select pg_temp.cnt(p_actor, 'select count(*) from public.establishment_app_state where establishment_id in (select id from public.establishments where name like ''Perf Est %'')') $$;
create function pg_temp.upd(p_actor text, p_est text) returns bigint language sql as $$
  select pg_temp.cnt(p_actor, format('with u as (update public.establishments set address = ''Otra'', updated_by = pg_temp.u(%L) where id = pg_temp.u(%L) returning 1) select count(*) from u', p_actor, p_est)) $$;

select pg_temp.check('administrador activo ve las 4 provincias (puntos y estado)', pg_temp.est('6a') = 4 and pg_temp.st('6a') = 4, pg_temp.est('6a')::text || '/' || pg_temp.st('6a')::text);
select pg_temp.check('administrador desactivado solo ve su provincia asignada', pg_temp.est('6b') = 0 and pg_temp.st('6b') = 0, pg_temp.est('6b')::text);
select pg_temp.check('usuario con dos provincias activas ve 2', pg_temp.est('6c') = 2 and pg_temp.st('6c') = 2, pg_temp.est('6c')::text);
select pg_temp.check('usuario desactivado no ve nada', pg_temp.est('6d') = 0 and pg_temp.st('6d') = 0);
select pg_temp.check('usuario sin provincias no ve nada', pg_temp.est('6e') = 0 and pg_temp.st('6e') = 0);
select pg_temp.check('usuario con una provincia activa y una inactiva solo ve la activa', pg_temp.est('6f') = 1 and pg_temp.st('6f') = 1, pg_temp.est('6f')::text);
select pg_temp.check('modifica puntos de sus provincias y de ninguna otra',
  pg_temp.upd('6c', 'a1') = 1 and pg_temp.upd('6c', 'a2') = 1 and pg_temp.upd('6c', 'a3') = 0 and pg_temp.upd('6c', 'a4') = 0 and pg_temp.upd('6e', 'a1') = 0);
select pg_temp.check('el administrador modifica puntos de cualquier provincia', pg_temp.upd('6a', 'a3') = 1 and pg_temp.upd('6a', 'a4') = 1);

-- Plan de ejecución: sin llamada a has_province_access por fila en la consulta del catálogo.
create function pg_temp.plan(p_actor text) returns text language plpgsql as $$
declare linea text; salida text := '';
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_actor)::text, true);
  execute 'set local role authenticated';
  for linea in execute 'explain (costs off) select id, name from public.establishments where status = ''active'' and latitude is not null order by id limit 1000' loop
    salida := salida || linea || E'\n';
  end loop;
  execute 'reset role';
  return salida;
end $$;
select pg_temp.check('plan del catálogo (administrador): sin has_province_access', pg_temp.plan('6a') not ilike '%has_province_access%', left(pg_temp.plan('6a'), 200));
select pg_temp.check('plan del catálogo (usuario): sin has_province_access y con subconsulta', pg_temp.plan('6c') not ilike '%has_province_access%' and pg_temp.plan('6c') ilike '%subplan%', left(pg_temp.plan('6c'), 200));

do $$
declare bad int; r record;
begin
  select count(*) into bad from perf_results where not ok;
  for r in select * from perf_results order by (not ok) desc, name loop
    raise notice '% | %', case when r.ok then 'OK ' else 'FALLO' end, r.name || case when r.detail <> '' then ' [' || r.detail || ']' else '' end;
  end loop;
  if bad > 0 or (select count(*) from perf_results) < 17 then
    raise exception 'rls_performance: % fallos de % comprobaciones', bad, (select count(*) from perf_results);
  end if;
  raise notice 'rls_performance: % comprobaciones correctas', (select count(*) from perf_results);
end $$;

rollback;
