-- Smoke tests against vanilla PostgreSQL with a minimal Supabase Auth shim.
-- All IDs and data are fictitious and deterministic. This file does not touch production.

insert into auth.users (id, raw_user_meta_data) values
  ('00000000-0000-4000-8000-0000000000a1', '{"full_name":"Smoke Admin"}'::jsonb),
  ('00000000-0000-4000-8000-0000000000a2', '{"full_name":"Smoke User A"}'::jsonb),
  ('00000000-0000-4000-8000-0000000000a3', '{"full_name":"Smoke User B"}'::jsonb);

update public.profiles
set role = 'admin'
where id = '00000000-0000-4000-8000-0000000000a1';

insert into public.provinces (id, code, name) values
  ('00000000-0000-4000-8000-000000000001', '01', 'Smoke Province A'),
  ('00000000-0000-4000-8000-000000000002', '02', 'Smoke Province B');

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
  exception when check_violation then
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
reset role;

select 'schema smoke tests passed' as result;
