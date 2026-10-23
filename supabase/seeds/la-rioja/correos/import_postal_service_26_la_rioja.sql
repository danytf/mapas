-- Carga de la categoría Correos de La Rioja (provincia 26), trozo de la carga de Andalucía.
-- Origen: postal_service-la-rioja.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:39:03Z).
-- 12 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-la-rioja:postal_service:node-1106879634', 'Correos Logroño – Calle Barrera', NULL, '26089', 'Calle Barrera 22', '26005', 42.4593, -2.45934, 'address', 'openstreetmap:node/1106879634'),
  ('catalogo-la-rioja:postal_service:node-12035318680', 'Correos Baños de Río Tobía – Plaza del Rosario', NULL, '26026', 'Plaza del Rosario', NULL, 42.33467, -2.7614, 'address', 'openstreetmap:node/12035318680'),
  ('catalogo-la-rioja:postal_service:node-1340275112', 'Correos Navarrete – Calle Abadía', NULL, '26105', 'Calle Abadía 1', '26370', 42.4293, -2.56301, 'address', 'openstreetmap:node/1340275112'),
  ('catalogo-la-rioja:postal_service:node-1641649063', 'Correos Calahorra – Calle Ruiz y Menta', NULL, '26036', 'Calle Ruiz y Menta', NULL, 42.30637, -1.96313, 'address', 'openstreetmap:node/1641649063'),
  ('catalogo-la-rioja:postal_service:node-2552643368', 'Correos Arnedo – Calle del Palacio', NULL, '26018', 'Calle del Palacio', NULL, 42.22741, -2.10056, 'address', 'openstreetmap:node/2552643368'),
  ('catalogo-la-rioja:postal_service:node-2554343573', 'Correos Alfaro – Calle Araciel', NULL, '26011', 'Calle Araciel', NULL, 42.17935, -1.74713, 'address', 'openstreetmap:node/2554343573'),
  ('catalogo-la-rioja:postal_service:node-2555515939', 'Correos San Vicente de la Sonsierra – Calle El Remedio', NULL, '26142', 'Calle El Remedio', '26338', 42.56256, -2.75821, 'address', 'openstreetmap:node/2555515939'),
  ('catalogo-la-rioja:postal_service:node-2555575853', 'Correos Santo Domingo de la Calzada – Plaza de España', NULL, '26138', 'Plaza de España', '26250', 42.44219, -2.95347, 'address', 'openstreetmap:node/2555575853'),
  ('catalogo-la-rioja:postal_service:node-2838114685', 'Correos Logroño – Calle Duquesa de la Victoria', NULL, '26089', 'Calle Duquesa de la Victoria 77', '26004', 42.46327, -2.43233, 'address', 'openstreetmap:node/2838114685'),
  ('catalogo-la-rioja:postal_service:node-426801529', 'Correos Haro – AVENIDA LA RIOJA', NULL, '26071', 'AVENIDA LA RIOJA 4', NULL, 42.57493, -2.8515, 'address', 'openstreetmap:node/426801529'),
  ('catalogo-la-rioja:postal_service:node-5064810684', 'Correos Torrecilla en Cameros – Calle Pedro Sagasta 24-B', NULL, '26151', 'Calle Pedro Sagasta 24-B', '26100', 42.2558, -2.62928, 'address', 'openstreetmap:node/5064810684'),
  ('catalogo-la-rioja:postal_service:node-5238295437', 'Correos Rincón de Soto – Calle Francisco Llorente', NULL, '26125', 'Calle Francisco Llorente', NULL, 42.23419, -1.85142, 'address', 'openstreetmap:node/5238295437');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '26');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 26 con estos códigos INE: %', faltan;
  END IF;
END;
$$;

INSERT INTO public.establishments (
  province_id, municipality_id, category_id,
  name, normalized_name, subtype, address, postal_code,
  latitude, longitude, location_precision, location_source,
  source_ref, status
)
SELECT p.id, m.id, cat.id,
       c.name, lower(trim(c.name)), c.subtype, c.address, c.postal_code,
       c.latitude, c.longitude, c.location_precision, c.location_source,
       c.source_ref, 'active'
FROM _carga c
JOIN public.municipalities m ON m.official_code = c.muni_ine
JOIN public.provinces p ON p.id = m.province_id AND p.code = '26'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 12 THEN
    RAISE EXCEPTION 'Se esperaban 12 puntos de Correos en La Rioja, hay %', n;
  END IF;
END;
$$;

COMMIT;
