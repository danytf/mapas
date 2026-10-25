-- Pruebas del borrado de solicitudes y concesiones con seguimientos (migración 20261025174656_followups_cascade_on_parent_delete). Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/followups_cascade.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-00000000c9' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Casc ' || s) from unnest(array['e1','e2']) s;
update public.profiles set role = 'admin' where id = pg_temp.u('e1');
insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '92', 'Casc Granada');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'Casc Mun', 'casc mun');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'casc_cat', 'Casc Cat');
insert into public.user_provinces (user_id, province_id, assigned_by) values (pg_temp.u('e2'), pg_temp.u('f1'), pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Casc Gr', 'casc gr', 'Calle 1', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1'));

create temp table fc_results (name text, ok boolean, detail text);
grant all on fc_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into fc_results values (p_name, coalesce(p_ok, false), p_detail) $$;
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
-- Resultados de las operaciones, guardados antes de comprobar el estado (Postgres evalúa las subconsultas de un AND antes que las funciones).
create temp table fc_r (k text primary key, v text);
grant all on fc_r to public;

-- Datos: b1 aprobada con concesión (y seguimientos en ambas); b2 con seguimiento; b3 sin seguimientos.
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'A', 1, '2026-11-02', '2026-11-03', null, null, null, '2026-10-30')$q$, pg_temp.u('b1'), pg_temp.u('a1')));
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'B', 1, '2026-11-02', '2026-11-03', null, null, null, '2026-10-30')$q$, pg_temp.u('b2'), pg_temp.u('a1')));
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'C', 1, '2026-11-02', '2026-11-03')$q$, pg_temp.u('b3'), pg_temp.u('a1')));
select pg_temp.as_user('e2', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b1')));
insert into public.followups (id, establishment_id, grant_id, due_on, created_by)
select pg_temp.u('d1'), pg_temp.u('a1'), id, '2026-11-05', pg_temp.u('e2') from public.permit_grants where application_id = pg_temp.u('b1');

-- Un usuario de la provincia no puede quitar nada (solo administradores): no da error, pero no se borra nada.
insert into fc_r values ('e2_app', pg_temp.as_user('e2', format($q$delete from public.permit_applications where id = %L$q$, pg_temp.u('b2'))));
insert into fc_r values ('e2_fu', pg_temp.as_user('e2', format($q$delete from public.followups where id = %L$q$, pg_temp.u('d1'))));
select pg_temp.check('un usuario normal no borra la solicitud (sigue con su seguimiento)',
  (select count(*) = 1 from public.permit_applications where id = pg_temp.u('b2')) and (select count(*) = 1 from public.followups where application_id = pg_temp.u('b2')));
select pg_temp.check('un usuario normal no borra seguimientos', (select count(*) = 1 from public.followups where id = pg_temp.u('d1')));
-- El trigger de seguridad sigue prohibiendo mover un seguimiento de expediente.
insert into fc_r values ('mover', pg_temp.as_user('e1', format($q$update public.followups set application_id = %L where application_id = %L$q$, pg_temp.u('b3'), pg_temp.u('b2'))));
insert into fc_r values ('anular', pg_temp.as_user('e1', format($q$update public.followups set application_id = null where application_id = %L$q$, pg_temp.u('b2'))));
select pg_temp.check('mover un seguimiento a otra solicitud sigue prohibido', (select v <> 'ok' from fc_r where k = 'mover'));
select pg_temp.check('dejar un seguimiento sin solicitud a mano sigue prohibido', (select v <> 'ok' from fc_r where k = 'anular'));

-- El administrador quita una solicitud con seguimiento: se va con él, sin error.
insert into fc_r values ('adm_b2', pg_temp.as_user('e1', format($q$delete from public.permit_applications where id = %L$q$, pg_temp.u('b2'))));
select pg_temp.check('el administrador quita una solicitud con seguimiento', (select v = 'ok' from fc_r where k = 'adm_b2'));
select pg_temp.check('…y desaparecen la solicitud y su seguimiento', (select count(*) = 0 from public.permit_applications where id = pg_temp.u('b2')) and (select count(*) = 0 from public.followups where application_id = pg_temp.u('b2')));
-- Una solicitud sin seguimientos se quita igual.
insert into fc_r values ('adm_b3', pg_temp.as_user('e1', format($q$delete from public.permit_applications where id = %L$q$, pg_temp.u('b3'))));
select pg_temp.check('quitar una solicitud sin seguimientos funciona', (select v = 'ok' from fc_r where k = 'adm_b3') and (select count(*) = 0 from public.permit_applications where id = pg_temp.u('b3')));
-- Una concesión con seguimiento propio se quita con él, y la solicitud de origen no se toca.
insert into fc_r values ('adm_g', pg_temp.as_user('e1', format($q$delete from public.permit_grants where application_id = %L$q$, pg_temp.u('b1'))));
select pg_temp.check('el administrador quita una concesión con seguimiento', (select v = 'ok' from fc_r where k = 'adm_g')
  and (select count(*) = 0 from public.permit_grants where application_id = pg_temp.u('b1')) and (select count(*) = 0 from public.followups where id = pg_temp.u('d1')));
select pg_temp.check('…y la solicitud de origen sigue existiendo con su seguimiento cerrado',
  (select count(*) = 1 from public.permit_applications where id = pg_temp.u('b1')) and (select count(*) = 1 from public.followups where application_id = pg_temp.u('b1') and completed_at is not null));
-- Con la concesión ya fuera, la solicitud aprobada (con su seguimiento cerrado) también se quita: el caso que fallaba en producción.
insert into fc_r values ('adm_b1', pg_temp.as_user('e1', format($q$delete from public.permit_applications where id = %L$q$, pg_temp.u('b1'))));
select pg_temp.check('quitar una solicitud aprobada con su seguimiento cerrado (caso real de producción)',
  (select v = 'ok' from fc_r where k = 'adm_b1') and (select count(*) = 0 from public.permit_applications where id = pg_temp.u('b1')) and (select count(*) = 0 from public.followups where application_id = pg_temp.u('b1')));
select pg_temp.check('los borrados de seguimientos quedan en la auditoría', (select count(*) >= 3 from public.audit_log where table_name = 'followups' and action = 'delete'));
select pg_temp.check('las claves foráneas son ON DELETE CASCADE y están validadas',
  (select count(*) = 2 from pg_constraint where conrelid = 'public.followups'::regclass and conname in ('followups_application_id_fkey', 'followups_grant_id_fkey') and confdeltype = 'c' and convalidated));

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from fc_results;
  for r in select * from fc_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'followups_cascade: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'followups_cascade: % comprobaciones correctas', total;
end $$;
rollback;
