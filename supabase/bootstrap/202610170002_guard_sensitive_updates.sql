-- Harden updates to immutable/control fields and restrict location-review decisions.
-- Apply only after reviewing and testing this migration in the development project.

BEGIN;

CREATE OR REPLACE FUNCTION public.guard_sensitive_updates()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  immutable_fields text[];
  field_name text;
BEGIN
  -- Fields that must never be rewritten after record creation.
  immutable_fields := CASE TG_TABLE_NAME
    WHEN 'establishments' THEN ARRAY['id', 'created_by', 'created_at']
    WHEN 'permit_applications' THEN ARRAY['id', 'establishment_id', 'created_by', 'created_at']
    WHEN 'permit_grants' THEN ARRAY['id', 'establishment_id', 'created_by', 'created_at']
    WHEN 'followups' THEN ARRAY['id', 'establishment_id', 'application_id', 'grant_id', 'created_by', 'created_at']
    WHEN 'establishment_location_reviews' THEN ARRAY['id', 'establishment_id', 'created_by', 'created_at']
    ELSE ARRAY['id', 'created_at']
  END;

  FOREACH field_name IN ARRAY immutable_fields LOOP
    IF (to_jsonb(NEW) -> field_name) IS DISTINCT FROM (to_jsonb(OLD) -> field_name) THEN
      RAISE EXCEPTION 'El campo % no se puede modificar después de crear el registro', field_name
        USING ERRCODE = '42501';
    END IF;
  END LOOP;

  -- Changing a record's province is an administrative operation.
  IF TG_TABLE_NAME = 'establishments'
     AND NEW.province_id IS DISTINCT FROM OLD.province_id
     AND NOT public.is_admin() THEN
    RAISE EXCEPTION 'Solo un administrador puede cambiar la provincia de un establecimiento'
      USING ERRCODE = '42501';
  END IF;

  -- The authenticated caller cannot impersonate another editor.
  IF TG_TABLE_NAME IN ('establishments', 'permit_applications', 'permit_grants') THEN
    IF (SELECT auth.uid()) IS NOT NULL THEN
      NEW.updated_by := (SELECT auth.uid());
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.guard_sensitive_updates() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.guard_sensitive_updates() FROM authenticated;

DROP TRIGGER IF EXISTS guard_sensitive_updates ON public.establishments;
CREATE TRIGGER guard_sensitive_updates
BEFORE UPDATE ON public.establishments
FOR EACH ROW EXECUTE FUNCTION public.guard_sensitive_updates();

DROP TRIGGER IF EXISTS guard_sensitive_updates ON public.permit_applications;
CREATE TRIGGER guard_sensitive_updates
BEFORE UPDATE ON public.permit_applications
FOR EACH ROW EXECUTE FUNCTION public.guard_sensitive_updates();

DROP TRIGGER IF EXISTS guard_sensitive_updates ON public.permit_grants;
CREATE TRIGGER guard_sensitive_updates
BEFORE UPDATE ON public.permit_grants
FOR EACH ROW EXECUTE FUNCTION public.guard_sensitive_updates();

DROP TRIGGER IF EXISTS guard_sensitive_updates ON public.followups;
CREATE TRIGGER guard_sensitive_updates
BEFORE UPDATE ON public.followups
FOR EACH ROW EXECUTE FUNCTION public.guard_sensitive_updates();

DROP TRIGGER IF EXISTS guard_sensitive_updates ON public.establishment_location_reviews;
CREATE TRIGGER guard_sensitive_updates
BEFORE UPDATE ON public.establishment_location_reviews
FOR EACH ROW EXECUTE FUNCTION public.guard_sensitive_updates();

-- Only administrators can decide whether a location proposal is accepted/rejected
-- or set reviewer identity/timestamp. Scoped users can still submit proposals.
DROP POLICY IF EXISTS location_reviews_update_scope ON public.establishment_location_reviews;
DROP POLICY IF EXISTS location_reviews_update_admin ON public.establishment_location_reviews;
CREATE POLICY location_reviews_update_admin
ON public.establishment_location_reviews
FOR UPDATE TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

COMMIT;
