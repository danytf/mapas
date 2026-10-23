-- Volcado IDEMPOTENTE de solicitudes, concesiones y seguimientos del JSON de establishment_app_state a las tablas relacionales.
-- No modifica establishment_app_state: es la copia de reversión (basta con volver a la versión anterior de la aplicación).
-- Se ejecuta con un rol con permisos de escritura sobre las tres tablas (postgres), con la aplicación antigua sin escribir (ver docs).
-- Segunda ejecución sin cambios en el JSON: 0 filas nuevas. Identificación de cada entrada (legacy_ref):
--   «jsonb:<establecimiento>:sol|con:<id>» si la entrada tiene id; si no, el md5 de su contenido y su número de repetición.
-- Además, una entrada que ya tiene fila con los mismos datos identificativos no se vuelve a crear (por si la aplicación le dio un id entre dos ejecuciones).
-- No se inventan vínculos: una concesión solo se enlaza a una solicitud si su campo «sol» apunta a una solicitud del mismo establecimiento.
-- Fechas desconocidas: requested_at usa la fecha de la solicitud si consta y, si no, la de creación de la fila de estado.
-- Ejecutar en UNA transacción: psql -v ON_ERROR_STOP=1 --single-transaction -f supabase/tools/backfill_permits_from_state.sql
-- (o enviar todo el texto como una sola consulta). Si algo falla no queda nada a medias.

-- 0. Solicitudes del JSON con su referencia (tabla temporal; desaparece al terminar)
DROP TABLE IF EXISTS _bf_sol;
CREATE TEMP TABLE _bf_sol ON COMMIT DROP AS
WITH src AS (
  SELECT s.establishment_id, s.created_at AS sc, x.elem, x.ord, coalesce(x.elem->>'id', md5(x.elem::text)) AS k
  FROM public.establishment_app_state s
  CROSS JOIN LATERAL jsonb_array_elements(
    CASE WHEN jsonb_typeof(s.state->'solicitudes') = 'array' THEN s.state->'solicitudes'
         WHEN jsonb_typeof(s.state->'solicitud') = 'object' THEN jsonb_build_array(s.state->'solicitud')
         ELSE '[]'::jsonb END
  ) WITH ORDINALITY AS x(elem, ord)
  WHERE jsonb_typeof(x.elem) = 'object'
), occ AS (
  SELECT *, row_number() OVER (PARTITION BY establishment_id, k ORDER BY ord) AS n,
            row_number() OVER (PARTITION BY establishment_id, nullif(elem->>'desde',''), nullif(elem->>'hasta',''), nullif(elem->>'ong',''),
                                            nullif(elem->>'captadores','')::int, nullif(elem->>'fecha','') ORDER BY ord) AS ident_n
  FROM src
)
SELECT *, 'jsonb:' || establishment_id || ':sol:' || k || CASE WHEN elem ? 'id' THEN '' ELSE '#' || n END AS ref FROM occ;

-- 1. Solicitudes
INSERT INTO public.permit_applications (establishment_id, status, requested_from, requested_until, organization, capturer_count, requested_at,
                                        follow_up_on, contact_details, notes, resolved_at, resolution_reason, legacy_ref)
SELECT o.establishment_id,
       CASE o.elem->>'res' WHEN 'aprobada' THEN 'approved' WHEN 'denegada' THEN 'denied' WHEN 'retirada' THEN 'withdrawn' ELSE 'pending' END,
       nullif(o.elem->>'desde','')::date, nullif(o.elem->>'hasta','')::date, nullif(btrim(o.elem->>'ong'),''), nullif(o.elem->>'captadores','')::int,
       coalesce(nullif(o.elem->>'fecha','')::date, o.sc::date),
       NULL, -- el seguimiento va a la tabla followups
       nullif(btrim(o.elem->>'contacto'),''), nullif(btrim(o.elem->>'notas'),''),
       CASE WHEN o.elem->>'res' IN ('aprobada','denegada','retirada') AND nullif(o.elem->>'resFecha','') IS NOT NULL
            THEN (nullif(o.elem->>'resFecha','')::date)::timestamp AT TIME ZONE 'Europe/Madrid' END,
       nullif(btrim(o.elem->>'motivo'),''),
       o.ref
FROM _bf_sol o
WHERE NOT EXISTS (SELECT 1 FROM public.permit_applications a WHERE a.legacy_ref = o.ref)
  AND (SELECT count(*) FROM public.permit_applications a
        WHERE a.legacy_ref IS NOT NULL AND a.establishment_id = o.establishment_id
          AND a.requested_from IS NOT DISTINCT FROM nullif(o.elem->>'desde','')::date AND a.requested_until IS NOT DISTINCT FROM nullif(o.elem->>'hasta','')::date
          AND a.organization IS NOT DISTINCT FROM nullif(btrim(o.elem->>'ong'),'') AND a.capturer_count IS NOT DISTINCT FROM nullif(o.elem->>'captadores','')::int
          AND a.requested_at IS NOT DISTINCT FROM coalesce(nullif(o.elem->>'fecha','')::date, o.sc::date)) < o.ident_n;

-- 2. Concesiones (el campo «sol» enlaza con la solicitud de origen cuando consta)
WITH src AS (
  SELECT s.establishment_id, s.created_at AS sc, s.updated_at AS su, x.elem, x.ord, coalesce(x.elem->>'id', md5(x.elem::text)) AS k
  FROM public.establishment_app_state s
  CROSS JOIN LATERAL jsonb_array_elements(CASE WHEN jsonb_typeof(s.state->'historial') = 'array' THEN s.state->'historial' ELSE '[]'::jsonb END) WITH ORDINALITY AS x(elem, ord)
  WHERE jsonb_typeof(x.elem) = 'object'
), occ AS (
  SELECT *, row_number() OVER (PARTITION BY establishment_id, k ORDER BY ord) AS n,
            row_number() OVER (PARTITION BY establishment_id, nullif(elem->>'desde',''), nullif(elem->>'hasta',''), nullif(elem->>'ong',''),
                                            nullif(elem->>'captadores','')::int ORDER BY ord) AS ident_n
  FROM src
)
INSERT INTO public.permit_grants (establishment_id, application_id, status, valid_from, valid_until, organization, capturer_count,
                                  contact_details, notes, cancelled_at, cancelled_reason, created_at, legacy_ref)
SELECT o.establishment_id,
       (SELECT a.id FROM public.permit_applications a
         WHERE a.establishment_id = o.establishment_id AND a.legacy_ref = 'jsonb:' || o.establishment_id || ':sol:' || (o.elem->>'sol')
           AND NOT EXISTS (SELECT 1 FROM public.permit_grants g2 WHERE g2.application_id = a.id)),
       CASE WHEN (o.elem->>'cancelada')::boolean IS TRUE THEN 'cancelled' ELSE 'active' END,
       nullif(o.elem->>'desde','')::date, nullif(o.elem->>'hasta','')::date, nullif(btrim(o.elem->>'ong'),''), nullif(o.elem->>'captadores','')::int,
       nullif(btrim(o.elem->>'contacto'),''), nullif(btrim(o.elem->>'notas'),''),
       CASE WHEN (o.elem->>'cancelada')::boolean IS TRUE
            THEN coalesce((nullif(o.elem->>'resFecha','')::date)::timestamp AT TIME ZONE 'Europe/Madrid', o.su) END,
       nullif(btrim(o.elem->>'motivo'),''),
       coalesce((nullif(o.elem->>'alta','')::date)::timestamp AT TIME ZONE 'Europe/Madrid', o.sc),
       'jsonb:' || o.establishment_id || ':con:' || o.k || CASE WHEN o.elem ? 'id' THEN '' ELSE '#' || o.n END
FROM occ o
WHERE NOT EXISTS (SELECT 1 FROM public.permit_grants g WHERE g.legacy_ref = 'jsonb:' || o.establishment_id || ':con:' || o.k || CASE WHEN o.elem ? 'id' THEN '' ELSE '#' || o.n END)
  AND (SELECT count(*) FROM public.permit_grants g
        WHERE g.legacy_ref IS NOT NULL AND g.establishment_id = o.establishment_id
          AND g.valid_from IS NOT DISTINCT FROM nullif(o.elem->>'desde','')::date AND g.valid_until IS NOT DISTINCT FROM nullif(o.elem->>'hasta','')::date
          AND g.organization IS NOT DISTINCT FROM nullif(btrim(o.elem->>'ong'),'') AND g.capturer_count IS NOT DISTINCT FROM nullif(o.elem->>'captadores','')::int) < o.ident_n;

-- 3. Seguimientos: uno por solicitud pendiente con fecha de seguimiento, y el seguimiento antiguo de un punto sin solicitudes
INSERT INTO public.followups (establishment_id, application_id, due_on, legacy_ref)
SELECT a.establishment_id, a.id, (o.elem->>'seg')::date, 'jsonb:' || a.establishment_id || ':seg:' || o.ref
FROM _bf_sol o
JOIN public.permit_applications a ON a.legacy_ref = o.ref
WHERE a.status = 'pending' AND nullif(o.elem->>'seg','') IS NOT NULL
ON CONFLICT (legacy_ref) DO NOTHING;

INSERT INTO public.followups (establishment_id, due_on, legacy_ref)
SELECT s.establishment_id, (s.state->>'seguimiento')::date, 'jsonb:' || s.establishment_id || ':seg'
FROM public.establishment_app_state s
WHERE nullif(s.state->>'seguimiento','') IS NOT NULL
  AND jsonb_array_length(CASE WHEN jsonb_typeof(s.state->'solicitudes') = 'array' THEN s.state->'solicitudes' ELSE '[]'::jsonb END) = 0
ON CONFLICT (legacy_ref) DO NOTHING;
