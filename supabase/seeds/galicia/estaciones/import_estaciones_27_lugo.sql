-- Carga de la categoría Estaciones de Lugo (provincia 27), trozo de la carga de Andalucía.
-- Origen: estaciones-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 44 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-galicia:estaciones:node-12587239425', 'Estación de tren de Pedrelo-Celtigos (Sarria)', 'Tren', '27057', NULL, NULL, 42.83289, -7.39342, 'address', 'openstreetmap:node/12587239425'),
  ('catalogo-galicia:estaciones:node-12587266755', 'Estación de tren de Areas (Sober) – Estrada Acedre - Apeadoiro de Areas', 'Tren', '27059', 'Estrada Acedre - Apeadoiro de Areas', NULL, 42.45715, -7.62935, 'address', 'openstreetmap:node/12587266755'),
  ('catalogo-galicia:estaciones:node-12589982363', 'Estación de tren de San Pedro do Sil (Pantón)', 'Tren', '27041', NULL, NULL, 42.45293, -7.71268, 'address', 'openstreetmap:node/12589982363'),
  ('catalogo-galicia:estaciones:node-13373732630', 'Estación de tren de A Pobra do Brollón – Avenida da Estación', 'Tren', '27047', 'Avenida da Estación', NULL, 42.53363, -7.40027, 'address', 'openstreetmap:node/13373732630'),
  ('catalogo-galicia:estaciones:node-13456229213', 'Estación de tren de Sarria – Rúa da Liberdade', 'Tren', '27057', 'Rúa da Liberdade 2', '27600', 42.78418, -7.419, 'address', 'openstreetmap:node/13456229213'),
  ('catalogo-galicia:estaciones:node-13731865774', 'Estación de tren de Barreiros', 'Tren', '27005', NULL, NULL, 43.54742, -7.22531, 'address', 'openstreetmap:node/13731865774'),
  ('catalogo-galicia:estaciones:node-13753836216', 'Estación de tren de Montefurado (Quiroga) – Camiño da Presa', 'Tren', '27050', 'Camiño da Presa', NULL, 42.3937, -7.19455, 'address', 'openstreetmap:node/13753836216'),
  ('catalogo-galicia:estaciones:node-13753836217', 'Estación de tren de San Clodio-Quiroga (Ribas de Sil) – Estrada San Clodio - Piñeira - Peites', 'Tren', '27052', 'Estrada San Clodio - Piñeira - Peites', '27310', 42.46517, -7.28721, 'address', 'openstreetmap:node/13753836217'),
  ('catalogo-galicia:estaciones:node-13817498312', 'Estación de Autobuses de Lugo – Rua Dinan', 'Autobús', '27028', 'Rua Dinan', '27002', 43.00834, -7.55342, 'address', 'openstreetmap:node/13817498312'),
  ('catalogo-galicia:estaciones:node-13817498338', 'Estación de Autobuses de Ribadeo – Avenida Rosalía de Castro', 'Autobús', '27051', 'Avenida Rosalía de Castro', NULL, 43.54055, -7.04062, 'address', 'openstreetmap:node/13817498338'),
  ('catalogo-galicia:estaciones:node-13821010281', 'Estación de Autobuses de Vilalba – Rúa de Lois Peña Novo', 'Autobús', '27065', 'Rúa de Lois Peña Novo', NULL, 43.3028, -7.67512, 'address', 'openstreetmap:node/13821010281'),
  ('catalogo-galicia:estaciones:node-14139662427', 'Estación de tren de O Folgueiro (O Vicedo)', 'Tren', '27064', NULL, NULL, 43.69279, -7.63503, 'address', 'openstreetmap:node/14139662427'),
  ('catalogo-galicia:estaciones:node-14141557286', 'Estación de tren de Mosende (O Vicedo)', 'Tren', '27064', NULL, NULL, 43.70609, -7.63618, 'address', 'openstreetmap:node/14141557286'),
  ('catalogo-galicia:estaciones:node-14218609601', 'Estación de tren de Reinante (Barreiros)', 'Tren', '27005', NULL, NULL, 43.54984, -7.17437, 'address', 'openstreetmap:node/14218609601'),
  ('catalogo-galicia:estaciones:node-14219125966', 'Estación de tren de Os Castros (Ribadeo)', 'Tren', '27051', NULL, NULL, 43.55154, -7.13087, 'address', 'openstreetmap:node/14219125966'),
  ('catalogo-galicia:estaciones:node-14246887155', 'Estación de tren de Foz', 'Tren', '27019', NULL, NULL, 43.56092, -7.27218, 'approximate', 'openstreetmap:node/14246887155'),
  ('catalogo-galicia:estaciones:node-14246913991', 'Estación de tren de O Madeiro (Cervo)', 'Tren', '27013', NULL, NULL, 43.68622, -7.41268, 'address', 'openstreetmap:node/14246913991'),
  ('catalogo-galicia:estaciones:node-14246966301', 'Estación de tren de Cangas de Foz', 'Tren', '27019', NULL, NULL, 43.62604, -7.33331, 'address', 'openstreetmap:node/14246966301'),
  ('catalogo-galicia:estaciones:node-14246972155', 'Estación de tren de Nois (Foz)', 'Tren', '27019', NULL, NULL, 43.61031, -7.31226, 'address', 'openstreetmap:node/14246972155'),
  ('catalogo-galicia:estaciones:node-14247461814', 'Estación de tren de Xove-Pobo – Rúa do Apeadoiro', 'Tren', '27025', 'Rúa do Apeadoiro', NULL, 43.68351, -7.51095, 'address', 'openstreetmap:node/14247461814'),
  ('catalogo-galicia:estaciones:node-14250024245', 'Estación de tren de Fazouro (Foz) – Estrada Xeral de Fazouro', 'Tren', '27019', 'Estrada Xeral de Fazouro 6', '27789', 43.60094, -7.29985, 'address', 'openstreetmap:node/14250024245'),
  ('catalogo-galicia:estaciones:node-1625248341', 'Estación de tren de Viveiro-Apeadoiro – Rúa Campo de Urraca', 'Tren', '27066', 'Rúa Campo de Urraca', '27850', 43.66306, -7.59211, 'address', 'openstreetmap:node/1625248341'),
  ('catalogo-galicia:estaciones:node-1625248357', 'Estación de tren de Xuances (Xove) – Estrada da Mariña', 'Tren', '27025', 'Estrada da Mariña', NULL, 43.6881, -7.55386, 'address', 'openstreetmap:node/1625248357'),
  ('catalogo-galicia:estaciones:node-1876320716', 'Estación de tren de Canaval (Sober)', 'Tren', '27059', NULL, NULL, 42.48277, -7.58769, 'address', 'openstreetmap:node/1876320716'),
  ('catalogo-galicia:estaciones:node-1876326473', 'Estación de tren de Santo Estevo do Sil (Pantón) – Carretera de San Esteban', 'Tren', '27041', 'Carretera de San Esteban', NULL, 42.42746, -7.66281, 'address', 'openstreetmap:node/1876326473'),
  ('catalogo-galicia:estaciones:node-1935793978', 'Estación de tren de Monforte de Lemos – Glorieta Pablo Iglesias', 'Tren', '27031', 'Glorieta Pablo Iglesias', NULL, 42.52952, -7.50314, 'address', 'openstreetmap:node/1935793978'),
  ('catalogo-galicia:estaciones:way-1086827669', 'Estación de Autobuses de Monforte de Lemos – Rúa de Carlos Casares', 'Autobús', '27031', 'Rúa de Carlos Casares', '27400', 42.52691, -7.50809, 'address', 'openstreetmap:way/1086827669'),
  ('catalogo-galicia:estaciones:way-110348446', 'Estación de Autobuses de Mondoñedo', 'Autobús', '27030', NULL, NULL, 43.43304, -7.36011, 'address', 'openstreetmap:way/110348446'),
  ('catalogo-galicia:estaciones:way-151347026', 'Estación de autobuses de Viveiro – Avenida de Galicia', 'Autobús', '27066', 'Avenida de Galicia', '27850', 43.66408, -7.59535, 'address', 'openstreetmap:way/151347026'),
  ('catalogo-galicia:estaciones:way-189867818', 'Estación de tren de Viveiro – Camiño das Aceñas', 'Tren', '27066', 'Camiño das Aceñas', '27850', 43.65687, -7.6002, 'address', 'openstreetmap:way/189867818'),
  ('catalogo-galicia:estaciones:way-206909498', 'Estación de tren de Covas (Viveiro) – Rúa Nogarido', 'Tren', '27066', 'Rúa Nogarido', '27850', 43.67026, -7.61458, 'address', 'openstreetmap:way/206909498'),
  ('catalogo-galicia:estaciones:way-210351492', 'Estación de Autobuses de Chantada – Avenida dos Pilos', 'Autobús', '27016', 'Avenida dos Pilos', NULL, 42.60646, -7.76544, 'address', 'openstreetmap:way/210351492'),
  ('catalogo-galicia:estaciones:way-231308687', 'Estación de Autobuses de Sarria – Rotonda de Guerlédan', 'Autobús', '27057', 'Rotonda de Guerlédan', '27600', 42.78262, -7.41365, 'address', 'openstreetmap:way/231308687'),
  ('catalogo-galicia:estaciones:way-239732671', 'Estación de Autobuses de Monterroso – Rúa de Concepción Arenal', 'Autobús', '27032', 'Rúa de Concepción Arenal', '27560', 42.79258, -7.8377, 'address', 'openstreetmap:way/239732671'),
  ('catalogo-galicia:estaciones:way-258110614', 'Estación de tren de Guitiriz – Rúa do Ferrocarril', 'Tren', '27022', 'Rúa do Ferrocarril', NULL, 43.17905, -7.8951, 'address', 'openstreetmap:way/258110614'),
  ('catalogo-galicia:estaciones:way-258111521', 'Estación de tren de Begonte – Rúa de Pedro Morandeira', 'Tren', '27007', 'Rúa de Pedro Morandeira', NULL, 43.1491, -7.68625, 'address', 'openstreetmap:way/258111521'),
  ('catalogo-galicia:estaciones:way-377617245', 'Estación de tren de Parga (Guitiriz) – Rúa Castelao', 'Tren', '27022', 'Rúa Castelao', '27380', 43.1636, -7.83736, 'address', 'openstreetmap:way/377617245'),
  ('catalogo-galicia:estaciones:way-497242408', 'Estación de tren de San Cibrao (Cervo) – Avenida da Veiga', 'Tren', '27013', 'Avenida da Veiga', NULL, 43.69232, -7.44179, 'address', 'openstreetmap:way/497242408'),
  ('catalogo-galicia:estaciones:way-497255562', 'Estación de tren de Marzán (Foz) – Rúa da Pena Parda', 'Tren', '27019', 'Rúa da Pena Parda', NULL, 43.57478, -7.26946, 'address', 'openstreetmap:way/497255562'),
  ('catalogo-galicia:estaciones:way-521786635', 'Estación de tren de A Pobra de San Xiao (O Páramo)', 'Tren', '27043', NULL, NULL, 42.87015, -7.45509, 'address', 'openstreetmap:way/521786635'),
  ('catalogo-galicia:estaciones:way-675659440', 'Estación de tren de Baamonde (Begonte) – Rúa da Estación', 'Tren', '27007', 'Rúa da Estación', '27371', 43.1734, -7.75634, 'address', 'openstreetmap:way/675659440'),
  ('catalogo-galicia:estaciones:way-86123754', 'Estación de tren de Lugo – Rúa Alta', 'Tren', '27028', 'Rúa Alta', '27003', 43.0151, -7.55216, 'address', 'openstreetmap:way/86123754'),
  ('catalogo-galicia:estaciones:way-881692841', 'Estación de Autobuses de Foz – Rúa de Cervantes', 'Autobús', '27019', 'Rúa de Cervantes 44', NULL, 43.57198, -7.25993, 'address', 'openstreetmap:way/881692841'),
  ('catalogo-galicia:estaciones:way-88971784', 'Estación de tren de Rábade – Praza de España', 'Tren', '27056', 'Praza de España', NULL, 43.12136, -7.62477, 'address', 'openstreetmap:way/88971784');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '27');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 27 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '27'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 44 THEN
    RAISE EXCEPTION 'Se esperaban 44 puntos de Estaciones en Lugo, hay %', n;
  END IF;
END;
$$;

COMMIT;
