-- Carga de la categoría Estaciones de Navarra (provincia 31), trozo de la carga de Andalucía.
-- Origen: estaciones-navarra.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 26 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-navarra:estaciones:node-11757382798', 'Estación de tren de Pamplona / Iruña – Parking de la Estación', 'Tren', '31201', 'Parking de la Estación', '31012', 42.82505, -1.66149, 'address', 'openstreetmap:node/11757382798'),
  ('catalogo-navarra:estaciones:node-13687517346', 'Estación de autobuses de Pamplona / Iruña – Yanguas y Miranda kalea', 'Autobús', '31201', 'Yanguas y Miranda kalea', NULL, 42.81131, -1.64592, 'address', 'openstreetmap:node/13687517346'),
  ('catalogo-navarra:estaciones:node-2090101642', 'Estación de tren de Féculas-Navarra (Lodosa)', 'Tren', '31157', NULL, NULL, 42.41116, -2.09801, 'address', 'openstreetmap:node/2090101642'),
  ('catalogo-navarra:estaciones:node-2090104052', 'Estación de tren de Lodosa', 'Tren', '31157', NULL, NULL, 42.38065, -2.07128, 'address', 'openstreetmap:node/2090104052'),
  ('catalogo-navarra:estaciones:node-2091462887', 'Estación de tren de Noain-Aeropuerto / Aireportua (Valle de Elorz / Elortzibar) – Geltoki kalea', 'Tren', '31088', 'Geltoki kalea', '31110', 42.75469, -1.63621, 'address', 'openstreetmap:node/2091462887'),
  ('catalogo-navarra:estaciones:node-2118941959', 'Estación de tren de Uharte-Arakil – Geltokiko kalea', 'Tren', '31123', 'Geltokiko kalea', NULL, 42.92039, -1.97483, 'address', 'openstreetmap:node/2118941959'),
  ('catalogo-navarra:estaciones:node-2121281730', 'Estación de tren de Olite (Olite / Erriberri) – Calle de la Estación', 'Tren', '31191', 'Calle de la Estación 25', '31390', 42.48513, -1.64976, 'address', 'openstreetmap:node/2121281730'),
  ('catalogo-navarra:estaciones:node-244184062', 'Estación de tren de Tafalla – San José', 'Tren', '31227', 'San José 26', '31300', 42.52575, -1.67121, 'address', 'openstreetmap:node/244184062'),
  ('catalogo-navarra:estaciones:node-256730491', 'Estación de autobuses de Tudela – Cuesta de la Estación', 'Autobús', '31232', 'Cuesta de la Estación 3', '31500', 42.059, -1.59746, 'address', 'openstreetmap:node/256730491'),
  ('catalogo-navarra:estaciones:node-26212732', 'Estación de tren de Villafranca de Navarra – Avenida de Miguel de Cervantes', 'Tren', '31254', 'Avenida de Miguel de Cervantes', NULL, 42.28074, -1.74544, 'address', 'openstreetmap:node/26212732'),
  ('catalogo-navarra:estaciones:node-26230611', 'Estación de tren de Castejón de Ebro – Calle Jerónimo Marco', 'Tren', '31070', 'Calle Jerónimo Marco', NULL, 42.17287, -1.69244, 'address', 'openstreetmap:node/26230611'),
  ('catalogo-navarra:estaciones:node-26377011', 'Estación de tren de Tudela de Navarra – Plaza de la estación', 'Tren', '31232', 'Plaza de la estación', '31500', 42.0595, -1.59766, 'address', 'openstreetmap:node/26377011'),
  ('catalogo-navarra:estaciones:node-26377358', 'Estación de tren de Ribaforada – Calle Teodoro Gascón', 'Tren', '31208', 'Calle Teodoro Gascón', NULL, 41.99707, -1.51548, 'address', 'openstreetmap:node/26377358'),
  ('catalogo-navarra:estaciones:node-26837751', 'Estación de tren de Etxarri-Aranatz – Basopokale', 'Tren', '31084', 'Basopokale', NULL, 42.91096, -2.07173, 'address', 'openstreetmap:node/26837751'),
  ('catalogo-navarra:estaciones:node-287467020', 'Estación de tren de Marcilla de Navarra – Marcilla de Navarra', 'Tren', '31163', 'Marcilla de Navarra', '31340', 42.33471, -1.71722, 'address', 'openstreetmap:node/287467020'),
  ('catalogo-navarra:estaciones:node-2961586517', 'Estación de tren de Cortes de Navarra – Calle Ferrocarril', 'Tren', '31078', 'Calle Ferrocarril', NULL, 41.91536, -1.42087, 'address', 'openstreetmap:node/2961586517'),
  ('catalogo-navarra:estaciones:node-326237700', 'Estación de autobuses de Cintruénigo – Calle Donantes De Sangre', 'Autobús', '31072', 'Calle Donantes De Sangre', NULL, 42.07985, -1.80191, 'address', 'openstreetmap:node/326237700'),
  ('catalogo-navarra:estaciones:node-4586116154', 'Estación de tren de Altsasu (Altsasu / Alsasua) – Geltokia kalea', 'Tren', '31010', 'Geltokia kalea', NULL, 42.89541, -2.18131, 'address', 'openstreetmap:node/4586116154'),
  ('catalogo-navarra:estaciones:node-4586116155', 'Estación de tren de Altsasu–Herria (Altsasu / Alsasua) – Beheko Benta', 'Tren', '31010', 'Beheko Benta 6', '31800', 42.89334, -2.16745, 'address', 'openstreetmap:node/4586116155'),
  ('catalogo-navarra:estaciones:node-7508510461', 'Estación de tren de Caparroso', 'Tren', '31065', NULL, NULL, 42.38096, -1.64529, 'address', 'openstreetmap:node/7508510461'),
  ('catalogo-navarra:estaciones:way-1342433987', 'Estación de tren de Biurrun Campanas (Biurrun-Olcoz) – Calle Estación', 'Tren', '31056', 'Calle Estación', '31398', 42.68988, -1.6524, 'address', 'openstreetmap:way/1342433987'),
  ('catalogo-navarra:estaciones:way-1432743644', 'Estación de autobuses de Cabanillas – Calle Juan XXIII', 'Autobús', '31062', 'Calle Juan XXIII 19', '31511', 42.03143, -1.52538, 'address', 'openstreetmap:way/1432743644'),
  ('catalogo-navarra:estaciones:way-300423746', 'Estación de autobuses de Estella (Estella-Lizarra) – Plaza de la Coronación', 'Autobús', '31097', 'Plaza de la Coronación 4', '31200', 42.67011, -2.03319, 'address', 'openstreetmap:way/300423746'),
  ('catalogo-navarra:estaciones:way-317492210', 'Estación de autobuses de Parada de la Baztanesa – Zubiondoa karrika', 'Autobús', '31050', 'Zubiondoa karrika 1', '31794', 43.14098, -1.56641, 'approximate', 'openstreetmap:way/317492210'),
  ('catalogo-navarra:estaciones:way-548172753', 'Estación de tren de Garinoain', 'Tren', '31114', NULL, NULL, 42.59888, -1.65008, 'address', 'openstreetmap:way/548172753'),
  ('catalogo-navarra:estaciones:way-692649047', 'Estación de tren de Carrascal (Unzué / Untzue) – Carretera de Pamplona', 'Tren', '31238', 'Carretera de Pamplona 1', '31396', 42.65279, -1.64559, 'address', 'openstreetmap:way/692649047');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '31');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 31 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '31'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 26 THEN
    RAISE EXCEPTION 'Se esperaban 26 puntos de Estaciones en Navarra, hay %', n;
  END IF;
END;
$$;

COMMIT;
