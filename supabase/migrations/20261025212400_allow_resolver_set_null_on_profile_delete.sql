-- Borrar un usuario (o su perfil) que resolvió solicitudes de permiso fallaba siempre.
--
-- permit_applications.resolved_by es ON DELETE SET NULL, pero guard_permit_lifecycle() declara
-- inmutables resolved_at y resolved_by en una solicitud ya resuelta y rechazaba esa misma acción
-- referencial con «La fecha y el autor de la decisión no se pueden modificar» (42501). En el panel
-- de Auth se veía como «Database error deleting user». Es el mismo fallo que H-10 corrigió para
-- created_by en guard_sensitive_updates(); resolved_by se quedó fuera.
--
-- Cambio mínimo: resolved_by solo puede pasar a NULL cuando el perfil que figuraba como autor de
-- la decisión ya no existe (es decir, durante el ON DELETE SET NULL). Mientras el perfil exista,
-- y para cualquier otro cambio (fecha, estado, reasignar a otra persona), la inmutabilidad sigue
-- intacta. La solicitud se conserva con su estado y su fecha de decisión, sin autor.
--
-- La función pasa a SECURITY DEFINER (como guard_sensitive_updates) porque durante la baja se ejecuta
-- con el rol de Auth, que no tiene por qué poder leer public.profiles. Sigue sin ser invocable por la API.

CREATE OR REPLACE FUNCTION public.guard_permit_lifecycle()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  resolver_removed boolean;
BEGIN
  IF NEW.legacy_ref IS DISTINCT FROM OLD.legacy_ref THEN
    RAISE EXCEPTION 'La referencia de origen no se puede modificar' USING ERRCODE = '42501';
  END IF;
  IF TG_TABLE_NAME = 'permit_applications' THEN
    IF OLD.status <> 'pending' AND NEW.status IS DISTINCT FROM OLD.status THEN
      RAISE EXCEPTION 'La solicitud ya está resuelta (%) y no puede cambiar de estado', OLD.status USING ERRCODE = '23514';
    END IF;
    -- Única excepción: ON DELETE SET NULL sobre quien resolvió, cuando su perfil ya no existe.
    resolver_removed := coalesce(
      OLD.resolved_by IS NOT NULL
      AND NEW.resolved_by IS NULL
      AND NOT EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = OLD.resolved_by),
      false);
    IF OLD.status <> 'pending' AND (NEW.resolved_at IS DISTINCT FROM OLD.resolved_at
       OR (NEW.resolved_by IS DISTINCT FROM OLD.resolved_by AND NOT resolver_removed)) THEN
      RAISE EXCEPTION 'La fecha y el autor de la decisión no se pueden modificar' USING ERRCODE = '42501';
    END IF;
    IF OLD.status = 'pending' AND NEW.status <> 'pending' THEN
      NEW.resolved_at := now();
      NEW.resolved_by := (SELECT auth.uid());
    END IF;
  ELSE
    IF NEW.status = 'cancelled' AND OLD.status <> 'cancelled' AND NEW.cancelled_at IS NULL THEN
      NEW.cancelled_at := now();
    ELSIF NEW.status <> 'cancelled' AND OLD.status = 'cancelled' THEN
      NEW.cancelled_at := NULL;
      NEW.cancelled_reason := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$function$;
REVOKE ALL ON FUNCTION public.guard_permit_lifecycle() FROM PUBLIC, anon, authenticated;
