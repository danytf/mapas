-- Carga de la categoría Estaciones de Toledo (provincia 45), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 26 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:estaciones:node-1164461464', 'Estación de tren de Illescas – Paseo de la Estación', 'Tren', '45081', 'Paseo de la Estación', '45200', 40.12085, -3.84226, 'address', 'openstreetmap:node/1164461464'),
  ('catalogo-castilla-la-mancha:estaciones:node-2328131198', 'Estación de tren de Erustes', 'Tren', '45060', NULL, NULL, 39.94935, -4.48756, 'address', 'openstreetmap:node/2328131198'),
  ('catalogo-castilla-la-mancha:estaciones:node-2328131201', 'Estación de tren de Montearagón', 'Tren', '45104', NULL, NULL, 39.96077, -4.64656, 'address', 'openstreetmap:node/2328131201'),
  ('catalogo-castilla-la-mancha:estaciones:node-2328131202', 'Estación de tren de Oropesa de Toledo – Avda. Estación', 'Tren', '45125', 'Avda. Estación', NULL, 39.92185, -5.18621, 'address', 'openstreetmap:node/2328131202'),
  ('catalogo-castilla-la-mancha:estaciones:node-2328131203', 'Estación de tren de Talavera de la Reina – Paseo de la Estación', 'Tren', '45165', 'Paseo de la Estación', '45600', 39.97063, -4.82655, 'address', 'openstreetmap:node/2328131203'),
  ('catalogo-castilla-la-mancha:estaciones:node-2328131205', 'Estación de tren de Torrijos – Calle de la Carretera de Gerindote', 'Tren', '45173', 'Calle de la Carretera de Gerindote', '45500', 39.97881, -4.28316, 'address', 'openstreetmap:node/2328131205'),
  ('catalogo-castilla-la-mancha:estaciones:node-2393743376', 'Estación de tren de Tembleque (El Romeral)', 'Tren', '45149', NULL, NULL, 39.72251, -3.49698, 'address', 'openstreetmap:node/2393743376'),
  ('catalogo-castilla-la-mancha:estaciones:node-2393787650', 'Estación de tren de Villasequilla – Paseo de la Estación', 'Tren', '45197', 'Paseo de la Estación', NULL, 39.87952, -3.72849, 'address', 'openstreetmap:node/2393787650'),
  ('catalogo-castilla-la-mancha:estaciones:node-254453384', 'Estación de tren de Toledo – Paseo de la Rosa', 'Tren', '45168', 'Paseo de la Rosa', '45006', 39.86256, -4.01083, 'address', 'openstreetmap:node/254453384'),
  ('catalogo-castilla-la-mancha:estaciones:node-2579743614', 'Estación de tren de Quero – Carretera de la Estación', 'Tren', '45141', 'Carretera de la Estación', NULL, 39.50422, -3.26636, 'address', 'openstreetmap:node/2579743614'),
  ('catalogo-castilla-la-mancha:estaciones:node-264034596', 'Estación de tren de El Romeral', 'Tren', '45149', NULL, NULL, 39.69397, -3.4301, 'address', 'openstreetmap:node/264034596'),
  ('catalogo-castilla-la-mancha:estaciones:node-264034930', 'Estación de tren de Villacañas – Paseo de los Enamorados', 'Tren', '45185', 'Paseo de los Enamorados', NULL, 39.62197, -3.33025, 'address', 'openstreetmap:node/264034930'),
  ('catalogo-castilla-la-mancha:estaciones:node-4181507647', 'Parada para autobuses (Toledo) – Calle de la Carrera', 'Autobús', '45168', 'Calle de la Carrera 47', '45003', 39.86252, -4.02071, 'approximate', 'openstreetmap:node/4181507647'),
  ('catalogo-castilla-la-mancha:estaciones:node-4896717721', 'Estación de autobuses de tren (Toledo) – Paseo de la Rosa', 'Autobús', '45168', 'Paseo de la Rosa', '45006', 39.8622, -4.01131, 'address', 'openstreetmap:node/4896717721'),
  ('catalogo-castilla-la-mancha:estaciones:node-7966358582', 'Estación de autobuses de Puerta Este (Quintanar de la Orden) – Avenida Jardines de la Estación', 'Autobús', '45142', 'Avenida Jardines de la Estación', NULL, 39.59525, -3.04731, 'approximate', 'openstreetmap:node/7966358582'),
  ('catalogo-castilla-la-mancha:estaciones:node-7966358583', 'Estación de autobuses de Puerta Sur (Quintanar de la Orden) – Avenida Jardines de la Estación', 'Autobús', '45142', 'Avenida Jardines de la Estación', NULL, 39.59512, -3.04739, 'approximate', 'openstreetmap:node/7966358583'),
  ('catalogo-castilla-la-mancha:estaciones:node-7966358584', 'Estación de autobuses de Puerta Oeste (Quintanar de la Orden) – Avenida Jardines de la Estación', 'Autobús', '45142', 'Avenida Jardines de la Estación', NULL, 39.59515, -3.04756, 'approximate', 'openstreetmap:node/7966358584'),
  ('catalogo-castilla-la-mancha:estaciones:relation-11546887', 'Estación de Autobuses de Toledo – Trasera Estación de Autobuses', 'Autobús', '45168', 'Trasera Estación de Autobuses', '45003', 39.86557, -4.02026, 'address', 'openstreetmap:relation/11546887'),
  ('catalogo-castilla-la-mancha:estaciones:way-1004982012', 'Estación de autobuses de Consuegra – Avenida de Castilla La Mancha', 'Autobús', '45053', 'Avenida de Castilla La Mancha', '45700', 39.46166, -3.60725, 'address', 'openstreetmap:way/1004982012'),
  ('catalogo-castilla-la-mancha:estaciones:way-1478622917', 'Estación de Autobuses (Miguel Esteban) – Calle Alcázar', 'Autobús', '45101', 'Calle Alcázar 15', '45830', 39.52327, -3.08071, 'address', 'openstreetmap:way/1478622917'),
  ('catalogo-castilla-la-mancha:estaciones:way-192354335', 'Estación de Autobuses (Madridejos) – Calle del Cristo', 'Autobús', '45087', 'Calle del Cristo', NULL, 39.46439, -3.52919, 'address', 'openstreetmap:way/192354335'),
  ('catalogo-castilla-la-mancha:estaciones:way-293129880', 'Estación de Autobuses (Corral de Almaguer) – Calle de la Piedad', 'Autobús', '45054', 'Calle de la Piedad', NULL, 39.75815, -3.16689, 'address', 'openstreetmap:way/293129880'),
  ('catalogo-castilla-la-mancha:estaciones:way-303410539', 'Estación de Autobuses (La Puebla de Montalbán) – Calle Nueva de Alfares', 'Autobús', '45136', 'Calle Nueva de Alfares', '45516', 39.87057, -4.3601, 'address', 'openstreetmap:way/303410539'),
  ('catalogo-castilla-la-mancha:estaciones:way-466224362', 'Estación de Autobuses de Quintanar de la Orden – Avenida Jardines de la Estación', 'Autobús', '45142', 'Avenida Jardines de la Estación', NULL, 39.59518, -3.04742, 'approximate', 'openstreetmap:way/466224362'),
  ('catalogo-castilla-la-mancha:estaciones:way-498010046', 'Estación de Autobuses (Torrijos) – Calle de la Carretera de Gerindote', 'Autobús', '45173', 'Calle de la Carretera de Gerindote', NULL, 39.97951, -4.28621, 'address', 'openstreetmap:way/498010046'),
  ('catalogo-castilla-la-mancha:estaciones:way-645764835', 'Estación de Autobuses de Talavera de la Reina – Avenida de Toledo', 'Autobús', '45165', 'Avenida de Toledo', '45600', 39.96251, -4.82588, 'address', 'openstreetmap:way/645764835');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '45');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 45 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '45'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 26 THEN
    RAISE EXCEPTION 'Se esperaban 26 puntos de Estaciones en Toledo, hay %', n;
  END IF;
END;
$$;

COMMIT;
