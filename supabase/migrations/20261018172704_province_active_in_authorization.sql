-- H-22: la autorización por provincia debe tener en cuenta si la provincia está activa.
--
-- La aplicación oculta las provincias con is_active = false, pero la base de datos seguía dando
-- acceso a sus puntos y a su estado compartido a quien las tuviera asignadas (por la API se podían
-- leer y modificar). Ahora un usuario solo accede a una provincia si está asignada, el usuario está
-- activo y la provincia está activa. El administrador activo conserva el acceso a todas, también a
-- las inactivas, para poder gestionarlas.
--
-- 1) private.has_province_access, de la que dependen las políticas de establecimientos, solicitudes,
--    concesiones, seguimientos, revisiones de ubicación e historial de ubicación, exige provincia
--    activa para los usuarios no administradores.
-- 2) Las políticas de establishment_app_state repetían la lógica a mano (sin mirar la provincia):
--    pasan a usar public.has_province_access, de modo que hay una sola regla. Se modifican con
--    ALTER POLICY (sin borrarlas ni recrearlas): mismos nombres, roles, operaciones y condición updated_by, y sin un
--    instante sin política.
--
-- No cambia datos, tablas, columnas ni permisos de tabla.

CREATE OR REPLACE FUNCTION private.has_province_access(target_province_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
  select private.is_admin() or exists (
    select 1
    from public.user_provinces up
    join public.profiles p on p.id = up.user_id
    join public.provinces pr on pr.id = up.province_id
    where up.user_id = (select auth.uid())
      and up.province_id = target_province_id
      and p.is_active = true
      and pr.is_active = true
  );
$function$;

ALTER POLICY "Users can read state for assigned provinces"
  ON public.establishment_app_state
  USING (public.has_province_access(province_id));

ALTER POLICY "Users can insert state for assigned provinces"
  ON public.establishment_app_state
  WITH CHECK (updated_by = (SELECT auth.uid()) AND public.has_province_access(province_id));

ALTER POLICY "Users can update state for assigned provinces"
  ON public.establishment_app_state
  USING (public.has_province_access(province_id))
  WITH CHECK (updated_by = (SELECT auth.uid()) AND public.has_province_access(province_id));
