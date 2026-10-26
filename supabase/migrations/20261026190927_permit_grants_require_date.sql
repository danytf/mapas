-- Una concesión debe tener al menos una fecha (inicio o fin).
--
-- Todo el Centro de permisos se calcula con fechas (vigente hoy, vence en 7/15/30 días, Calendario, Panel, seguimientos). Una concesión sin ninguna fecha cuenta
-- como vigente pero el Calendario no la muestra. El formulario de la aplicación ya exige una fecha, pero la base solo comprobaba que el fin no fuera anterior al
-- inicio, y aprobar una solicitud sin fechas (ni en la solicitud ni en la aprobación) creaba una concesión sin ellas.
--
-- Decisión del titular (26/10/2026): «al menos una fecha». Un fin abierto (concesión indefinida) y un inicio desconocido (válida hasta tal día) son casos reales:
-- no se obliga a inventar la otra fecha.
--  1. CHECK permit_grants_has_date: valid_from o valid_until no nulos. Exenta de la regla la concesión importada del modelo antiguo (legacy_ref no nulo, que es
--     inmutable): ese modelo admitía concesiones sin fechas y la herramienta de importación no puede inventarlas. Hoy hay 0 concesiones, así que no hay datos
--     que corregir.
--  2. approve_permit_application: si ni la aprobación ni la solicitud traen fecha, falla ANTES de cambiar nada con un mensaje claro (23514); al ser una sola
--     transacción, la solicitud sigue pendiente.
--
-- Cambio ADITIVO y reversible: una restricción nueva y CREATE OR REPLACE de una función (misma firma, mismos permisos y códigos de error; solo añade una
-- comprobación). No toca columnas, políticas RLS ni datos.
-- Reversión: ALTER TABLE public.permit_grants DROP CONSTRAINT permit_grants_has_date; y volver a aplicar el cuerpo de 20261025170441_permit_atomic_followups.sql.

BEGIN;

ALTER TABLE public.permit_grants
  ADD CONSTRAINT permit_grants_has_date
  CHECK (valid_from IS NOT NULL OR valid_until IS NOT NULL OR legacy_ref IS NOT NULL);

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
  IF coalesce(p_valid_from, a.requested_from) IS NULL AND coalesce(p_valid_until, a.requested_until) IS NULL THEN
    RAISE EXCEPTION 'La concesión necesita al menos una fecha (inicio o fin)' USING ERRCODE = '23514';
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

COMMIT;
