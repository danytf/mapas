-- Panel de administración v1: lectura de usuarios con correo (solo administradores) y protección del último administrador.
-- Solo CREATE OR REPLACE / CREATE TRIGGER: no se elimina nada.

BEGIN;

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

REVOKE ALL ON FUNCTION public.admin_list_users() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_list_users() TO authenticated;

CREATE OR REPLACE FUNCTION public.protect_last_admin()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF OLD.role = 'admin' AND OLD.is_active
     AND (TG_OP = 'DELETE' OR NEW.role IS DISTINCT FROM 'admin' OR NEW.is_active IS NOT TRUE) THEN
    -- Serializa cambios simultáneos de administradores para que dos degradaciones a la vez no dejen cero.
    PERFORM pg_advisory_xact_lock(hashtext('protect_last_admin'));
    IF NOT EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id <> OLD.id AND p.role = 'admin' AND p.is_active
    ) THEN
      RAISE EXCEPTION 'No se puede dejar el sistema sin administradores activos' USING ERRCODE = '23514';
    END IF;
  END IF;
  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.protect_last_admin() FROM PUBLIC, anon, authenticated;

CREATE TRIGGER protect_last_admin_update
BEFORE UPDATE OF role, is_active ON public.profiles
FOR EACH ROW EXECUTE FUNCTION public.protect_last_admin();

CREATE TRIGGER protect_last_admin_delete
BEFORE DELETE ON public.profiles
FOR EACH ROW EXECUTE FUNCTION public.protect_last_admin();

COMMIT;
