-- Carga de la categoría Estaciones de Teruel (provincia 44), trozo de la carga de Andalucía.
-- Origen: estaciones-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 25 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-aragon:estaciones:node-12117543660', 'Estación de tren de Lechago (Calamocha)', 'Tren', '44050', NULL, NULL, 40.95765, -1.26904, 'address', 'openstreetmap:node/12117543660'),
  ('catalogo-aragon:estaciones:node-12589984751', 'Estación de tren de Cuencabuena (Calamocha)', 'Tren', '44050', NULL, NULL, 41.00931, -1.25479, 'address', 'openstreetmap:node/12589984751'),
  ('catalogo-aragon:estaciones:node-13378853513', 'Estación de tren de La Puebla de Híjar – Plaza Reino de Aragón', 'Tren', '44191', 'Plaza Reino de Aragón', NULL, 41.22451, -0.43819, 'address', 'openstreetmap:node/13378853513'),
  ('catalogo-aragon:estaciones:node-13378853528', 'Estación de tren de Samper (Samper de Calanda) – Ctra. Estación Ferrocarril', 'Tren', '44205', 'Ctra. Estación Ferrocarril', '44520', 41.18208, -0.36874, 'address', 'openstreetmap:node/13378853528'),
  ('catalogo-aragon:estaciones:node-13397831246', 'Estación de tren de Navarrete (Calamocha)', 'Tren', '44050', NULL, NULL, 40.93708, -1.26171, 'address', 'openstreetmap:node/13397831246'),
  ('catalogo-aragon:estaciones:node-2074611275', 'Estación de tren de Santa Eulalia del Campo – Barrio de la Estación', 'Tren', '44209', 'Barrio de la Estación', '44360', 40.57306, -1.31292, 'address', 'openstreetmap:node/2074611275'),
  ('catalogo-aragon:estaciones:node-2074634373', 'Estación de tren de Villafranca del Campo', 'Tren', '44251', NULL, NULL, 40.68377, -1.35823, 'address', 'openstreetmap:node/2074634373'),
  ('catalogo-aragon:estaciones:node-2331789915', 'Estación de tren de Monreal del Campo', 'Tren', '44153', NULL, NULL, 40.78229, -1.36085, 'address', 'openstreetmap:node/2331789915'),
  ('catalogo-aragon:estaciones:node-2331876446', 'Estación de tren de Rubielos de Mora (Albentosa)', 'Tren', '44010', NULL, NULL, 40.11063, -0.74095, 'address', 'openstreetmap:node/2331876446'),
  ('catalogo-aragon:estaciones:node-248952708', 'Estación de Autobuses (Teruel) – Ronda Ambeles 6A', 'Autobús', '44216', 'Ronda Ambeles 6A', '44001', 40.34227, -1.10434, 'approximate', 'openstreetmap:node/248952708'),
  ('catalogo-aragon:estaciones:node-358544296', 'Estación de tren de Puerto del Escandón (La Puebla de Valverde)', 'Tren', '44192', NULL, NULL, 40.27321, -0.9852, 'address', 'openstreetmap:node/358544296'),
  ('catalogo-aragon:estaciones:node-359166884', 'Estación de tren de Cella', 'Tren', '44076', NULL, NULL, 40.45529, -1.24479, 'address', 'openstreetmap:node/359166884'),
  ('catalogo-aragon:estaciones:node-368243347', 'Estación de tren de Teruel – Camino de la Estación', 'Tren', '44216', 'Camino de la Estación', NULL, 40.34099, -1.11042, 'address', 'openstreetmap:node/368243347'),
  ('catalogo-aragon:estaciones:node-5937929969', 'Estación de tren de Caminreal-Fuentes Claras', 'Tren', '44056', NULL, NULL, 40.85045, -1.33858, 'address', 'openstreetmap:node/5937929969'),
  ('catalogo-aragon:estaciones:node-5940860995', 'Estación de tren de Torrijo del Campo – Calle Alemania', 'Tren', '44232', 'Calle Alemania', NULL, 40.82625, -1.34052, 'address', 'openstreetmap:node/5940860995'),
  ('catalogo-aragon:estaciones:node-6167041751', 'Estación de tren de Puebla de Valverde (La Puebla de Valverde)', 'Tren', '44192', NULL, NULL, 40.21239, -0.94395, 'address', 'openstreetmap:node/6167041751'),
  ('catalogo-aragon:estaciones:node-6167089167', 'Estación de tren de Mora de Rubielos (Albentosa) – Calle de la Estación', 'Tren', '44010', 'Calle de la Estación', NULL, 40.11784, -0.77347, 'address', 'openstreetmap:node/6167089167'),
  ('catalogo-aragon:estaciones:node-8060131557', 'Estación de tren de Sarrión – Acceso a la estación de ferrocarril de Sarrión', 'Tren', '44210', 'Acceso a la estación de ferrocarril de Sarrión', NULL, 40.14615, -0.82358, 'address', 'openstreetmap:node/8060131557'),
  ('catalogo-aragon:estaciones:node-8075148246', 'Estación de tren de Ferreruela (Ferreruela de Huerva) – Calle Estación', 'Tren', '44101', 'Calle Estación', NULL, 41.06384, -1.23859, 'address', 'openstreetmap:node/8075148246'),
  ('catalogo-aragon:estaciones:node-8576900308', 'Estación de Autobuses de Teruel – Ronda Ambeles 6A', 'Autobús', '44216', 'Ronda Ambeles 6A', '44001', 40.34226, -1.10421, 'approximate', 'openstreetmap:node/8576900308'),
  ('catalogo-aragon:estaciones:node-8697676633', 'Estación de tren de Villahermosa (Villahermosa del Campo)', 'Tren', '44252', NULL, NULL, 41.10852, -1.23985, 'address', 'openstreetmap:node/8697676633'),
  ('catalogo-aragon:estaciones:way-1040818932', 'Estación de autobuses de Alcañiz – Avenida Maestrazgo', 'Autobús', '44013', 'Avenida Maestrazgo', '44600', 41.0422, -0.12786, 'address', 'openstreetmap:way/1040818932'),
  ('catalogo-aragon:estaciones:way-149880616', 'Estación de tren de Calamocha-Nueva', 'Tren', '44050', NULL, NULL, 40.90344, -1.30039, 'address', 'openstreetmap:way/149880616'),
  ('catalogo-aragon:estaciones:way-255410888', 'Estación de autobuses de Calamocha – Calle Eras', 'Autobús', '44050', 'Calle Eras', NULL, 40.91421, -1.29701, 'address', 'openstreetmap:way/255410888'),
  ('catalogo-aragon:estaciones:way-280975185', 'Estación de Autobuses de Andorra – Calle Hortales', 'Autobús', '44025', 'Calle Hortales', NULL, 40.97912, -0.44396, 'address', 'openstreetmap:way/280975185');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '44');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 44 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '44'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 25 THEN
    RAISE EXCEPTION 'Se esperaban 25 puntos de Estaciones en Teruel, hay %', n;
  END IF;
END;
$$;

COMMIT;
