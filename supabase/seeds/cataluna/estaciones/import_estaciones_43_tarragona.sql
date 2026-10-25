-- Carga de la categoría Estaciones de Tarragona (provincia 43), trozo de la carga de Andalucía.
-- Origen: estaciones-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 66 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cataluna:estaciones:node-1113111468', 'Estación de tren de Tortosa – Carrer del poeta Francesc Vicenç Garcia', 'Tren', '43155', 'Carrer del poeta Francesc Vicenç Garcia 7', '43500', 40.80712, 0.52288, 'address', 'openstreetmap:node/1113111468'),
  ('catalogo-cataluna:estaciones:node-13020905215', 'Estación de tren de Calafell – Plaça de l''Estació', 'Tren', '43037', 'Plaça de l''Estació 3', '43820', 41.18956, 1.57502, 'address', 'openstreetmap:node/13020905215'),
  ('catalogo-cataluna:estaciones:node-13894696022', 'Estación de tren de Tarragona – Passeig Marítim de Rafael Casanova', 'Tren', '43148', 'Passeig Marítim de Rafael Casanova', '43004', 41.11122, 1.25354, 'address', 'openstreetmap:node/13894696022'),
  ('catalogo-cataluna:estaciones:node-1584912833', 'Estación de tren de la Plana - Picamoixons (Valls) – Camí de l''Estació', 'Tren', '43161', 'Camí de l''Estació', '43491', 41.30608, 1.19495, 'address', 'openstreetmap:node/1584912833'),
  ('catalogo-cataluna:estaciones:node-1585031955', 'Estación de tren de Alcover – Avinguda de Sant Pau 1A', 'Tren', '43005', 'Avinguda de Sant Pau 1A', '43460', 41.2616, 1.17417, 'address', 'openstreetmap:node/1585031955'),
  ('catalogo-cataluna:estaciones:node-1585031964', 'Estación de tren de la Selva del Camp – Passatge de l''Estació', 'Tren', '43145', 'Passatge de l''Estació', '43470', 41.21127, 1.14396, 'address', 'openstreetmap:node/1585031964'),
  ('catalogo-cataluna:estaciones:node-2056581884', 'Estación de tren de L''Aldea - Amposta - Tortosa – Polígon Estació de Mercaderies', 'Tren', '43904', 'Polígon Estació de Mercaderies', '43896', 40.75359, 0.61455, 'address', 'openstreetmap:node/2056581884'),
  ('catalogo-cataluna:estaciones:node-2056719798', 'Estación de tren de L''Ampolla - Perelló - Deltebre – Passeig Centre', 'Tren', '43906', 'Passeig Centre 39', '43895', 40.81192, 0.70818, 'address', 'openstreetmap:node/2056719798'),
  ('catalogo-cataluna:estaciones:node-2125146085', 'Estación de tren de l''Ametlla de Mar – Carrer de l''Estació 5B', 'Tren', '43013', 'Carrer de l''Estació 5B', '43860', 40.8862, 0.80045, 'address', 'openstreetmap:node/2125146085'),
  ('catalogo-cataluna:estaciones:node-2209660914', 'Estación de tren de Montblanc – Avinguda de l''Estació', 'Tren', '43086', 'Avinguda de l''Estació', '43400', 41.37652, 1.16571, 'address', 'openstreetmap:node/2209660914'),
  ('catalogo-cataluna:estaciones:node-2240188565', 'Estación de tren de Móra la Nova – Camí de l''Estació', 'Tren', '43094', 'Camí de l''Estació', NULL, 41.10642, 0.65342, 'address', 'openstreetmap:node/2240188565'),
  ('catalogo-cataluna:estaciones:node-2580000640', 'Estación de tren de Campredó (Tortosa) – Carrer de Benicarló', 'Tren', '43155', 'Carrer de Benicarló 65', '43897', 40.75908, 0.55586, 'address', 'openstreetmap:node/2580000640'),
  ('catalogo-cataluna:estaciones:node-2711347325', 'Estación de tren de l''Espluga de Francolí', 'Tren', '43054', NULL, '43440', 41.40047, 1.10326, 'address', 'openstreetmap:node/2711347325'),
  ('catalogo-cataluna:estaciones:node-2713026494', 'Estación de tren de Camp de Tarragona (la Secuita)', 'Tren', '43144', NULL, NULL, 41.19217, 1.27357, 'address', 'openstreetmap:node/2713026494'),
  ('catalogo-cataluna:estaciones:node-2725947903', 'Estación de tren de Marçà - Falset', 'Tren', '43076', NULL, NULL, 41.13092, 0.81051, 'address', 'openstreetmap:node/2725947903'),
  ('catalogo-cataluna:estaciones:node-2725947939', 'Estación de tren de Pradell (Pradell de la Teixeta)', 'Tren', '43115', NULL, NULL, 41.13316, 0.85864, 'address', 'openstreetmap:node/2725947939'),
  ('catalogo-cataluna:estaciones:node-2725948021', 'Estación de tren de Riudecanyes - Botarell', 'Tren', '43127', NULL, NULL, 41.14005, 0.97578, 'address', 'openstreetmap:node/2725948021'),
  ('catalogo-cataluna:estaciones:node-2899831261', 'Estación de tren de els Guiamets', 'Tren', '43070', NULL, NULL, 41.09591, 0.74778, 'address', 'openstreetmap:node/2899831261'),
  ('catalogo-cataluna:estaciones:node-2899839346', 'Estación de tren de Capçanes – Carrer de Pau Casals', 'Tren', '43040', 'Carrer de Pau Casals', NULL, 41.10208, 0.78038, 'address', 'openstreetmap:node/2899839346'),
  ('catalogo-cataluna:estaciones:node-2899848133', 'Estación de tren de Duesaigües - l''Argentera', 'Tren', '43017', NULL, NULL, 41.14363, 0.92079, 'address', 'openstreetmap:node/2899848133'),
  ('catalogo-cataluna:estaciones:node-3316606134', 'Estación de tren de Ascó – Plaça de l''Estació', 'Tren', '43019', 'Plaça de l''Estació', '43791', 41.18232, 0.56905, 'address', 'openstreetmap:node/3316606134'),
  ('catalogo-cataluna:estaciones:node-3592103272', 'Estación de tren de Salomó', 'Tren', '43135', NULL, NULL, 41.22339, 1.37659, 'address', 'openstreetmap:node/3592103272'),
  ('catalogo-cataluna:estaciones:node-3592103913', 'Estación de tren de Nulles - Bràfim – Carrer de l''estacio', 'Tren', '43098', 'Carrer de l''estacio', NULL, 41.25034, 1.2974, 'address', 'openstreetmap:node/3592103913'),
  ('catalogo-cataluna:estaciones:node-3592103996', 'Estación de tren de Vilaverd – carrer Major', 'Tren', '43172', 'carrer Major', NULL, 41.33763, 1.17649, 'address', 'openstreetmap:node/3592103996'),
  ('catalogo-cataluna:estaciones:node-5434997566', 'Estación de tren de Camarles - Deltebre – Carrer Quaranta-Nou', 'Tren', '43903', 'Carrer Quaranta-Nou', '43894', 40.77512, 0.6711, 'address', 'openstreetmap:node/5434997566'),
  ('catalogo-cataluna:estaciones:node-5435163761', 'Estación de tren de Salou-Port Aventura – Avinguda de Joan Fuster', 'Tren', '43905', 'Avinguda de Joan Fuster', NULL, 41.08792, 1.1456, 'address', 'openstreetmap:node/5435163761'),
  ('catalogo-cataluna:estaciones:node-5435480586', 'Estación de tren de Altafulla - Tamarit (Tarragona) – Camí de l''Estació', 'Tren', '43148', 'Camí de l''Estació', NULL, 41.13661, 1.3733, 'address', 'openstreetmap:node/5435480586'),
  ('catalogo-cataluna:estaciones:node-5435487464', 'Estación de tren de Torredembarra – Passeig de Miramar', 'Tren', '43153', 'Passeig de Miramar', '43830', 41.14279, 1.40571, 'address', 'openstreetmap:node/5435487464'),
  ('catalogo-cataluna:estaciones:node-5443674165', 'Estación de tren de Roda de Mar (Roda de Berà) – Carrer de la Vila', 'Tren', '43131', 'Carrer de la Vila', '43883', 41.18643, 1.45519, 'address', 'openstreetmap:node/5443674165'),
  ('catalogo-cataluna:estaciones:node-5443873391', 'Estación de tren de Vilabella', 'Tren', '43165', NULL, NULL, 41.2395, 1.31748, 'address', 'openstreetmap:node/5443873391'),
  ('catalogo-cataluna:estaciones:node-5443935580', 'Estación de tren de la Riba – Eix Salou - Andorra C-14', 'Tren', '43124', 'Eix Salou - Andorra C-14', NULL, 41.31843, 1.18136, 'address', 'openstreetmap:node/5443935580'),
  ('catalogo-cataluna:estaciones:node-5451606993', 'Estación de tren de Vimbodí (Vimbodí i Poblet) – Carrer de l''Estació', 'Tren', '43176', 'Carrer de l''Estació', '43430', 41.40269, 1.04603, 'address', 'openstreetmap:node/5451606993'),
  ('catalogo-cataluna:estaciones:node-5452414077', 'Estación de tren de Flix – Carrer d''Ernesto Scheef', 'Tren', '43060', 'Carrer d''Ernesto Scheef', NULL, 41.22942, 0.54015, 'address', 'openstreetmap:node/5452414077'),
  ('catalogo-cataluna:estaciones:node-5453800281', 'Estación de tren de les Borges del Camp – Carrer de la Indústria', 'Tren', '43031', 'Carrer de la Indústria', NULL, 41.16641, 1.02207, 'address', 'openstreetmap:node/5453800281'),
  ('catalogo-cataluna:estaciones:node-5786065924', 'Estació d''autobusos d''Amposta – Avinguda de Santa Bàrbara', 'Autobús', '43014', 'Avinguda de Santa Bàrbara 125', '43870', 40.70686, 0.57202, 'address', 'openstreetmap:node/5786065924'),
  ('catalogo-cataluna:estaciones:node-7108274841', 'Estación de tren de l''Hospitalet de l''Infant (Vandellòs i l''Hospitalet de l''Infant) – Plaça de l''Estació', 'Tren', '43162', 'Plaça de l''Estació', NULL, 40.99965, 0.9124, 'address', 'openstreetmap:node/7108274841'),
  ('catalogo-cataluna:estaciones:node-7204816745', 'Estación de tren de l''Arboç – Carrer de l''Estació', 'Tren', '43016', 'Carrer de l''Estació 1', '43720', 41.27367, 1.60041, 'address', 'openstreetmap:node/7204816745'),
  ('catalogo-cataluna:estaciones:node-7204816746', 'Estación de tren de el Vendrell – Avinguda Jaume Carner', 'Tren', '43163', 'Avinguda Jaume Carner 1', '43700', 41.2209, 1.53813, 'address', 'openstreetmap:node/7204816746'),
  ('catalogo-cataluna:estaciones:node-7204816747', 'Estación de tren de Sant Vicenç de Calders (el Vendrell)', 'Tren', '43163', NULL, '43880', 41.18608, 1.52579, 'address', 'openstreetmap:node/7204816747'),
  ('catalogo-cataluna:estaciones:node-7204816750', 'Estación de tren de Segur de Calafell – Carrer de Lluís Companys', 'Tren', '43037', 'Carrer de Lluís Companys 55', '43882', 41.19246, 1.60645, 'address', 'openstreetmap:node/7204816750'),
  ('catalogo-cataluna:estaciones:node-7204816751', 'Estación de tren de Cunit – Avinguda de Vilanova i la Geltrú', 'Tren', '43051', 'Avinguda de Vilanova i la Geltrú 128', '43881', 41.19476, 1.63154, 'address', 'openstreetmap:node/7204816751'),
  ('catalogo-cataluna:estaciones:node-7206954504', 'Estación de tren de Vila-seca – Carrer de Josep Anselm Clavé', 'Tren', '43171', 'Carrer de Josep Anselm Clavé', NULL, 41.11288, 1.15044, 'address', 'openstreetmap:node/7206954504'),
  ('catalogo-cataluna:estaciones:node-7206954520', 'Estación de tren de Reus – Plaça de l''Estació', 'Tren', '43123', 'Plaça de l''Estació', '43202', 41.1606, 1.09994, 'address', 'openstreetmap:node/7206954520'),
  ('catalogo-cataluna:estaciones:node-7220776558', 'Estación de tren de Cambrils – Passeig de Sant Joan Baptista de la Salle', 'Tren', '43038', 'Passeig de Sant Joan Baptista de la Salle', NULL, 41.08111, 1.04528, 'address', 'openstreetmap:node/7220776558'),
  ('catalogo-cataluna:estaciones:node-7554725804', 'Estación de tren de Riba-roja d''Ebre', 'Tren', '43125', NULL, NULL, 41.24851, 0.48079, 'address', 'openstreetmap:node/7554725804'),
  ('catalogo-cataluna:estaciones:node-7557284885', 'Estación de tren de Faió - la Pobla de Massaluca', 'Tren', '43110', NULL, NULL, 41.22498, 0.35078, 'address', 'openstreetmap:node/7557284885'),
  ('catalogo-cataluna:estaciones:relation-21614086', 'Estació d''autobusos a l''aeroport de Reus', 'Autobús', '43123', NULL, '43201', 41.14593, 1.15335, 'address', 'openstreetmap:relation/21614086'),
  ('catalogo-cataluna:estaciones:way-1014924821', 'Estación de tren de Valls – Plaça de l''Estació', 'Tren', '43161', 'Plaça de l''Estació 1', '43800', 41.28958, 1.25871, 'address', 'openstreetmap:way/1014924821'),
  ('catalogo-cataluna:estaciones:way-1030951490', 'Estació de Misericòrdia (Reus) – Avinguda dels Països Catalans', 'Tren', '43123', 'Avinguda dels Països Catalans', NULL, 41.14477, 1.09927, 'address', 'openstreetmap:way/1030951490'),
  ('catalogo-cataluna:estaciones:way-1128446605', 'Estació d''autobusos de Reus – Avinguda de Salou', 'Autobús', '43123', 'Avinguda de Salou 11', '43205', 41.14778, 1.11176, 'address', 'openstreetmap:way/1128446605'),
  ('catalogo-cataluna:estaciones:way-118022027', 'Estació del Nord (Salou)', 'Tren', '43905', NULL, NULL, 41.08516, 1.15698, 'address', 'openstreetmap:way/118022027'),
  ('catalogo-cataluna:estaciones:way-120299743', 'Estación de tren de Penitence Station (Salou)', 'Tren', '43905', NULL, '43840', 41.08893, 1.15629, 'address', 'openstreetmap:way/120299743'),
  ('catalogo-cataluna:estaciones:way-1353188559', 'Estació d''autobusos de Valls – Carrer Anselm Clavé', 'Autobús', '43161', 'Carrer Anselm Clavé 16', '43800', 41.28592, 1.25374, 'address', 'openstreetmap:way/1353188559'),
  ('catalogo-cataluna:estaciones:way-190636937', 'Estación de tren de Ulldecona-Alcanar-la Sénia – Passeig de l''Estació', 'Tren', '43156', 'Passeig de l''Estació', '43550', 40.59593, 0.44929, 'address', 'openstreetmap:way/190636937'),
  ('catalogo-cataluna:estaciones:way-196651546', 'Gandesa Estació d''autobusos – Carrer de Joan Perucho', 'Autobús', '43064', 'Carrer de Joan Perucho 4', '43780', 41.05748, 0.44086, 'address', 'openstreetmap:way/196651546'),
  ('catalogo-cataluna:estaciones:way-206891794', 'Estació d''Autobusos d''El Vendrell – Avinguda Jaume Carner', 'Autobús', '43163', 'Avinguda Jaume Carner 40', '43700', 41.21844, 1.53631, 'address', 'openstreetmap:way/206891794'),
  ('catalogo-cataluna:estaciones:way-366377318', 'Estación de tren de SésamoAventura Station (Salou)', 'Tren', '43905', NULL, NULL, 41.08674, 1.16015, 'address', 'openstreetmap:way/366377318'),
  ('catalogo-cataluna:estaciones:way-586026629', 'Estació d''autobusos de Tarragona – Carrer Dr. Battestini 4Bis', 'Autobús', '43148', 'Carrer Dr. Battestini 4Bis', '43005', 41.11819, 1.24429, 'approximate', 'openstreetmap:way/586026629'),
  ('catalogo-cataluna:estaciones:way-634390995', 'Estació d''autobusos de Tortosa – Carrer de Lamotte de Grignon', 'Autobús', '43155', 'Carrer de Lamotte de Grignon 2', '43500', 40.80586, 0.52198, 'address', 'openstreetmap:way/634390995'),
  ('catalogo-cataluna:estaciones:way-722329735', 'Estación de autobuses de Autocars Penedes (Santa Oliva) – Carrer del Tarragonès', 'Autobús', '43140', 'Carrer del Tarragonès 30', '43710', 41.23937, 1.54728, 'address', 'openstreetmap:way/722329735'),
  ('catalogo-cataluna:estaciones:way-722329736', 'Estación de autobuses de Autocars Poch (Santa Oliva) – Carrer del Tarragonès', 'Autobús', '43140', 'Carrer del Tarragonès 21', '43710', 41.23805, 1.54581, 'address', 'openstreetmap:way/722329736'),
  ('catalogo-cataluna:estaciones:way-755292817', 'Estació d''autobusos de Cambrils – Passeig de Sant Joan Baptista de la Salle', 'Autobús', '43038', 'Passeig de Sant Joan Baptista de la Salle', '43850', 41.06898, 1.05533, 'address', 'openstreetmap:way/755292817'),
  ('catalogo-cataluna:estaciones:way-756018539', 'Estació d''autobusos Salou – Plaça de les Comunitats Autònomes', 'Autobús', '43905', 'Plaça de les Comunitats Autònomes', '43840', 41.07423, 1.13932, 'address', 'openstreetmap:way/756018539'),
  ('catalogo-cataluna:estaciones:way-86387183', 'Intercanviador d''autobussos de Battestini (Tarragona) – Avinguda de Roma', 'Autobús', '43148', 'Avinguda de Roma', '43005', 41.11804, 1.24385, 'approximate', 'openstreetmap:way/86387183'),
  ('catalogo-cataluna:estaciones:way-884500381', 'Estació d''autobusos Móra d''Ebre – Camí de les Sínies', 'Autobús', '43093', 'Camí de les Sínies', NULL, 41.08861, 0.64438, 'address', 'openstreetmap:way/884500381'),
  ('catalogo-cataluna:estaciones:way-922106655', 'Parada bus IES Coster de la Torre (la Bisbal del Penedès) – Camí de Gosch', 'Autobús', '43028', 'Camí de Gosch 9', '43717', 41.27576, 1.48927, 'approximate', 'openstreetmap:way/922106655');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '43');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 43 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '43'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 66 THEN
    RAISE EXCEPTION 'Se esperaban 66 puntos de Estaciones en Tarragona, hay %', n;
  END IF;
END;
$$;

COMMIT;
