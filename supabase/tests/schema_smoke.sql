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
  ('00000000-0000-4000-8000-0000000000a3', '{"full_name":"Smoke User B"}'::jsonb),
  ('00000000-0000-4000-8000-0000000000a4', '{"full_name":"Smoke Inactive User"}'::jsonb);

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
values
  ('00000000-0000-4000-8000-000000000003', 'smoke_category', 'Smoke Category'),
  ('00000000-0000-4000-8000-0000000000d1', 'rls_matrix_delete_category', 'RLS Matrix Delete Category');

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

-- Child records in province B let the RLS tests distinguish cross-scope denial
-- from unrelated FK/trigger failures.
insert into public.permit_applications (
  id, establishment_id, organization, created_by, updated_by
) values (
  '00000000-0000-4000-8000-0000000000c1',
  '00000000-0000-4000-8000-000000000006',
  'Smoke organization B',
  '00000000-0000-4000-8000-0000000000a1',
  '00000000-0000-4000-8000-0000000000a1'
);

insert into public.permit_grants (
  id, establishment_id, application_id, organization, created_by, updated_by
) values (
  '00000000-0000-4000-8000-0000000000c2',
  '00000000-0000-4000-8000-000000000006',
  '00000000-0000-4000-8000-0000000000c1',
  'Smoke organization B',
  '00000000-0000-4000-8000-0000000000a1',
  '00000000-0000-4000-8000-0000000000a1'
);

insert into public.followups (
  id, establishment_id, grant_id, due_on, created_by
) values (
  '00000000-0000-4000-8000-0000000000c3',
  '00000000-0000-4000-8000-000000000006',
  '00000000-0000-4000-8000-0000000000c2',
  current_date,
  '00000000-0000-4000-8000-0000000000a1'
);

-- Cross-province fixtures for shared state and location proposals.
insert into public.establishment_app_state (
  establishment_id, province_id, state, updated_by
) values (
  '00000000-0000-4000-8000-000000000006',
  '00000000-0000-4000-8000-000000000002',
  '{"fixture":"province-b-state"}'::jsonb,
  '00000000-0000-4000-8000-0000000000a1'
);

insert into public.establishment_location_reviews (
  id, establishment_id, status, proposed_latitude, proposed_longitude,
  proposed_address, source, notes, created_by
) values (
  '00000000-0000-4000-8000-0000000000c4',
  '00000000-0000-4000-8000-000000000006',
  'pending', 37.301, -3.201, 'Province B proposal', 'manual_google_maps',
  'Cross-province RLS fixture', '00000000-0000-4000-8000-0000000000a1'
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
-- Las propuestas de ubicación son editables por su autor solo al crearlas; decidirlas es tarea administrativa.
-- El usuario A puede registrar una propuesta para su provincia, pero no aceptarla ni suplantar al revisor.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
insert into public.establishment_location_reviews (
  id, establishment_id, status, proposed_latitude, proposed_longitude,
  proposed_address, source, notes, created_by
) values (
  '00000000-0000-4000-8000-0000000000b1',
  '00000000-0000-4000-8000-000000000005',
  'pending', 37.181, -3.601, 'Proposed address', 'manual_google_maps',
  'Smoke test proposal', '00000000-0000-4000-8000-0000000000a2'
);

-- A provincial user cannot smuggle an already-approved proposal through INSERT.
do $location_review_insert_decision_test$
begin
  begin
    insert into public.establishment_location_reviews (
      id, establishment_id, status, proposed_latitude, proposed_longitude,
      proposed_address, source, notes, reviewed_by, reviewed_at, created_by
    ) values (
      '00000000-0000-4000-8000-0000000000b2',
      '00000000-0000-4000-8000-000000000005',
      'accepted', 37.182, -3.602, 'Forged accepted address', 'manual_google_maps',
      'Must be rejected on insert', '00000000-0000-4000-8000-0000000000a2', now(),
      '00000000-0000-4000-8000-0000000000a2'
    );
    raise exception 'FALLO SEGURIDAD: usuario provincial insertó una propuesta ya aceptada';
  exception when insufficient_privilege then
    null;
  end;

  if exists (select 1 from public.establishment_location_reviews
              where id = '00000000-0000-4000-8000-0000000000b2') then
    raise exception 'FALLO SEGURIDAD: persistió una propuesta con decisión falsificada';
  end if;
end;
$location_review_insert_decision_test$;

update public.establishment_location_reviews
   set status = 'accepted',
       reviewed_by = '00000000-0000-4000-8000-0000000000a2',
       reviewed_at = now()
 where id = '00000000-0000-4000-8000-0000000000b1';

do $location_review_decision_test$
declare saved_status text;
        saved_reviewer uuid;
        saved_reviewed_at timestamptz;
begin
  select status, reviewed_by, reviewed_at
    into saved_status, saved_reviewer, saved_reviewed_at
    from public.establishment_location_reviews
   where id = '00000000-0000-4000-8000-0000000000b1';

  if saved_status <> 'pending' or saved_reviewer is not null or saved_reviewed_at is not null then
    raise exception 'FALLO SEGURIDAD: un usuario ordinario pudo decidir su propia propuesta de ubicación';
  end if;
end;
$location_review_decision_test$;

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

  begin
    update public.establishment_location_history
       set new_address = 'forged history update'
     where establishment_id = '00000000-0000-4000-8000-000000000005';
    raise exception 'FALLO: authenticated pudo modificar historial directamente';
  exception when insufficient_privilege then
    null;
  end;

  begin
    delete from public.establishment_location_history
     where establishment_id = '00000000-0000-4000-8000-000000000005';
    raise exception 'FALLO: authenticated pudo borrar historial directamente';
  exception when insufficient_privilege then
    null;
  end;

  begin
    update public.audit_log set action = 'forged'
     where table_name = 'establishments';
    raise exception 'FALLO: authenticated pudo modificar audit_log directamente';
  exception when insufficient_privilege then
    null;
  end;

  begin
    delete from public.audit_log where table_name = 'establishments';
    raise exception 'FALLO: authenticated pudo borrar audit_log directamente';
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

  update public.permit_applications
     set notes = 'cross-province write must not persist'
   where id = '00000000-0000-4000-8000-0000000000c1';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario A pudo actualizar una solicitud de provincia B';
  end if;

  update public.permit_grants
     set notes = 'cross-province write must not persist'
   where id = '00000000-0000-4000-8000-0000000000c2';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario A pudo actualizar una concesión de provincia B';
  end if;

  update public.followups
     set notes = 'cross-province write must not persist'
   where id = '00000000-0000-4000-8000-0000000000c3';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario A pudo actualizar un seguimiento de provincia B';
  end if;

  update public.establishment_app_state
     set state = '{"cross_province_write":true}'::jsonb,
         updated_by = auth.uid()
   where establishment_id = '00000000-0000-4000-8000-000000000006';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario A pudo actualizar estado compartido de provincia B';
  end if;

  update public.establishment_location_reviews
     set proposed_address = 'forbidden cross-province edit'
   where id = '00000000-0000-4000-8000-0000000000c4';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario A pudo actualizar propuesta de ubicación de provincia B';
  end if;

  begin
    insert into public.establishment_location_reviews (
      establishment_id, status, proposed_address, source, created_by
    ) values (
      '00000000-0000-4000-8000-000000000006',
      'pending', 'Forbidden cross-province proposal', 'manual_google_maps', auth.uid()
    );
    raise exception 'FALLO RLS: usuario A pudo insertar propuesta en provincia B';
  exception when insufficient_privilege then
    null;
  end;

  begin
    insert into public.permit_applications (
      establishment_id, organization, created_by, updated_by
    ) values (
      '00000000-0000-4000-8000-000000000006',
      'Cross-province forbidden',
      auth.uid(), auth.uid()
    );
    raise exception 'FALLO RLS: usuario A pudo insertar solicitud en provincia B';
  exception when insufficient_privilege then
    null;
  end;

  begin
    insert into public.permit_grants (
      establishment_id, organization, created_by, updated_by
    ) values (
      '00000000-0000-4000-8000-000000000006',
      'Cross-province forbidden',
      auth.uid(), auth.uid()
    );
    raise exception 'FALLO RLS: usuario A pudo insertar concesión en provincia B';
  exception when insufficient_privilege then
    null;
  end;

  begin
    insert into public.followups (
      establishment_id, grant_id, due_on, created_by
    ) values (
      '00000000-0000-4000-8000-000000000006',
      '00000000-0000-4000-8000-0000000000c2',
      current_date,
      auth.uid()
    );
    raise exception 'FALLO RLS: usuario A pudo insertar seguimiento en provincia B';
  exception when insufficient_privilege then
    null;
  end;

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

-- Un usuario ordinario no puede modificar perfiles ni asignarse provincias.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
do $profile_and_province_grant_test$
declare affected integer;
        assigned_count integer;
        profile_role text;
begin
  begin
    update public.profiles
       set is_active = false
     where id = '00000000-0000-4000-8000-0000000000a3';
    get diagnostics affected = row_count;
    if affected <> 0 then
      raise exception 'FALLO RLS: un usuario normal pudo modificar el perfil de otra cuenta';
    end if;
  exception when insufficient_privilege then
    null;
  end;

  begin
    insert into public.user_provinces (user_id, province_id, assigned_by)
    values (
      '00000000-0000-4000-8000-0000000000a2',
      '00000000-0000-4000-8000-000000000002',
      '00000000-0000-4000-8000-0000000000a2'
    );
    raise exception 'FALLO RLS: un usuario normal pudo asignarse una provincia adicional';
  exception when insufficient_privilege then
    null;
  end;

  select count(*) into assigned_count
    from public.user_provinces
   where user_id = '00000000-0000-4000-8000-0000000000a2';
  if assigned_count <> 1 then
    raise exception 'FALLO SEGURIDAD: la asignación provincial del usuario cambió sin autorización';
  end if;

  select role into profile_role
    from public.profiles
   where id = '00000000-0000-4000-8000-0000000000a3';
  if profile_role <> 'user' then
    raise exception 'FALLO SEGURIDAD: el perfil de otra cuenta fue alterado';
  end if;
end;
$profile_and_province_grant_test$;

-- Los seguimientos permiten actualizar sus campos operativos, pero no falsificar autoría.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
insert into public.followups (
  id, establishment_id, grant_id, due_on, outcome, created_by
) values (
  '00000000-0000-4000-8000-0000000000a9',
  '00000000-0000-4000-8000-000000000005',
  '00000000-0000-4000-8000-000000000008',
  current_date,
  'pendiente',
  '00000000-0000-4000-8000-0000000000a2'
);
update public.followups
   set outcome = 'contactado'
 where id = '00000000-0000-4000-8000-0000000000a9';

do $followup_attribution_test$
declare saved_creator uuid;
        saved_outcome text;
begin
  select created_by, outcome into saved_creator, saved_outcome
    from public.followups
   where id = '00000000-0000-4000-8000-0000000000a9';

  if saved_creator <> '00000000-0000-4000-8000-0000000000a2' then
    raise exception 'FALLO SEGURIDAD: se alteró la autoría del seguimiento';
  end if;
  if saved_outcome <> 'contactado' then
    raise exception 'FALLO: un usuario autorizado no pudo actualizar un seguimiento';
  end if;

  begin
    update public.followups
       set created_by = '00000000-0000-4000-8000-0000000000a3'
     where id = '00000000-0000-4000-8000-0000000000a9';
    raise exception 'FALLO SEGURIDAD: se permitió reescribir created_by en un seguimiento';
  exception when insufficient_privilege then
    null;
  end;
end;
$followup_attribution_test$;

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
where id in (
  '00000000-0000-4000-8000-0000000000a2',
  '00000000-0000-4000-8000-0000000000a4'
);

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
  select count(*) into establishment_count
  from public.permit_applications
  where id = '00000000-0000-4000-8000-000000000007';
  if establishment_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada conserva acceso a solicitudes';
  end if;

  select count(*) into establishment_count
  from public.permit_grants
  where id = '00000000-0000-4000-8000-000000000008';
  if establishment_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada conserva acceso a concesiones';
  end if;

  select count(*) into establishment_count
  from public.followups
  where id = '00000000-0000-4000-8000-0000000000a9';
  if establishment_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada conserva acceso a seguimientos';
  end if;

  select count(*) into establishment_count
  from public.establishment_location_reviews
  where id = '00000000-0000-4000-8000-0000000000b1';
  if establishment_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada conserva acceso a propuestas de ubicación';
  end if;

  update public.permit_applications set notes = 'inactive write must not persist'
   where id = '00000000-0000-4000-8000-000000000007';
  get diagnostics shared_state_count = row_count;
  if shared_state_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada pudo actualizar solicitudes';
  end if;

  update public.permit_grants set notes = 'inactive write must not persist'
   where id = '00000000-0000-4000-8000-000000000008';
  get diagnostics shared_state_count = row_count;
  if shared_state_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada pudo actualizar concesiones';
  end if;

  update public.followups set notes = 'inactive write must not persist'
   where id = '00000000-0000-4000-8000-0000000000a9';
  get diagnostics shared_state_count = row_count;
  if shared_state_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada pudo actualizar seguimientos';
  end if;

  delete from public.permit_applications where id = '00000000-0000-4000-8000-000000000007';
  get diagnostics shared_state_count = row_count;
  if shared_state_count <> 0 then raise exception 'FALLO RLS: una cuenta desactivada borró solicitudes'; end if;

  delete from public.permit_grants where id = '00000000-0000-4000-8000-000000000008';
  get diagnostics shared_state_count = row_count;
  if shared_state_count <> 0 then raise exception 'FALLO RLS: una cuenta desactivada borró concesiones'; end if;

  delete from public.followups where id = '00000000-0000-4000-8000-0000000000a9';
  get diagnostics shared_state_count = row_count;
  if shared_state_count <> 0 then raise exception 'FALLO RLS: una cuenta desactivada borró seguimientos'; end if;

  begin
    insert into public.permit_applications (establishment_id, organization, created_by, updated_by)
    values ('00000000-0000-4000-8000-000000000005', 'Inactive user forbidden', auth.uid(), auth.uid());
    raise exception 'FALLO RLS: una cuenta desactivada insertó una solicitud';
  exception when insufficient_privilege then null;
  end;

  begin
    insert into public.permit_grants (establishment_id, organization, created_by, updated_by)
    values ('00000000-0000-4000-8000-000000000005', 'Inactive user forbidden', auth.uid(), auth.uid());
    raise exception 'FALLO RLS: una cuenta desactivada insertó una concesión';
  exception when insufficient_privilege then null;
  end;

  begin
    insert into public.followups (establishment_id, grant_id, due_on, created_by)
    values ('00000000-0000-4000-8000-000000000005',
            '00000000-0000-4000-8000-000000000008', current_date, auth.uid());
    raise exception 'FALLO RLS: una cuenta desactivada insertó un seguimiento';
  exception when insufficient_privilege then null;
  end;
end;
$inactive_user_scope_test$;

-- Reactivate user A only for the active-user province/role matrix below.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
update public.profiles set is_active = true
where id = '00000000-0000-4000-8000-0000000000a2';
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);

-- Phase 2.1: explicit operation-coverage matrix for every public table.
-- This verifies the intended command surface exists; behavioural tests below/above
-- exercise row-level scope and denied writes with synthetic fixtures.
do $rls_policy_matrix$
declare
  item record;
  expected text[];
  missing text[];
  rls_enabled boolean;
begin
  for item in
    select * from (values
      ('audit_log', array['SELECT']::text[]),
      ('categories', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('establishment_app_state', array['SELECT','INSERT','UPDATE']::text[]),
      ('establishment_location_history', array['SELECT']::text[]),
      ('establishment_location_reviews', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('establishments', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('followups', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('import_batches', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('import_records', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('municipalities', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('permit_applications', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('permit_grants', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('profiles', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('provinces', array['SELECT','INSERT','UPDATE','DELETE']::text[]),
      ('user_app_state', array['SELECT','INSERT','UPDATE']::text[]),
      ('user_provinces', array['SELECT','INSERT','UPDATE','DELETE']::text[])
    ) as matrix(table_name, commands)
  loop
    select c.relrowsecurity into rls_enabled
      from pg_class c
      join pg_namespace n on n.oid = c.relnamespace
     where n.nspname = 'public' and c.relname = item.table_name and c.relkind = 'r';
    if coalesce(rls_enabled, false) is not true then
      raise exception 'FALLO RLS: public.% no tiene RLS habilitado', item.table_name;
    end if;

    if exists (
      select 1
        from pg_policies p
        cross join lateral unnest(p.roles) as policy_role(role_name)
       where p.schemaname = 'public'
         and p.tablename = item.table_name
         and policy_role.role_name::text in ('anon', 'public')
    ) then
      raise exception 'FALLO RLS: public.% tiene una política asignada a anon/public', item.table_name;
    end if;

    select array_agg(command order by command) into missing
    from unnest(item.commands) as u(command)
    where not exists (
      select 1 from pg_policies p
      where p.schemaname = 'public'
        and p.tablename = item.table_name
        and (p.cmd = command or p.cmd = 'ALL')
    );
    if coalesce(array_length(missing, 1), 0) > 0 then
      raise exception 'FALLO RLS: faltan políticas para public.% operaciones %',
        item.table_name, missing;
    end if;
  end loop;
end;
$rls_policy_matrix$;

-- Import staging tables are strictly administrator-only for all CRUD operations.
-- Fixtures are synthetic and created/deleted in this disposable test database.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
insert into public.import_batches (id, source_name, started_by, summary)
values (
  '00000000-0000-4000-8000-0000000000d4',
  'RLS matrix synthetic batch',
  '00000000-0000-4000-8000-0000000000a1',
  '{"test_fixture":true}'::jsonb
);
insert into public.import_records (id, batch_id, source_row, payload)
values (
  '00000000-0000-4000-8000-0000000000d5',
  '00000000-0000-4000-8000-0000000000d4',
  1,
  '{"test_fixture":true}'::jsonb
);

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
do $import_tables_non_admin_matrix$
declare visible_count integer; affected integer;
begin
  select count(*) into visible_count from public.import_batches
   where id = '00000000-0000-4000-8000-0000000000d4';
  if visible_count <> 0 then raise exception 'FALLO RLS: usuario normal leyó un lote de importación'; end if;

  select count(*) into visible_count from public.import_records
   where id = '00000000-0000-4000-8000-0000000000d5';
  if visible_count <> 0 then raise exception 'FALLO RLS: usuario normal leyó un registro de importación'; end if;

  update public.import_batches set summary = '{"forbidden":true}'::jsonb
   where id = '00000000-0000-4000-8000-0000000000d4';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario normal actualizó un lote de importación'; end if;

  update public.import_records set payload = '{"forbidden":true}'::jsonb
   where id = '00000000-0000-4000-8000-0000000000d5';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario normal actualizó un registro de importación'; end if;

  delete from public.import_records where id = '00000000-0000-4000-8000-0000000000d5';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario normal borró un registro de importación'; end if;

  delete from public.import_batches where id = '00000000-0000-4000-8000-0000000000d4';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario normal borró un lote de importación'; end if;

  begin
    insert into public.import_batches (source_name, started_by)
    values ('Forbidden non-admin batch', auth.uid());
    raise exception 'FALLO RLS: usuario normal insertó un lote de importación';
  exception when insufficient_privilege then null;
  end;

  begin
    insert into public.import_records (batch_id, payload)
    values ('00000000-0000-4000-8000-0000000000d4', '{}'::jsonb);
    raise exception 'FALLO RLS: usuario normal insertó un registro de importación';
  exception when insufficient_privilege then null;
  end;
end;
$import_tables_non_admin_matrix$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
do $import_tables_admin_matrix$
declare visible_count integer; affected integer;
begin
  select count(*) into visible_count from public.import_batches
   where id = '00000000-0000-4000-8000-0000000000d4';
  if visible_count <> 1 then raise exception 'FALLO RLS: administrador no leyó lote de importación'; end if;

  select count(*) into visible_count from public.import_records
   where id = '00000000-0000-4000-8000-0000000000d5';
  if visible_count <> 1 then raise exception 'FALLO RLS: administrador no leyó registro de importación'; end if;

  update public.import_batches set summary = '{"admin_update":true}'::jsonb
   where id = '00000000-0000-4000-8000-0000000000d4';
  get diagnostics affected = row_count;
  if affected <> 1 then raise exception 'FALLO RLS: administrador no actualizó lote de importación'; end if;

  update public.import_records set payload = '{"admin_update":true}'::jsonb
   where id = '00000000-0000-4000-8000-0000000000d5';
  get diagnostics affected = row_count;
  if affected <> 1 then raise exception 'FALLO RLS: administrador no actualizó registro de importación'; end if;

  delete from public.import_records where id = '00000000-0000-4000-8000-0000000000d5';
  get diagnostics affected = row_count;
  if affected <> 1 then raise exception 'FALLO RLS: administrador no borró registro de importación'; end if;

  delete from public.import_batches where id = '00000000-0000-4000-8000-0000000000d4';
  get diagnostics affected = row_count;
  if affected <> 1 then raise exception 'FALLO RLS: administrador no borró lote de importación'; end if;
end;
$import_tables_admin_matrix$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);

-- Cross-province SELECT must hide child records as well as the establishment itself.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
do $cross_province_select_matrix$
declare visible_count integer;
begin
  select count(*) into visible_count from public.permit_applications
   where id = '00000000-0000-4000-8000-0000000000c1';
  if visible_count <> 0 then raise exception 'FALLO RLS: usuario A ve solicitud de provincia B'; end if;

  select count(*) into visible_count from public.permit_grants
   where id = '00000000-0000-4000-8000-0000000000c2';
  if visible_count <> 0 then raise exception 'FALLO RLS: usuario A ve concesión de provincia B'; end if;

  select count(*) into visible_count from public.followups
   where id = '00000000-0000-4000-8000-0000000000c3';
  if visible_count <> 0 then raise exception 'FALLO RLS: usuario A ve seguimiento de provincia B'; end if;

  select count(*) into visible_count from public.establishment_app_state
   where establishment_id = '00000000-0000-4000-8000-000000000006';
  if visible_count <> 0 then raise exception 'FALLO RLS: usuario A ve estado compartido de provincia B'; end if;

  select count(*) into visible_count from public.establishment_location_reviews
   where id = '00000000-0000-4000-8000-0000000000c4';
  if visible_count <> 0 then raise exception 'FALLO RLS: usuario A ve propuesta de ubicación de provincia B'; end if;
end;
$cross_province_select_matrix$;

-- Users without province scope must not delete records in another province.
do $cross_province_delete_matrix$
declare affected integer;
begin
  delete from public.establishments where id = '00000000-0000-4000-8000-000000000006';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario A borró establecimiento de provincia B'; end if;

  delete from public.permit_applications where id = '00000000-0000-4000-8000-0000000000c1';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario A borró solicitud de provincia B'; end if;

  delete from public.permit_grants where id = '00000000-0000-4000-8000-0000000000c2';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario A borró concesión de provincia B'; end if;

  delete from public.followups where id = '00000000-0000-4000-8000-0000000000c3';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario A borró seguimiento de provincia B'; end if;
end;
$cross_province_delete_matrix$;

-- Ordinary users cannot delete even globally readable catalogue reference rows;
-- administrators can delete an isolated synthetic fixture.
do $category_delete_matrix$
declare affected integer;
begin
  perform set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
  delete from public.categories where id = '00000000-0000-4000-8000-0000000000d1';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario provincial pudo borrar una categoría de referencia';
  end if;

  perform set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
  delete from public.categories where id = '00000000-0000-4000-8000-0000000000d1';
  get diagnostics affected = row_count;
  if affected <> 1 then
    raise exception 'FALLO RLS: administrador no pudo borrar el fixture aislado de categoría';
  end if;
end;
$category_delete_matrix$;

-- Same-province operational DELETE is still administrator-only.
-- Cross-province tests alone would not catch a policy accidentally widened to all scoped users.
do $same_province_delete_matrix$
declare affected integer;
begin
  perform set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);

  delete from public.permit_applications where id = '00000000-0000-4000-8000-000000000007';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario provincial borró una solicitud de su propia provincia';
  end if;

  delete from public.permit_grants where id = '00000000-0000-4000-8000-000000000008';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario provincial borró una concesión de su propia provincia';
  end if;

  delete from public.followups where id = '00000000-0000-4000-8000-0000000000a9';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario provincial borró un seguimiento de su propia provincia';
  end if;
end;
$same_province_delete_matrix$;

-- Global reference data and identity/assignment tables are admin-write-only.
do $admin_only_writes_matrix$
declare affected integer; visible_count integer;
begin
  update public.categories set name = name || ' forbidden'
   where id = '00000000-0000-4000-8000-000000000003';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario normal actualizó categorías'; end if;

  update public.municipalities set name = name || ' forbidden'
   where id = '00000000-0000-4000-8000-000000000004';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario normal actualizó municipios'; end if;

  update public.provinces set name = name || ' forbidden'
   where id = '00000000-0000-4000-8000-000000000001';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario normal actualizó provincias'; end if;

  delete from public.user_provinces
   where user_id = '00000000-0000-4000-8000-0000000000a2'
     and province_id = '00000000-0000-4000-8000-000000000001';
  get diagnostics affected = row_count;
  if affected <> 0 then raise exception 'FALLO RLS: usuario normal eliminó su asignación provincial'; end if;

  begin
    insert into public.categories (id, code, name)
    values ('00000000-0000-4000-8000-0000000000d2', 'forbidden_user_category', 'Forbidden');
    raise exception 'FALLO RLS: usuario normal insertó una categoría';
  exception when insufficient_privilege then null;
  end;

  begin
    insert into public.municipalities (province_id, name, normalized_name)
    values ('00000000-0000-4000-8000-000000000001', 'Forbidden Municipality', 'forbidden municipality');
    raise exception 'FALLO RLS: usuario normal insertó un municipio';
  exception when insufficient_privilege then null;
  end;

  begin
    insert into public.provinces (id, code, name)
    values ('00000000-0000-4000-8000-0000000000d3', '97', 'Forbidden Province');
    raise exception 'FALLO RLS: usuario normal insertó una provincia';
  exception when insufficient_privilege then null;
  end;

  select count(*) into visible_count from public.audit_log;
  if visible_count <> 0 then
    raise exception 'FALLO RLS: usuario normal leyó el registro de auditoría reservado a administradores';
  end if;
end;
$admin_only_writes_matrix$;

-- Users must not promote themselves, deactivate themselves, or edit province assignments.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);
do $self_privilege_escalation_matrix$
declare affected integer; saved_role text; saved_active boolean;
begin
  update public.profiles set role = 'admin'
   where id = '00000000-0000-4000-8000-0000000000a2';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario normal pudo elevar su propio rol';
  end if;

  update public.profiles set is_active = false
   where id = '00000000-0000-4000-8000-0000000000a2';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario normal pudo modificar su propio estado de activación';
  end if;

  select role, is_active into saved_role, saved_active
    from public.profiles where id = '00000000-0000-4000-8000-0000000000a2';
  if saved_role <> 'user' or saved_active is not true then
    raise exception 'FALLO RLS: se alteró el rol o la activación del usuario normal';
  end if;

  begin
    insert into public.user_provinces (user_id, province_id, assigned_by)
    values ('00000000-0000-4000-8000-0000000000a2',
            '00000000-0000-4000-8000-000000000002', auth.uid());
    raise exception 'FALLO RLS: usuario normal se asignó a otra provincia';
  exception when insufficient_privilege then null;
  end;

  update public.user_provinces
     set province_id = '00000000-0000-4000-8000-000000000002'
   where user_id = '00000000-0000-4000-8000-0000000000a2'
     and province_id = '00000000-0000-4000-8000-000000000001';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: usuario normal pudo cambiar su asignación provincial';
  end if;

  select count(*) into affected from public.user_provinces
   where user_id = '00000000-0000-4000-8000-0000000000a2'
     and province_id = '00000000-0000-4000-8000-000000000001';
  if affected <> 1 then
    raise exception 'FALLO RLS: la asignación provincial original se alteró';
  end if;

  begin
    delete from public.user_app_state where user_id = auth.uid();
    get diagnostics affected = row_count;
    if affected <> 0 then
      raise exception 'FALLO RLS: un usuario pudo borrar su estado personal';
    end if;
  exception when insufficient_privilege then
    null;
  end;

  select count(*) into affected from public.user_app_state where user_id = auth.uid();
  if affected <> 1 then
    raise exception 'FALLO RLS: se perdió el estado personal tras intentar borrarlo';
  end if;

  begin
    delete from public.establishment_app_state
     where establishment_id = '00000000-0000-4000-8000-000000000005';
    get diagnostics affected = row_count;
    if affected <> 0 then
      raise exception 'FALLO RLS: un usuario provincial pudo borrar el estado compartido';
    end if;
  exception when insufficient_privilege then
    null;
  end;
end;
$self_privilege_escalation_matrix$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
do $admin_profile_assignment_matrix$
declare affected integer; saved_role text;
begin
  update public.profiles set role = 'admin'
   where id = '00000000-0000-4000-8000-0000000000a2';
  get diagnostics affected = row_count;
  if affected <> 1 then raise exception 'FALLO RLS: administrador no pudo cambiar el rol de prueba'; end if;

  select role into saved_role from public.profiles
   where id = '00000000-0000-4000-8000-0000000000a2';
  if saved_role <> 'admin' then raise exception 'FALLO RLS: no se aplicó el cambio administrativo de rol'; end if;

  update public.profiles set role = 'user'
   where id = '00000000-0000-4000-8000-0000000000a2';
  get diagnostics affected = row_count;
  if affected <> 1 then raise exception 'FALLO RLS: no se pudo restaurar el usuario de prueba'; end if;
end;
$admin_profile_assignment_matrix$;

-- Profile identity is immutable even for administrators; role/activation remain admin-managed.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
do $profile_identity_immutable$
declare saved_id uuid;
begin
  select id into saved_id from public.profiles
   where id = '00000000-0000-4000-8000-0000000000a2';

  begin
    update public.profiles
       set id = '00000000-0000-4000-8000-0000000000a3'
     where id = '00000000-0000-4000-8000-0000000000a2';
    raise exception 'FALLO SEGURIDAD: se permitió modificar la identidad de un perfil';
  exception when insufficient_privilege then
    null;
  end;

  if not exists (select 1 from public.profiles where id = saved_id) then
    raise exception 'FALLO SEGURIDAD: cambió la identidad del perfil';
  end if;
end;
$profile_identity_immutable$;

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);

-- Administrators can read audit logs; ordinary users cannot.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
do $admin_audit_read_matrix$
declare visible_count integer;
begin
  select count(*) into visible_count from public.audit_log;
  if visible_count = 0 then
    raise exception 'FALLO RLS: administrador no puede leer el registro de auditoría';
  end if;
end;
$admin_audit_read_matrix$;
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);

-- Revoke province access again for the dedicated personal-state inactive-user checks.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a1', false);
update public.profiles set is_active = false
where id = '00000000-0000-4000-8000-0000000000a2';
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a2', false);

-- Inactive users lose their personal app-state access too (not only provincial access).
do $inactive_personal_state_matrix$
declare visible_count integer; affected integer;
begin
  select count(*) into visible_count from public.user_app_state
   where user_id = '00000000-0000-4000-8000-0000000000a2';
  if visible_count <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada puede leer su estado personal';
  end if;

  update public.user_app_state set state = '{"should_not_persist":true}'::jsonb
   where user_id = '00000000-0000-4000-8000-0000000000a2';
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'FALLO RLS: una cuenta desactivada puede actualizar su estado personal';
  end if;
end;
$inactive_personal_state_matrix$;

-- A separate inactive account without a pre-existing state row must not create one.
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-0000000000a4', false);
do $inactive_personal_state_insert$
begin
  begin
    insert into public.user_app_state (user_id, state)
    values ('00000000-0000-4000-8000-0000000000a4', '{"inactive_insert":true}'::jsonb);
    raise exception 'FALLO RLS: cuenta desactivada pudo crear su estado personal';
  exception when insufficient_privilege then
    null;
  end;
end;
$inactive_personal_state_insert$;

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
