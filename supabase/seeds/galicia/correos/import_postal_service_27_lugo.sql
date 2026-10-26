-- Carga de la categoría Correos de Lugo (provincia 27), trozo de la carga de Andalucía.
-- Origen: postal_service-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 45 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-galicia:postal_service:node-10600988392', 'Correos Pantón – Rúa Ramón Fernández Núñez', NULL, '27041', 'Rúa Ramón Fernández Núñez', '27430', 42.50617, -7.62337, 'address', 'openstreetmap:node/10600988392'),
  ('catalogo-galicia:postal_service:node-11009956872', 'Correos Navia de Suarna – Avenida de Galicia', NULL, '27034', 'Avenida de Galicia', '27650', 42.96409, -7.00649, 'address', 'openstreetmap:node/11009956872'),
  ('catalogo-galicia:postal_service:node-11274588202', 'Correos Muras – Rúa da Margarida', NULL, '27033', 'Rúa da Margarida', NULL, 43.46722, -7.72292, 'address', 'openstreetmap:node/11274588202'),
  ('catalogo-galicia:postal_service:node-11332910452', 'Correos Paradela – Estrada Pedrafita (N-6) - Alto do Hospital (N-540)', NULL, '27042', 'Estrada Pedrafita (N-6) - Alto do Hospital (N-540)', NULL, 42.76684, -7.56787, 'address', 'openstreetmap:node/11332910452'),
  ('catalogo-galicia:postal_service:node-11351320483', 'Correos Pedrafita do Cebreiro – Avenida de Castela', NULL, '27045', 'Avenida de Castela 20', NULL, 42.72691, -7.02163, 'address', 'openstreetmap:node/11351320483'),
  ('catalogo-galicia:postal_service:node-11398003138', 'Correos Monforte de Lemos – Rúa do Conde', NULL, '27031', 'Rúa do Conde', '27400', 42.51937, -7.51517, 'address', 'openstreetmap:node/11398003138'),
  ('catalogo-galicia:postal_service:node-11710908916', 'Correos Cospeito – Avenida da Terra Chá', NULL, '27015', 'Avenida da Terra Chá 29', '27377', 43.23641, -7.55701, 'address', 'openstreetmap:node/11710908916'),
  ('catalogo-galicia:postal_service:node-11928011804', 'Correos Folgoso do Courel', NULL, '27017', NULL, NULL, 42.63999, -7.15127, 'address', 'openstreetmap:node/11928011804'),
  ('catalogo-galicia:postal_service:node-12147778837', 'Correos Ribas de Sil – Plaza Mayor', NULL, '27052', 'Plaza Mayor', '27310', 42.46649, -7.28758, 'address', 'openstreetmap:node/12147778837'),
  ('catalogo-galicia:postal_service:node-12281589865', 'Correos Taboada – Praza do Xeneral Muinelo', NULL, '27060', 'Praza do Xeneral Muinelo', '27550', 42.71617, -7.76188, 'address', 'openstreetmap:node/12281589865'),
  ('catalogo-galicia:postal_service:node-1232221317', 'Correos Lugo – Rúa Mallorca 18-16', NULL, '27028', 'Rúa Mallorca 18-16', '27003', 43.0198, -7.56386, 'address', 'openstreetmap:node/1232221317'),
  ('catalogo-galicia:postal_service:node-12355106235', 'Correos Xove – Camiño Real', NULL, '27025', 'Camiño Real', '27870', 43.68599, -7.50927, 'address', 'openstreetmap:node/12355106235'),
  ('catalogo-galicia:postal_service:node-12541938261', 'Correos Castro de Rei – Praza Maior', NULL, '27010', 'Praza Maior', NULL, 43.20735, -7.39845, 'address', 'openstreetmap:node/12541938261'),
  ('catalogo-galicia:postal_service:node-1261927915', 'Correos O Vicedo – 76', NULL, '27064', '76', '27860', 43.73284, -7.67267, 'address', 'openstreetmap:node/1261927915'),
  ('catalogo-galicia:postal_service:node-13006104752', 'Correos Barreiros – Rúa Vila', NULL, '27005', 'Rúa Vila 65', NULL, 43.54089, -7.23282, 'address', 'openstreetmap:node/13006104752'),
  ('catalogo-galicia:postal_service:node-13087682243', 'Correos As Nogais – Amparo Del Rio', NULL, '27037', 'Amparo Del Rio', '27677', 42.81045, -7.11023, 'address', 'openstreetmap:node/13087682243'),
  ('catalogo-galicia:postal_service:node-1426024901', 'Correos A Pontenova – Ponte do Eo', NULL, '27048', 'Ponte do Eo', NULL, 43.34736, -7.19265, 'address', 'openstreetmap:node/1426024901'),
  ('catalogo-galicia:postal_service:node-1451336260', 'Correos Foz – Rúa de Álvaro Cunqueiro', NULL, '27019', 'Rúa de Álvaro Cunqueiro 11', '27780', 43.56827, -7.25931, 'address', 'openstreetmap:node/1451336260'),
  ('catalogo-galicia:postal_service:node-1488368201', 'Correos O Valadouro – Avenida de Viveiro', NULL, '27063', 'Avenida de Viveiro', NULL, 43.55205, -7.44102, 'address', 'openstreetmap:node/1488368201'),
  ('catalogo-galicia:postal_service:node-1538547888', 'Correos Chantada – Avenida de Monforte', NULL, '27016', 'Avenida de Monforte 42', '27500', 42.6087, -7.76737, 'address', 'openstreetmap:node/1538547888'),
  ('catalogo-galicia:postal_service:node-1735729744', 'Correos A Pobra do Brollón – Avenida de Galicia', NULL, '27047', 'Avenida de Galicia', NULL, 42.55721, -7.39322, 'address', 'openstreetmap:node/1735729744'),
  ('catalogo-galicia:postal_service:node-1749057057', 'Correos Guitiriz – Rúa do Concello', NULL, '27022', 'Rúa do Concello 39', NULL, 43.18038, -7.89087, 'address', 'openstreetmap:node/1749057057'),
  ('catalogo-galicia:postal_service:node-1838992723', 'Correos Ribadeo – Avenida de Asturias', NULL, '27051', 'Avenida de Asturias 20', '27700', 43.53487, -7.04201, 'address', 'openstreetmap:node/1838992723'),
  ('catalogo-galicia:postal_service:node-2018852899', 'Correos Bóveda – Rúa da Estación', NULL, '27008', 'Rúa da Estación', NULL, 42.62129, -7.48681, 'address', 'openstreetmap:node/2018852899'),
  ('catalogo-galicia:postal_service:node-2028811251', 'Correos Samos – Avenida de Compostela', NULL, '27055', 'Avenida de Compostela', '27620', 42.73002, -7.32686, 'address', 'openstreetmap:node/2028811251'),
  ('catalogo-galicia:postal_service:node-2469347897', 'Correos Lugo – Ronda da Muralla', NULL, '27028', 'Ronda da Muralla', '27003', 43.01455, -7.5564, 'address', 'openstreetmap:node/2469347897'),
  ('catalogo-galicia:postal_service:node-2587319725', 'Correos Antas de Ulla – Praza de España', NULL, '27003', 'Praza de España 2', '27570', 42.78269, -7.89029, 'address', 'openstreetmap:node/2587319725'),
  ('catalogo-galicia:postal_service:node-3156133363', 'Correos Láncara – Rúa Benigno Quiroga', NULL, '27026', 'Rúa Benigno Quiroga', '27360', 42.86392, -7.44567, 'address', 'openstreetmap:node/3156133363'),
  ('catalogo-galicia:postal_service:node-3158598165', 'Correos Friol – Plazuela Curros Enriquez 1,2,3', NULL, '27020', 'Plazuela Curros Enriquez 1,2,3', NULL, 43.03166, -7.79607, 'address', 'openstreetmap:node/3158598165'),
  ('catalogo-galicia:postal_service:node-3246142147', 'Correos Sarria – Rúa da Liberdade', NULL, '27057', 'Rúa da Liberdade 183', '27600', 42.7769, -7.40787, 'address', 'openstreetmap:node/3246142147'),
  ('catalogo-galicia:postal_service:node-3724494523', 'Correos Folgoso do Courel – Praza Manuel Fraga Iribarne', NULL, '27017', 'Praza Manuel Fraga Iribarne', '27325', 42.58743, -7.19275, 'address', 'openstreetmap:node/3724494523'),
  ('catalogo-galicia:postal_service:node-4453438089', 'Correos O Saviñao – Praza Bernardino Ribadavia', NULL, '27058', 'Praza Bernardino Ribadavia', '27540', 42.58455, -7.6392, 'address', 'openstreetmap:node/4453438089'),
  ('catalogo-galicia:postal_service:node-492071758', 'Correos Lourenzá – Praza de César Chavarría Pacio', NULL, '27027', 'Praza de César Chavarría Pacio', NULL, 43.47089, -7.29871, 'address', 'openstreetmap:node/492071758'),
  ('catalogo-galicia:postal_service:node-4940684921', 'Correos Portomarín – Rúa Benigno Quiroga', NULL, '27049', 'Rúa Benigno Quiroga 6', '27178', 42.80707, -7.61615, 'address', 'openstreetmap:node/4940684921'),
  ('catalogo-galicia:postal_service:node-5047723019', 'Correos Becerreá – Avenida de Navia', NULL, '27006', 'Avenida de Navia 12', '27640', 42.85416, -7.16235, 'address', 'openstreetmap:node/5047723019'),
  ('catalogo-galicia:postal_service:node-6516164516', 'Correos Abadín – Estrada de Fanoi', NULL, '27001', 'Estrada de Fanoi', '27730', 43.36391, -7.47586, 'address', 'openstreetmap:node/6516164516'),
  ('catalogo-galicia:postal_service:node-6534813106', 'Correos Quiroga – Rúa de Eduardo Moreiras', NULL, '27050', 'Rúa de Eduardo Moreiras', '27320', 42.47516, -7.27327, 'address', 'openstreetmap:node/6534813106'),
  ('catalogo-galicia:postal_service:node-7796270985', 'Correos A Fonsagrada – Rúa do Parque', NULL, '27018', 'Rúa do Parque', NULL, 43.12433, -7.06995, 'address', 'openstreetmap:node/7796270985'),
  ('catalogo-galicia:postal_service:node-803951469', 'Correos Palas de Rei – Avenida de Ourense', NULL, '27040', 'Avenida de Ourense 31', '27200', 42.87238, -7.86841, 'address', 'openstreetmap:node/803951469'),
  ('catalogo-galicia:postal_service:node-8154666865', 'Correos Rábade – Rúa Bautista Núñez Varela', NULL, '27056', 'Rúa Bautista Núñez Varela', NULL, 43.1203, -7.6278, 'address', 'openstreetmap:node/8154666865'),
  ('catalogo-galicia:postal_service:relation-2588568', 'Correos Viveiro – Avenida de Ramón Canosa', NULL, '27066', 'Avenida de Ramón Canosa 4', '27850', 43.66521, -7.59415, 'address', 'openstreetmap:relation/2588568'),
  ('catalogo-galicia:postal_service:way-113752900', 'Correos Mondoñedo – Rúa da Concepción', NULL, '27030', 'Rúa da Concepción 15', '27740', 43.42876, -7.36469, 'address', 'openstreetmap:way/113752900'),
  ('catalogo-galicia:postal_service:way-1322964361', 'Correos Lugo – Rúa de San Pedro', NULL, '27028', 'Rúa de San Pedro 5', '27001', 43.01057, -7.5551, 'address', 'openstreetmap:way/1322964361'),
  ('catalogo-galicia:postal_service:way-1381114671', 'Correos Alfoz do Castrodouro', NULL, '27002', NULL, NULL, 43.52742, -7.41734, 'address', 'openstreetmap:way/1381114671'),
  ('catalogo-galicia:postal_service:way-1458286882', 'Correos O Corgo', NULL, '27014', NULL, NULL, 42.94236, -7.42551, 'address', 'openstreetmap:way/1458286882');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 45 THEN
    RAISE EXCEPTION 'Se esperaban 45 puntos de Correos en Lugo, hay %', n;
  END IF;
END;
$$;

COMMIT;
