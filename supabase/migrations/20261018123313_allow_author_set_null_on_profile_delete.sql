-- H-10: borrar un perfil (o su usuario de Auth) que haya creado registros fallaba siempre.
--
-- Las claves foráneas *_created_by_fkey usan ON DELETE SET NULL, pero guard_sensitive_updates()
-- declara created_by inmutable y rechazaba esa misma acción referencial con el error
-- "El campo created_by no se puede modificar después de crear el registro".
--
-- Cambio mínimo: created_by solo puede pasar a NULL cuando el perfil que figuraba como autor
-- ya no existe (es decir, durante el ON DELETE SET NULL). Mientras el perfil exista, la
-- inmutabilidad sigue intacta, de modo que un usuario no puede reasignar ni borrar la autoría.
-- La excepción se aplica en los dos controles del guard: la lista de campos inmutables y la
-- restricción de columnas para no administradores (en una baja desde Auth no hay usuario
-- suplantado, por lo que is_admin() es falso y el segundo control también la rechazaba).
--
-- Fuera de alcance, y rechazado a propósito: que un administrador borre su propio perfil
-- mientras es autor de registros (queda fijado por supabase/tests/rls_matrix.sql).
--
-- No se tocan las columnas followups.application_id / grant_id: allí el bloqueo sigue siendo
-- deliberado (fallo cerrado) y queda fijado por supabase/tests/rls_matrix.sql.

CREATE OR REPLACE FUNCTION public.guard_sensitive_updates()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  immutable_fields text[];
  field_name text;
  nonadmin_editable text[] := ARRAY['address','latitude','longitude','location_precision','location_source','location_verified_at','updated_by','updated_at'];
  author_removed boolean;
BEGIN
  immutable_fields := CASE TG_TABLE_NAME
    WHEN 'establishments' THEN ARRAY['id', 'created_by', 'created_at']
    WHEN 'permit_applications' THEN ARRAY['id', 'establishment_id', 'created_by', 'created_at']
    WHEN 'permit_grants' THEN ARRAY['id', 'establishment_id', 'created_by', 'created_at']
    WHEN 'followups' THEN ARRAY['id', 'establishment_id', 'application_id', 'grant_id', 'created_by', 'created_at']
    WHEN 'establishment_location_reviews' THEN ARRAY['id', 'establishment_id', 'created_by', 'created_at']
    ELSE ARRAY['id', 'created_at']
  END;

  -- Única excepción: ON DELETE SET NULL sobre el autor, cuando su perfil ya no existe.
  author_removed := coalesce(
    (to_jsonb(NEW) -> 'created_by') = 'null'::jsonb
    AND (to_jsonb(OLD) ->> 'created_by') IS NOT NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = (to_jsonb(OLD) ->> 'created_by')::uuid
    ),
    false);
  IF author_removed THEN
    nonadmin_editable := array_append(nonadmin_editable, 'created_by');
  END IF;

  FOREACH field_name IN ARRAY immutable_fields LOOP
    IF (to_jsonb(NEW) -> field_name) IS DISTINCT FROM (to_jsonb(OLD) -> field_name) THEN
      IF field_name = 'created_by' AND author_removed THEN
        CONTINUE;
      END IF;
      RAISE EXCEPTION 'El campo % no se puede modificar después de crear el registro', field_name
        USING ERRCODE = '42501';
    END IF;
  END LOOP;

  IF TG_TABLE_NAME = 'establishments' THEN
    IF NEW.province_id IS DISTINCT FROM OLD.province_id
       AND NOT public.is_admin() THEN
      RAISE EXCEPTION 'Solo un administrador puede cambiar la provincia de un establecimiento'
        USING ERRCODE = '42501';
    END IF;
  END IF;

  IF TG_TABLE_NAME IN ('establishments', 'permit_applications', 'permit_grants') THEN
    IF (SELECT auth.uid()) IS NOT NULL THEN
      NEW.updated_by := (SELECT auth.uid());
    END IF;
  END IF;

  IF TG_TABLE_NAME = 'establishments' AND NOT public.is_admin() THEN
    IF (to_jsonb(NEW) - nonadmin_editable) IS DISTINCT FROM (to_jsonb(OLD) - nonadmin_editable) THEN
      RAISE EXCEPTION 'Los usuarios no administradores solo pueden modificar la dirección y ubicación del establecimiento'
        USING ERRCODE = '42501';
    END IF;
  END IF;

  RETURN NEW;
END;
$function$;
