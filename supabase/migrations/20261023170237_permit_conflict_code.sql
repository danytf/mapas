-- Corrección: el conflicto de edición ya no se señala con SQLSTATE 40001 (fallo de serialización).
-- La API de Supabase (PostgREST) reintenta sin límite las transacciones que fallan con 40001, así que un conflicto dejaba la llamada
-- repitiéndose en el servidor. Ahora se usa el código propio PT409, que PostgREST devuelve como HTTP 409 (sin reintentos); el cliente lo
-- reconoce como «otra persona cambió el registro». Solo CREATE OR REPLACE de las tres funciones, con los mismos permisos.

BEGIN;

-- Aprobar: actualiza la solicitud y crea la concesión en una sola transacción. Idempotente: si ya estaba aprobada devuelve su concesión.
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
  RETURN g;
END;
$function$;

-- Denegar o retirar con motivo. Idempotente para el mismo estado.
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
END;
$function$;

-- Cancelar una concesión con motivo. Idempotente.
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
END;
$function$;


REVOKE ALL ON FUNCTION public.approve_permit_application(uuid, timestamptz, date, date, text, integer) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.resolve_permit_application(uuid, text, text, timestamptz) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.cancel_permit_grant(uuid, text, timestamptz) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.approve_permit_application(uuid, timestamptz, date, date, text, integer) TO authenticated;
GRANT EXECUTE ON FUNCTION public.resolve_permit_application(uuid, text, text, timestamptz) TO authenticated;
GRANT EXECUTE ON FUNCTION public.cancel_permit_grant(uuid, text, timestamptz) TO authenticated;

COMMIT;
