-- Personas a las que se puede asignar un seguimiento de un establecimiento: administradores activos y usuarios activos con la provincia
-- del establecimiento. Solo devuelve un identificador y una etiqueta (nombre, o la parte local del correo), nunca el correo completo.
-- Solo la puede llamar quien ya tiene acceso al establecimiento. Lógica privilegiada en el esquema private y envoltorio público SECURITY INVOKER
-- (mismo patrón que admin_list_users). Aditiva: solo crea funciones.

BEGIN;

CREATE FUNCTION private.list_establishment_assignees(p_establishment_id uuid)
RETURNS TABLE (id uuid, label text)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF NOT (SELECT private.can_access_establishment(p_establishment_id)) THEN
    RAISE EXCEPTION 'No autorizado' USING ERRCODE = '42501';
  END IF;
  RETURN QUERY
  SELECT p.id, COALESCE(NULLIF(btrim(p.display_name), ''), split_part(u.email::text, '@', 1))
  FROM public.profiles p
  JOIN auth.users u ON u.id = p.id
  WHERE p.is_active
    AND (p.role = 'admin' OR EXISTS (
      SELECT 1 FROM public.user_provinces up
      JOIN public.establishments e ON e.province_id = up.province_id
      WHERE up.user_id = p.id AND e.id = p_establishment_id))
  ORDER BY 2, p.id;
END;
$$;

REVOKE ALL ON FUNCTION private.list_establishment_assignees(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION private.list_establishment_assignees(uuid) TO authenticated;

CREATE FUNCTION public.list_establishment_assignees(p_establishment_id uuid)
RETURNS TABLE (id uuid, label text)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
  SELECT * FROM private.list_establishment_assignees(p_establishment_id);
$$;

REVOKE ALL ON FUNCTION public.list_establishment_assignees(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.list_establishment_assignees(uuid) TO authenticated;

COMMIT;
