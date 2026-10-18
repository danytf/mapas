-- Pruebas del control de conflicto de establishment_app_state (H-11). Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/state_version.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Ver ' || s) from unnest(array['e1','e2','e3','e4']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('e1');

insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '94', 'Ver G'), (pg_temp.u('f2'), '95', 'Ver O');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'Ver Mun', 'ver mun');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'ver_cat', 'Ver Cat');
-- e2 y e3: misma provincia (dos sesiones sobre el mismo punto); e4: otra provincia.
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('e2'), pg_temp.u('f1'), pg_temp.u('e1')), (pg_temp.u('e3'), pg_temp.u('f1'), pg_temp.u('e1')),
  (pg_temp.u('e4'), pg_temp.u('f2'), pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Ver Est 1', 'ver est 1', 'Calle 1', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1')),
       (pg_temp.u('a2'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Ver Est 2', 'ver est 2', 'Calle 2', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1'));

create temp table ver_results (name text, ok boolean, detail text);
grant all on ver_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into ver_results values (p_name, coalesce(p_ok, false), p_detail) $$;
create function pg_temp.v(est text) returns bigint language sql as
$$ select version from public.establishment_app_state where establishment_id = pg_temp.u(est) $$;
create function pg_temp.s(est text) returns jsonb language sql as
$$ select state from public.establishment_app_state where establishment_id = pg_temp.u(est) $$;

select pg_temp.check('existe la columna version bigint NOT NULL',
  exists (select 1 from information_schema.columns where table_schema = 'public' and table_name = 'establishment_app_state'
          and column_name = 'version' and data_type = 'bigint' and is_nullable = 'NO'));
select pg_temp.check('existe la restricción version >= 1',
  exists (select 1 from pg_constraint where conname = 'establishment_app_state_version_positive'));

-- Alta por e2: el cliente no puede fijar la versión inicial.
select set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
set local role authenticated;
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by, version)
values (pg_temp.u('a1'), pg_temp.u('f1'), '{"estado":"sin","notas":"inicial"}', pg_temp.u('e2'), 99);
reset role;
select pg_temp.check('INSERT empieza en versión 1 aunque el cliente envíe otra', pg_temp.v('a1') = 1, pg_temp.v('a1')::text);

-- Dos sesiones (e2 y e3) leen la versión 1. e2 guarda primero con su versión: se aplica.
do $$
declare n int;
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
  set local role authenticated;
  update public.establishment_app_state set state = '{"estado":"solicitado","notas":"de e2"}', updated_by = pg_temp.u('e2')
   where establishment_id = pg_temp.u('a1') and version = 1;
  get diagnostics n = row_count;
  reset role;
  perform pg_temp.check('e2 guarda con la versión leída: 1 fila', n = 1, n::text);
  perform pg_temp.check('la versión pasa a 2', pg_temp.v('a1') = 2, pg_temp.v('a1')::text);

  -- e3 guarda después con la versión que leyó (1): conflicto, no pisa a e2.
  perform set_config('request.jwt.claim.sub', pg_temp.u('e3')::text, true);
  set local role authenticated;
  update public.establishment_app_state set state = '{"estado":"sin","notas":"de e3"}', updated_by = pg_temp.u('e3')
   where establishment_id = pg_temp.u('a1') and version = 1;
  get diagnostics n = row_count;
  reset role;
  perform pg_temp.check('e3 con versión obsoleta: 0 filas (conflicto)', n = 0, n::text);
  perform pg_temp.check('el estado de e2 se conserva', pg_temp.s('a1') = '{"estado":"solicitado","notas":"de e2"}', pg_temp.s('a1')::text);
  perform pg_temp.check('la versión no cambia tras el conflicto', pg_temp.v('a1') = 2, pg_temp.v('a1')::text);
  perform pg_temp.check('el conflicto no genera historial (H-12)',
    (select count(*) = 1 from public.establishment_app_state_history where establishment_id = pg_temp.u('a1')),
    (select count(*)::text from public.establishment_app_state_history where establishment_id = pg_temp.u('a1')));

  -- e3 recarga (versión 2) y vuelve a guardar: se aplica.
  set local role authenticated;
  update public.establishment_app_state set state = '{"estado":"solicitado","notas":"de e2 y e3"}', updated_by = pg_temp.u('e3')
   where establishment_id = pg_temp.u('a1') and version = 2;
  get diagnostics n = row_count;
  reset role;
  perform pg_temp.check('e3 tras recargar guarda: 1 fila y versión 3', n = 1 and pg_temp.v('a1') = 3, n::text || '/' || pg_temp.v('a1')::text);
  perform pg_temp.check('el historial conserva lo de e2',
    exists (select 1 from public.establishment_app_state_history where establishment_id = pg_temp.u('a1') and old_state = '{"estado":"solicitado","notas":"de e2"}' and changed_by = pg_temp.u('e3')));

  -- El cliente no puede fijar la versión en un UPDATE.
  perform set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
  set local role authenticated;
  update public.establishment_app_state set version = 100, updated_by = pg_temp.u('e2') where establishment_id = pg_temp.u('a1') and version = 3;
  reset role;
  perform pg_temp.check('UPDATE con version = 100 deja la versión en 4', pg_temp.v('a1') = 4, pg_temp.v('a1')::text);

  -- Otra provincia: no actualiza nada aunque conozca la versión.
  perform set_config('request.jwt.claim.sub', pg_temp.u('e4')::text, true);
  set local role authenticated;
  update public.establishment_app_state set state = '{"estado":"sin"}', updated_by = pg_temp.u('e4') where establishment_id = pg_temp.u('a1') and version = 4;
  get diagnostics n = row_count;
  reset role;
  perform pg_temp.check('usuario de otra provincia: 0 filas', n = 0 and pg_temp.v('a1') = 4, n::text);
end $$;

-- Cliente anterior (upsert sin versión): sigue funcionando e incrementa la versión.
select set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
set local role authenticated;
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), '{"estado":"concedido"}', pg_temp.u('e2'))
on conflict (establishment_id) do update set state = excluded.state, updated_by = excluded.updated_by;
reset role;
select pg_temp.check('upsert de un cliente anterior incrementa la versión (4 -> 5)', pg_temp.v('a1') = 5, pg_temp.v('a1')::text);

-- Alta simultánea: si otro creó la fila primero, el INSERT del segundo choca con la clave (conflicto).
do $$
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
  set local role authenticated;
  insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
  values (pg_temp.u('a2'), pg_temp.u('f1'), '{"notas":"primero e2"}', pg_temp.u('e2'));
  reset role;
  perform set_config('request.jwt.claim.sub', pg_temp.u('e3')::text, true);
  set local role authenticated;
  begin
    insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
    values (pg_temp.u('a2'), pg_temp.u('f1'), '{"notas":"luego e3"}', pg_temp.u('e3'));
    reset role;
    perform pg_temp.check('segundo INSERT sobre la misma fila falla con 23505', false, 'sin error');
  exception when unique_violation then
    reset role;
    perform pg_temp.check('segundo INSERT sobre la misma fila falla con 23505', true);
  end;
  perform pg_temp.check('el alta de e2 se conserva (versión 1)', pg_temp.s('a2') = '{"notas":"primero e2"}' and pg_temp.v('a2') = 1);
end $$;

-- La función del trigger no es invocable desde la API.
do $$
declare r text;
begin
  foreach r in array array['anon', 'authenticated'] loop
    perform pg_temp.check('sin EXECUTE para ' || r, not has_function_privilege(r, 'public.set_establishment_app_state_version()', 'EXECUTE'));
  end loop;
  perform pg_temp.check('la función no es SECURITY DEFINER', not (select prosecdef from pg_proc where proname = 'set_establishment_app_state_version'));
  perform pg_temp.check('el trigger es BEFORE INSERT OR UPDATE',
    exists (select 1 from pg_trigger where tgname = 'set_establishment_app_state_version' and tgrelid = 'public.establishment_app_state'::regclass and not tgisinternal));
end $$;

do $$
declare bad int; r record;
begin
  select count(*) into bad from ver_results where not ok;
  for r in select * from ver_results order by (not ok) desc, name loop
    raise notice '% | %', case when r.ok then 'OK ' else 'FALLO' end, r.name || case when r.detail <> '' then ' [' || r.detail || ']' else '' end;
  end loop;
  if bad > 0 or (select count(*) from ver_results) < 20 then
    raise exception 'state_version: % fallos de % comprobaciones', bad, (select count(*) from ver_results);
  end if;
  raise notice 'state_version: % comprobaciones correctas', (select count(*) from ver_results);
end $$;

rollback;
