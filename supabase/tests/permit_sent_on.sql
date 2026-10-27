-- Pruebas de la fecha de envío de una solicitud (migración 20261027180000_permit_application_sent_on). Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/permit_sent_on.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Sent ' || s) from unnest(array['e1','e2','e4']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('e1');

insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '94', 'Sent Granada'), (pg_temp.u('f2'), '95', 'Sent Malaga');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'Sent Mun G', 'sent mun g'), (pg_temp.u('f4'), pg_temp.u('f2'), 'Sent Mun M', 'sent mun m');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'sent_cat', 'Sent Cat');
-- e2: Granada; e4: Málaga; e1: administrador.
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('e2'), pg_temp.u('f1'), pg_temp.u('e1')), (pg_temp.u('e4'), pg_temp.u('f2'), pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Sent Gr', 'sent gr', 'Calle 1', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1'));

create temp table pw_results (name text, ok boolean, detail text);
grant all on pw_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into pw_results values (p_name, coalesce(p_ok, false), p_detail) $$;
-- ejecuta una sentencia como un usuario (rol authenticated, o el indicado) y devuelve el SQLSTATE del error (o 'ok')
create function pg_temp.as_user(p_user text, p_sql text, p_role text default 'authenticated') returns text language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', pg_temp.u(p_user)::text, true);
  execute 'set local role ' || p_role;
  begin
    execute p_sql;
  exception when others then
    reset role;
    return sqlstate;
  end;
  reset role;
  return 'ok';
end $$;

-- La columna: fecha anulable y sin valor por defecto.
select pg_temp.check('sent_on es una fecha anulable sin valor por defecto',
  exists (select 1 from information_schema.columns where table_schema = 'public' and table_name = 'permit_applications' and column_name = 'sent_on'
          and data_type = 'date' and is_nullable = 'YES' and column_default is null));

-- Alta como e2 (Granada): la solicitud nace «por solicitar» (pendiente y sin fecha de envío).
select set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
set local role authenticated;
insert into public.permit_applications (id, establishment_id, requested_from, requested_until, organization, capturer_count, created_by, updated_by)
values (pg_temp.u('b1'), pg_temp.u('a1'), '2026-11-02', '2026-11-30', 'AECC', 3, pg_temp.u('e2'), pg_temp.u('e2'));
reset role;
select pg_temp.check('la solicitud nace pendiente y sin fecha de envío (por solicitar)',
  (select status = 'pending' and sent_on is null from public.permit_applications where id = pg_temp.u('b1')));

-- El RGR (usuario de la provincia) la marca como solicitada.
select pg_temp.check('un usuario de la provincia puede marcar la solicitud como solicitada',
  pg_temp.as_user('e2', format($q$update public.permit_applications set sent_on = '2026-11-03' where id = %L$q$, pg_temp.u('b1'))) = 'ok');
select pg_temp.check('la fecha de envío queda guardada y la solicitud sigue pendiente (solicitada)',
  (select status = 'pending' and sent_on = '2026-11-03' from public.permit_applications where id = pg_temp.u('b1')));
select pg_temp.check('audit_log registra el envío (quién y qué campo)',
  exists (select 1 from public.audit_log where record_id = pg_temp.u('b1') and table_name = 'permit_applications' and action = 'update' and actor_id = pg_temp.u('e2')
          and details->'changed_fields' ? 'sent_on'));

-- Aislamiento: un usuario de otra provincia no puede cambiarla (la política no le deja ver la fila, así que no actualiza ninguna).
select pg_temp.as_user('e4', format($q$update public.permit_applications set sent_on = '2026-12-31' where id = %L$q$, pg_temp.u('b1')));
select pg_temp.check('un usuario de otra provincia no modifica la fecha de envío',
  (select sent_on = '2026-11-03' from public.permit_applications where id = pg_temp.u('b1')));
select pg_temp.check('sin sesión (anon) no se puede escribir la fecha de envío (42501)',
  pg_temp.as_user('e2', format($q$update public.permit_applications set sent_on = '2026-12-31' where id = %L$q$, pg_temp.u('b1')), 'anon') = '42501');

-- Se puede quitar (volver a «por solicitar»).
select pg_temp.check('se puede quitar la fecha de envío',
  pg_temp.as_user('e2', format($q$update public.permit_applications set sent_on = null where id = %L$q$, pg_temp.u('b1'))) = 'ok');
select pg_temp.check('sin fecha vuelve a «por solicitar»',
  (select status = 'pending' and sent_on is null from public.permit_applications where id = pg_temp.u('b1')));

-- Aprobar o denegar conserva la fecha de envío (queda el rastro de cuándo se pidió).
select pg_temp.as_user('e2', format($q$update public.permit_applications set sent_on = '2026-11-03' where id = %L$q$, pg_temp.u('b1')));
select set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
set local role authenticated;
select public.approve_permit_application(pg_temp.u('b1'));
reset role;
select pg_temp.check('al aprobar se conserva la fecha de envío',
  (select status = 'approved' and sent_on = '2026-11-03' from public.permit_applications where id = pg_temp.u('b1')));

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from pw_results;
  for r in select * from pw_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'permit_sent_on: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'permit_sent_on: % comprobaciones correctas', total;
end $$;
rollback;
