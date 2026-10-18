-- H-26: las políticas de lectura del catálogo y del estado compartido llamaban a una función por cada fila.
--
-- Medido en una base local con 50.000 puntos (docs/AUDITORIA_FASE_D_2026-10-18.md): public.has_province_access
-- (que llama a su vez a private.has_province_access, SECURITY DEFINER) cuesta unos 0,2 ms por fila y el planificador
-- no puede evitar evaluarla en todas las filas que el filtro deja pasar. Para el administrador, que no filtra por
-- provincia, la carga completa del catálogo tardaba 25 s (recuento exacto 9 s); con unos 10.000 puntos en las
-- provincias de un usuario serían unos 2 s. Con los 791 puntos actuales no se nota.
--
-- Cambio: la misma regla, evaluada una vez por consulta en lugar de una vez por fila.
--   * El administrador se evalúa como subconsulta escalar (se calcula una sola vez; si es administrador no se
--     llega a mirar las provincias).
--   * Las provincias accesibles de un usuario salen de private.accessible_province_ids(), que devuelve el
--     conjunto de provincias asignadas con usuario y provincia activos (la misma condición que
--     private.has_province_access); la política pasa a «province_id IN (subconsulta)», que PostgreSQL resuelve
--     con una tabla hash sin dependencia de la fila.
--
-- Políticas modificadas con ALTER POLICY (mismos nombres, roles, operaciones y condición updated_by):
--   establishments: establishments_select_scope y establishments_update_scope.
--   establishment_app_state: las tres políticas de lectura, alta y modificación.
-- Las demás políticas (solicitudes, concesiones, seguimientos, revisiones e historial de ubicación) siguen con
-- has_province_access / can_access_establishment: sus tablas están vacías y no cambian de comportamiento.
-- public.has_province_access y private.has_province_access se conservan sin cambios.
--
-- No cambia datos, tablas, columnas ni permisos de tabla.

CREATE FUNCTION private.accessible_province_ids()
RETURNS SETOF uuid
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
  select up.province_id
  from public.user_provinces up
  join public.profiles p on p.id = up.user_id
  join public.provinces pr on pr.id = up.province_id
  where up.user_id = (select auth.uid())
    and p.is_active = true
    and pr.is_active = true;
$function$;

REVOKE ALL ON FUNCTION private.accessible_province_ids() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION private.accessible_province_ids() TO authenticated, service_role;

ALTER POLICY establishments_select_scope
  ON public.establishments
  USING ((SELECT private.is_admin()) OR province_id IN (SELECT private.accessible_province_ids()));

ALTER POLICY establishments_update_scope
  ON public.establishments
  USING ((SELECT private.is_admin()) OR province_id IN (SELECT private.accessible_province_ids()))
  WITH CHECK (((SELECT private.is_admin()) OR province_id IN (SELECT private.accessible_province_ids()))
              AND updated_by = (SELECT auth.uid()));

ALTER POLICY "Users can read state for assigned provinces"
  ON public.establishment_app_state
  USING ((SELECT private.is_admin()) OR province_id IN (SELECT private.accessible_province_ids()));

ALTER POLICY "Users can insert state for assigned provinces"
  ON public.establishment_app_state
  WITH CHECK (updated_by = (SELECT auth.uid())
              AND ((SELECT private.is_admin()) OR province_id IN (SELECT private.accessible_province_ids())));

ALTER POLICY "Users can update state for assigned provinces"
  ON public.establishment_app_state
  USING ((SELECT private.is_admin()) OR province_id IN (SELECT private.accessible_province_ids()))
  WITH CHECK (updated_by = (SELECT auth.uid())
              AND ((SELECT private.is_admin()) OR province_id IN (SELECT private.accessible_province_ids())));
