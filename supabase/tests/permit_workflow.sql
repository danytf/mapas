-- Pruebas del ciclo de vida de solicitudes y concesiones (migración 20261023150000_permit_workflow). Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/permit_workflow.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Perm ' || s) from unnest(array['e1','e2','e3','e4']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('e1');

insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '96', 'Perm Granada'), (pg_temp.u('f2'), '97', 'Perm Malaga');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'Perm Mun G', 'perm mun g'), (pg_temp.u('f4'), pg_temp.u('f2'), 'Perm Mun M', 'perm mun m');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'perm_cat', 'Perm Cat');
-- e2, e3: Granada; e4: Málaga; e1: administrador.
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('e2'), pg_temp.u('f1'), pg_temp.u('e1')), (pg_temp.u('e3'), pg_temp.u('f1'), pg_temp.u('e1')), (pg_temp.u('e4'), pg_temp.u('f2'), pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Perm Gr', 'perm gr', 'Calle 1', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1')),
       (pg_temp.u('a2'), pg_temp.u('f2'), pg_temp.u('f4'), pg_temp.u('f5'), 'Perm Ma', 'perm ma', 'Calle 2', 36.7, -4.4, pg_temp.u('e1'), pg_temp.u('e1'));

create temp table pw_results (name text, ok boolean, detail text);
grant all on pw_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into pw_results values (p_name, coalesce(p_ok, false), p_detail) $$;
-- ejecuta una sentencia como un usuario y devuelve el SQLSTATE del error (o 'ok')
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

-- Alta de dos solicitudes como e2 (Granada).
select set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
set local role authenticated;
insert into public.permit_applications (id, establishment_id, requested_from, requested_until, organization, capturer_count, created_by, updated_by)
values (pg_temp.u('b1'), pg_temp.u('a1'), '2026-11-02', '2026-11-30', 'AECC', 3, pg_temp.u('e2'), pg_temp.u('e2')),
       (pg_temp.u('b2'), pg_temp.u('a1'), '2026-12-01', '2026-12-10', 'Cruz Roja', 2, pg_temp.u('e2'), pg_temp.u('e2'));
reset role;
select pg_temp.check('la solicitud nace pendiente y sin decisión',
  (select status = 'pending' and resolved_at is null and resolved_by is null from public.permit_applications where id = pg_temp.u('b1')));

-- Aprobar: solicitud aprobada + concesión enlazada, en una operación.
select set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
create temp table pw_g (n int, id uuid);
grant all on pw_g to public;
create temp table pw_seen (n int);
grant all on pw_seen to public;
set local role authenticated;
insert into pw_g select 1, public.approve_permit_application(pg_temp.u('b1'));
insert into pw_g select 2, public.approve_permit_application(pg_temp.u('b1'));   -- reintento (respuesta perdida o doble clic)
reset role;
select pg_temp.check('aprobar devuelve la misma concesión al repetir (idempotente)', (select count(distinct id) = 1 and count(*) = 2 from pw_g));
select pg_temp.check('una sola concesión por solicitud', (select count(*) = 1 from public.permit_grants where application_id = pg_temp.u('b1')));
select pg_temp.check('la solicitud conserva su registro y queda aprobada con autor y fecha',
  (select status = 'approved' and resolved_at is not null and resolved_by = pg_temp.u('e2') from public.permit_applications where id = pg_temp.u('b1')));
select pg_temp.check('la concesión hereda fechas, ONG y captadores y enlaza la solicitud',
  (select valid_from = '2026-11-02' and valid_until = '2026-11-30' and organization = 'AECC' and capturer_count = 3 and status = 'active' and created_by = pg_temp.u('e2')
   from public.permit_grants where application_id = pg_temp.u('b1')));
select pg_temp.check('segunda concesión para la misma solicitud: rechazada por el índice único',
  pg_temp.as_user('e2', format($q$insert into public.permit_grants (establishment_id, application_id, created_by, updated_by) values (%L, %L, %L, %L)$q$, pg_temp.u('a1'), pg_temp.u('b1'), pg_temp.u('e2'), pg_temp.u('e2'))) = '23505');

-- Denegar con motivo; retirar; estados terminales.
select pg_temp.check('denegar con motivo', pg_temp.as_user('e3', format($q$select public.resolve_permit_application(%L, 'denied', 'Sin cupo')$q$, pg_temp.u('b2'))) = 'ok');
select pg_temp.check('la denegación guarda estado, motivo, autor y fecha',
  (select status = 'denied' and resolution_reason = 'Sin cupo' and resolved_by = pg_temp.u('e3') and resolved_at is not null from public.permit_applications where id = pg_temp.u('b2')));
select pg_temp.check('denegar otra vez es idempotente', pg_temp.as_user('e3', format($q$select public.resolve_permit_application(%L, 'denied', 'otro')$q$, pg_temp.u('b2'))) = 'ok');
select pg_temp.check('el motivo original no se pisa al repetir', (select resolution_reason = 'Sin cupo' from public.permit_applications where id = pg_temp.u('b2')));
select pg_temp.check('retirar una solicitud ya denegada falla (23514)', pg_temp.as_user('e3', format($q$select public.resolve_permit_application(%L, 'withdrawn')$q$, pg_temp.u('b2'))) = '23514');
select pg_temp.check('aprobar una solicitud denegada falla (23514)', pg_temp.as_user('e3', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b2'))) = '23514');
select pg_temp.check('estado de resolución no válido (22023)', pg_temp.as_user('e3', format($q$select public.resolve_permit_application(%L, 'approved')$q$, pg_temp.u('b2'))) = '22023');
select pg_temp.check('una solicitud resuelta no vuelve a pendiente con un UPDATE directo',
  pg_temp.as_user('e3', format($q$update public.permit_applications set status = 'pending', updated_by = %L where id = %L$q$, pg_temp.u('e3'), pg_temp.u('b2'))) = '23514');
select pg_temp.check('la fecha de decisión no se puede reescribir',
  pg_temp.as_user('e3', format($q$update public.permit_applications set resolved_at = now() - interval '9 days', updated_by = %L where id = %L$q$, pg_temp.u('e3'), pg_temp.u('b2'))) = '42501');
select pg_temp.check('la referencia de origen es inmutable',
  pg_temp.as_user('e3', format($q$update public.permit_applications set legacy_ref = 'x', updated_by = %L where id = %L$q$, pg_temp.u('e3'), pg_temp.u('b2'))) = '42501');

-- Conflicto concurrente: dos sesiones leen la misma fecha de modificación.
insert into public.permit_applications (id, establishment_id, requested_from, organization, created_by, updated_by)
values (pg_temp.u('b3'), pg_temp.u('a1'), '2026-12-15', 'WWF', pg_temp.u('e2'), pg_temp.u('e2'));
create temp table pw_v (v timestamptz);
grant all on pw_v to public;
-- dentro de una transacción now() no avanza: la lectura «obsoleta» es una fecha anterior a la actual
insert into pw_v select updated_at - interval '1 second' from public.permit_applications where id = pg_temp.u('b3');
select pg_temp.check('aprobar con una fecha de lectura obsoleta: conflicto 40001',
  pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L, %L)$q$, pg_temp.u('b3'), (select v from pw_v))) = '40001');
select pg_temp.check('el conflicto no deja concesión ni cambia el estado',
  (select status = 'pending' from public.permit_applications where id = pg_temp.u('b3')) and not exists (select 1 from public.permit_grants where application_id = pg_temp.u('b3')));
select pg_temp.check('con la fecha actual la aprobación sí se aplica',
  pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L, %L)$q$, pg_temp.u('b3'), (select updated_at from public.permit_applications where id = pg_temp.u('b3')))) = 'ok');

-- Atomicidad: si la concesión no se puede crear, la solicitud no queda aprobada.
insert into public.permit_applications (id, establishment_id, requested_from, requested_until, organization, created_by, updated_by)
values (pg_temp.u('b4'), pg_temp.u('a1'), '2026-12-15', '2026-12-20', 'WWF', pg_temp.u('e2'), pg_temp.u('e2'));
select pg_temp.check('aprobación con fechas incoherentes falla (23514) ...',
  pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L, null, '2026-12-30', '2026-12-01')$q$, pg_temp.u('b4'))) = '23514');
select pg_temp.check('... y la solicitud sigue pendiente (todo o nada)',
  (select status = 'pending' and resolved_at is null from public.permit_applications where id = pg_temp.u('b4')));
select pg_temp.check('... y no hay concesión huérfana', not exists (select 1 from public.permit_grants where application_id = pg_temp.u('b4')));

-- Cancelar una concesión.
select pg_temp.check('cancelar con motivo', pg_temp.as_user('e2', format($q$select public.cancel_permit_grant(%L, 'La ONG renuncia')$q$, (select id from public.permit_grants where application_id = pg_temp.u('b1')))) = 'ok');
select pg_temp.check('la cancelación guarda estado, fecha y motivo',
  (select status = 'cancelled' and cancelled_at is not null and cancelled_reason = 'La ONG renuncia' and updated_by = pg_temp.u('e2') from public.permit_grants where application_id = pg_temp.u('b1')));
select pg_temp.check('cancelar otra vez es idempotente', pg_temp.as_user('e2', format($q$select public.cancel_permit_grant(%L, 'otro')$q$, (select id from public.permit_grants where application_id = pg_temp.u('b1')))) = 'ok');
select pg_temp.check('reactivar por UPDATE funciona', pg_temp.as_user('e2', format($q$update public.permit_grants set status = 'active', updated_by = %L where application_id = %L$q$, pg_temp.u('e2'), pg_temp.u('b1'))) = 'ok');
select pg_temp.check('... y limpia la cancelación', (select cancelled_at is null and cancelled_reason is null from public.permit_grants where application_id = pg_temp.u('b1')));

-- Aislamiento provincial: e4 (Málaga) no ve ni opera sobre expedientes de Granada, y viceversa.
select pg_temp.as_user('e4', 'delete from pw_seen; insert into pw_seen select count(*) from public.permit_applications');
select pg_temp.check('e4 (Málaga) no ve solicitudes de Granada', (select n = 0 from pw_seen), (select n::text from pw_seen));
select pg_temp.check('e4 no puede aprobar una solicitud de Granada (P0002, sin filtrar su existencia)',
  pg_temp.as_user('e4', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b4'))) = 'P0002');
select pg_temp.check('e4 no puede denegar una solicitud de Granada', pg_temp.as_user('e4', format($q$select public.resolve_permit_application(%L, 'denied')$q$, pg_temp.u('b4'))) = 'P0002');
select pg_temp.check('e4 no puede cancelar una concesión de Granada', pg_temp.as_user('e4', format($q$select public.cancel_permit_grant(%L)$q$, (select id from public.permit_grants where application_id = pg_temp.u('b1')))) = 'P0002');
select pg_temp.check('e4 no puede crear una solicitud en un establecimiento de Granada',
  pg_temp.as_user('e4', format($q$insert into public.permit_applications (establishment_id, created_by, updated_by) values (%L, %L, %L)$q$, pg_temp.u('a1'), pg_temp.u('e4'), pg_temp.u('e4'))) = '42501');
select pg_temp.check('e2 (Granada) no puede crear una solicitud en Málaga',
  pg_temp.as_user('e2', format($q$insert into public.permit_applications (establishment_id, created_by, updated_by) values (%L, %L, %L)$q$, pg_temp.u('a2'), pg_temp.u('e2'), pg_temp.u('e2'))) = '42501');
select pg_temp.check('no se puede mover una solicitud a otra provincia cambiando su establecimiento',
  pg_temp.as_user('e2', format($q$update public.permit_applications set establishment_id = %L, updated_by = %L where id = %L$q$, pg_temp.u('a2'), pg_temp.u('e2'), pg_temp.u('b4'))) in ('42501'));
select pg_temp.check('anon no puede ejecutar las funciones',
  not has_function_privilege('anon', 'public.approve_permit_application(uuid, timestamptz, date, date, text, integer)', 'execute')
  and not has_function_privilege('anon', 'public.resolve_permit_application(uuid, text, text, timestamptz)', 'execute')
  and not has_function_privilege('anon', 'public.cancel_permit_grant(uuid, text, timestamptz)', 'execute'));
select pg_temp.as_user('e1', 'delete from pw_seen; insert into pw_seen select count(*) from public.permit_applications');
select pg_temp.check('administrador ve todo', (select n >= 4 from pw_seen), (select n::text from pw_seen));

-- Seguimientos: cola de trabajo con responsable de la provincia.
select pg_temp.check('seguimiento asignado a un usuario de la provincia',
  pg_temp.as_user('e2', format($q$insert into public.followups (id, establishment_id, application_id, due_on, assigned_to, next_action, created_by) values (%L, %L, %L, '2026-10-30', %L, 'Llamar al responsable', %L)$q$, pg_temp.u('c1'), pg_temp.u('a1'), pg_temp.u('b4'), pg_temp.u('e3'), pg_temp.u('e2'))) = 'ok');
select pg_temp.check('seguimiento asignado a un usuario de otra provincia: rechazado (23514)',
  pg_temp.as_user('e2', format($q$insert into public.followups (establishment_id, application_id, due_on, assigned_to, created_by) values (%L, %L, '2026-10-30', %L, %L)$q$, pg_temp.u('a1'), pg_temp.u('b4'), pg_temp.u('e4'), pg_temp.u('e2'))) = '23514');
select pg_temp.check('seguimiento asignado a un administrador: permitido',
  pg_temp.as_user('e2', format($q$insert into public.followups (establishment_id, due_on, assigned_to, created_by) values (%L, '2026-10-30', %L, %L)$q$, pg_temp.u('a1'), pg_temp.u('e1'), pg_temp.u('e2'))) = 'ok');
select pg_temp.as_user('e4', 'delete from pw_seen; insert into pw_seen select count(*) from public.followups');
select pg_temp.check('e4 no ve los seguimientos de Granada', (select n = 0 from pw_seen), (select n::text from pw_seen));
select pg_temp.check('completar un seguimiento con resultado',
  pg_temp.as_user('e3', format($q$update public.followups set completed_at = now(), outcome = 'Pidió esperar a noviembre' where id = %L$q$, pg_temp.u('c1'))) = 'ok');

-- Trazabilidad: el ciclo de vida queda en audit_log.
select pg_temp.check('audit_log registra la aprobación (quién y qué cambió)',
  exists (select 1 from public.audit_log where record_id = pg_temp.u('b1') and table_name = 'permit_applications' and action = 'update' and actor_id = pg_temp.u('e2') and details->'changed_fields' ? 'status'));

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from pw_results;
  for r in select * from pw_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'permit_workflow: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'permit_workflow: % comprobaciones correctas', total;
end $$;
rollback;
