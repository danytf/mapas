-- Carga de la categoría Correos de Bizkaia (provincia 48), trozo de la carga de Andalucía.
-- Origen: postal_service-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 50 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-pais-vasco:postal_service:node-11084069039', 'Correos Derio – Euskalerria kalea', NULL, '48901', 'Euskalerria kalea 4', '48160', 43.29082, -2.8855, 'address', 'openstreetmap:node/11084069039'),
  ('catalogo-pais-vasco:postal_service:node-1131395315', 'Correos Getxo – Santa Ana kalea', NULL, '48044', 'Santa Ana kalea 2', '48930', 43.32507, -3.01345, 'address', 'openstreetmap:node/1131395315'),
  ('catalogo-pais-vasco:postal_service:node-12548834724', 'Correos Ermua – Hiriaren VI. mendeurrenaren kalea', NULL, '48034', 'Hiriaren VI. mendeurrenaren kalea 10', '48260', 43.18713, -2.50336, 'address', 'openstreetmap:node/12548834724'),
  ('catalogo-pais-vasco:postal_service:node-12616242325', 'Correos Bilbao – Julian Gaiarre etorbidea', NULL, '48020', 'Julian Gaiarre etorbidea 84', '48004', 43.25495, -2.90036, 'address', 'openstreetmap:node/12616242325'),
  ('catalogo-pais-vasco:postal_service:node-1269450187', 'Correos Valle de Trápaga-Trapagaran – Calle José Rufino Olaso kalea', NULL, '48080', 'Calle José Rufino Olaso kalea 4', '48510', 43.30535, -3.03871, 'address', 'openstreetmap:node/1269450187'),
  ('catalogo-pais-vasco:postal_service:node-13610229801', 'Correos Durango – Estrada de Matxinestarta', NULL, '48027', 'Estrada de Matxinestarta 10', '48200', 43.17001, -2.62907, 'address', 'openstreetmap:node/13610229801'),
  ('catalogo-pais-vasco:postal_service:node-13988504467', 'Correos Gorliz – Itsasbide kalea', NULL, '48043', 'Itsasbide kalea', NULL, 43.41282, -2.93844, 'address', 'openstreetmap:node/13988504467'),
  ('catalogo-pais-vasco:postal_service:node-1402303912', 'Correos Erandio – Antonio Trueba kalea', NULL, '48902', 'Antonio Trueba kalea 15', '48950', 43.30183, -2.97521, 'address', 'openstreetmap:node/1402303912'),
  ('catalogo-pais-vasco:postal_service:node-1417011177', 'Correos Portugalete – Calle Gipuzkoa kalea', NULL, '48078', 'Calle Gipuzkoa kalea 14', '48920', 43.31973, -3.02034, 'address', 'openstreetmap:node/1417011177'),
  ('catalogo-pais-vasco:postal_service:node-1483686582', 'Correos Basauri – Autonomia kalea', NULL, '48015', 'Autonomia kalea', '48970', 43.23662, -2.88887, 'address', 'openstreetmap:node/1483686582'),
  ('catalogo-pais-vasco:postal_service:node-1511385313', 'Correos Usansolo – Torreondo kalea', NULL, '48916', 'Torreondo kalea', '48960', 43.21919, -2.81926, 'address', 'openstreetmap:node/1511385313'),
  ('catalogo-pais-vasco:postal_service:node-1620646935', 'Correos Barakaldo – San Antonio kalea', NULL, '48013', 'San Antonio kalea 5', '48901', 43.29853, -2.98553, 'address', 'openstreetmap:node/1620646935'),
  ('catalogo-pais-vasco:postal_service:node-1888266673', 'Correos Sondika – Mikel Zarate kalea', NULL, '48904', 'Mikel Zarate kalea 2', '48150', 43.29989, -2.92703, 'address', 'openstreetmap:node/1888266673'),
  ('catalogo-pais-vasco:postal_service:node-1938097534', 'Correos Etxebarri – Antonio Epalza kalea 1C', NULL, '48029', 'Antonio Epalza kalea 1C', '48450', 43.2476, -2.89232, 'address', 'openstreetmap:node/1938097534'),
  ('catalogo-pais-vasco:postal_service:node-2279408539', 'Correos Bermeo – Trake kalea', NULL, '48017', 'Trake kalea 5', '48370', 43.41779, -2.72583, 'address', 'openstreetmap:node/2279408539'),
  ('catalogo-pais-vasco:postal_service:node-2281164336', 'Correos Basauri – Kale Nagusia', NULL, '48015', 'Kale Nagusia', '48970', 43.2358, -2.88661, 'address', 'openstreetmap:node/2281164336'),
  ('catalogo-pais-vasco:postal_service:node-2554400743', 'Correos Bilbao – Agirre lehendakariaren etorbidea', NULL, '48020', 'Agirre lehendakariaren etorbidea 22', '48014', 43.27209, -2.94658, 'address', 'openstreetmap:node/2554400743'),
  ('catalogo-pais-vasco:postal_service:node-2573940740', 'Correos Zalla – La Inmaculada auzoa', NULL, '48096', 'La Inmaculada auzoa 20', '48850', 43.20937, -3.11679, 'address', 'openstreetmap:node/2573940740'),
  ('catalogo-pais-vasco:postal_service:node-2574311756', 'Correos Zalla – Barrio Artebizkarra', NULL, '48096', 'Barrio Artebizkarra 3', NULL, 43.21345, -3.13614, 'address', 'openstreetmap:node/2574311756'),
  ('catalogo-pais-vasco:postal_service:node-2813113158', 'Correos Bilbao – Epaltzaren alargunaren kalea', NULL, '48020', 'Epaltzaren alargunaren kalea 3', '48005', 43.26107, -2.92275, 'address', 'openstreetmap:node/2813113158'),
  ('catalogo-pais-vasco:postal_service:node-2972901473', 'Correos Sopela – Zubigane kalea', NULL, '48085', 'Zubigane kalea 4', '48600', 43.37968, -2.98086, 'address', 'openstreetmap:node/2972901473'),
  ('catalogo-pais-vasco:postal_service:node-3058785206', 'Correos Berango – Sabino Arana kalea', NULL, '48016', 'Sabino Arana kalea', '48640', 43.36488, -2.99991, 'address', 'openstreetmap:node/3058785206'),
  ('catalogo-pais-vasco:postal_service:node-3060681421', 'Correos Berriz – Iturritza kalea', NULL, '48019', 'Iturritza kalea 16', '48240', 43.16975, -2.57433, 'address', 'openstreetmap:node/3060681421'),
  ('catalogo-pais-vasco:postal_service:node-3778217002', 'Correos Gernika-Lumo – Iparragirre kalea 26A', NULL, '48046', 'Iparragirre kalea 26A', '48300', 43.31199, -2.67765, 'address', 'openstreetmap:node/3778217002'),
  ('catalogo-pais-vasco:postal_service:node-3808521296', 'Correos Alonsotegi – Calle Lasao', NULL, '48912', 'Calle Lasao 20', '48810', 43.24489, -2.98784, 'address', 'openstreetmap:node/3808521296'),
  ('catalogo-pais-vasco:postal_service:node-3814619323', 'Correos Ondarroa – Artabide kalea', NULL, '48073', 'Artabide kalea 32', '48700', 43.32397, -2.42345, 'address', 'openstreetmap:node/3814619323'),
  ('catalogo-pais-vasco:postal_service:node-4176737366', 'Correos Barakaldo – Lopez de Ayala enparantza', NULL, '48013', 'Lopez de Ayala enparantza 6', '48902', 43.28943, -2.99769, 'address', 'openstreetmap:node/4176737366'),
  ('catalogo-pais-vasco:postal_service:node-4255917353', 'Correos Bilbao – Etxetxua plaza', NULL, '48020', 'Etxetxua plaza 11', '48012', 43.25678, -2.94423, 'address', 'openstreetmap:node/4255917353'),
  ('catalogo-pais-vasco:postal_service:node-4308703083', 'Correos Bilbao – Mazarredo zumarkalea', NULL, '48020', 'Mazarredo zumarkalea 12', '48009', 43.26657, -2.93011, 'address', 'openstreetmap:node/4308703083'),
  ('catalogo-pais-vasco:postal_service:node-4383039690', 'Correos Balmaseda – Calle Félix de la Torre', NULL, '48090', 'Calle Félix de la Torre 2', '48800', 43.19398, -3.19698, 'address', 'openstreetmap:node/4383039690'),
  ('catalogo-pais-vasco:postal_service:node-4440785073', 'Correos Sestao – Mariana Pineda kalea', NULL, '48084', 'Mariana Pineda kalea 22', '48910', 43.30957, -3.0119, 'address', 'openstreetmap:node/4440785073'),
  ('catalogo-pais-vasco:postal_service:node-4471815241', 'Correos Ortuella – Catalina Gibaja kalea', NULL, '48083', 'Catalina Gibaja kalea 3', '48530', 43.30922, -3.05377, 'address', 'openstreetmap:node/4471815241'),
  ('catalogo-pais-vasco:postal_service:node-4889583844', 'Correos Zamudio – Uribe plaza 4-5', NULL, '48905', 'Uribe plaza 4-5', '48170', 43.28166, -2.86308, 'address', 'openstreetmap:node/4889583844'),
  ('catalogo-pais-vasco:postal_service:node-500936828', 'Correos Bilbao – Particular Allende kalea', NULL, '48020', 'Particular Allende kalea 14', '48004', 43.25239, -2.91281, 'address', 'openstreetmap:node/500936828'),
  ('catalogo-pais-vasco:postal_service:node-504607197', 'Correos Barakaldo – Calle La Paz', NULL, '48013', 'Calle La Paz 34', '48903', 43.28274, -2.98913, 'address', 'openstreetmap:node/504607197'),
  ('catalogo-pais-vasco:postal_service:node-512653269', 'Correos Bilbao – Gregorio Balparda kalea', NULL, '48020', 'Gregorio Balparda kalea 2', '48015', 43.27827, -2.96075, 'address', 'openstreetmap:node/512653269'),
  ('catalogo-pais-vasco:postal_service:node-518811867', 'Correos Santurtzi – Cartero Germán,', NULL, '48082', 'Cartero Germán, 4', '48980', 43.32893, -3.03504, 'address', 'openstreetmap:node/518811867'),
  ('catalogo-pais-vasco:postal_service:node-527354195', 'Correos Galdakao – Pontzi Zabala kalea', NULL, '48036', 'Pontzi Zabala kalea', '48960', 43.23022, -2.84157, 'address', 'openstreetmap:node/527354195'),
  ('catalogo-pais-vasco:postal_service:node-551312103', 'Correos Amorebieta-Etxano – San Pedro kalea', NULL, '48003', 'San Pedro kalea 7', '48340', 43.22228, -2.73563, 'address', 'openstreetmap:node/551312103'),
  ('catalogo-pais-vasco:postal_service:node-5538446663', 'Correos Plentzia – Arraun kalea', NULL, '48077', 'Arraun kalea', '48620', 43.40655, -2.94636, 'address', 'openstreetmap:node/5538446663'),
  ('catalogo-pais-vasco:postal_service:node-6158394343', 'Correos Leioa – Luis Bilbao Libano kalea 11-13', NULL, '48054', 'Luis Bilbao Libano kalea 11-13', '48940', 43.32325, -2.98581, 'address', 'openstreetmap:node/6158394343'),
  ('catalogo-pais-vasco:postal_service:node-6178320735', 'Correos Bilbao – Zorrotza-Kastrexana errepidea', NULL, '48020', 'Zorrotza-Kastrexana errepidea 16', '48013', 43.2754, -2.97255, 'address', 'openstreetmap:node/6178320735'),
  ('catalogo-pais-vasco:postal_service:node-671239014', 'Correos Lekeitio – Sabino Arana etorbidea', NULL, '48057', 'Sabino Arana etorbidea', '48280', 43.3638, -2.5081, 'address', 'openstreetmap:node/671239014'),
  ('catalogo-pais-vasco:postal_service:node-6807153094', 'Correos Igorre – Elexalde kalea 33C', NULL, '48094', 'Elexalde kalea 33C', '48140', 43.16287, -2.78038, 'address', 'openstreetmap:node/6807153094'),
  ('catalogo-pais-vasco:postal_service:node-7141044389', 'Correos Karrantza Harana / Valle de Carranza – Ambasaguas auzoa', NULL, '48022', 'Ambasaguas auzoa', NULL, 43.23814, -3.35725, 'address', 'openstreetmap:node/7141044389'),
  ('catalogo-pais-vasco:postal_service:node-8036307193', 'Correos Erandio – Calle Mezo', NULL, '48902', 'Calle Mezo', NULL, 43.31519, -2.98386, 'address', 'openstreetmap:node/8036307193'),
  ('catalogo-pais-vasco:postal_service:way-110895406', 'Correos Bilbao – Urkixo zumarkalea', NULL, '48020', 'Urkixo zumarkalea 19', '48008', 43.25981, -2.93174, 'address', 'openstreetmap:way/110895406'),
  ('catalogo-pais-vasco:postal_service:way-379470849', 'Correos Urduliz – Aita Gotzon kalea', NULL, '48089', 'Aita Gotzon kalea 6', '48610', 43.37336, -2.94924, 'address', 'openstreetmap:way/379470849'),
  ('catalogo-pais-vasco:postal_service:way-41969729', 'Correos Getxo – Torrene kalea', NULL, '48044', 'Torrene kalea', '48991', 43.35021, -3.01065, 'address', 'openstreetmap:way/41969729'),
  ('catalogo-pais-vasco:postal_service:way-517341393', 'Correos Bakio – Aguirre Lehendakaria', NULL, '48012', 'Aguirre Lehendakaria', '48130', 43.42333, -2.81415, 'address', 'openstreetmap:way/517341393');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '48');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 48 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '48'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 50 THEN
    RAISE EXCEPTION 'Se esperaban 50 puntos de Correos en Bizkaia, hay %', n;
  END IF;
END;
$$;

COMMIT;
