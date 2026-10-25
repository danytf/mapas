-- Pruebas de la baja de un usuario que resolvió solicitudes (migración 20261025212400_allow_resolver_set_null_on_profile_delete). Una transacción que termina en ROLLBACK.
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/profile_delete_resolver.sql
begin;

create function pg_temp.u(sfx text) returns uuid language sql immutable as
$$ select ('00000000-0000-4000-8000-00000000d7' || sfx)::uuid $$;

select set_config('request.jwt.claim.sub', pg_temp.u('e1')::text, true);
insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Res ' || s) from unnest(array['e1','e2','e3']) s;
update public.profiles set role = 'admin' where id in (pg_temp.u('e1'), pg_temp.u('e3'));
insert into public.provinces (id, code, name) values (pg_temp.u('f1'), '93', 'Res Granada');
insert into public.municipalities (id, province_id, name, normalized_name) values (pg_temp.u('f3'), pg_temp.u('f1'), 'Res Mun', 'res mun');
insert into public.categories (id, code, name) values (pg_temp.u('f5'), 'res_cat', 'Res Cat');
insert into public.user_provinces (user_id, province_id, assigned_by) values (pg_temp.u('e2'), pg_temp.u('f1'), pg_temp.u('e1'));
insert into public.establishments (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values (pg_temp.u('a1'), pg_temp.u('f1'), pg_temp.u('f3'), pg_temp.u('f5'), 'Res Gr', 'res gr', 'Calle 1', 37.1, -3.6, pg_temp.u('e1'), pg_temp.u('e1'));

create temp table rd_results (name text, ok boolean, detail text);
grant all on rd_results to public;
create function pg_temp.check(p_name text, p_ok boolean, p_detail text default '') returns void language sql as
$$ insert into rd_results values (p_name, coalesce(p_ok, false), p_detail) $$;
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
-- Resultado de cada operación, guardado antes de comprobar el estado (Postgres evalúa las subconsultas de un AND antes que las funciones).
create temp table rd_r (k text primary key, v text);
grant all on rd_r to public;

-- Datos: b1 resuelta (aprobada) por la administradora e3, con su concesión; b2 sigue pendiente.
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'A', 1, '2026-11-02', '2026-11-03', null, null, null, '2026-10-30')$q$, pg_temp.u('b1'), pg_temp.u('a1')));
select pg_temp.as_user('e2', format($q$select public.create_permit_application(%L, %L, 'B', 1, '2026-11-02', '2026-11-03')$q$, pg_temp.u('b2'), pg_temp.u('a1')));
select pg_temp.as_user('e3', format($q$select public.approve_permit_application(%L)$q$, pg_temp.u('b1')));
-- Un seguimiento creado por e3 y asignado a e3 (como el que tenía el usuario real).
insert into public.followups (id, establishment_id, application_id, due_on, created_by, assigned_to)
values (pg_temp.u('d1'), pg_temp.u('a1'), pg_temp.u('b2'), '2026-11-05', pg_temp.u('e3'), pg_temp.u('e3'));
select pg_temp.check('la solicitud b1 quedó resuelta por e3',
  (select status = 'approved' and resolved_by = pg_temp.u('e3') and resolved_at is not null from public.permit_applications where id = pg_temp.u('b1')));

-- Como superusuario y sin auth.uid(), igual que el panel de Auth: así solo decide el trigger, no la RLS.
create function pg_temp.run(p_sql text) returns text language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', '', true);
  begin
    execute p_sql;
  exception when others then
    return sqlstate;
  end;
  return 'ok';
end $$;

-- Con la persona viva, la decisión sigue siendo inmutable: ni se anula ni se reasigna el autor de la decisión.
insert into rd_r values ('anular_vivo', pg_temp.run(format($q$update public.permit_applications set resolved_by = null where id = %L$q$, pg_temp.u('b1'))));
insert into rd_r values ('reasignar_vivo', pg_temp.run(format($q$update public.permit_applications set resolved_by = %L where id = %L$q$, pg_temp.u('e1'), pg_temp.u('b1'))));
select pg_temp.check('con el autor de la decisión vivo no se puede anular', (select v = '42501' from rd_r where k = 'anular_vivo'));
select pg_temp.check('con el autor de la decisión vivo no se puede reasignar', (select v = '42501' from rd_r where k = 'reasignar_vivo'));
select pg_temp.check('…y la decisión sigue atribuida a e3', (select resolved_by = pg_temp.u('e3') from public.permit_applications where id = pg_temp.u('b1')));

-- Baja real de e3 (borrado en Auth): antes fallaba con «La fecha y el autor de la decisión no se pueden modificar».
insert into rd_r values ('baja', pg_temp.run(format($q$delete from auth.users where id = %L$q$, pg_temp.u('e3'))));
select pg_temp.check('se puede dar de baja a quien resolvió una solicitud', (select v = 'ok' from rd_r where k = 'baja'), (select v from rd_r where k = 'baja'));
select pg_temp.check('…el perfil desaparece', (select count(*) = 0 from public.profiles where id = pg_temp.u('e3')));
select pg_temp.check('…la solicitud se conserva, sigue aprobada y con su fecha de decisión, sin autor de la decisión',
  (select status = 'approved' and resolved_at is not null and resolved_by is null and created_by = pg_temp.u('e2') from public.permit_applications where id = pg_temp.u('b1')));
select pg_temp.check('…la concesión que creó se conserva sin autor', (select count(*) = 1 from public.permit_grants where application_id = pg_temp.u('b1') and created_by is null));
select pg_temp.check('…el seguimiento se conserva sin autor ni responsable', (select count(*) = 1 from public.followups where id = pg_temp.u('d1') and created_by is null and assigned_to is null));
select pg_temp.check('…la otra solicitud no se toca', (select count(*) = 1 from public.permit_applications where id = pg_temp.u('b2') and status = 'pending'));

-- Una decisión huérfana no se puede volver a atribuir ni cambiar de estado.
insert into rd_r values ('atribuir_huerfana', pg_temp.run(format($q$update public.permit_applications set resolved_by = %L where id = %L$q$, pg_temp.u('e1'), pg_temp.u('b1'))));
insert into rd_r values ('fecha', pg_temp.run(format($q$update public.permit_applications set resolved_at = now() + interval '1 day' where id = %L$q$, pg_temp.u('b1'))));
insert into rd_r values ('estado', pg_temp.run(format($q$update public.permit_applications set status = 'denied' where id = %L$q$, pg_temp.u('b1'))));
select pg_temp.check('una decisión sin autor no se puede atribuir a otra persona', (select v = '42501' from rd_r where k = 'atribuir_huerfana'));
select pg_temp.check('la fecha de la decisión sigue siendo inmutable', (select v = '42501' from rd_r where k = 'fecha'));
select pg_temp.check('una solicitud resuelta sigue sin poder cambiar de estado', (select v = '23514' from rd_r where k = 'estado'));

do $$
declare r record; fallos int := 0; total int;
begin
  select count(*) into total from rd_results;
  for r in select * from rd_results where not ok loop
    raise warning 'FALLO: % (%)', r.name, r.detail; fallos := fallos + 1;
  end loop;
  if fallos > 0 then raise exception 'profile_delete_resolver: % de % comprobaciones fallan', fallos, total; end if;
  raise notice 'profile_delete_resolver: % comprobaciones correctas', total;
end $$;
rollback;
