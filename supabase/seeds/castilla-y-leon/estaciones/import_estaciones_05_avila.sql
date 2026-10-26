-- Carga de la categoría Estaciones de Ávila (provincia 05), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 16 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-13644818962', 'Estación de tren de San Pedro del Arroyo – Calle Correos', 'Tren', '05220', 'Calle Correos 4', '05350', 40.80385, -4.87146, 'address', 'openstreetmap:node/13644818962'),
  ('catalogo-castilla-y-leon:estaciones:node-13644818963', 'Estación de tren de Cardeñosa de Ávila – Carretera de la Estación', 'Tren', '05049', 'Carretera de la Estación', NULL, 40.73918, -4.75089, 'address', 'openstreetmap:node/13644818963'),
  ('catalogo-castilla-y-leon:estaciones:node-13644818964', 'Estación de tren de Crespos – Avenida de la Estación', 'Tren', '05065', 'Avenida de la Estación 4', '05300', 40.87, -4.96805, 'address', 'openstreetmap:node/13644818964'),
  ('catalogo-castilla-y-leon:estaciones:node-13644818965', 'Estación de tren de Narros del Castillo', 'Tren', '05147', NULL, NULL, 40.86667, -5.05291, 'address', 'openstreetmap:node/13644818965'),
  ('catalogo-castilla-y-leon:estaciones:node-13644968975', 'Estación de tren de Herradón-La Cañada (Herradón de Pinares) – Calle Mayor', 'Tren', '05093', 'Calle Mayor', '05294', 40.59935, -4.49501, 'address', 'openstreetmap:node/13644968975'),
  ('catalogo-castilla-y-leon:estaciones:node-2369495811', 'Estación de tren de Navalperal (Navalperal de Pinares) – Avenida de la Estación', 'Tren', '05161', 'Avenida de la Estación', NULL, 40.59093, -4.40863, 'address', 'openstreetmap:node/2369495811'),
  ('catalogo-castilla-y-leon:estaciones:node-2370627584', 'Estación de tren de Arévalo – Carretera de Segovia', 'Tren', '05016', 'Carretera de Segovia 1', '05200', 41.04707, -4.70193, 'address', 'openstreetmap:node/2370627584'),
  ('catalogo-castilla-y-leon:estaciones:node-367103979', 'Estación de Autobuses de El Barco de Ávila – Plaza del Redondel', 'Autobús', '05021', 'Plaza del Redondel', '05600', 40.35932, -5.52371, 'address', 'openstreetmap:node/367103979'),
  ('catalogo-castilla-y-leon:estaciones:node-4033752071', 'Estación de tren de Ávila – Paseo de la Estación', 'Tren', '05019', 'Paseo de la Estación 42', NULL, 40.65709, -4.683, 'address', 'openstreetmap:node/4033752071'),
  ('catalogo-castilla-y-leon:estaciones:node-5323342061', 'Estación de tren de Las Navas del Marqués – Calle de la Estación', 'Tren', '05168', 'Calle de la Estación', NULL, 40.58916, -4.36162, 'address', 'openstreetmap:node/5323342061'),
  ('catalogo-castilla-y-leon:estaciones:node-7063698911', 'Estación de tren de Guimorcondo (Ávila)', 'Tren', '05019', NULL, NULL, 40.64894, -4.61499, 'address', 'openstreetmap:node/7063698911'),
  ('catalogo-castilla-y-leon:estaciones:way-1446743204', 'Estación de Autobuses de Pedro Bernardo – Calle del Santísimo Cristo de la Vera Cruz', 'Autobús', '05182', 'Calle del Santísimo Cristo de la Vera Cruz', NULL, 40.24065, -4.90697, 'address', 'openstreetmap:way/1446743204'),
  ('catalogo-castilla-y-leon:estaciones:way-291697358', 'Estación de Autobuses (Ávila) – Avenida de Juan Carlos I', 'Autobús', '05019', 'Avenida de Juan Carlos I 1', NULL, 40.65909, -4.6827, 'address', 'openstreetmap:way/291697358'),
  ('catalogo-castilla-y-leon:estaciones:way-296188498', 'Estación de Autobuses de Piedrahíta – Calle B', 'Autobús', '05186', 'Calle B', NULL, 40.46549, -5.32443, 'address', 'openstreetmap:way/296188498'),
  ('catalogo-castilla-y-leon:estaciones:way-434932550', 'Terminal de Autobuses de El Tiemblo – Calle de las Capellanías', 'Autobús', '05241', 'Calle de las Capellanías 18', '05270', 40.4143, -4.49686, 'address', 'openstreetmap:way/434932550'),
  ('catalogo-castilla-y-leon:estaciones:way-847970192', 'Estacion de autobuses de Arenas de San Pedro – Calle del Sol', 'Autobús', '05014', 'Calle del Sol', '05400', 40.2114, -5.08378, 'address', 'openstreetmap:way/847970192');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 16 THEN
    RAISE EXCEPTION 'Se esperaban 16 puntos de Estaciones en Ávila, hay %', n;
  END IF;
END;
$$;

COMMIT;
