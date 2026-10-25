-- Operaciones de expedientes atómicas: lo que es una sola acción de negocio se hace en una sola transacción.
--
-- Hasta ahora la aplicación hacía varias llamadas seguidas (aprobar y luego cerrar el seguimiento; crear la solicitud y luego su seguimiento), de modo que un fallo
-- entre dos llamadas dejaba el expediente a medias. Esta migración mueve esos pasos a la base de datos:
--  1. approve_permit_application, resolve_permit_application y cancel_permit_grant cierran, en la misma transacción, los seguimientos abiertos del
--     expediente que se resuelve (los de la solicitud, o los de la concesión que se cancela).
--  2. create_permit_application crea la solicitud y, si se pide, su seguimiento, en una sola transacción. Es idempotente: reintentar con el mismo
--     identificador no duplica nada; solo vale si la solicitud existente es la misma (si no, 23505) y solo añade el seguimiento si falta.
--
-- Cambio ADITIVO y reversible: solo CREATE OR REPLACE de tres funciones (mismas firmas, mismos permisos y mismos códigos de error, PT409 incluido) y una
-- función nueva. No toca tablas, columnas, políticas RLS ni datos. SECURITY INVOKER: siguen mandando las políticas por provincia y las guardas.
-- Reversión: volver a aplicar el cuerpo de 20261023170237_permit_conflict_code.sql y DROP FUNCTION public.create_permit_application(...).

BEGIN;

-- Aprobar: actualiza la solicitud, crea la concesión y cierra sus seguimientos abiertos, todo en una transacción. Idempotente.
CREATE OR REPLACE FUNCTION public.approve_permit_application(
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
    RAISE EXCEPTION 'La solicitud ha cambiado desde que se leyó' USING ERRCODE = 'PT409';
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
  UPDATE public.followups SET completed_at = now() WHERE application_id = a.id AND completed_at IS NULL;
  RETURN g;
END;
$function$;

-- Denegar o retirar con motivo y cerrar los seguimientos abiertos de la solicitud. Idempotente para el mismo estado.
CREATE OR REPLACE FUNCTION public.resolve_permit_application(
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
    RAISE EXCEPTION 'La solicitud ha cambiado desde que se leyó' USING ERRCODE = 'PT409';
  END IF;
  IF a.status <> 'pending' THEN
    RAISE EXCEPTION 'La solicitud ya está resuelta (%)', a.status USING ERRCODE = '23514';
  END IF;
  UPDATE public.permit_applications
     SET status = p_status, resolution_reason = nullif(btrim(p_reason), ''), updated_by = (SELECT auth.uid())
   WHERE id = a.id;
  UPDATE public.followups SET completed_at = now() WHERE application_id = a.id AND completed_at IS NULL;
END;
$function$;

-- Cancelar una concesión con motivo y cerrar sus seguimientos abiertos. Idempotente.
CREATE OR REPLACE FUNCTION public.cancel_permit_grant(
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
    RAISE EXCEPTION 'La concesión ha cambiado desde que se leyó' USING ERRCODE = 'PT409';
  END IF;
  UPDATE public.permit_grants
     SET status = 'cancelled', cancelled_reason = nullif(btrim(p_reason), ''), updated_by = (SELECT auth.uid())
   WHERE id = g.id;
  UPDATE public.followups SET completed_at = now() WHERE grant_id = g.id AND completed_at IS NULL;
END;
$function$;

-- Crear una solicitud y, si se indica, su seguimiento, en una sola transacción. El identificador lo genera el cliente: reintentar con el mismo identificador
-- (respuesta perdida, doble clic) no duplica ni la solicitud ni el seguimiento. Si ya existe una solicitud con ese identificador pero con otros datos, falla
-- (23505) en lugar de darla por buena. Si el seguimiento no es válido (p. ej. un responsable de otra provincia), no se crea nada.
CREATE OR REPLACE FUNCTION public.create_permit_application(
  p_id uuid,
  p_establishment_id uuid,
  p_organization text DEFAULT NULL,
  p_capturer_count integer DEFAULT NULL,
  p_requested_from date DEFAULT NULL,
  p_requested_until date DEFAULT NULL,
  p_requested_at date DEFAULT NULL,
  p_contact_details text DEFAULT NULL,
  p_notes text DEFAULT NULL,
  p_followup_due date DEFAULT NULL,
  p_followup_assignee uuid DEFAULT NULL,
  p_followup_action text DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $function$
DECLARE
  a public.permit_applications%ROWTYPE;
BEGIN
  IF p_id IS NULL OR p_establishment_id IS NULL THEN
    RAISE EXCEPTION 'Faltan el identificador o el establecimiento' USING ERRCODE = '22023';
  END IF;
  SELECT * INTO a FROM public.permit_applications WHERE id = p_id;
  IF FOUND THEN
    IF a.establishment_id <> p_establishment_id
       OR a.organization IS DISTINCT FROM p_organization
       OR a.capturer_count IS DISTINCT FROM p_capturer_count
       OR a.requested_from IS DISTINCT FROM p_requested_from
       OR a.requested_until IS DISTINCT FROM p_requested_until THEN
      RAISE EXCEPTION 'Ya existe otra solicitud con ese identificador' USING ERRCODE = '23505';
    END IF;
  ELSE
    INSERT INTO public.permit_applications (id, establishment_id, status, requested_from, requested_until, organization, capturer_count,
                                            requested_at, contact_details, notes, created_by, updated_by)
    VALUES (p_id, p_establishment_id, 'pending', p_requested_from, p_requested_until, p_organization, p_capturer_count,
            coalesce(p_requested_at, (now() AT TIME ZONE 'Europe/Madrid')::date), p_contact_details, p_notes, (SELECT auth.uid()), (SELECT auth.uid()))
    RETURNING * INTO a;
  END IF;
  IF p_followup_due IS NOT NULL AND a.status = 'pending'
     AND NOT EXISTS (SELECT 1 FROM public.followups f WHERE f.application_id = p_id AND f.completed_at IS NULL) THEN
    INSERT INTO public.followups (establishment_id, application_id, due_on, assigned_to, next_action, created_by)
    VALUES (p_establishment_id, p_id, p_followup_due, p_followup_assignee, nullif(btrim(p_followup_action), ''), (SELECT auth.uid()));
  END IF;
  RETURN p_id;
END;
$function$;

REVOKE ALL ON FUNCTION public.approve_permit_application(uuid, timestamptz, date, date, text, integer) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.resolve_permit_application(uuid, text, text, timestamptz) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.cancel_permit_grant(uuid, text, timestamptz) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.create_permit_application(uuid, uuid, text, integer, date, date, date, text, text, date, uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.approve_permit_application(uuid, timestamptz, date, date, text, integer) TO authenticated;
GRANT EXECUTE ON FUNCTION public.resolve_permit_application(uuid, text, text, timestamptz) TO authenticated;
GRANT EXECUTE ON FUNCTION public.cancel_permit_grant(uuid, text, timestamptz) TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_permit_application(uuid, uuid, text, integer, date, date, date, text, text, date, uuid, text) TO authenticated;

COMMIT;
