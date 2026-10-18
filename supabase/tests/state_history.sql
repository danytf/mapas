-- Pruebas del historial de establishment_app_state (H-12). Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/state_history.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('b1')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Hist ' || s) from unnest(array['b1','b2','b3','b4']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('b1');

insert into public.provinces (id, code, name) values (pg_temp.u('c1'), '96', 'Hist G'), (pg_temp.u('c2'), '97', 'Hist O');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('c3'), pg_temp.u('c1'), 'Hist Mun', 'hist mun');
insert into public.categories (id, code, name) values (pg_temp.u('c5'), 'hist_cat', 'Hist Cat');
-- b2 y b3: misma provincia (el caso del lost update); b4: otra provincia.
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('b2'), pg_temp.u('c1'), pg_temp.u('b1')), (pg_temp.u('b3'), pg_temp.u('c1'), pg_temp.u('b1')),
  (pg_temp.u('b4'), pg_temp.u('c2'), pg_temp.u('b1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('d1'), pg_temp.u('c1'), pg_temp.u('c3'), pg_temp.u('c5'), 'Hist Est', 'hist est', 'Calle 1', 37.1, -3.6, pg_temp.u('b1'), pg_temp.u('b1'));
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
values (pg_temp.u('d1'), pg_temp.u('c1'), '{"v":0}', pg_temp.u('b1'));

create temp table hist_results (name text, ok boolean, detail text);
grant all on hist_results to public;

create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into hist_results values (p_name, coalesce(p_ok, false), p_detail) $$;

-- Reproduce el lost update de H-11: b2 y b3 parten del mismo estado; el segundo pisa al primero.
select set_config('request.jwt.claim.sub', pg_temp.u('b2')::text, true);
set local role authenticated;
update public.establishment_app_state set state = '{"v":1,"contacto":"de b2"}', updated_by = pg_temp.u('b2') where establishment_id = pg_temp.u('d1');
select set_config('request.jwt.claim.sub', pg_temp.u('b3')::text, true);
update public.establishment_app_state set state = '{"v":2,"otro":"de b3"}', updated_by = pg_temp.u('b3') where establishment_id = pg_temp.u('d1');
-- Guardado idéntico: no debe generar historial.
update public.establishment_app_state set state = '{"v":2,"otro":"de b3"}', updated_by = pg_temp.u('b3') where establishment_id = pg_temp.u('d1');
reset role;

select pg_temp.check('dos sobrescrituras reales generan exactamente 2 filas', (select count(*) = 2 from public.establishment_app_state_history), (select count(*)::text from public.establishment_app_state_history));
select pg_temp.check('un guardado idéntico no genera historial', (select count(*) = 2 from public.establishment_app_state_history));
select pg_temp.check('el contenido pisado de b2 es recuperable', exists (select 1 from public.establishment_app_state_history where old_state = '{"v":1,"contacto":"de b2"}' and changed_by = pg_temp.u('b3') and old_updated_by = pg_temp.u('b2') and operation = 'UPDATE'));
select pg_temp.check('el estado inicial queda registrado al ser sobrescrito por b2', exists (select 1 from public.establishment_app_state_history where old_state = '{"v":0}' and changed_by = pg_temp.u('b2')));
select pg_temp.check('conserva provincia y establecimiento', (select bool_and(province_id = pg_temp.u('c1') and establishment_id = pg_temp.u('d1')) from public.establishment_app_state_history));

-- Lectura: solo administrador.
do $$
declare n int; r record;
begin
  for r in select * from (values ('b1', 2), ('b2', 0), ('b3', 0), ('b4', 0)) v(sfx, expected) loop
    perform set_config('request.jwt.claim.sub', pg_temp.u(r.sfx)::text, true);
    set local role authenticated;
    select count(*) into n from public.establishment_app_state_history;
    reset role;
    perform pg_temp.check('lectura como ' || r.sfx || ' ve ' || r.expected, n = r.expected, n::text);
  end loop;
  set local role anon;
  begin
    perform 1 from public.establishment_app_state_history;
    reset role;
    perform pg_temp.check('anon no puede leer', false, 'sin error');
  exception when insufficient_privilege then
    reset role;
    perform pg_temp.check('anon no puede leer', true);
  end;
end $$;

-- Escritura directa: nadie desde la API, ni siquiera el administrador.
do $$
declare actor text; stmt text; stmts text[] := array[
  'insert into public.establishment_app_state_history(establishment_id,province_id,operation,old_state) values (pg_temp.u(''d1''),pg_temp.u(''c1''),''UPDATE'',''{}'')',
  'update public.establishment_app_state_history set old_state = ''{}''',
  'delete from public.establishment_app_state_history',
  'truncate public.establishment_app_state_history',
  'select public.record_establishment_app_state_history()'];
begin
  foreach actor in array array['b1','b2','b4'] loop
    foreach stmt in array stmts loop
      perform set_config('request.jwt.claim.sub', pg_temp.u(actor)::text, true);
      set local role authenticated;
      begin
        execute stmt;
        reset role;
        perform pg_temp.check(actor || ' no puede: ' || left(stmt, 40), false, 'sin error');
      exception when insufficient_privilege then
        reset role;
        perform pg_temp.check(actor || ' no puede: ' || left(stmt, 40), true);
      when others then
        reset role;
        perform pg_temp.check(actor || ' no puede: ' || left(stmt, 40), false, sqlstate || ' ' || sqlerrm);
      end;
    end loop;
  end loop;
end $$;

select pg_temp.check('las filas siguen intactas tras los intentos', (select count(*) = 2 from public.establishment_app_state_history));

-- Borrado de la fila de estado (solo propietario/servicio): se conserva el último estado.
select set_config('request.jwt.claim.sub', '', true);
delete from public.establishment_app_state where establishment_id = pg_temp.u('d1');
select pg_temp.check('DELETE registra el estado final', exists (select 1 from public.establishment_app_state_history where operation = 'DELETE' and old_state = '{"v":2,"otro":"de b3"}'));
select pg_temp.check('borrar un establecimiento no borra su historial', (select count(*) = 3 from public.establishment_app_state_history));

-- Las tablas con estado no tocadas no cambian: user_app_state sigue sin historial.
select pg_temp.check('user_app_state fuera de alcance (sin trigger de historial)', not exists (select 1 from pg_trigger where tgrelid = 'public.user_app_state'::regclass and tgname like '%history%'));

do $$
declare bad int; r record;
begin
  select count(*) into bad from hist_results where not ok;
  for r in select * from hist_results order by (not ok) desc, name loop
    raise notice '% | %', case when r.ok then 'OK ' else 'FALLO' end, r.name || case when r.detail <> '' then ' [' || r.detail || ']' else '' end;
  end loop;
  if bad > 0 or (select count(*) from hist_results) < 25 then
    raise exception 'state_history: % fallos de % comprobaciones', bad, (select count(*) from hist_results);
  end if;
  raise notice 'state_history: % comprobaciones correctas', (select count(*) from hist_results);
end $$;

rollback;
