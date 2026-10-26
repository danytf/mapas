-- Carga de la categoría Estaciones de Alicante/Alacant (provincia 03), trozo de la carga de Andalucía.
-- Origen: estaciones-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 42 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-valencia:estaciones:node-10914769161', 'Alacant Terminal (Alacant / Alicante) – Carrer de Bono Guarner', 'Tren', '03014', 'Carrer de Bono Guarner', '03005', 38.34498, -0.49606, 'address', 'openstreetmap:node/10914769161'),
  ('catalogo-valencia:estaciones:node-10914787249', 'Estación de tren de Sant Vicent - Centre (Sant Vicent del Raspeig / San Vicente del Raspeig) – Vial del Terraplè', 'Tren', '03122', 'Vial del Terraplè', '03690', 38.39456, -0.52877, 'address', 'openstreetmap:node/10914787249'),
  ('catalogo-valencia:estaciones:node-10922195556', 'Estación de tren de Alcoi (Alcoi / Alcoy) – Carrer Filà Judios', 'Tren', '03009', 'Carrer Filà Judios', '03803', 38.70948, -0.47065, 'address', 'openstreetmap:node/10922195556'),
  ('catalogo-valencia:estaciones:node-10922195560', 'Estación de tren de La Encina (Villena) – calle de La Rambla', 'Tren', '03140', 'calle de La Rambla', '03408', 38.76545, -0.95385, 'address', 'openstreetmap:node/10922195560'),
  ('catalogo-valencia:estaciones:node-11372360327', 'Estación de tren de San Isidro-Albatera-Catral – Carretera Albatera - Catral', 'Tren', '03904', 'Carretera Albatera - Catral', NULL, 38.16725, -0.83835, 'address', 'openstreetmap:node/11372360327'),
  ('catalogo-valencia:estaciones:node-12093490202', 'Estación de autobuses de CEE Miguel de Cervantes. Avenida de Ronda (Elda) – Avenida de Ronda', 'Autobús', '03066', 'Avenida de Ronda', NULL, 38.46645, -0.79251, 'address', 'openstreetmap:node/12093490202'),
  ('catalogo-valencia:estaciones:node-12971865263', 'Estación de tren de Elx Carrús (Elx / Elche) – Carrer Óscar Esplá', 'Tren', '03065', 'Carrer Óscar Esplá 94', '03201', 38.26904, -0.7063, 'address', 'openstreetmap:node/12971865263'),
  ('catalogo-valencia:estaciones:node-13158211480', 'Estació d''Autobusos d''Alacant / Estación de Autobuses de Alicante (Alacant / Alicante) – Carrer del Far del Cap de Sant Antoni', 'Autobús', '03014', 'Carrer del Far del Cap de Sant Antoni', '03003', 38.33738, -0.49138, 'approximate', 'openstreetmap:node/13158211480'),
  ('catalogo-valencia:estaciones:node-13755311775', 'Estació d''Autobusos de Guardamar del Segura – Carrer Molivent', 'Autobús', '03076', 'Carrer Molivent 5', '03140', 38.08791, -0.65607, 'approximate', 'openstreetmap:node/13755311775'),
  ('catalogo-valencia:estaciones:node-13807863708', 'Estación de tren de Universidad de Alicante (Alacant / Alicante)', 'Tren', '03014', NULL, '03005', 38.3841, -0.52842, 'address', 'openstreetmap:node/13807863708'),
  ('catalogo-valencia:estaciones:node-2021580965', 'Estación de tren de Villena – Paseo Chapí', 'Tren', '03140', 'Paseo Chapí 2', NULL, 38.63227, -0.86795, 'address', 'openstreetmap:node/2021580965'),
  ('catalogo-valencia:estaciones:node-2085235056', 'Estación de tren de Cocentaina – Carrer Pujada a Santa Barbara', 'Tren', '03056', 'Carrer Pujada a Santa Barbara', NULL, 38.74078, -0.44705, 'address', 'openstreetmap:node/2085235056'),
  ('catalogo-valencia:estaciones:node-230015114', 'Estación de tren de Sant Gabriel (Alacant / Alicante) – Avinguda d''Elx', 'Tren', '03014', 'Avinguda d''Elx', NULL, 38.32906, -0.50862, 'address', 'openstreetmap:node/230015114'),
  ('catalogo-valencia:estaciones:node-2400545326', 'Estación de tren de Novelda-Aspe – Barrio La Estación', 'Tren', '03093', 'Barrio La Estación 1', NULL, 38.40726, -0.77755, 'address', 'openstreetmap:node/2400545326'),
  ('catalogo-valencia:estaciones:node-3051824558', 'Estación de tren de Agres', 'Tren', '03003', NULL, NULL, 38.79686, -0.52183, 'address', 'openstreetmap:node/3051824558'),
  ('catalogo-valencia:estaciones:node-4213612164', 'Estación de tren de Luceros (Alacant / Alicante) – Plaça dels Estels', 'Tren', '03014', 'Plaça dels Estels 1', '03001', 38.34603, -0.49062, 'address', 'openstreetmap:node/4213612164'),
  ('catalogo-valencia:estaciones:node-4213612165', 'Estación de tren de Mercado (Alacant / Alicante) – Avinguda Alfons el Savi', 'Tren', '03014', 'Avinguda Alfons el Savi', '03004', 38.34815, -0.48483, 'address', 'openstreetmap:node/4213612165'),
  ('catalogo-valencia:estaciones:node-4365035714', 'Estación de tren de Villena Alta Velocidad', 'Tren', '03140', NULL, NULL, 38.58431, -0.87389, 'address', 'openstreetmap:node/4365035714'),
  ('catalogo-valencia:estaciones:node-5342775859', 'Estación de tren de Gabinete de Circulación Elx Mercaderíes (Elx / Elche) – Camí de les Salades', 'Tren', '03065', 'Camí de les Salades', NULL, 38.27865, -0.65554, 'address', 'openstreetmap:node/5342775859'),
  ('catalogo-valencia:estaciones:node-6702770321', 'Estación de autobuses de Barrio San José (Petrer) – Av. Mediterraneo', 'Autobús', '03104', 'Av. Mediterraneo 69', NULL, 38.46741, -0.78721, 'address', 'openstreetmap:node/6702770321'),
  ('catalogo-valencia:estaciones:node-7677571532', 'Estación de tren de Torrellano (Elx / Elche) – Avinguda del Mediterrani', 'Tren', '03065', 'Avinguda del Mediterrani', '03320', 38.28965, -0.58276, 'address', 'openstreetmap:node/7677571532'),
  ('catalogo-valencia:estaciones:relation-14664624', 'Estación de Autobuses de Torrevieja – Calle del Mar', 'Autobús', '03133', 'Calle del Mar 50', '03182', 37.97937, -0.67555, 'address', 'openstreetmap:relation/14664624'),
  ('catalogo-valencia:estaciones:relation-8634348', 'Estació d''Autobusos de Santa Pola / Estación de Autobuses de Santa Pola – Carrer de Llevant', 'Autobús', '03121', 'Carrer de Llevant', NULL, 38.19719, -0.56224, 'address', 'openstreetmap:relation/8634348'),
  ('catalogo-valencia:estaciones:way-1134371995', 'Estación de tren de Elda-Petrer – Calle Galicia', 'Tren', '03066', 'Calle Galicia 5', NULL, 38.4849, -0.8011, 'address', 'openstreetmap:way/1134371995'),
  ('catalogo-valencia:estaciones:way-1226352951', 'Estación de tren de Callosa de Segura – Calle Estación Ferrocarril', 'Tren', '03049', 'Calle Estación Ferrocarril', NULL, 38.12267, -0.8744, 'address', 'openstreetmap:way/1226352951'),
  ('catalogo-valencia:estaciones:way-1430532316', 'Estació d''Autobusos d''Alcoi (Alcoi / Alcoy) – Avinguda Tirant lo Blanc', 'Autobús', '03009', 'Avinguda Tirant lo Blanc', '03804', 38.70976, -0.46883, 'address', 'openstreetmap:way/1430532316'),
  ('catalogo-valencia:estaciones:way-184918562', 'Estació d''Autobusos de Guardamar (Guardamar del Segura) – Carrer Molivent', 'Autobús', '03076', 'Carrer Molivent 5', '03140', 38.08793, -0.65605, 'approximate', 'openstreetmap:way/184918562'),
  ('catalogo-valencia:estaciones:way-250304318', 'Estació de Autobusos (Alacant / Alicante) – Carrer del Far del Cap de Santa Pola', 'Autobús', '03014', 'Carrer del Far del Cap de Santa Pola', '03003', 38.33722, -0.49161, 'approximate', 'openstreetmap:way/250304318'),
  ('catalogo-valencia:estaciones:way-269819415', 'Estación de autobuses (Aspe) – Calle Lepanto', 'Autobús', '03019', 'Calle Lepanto', NULL, 38.34905, -0.76802, 'address', 'openstreetmap:way/269819415'),
  ('catalogo-valencia:estaciones:way-356545304', 'Sub-Estación Bus Elda – avenida de Ruperto Chapí', 'Autobús', '03066', 'avenida de Ruperto Chapí 43', '03600', 38.47348, -0.79445, 'address', 'openstreetmap:way/356545304'),
  ('catalogo-valencia:estaciones:way-38627602', 'Estación Orihuela - Miguel Hernández – Camino Parelelo al Ferrocarril', 'Autobús', '03099', 'Camino Parelelo al Ferrocarril', NULL, 38.07722, -0.94558, 'address', 'openstreetmap:way/38627602'),
  ('catalogo-valencia:estaciones:way-406182418', 'Estació d''Autobusos d''Elx / Estación de Autobuses de Elche (Elx / Elche) – avinguda Alcalde Vicente Quiles', 'Autobús', '03065', 'avinguda Alcalde Vicente Quiles 8', NULL, 38.27215, -0.69174, 'address', 'openstreetmap:way/406182418'),
  ('catalogo-valencia:estaciones:way-426128384', 'Estación de tren de Sax – Calle Luís barceló', 'Tren', '03123', 'Calle Luís barceló 1', '03630', 38.54472, -0.8142, 'approximate', 'openstreetmap:way/426128384'),
  ('catalogo-valencia:estaciones:way-452206583', 'Estació d''Autobusos de Xàbia (Xàbia / Jávea) – Carrer de José Ortega y Gasset', 'Autobús', '03082', 'Carrer de José Ortega y Gasset', NULL, 38.78703, 0.16557, 'address', 'openstreetmap:way/452206583'),
  ('catalogo-valencia:estaciones:way-473732487', 'Estación de tren de Elche / Elx AV (Elx / Elche)', 'Tren', '03065', NULL, NULL, 38.24539, -0.76676, 'address', 'openstreetmap:way/473732487'),
  ('catalogo-valencia:estaciones:way-491621368', 'Estación de tren de Callosa de Segura-Cox – Carretera de Cox a Callosa', 'Tren', '03049', 'Carretera de Cox a Callosa', NULL, 38.13675, -0.87556, 'address', 'openstreetmap:way/491621368'),
  ('catalogo-valencia:estaciones:way-497592439', 'Estació d''Autobusos de Benidorm / Estación de Autobuses de Benidorm – Carrer Francisco Llorca Antón', 'Autobús', '03031', 'Carrer Francisco Llorca Antón', '03502', 38.54953, -0.12497, 'address', 'openstreetmap:way/497592439'),
  ('catalogo-valencia:estaciones:way-553494404', 'Estación de tren de Monòver (Elda)', 'Tren', '03066', NULL, NULL, 38.4413, -0.81663, 'address', 'openstreetmap:way/553494404'),
  ('catalogo-valencia:estaciones:way-58220199', 'Estación de tren de Orihuela Miguel Hernández – Calle Marqués de Molins', 'Tren', '03099', 'Calle Marqués de Molins', NULL, 38.07785, -0.94466, 'address', 'openstreetmap:way/58220199'),
  ('catalogo-valencia:estaciones:way-661641776', 'Estació d''Autobusos de Dénia – Carrer Francisca Moreno', 'Autobús', '03063', 'Carrer Francisca Moreno 10', '03700', 38.83719, 0.10114, 'address', 'openstreetmap:way/661641776'),
  ('catalogo-valencia:estaciones:way-665788386', 'Estació d''Autobusos de Calp – Benicolada-Paralela 2-F', 'Autobús', '03047', 'Benicolada-Paralela 2-F', '03710', 38.64692, 0.04454, 'address', 'openstreetmap:way/665788386'),
  ('catalogo-valencia:estaciones:way-79816692', 'Estació Elx-Parc (Elx / Elche) – avinguda Alcalde Vicente Quiles', 'Tren', '03065', 'avinguda Alcalde Vicente Quiles 6', NULL, 38.27179, -0.6951, 'address', 'openstreetmap:way/79816692');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '03');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 03 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '03'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 42 THEN
    RAISE EXCEPTION 'Se esperaban 42 puntos de Estaciones en Alicante/Alacant, hay %', n;
  END IF;
END;
$$;

COMMIT;
