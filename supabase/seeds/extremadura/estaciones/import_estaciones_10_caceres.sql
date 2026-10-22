-- Carga de la categoría Estaciones de Cáceres (provincia 10), trozo de la carga de Andalucía.
-- Origen: estaciones-extremadura.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:56Z).
-- 28 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-extremadura:estaciones:node-1073008477', 'Estación de tren de Casatejada', 'Tren', '10058', NULL, NULL, 39.89199, -5.67764, 'address', 'openstreetmap:node/1073008477'),
  ('catalogo-extremadura:estaciones:node-13714976346', 'Estación de tren de Cáceres – Avenida de Alemania', 'Tren', '10037', 'Avenida de Alemania', '10005', 39.46118, -6.38572, 'address', 'openstreetmap:node/13714976346'),
  ('catalogo-extremadura:estaciones:node-13715660837', 'Estación de tren de Navalmoral de la Mata – Paseo de la Estación', 'Tren', '10131', 'Paseo de la Estación 1', '10300', 39.89496, -5.54565, 'address', 'openstreetmap:node/13715660837'),
  ('catalogo-extremadura:estaciones:node-1585506300', 'Estación de tren de Arroyo de Malpartida (Cáceres) – Plaza Patio de Viajeros', 'Tren', '10037', 'Plaza Patio de Viajeros', NULL, 39.46807, -6.53447, 'address', 'openstreetmap:node/1585506300'),
  ('catalogo-extremadura:estaciones:node-1890818693', 'Parada de Autobuses (Cañamero) – Avenida de Cervantes', 'Autobús', '10044', 'Avenida de Cervantes', NULL, 39.38313, -5.38917, 'approximate', 'openstreetmap:node/1890818693'),
  ('catalogo-extremadura:estaciones:node-2328131196', 'Estación de tren de Casas de Millán', 'Tren', '10056', NULL, NULL, 39.81206, -6.32569, 'address', 'openstreetmap:node/2328131196'),
  ('catalogo-extremadura:estaciones:node-2328131197', 'Estación de tren de Cañaveral – Calle Barrio de la Estación', 'Tren', '10045', 'Calle Barrio de la Estación', NULL, 39.78881, -6.37452, 'address', 'openstreetmap:node/2328131197'),
  ('catalogo-extremadura:estaciones:node-2328131200', 'Estación de tren de Monfragüe (Malpartida de Plasencia) – Carretera de Malpartida de Plasencia a Estación Ferrocarril de Monfragüe', 'Tren', '10116', 'Carretera de Malpartida de Plasencia a Estación Ferrocarril de Monfragüe', NULL, 39.93762, -6.10125, 'address', 'openstreetmap:node/2328131200'),
  ('catalogo-extremadura:estaciones:node-325231127', 'Estación de tren de Plasencia – Avenida del Ambroz', 'Tren', '10148', 'Avenida del Ambroz', '10600', 40.02226, -6.09963, 'address', 'openstreetmap:node/325231127'),
  ('catalogo-extremadura:estaciones:node-349044413', 'Estación de tren de Mirabel – Calle Adolfo de Miguel', 'Tren', '10123', 'Calle Adolfo de Miguel 36', '10540', 39.86621, -6.22895, 'address', 'openstreetmap:node/349044413'),
  ('catalogo-extremadura:estaciones:node-3887503141', 'Estación de Autobuses (Arroyo de la Luz) – Calle Regajal', 'Autobús', '10021', 'Calle Regajal', '10900', 39.48197, -6.58249, 'approximate', 'openstreetmap:node/3887503141'),
  ('catalogo-extremadura:estaciones:node-6427733921', 'Estación de autobuses de Hospital Universitario (Cáceres)', 'Autobús', '10037', NULL, NULL, 39.47552, -6.32999, 'address', 'openstreetmap:node/6427733921'),
  ('catalogo-extremadura:estaciones:node-683597660', 'Estación de tren de Valencia de Alcántara', 'Tren', '10203', NULL, NULL, 39.42694, -7.23072, 'address', 'openstreetmap:node/683597660'),
  ('catalogo-extremadura:estaciones:node-936179799', 'Estación de autobuses de Casar de Cáceres – Avenida Ejido de Abajo', 'Autobús', '10049', 'Avenida Ejido de Abajo 57', '10190', 39.56085, -6.41508, 'address', 'openstreetmap:node/936179799'),
  ('catalogo-extremadura:estaciones:way-1151604399', 'Estación de Autobuses (Montehermoso) – Calle Estación', 'Autobús', '10127', 'Calle Estación', NULL, 40.08563, -6.34864, 'address', 'openstreetmap:way/1151604399'),
  ('catalogo-extremadura:estaciones:way-127395057', 'Estación de Autobuses de Plasencia – Calle Tornavacas', 'Autobús', '10148', 'Calle Tornavacas 2', '10600', 40.03286, -6.08023, 'address', 'openstreetmap:way/127395057'),
  ('catalogo-extremadura:estaciones:way-1359391563', 'Estación De Autobuses Jaraiz De La Vera – Avenida de la Constitución', 'Autobús', '10104', 'Avenida de la Constitución', NULL, 40.05428, -5.75749, 'address', 'openstreetmap:way/1359391563'),
  ('catalogo-extremadura:estaciones:way-153045358', 'Estación de Autobuses de Cáceres – Calle Túnez', 'Autobús', '10037', 'Calle Túnez', '10005', 39.46002, -6.38226, 'address', 'openstreetmap:way/153045358'),
  ('catalogo-extremadura:estaciones:way-297304561', 'Parada de Autobús (Villanueva de la Sierra) – Plaza del Egido', 'Autobús', '10211', 'Plaza del Egido', NULL, 40.2024, -6.40719, 'approximate', 'openstreetmap:way/297304561'),
  ('catalogo-extremadura:estaciones:way-410683709', 'Estación de Autobuses (Miajadas) – Calle los Naranjos', 'Autobús', '10121', 'Calle los Naranjos', NULL, 39.14639, -5.91476, 'address', 'openstreetmap:way/410683709'),
  ('catalogo-extremadura:estaciones:way-470124927', 'Estaciòn de Autobuses de Montemayor (Baños de Montemayor) – Plaza del Arenal', 'Autobús', '10024', 'Plaza del Arenal', '10750', 40.31813, -5.8592, 'address', 'openstreetmap:way/470124927'),
  ('catalogo-extremadura:estaciones:way-522942050', 'Estación de autobuses de Trujillo – Calle Ferial', 'Autobús', '10195', 'Calle Ferial', NULL, 39.452, -5.88223, 'address', 'openstreetmap:way/522942050'),
  ('catalogo-extremadura:estaciones:way-563710791', 'Estación de Autobuses (Valencia de Alcántara) – Calle Congregación Hijas de la Virgen', 'Autobús', '10203', 'Calle Congregación Hijas de la Virgen 11', NULL, 39.40754, -7.2483, 'address', 'openstreetmap:way/563710791'),
  ('catalogo-extremadura:estaciones:way-640582138', 'Estación de Autobuses de Moraleja – Calle Trinidad Ruiz Téllez', 'Autobús', '10128', 'Calle Trinidad Ruiz Téllez', '10840', 40.06724, -6.6542, 'address', 'openstreetmap:way/640582138'),
  ('catalogo-extremadura:estaciones:way-642650907', 'Estación de Autobuses de Coria – Calle El Salvador', 'Autobús', '10067', 'Calle El Salvador', '10800', 39.98925, -6.53277, 'address', 'openstreetmap:way/642650907'),
  ('catalogo-extremadura:estaciones:way-655440158', 'Estación de Autobuses Arroyo de la Luz – Calle Regajal', 'Autobús', '10021', 'Calle Regajal', '10900', 39.48198, -6.5825, 'approximate', 'openstreetmap:way/655440158'),
  ('catalogo-extremadura:estaciones:way-802997330', 'Estación de Autobuses (Hervás) – Avenida de España', 'Autobús', '10096', 'Avenida de España', '10700', 40.27348, -5.86263, 'address', 'openstreetmap:way/802997330'),
  ('catalogo-extremadura:estaciones:way-92426326', 'Estación de autobuses de Navalmoral de la Mata – Carretera Jarandilla', 'Autobús', '10131', 'Carretera Jarandilla', '10300', 39.89494, -5.54445, 'address', 'openstreetmap:way/92426326');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '10');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 10 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '10'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 28 THEN
    RAISE EXCEPTION 'Se esperaban 28 puntos de Estaciones en Cáceres, hay %', n;
  END IF;
END;
$$;

COMMIT;
