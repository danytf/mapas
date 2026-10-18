-- Datos sintéticos para las pruebas E2E de la Fase C. SOLO para un proyecto Supabase aislado y vacío.
-- Las contraseñas se leen de variables de entorno (E2E_PW_ADMIN, E2E_PW_GRANADA, E2E_PW_GRANADA2,
-- E2E_PW_ALMERIA, E2E_PW_SINPROVINCIA, E2E_PW_DESACTIVADO); este fichero no contiene ninguna.
-- Uso: psql "<conexión al proyecto aislado>" -v ON_ERROR_STOP=1 -f supabase/e2e/seed_synthetic.sql
\set ON_ERROR_STOP 1
\getenv pw_admin E2E_PW_ADMIN
\getenv pw_granada E2E_PW_GRANADA
\getenv pw_granada2 E2E_PW_GRANADA2
\getenv pw_almeria E2E_PW_ALMERIA
\getenv pw_sinprovincia E2E_PW_SINPROVINCIA
\getenv pw_desactivado E2E_PW_DESACTIVADO
\if :{?pw_admin}
\else
  do $$ begin raise exception 'Faltan las variables de entorno E2E_PW_*'; end $$;
\endif

begin;

-- Barrera: abortar si esto no es la base aislada (producción tiene establecimientos reales).
do $$
begin
  if exists (select 1 from public.establishments) or exists (select 1 from auth.users) then
    raise exception 'La base no está vacía: no es el entorno aislado esperado. Abortado.';
  end if;
end;
$$;

-- Municipios de prueba.
insert into public.municipalities (province_id, name, normalized_name)
select p.id, v.name, v.norm
from (values
  ('18', 'Granada', 'granada'),
  ('18', 'Armilla', 'armilla'),
  ('18', 'Motril', 'motril'),
  ('04', 'Almería', 'almeria'),
  ('04', 'Roquetas de Mar', 'roquetas de mar')
) as v(code, name, norm)
join public.provinces p on p.code = v.code;

-- 22 puntos ficticios: 20 visibles, 1 archivado y 1 sin coordenadas (no deben aparecer en el mapa).
insert into public.establishments (
  province_id, municipality_id, category_id, name, normalized_name, subtype, address,
  latitude, longitude, location_precision, location_source, source_ref, status, archived_at
)
select p.id, m.id, c.id, v.name, lower(v.name), v.sub, v.addr,
       v.lat, v.lon, v.prec, 'e2e-sintetico', v.ref, v.status,
       case when v.status = 'archived' then now() end
from (values
  ('e2e-001','18','granada','Hospital','[PRUEBA] Hospital Alfa',null,'Calle Ficticia 1, Granada',37.1890,-3.6050,'verified','active'),
  ('e2e-002','18','granada','Centro de salud','[PRUEBA] Centro de salud Beta',null,'Calle Ficticia 2, Granada',37.1760,-3.5980,'address','active'),
  ('e2e-003','18','granada','Supermercado','[PRUEBA] Supermercado Gamma','Mercado','Calle Ficticia 3, Granada',37.1700,-3.6100,'address','active'),
  ('e2e-004','18','granada','Centro comercial','[PRUEBA] Centro comercial Delta',null,'Calle Ficticia 4, Granada',37.1650,-3.6000,'approximate','active'),
  ('e2e-005','18','granada','Entidad oficial','[PRUEBA] Oficina Epsilon','Ayuntamiento','Calle Ficticia 5, Granada',37.1770,-3.5970,'verified','active'),
  ('e2e-006','18','granada','Gimnasios','[PRUEBA] Gimnasio Zeta',null,'Calle Ficticia 6, Granada',37.1820,-3.6150,'address','active'),
  ('e2e-007','18','granada','Correos','[PRUEBA] Correos Eta',null,'Calle Ficticia 7, Granada',37.1740,-3.6030,'address','active'),
  ('e2e-008','18','granada','Tiendas','[PRUEBA] Tienda Theta',null,'Calle Ficticia 8, Granada',37.1790,-3.6080,'approximate','active'),
  ('e2e-009','18','armilla','Centro comercial','[PRUEBA] Centro comercial Iota',null,'Calle Ficticia 9, Armilla',37.1450,-3.6250,'address','active'),
  ('e2e-010','18','armilla','Supermercado','[PRUEBA] Supermercado Kappa',null,'Calle Ficticia 10, Armilla',37.1420,-3.6200,'address','active'),
  ('e2e-011','18','armilla','Bricolaje','[PRUEBA] Bricolaje Lambda',null,'Calle Ficticia 11, Armilla',37.1390,-3.6300,'approximate','active'),
  ('e2e-012','18','motril','Hospital','[PRUEBA] Hospital Mu',null,'Calle Ficticia 12, Motril',36.7480,-3.5200,'verified','active'),
  ('e2e-013','18','motril','Centro de salud','[PRUEBA] Centro de salud Nu',null,'Calle Ficticia 13, Motril',36.7440,-3.5150,'address','active'),
  ('e2e-014','18','motril','Estaciones','[PRUEBA] Estación Xi',null,'Calle Ficticia 14, Motril',36.7400,-3.5250,'approximate','active'),
  ('e2e-015','04','almeria','Hospital','[PRUEBA] Hospital Ómicron',null,'Calle Ficticia 15, Almería',36.8400,-2.4600,'verified','active'),
  ('e2e-016','04','almeria','Supermercado','[PRUEBA] Supermercado Pi',null,'Calle Ficticia 16, Almería',36.8350,-2.4550,'address','active'),
  ('e2e-017','04','almeria','Entidad oficial','[PRUEBA] Oficina Rho',null,'Calle Ficticia 17, Almería',36.8380,-2.4650,'address','active'),
  ('e2e-018','04','roquetas de mar','Centro comercial','[PRUEBA] Centro comercial Sigma',null,'Calle Ficticia 18, Roquetas de Mar',36.7650,-2.6100,'address','active'),
  ('e2e-019','04','roquetas de mar','Gimnasios','[PRUEBA] Gimnasio Tau',null,'Calle Ficticia 19, Roquetas de Mar',36.7620,-2.6150,'approximate','active'),
  ('e2e-020','04','roquetas de mar','Correos','[PRUEBA] Correos Ípsilon',null,'Calle Ficticia 20, Roquetas de Mar',36.7600,-2.6050,'address','active'),
  ('e2e-021','18','granada','Tiendas','[PRUEBA] Archivado Phi',null,'Calle Ficticia 21, Granada',37.1800,-3.6000,'address','archived'),
  ('e2e-022','18','granada','Tiendas','[PRUEBA] Sin coordenadas Chi',null,'Calle Ficticia 22, Granada',null,null,'unknown','active')
) as v(ref, code, muni, cat, name, sub, addr, lat, lon, prec, status)
join public.provinces p on p.code = v.code
join public.municipalities m on m.province_id = p.id and m.normalized_name = v.muni
join public.categories c on c.name = v.cat;

-- Cuentas sintéticas (dominio reservado .test). IDs fijos para que las pruebas sean reproducibles.
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, recovery_token, email_change, email_change_token_new,
  email_change_token_current, reauthentication_token
)
select '00000000-0000-0000-0000-000000000000', v.id::uuid, 'authenticated', 'authenticated', v.email,
       extensions.crypt(v.pw, extensions.gen_salt('bf')), now(),
       '{"provider":"email","providers":["email"]}'::jsonb,
       jsonb_build_object('full_name', v.full_name), now(), now(),
       '', '', '', '', '', ''
from (values
  ('e2e00000-0000-4000-8000-000000000001', 'admin@e2e.mapas.test',        :'pw_admin',        'E2E Administrador'),
  ('e2e00000-0000-4000-8000-000000000002', 'granada@e2e.mapas.test',      :'pw_granada',      'E2E Granada'),
  ('e2e00000-0000-4000-8000-000000000003', 'granada2@e2e.mapas.test',     :'pw_granada2',     'E2E Granada 2'),
  ('e2e00000-0000-4000-8000-000000000004', 'almeria@e2e.mapas.test',      :'pw_almeria',      'E2E Almería'),
  ('e2e00000-0000-4000-8000-000000000005', 'sinprovincia@e2e.mapas.test', :'pw_sinprovincia', 'E2E Sin provincia'),
  ('e2e00000-0000-4000-8000-000000000006', 'desactivado@e2e.mapas.test',  :'pw_desactivado',  'E2E Desactivado')
) as v(id, email, pw, full_name);

insert into auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
select u.id::text, u.id,
       jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
       'email', now(), now(), now()
from auth.users u
where u.email like '%@e2e.mapas.test';

-- Perfiles (creados por el trigger de alta): rol y estado.
update public.profiles set role = 'admin' where id = 'e2e00000-0000-4000-8000-000000000001';
update public.profiles set is_active = false where id = 'e2e00000-0000-4000-8000-000000000006';

-- Provincias asignadas. "sinprovincia" no recibe ninguna.
insert into public.user_provinces (user_id, province_id, assigned_by)
select v.uid::uuid, p.id, 'e2e00000-0000-4000-8000-000000000001'::uuid
from (values
  ('e2e00000-0000-4000-8000-000000000002', '18'),
  ('e2e00000-0000-4000-8000-000000000003', '18'),
  ('e2e00000-0000-4000-8000-000000000004', '04'),
  ('e2e00000-0000-4000-8000-000000000006', '18')
) as v(uid, code)
join public.provinces p on p.code = v.code;

-- Comprobaciones: abortar si algo no cuadra.
do $$
begin
  if (select count(*) from public.municipalities) <> 5 then raise exception 'municipios <> 5'; end if;
  if (select count(*) from public.establishments where source_ref like 'e2e-%') <> 22 then raise exception 'establecimientos <> 22'; end if;
  if (select count(*) from auth.users where email like '%@e2e.mapas.test') <> 6 then raise exception 'usuarios <> 6'; end if;
  if (select count(*) from auth.identities where provider = 'email') <> 6 then raise exception 'identidades <> 6'; end if;
  if (select count(*) from public.profiles) <> 6 then raise exception 'perfiles <> 6'; end if;
  if (select count(*) from public.profiles where role = 'admin') <> 1 then raise exception 'admins <> 1'; end if;
  if (select count(*) from public.user_provinces) <> 4 then raise exception 'asignaciones <> 4'; end if;
end;
$$;

commit;

select p.display_name, p.role, p.is_active, coalesce(string_agg(pr.code, ',' order by pr.code), '-') as provincias
from public.profiles p
left join public.user_provinces up on up.user_id = p.id
left join public.provinces pr on pr.id = up.province_id
group by p.id, p.display_name, p.role, p.is_active
order by p.display_name;

select pr.code, e.status, (e.latitude is not null) as con_coordenadas, count(*)
from public.establishments e join public.provinces pr on pr.id = e.province_id
group by 1, 2, 3 order by 1, 2, 3;
