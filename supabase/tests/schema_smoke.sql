do $$
begin
  if (select count(*) from public.provinces) <> 52 then
    raise exception 'FALLO: el seed no ha cargado las 52 provincias/códigos territoriales esperados';
  end if;
  if (select count(*) from public.categories where is_active) <> 17 then
    raise exception 'FALLO: la taxonomía activa del mapa debe contener 17 categorías';
  end if;
  if (select count(*) from public.categories) <> 28 then
    raise exception 'FALLO: se esperaba conservar 11 categorías de referencia antiguas como inactivas';
  end if;
end;
$$;

-- Smoke tests against vanilla PostgreSQL with a minimal Supabase Auth shim.
-- All IDs and data are fictitious and deterministic. This file does not touch production.

insert into auth.users (id, raw_user_meta_data) values
  ('00000000-0000-4000-8000-0000000000a1', '{"full_name":"Smoke Admin"}'::jsonb),
  ('00000000-0000-4000-8000-0000000000a2', '{"full_name":"Smoke User A"}'::jsonb),
  ('00000000-0000-4000-8000-0000000000a3', '{"full_name":"Smoke User B"}'::jsonb);

update public.profiles
set role = 'admin'
where id = '00000000-0000-4000-8000-0000000000a1';

update public.profiles
set role = 'user'
where id in (
  '00000000-0000-4000-8000-0000000000a2',
  '00000000-0000-4000-8000-0000000000a3'
);

insert into public.provinces (id, code, name) values
  ('00000000-0000-4000-8000-000000000001', '98', 'Smoke Province A'),
  ('00000000-0000-4000-8000-000000000002', '99', 'Smoke Province B');

insert into public.categories (id, code, name)
values ('00000000-0000-4000-8000-000000000003', 'smoke_category', 'Smoke Category');

insert into public.municipalities (id, province_id, name, normalized_name)
values (
  '00000000-0000-4000-8000-000000000004',
  '00000000-0000-4000-8000-000000000001',
  'Smoke Municipality A',
  'smoke municipality a'
);

insert into public.user_provinces (user_id, province_id, assigned_by) values
  ('00000000-0000-4000-8000-0000000000a2', '00000000-0000-4000-8000-000000000001', '00000000-0000-4000-8000-0000000000a1'),
  ('00000000-0000-4000-8000-0000000000a3', '00000000-0000-4000-8000-000000000002', '00000000-0000-4000-8000-0000000000a1');

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);

insert into public.establishments (
  id, province_id, municipality_id, category_id, name, normalized_name,
  address, latitude, longitude, created_by, updated_by
) values
  (
    '00000000-0000-4000-8000-000000000005',
    '00000000-0000-4000-8000-000000000001',
    '00000000-0000-4000-8000-000000000004',
    '00000000-0000-4000-8000-000000000003',
    'Smoke Establishment A', 'smoke establishment a',
    'Address before', 37.18, -3.60,
    '00000000-0000-4000-8000-0000000000a1',
    '00000000-0000-4000-8000-0000000000a1'
  ),
  (
    '00000000-0000-4000-8000-000000000006',
    '00000000-0000-4000-8000-000000000002',
    null,
    '00000000-0000-4000-8000-000000000003',
    'Smoke Establishment B', 'smoke establishment b',
    'Address B', 37.30, -3.20,
    '00000000-0000-4000-8000-0000000000a1',
    '00000000-0000-4000-8000-0000000000a1'
  );

insert into public.permit_applications (
  id, establishment_id, organization, created_by, updated_by
) values (
  '00000000-0000-4000-8000-000000000007',
  '00000000-0000-4000-8000-000000000005',
  'Smoke organization',
  '00000000-0000-4000-8000-0000000000a1',
  '00000000-0000-4000-8000-0000000000a1'
);

insert into public.permit_grants (
  id, establishment_id, application_id, organization, created_by, updated_by
) values (
  '00000000-0000-4000-8000-000000000008',
  '00000000-0000-4000-8000-000000000005',
  '00000000-0000-4000-8000-000000000007',
  'Smoke organization',
  '00000000-0000-4000-8000-0000000000a1',
  '00000000-0000-4000-8000-0000000000a1'
);

-- La base de datos debe rechazar cada relación incoherente.
do $$
begin
  begin
    insert into public.establishments (
      id, province_id, municipality_id, category_id, name, normalized_name, created_by, updated_by
    ) values (
      '00000000-0000-4000-8000-000000000009',
      '00000000-0000-4000-8000-000000000002',
      '00000000-0000-4000-8000-000000000004',
      '00000000-0000-4000-8000-000000000003',
      'Invalid municipality link', 'invalid municipality link',
      '00000000-0000-4000-8000-0000000000a1',
      '00000000-0000-4000-8000-0000000000a1'
    );
    raise exception 'FALLO: se permitió un municipio de otra provincia';
  exception when check_violation then
    null;
  end;

  begin
    insert into public.permit_grants (
      establishment_id, application_id, created_by, updated_by
    ) values (
      '00000000-0000-4000-8000-000000000006',
      '00000000-0000-4000-8000-000000000007',
      '00000000-0000-4000-8000-0000000000a1',
      '00000000-0000-4000-8000-0000000000a1'
    );
    raise exception 'FALLO: se permitió una concesión cruzada';
  exception when check_violation then
    null;
  end;

  begin
    insert into public.followups (
      establishment_id, grant_id, due_on, created_by
    ) values (
      '00000000-0000-4000-8000-000000000006',
      '00000000-0000-4000-8000-000000000008',
      current_date,
      '00000000-0000-4000-8000-0000000000a1'
    );
    raise exception 'FALLO: se permitió un seguimiento cruzado';
  exception when check_violation then
    null;
  end;

  begin
    update public.permit_applications
    set establishment_id = '00000000-0000-4000-8000-000000000006'
    where id = '00000000-0000-4000-8000-000000000007';
    raise exception 'FALLO: se permitió mover una solicitud con concesión asociada';
  exception when check_violation or insufficient_privilege then
    null;
  end;
end;
$$;

-- Cambio de dirección: debe generar historial y auditoría automáticamente.
update public.establishments
set address = 'Address after', updated_by = '00000000-0000-4000-8000-0000000000a1'
where id = '00000000-0000-4000-8000-000000000005';

do $$
declare
  history_count integer;
  audit_count integer;
begin
  select count(*) into history_count
  from public.establishment_location_history
  where establishment_id = '00000000-0000-4000-8000-000000000005'
    and old_address = 'Address before'
    and new_address = 'Address after';

  if history_count <> 1 then
    raise exception 'FALLO: el historial de ubicación no registró el cambio esperado';
  end if;

  select count(*) into audit_count
  from public.audit_log
  where table_name = 'establishments'
    and record_id = '00000000-0000-4000-8000-000000000005'
    and action = 'update'
    and details -> 'changed_fields' ? 'address';

  if audit_count < 1 then
    raise exception 'FALLO: no se encontró auditoría del cambio de dirección';
  end if;
end;
$$;

-- El rol authenticated no debe tener escritura directa en auditoría ni historial.
set role authenticated;
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
do $$
begin
  begin
    insert into public.audit_log (action, table_name) values ('forged', 'audit_log');
    raise exception 'FALLO: authenticated pudo escribir audit_log directamente';
  exception when insufficient_privilege then
    null;
  end;

  begin
    insert into public.establishment_location_history (establishment_id)
    values ('00000000-0000-4000-8000-000000000005');
    raise exception 'FALLO: authenticated pudo escribir historial directamente';
  exception when insufficient_privilege then
    null;
  end;
end;
$$;

-- Prueba de aislamiento provincial con llamadas bajo el rol API.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);

-- Standard users may update location fields, but not master identity/status or insert master rows.
do $master_write_test$
declare affected integer;
begin
  update public.establishments
  set address = address, latitude = latitude, longitude = longitude,
      location_precision = location_precision, location_source = location_source,
      location_verified_at = location_verified_at, updated_by = auth.uid()
  where id = '00000000-0000-4000-8000-000000000005';
  get diagnostics affected = row_count;
  if affected <> 1 then
    raise exception 'FALLO RLS: el usuario provincial no puede corregir la ubicación';
  end if;

  begin
    update public.establishments
    set name = name || ' forbidden', status = 'archived'
    where id = '00000000-0000-4000-8000-000000000005';
    get diagnostics affected = row_count;
    if affected > 0 then
      raise exception 'FALLO RLS: el usuario provincial pudo modificar nombre/estado del catálogo maestro';
    end if;
  exception when insufficient_privilege then
    null;
  end;

  begin
    insert into public.establishments (
      province_id, category_id, name, normalized_name, source_ref, status, created_by, updated_by
    ) values (
      '00000000-0000-4000-8000-000000000001',
      '00000000-0000-4000-8000-000000000003',
      'Forbidden master insert', 'forbidden master insert', 'rls-test:forbidden-master-insert',
      'archived', auth.uid(), auth.uid()
    );
    raise exception 'FALLO RLS: el usuario provincial pudo insertar un establecimiento maestro';
  exception when insufficient_privilege then
    null;
  end;
end;
$master_write_test$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
do $admin_master_write_test$
declare affected integer;
begin
  update public.establishments
  set name = name || ' admin edit'
  where id = '00000000-0000-4000-8000-000000000005';
  get diagnostics affected = row_count;
  if affected <> 1 then
    raise exception 'FALLO RLS: el administrador no puede actualizar el catálogo maestro';
  end if;
end;
$admin_master_write_test$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
do $$
declare visible_count integer;
begin
  select count(*) into visible_count
  from public.establishments
  where id = '00000000-0000-4000-8000-000000000006';
  if visible_count <> 0 then
    raise exception 'FALLO RLS: usuario A ve un establecimiento de provincia B';
  end if;
end;
$$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a3', false);
do $$
declare visible_count integer;
begin
  select count(*) into visible_count
  from public.establishments
  where id = '00000000-0000-4000-8000-000000000005';
  if visible_count <> 0 then
    raise exception 'FALLO RLS: usuario B ve un establecimiento de provincia A';
  end if;
end;
$$;
-- Pruebas negativas de escritura: conocer el UUID de otra provincia no concede acceso.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
do $cross_province_write_test$
declare affected integer;
begin
  update public.establishments
     set address = address
   where id = '00000000-0000-4000-8000-000000000006';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: el usuario de provincia A pudo actualizar un establecimiento de provincia B';
  end if;

  begin
    insert into public.user_app_state (user_id, state)
    values ('00000000-0000-4000-8000-0000000000a3', '{}'::jsonb);
    raise exception 'FALLO RLS: un usuario pudo crear estado personal para otra cuenta';
  exception when insufficient_privilege then
    null;
  end;

  begin
    insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
    values (
      '00000000-0000-4000-8000-000000000006',
      '00000000-0000-4000-8000-000000000002',
      '{"test":"cross-province-write"}'::jsonb,
      '00000000-0000-4000-8000-0000000000a2'
    );
    raise exception 'FALLO RLS: el usuario de provincia A pudo insertar estado operativo en provincia B';
  exception when insufficient_privilege then
    null;
  end;
end;
$cross_province_write_test$;

-- Un usuario normal no puede elevar su rol ni desactivar/reactivar su propia cuenta.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
do $self_privilege_escalation_test$
declare affected integer;
        profile_role text;
begin
  begin
    update public.profiles
       set role = 'admin'
     where id = '00000000-0000-4000-8000-0000000000a2';
    get diagnostics affected = row_count;
    if affected <> 0 then
      raise exception 'FALLO RLS: un usuario pudo elevar su propio rol a admin';
    end if;
  exception when insufficient_privilege then
    null;
  end;

  select role into profile_role
    from public.profiles
   where id = '00000000-0000-4000-8000-0000000000a2';
  if profile_role <> 'user' then
    raise exception 'FALLO SEGURIDAD: el rol del usuario cambió sin autorización';
  end if;
end;
$self_privilege_escalation_test$;

-- Aislamiento del estado personal: la cuenta B no debe leer la fila de A.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
insert into public.user_app_state (user_id, state)
values ('00000000-0000-4000-8000-0000000000a2', '{"gamification":{"lvl":3},"badges":{"test":"A"}}'::jsonb);

do $rls_test$
declare visible_count integer;
begin
  select count(*) into visible_count from public.user_app_state
  where user_id = '00000000-0000-4000-8000-0000000000a2';
  if visible_count <> 1 then
    raise exception 'FALLO RLS: el propietario no puede leer su estado personal';
  end if;
end;
$rls_test$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a3', false);
do $rls_test$
declare visible_count integer;
begin
  select count(*) into visible_count from public.user_app_state
  where user_id = '00000000-0000-4000-8000-0000000000a2';
  if visible_count <> 0 then
    raise exception 'FALLO RLS: la cuenta B puede leer el estado personal de A';
  end if;
end;
$rls_test$;

-- El estado operativo de un establecimiento es compartido dentro de su provincia,
-- pero no debe filtrarse a usuarios asignados a otra provincia.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
insert into public.establishment_app_state (establishment_id, province_id, state, updated_by)
values (
  '00000000-0000-4000-8000-000000000005',
  '00000000-0000-4000-8000-000000000001',
  '{"permit":{"status":"smoke-test"}}'::jsonb,
  '00000000-0000-4000-8000-0000000000a3'
);

do $rls_test$
declare visible_count integer;
begin
  select count(*) into visible_count from public.establishment_app_state
  where establishment_id = '00000000-0000-4000-8000-000000000005';
  if visible_count <> 1 then
    raise exception 'FALLO RLS: el usuario asignado no puede leer el estado operativo provincial';
  end if;
  if (select updated_by from public.establishment_app_state
      where establishment_id = '00000000-0000-4000-8000-000000000005')
      <> '00000000-0000-4000-8000-0000000000a2' then
    raise exception 'FALLO: el estado compartido permite suplantar updated_by';
  end if;
end;
$rls_test$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a3', false);
do $rls_test$
declare visible_count integer;
begin
  select count(*) into visible_count from public.establishment_app_state
  where establishment_id = '00000000-0000-4000-8000-000000000005';
  if visible_count <> 0 then
    raise exception 'FALLO RLS: la cuenta de provincia B puede leer el estado operativo de A';
  end if;
end;
$rls_test$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
do $shared_state_integrity_test$
begin
  begin
    update public.establishment_app_state
       set province_id = '00000000-0000-4000-8000-000000000002'
     where establishment_id = '00000000-0000-4000-8000-000000000005';
    raise exception 'FALLO: el estado compartido se pudo reasignar a una provincia incorrecta';
  exception when check_violation or insufficient_privilege then
    null;
  end;
end;
$shared_state_integrity_test$;

do $rls_test$
declare visible_count integer;
begin
  select count(*) into visible_count from public.establishment_app_state
  where establishment_id = '00000000-0000-4000-8000-000000000005';
  if visible_count <> 1 then
    raise exception 'FALLO RLS: el administrador no puede leer estado operativo interprovincial';
  end if;
end;
$rls_test$;

do $function_privilege_test$
begin
  if has_function_privilege('anon', 'public.guard_establishment_app_state()', 'EXECUTE')
     or has_function_privilege('authenticated', 'public.guard_establishment_app_state()', 'EXECUTE') then
    raise exception 'FALLO SEGURIDAD: la función trigger de estado compartido se puede invocar como RPC';
  end if;
end;
$function_privilege_test$;

-- Invariantes de seguridad para todas las funciones SECURITY DEFINER propias.
-- Evita que una nueva función privilegiada se publique sin search_path fijo
-- o quede invocable por el rol anónimo de la API.
do $security_definer_invariants$
declare
  fn record;
begin
  if has_schema_privilege('anon', 'private', 'USAGE') then
    raise exception 'FALLO SEGURIDAD: el rol anon tiene USAGE sobre el esquema private';
  end if;

  for fn in
    select n.nspname, p.oid, p.proname, p.proconfig
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname in ('public', 'private')
      and p.prosecdef
  loop
    if fn.proconfig is null or not exists (
      select 1
      from unnest(fn.proconfig) setting
      where setting like 'search_path=%'
    ) then
      raise exception 'FALLO SEGURIDAD: %.% SECURITY DEFINER no fija search_path',
        fn.nspname, fn.proname;
    end if;

    if has_function_privilege('anon', fn.oid, 'EXECUTE') then
      raise exception 'FALLO SEGURIDAD: anon puede ejecutar %.%',
        fn.nspname, fn.proname;
    end if;
  end loop;
end;
$security_definer_invariants$;
do $state_table_privilege_test$
begin
  if has_table_privilege('authenticated', 'public.user_app_state', 'DELETE')
     or has_table_privilege('authenticated', 'public.user_app_state', 'TRUNCATE')
     or has_table_privilege('authenticated', 'public.user_app_state', 'REFERENCES')
     or has_table_privilege('authenticated', 'public.user_app_state', 'TRIGGER')
     or has_table_privilege('authenticated', 'public.establishment_app_state', 'DELETE')
     or has_table_privilege('authenticated', 'public.establishment_app_state', 'TRUNCATE')
     or has_table_privilege('authenticated', 'public.establishment_app_state', 'REFERENCES')
     or has_table_privilege('authenticated', 'public.establishment_app_state', 'TRIGGER') then
    raise exception 'FALLO SEGURIDAD: las tablas de estado conceden privilegios API innecesarios';
  end if;
  if not has_table_privilege('authenticated', 'public.user_app_state', 'SELECT')
     or not has_table_privilege('authenticated', 'public.user_app_state', 'INSERT')
     or not has_table_privilege('authenticated', 'public.user_app_state', 'UPDATE')
     or not has_table_privilege('authenticated', 'public.establishment_app_state', 'SELECT')
     or not has_table_privilege('authenticated', 'public.establishment_app_state', 'INSERT')
     or not has_table_privilege('authenticated', 'public.establishment_app_state', 'UPDATE') then
    raise exception 'FALLO: faltan privilegios necesarios para el estado de la aplicación';
  end if;
end;
$state_table_privilege_test$;


-- Una cuenta desactivada pierde el acceso provincial incluso si conserva asignaciones.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
update public.profiles
set is_active = false
where id = '00000000-0000-4000-8000-0000000000a2';

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
do $inactive_user_scope_test$
declare establishment_count integer;
        shared_state_count integer;
begin
  select count(*) into establishment_count
  from public.establishments
  where id = '00000000-0000-4000-8000-000000000005';

  if establishment_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada conserva acceso al catálogo provincial';
  end if;

  select count(*) into shared_state_count
  from public.establishment_app_state
  where establishment_id = '00000000-0000-4000-8000-000000000005';

  if shared_state_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada conserva acceso al estado operativo provincial';
  end if;
end;
$inactive_user_scope_test$;

-- Timestamp trigger functions must not be executable as public API RPCs.
do $timestamp_trigger_privilege_test$
begin
  if has_function_privilege('anon', 'public.set_user_app_state_updated_at()', 'EXECUTE')
     or has_function_privilege('authenticated', 'public.set_user_app_state_updated_at()', 'EXECUTE')
     or has_function_privilege('anon', 'public.set_establishment_app_state_updated_at()', 'EXECUTE')
     or has_function_privilege('authenticated', 'public.set_establishment_app_state_updated_at()', 'EXECUTE') then
    raise exception 'FALLO SEGURIDAD: una función trigger de actualización temporal es ejecutable desde la API';
  end if;
end;
$timestamp_trigger_privilege_test$;

reset role;

select 'schema smoke tests passed' as result;
