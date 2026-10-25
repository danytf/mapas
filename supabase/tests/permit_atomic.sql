-- Pruebas de las operaciones atómicas de expedientes (migración 20261025170441_permit_atomic_followups). Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/permit_atomic.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-00000000a7' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Atom ' || s) from unnest(array['e1','e2','e3','e4']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('e1');

insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '94', 'Atom Granada'), (pg_temp.u('f2'), '95', 'Atom Malaga');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'Atom Mun G', 'atom mun g'), (pg_temp.u('f4'), pg_temp.u('f2'), 'Atom Mun M', 'atom mun m');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'atom_cat', 'Atom Cat');
-- e2, e3: Granada; e4: Málaga; e1: administrador.
insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('e2'), pg_temp.u('f1'), pg_temp.u('e1')), (pg_temp.u('e3'), pg_temp.u('f1'), pg_temp.u('e1')), (pg_temp.u('e4'), pg_temp.u('f2'), pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Atom Gr', 'atom gr', 'Calle 1', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1')),
       (pg_temp.u('a2'), pg_temp.u('f2'), pg_temp.u('f4'), pg_temp.u('f5'), 'Atom Ma', 'atom ma', 'Calle 2', 36.7, -4.4, pg_temp.u('e1'), pg_temp.u('e1'));

create temp table pa_results (name text, ok boolean, detail text);
grant all on pa_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into pa_results values (p_name, coalesce(p_ok, false), p_detail) $$;
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
create temp table pa_t (k text primary key, v timestamptz);
grant all on pa_t to public;

-- Tres solicitudes y sus seguimientos (como e2, Granada).
select set_config('request.jwt.claim.sub', pg_temp.u('e2')::text, true);
set local role authenticated;
insert into public.permit_applications (id, establishment_id, requested_from, requested_until, organization, capturer_count, created_by, updated_by) values
  (pg_temp.u('b1'), pg_temp.u('a1'), '2026-11-02', '2026-11-30', 'AECC', 3, pg_temp.u('e2'), pg_temp.u('e2')),
  (pg_temp.u('b2'), pg_temp.u('a1'), '2026-12-01', '2026-12-10', 'Cruz Roja', 2, pg_temp.u('e2'), pg_temp.u('e2')),
  (pg_temp.u('b3'), pg_temp.u('a1'), '2027-01-01', '2027-01-10', 'WWF', 1, pg_temp.u('e2'), pg_temp.u('e2'));
insert into public.followups (id, establishment_id, application_id, due_on, created_by) values
  (pg_temp.u('c1'), pg_temp.u('a1'), pg_temp.u('b1'), '2026-10-30', pg_temp.u('e2')),
  (pg_temp.u('c2'), pg_temp.u('a1'), pg_temp.u('b2'), '2026-10-30', pg_temp.u('e2'));
reset role;

-- APROBAR cierra los seguimientos de la solicitud en la misma transacción y no toca los de otras.
select pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b1')));
select pg_temp.check('aprobar cierra el seguimiento abierto de la solicitud', (select completed_at is not null from public.followups where id = pg_temp.u('c1')));
select pg_temp.check('aprobar no toca el seguimiento de otra solicitud', (select completed_at is null from public.followups where id = pg_temp.u('c2')));
select pg_temp.check('aprobar sigue creando la concesión enlazada', (select count(*) = 1 from public.permit_grants where application_id = pg_temp.u('b1')));
select pg_temp.check('reintentar la aprobación es idempotente', pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b1'))) = 'ok');
select pg_temp.check('…y no duplica la concesión', (select count(*) = 1 from public.permit_grants where application_id = pg_temp.u('b1')));

-- Un conflicto de versión (PT409) deshace todo: ni la solicitud cambia ni el seguimiento se cierra.
select pg_temp.check('aprobar con una versión vieja falla con PT409',
  pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L, now() - interval '1 day')$q$, pg_temp.u('b2'))) = 'PT409');
select pg_temp.check('…y la solicitud sigue pendiente y su seguimiento abierto',
  (select a.status = 'pending' and f.completed_at is null from public.permit_applications a join public.followups f on f.application_id = a.id where a.id = pg_temp.u('b2')));
select pg_temp.check('aprobar con fechas incoherentes falla y no cierra el seguimiento',
  pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L, null, '2026-12-30', '2026-12-01')$q$, pg_temp.u('b2'))) <> 'ok'
  and (select f.completed_at is null from public.followups f where f.id = pg_temp.u('c2')));

-- DENEGAR / RETIRAR cierran los seguimientos de la solicitud.
select pg_temp.check('denegar funciona', pg_temp.as_user('e2', format($q$select public.resolve_permit_application(%L, 'denied', 'Sin cupo')$q$, pg_temp.u('b2'))) = 'ok');
select pg_temp.check('denegar cierra el seguimiento de la solicitud', (select completed_at is not null from public.followups where id = pg_temp.u('c2')));
insert into pa_t select 'c2', completed_at from public.followups where id = pg_temp.u('c2');
select pg_temp.check('retirar una solicitud ya denegada falla (23514)', pg_temp.as_user('e2', format($q$select public.resolve_permit_application(%L, 'withdrawn')$q$, pg_temp.u('b2'))) = '23514');
select pg_temp.check('…y no vuelve a tocar el seguimiento', (select completed_at = (select v from pa_t where k = 'c2') from public.followups where id = pg_temp.u('c2')));
select pg_temp.check('denegar otra vez es idempotente', pg_temp.as_user('e2', format($q$select public.resolve_permit_application(%L, 'denied')$q$, pg_temp.u('b2'))) = 'ok');

-- CANCELAR una concesión cierra los seguimientos de esa concesión y solo esos.
select pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b3')));
insert into public.followups (id, establishment_id, grant_id, due_on, created_by)
select pg_temp.u('c3'), pg_temp.u('a1'), id, '2026-11-05', pg_temp.u('e2') from public.permit_grants where application_id = pg_temp.u('b3');
insert into public.followups (id, establishment_id, application_id, due_on, created_by) values (pg_temp.u('c4'), pg_temp.u('a1'), pg_temp.u('b3'), '2026-11-06', pg_temp.u('e2'));
select pg_temp.check('cancelar la concesión funciona', pg_temp.as_user('e2', format($q$select public.cancel_permit_grant(%L, 'Fin de campaña')$q$, (select id from public.permit_grants where application_id = pg_temp.u('b3')))) = 'ok');
select pg_temp.check('cancelar cierra el seguimiento de la concesión', (select completed_at is not null from public.followups where id = pg_temp.u('c3')));
select pg_temp.check('cancelar no cierra el de la solicitud de origen', (select completed_at is null from public.followups where id = pg_temp.u('c4')));
select pg_temp.check('cancelar otra vez es idempotente', pg_temp.as_user('e2', format($q$select public.cancel_permit_grant(%L)$q$, (select id from public.permit_grants where application_id = pg_temp.u('b3')))) = 'ok');

-- CREAR una solicitud con su seguimiento en una sola operación.
select pg_temp.check('crear solicitud con seguimiento',
  pg_temp.as_user('e2', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'AECC', p_capturer_count => 3, p_requested_from => '2026-11-02', p_requested_until => '2026-11-20',
    p_contact_details => 'Ana', p_notes => 'Nota', p_followup_due => '2026-10-30', p_followup_assignee => %L, p_followup_action => 'Llamar')$q$, pg_temp.u('d1'), pg_temp.u('a1'), pg_temp.u('e3'))) = 'ok');
select pg_temp.check('la solicitud nace pendiente, de su autor y con la fecha de hoy en Madrid',
  (select status = 'pending' and created_by = pg_temp.u('e2') and requested_at = (now() at time zone 'Europe/Madrid')::date and contact_details = 'Ana' and capturer_count = 3 from public.permit_applications where id = pg_temp.u('d1')));
select pg_temp.check('y su seguimiento queda abierto con fecha, responsable y acción',
  (select count(*) = 1 and bool_and(completed_at is null and due_on = '2026-10-30' and assigned_to = pg_temp.u('e3') and next_action = 'Llamar' and created_by = pg_temp.u('e2')) from public.followups where application_id = pg_temp.u('d1')));
select pg_temp.check('reintentar con los mismos datos no duplica nada',
  pg_temp.as_user('e2', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'AECC', p_capturer_count => 3, p_requested_from => '2026-11-02', p_requested_until => '2026-11-20',
    p_followup_due => '2026-10-30', p_followup_assignee => %L, p_followup_action => 'Llamar')$q$, pg_temp.u('d1'), pg_temp.u('a1'), pg_temp.u('e3'))) = 'ok'
  and (select count(*) = 1 from public.permit_applications where id = pg_temp.u('d1')) and (select count(*) = 1 from public.followups where application_id = pg_temp.u('d1')));
select pg_temp.check('reintentar con otros datos falla (23505) y no cambia nada',
  pg_temp.as_user('e2', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'AECC', p_capturer_count => 9, p_requested_from => '2026-11-02', p_requested_until => '2026-11-20')$q$, pg_temp.u('d1'), pg_temp.u('a1'))) = '23505'
  and (select capturer_count = 3 from public.permit_applications where id = pg_temp.u('d1')));
-- Si el primer intento llegó a medias (la solicitud existe y el seguimiento no), el reintento solo añade lo que falta.
delete from public.followups where application_id = pg_temp.u('d1');
create temp table pa_r (k text primary key, v text);
grant all on pa_r to public;
insert into pa_r select 'd1', pg_temp.as_user('e2', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'AECC', p_capturer_count => 3, p_requested_from => '2026-11-02', p_requested_until => '2026-11-20',
    p_followup_due => '2026-10-30', p_followup_action => 'Llamar')$q$, pg_temp.u('d1'), pg_temp.u('a1')));
select pg_temp.check('reintento con la solicitud ya creada y el seguimiento perdido: añade solo el seguimiento',
  (select v = 'ok' from pa_r where k = 'd1')
  and (select count(*) = 1 from public.permit_applications where id = pg_temp.u('d1')) and (select count(*) = 1 from public.followups where application_id = pg_temp.u('d1') and completed_at is null));
-- Si la solicitud ya se resolvió, un reintento tardío no crea un seguimiento nuevo.
select pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('d1')));
select pg_temp.check('reintento tardío sobre una solicitud ya resuelta no abre otro seguimiento',
  pg_temp.as_user('e2', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'AECC', p_capturer_count => 3, p_requested_from => '2026-11-02', p_requested_until => '2026-11-20',
    p_followup_due => '2026-10-31')$q$, pg_temp.u('d1'), pg_temp.u('a1'))) = 'ok'
  and (select count(*) = 1 and bool_and(completed_at is not null) from public.followups where application_id = pg_temp.u('d1')));

-- ATOMICIDAD: si el seguimiento no es válido, no se crea ni la solicitud.
select pg_temp.check('responsable de otra provincia: falla (23514)',
  pg_temp.as_user('e2', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'WWF', p_followup_due => '2026-10-30', p_followup_assignee => %L)$q$, pg_temp.u('d2'), pg_temp.u('a1'), pg_temp.u('e4'))) = '23514');
select pg_temp.check('…y la solicitud tampoco se ha creado (todo o nada)', (select count(*) = 0 from public.permit_applications where id = pg_temp.u('d2')));
insert into pa_r select 'd3', pg_temp.as_user('e2', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'FJC')$q$, pg_temp.u('d3'), pg_temp.u('a1')));
select pg_temp.check('sin seguimiento solo crea la solicitud',
  (select v = 'ok' from pa_r where k = 'd3')
  and (select count(*) = 1 from public.permit_applications where id = pg_temp.u('d3')) and (select count(*) = 0 from public.followups where application_id = pg_temp.u('d3')));

-- AISLAMIENTO PROVINCIAL y permisos.
select pg_temp.check('e4 (Málaga) no puede crear una solicitud en Granada (42501)',
  pg_temp.as_user('e4', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'X', p_followup_due => '2026-10-30')$q$, pg_temp.u('d4'), pg_temp.u('a1'))) = '42501');
select pg_temp.check('…y no queda ni solicitud ni seguimiento', (select count(*) = 0 from public.permit_applications where id = pg_temp.u('d4')) and (select count(*) = 0 from public.followups where application_id = pg_temp.u('d4')));
select pg_temp.check('e2 (Granada) no puede crear una solicitud en Málaga (42501)',
  pg_temp.as_user('e2', format($q$select public.create_permit_application(p_id => %L, p_establishment_id => %L, p_organization => 'X')$q$, pg_temp.u('d5'), pg_temp.u('a2'))) = '42501');
select pg_temp.check('e4 no puede aprobar, denegar ni cancelar en Granada (sin revelar que existe)',
  pg_temp.as_user('e4', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('d3'))) = 'P0002'
  and pg_temp.as_user('e4', format($q$select public.resolve_permit_application(%L, 'denied')$q$, pg_temp.u('d3'))) = 'P0002');
select pg_temp.check('sin identificador o sin establecimiento: 22023',
  pg_temp.as_user('e2', $q$select public.create_permit_application(p_id => null, p_establishment_id => null)$q$) = '22023');
select pg_temp.check('anon no puede ejecutar la función nueva ni las modificadas',
  not has_function_privilege('anon', 'public.create_permit_application(uuid, uuid, text, integer, date, date, date, text, text, date, uuid, text)', 'execute')
  and not has_function_privilege('anon', 'public.approve_permit_application(uuid, timestamptz, date, date, text, integer)', 'execute')
  and not has_function_privilege('anon', 'public.resolve_permit_application(uuid, text, text, timestamptz)', 'execute')
  and not has_function_privilege('anon', 'public.cancel_permit_grant(uuid, text, timestamptz)', 'execute')
  and has_function_privilege('authenticated', 'public.create_permit_application(uuid, uuid, text, integer, date, date, date, text, text, date, uuid, text)', 'execute'));
select pg_temp.check('las cuatro funciones siguen siendo SECURITY INVOKER (mandan las políticas por provincia)',
  (select count(*) = 4 and bool_and(not prosecdef) from pg_proc where pronamespace = 'public'::regnamespace and proname in ('approve_permit_application', 'resolve_permit_application', 'cancel_permit_grant', 'create_permit_application')));

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from pa_results;
  for r in select * from pa_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'permit_atomic: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'permit_atomic: % comprobaciones correctas', total;
end $$;
rollback;
