-- Expedientes de solicitudes, concesiones y seguimientos: el ciclo de vida pasa a la base de datos.
--
-- Migración ADITIVA: no borra ni reescribe nada. Las tablas permit_applications, permit_grants y followups ya existen
-- (con RLS por provincia, guardas de campos inmutables, triggers de coherencia y auditoría en audit_log). Aquí se añade:
--  1. Datos de la decisión (resolved_at / resolved_by / resolution_reason) y referencia de origen (legacy_ref) para el volcado idempotente
--     del JSON de establishment_app_state (supabase/tools/backfill_permits_from_state.sql).
--  2. Una sola concesión por solicitud (índice único): una aprobación repetida no puede duplicar la concesión.
--  3. Un trigger de decisión: una solicitud resuelta no vuelve a pendiente, y quién y cuándo resuelve queda en la fila.
--  4. Funciones atómicas SECURITY INVOKER (mandan RLS y las guardas): aprobar, denegar/retirar y cancelar. Son idempotentes
--     y aceptan la fecha de última modificación que leyó el cliente para detectar conflictos (SQLSTATE 40001).
--  5. Responsable de un seguimiento: debe poder trabajar en la provincia del establecimiento.
-- Quién creó, modificó, resolvió o canceló cada expediente sigue en audit_log (triggers existentes).

ALTER TABLE public.permit_applications
  ADD COLUMN IF NOT EXISTS resolved_at timestamptz,
  ADD COLUMN IF NOT EXISTS resolved_by uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS resolution_reason text,
  ADD COLUMN IF NOT EXISTS legacy_ref text;

ALTER TABLE public.permit_grants ADD COLUMN IF NOT EXISTS legacy_ref text;

ALTER TABLE public.followups
  ADD COLUMN IF NOT EXISTS next_action text,
  ADD COLUMN IF NOT EXISTS legacy_ref text;

CREATE INDEX IF NOT EXISTS idx_permit_applications_resolved_by ON public.permit_applications(resolved_by);
CREATE UNIQUE INDEX IF NOT EXISTS permit_applications_legacy_ref_key ON public.permit_applications(legacy_ref);
CREATE UNIQUE INDEX IF NOT EXISTS permit_grants_legacy_ref_key ON public.permit_grants(legacy_ref);
CREATE UNIQUE INDEX IF NOT EXISTS followups_legacy_ref_key ON public.followups(legacy_ref);
CREATE UNIQUE INDEX IF NOT EXISTS permit_grants_one_per_application ON public.permit_grants(application_id) WHERE application_id IS NOT NULL;

ALTER TABLE public.permit_applications
  ADD CONSTRAINT permit_applications_resolution_check CHECK (
    (status = 'pending' AND resolved_at IS NULL)
    OR (status <> 'pending' AND (resolved_at IS NOT NULL OR legacy_ref IS NOT NULL))
  ),
  ADD CONSTRAINT permit_applications_reason_length CHECK (resolution_reason IS NULL OR char_length(resolution_reason) <= 500);
ALTER TABLE public.permit_grants
  ADD CONSTRAINT permit_grants_reason_length CHECK (cancelled_reason IS NULL OR char_length(cancelled_reason) <= 500);

-- Decisión de una solicitud y vida de una concesión.
CREATE FUNCTION public.guard_permit_lifecycle()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $function$
BEGIN
  IF NEW.legacy_ref IS DISTINCT FROM OLD.legacy_ref THEN
    RAISE EXCEPTION 'La referencia de origen no se puede modificar' USING ERRCODE = '42501';
  END IF;
  IF TG_TABLE_NAME = 'permit_applications' THEN
    IF OLD.status <> 'pending' AND NEW.status IS DISTINCT FROM OLD.status THEN
      RAISE EXCEPTION 'La solicitud ya está resuelta (%) y no puede cambiar de estado', OLD.status USING ERRCODE = '23514';
    END IF;
    IF OLD.status <> 'pending' AND (NEW.resolved_at IS DISTINCT FROM OLD.resolved_at OR NEW.resolved_by IS DISTINCT FROM OLD.resolved_by) THEN
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

CREATE TRIGGER guard_permit_application_lifecycle
  BEFORE UPDATE ON public.permit_applications
  FOR EACH ROW EXECUTE FUNCTION public.guard_permit_lifecycle();
CREATE TRIGGER guard_permit_grant_lifecycle
  BEFORE UPDATE ON public.permit_grants
  FOR EACH ROW EXECUTE FUNCTION public.guard_permit_lifecycle();

-- El responsable de un seguimiento debe ser administrador o tener asignada la provincia del establecimiento.
CREATE FUNCTION public.validate_followup_assignee()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
BEGIN
  IF NEW.assigned_to IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM public.profiles p WHERE p.id = NEW.assigned_to AND p.role = 'admin'
  ) AND NOT EXISTS (
    SELECT 1 FROM public.user_provinces up
    JOIN public.establishments e ON e.province_id = up.province_id
    WHERE up.user_id = NEW.assigned_to AND e.id = NEW.establishment_id
  ) THEN
    RAISE EXCEPTION 'El responsable del seguimiento no tiene acceso a la provincia del establecimiento' USING ERRCODE = '23514';
  END IF;
  RETURN NEW;
END;
$function$;
REVOKE ALL ON FUNCTION public.validate_followup_assignee() FROM PUBLIC, anon, authenticated;

CREATE TRIGGER validate_followup_assignee
  BEFORE INSERT OR UPDATE OF assigned_to, establishment_id ON public.followups
  FOR EACH ROW EXECUTE FUNCTION public.validate_followup_assignee();

-- Aprobar: actualiza la solicitud y crea la concesión en una sola transacción. Idempotente: si ya estaba aprobada devuelve su concesión.
CREATE FUNCTION public.approve_permit_application(
  p_application_id uuid,
  p_expected_updated_at timestamptz DEFAULT NULL,
  p_valid_from date DEFAULT NULL,
  p_valid_until date DEFAULT NULL,
  p_organization text DEFAULT NULL,
  p_capturer_count integer DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $function$
DECLARE
  a public.permit_applications%ROWTYPE;
  g uuid;
BEGIN
  SELECT * INTO a FROM public.permit_applications WHERE id = p_application_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Solicitud no encontrada' USING ERRCODE = 'P0002';
  END IF;
  IF a.status = 'approved' THEN
    SELECT pg.id INTO g FROM public.permit_grants pg WHERE pg.application_id = a.id;
    IF FOUND THEN RETURN g; END IF;
  END IF;
  IF p_expected_updated_at IS NOT NULL AND a.updated_at <> p_expected_updated_at THEN
    RAISE EXCEPTION 'La solicitud ha cambiado desde que se leyó' USING ERRCODE = '40001';
  END IF;
  IF a.status <> 'pending' THEN
    RAISE EXCEPTION 'La solicitud ya está resuelta (%)', a.status USING ERRCODE = '23514';
  END IF;
  UPDATE public.permit_applications SET status = 'approved', updated_by = (SELECT auth.uid()) WHERE id = a.id;
  INSERT INTO public.permit_grants (establishment_id, application_id, status, valid_from, valid_until, organization, capturer_count,
                                    contact_name, contact_details, notes, created_by, updated_by)
  VALUES (a.establishment_id, a.id, 'active', coalesce(p_valid_from, a.requested_from), coalesce(p_valid_until, a.requested_until),
          coalesce(p_organization, a.organization), coalesce(p_capturer_count, a.capturer_count),
          a.contact_name, a.contact_details, a.notes, (SELECT auth.uid()), (SELECT auth.uid()))
  RETURNING id INTO g;
  RETURN g;
END;
$function$;

-- Denegar o retirar con motivo. Idempotente para el mismo estado.
CREATE FUNCTION public.resolve_permit_application(
  p_application_id uuid,
  p_status text,
  p_reason text DEFAULT NULL,
  p_expected_updated_at timestamptz DEFAULT NULL
) RETURNS void
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $function$
DECLARE
  a public.permit_applications%ROWTYPE;
BEGIN
  IF p_status NOT IN ('denied', 'withdrawn') THEN
    RAISE EXCEPTION 'Estado de resolución no válido: %', p_status USING ERRCODE = '22023';
  END IF;
  SELECT * INTO a FROM public.permit_applications WHERE id = p_application_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Solicitud no encontrada' USING ERRCODE = 'P0002';
  END IF;
  IF a.status = p_status THEN RETURN; END IF;
  IF p_expected_updated_at IS NOT NULL AND a.updated_at <> p_expected_updated_at THEN
    RAISE EXCEPTION 'La solicitud ha cambiado desde que se leyó' USING ERRCODE = '40001';
  END IF;
  IF a.status <> 'pending' THEN
    RAISE EXCEPTION 'La solicitud ya está resuelta (%)', a.status USING ERRCODE = '23514';
  END IF;
  UPDATE public.permit_applications
     SET status = p_status, resolution_reason = nullif(btrim(p_reason), ''), updated_by = (SELECT auth.uid())
   WHERE id = a.id;
END;
$function$;

-- Cancelar una concesión con motivo. Idempotente.
CREATE FUNCTION public.cancel_permit_grant(
  p_grant_id uuid,
  p_reason text DEFAULT NULL,
  p_expected_updated_at timestamptz DEFAULT NULL
) RETURNS void
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $function$
DECLARE
  g public.permit_grants%ROWTYPE;
BEGIN
  SELECT * INTO g FROM public.permit_grants WHERE id = p_grant_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Concesión no encontrada' USING ERRCODE = 'P0002';
  END IF;
  IF g.status = 'cancelled' THEN RETURN; END IF;
  IF p_expected_updated_at IS NOT NULL AND g.updated_at <> p_expected_updated_at THEN
    RAISE EXCEPTION 'La concesión ha cambiado desde que se leyó' USING ERRCODE = '40001';
  END IF;
  UPDATE public.permit_grants
     SET status = 'cancelled', cancelled_reason = nullif(btrim(p_reason), ''), updated_by = (SELECT auth.uid())
   WHERE id = g.id;
END;
$function$;

REVOKE ALL ON FUNCTION public.approve_permit_application(uuid, timestamptz, date, date, text, integer) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.resolve_permit_application(uuid, text, text, timestamptz) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.cancel_permit_grant(uuid, text, timestamptz) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.approve_permit_application(uuid, timestamptz, date, date, text, integer) TO authenticated;
GRANT EXECUTE ON FUNCTION public.resolve_permit_application(uuid, text, text, timestamptz) TO authenticated;
GRANT EXECUTE ON FUNCTION public.cancel_permit_grant(uuid, text, timestamptz) TO authenticated;
