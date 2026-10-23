-- Reconciliación (solo lectura) entre el JSON de establishment_app_state y las tablas relacionales.
-- Devuelve una fila por comprobación con «diferencias» = 0 cuando coincide. Criterio para dejar de leer y escribir los arrays antiguos:
-- todas las filas en 0 con el JSON congelado.
CREATE OR REPLACE TEMP VIEW _reconcile AS
WITH sol AS (
  SELECT s.establishment_id, x.elem FROM public.establishment_app_state s
  CROSS JOIN LATERAL jsonb_array_elements(CASE WHEN jsonb_typeof(s.state->'solicitudes') = 'array' THEN s.state->'solicitudes'
        WHEN jsonb_typeof(s.state->'solicitud') = 'object' THEN jsonb_build_array(s.state->'solicitud') ELSE '[]'::jsonb END) AS x(elem)
  WHERE jsonb_typeof(x.elem) = 'object'
), con AS (
  SELECT s.establishment_id, x.elem FROM public.establishment_app_state s
  CROSS JOIN LATERAL jsonb_array_elements(CASE WHEN jsonb_typeof(s.state->'historial') = 'array' THEN s.state->'historial' ELSE '[]'::jsonb END) AS x(elem)
  WHERE jsonb_typeof(x.elem) = 'object'
), checks AS (
  SELECT 1 AS n, 'solicitudes: JSON frente a tabla (recuento)' AS comprobacion,
         abs((SELECT count(*) FROM sol) - (SELECT count(*) FROM public.permit_applications WHERE legacy_ref IS NOT NULL)) AS diferencias
  UNION ALL SELECT 2, 'concesiones: JSON frente a tabla (recuento)',
         abs((SELECT count(*) FROM con) - (SELECT count(*) FROM public.permit_grants WHERE legacy_ref IS NOT NULL))
  UNION ALL SELECT 3, 'solicitudes por establecimiento distintas', (SELECT count(*) FROM (
         SELECT establishment_id, count(*) c FROM sol GROUP BY 1
         EXCEPT SELECT establishment_id, count(*) FROM public.permit_applications WHERE legacy_ref IS NOT NULL GROUP BY 1) t)
  UNION ALL SELECT 4, 'concesiones por establecimiento distintas', (SELECT count(*) FROM (
         SELECT establishment_id, count(*) c FROM con GROUP BY 1
         EXCEPT SELECT establishment_id, count(*) FROM public.permit_grants WHERE legacy_ref IS NOT NULL GROUP BY 1) t)
  UNION ALL SELECT 5, 'solicitudes: fechas, ONG y captadores distintos', (SELECT count(*) FROM (
         SELECT establishment_id, nullif(elem->>'desde','')::date, nullif(elem->>'hasta','')::date, nullif(btrim(elem->>'ong'),''), nullif(elem->>'captadores','')::int, count(*) FROM sol GROUP BY 1,2,3,4,5
         EXCEPT SELECT establishment_id, requested_from, requested_until, organization, capturer_count, count(*) FROM public.permit_applications WHERE legacy_ref IS NOT NULL GROUP BY 1,2,3,4,5) t)
  UNION ALL SELECT 6, 'concesiones: fechas, ONG y captadores distintos', (SELECT count(*) FROM (
         SELECT establishment_id, nullif(elem->>'desde','')::date, nullif(elem->>'hasta','')::date, nullif(btrim(elem->>'ong'),''), nullif(elem->>'captadores','')::int, count(*) FROM con GROUP BY 1,2,3,4,5
         EXCEPT SELECT establishment_id, valid_from, valid_until, organization, capturer_count, count(*) FROM public.permit_grants WHERE legacy_ref IS NOT NULL GROUP BY 1,2,3,4,5) t)
  UNION ALL SELECT 7, 'estados de solicitud distintos', (SELECT count(*) FROM (
         SELECT establishment_id, CASE elem->>'res' WHEN 'aprobada' THEN 'approved' WHEN 'denegada' THEN 'denied' WHEN 'retirada' THEN 'withdrawn' ELSE 'pending' END, count(*) FROM sol GROUP BY 1,2
         EXCEPT SELECT establishment_id, status, count(*) FROM public.permit_applications WHERE legacy_ref IS NOT NULL GROUP BY 1,2) t)
  UNION ALL SELECT 8, 'estados de concesión distintos', (SELECT count(*) FROM (
         SELECT establishment_id, CASE WHEN (elem->>'cancelada')::boolean IS TRUE THEN 'cancelled' ELSE 'active' END, count(*) FROM con GROUP BY 1,2
         EXCEPT SELECT establishment_id, status, count(*) FROM public.permit_grants WHERE legacy_ref IS NOT NULL GROUP BY 1,2) t)
  UNION ALL SELECT 9, 'establecimientos de las filas relacionales sin fila de estado', (
         SELECT count(*) FROM public.permit_applications a WHERE a.legacy_ref IS NOT NULL AND NOT EXISTS (SELECT 1 FROM public.establishment_app_state s WHERE s.establishment_id = a.establishment_id))
  UNION ALL SELECT 10, 'seguimientos pendientes del JSON sin fila en followups', (
         SELECT count(*) FROM sol WHERE nullif(elem->>'seg','') IS NOT NULL AND coalesce(elem->>'res','') = ''
           AND NOT EXISTS (SELECT 1 FROM public.followups f WHERE f.establishment_id = sol.establishment_id AND f.due_on = (sol.elem->>'seg')::date))
)
SELECT n, comprobacion, diferencias, CASE WHEN diferencias = 0 THEN 'OK' ELSE 'DIFERENCIA' END AS resultado FROM checks;

SELECT * FROM _reconcile ORDER BY n;

-- Informativo: concesiones sin solicitud de origen demostrable (no se inventa ningún vínculo).
SELECT count(*) AS concesiones_sin_vinculo_confirmado FROM public.permit_grants WHERE legacy_ref IS NOT NULL AND application_id IS NULL;
