-- Carga de la categoría Correos de Ávila (provincia 05), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 10 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-11913827559', 'Correos Crespos – Plaza de la Constitución', NULL, '05065', 'Plaza de la Constitución 8', '05300', 40.87252, -4.97101, 'address', 'openstreetmap:node/11913827559'),
  ('catalogo-castilla-y-leon:postal_service:node-13580751314', 'Correos San Pedro del Arroyo – Plaza de José Antonio Vaca de Osma', NULL, '05220', 'Plaza de José Antonio Vaca de Osma', '05350', 40.80199, -4.86963, 'address', 'openstreetmap:node/13580751314'),
  ('catalogo-castilla-y-leon:postal_service:node-1949399817', 'Correos El Barco de Ávila – Calle Mayor', NULL, '05021', 'Calle Mayor 31', '05600', 40.35748, -5.52427, 'address', 'openstreetmap:node/1949399817'),
  ('catalogo-castilla-y-leon:postal_service:node-2532841261', 'Correos Horcajo de las Torres – Calle de San Bernardo', NULL, '05099', 'Calle de San Bernardo', NULL, 41.06478, -5.09104, 'address', 'openstreetmap:node/2532841261'),
  ('catalogo-castilla-y-leon:postal_service:node-3770206236', 'Correos Piedralaves – Calle del Río Tiétar', NULL, '05187', 'Calle del Río Tiétar 2', '05440', 40.31764, -4.69625, 'address', 'openstreetmap:node/3770206236'),
  ('catalogo-castilla-y-leon:postal_service:node-6545730496', 'Correos Ávila – Plaza de la Catedral', NULL, '05019', 'Plaza de la Catedral 2', '05001', 40.65626, -4.69764, 'address', 'openstreetmap:node/6545730496'),
  ('catalogo-castilla-y-leon:postal_service:node-6954131163', 'Correos Las Navas del Marqués – Avenida Principal', NULL, '05168', 'Avenida Principal 17', NULL, 40.60348, -4.32926, 'address', 'openstreetmap:node/6954131163'),
  ('catalogo-castilla-y-leon:postal_service:way-239852350', 'Correos Cebreros – Travesía de la Plaza de España', NULL, '05057', 'Travesía de la Plaza de España 5', '05260', 40.45476, -4.46472, 'address', 'openstreetmap:way/239852350'),
  ('catalogo-castilla-y-leon:postal_service:way-486815940', 'Correos El Hoyo de Pinares – Calle Virgen de Navaserrada', NULL, '05102', 'Calle Virgen de Navaserrada', '05250', 40.50112, -4.42218, 'address', 'openstreetmap:way/486815940'),
  ('catalogo-castilla-y-leon:postal_service:way-546013065', 'Correos Madrigal de las Altas Torres – Plaza de Santa María', NULL, '05114', 'Plaza de Santa María 1', NULL, 41.08924, -4.99895, 'address', 'openstreetmap:way/546013065');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '05');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 05 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '05'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 10 THEN
    RAISE EXCEPTION 'Se esperaban 10 puntos de Correos en Ávila, hay %', n;
  END IF;
END;
$$;

COMMIT;
