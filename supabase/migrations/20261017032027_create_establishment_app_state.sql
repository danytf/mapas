-- Estado operativo compartido por establecimiento, protegido por provincia y rol.
create table if not exists public.establishment_app_state (
  establishment_id uuid primary key references public.establishments(id) on delete cascade,
  province_id uuid not null references public.provinces(id) on delete cascade,
  state jsonb not null default '{}'::jsonb check (jsonb_typeof(state) = 'object'),
  updated_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists establishment_app_state_province_id_idx on public.establishment_app_state(province_id);
alter table public.establishment_app_state enable row level security;
revoke all on public.establishment_app_state from anon;
grant select, insert, update on public.establishment_app_state to authenticated;
drop policy if exists "Users can read state for assigned provinces" on public.establishment_app_state;
create policy "Users can read state for assigned provinces" on public.establishment_app_state for select to authenticated using (
 exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.is_active and
 (p.role='admin' or exists (select 1 from public.user_provinces up where up.user_id=p.id and up.province_id=establishment_app_state.province_id)))
);
drop policy if exists "Users can insert state for assigned provinces" on public.establishment_app_state;
create policy "Users can insert state for assigned provinces" on public.establishment_app_state for insert to authenticated with check (
 updated_by=(select auth.uid()) and exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.is_active and
 (p.role='admin' or exists (select 1 from public.user_provinces up where up.user_id=p.id and up.province_id=establishment_app_state.province_id)))
);
drop policy if exists "Users can update state for assigned provinces" on public.establishment_app_state;
create policy "Users can update state for assigned provinces" on public.establishment_app_state for update to authenticated using (
 exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.is_active and
 (p.role='admin' or exists (select 1 from public.user_provinces up where up.user_id=p.id and up.province_id=establishment_app_state.province_id)))
) with check (
 updated_by=(select auth.uid()) and exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.is_active and
 (p.role='admin' or exists (select 1 from public.user_provinces up where up.user_id=p.id and up.province_id=establishment_app_state.province_id)))
);
create or replace function public.set_establishment_app_state_updated_at() returns trigger language plpgsql set search_path='' as $$
begin new.updated_at=now(); return new; end; $$;
drop trigger if exists set_establishment_app_state_updated_at on public.establishment_app_state;
create trigger set_establishment_app_state_updated_at before update on public.establishment_app_state for each row execute function public.set_establishment_app_state_updated_at();
