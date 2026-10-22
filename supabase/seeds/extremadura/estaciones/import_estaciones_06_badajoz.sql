-- Carga de la categoría Estaciones de Badajoz (provincia 06), trozo de la carga de Andalucía.
-- Origen: estaciones-extremadura.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:56Z).
-- 56 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:extremadura-estaciones:node-12571012002', 'Estación de tren de Villanueva de la Serena – Calle José Gallardo', 'Tren', '06153', 'Calle José Gallardo', NULL, 38.96867, -5.7965, 'address', 'openstreetmap:node/12571012002'),
  ('catalogo-andalucia:extremadura-estaciones:node-12589890277', 'Estación de tren de Castuera – Plaza del Retraso', 'Tren', '06036', 'Plaza del Retraso', NULL, 38.73511, -5.54169, 'address', 'openstreetmap:node/12589890277'),
  ('catalogo-andalucia:extremadura-estaciones:node-12590020268', 'Estación de tren de Valdetorres – Calle Luis Chamizo', 'Tren', '06138', 'Calle Luis Chamizo', '06474', 38.9133, -6.06941, 'address', 'openstreetmap:node/12590020268'),
  ('catalogo-andalucia:extremadura-estaciones:node-12819863889', 'Estación de tren de Campanario', 'Tren', '06028', NULL, NULL, 38.8533, -5.64149, 'address', 'openstreetmap:node/12819863889'),
  ('catalogo-andalucia:extremadura-estaciones:node-14144255687', 'Estación de Autobuses de Almendralejo – Calle Santa María de Cora', 'Autobús', '06011', 'Calle Santa María de Cora', '06200', 38.67567, -6.39656, 'address', 'openstreetmap:node/14144255687'),
  ('catalogo-andalucia:extremadura-estaciones:node-14144255688', 'Estación de Autobuses de Zafra – Avenida de los Príncipes', 'Autobús', '06158', 'Avenida de los Príncipes', NULL, 38.42753, -6.41104, 'approximate', 'openstreetmap:node/14144255688'),
  ('catalogo-andalucia:extremadura-estaciones:node-1495837646', 'Estación de tren de Don Benito – Avenida de la Constitución', 'Tren', '06044', 'Avenida de la Constitución', NULL, 38.96706, -5.86293, 'address', 'openstreetmap:node/1495837646'),
  ('catalogo-andalucia:extremadura-estaciones:node-1741275667', 'Estación de tren de Zafra', 'Tren', '06158', NULL, NULL, 38.41395, -6.40518, 'address', 'openstreetmap:node/1741275667'),
  ('catalogo-andalucia:extremadura-estaciones:node-1787131924', 'Estación de autobuses de Guareña – Calle Vicente Alexander', 'Autobús', '06060', 'Calle Vicente Alexander', '06470', 38.86092, -6.09613, 'address', 'openstreetmap:node/1787131924'),
  ('catalogo-andalucia:extremadura-estaciones:node-1900394161', 'Estación de tren de Guareña', 'Tren', '06060', NULL, NULL, 38.89692, -6.12902, 'address', 'openstreetmap:node/1900394161'),
  ('catalogo-andalucia:extremadura-estaciones:node-1972336081', 'Estación de Autobuses de Llerena – Paseo Cieza de León', 'Autobús', '06074', 'Paseo Cieza de León', '06900', 38.23677, -6.01055, 'address', 'openstreetmap:node/1972336081'),
  ('catalogo-andalucia:extremadura-estaciones:node-1972336082', 'Estación de tren de Llerena – Barriada de la estación', 'Tren', '06074', 'Barriada de la estación', '06900', 38.23775, -6.00962, 'address', 'openstreetmap:node/1972336082'),
  ('catalogo-andalucia:extremadura-estaciones:node-2039781019', 'Estación de tren de Mérida – Calle Carderos', 'Tren', '06083', 'Calle Carderos', NULL, 38.92159, -6.34305, 'address', 'openstreetmap:node/2039781019'),
  ('catalogo-andalucia:extremadura-estaciones:node-2333726540', 'Estación de tren de San Vicente de Alcántara', 'Tren', '06123', NULL, NULL, 39.38155, -7.11698, 'address', 'openstreetmap:node/2333726540'),
  ('catalogo-andalucia:extremadura-estaciones:node-2962633346', 'Estación de tren de Badajoz – Cáceres a Badajoz', 'Tren', '06015', 'Cáceres a Badajoz', NULL, 38.89073, -6.98162, 'address', 'openstreetmap:node/2962633346'),
  ('catalogo-andalucia:extremadura-estaciones:node-2962633353', 'Estación de tren de Montijo – Ctra. Estación', 'Tren', '06088', 'Ctra. Estación', '06840', 38.91358, -6.59867, 'address', 'openstreetmap:node/2962633353'),
  ('catalogo-andalucia:extremadura-estaciones:node-2962633354', 'Estación de tren de Guadiana – Carretera de Guadiana a EX-209', 'Tren', '06903', 'Carretera de Guadiana a EX-209', NULL, 38.92177, -6.69002, 'address', 'openstreetmap:node/2962633354'),
  ('catalogo-andalucia:extremadura-estaciones:node-444122528', 'Estación de tren de Garrovilla - Las Vegas (La Garrovilla) – Carretera de la Estación', 'Tren', '06058', 'Carretera de la Estación', '06870', 38.91537, -6.47721, 'address', 'openstreetmap:node/444122528'),
  ('catalogo-andalucia:extremadura-estaciones:node-539005521', 'Estación de tren de Cabeza Del Buey – Barriada de la Estación', 'Tren', '06023', 'Barriada de la Estación', NULL, 38.72394, -5.22708, 'address', 'openstreetmap:node/539005521'),
  ('catalogo-andalucia:extremadura-estaciones:node-5461930431', 'Estación de Autobuses (Villafranca de los Barros) – Avenida de Fernando Aranguren', 'Autobús', '06149', 'Avenida de Fernando Aranguren', '06220', 38.55986, -6.34749, 'address', 'openstreetmap:node/5461930431'),
  ('catalogo-andalucia:extremadura-estaciones:node-7042360728', 'Estación de tren de Aljucén (Mérida)', 'Tren', '06083', NULL, NULL, 38.93625, -6.40788, 'address', 'openstreetmap:node/7042360728'),
  ('catalogo-andalucia:extremadura-estaciones:node-774864973', 'Estación de Autobús de Alburquerque – Avenida de los Emigrantes', 'Autobús', '06006', 'Avenida de los Emigrantes', '06510', 39.22423, -6.99884, 'address', 'openstreetmap:node/774864973'),
  ('catalogo-andalucia:extremadura-estaciones:node-7785762854', 'Estación de tren de Fuente del Arco', 'Tren', '06053', NULL, NULL, 38.16367, -5.90041, 'address', 'openstreetmap:node/7785762854'),
  ('catalogo-andalucia:extremadura-estaciones:node-7785762865', 'Estación de tren de Zafra Feria – Carretera de N-630 a Fregenal de la Sierra por Zafra', 'Tren', '06158', 'Carretera de N-630 a Fregenal de la Sierra por Zafra', '06300', 38.42447, -6.40973, 'address', 'openstreetmap:node/7785762865'),
  ('catalogo-andalucia:extremadura-estaciones:node-7785762866', 'Estación de tren de Los Santos de Maimona', 'Tren', '06122', NULL, NULL, 38.44975, -6.36151, 'address', 'openstreetmap:node/7785762866'),
  ('catalogo-andalucia:extremadura-estaciones:node-7785762867', 'Estación de tren de Villafranca de los Barros – Paseo de la Estación', 'Tren', '06149', 'Paseo de la Estación', NULL, 38.56447, -6.35222, 'address', 'openstreetmap:node/7785762867'),
  ('catalogo-andalucia:extremadura-estaciones:node-7785762869', 'Estación de tren de Almendralejo – Plaza Matías Pérez Fernández', 'Tren', '06011', 'Plaza Matías Pérez Fernández', '06200', 38.68468, -6.39953, 'address', 'openstreetmap:node/7785762869'),
  ('catalogo-andalucia:extremadura-estaciones:node-7785762875', 'Estación de tren de Calamonte – Avenida de José de Espronceda', 'Tren', '06025', 'Avenida de José de Espronceda', NULL, 38.88687, -6.38281, 'address', 'openstreetmap:node/7785762875'),
  ('catalogo-andalucia:extremadura-estaciones:node-7788690540', 'Estación de tren de Fregenal de la Sierra – Carretera de la Estación', 'Tren', '06050', 'Carretera de la Estación', NULL, 38.16771, -6.63754, 'address', 'openstreetmap:node/7788690540'),
  ('catalogo-andalucia:extremadura-estaciones:node-7804977670', 'Estación de tren de Almorchón (Cabeza del Buey)', 'Tren', '06023', NULL, NULL, 38.69646, -5.29036, 'address', 'openstreetmap:node/7804977670'),
  ('catalogo-andalucia:extremadura-estaciones:node-9665651329', 'Estación de tren de Montijo - El Molino – Calle Cerro de la Cruz', 'Tren', '06088', 'Calle Cerro de la Cruz', NULL, 38.91402, -6.61824, 'address', 'openstreetmap:node/9665651329'),
  ('catalogo-andalucia:extremadura-estaciones:way-100368728', 'Estación Autobuses Don Benito – Avenida de Alonso Martín', 'Autobús', '06044', 'Avenida de Alonso Martín', '06400', 38.96207, -5.86322, 'address', 'openstreetmap:way/100368728'),
  ('catalogo-andalucia:extremadura-estaciones:way-1123007856', 'Estación de Autobuses de Cabeza del Buey – Camino de Campanario', 'Autobús', '06023', 'Camino de Campanario', NULL, 38.71846, -5.22894, 'address', 'openstreetmap:way/1123007856'),
  ('catalogo-andalucia:extremadura-estaciones:way-1234892172', 'Estación de Autobuses de Granja de Torrehermosa – Carretera del Parque', 'Autobús', '06059', 'Carretera del Parque', NULL, 38.30709, -5.59358, 'address', 'openstreetmap:way/1234892172'),
  ('catalogo-andalucia:extremadura-estaciones:way-1237080052', 'Estación de Autobuses de Berlanga – Calle Tenería', 'Autobús', '06019', 'Calle Tenería', NULL, 38.27798, -5.82684, 'address', 'openstreetmap:way/1237080052'),
  ('catalogo-andalucia:extremadura-estaciones:way-171244112', 'Estación de Autobuses de Mérida – Avenida de la Libertad', 'Autobús', '06083', 'Avenida de la Libertad', '06800', 38.91474, -6.35793, 'address', 'openstreetmap:way/171244112'),
  ('catalogo-andalucia:extremadura-estaciones:way-220873169', 'Estación de Autobuses de Fuente de Cantos – Real', 'Autobús', '06052', 'Real', '06240', 38.24592, -6.30041, 'address', 'openstreetmap:way/220873169'),
  ('catalogo-andalucia:extremadura-estaciones:way-273296424', 'Estación de Autobuses (Villanueva de la Serena) – Calle Isabel Gallardo', 'Autobús', '06153', 'Calle Isabel Gallardo', NULL, 38.9698, -5.79654, 'address', 'openstreetmap:way/273296424'),
  ('catalogo-andalucia:extremadura-estaciones:way-336389605', 'Estación de Autobuses (Azuaga) – Calle Estalajes', 'Autobús', '06014', 'Calle Estalajes 169', '06920', 38.26122, -5.6858, 'address', 'openstreetmap:way/336389605'),
  ('catalogo-andalucia:extremadura-estaciones:way-385454286', 'Estación de Autobuses (Los Santos de Maimona) – Calle Francisco Pizarro', 'Autobús', '06122', 'Calle Francisco Pizarro', '06230', 38.44717, -6.37731, 'address', 'openstreetmap:way/385454286'),
  ('catalogo-andalucia:extremadura-estaciones:way-489842758', 'Estración de Autobuses de Zafra – Avenida de los Príncipes', 'Autobús', '06158', 'Avenida de los Príncipes', NULL, 38.42749, -6.41136, 'approximate', 'openstreetmap:way/489842758'),
  ('catalogo-andalucia:extremadura-estaciones:way-546304851', 'Parada de bus. (La Parra) – Carretera de Salvatierra', 'Autobús', '06099', 'Carretera de Salvatierra', NULL, 38.52161, -6.61787, 'approximate', 'openstreetmap:way/546304851'),
  ('catalogo-andalucia:extremadura-estaciones:way-547016283', 'Estación de Autobuses (Jerez de los Caballeros) – Calle Rodeo', 'Autobús', '06070', 'Calle Rodeo', NULL, 38.31996, -6.77918, 'address', 'openstreetmap:way/547016283'),
  ('catalogo-andalucia:extremadura-estaciones:way-547028242', 'Parada de Autobuses (Casas de Don Pedro) – Carretera de Pela', 'Autobús', '06033', 'Carretera de Pela', '06770', 39.10308, -5.33144, 'approximate', 'openstreetmap:way/547028242'),
  ('catalogo-andalucia:extremadura-estaciones:way-548883920', 'Estación de Autobuses (Castuera) – Calle Zújar', 'Autobús', '06036', 'Calle Zújar', NULL, 38.72544, -5.54798, 'address', 'openstreetmap:way/548883920'),
  ('catalogo-andalucia:extremadura-estaciones:way-551732523', 'Parada de Autobús (Monterrubio de la Serena) – Calle Cruces', 'Autobús', '06087', 'Calle Cruces', NULL, 38.59113, -5.4437, 'approximate', 'openstreetmap:way/551732523'),
  ('catalogo-andalucia:extremadura-estaciones:way-554727219', 'Parada de Autobuses (Higuera la Real) – Avenida de Portugal', 'Autobús', '06067', 'Avenida de Portugal', NULL, 38.14386, -6.6903, 'approximate', 'openstreetmap:way/554727219'),
  ('catalogo-andalucia:extremadura-estaciones:way-563323915', 'Estación de autobuses de Badajoz – Calle de José Rebollo López', 'Autobús', '06015', 'Calle de José Rebollo López 2', '06010', 38.86668, -6.97475, 'address', 'openstreetmap:way/563323915'),
  ('catalogo-andalucia:extremadura-estaciones:way-596491677', 'Estación de Autobuses (Arroyo de San Serván) – Avenida de la Constitución', 'Autobús', '06012', 'Avenida de la Constitución', NULL, 38.85863, -6.455, 'address', 'openstreetmap:way/596491677'),
  ('catalogo-andalucia:extremadura-estaciones:way-607017087', 'Parada de Autobuses (Fuente del Maestre) – Paseo de Extremadura', 'Autobús', '06054', 'Paseo de Extremadura', NULL, 38.52695, -6.44453, 'approximate', 'openstreetmap:way/607017087'),
  ('catalogo-andalucia:extremadura-estaciones:way-624256227', 'Estación de Autobuses (Talarrubias) – Calle Fuentecita', 'Autobús', '06127', 'Calle Fuentecita', '06640', 39.0323, -5.23667, 'address', 'openstreetmap:way/624256227'),
  ('catalogo-andalucia:extremadura-estaciones:way-633120827', 'Estación de autobuses de Montijo – Calle Virgen de Barbaño', 'Autobús', '06088', 'Calle Virgen de Barbaño', '06840', 38.90557, -6.60818, 'address', 'openstreetmap:way/633120827'),
  ('catalogo-andalucia:extremadura-estaciones:way-658417279', 'Estación de Autobuses (Olivenza) – Calle Avelino Palma Brioa', 'Autobús', '06095', 'Calle Avelino Palma Brioa', '06100', 38.68515, -7.09754, 'address', 'openstreetmap:way/658417279'),
  ('catalogo-andalucia:extremadura-estaciones:way-880427343', 'Estación de Autobuses (Oliva de la Frontera) – Calle Paco Ramiro', 'Autobús', '06093', 'Calle Paco Ramiro', NULL, 38.27808, -6.91342, 'address', 'openstreetmap:way/880427343'),
  ('catalogo-andalucia:extremadura-estaciones:way-926312587', 'Parada de Autobuses (Zahínos) – Calle Arroyo Judío', 'Autobús', '06159', 'Calle Arroyo Judío', '06380', 38.33417, -6.95506, 'approximate', 'openstreetmap:way/926312587'),
  ('catalogo-andalucia:extremadura-estaciones:way-998727339', 'Parada de Autobuses (Castilblanco) – Calle Capellanía', 'Autobús', '06035', 'Calle Capellanía', '06680', 39.28559, -5.0892, 'approximate', 'openstreetmap:way/998727339');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '06');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 06 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '06'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 56 THEN
    RAISE EXCEPTION 'Se esperaban 56 puntos de Estaciones en Badajoz, hay %', n;
  END IF;
END;
$$;

COMMIT;
