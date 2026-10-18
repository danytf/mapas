-- La lógica privilegiada de admin_list_users() pasa al esquema private (no expuesto por la API) y la función pública
-- queda como envoltorio SECURITY INVOKER, igual que los ayudantes de autorización (migración 20261017092625).
-- Así el asesor de seguridad no avisa de una función SECURITY DEFINER pública. Solo CREATE OR REPLACE.

BEGIN;

CREATE OR REPLACE FUNCTION private.admin_list_users()
RETURNS TABLE (
  id uuid,
  email text,
  display_name text,
  role text,
  is_active boolean,
  created_at timestamptz,
  last_sign_in_at timestamptz,
  province_ids uuid[]
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF NOT (SELECT private.is_admin()) THEN
    RAISE EXCEPTION 'No autorizado' USING ERRCODE = '42501';
  END IF;
  RETURN QUERY
  SELECT p.id,
         u.email::text,
         p.display_name,
         p.role,
         p.is_active,
         p.created_at,
         u.last_sign_in_at,
         COALESCE((SELECT array_agg(up.province_id ORDER BY up.province_id)
                   FROM public.user_provinces up
                   WHERE up.user_id = p.id), '{}'::uuid[])
  FROM public.profiles p
  JOIN auth.users u ON u.id = p.id
  ORDER BY p.created_at, p.id;
END;
$$;

REVOKE ALL ON FUNCTION private.admin_list_users() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION private.admin_list_users() TO authenticated;

CREATE OR REPLACE FUNCTION public.admin_list_users()
RETURNS TABLE (
  id uuid,
  email text,
  display_name text,
  role text,
  is_active boolean,
  created_at timestamptz,
  last_sign_in_at timestamptz,
  province_ids uuid[]
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
  SELECT * FROM private.admin_list_users();
$$;

COMMIT;
