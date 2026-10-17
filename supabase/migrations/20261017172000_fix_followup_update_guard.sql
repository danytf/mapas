-- followups has no updated_by column; keep its immutable-field guard without assigning it.
CREATE OR REPLACE FUNCTION public.guard_sensitive_updates()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  immutable_fields text[];
  field_name text;
BEGIN
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

  IF TG_TABLE_NAME = 'establishments'
     AND NEW.province_id IS DISTINCT FROM OLD.province_id
     AND NOT public.is_admin() THEN
    RAISE EXCEPTION 'Solo un administrador puede cambiar la provincia de un establecimiento'
      USING ERRCODE = '42501';
  END IF;

  -- Only tables that actually define updated_by can receive automatic editor attribution.
  IF TG_TABLE_NAME IN ('establishments', 'permit_applications', 'permit_grants') THEN
    IF (SELECT auth.uid()) IS NOT NULL THEN
      NEW.updated_by := (SELECT auth.uid());
    END IF;
  END IF;

  IF TG_TABLE_NAME = 'establishments' AND NOT public.is_admin() THEN
    IF (to_jsonb(NEW) - ARRAY['address','latitude','longitude','location_precision','location_source','location_verified_at','updated_by','updated_at'])
       IS DISTINCT FROM
       (to_jsonb(OLD) - ARRAY['address','latitude','longitude','location_precision','location_source','location_verified_at','updated_by','updated_at']) THEN
      RAISE EXCEPTION 'Los usuarios no administradores solo pueden modificar la dirección y ubicación del establecimiento'
        USING ERRCODE = '42501';
    END IF;
  END IF;

  RETURN NEW;
END;
$function$;
