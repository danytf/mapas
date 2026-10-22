-- Carga de la categoría Correos de Cáceres (provincia 10), trozo de la carga de Andalucía.
-- Origen: postal_service-extremadura.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:56Z).
-- 36 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-extremadura:postal_service:node-10106967921', 'Correos Aldeanueva de la Vera – Calle del Maestro Aparicio', NULL, '10014', 'Calle del Maestro Aparicio 5', NULL, 40.1291, -5.6996, 'address', 'openstreetmap:node/10106967921'),
  ('catalogo-extremadura:postal_service:node-10605392748', 'Correos Madrigalejo – Calle Valeriano Muños', NULL, '10112', 'Calle Valeriano Muños', NULL, 39.13788, -5.62812, 'address', 'openstreetmap:node/10605392748'),
  ('catalogo-extremadura:postal_service:node-10726545817', 'Correos Pozuelo de Zarzón – Calle Iglesia', NULL, '10152', 'Calle Iglesia', '10813', 40.14939, -6.41547, 'address', 'openstreetmap:node/10726545817'),
  ('catalogo-extremadura:postal_service:node-10740810349', 'Correos Villanueva de la Sierra – Plaza de España', NULL, '10211', 'Plaza de España', '10812', 40.20069, -6.40588, 'address', 'openstreetmap:node/10740810349'),
  ('catalogo-extremadura:postal_service:node-10885939591', 'Correos Santa Marta de Magasca – Avenida de Extremadura', NULL, '10168', 'Avenida de Extremadura', '10198', 39.51024, -6.09893, 'address', 'openstreetmap:node/10885939591'),
  ('catalogo-extremadura:postal_service:node-11144592020', 'Correos Caminomorisco – Calle Portillita', NULL, '10041', 'Calle Portillita 14', NULL, 40.32598, -6.29248, 'address', 'openstreetmap:node/11144592020'),
  ('catalogo-extremadura:postal_service:node-1145674682', 'Correos Mirabel – Calle Cuesta', NULL, '10123', 'Calle Cuesta 2', '10540', 39.86145, -6.23342, 'address', 'openstreetmap:node/1145674682'),
  ('catalogo-extremadura:postal_service:node-12010185185', 'Correos Jarandilla de la Vera – Avenida de Soledad Vega Ortiz', NULL, '10105', 'Avenida de Soledad Vega Ortiz 135', '10450', 40.13089, -5.66337, 'address', 'openstreetmap:node/12010185185'),
  ('catalogo-extremadura:postal_service:node-1594869295', 'Correos Alcuéscar – Calle Madrid', NULL, '10010', 'Calle Madrid', '10160', 39.18013, -6.22752, 'address', 'openstreetmap:node/1594869295'),
  ('catalogo-extremadura:postal_service:node-2149678219', 'Correos Guadalupe – Calle del Poeta Ángel Marina', NULL, '10087', 'Calle del Poeta Ángel Marina', '10140', 39.45038, -5.32577, 'address', 'openstreetmap:node/2149678219'),
  ('catalogo-extremadura:postal_service:node-2445987631', 'Correos Hervás – Calle Gabriel y Galán', NULL, '10096', 'Calle Gabriel y Galán 42', '10700', 40.27535, -5.86166, 'address', 'openstreetmap:node/2445987631'),
  ('catalogo-extremadura:postal_service:node-2620064261', 'Correos Arroyo de la Luz – Calle Parra', NULL, '10021', 'Calle Parra', NULL, 39.48447, -6.58133, 'address', 'openstreetmap:node/2620064261'),
  ('catalogo-extremadura:postal_service:node-2694639524', 'Correos Cáceres – Calle Oaxaca', NULL, '10037', 'Calle Oaxaca 30', '10005', 39.45647, -6.37937, 'address', 'openstreetmap:node/2694639524'),
  ('catalogo-extremadura:postal_service:node-3455967906', 'Correos Trujillo – Calle de la Encarnación', NULL, '10195', 'Calle de la Encarnación 28', '10200', 39.4571, -5.8818, 'address', 'openstreetmap:node/3455967906'),
  ('catalogo-extremadura:postal_service:node-3643289486', 'Correos Jarandilla de la Vera – Calle de Gabriel Acedo de la Berrueza', NULL, '10105', 'Calle de Gabriel Acedo de la Berrueza 34', '10450', 40.1272, -5.6598, 'address', 'openstreetmap:node/3643289486'),
  ('catalogo-extremadura:postal_service:node-3669253294', 'Correos Gata – Plaza de la Constitución', NULL, '10084', 'Plaza de la Constitución', NULL, 40.23765, -6.59663, 'address', 'openstreetmap:node/3669253294'),
  ('catalogo-extremadura:postal_service:node-4004041552', 'Correos Montehermoso – Iglesia', NULL, '10127', 'Iglesia 4', '10810', 40.08896, -6.34986, 'address', 'openstreetmap:node/4004041552'),
  ('catalogo-extremadura:postal_service:node-4195366298', 'Correos Berzocana – Plaza de España', NULL, '10029', 'Plaza de España 1', NULL, 39.43689, -5.46061, 'address', 'openstreetmap:node/4195366298'),
  ('catalogo-extremadura:postal_service:node-4324469195', 'Correos Jaraíz de la Vera – Avenida de la Constitución', NULL, '10104', 'Avenida de la Constitución 17', NULL, 40.06078, -5.7515, 'address', 'openstreetmap:node/4324469195'),
  ('catalogo-extremadura:postal_service:node-452580404', 'Correos Cáceres – Avenida de España 2-bis', NULL, '10037', 'Avenida de España 2-bis', '10001', 39.47214, -6.37757, 'address', 'openstreetmap:node/452580404'),
  ('catalogo-extremadura:postal_service:node-4587821766', 'Correos Aldeanueva del Camino – Avenida Gabriel y Galán', NULL, '10015', 'Avenida Gabriel y Galán 60', '10740', 40.25964, -5.931, 'address', 'openstreetmap:node/4587821766'),
  ('catalogo-extremadura:postal_service:node-4643687721', 'Correos Baños de Montemayor – Calle Vía de la Plata', NULL, '10024', 'Calle Vía de la Plata 7', '10750', 40.31806, -5.85776, 'address', 'openstreetmap:node/4643687721'),
  ('catalogo-extremadura:postal_service:node-5301112121', 'Correos Losar de la Vera – Calle Real', NULL, '10110', 'Calle Real 2', '10460', 40.12075, -5.60388, 'address', 'openstreetmap:node/5301112121'),
  ('catalogo-extremadura:postal_service:node-5643914889', 'Correos Cuacos de Yuste – Calle de Teodoro Perianes', NULL, '10068', 'Calle de Teodoro Perianes 6', '10430', 40.1054, -5.72276, 'address', 'openstreetmap:node/5643914889'),
  ('catalogo-extremadura:postal_service:node-6077818668', 'Correos Valencia de Alcántara – Calle Rocamador', NULL, '10203', 'Calle Rocamador 40', '10500', 39.41152, -7.24183, 'address', 'openstreetmap:node/6077818668'),
  ('catalogo-extremadura:postal_service:node-613092873', 'Correos Logrosán – Calle Mario Roso de Luna', NULL, '10109', 'Calle Mario Roso de Luna 19', '10120', 39.33697, -5.49087, 'address', 'openstreetmap:node/613092873'),
  ('catalogo-extremadura:postal_service:node-6146168856', 'Correos Madroñera – Calle Valencia', NULL, '10113', 'Calle Valencia', NULL, 39.42491, -5.75907, 'address', 'openstreetmap:node/6146168856'),
  ('catalogo-extremadura:postal_service:node-6163765656', 'Correos Aldeacentenera – Calle Antonio Machado', NULL, '10011', 'Calle Antonio Machado', NULL, 39.52746, -5.62931, 'address', 'openstreetmap:node/6163765656'),
  ('catalogo-extremadura:postal_service:node-6178340885', 'Correos Valverde del Fresno – 1º de Mayo', NULL, '10205', '1º de Mayo', '10890', 40.22461, -6.87913, 'address', 'openstreetmap:node/6178340885'),
  ('catalogo-extremadura:postal_service:node-6216439177', 'Correos Hoyos – Avenida Extremadura', NULL, '10100', 'Avenida Extremadura', '10850', 40.1722, -6.71969, 'address', 'openstreetmap:node/6216439177'),
  ('catalogo-extremadura:postal_service:node-710745557', 'Correos Casar de Cáceres – Calle Larga Alta', NULL, '10049', 'Calle Larga Alta', '10190', 39.55913, -6.41649, 'address', 'openstreetmap:node/710745557'),
  ('catalogo-extremadura:postal_service:node-7725331816', 'Correos Miajadas – Calle de Colón', NULL, '10121', 'Calle de Colón', NULL, 39.15374, -5.90907, 'address', 'openstreetmap:node/7725331816'),
  ('catalogo-extremadura:postal_service:node-8260177518', 'Correos Salorino – Calle del Cura', NULL, '10162', 'Calle del Cura 10', '10570', 39.4791, -7.00857, 'address', 'openstreetmap:node/8260177518'),
  ('catalogo-extremadura:postal_service:node-8822447872', 'Correos Coria – Avenida Sierra de Gata', NULL, '10067', 'Avenida Sierra de Gata 49', '10800', 39.98843, -6.53877, 'address', 'openstreetmap:node/8822447872'),
  ('catalogo-extremadura:postal_service:way-1083828414', 'Correos Baños de Montemayor – Avenida de Extremadura', NULL, '10024', 'Avenida de Extremadura', '10750', 40.31703, -5.8602, 'address', 'openstreetmap:way/1083828414'),
  ('catalogo-extremadura:postal_service:way-650716207', 'Correos Plasencia – Avda. de Alfonso VIII', NULL, '10148', 'Avda. de Alfonso VIII', '10600', 40.02901, -6.08783, 'address', 'openstreetmap:way/650716207');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 36 THEN
    RAISE EXCEPTION 'Se esperaban 36 puntos de Correos en Cáceres, hay %', n;
  END IF;
END;
$$;

COMMIT;
