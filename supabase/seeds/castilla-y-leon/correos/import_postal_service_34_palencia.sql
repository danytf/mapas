-- Carga de la categoría Correos de Palencia (provincia 34), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 13 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-11947644605', 'Correos Baltanás – Calle el Molino', NULL, '34022', 'Calle el Molino', NULL, 41.93694, -4.25016, 'address', 'openstreetmap:node/11947644605'),
  ('catalogo-castilla-y-leon:postal_service:node-13626702840', 'Correos Torquemada – Plaza de España', NULL, '34182', 'Plaza de España 1', '34230', 42.03457, -4.31867, 'address', 'openstreetmap:node/13626702840'),
  ('catalogo-castilla-y-leon:postal_service:node-2219908697', 'Correos Saldaña – Calle Danzantes', NULL, '34157', 'Calle Danzantes', '34100', 42.52058, -4.73748, 'address', 'openstreetmap:node/2219908697'),
  ('catalogo-castilla-y-leon:postal_service:node-2545157780', 'Correos Aguilar de Campoo – Calle de Modesto Lafuente', NULL, '34004', 'Calle de Modesto Lafuente 43', '34800', 42.79416, -4.26368, 'address', 'openstreetmap:node/2545157780'),
  ('catalogo-castilla-y-leon:postal_service:node-2548164967', 'Correos Astudillo – Calle Nueva', NULL, '34017', 'Calle Nueva', NULL, 42.19321, -4.29321, 'address', 'openstreetmap:node/2548164967'),
  ('catalogo-castilla-y-leon:postal_service:node-4316424218', 'Correos Velilla del Río Carrión – Calle Dos de Mayo', NULL, '34199', 'Calle Dos de Mayo', NULL, 42.82446, -4.84659, 'address', 'openstreetmap:node/4316424218'),
  ('catalogo-castilla-y-leon:postal_service:node-6436372280', 'Correos Ampudia – Plaza de San Miguel', NULL, '34010', 'Plaza de San Miguel', NULL, 41.91593, -4.78113, 'address', 'openstreetmap:node/6436372280'),
  ('catalogo-castilla-y-leon:postal_service:node-6554032921', 'Correos Palencia – Avenida de Valladolid', NULL, '34120', 'Avenida de Valladolid', NULL, 42.00012, -4.52593, 'address', 'openstreetmap:node/6554032921'),
  ('catalogo-castilla-y-leon:postal_service:node-9143418231', 'Correos Cervera de Pisuerga – Calle San Roque', NULL, '34056', 'Calle San Roque 22', '34840', 42.8665, -4.49894, 'address', 'openstreetmap:node/9143418231'),
  ('catalogo-castilla-y-leon:postal_service:way-198235307', 'Correos Guardo – Paseo del Ayuntamiento', NULL, '34080', 'Paseo del Ayuntamiento 1', '34880', 42.78986, -4.8448, 'address', 'openstreetmap:way/198235307'),
  ('catalogo-castilla-y-leon:postal_service:way-47235220', 'Correos Paredes de Nava – Calle Jesús', NULL, '34123', 'Calle Jesús', NULL, 42.15234, -4.69189, 'address', 'openstreetmap:way/47235220'),
  ('catalogo-castilla-y-leon:postal_service:way-713289643', 'Correos Palencia – Calle Pedro Miguel Barreda', NULL, '34120', 'Calle Pedro Miguel Barreda', NULL, 42.01589, -4.53481, 'address', 'openstreetmap:way/713289643'),
  ('catalogo-castilla-y-leon:postal_service:way-84034547', 'Correos Palencia – Calle Alonso Fernández de Madrid', NULL, '34120', 'Calle Alonso Fernández de Madrid 1', '34001', 42.01387, -4.53399, 'address', 'openstreetmap:way/84034547');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '34');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 34 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '34'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 13 THEN
    RAISE EXCEPTION 'Se esperaban 13 puntos de Correos en Palencia, hay %', n;
  END IF;
END;
$$;

COMMIT;
