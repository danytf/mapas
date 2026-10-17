-- Harden authorization helpers without breaking existing RLS policy dependencies.
-- SECURITY DEFINER implementations live in a non-exposed schema. Public functions
-- remain SECURITY INVOKER compatibility wrappers because current policies reference them.
begin;

create schema if not exists private;
revoke all on schema private from public, anon;
grant usage on schema private to authenticated, service_role;

create or replace function private.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = (select auth.uid())
      and p.role = 'admin'
      and p.is_active = true
  );
$$;

create or replace function private.has_province_access(target_province_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select private.is_admin() or exists (
    select 1
    from public.user_provinces up
    join public.profiles p on p.id = up.user_id
    where up.user_id = (select auth.uid())
      and up.province_id = target_province_id
      and p.is_active = true
  );
$$;

create or replace function private.can_access_establishment(target_establishment_id uuid)
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
      and private.has_province_access(e.province_id)
  );
$$;

revoke all on function private.is_admin() from public, anon;
revoke all on function private.has_province_access(uuid) from public, anon;
revoke all on function private.can_access_establishment(uuid) from public, anon;
grant execute on function private.is_admin() to authenticated, service_role;
grant execute on function private.has_province_access(uuid) to authenticated, service_role;
grant execute on function private.can_access_establishment(uuid) to authenticated, service_role;

-- Keep the public signatures referenced by existing RLS policies, but remove
-- SECURITY DEFINER from the exposed RPC surface.
create or replace function public.is_admin()
returns boolean
language sql
stable
security invoker
set search_path = ''
as $$
  select private.is_admin();
$$;

create or replace function public.has_province_access(target_province_id uuid)
returns boolean
language sql
stable
security invoker
set search_path = ''
as $$
  select private.has_province_access(target_province_id);
$$;

create or replace function public.can_access_establishment(target_establishment_id uuid)
returns boolean
language sql
stable
security invoker
set search_path = ''
as $$
  select private.can_access_establishment(target_establishment_id);
$$;

revoke all on function public.is_admin() from public, anon;
revoke all on function public.has_province_access(uuid) from public, anon;
revoke all on function public.can_access_establishment(uuid) from public, anon;
grant execute on function public.is_admin() to authenticated, service_role;
grant execute on function public.has_province_access(uuid) to authenticated, service_role;
grant execute on function public.can_access_establishment(uuid) to authenticated, service_role;

commit;
