-- Mapas corporativo — esquema inicial Supabase/PostgreSQL
-- Rama: architecture/fase-2-supabase-schema
-- IMPORTANTE:
--   * Ejecutar primero en un proyecto Supabase NUEVO de desarrollo.
--   * No importar localStorage/sessionStorage ni backups JSON/CSV de pruebas.
--   * Este script crea estructura y políticas; NO carga establecimientos ni usuarios.
--   * Revisar y probar RLS antes de conectar la aplicación.
--
-- La migración usa auth.users como identidad real. El primer administrador se
-- promueve manualmente desde el SQL Editor de Supabase después de crear su usuario.
-- Nunca permitir que un usuario cambie su propio role desde el frontend.

begin;

create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.provinces (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint provinces_code_format check (code ~ '^[0-9]{2}$')
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  role text not null default 'user',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_role_check check (role in ('user', 'admin'))
);

create table if not exists public.user_provinces (
  user_id uuid not null references public.profiles(id) on delete cascade,
  province_id uuid not null references public.provinces(id) on delete restrict,
  assigned_by uuid references public.profiles(id) on delete set null,
  assigned_at timestamptz not null default now(),
  primary key (user_id, province_id)
);

create table if not exists public.municipalities (
  id uuid primary key default gen_random_uuid(),
  province_id uuid not null references public.provinces(id) on delete restrict,
  name text not null,
  normalized_name text not null,
  official_code text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint municipalities_name_per_province unique (province_id, normalized_name)
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.establishments (
  id uuid primary key default gen_random_uuid(),
  province_id uuid not null references public.provinces(id) on delete restrict,
  municipality_id uuid references public.municipalities(id) on delete set null,
  category_id uuid references public.categories(id) on delete set null,
  name text not null,
  normalized_name text not null,
  subtype text,
  address text,
  postal_code text,
  latitude double precision,
  longitude double precision,
  location_precision text not null default 'unknown',
  location_source text,
  location_verified_at timestamptz,
  source_ref text,
  notes text,
  status text not null default 'active',
  created_by uuid references public.profiles(id) on delete set null,
  updated_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  archived_at timestamptz,
  constraint establishments_location_precision_check
    check (location_precision in ('unknown', 'approximate', 'address', 'verified')),
  constraint establishments_status_check check (status in ('active', 'archived')),
  constraint establishments_latitude_check check (latitude is null or latitude between -90 and 90),
  constraint establishments_longitude_check check (longitude is null or longitude between -180 and 180),
  constraint establishments_archive_check
    check ((status = 'active' and archived_at is null) or status = 'archived')
);

create table if not exists public.permit_applications (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete restrict,
  status text not null default 'pending',
  requested_from date,
  requested_until date,
  organization text,
  capturer_count integer,
  requested_at date not null default current_date,
  follow_up_on date,
  contact_name text,
  contact_details text,
  notes text,
  response_notes text,
  created_by uuid references public.profiles(id) on delete set null,
  updated_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint permit_applications_status_check
    check (status in ('pending', 'approved', 'denied', 'withdrawn', 'expired')),
  constraint permit_applications_dates_check
    check (requested_from is null or requested_until is null or requested_until >= requested_from),
  constraint permit_applications_count_check
    check (capturer_count is null or capturer_count >= 0)
);

create table if not exists public.permit_grants (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete restrict,
  application_id uuid references public.permit_applications(id) on delete set null,
  status text not null default 'active',
  valid_from date,
  valid_until date,
  organization text,
  capturer_count integer,
  contact_name text,
  contact_details text,
  notes text,
  cancelled_at timestamptz,
  cancelled_reason text,
  created_by uuid references public.profiles(id) on delete set null,
  updated_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint permit_grants_status_check check (status in ('active', 'cancelled', 'expired')),
  constraint permit_grants_dates_check
    check (valid_from is null or valid_until is null or valid_until >= valid_from),
  constraint permit_grants_count_check check (capturer_count is null or capturer_count >= 0),
  constraint permit_grants_cancelled_check
    check ((status = 'cancelled' and cancelled_at is not null) or status <> 'cancelled')
);

create table if not exists public.followups (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete restrict,
  application_id uuid references public.permit_applications(id) on delete set null,
  grant_id uuid references public.permit_grants(id) on delete set null,
  due_on date,
  completed_at timestamptz,
  outcome text,
  notes text,
  assigned_to uuid references public.profiles(id) on delete set null,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint followups_target_check check (application_id is not null or grant_id is not null or due_on is not null)
);

create table if not exists public.establishment_location_reviews (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete restrict,
  status text not null default 'pending',
  proposed_latitude double precision,
  proposed_longitude double precision,
  proposed_address text,
  source text,
  notes text,
  reviewed_by uuid references public.profiles(id) on delete set null,
  reviewed_at timestamptz,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  constraint location_reviews_status_check check (status in ('pending', 'accepted', 'rejected')),
  constraint location_reviews_latitude_check
    check (proposed_latitude is null or proposed_latitude between -90 and 90),
  constraint location_reviews_longitude_check
    check (proposed_longitude is null or proposed_longitude between -180 and 180)
);

create table if not exists public.establishment_location_history (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete restrict,
  old_latitude double precision,
  old_longitude double precision,
  old_address text,
  new_latitude double precision,
  new_longitude double precision,
  new_address text,
  change_reason text,
  changed_by uuid references public.profiles(id) on delete set null,
  changed_at timestamptz not null default now()
);

create table if not exists public.audit_log (
  id bigint generated always as identity primary key,
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  table_name text not null,
  record_id uuid,
  province_id uuid references public.provinces(id) on delete set null,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.import_batches (
  id uuid primary key default gen_random_uuid(),
  source_name text not null,
  source_sha256 text,
  status text not null default 'draft',
  started_by uuid references public.profiles(id) on delete set null,
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  summary jsonb not null default '{}'::jsonb,
  constraint import_batches_status_check
    check (status in ('draft', 'validated', 'applied', 'failed', 'cancelled'))
);

create table if not exists public.import_records (
  id uuid primary key default gen_random_uuid(),
  batch_id uuid not null references public.import_batches(id) on delete cascade,
  source_row integer,
  source_key text,
  status text not null default 'pending',
  candidate_establishment_id uuid references public.establishments(id) on delete set null,
  payload jsonb not null default '{}'::jsonb,
  issues jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  constraint import_records_status_check
    check (status in ('pending', 'valid', 'ambiguous', 'invalid', 'applied', 'skipped'))
);

create index if not exists municipalities_province_idx on public.municipalities(province_id);
create index if not exists establishments_province_status_idx on public.establishments(province_id, status);
create index if not exists establishments_municipality_idx on public.establishments(municipality_id);
create index if not exists establishments_category_idx on public.establishments(category_id);
create index if not exists establishments_name_idx on public.establishments(province_id, normalized_name);
create index if not exists permit_applications_establishment_idx on public.permit_applications(establishment_id, status);
create index if not exists permit_applications_follow_up_idx on public.permit_applications(follow_up_on) where follow_up_on is not null;
create index if not exists permit_grants_establishment_idx on public.permit_grants(establishment_id, status);
create index if not exists followups_due_idx on public.followups(due_on) where completed_at is null;
create index if not exists followups_assigned_idx on public.followups(assigned_to);
create index if not exists location_reviews_establishment_idx on public.establishment_location_reviews(establishment_id, status);
create index if not exists location_history_establishment_idx on public.establishment_location_history(establishment_id, changed_at desc);
create index if not exists audit_log_province_date_idx on public.audit_log(province_id, created_at desc);
create index if not exists import_records_batch_status_idx on public.import_records(batch_id, status);

-- Las funciones SECURITY DEFINER consultan tablas de autorización sin caer en
-- recursión de RLS. search_path fijo para reducir el riesgo de sustitución de objetos.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = (select auth.uid())
      and p.role = 'admin'
      and p.is_active = true
  );
$$;

create or replace function public.has_province_access(target_province_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.is_admin() or exists (
    select 1
    from public.user_provinces up
    join public.profiles p on p.id = up.user_id
    where up.user_id = (select auth.uid())
      and up.province_id = target_province_id
      and p.is_active = true
  );
$$;

create or replace function public.can_access_establishment(target_establishment_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.establishments e
    where e.id = target_establishment_id
      and public.has_province_access(e.province_id)
  );
$$;

revoke all on function public.is_admin() from public;
revoke all on function public.has_province_access(uuid) from public;
revoke all on function public.can_access_establishment(uuid) from public;
grant execute on function public.is_admin() to authenticated;
grant execute on function public.has_province_access(uuid) to authenticated;
grant execute on function public.can_access_establishment(uuid) to authenticated;

-- Crear un perfil básico al registrarse. El rol siempre nace como 'user'.
create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name, role, is_active)
  values (
    new.id,
    nullif(trim(coalesce(new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'name', '')), ''),
    'user',
    true
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_profile on auth.users;
create trigger on_auth_user_created_profile
after insert on auth.users
for each row execute procedure public.handle_new_auth_user();

-- updated_at automático.
do $$
declare t text;
begin
  foreach t in array array[
    'provinces','profiles','municipalities','categories','establishments',
    'permit_applications','permit_grants','followups'
  ] loop
    execute format('drop trigger if exists set_updated_at on public.%I', t);
    execute format(
      'create trigger set_updated_at before update on public.%I for each row execute procedure public.set_updated_at()',
      t
    );
  end loop;
end;
$$;

-- Integridad relacional reforzada en la base de datos (no depende del frontend).
create or replace function public.validate_permit_grant_application()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  parent_establishment_id uuid;
begin
  if new.application_id is not null then
    select pa.establishment_id into parent_establishment_id
    from public.permit_applications pa
    where pa.id = new.application_id;

    if parent_establishment_id is null or parent_establishment_id <> new.establishment_id then
      raise exception 'La solicitud asociada debe pertenecer al mismo establecimiento que la concesión'
        using errcode = '23514';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists validate_permit_grant_application on public.permit_grants;
create trigger validate_permit_grant_application
before insert or update of establishment_id, application_id on public.permit_grants
for each row execute procedure public.validate_permit_grant_application();

create or replace function public.validate_followup_targets()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  parent_establishment_id uuid;
begin
  if new.application_id is not null then
    select pa.establishment_id into parent_establishment_id
    from public.permit_applications pa
    where pa.id = new.application_id;

    if parent_establishment_id is null or parent_establishment_id <> new.establishment_id then
      raise exception 'La solicitud del seguimiento debe pertenecer al mismo establecimiento'
        using errcode = '23514';
    end if;
  end if;

  if new.grant_id is not null then
    select pg.establishment_id into parent_establishment_id
    from public.permit_grants pg
    where pg.id = new.grant_id;

    if parent_establishment_id is null or parent_establishment_id <> new.establishment_id then
      raise exception 'La concesión del seguimiento debe pertenecer al mismo establecimiento'
        using errcode = '23514';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists validate_followup_targets on public.followups;
create trigger validate_followup_targets
before insert or update of establishment_id, application_id, grant_id on public.followups
for each row execute procedure public.validate_followup_targets();

-- Historial automático de ubicación. La función se ejecuta con privilegios de
-- servidor para que RLS no impida escribir la traza; solo guarda cambios reales.
create or replace function public.record_establishment_location_history()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if old.latitude is distinct from new.latitude
     or old.longitude is distinct from new.longitude
     or old.address is distinct from new.address then
    insert into public.establishment_location_history (
      establishment_id, old_latitude, old_longitude, old_address,
      new_latitude, new_longitude, new_address, change_reason, changed_by
    ) values (
      new.id, old.latitude, old.longitude, old.address,
      new.latitude, new.longitude, new.address,
      'Actualización de coordenadas o dirección',
      coalesce(new.updated_by, (select auth.uid()))
    );
  end if;
  return new;
end;
$$;

drop trigger if exists establishment_location_history_on_update on public.establishments;
create trigger establishment_location_history_on_update
after update of latitude, longitude, address on public.establishments
for each row execute procedure public.record_establishment_location_history();

-- Auditoría de servidor: registra operación, entidad, ámbito y nombres de campos
-- cambiados; no copia notas, teléfonos, contactos ni otros valores potencialmente sensibles.
create or replace function public.write_audit_log()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  old_data jsonb := '{}'::jsonb;
  new_data jsonb := '{}'::jsonb;
  row_data jsonb;
  field_name text;
  changed_fields jsonb := '[]'::jsonb;
  entity_id uuid;
  entity_establishment_id uuid;
  entity_province_id uuid;
  audit_action text := lower(tg_op);
begin
  if tg_op <> 'INSERT' then old_data := to_jsonb(old); end if;
  if tg_op <> 'DELETE' then new_data := to_jsonb(new); end if;
  row_data := case when tg_op = 'DELETE' then old_data else new_data end;

  entity_id := nullif(row_data ->> 'id', '')::uuid;
  entity_establishment_id := nullif(row_data ->> 'establishment_id', '')::uuid;
  entity_province_id := nullif(row_data ->> 'province_id', '')::uuid;

  if entity_province_id is null and entity_establishment_id is not null then
    select e.province_id into entity_province_id
    from public.establishments e where e.id = entity_establishment_id;
  end if;

  if tg_op = 'INSERT' then
    select coalesce(jsonb_agg(k), '[]'::jsonb) into changed_fields
    from jsonb_object_keys(new_data) as keys(k)
    where k not in ('created_at', 'updated_at');
  elsif tg_op = 'DELETE' then
    select coalesce(jsonb_agg(k), '[]'::jsonb) into changed_fields
    from jsonb_object_keys(old_data) as keys(k)
    where k not in ('created_at', 'updated_at');
  else
    for field_name in select jsonb_object_keys(new_data)
    loop
      if field_name not in ('updated_at')
         and old_data -> field_name is distinct from new_data -> field_name then
        changed_fields := changed_fields || jsonb_build_array(field_name);
      end if;
    end loop;
  end if;

  insert into public.audit_log (actor_id, action, table_name, record_id, province_id, details)
  values (
    (select auth.uid()),
    audit_action,
    tg_table_name,
    entity_id,
    entity_province_id,
    jsonb_build_object('changed_fields', changed_fields)
  );
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$;

revoke all on function public.validate_permit_grant_application() from public;
revoke all on function public.validate_followup_targets() from public;
revoke all on function public.record_establishment_location_history() from public;
revoke all on function public.write_audit_log() from public;

do $$
declare t text;
begin
  foreach t in array array[
    'establishments','permit_applications','permit_grants','followups',
    'establishment_location_reviews','user_provinces','profiles'
  ] loop
    execute format('drop trigger if exists audit_row_change on public.%I', t);
    execute format(
      'create trigger audit_row_change after insert or update or delete on public.%I for each row execute procedure public.write_audit_log()',
      t
    );
  end loop;
end;
$$;

-- Activar RLS en todas las tablas expuestas por la API.
alter table public.provinces enable row level security;
alter table public.profiles enable row level security;
alter table public.user_provinces enable row level security;
alter table public.municipalities enable row level security;
alter table public.categories enable row level security;
alter table public.establishments enable row level security;
alter table public.permit_applications enable row level security;
alter table public.permit_grants enable row level security;
alter table public.followups enable row level security;
alter table public.establishment_location_reviews enable row level security;
alter table public.establishment_location_history enable row level security;
alter table public.audit_log enable row level security;
alter table public.import_batches enable row level security;
alter table public.import_records enable row level security;

-- Provincias: usuarios autenticados pueden consultar el catálogo; solo admin gestiona.
drop policy if exists provinces_read_authenticated on public.provinces;
create policy provinces_read_authenticated on public.provinces
for select to authenticated using (true);
drop policy if exists provinces_admin_all on public.provinces;
create policy provinces_admin_all on public.provinces
for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Perfil propio visible; administración de perfiles solo por administradores.
drop policy if exists profiles_read_self_or_admin on public.profiles;
create policy profiles_read_self_or_admin on public.profiles
for select to authenticated using (id = (select auth.uid()) or public.is_admin());
drop policy if exists profiles_admin_all on public.profiles;
create policy profiles_admin_all on public.profiles
for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Cada usuario ve sus asignaciones; solo admin asigna/quita provincias.
drop policy if exists user_provinces_read_self_or_admin on public.user_provinces;
create policy user_provinces_read_self_or_admin on public.user_provinces
for select to authenticated using (user_id = (select auth.uid()) or public.is_admin());
drop policy if exists user_provinces_admin_all on public.user_provinces;
create policy user_provinces_admin_all on public.user_provinces
for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Catálogos de referencia consultables por usuarios autenticados.
drop policy if exists municipalities_read_authenticated on public.municipalities;
create policy municipalities_read_authenticated on public.municipalities
for select to authenticated using (true);
drop policy if exists municipalities_admin_all on public.municipalities;
create policy municipalities_admin_all on public.municipalities
for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists categories_read_authenticated on public.categories;
create policy categories_read_authenticated on public.categories
for select to authenticated using (true);
drop policy if exists categories_admin_all on public.categories;
create policy categories_admin_all on public.categories
for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Establecimientos: cada usuario solo accede a sus provincias asignadas; admin global.
drop policy if exists establishments_select_scope on public.establishments;
create policy establishments_select_scope on public.establishments
for select to authenticated using (public.has_province_access(province_id));
drop policy if exists establishments_insert_scope on public.establishments;
create policy establishments_insert_scope on public.establishments
for insert to authenticated with check (
  public.has_province_access(province_id)
  and created_by = (select auth.uid())
);
drop policy if exists establishments_update_scope on public.establishments;
create policy establishments_update_scope on public.establishments
for update to authenticated using (public.has_province_access(province_id))
with check (public.has_province_access(province_id) and updated_by = (select auth.uid()));
drop policy if exists establishments_delete_admin on public.establishments;
create policy establishments_delete_admin on public.establishments
for delete to authenticated using (public.is_admin());

-- Solicitudes, concesiones y seguimientos heredan el ámbito provincial del establecimiento.
drop policy if exists applications_select_scope on public.permit_applications;
create policy applications_select_scope on public.permit_applications
for select to authenticated using (public.can_access_establishment(establishment_id));
drop policy if exists applications_insert_scope on public.permit_applications;
create policy applications_insert_scope on public.permit_applications
for insert to authenticated with check (
  public.can_access_establishment(establishment_id) and created_by = (select auth.uid())
);
drop policy if exists applications_update_scope on public.permit_applications;
create policy applications_update_scope on public.permit_applications
for update to authenticated using (public.can_access_establishment(establishment_id))
with check (
  public.can_access_establishment(establishment_id) and updated_by = (select auth.uid())
);
drop policy if exists applications_delete_admin on public.permit_applications;
create policy applications_delete_admin on public.permit_applications
for delete to authenticated using (public.is_admin());

drop policy if exists grants_select_scope on public.permit_grants;
create policy grants_select_scope on public.permit_grants
for select to authenticated using (public.can_access_establishment(establishment_id));
drop policy if exists grants_insert_scope on public.permit_grants;
create policy grants_insert_scope on public.permit_grants
for insert to authenticated with check (
  public.can_access_establishment(establishment_id) and created_by = (select auth.uid())
);
drop policy if exists grants_update_scope on public.permit_grants;
create policy grants_update_scope on public.permit_grants
for update to authenticated using (public.can_access_establishment(establishment_id))
with check (
  public.can_access_establishment(establishment_id) and updated_by = (select auth.uid())
);
drop policy if exists grants_delete_admin on public.permit_grants;
create policy grants_delete_admin on public.permit_grants
for delete to authenticated using (public.is_admin());

drop policy if exists followups_select_scope on public.followups;
create policy followups_select_scope on public.followups
for select to authenticated using (public.can_access_establishment(establishment_id));
drop policy if exists followups_insert_scope on public.followups;
create policy followups_insert_scope on public.followups
for insert to authenticated with check (
  public.can_access_establishment(establishment_id) and created_by = (select auth.uid())
);
drop policy if exists followups_update_scope on public.followups;
create policy followups_update_scope on public.followups
for update to authenticated using (public.can_access_establishment(establishment_id))
with check (public.can_access_establishment(establishment_id));
drop policy if exists followups_delete_admin on public.followups;
create policy followups_delete_admin on public.followups
for delete to authenticated using (public.is_admin());

-- Revisión de coordenadas y su historial.
drop policy if exists location_reviews_select_scope on public.establishment_location_reviews;
create policy location_reviews_select_scope on public.establishment_location_reviews
for select to authenticated using (public.can_access_establishment(establishment_id));
drop policy if exists location_reviews_insert_scope on public.establishment_location_reviews;
create policy location_reviews_insert_scope on public.establishment_location_reviews
for insert to authenticated with check (
  public.can_access_establishment(establishment_id) and created_by = (select auth.uid())
);
drop policy if exists location_reviews_update_scope on public.establishment_location_reviews;
create policy location_reviews_update_scope on public.establishment_location_reviews
for update to authenticated using (public.can_access_establishment(establishment_id))
with check (public.can_access_establishment(establishment_id));
drop policy if exists location_reviews_delete_admin on public.establishment_location_reviews;
create policy location_reviews_delete_admin on public.establishment_location_reviews
for delete to authenticated using (public.is_admin());

drop policy if exists location_history_select_scope on public.establishment_location_history;
create policy location_history_select_scope on public.establishment_location_history
for select to authenticated using (public.can_access_establishment(establishment_id));
-- Historial de solo lectura desde la API: solo el trigger SECURITY DEFINER inserta.
drop policy if exists location_history_insert_scope on public.establishment_location_history;
drop policy if exists location_history_update_admin on public.establishment_location_history;
drop policy if exists location_history_delete_admin on public.establishment_location_history;

-- Auditoría e importación: solo admin puede consultar o gestionar desde el cliente.
-- Las escrituras en audit_log se realizan exclusivamente mediante triggers de servidor.
drop policy if exists audit_log_admin_read on public.audit_log;
create policy audit_log_admin_read on public.audit_log
for select to authenticated using (public.is_admin());
drop policy if exists import_batches_admin_all on public.import_batches;
create policy import_batches_admin_all on public.import_batches
for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists import_records_admin_all on public.import_records;
create policy import_records_admin_all on public.import_records
for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Privilegios mínimos para roles API. RLS limita las filas; estos GRANT limitan operaciones.
grant usage on schema public to authenticated;
grant select on public.provinces, public.profiles, public.user_provinces,
  public.municipalities, public.categories, public.establishments,
  public.permit_applications, public.permit_grants, public.followups,
  public.establishment_location_reviews, public.establishment_location_history,
  public.audit_log, public.import_batches, public.import_records to authenticated;
grant insert, update, delete on public.provinces, public.profiles, public.user_provinces,
  public.municipalities, public.categories, public.establishments,
  public.permit_applications, public.permit_grants, public.followups,
  public.establishment_location_reviews,
  public.import_batches, public.import_records to authenticated;
-- No se concede acceso directo a la secuencia de auditoría; el trigger escribe como función de servidor.

commit;

-- ---------------------------------------------------------------------------
-- CONFIGURACIÓN POSTERIOR (ejecutar manualmente en SQL Editor, no en frontend)
-- ---------------------------------------------------------------------------
-- 1. Crear el proyecto Supabase de desarrollo y ejecutar este script.
-- 2. Crear el primer usuario mediante Supabase Auth.
-- 3. Obtener el UUID de ese usuario desde Authentication > Users y promoverlo:
--
--    update public.profiles set role = 'admin' where id = '<UUID_DEL_PRIMER_ADMIN>';
--
-- 4. Insertar el catálogo de provincias y categorías mediante una carga revisada.
-- 5. Asignar provincias desde una sesión de administrador.
-- 6. Antes de producción, completar pruebas negativas de RLS con dos usuarios
--    asignados a provincias distintas y con un usuario administrador.
--
-- NO usar la clave service_role en la web. No cargar aquí datos de navegadores.
