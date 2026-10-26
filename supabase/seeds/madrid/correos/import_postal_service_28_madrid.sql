-- Carga de la categoría Correos de Madrid (provincia 28), trozo de la carga de Andalucía.
-- Origen: postal_service-madrid.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 190 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-madrid:postal_service:node-10053462054', 'Correos Madrid – Calle del Monte Olivetti', NULL, '28079', 'Calle del Monte Olivetti 15', '28038', 40.3981, -3.66735, 'address', 'openstreetmap:node/10053462054'),
  ('catalogo-madrid:postal_service:node-10067418221', 'Correos Alcorcón – Calle Porto Cristo', NULL, '28007', 'Calle Porto Cristo 13', '28924', 40.35053, -3.81586, 'address', 'openstreetmap:node/10067418221'),
  ('catalogo-madrid:postal_service:node-10126850412', 'Correos Madrid – Calle de Ambrosio Vallejo', NULL, '28079', 'Calle de Ambrosio Vallejo 26', '28039', 40.45726, -3.70843, 'address', 'openstreetmap:node/10126850412'),
  ('catalogo-madrid:postal_service:node-1029729910', 'Correos Alcorcón – Calle Jabonería', NULL, '28007', 'Calle Jabonería 45', '28921', 40.34929, -3.82573, 'address', 'openstreetmap:node/1029729910'),
  ('catalogo-madrid:postal_service:node-1029729911', 'Correos Alcorcón – Calle Mayor', NULL, '28007', 'Calle Mayor 99', '28922', 40.34079, -3.82789, 'address', 'openstreetmap:node/1029729911'),
  ('catalogo-madrid:postal_service:node-10687896512', 'Correos Madrid – Calle de Miranda de Arga', NULL, '28079', 'Calle de Miranda de Arga 5', '28033', 40.47589, -3.6493, 'address', 'openstreetmap:node/10687896512'),
  ('catalogo-madrid:postal_service:node-10760817439', 'Correos Fuenlabrada – Urbanización Nuevo Versalles', NULL, '28058', 'Urbanización Nuevo Versalles 9', '28942', 40.29346, -3.83303, 'address', 'openstreetmap:node/10760817439'),
  ('catalogo-madrid:postal_service:node-11063317300', 'Correos Getafe – Calle Diez y Barcala', NULL, '28065', 'Calle Diez y Barcala', '28905', 40.29698, -3.75074, 'address', 'openstreetmap:node/11063317300'),
  ('catalogo-madrid:postal_service:node-11130669203', 'Correos Valdetorres de Jarama – Calle Airosa', NULL, '28164', 'Calle Airosa 31', '28150', 40.69693, -3.51593, 'address', 'openstreetmap:node/11130669203'),
  ('catalogo-madrid:postal_service:node-11224990812', 'Correos Valdemaqueda – Travesía Dos de Mayo', NULL, '28159', 'Travesía Dos de Mayo', '28295', 40.51136, -4.29597, 'address', 'openstreetmap:node/11224990812'),
  ('catalogo-madrid:postal_service:node-11274408026', 'Correos Tres Cantos – Sector Literatos', NULL, '28903', 'Sector Literatos 22', '28760', 40.6085, -3.71418, 'address', 'openstreetmap:node/11274408026'),
  ('catalogo-madrid:postal_service:node-11327726108', 'Correos Getafe – Calle Jardines', NULL, '28065', 'Calle Jardines 4', '28901', 40.30511, -3.73131, 'address', 'openstreetmap:node/11327726108'),
  ('catalogo-madrid:postal_service:node-11327899795', 'Correos Getafe – Calle de Isabel Allende', NULL, '28065', 'Calle de Isabel Allende', '28903', 40.32595, -3.72102, 'address', 'openstreetmap:node/11327899795'),
  ('catalogo-madrid:postal_service:node-11491968176', 'Correos Parla – Calle Estrella Antares', NULL, '28106', 'Calle Estrella Antares 1', '28983', 40.23235, -3.75644, 'address', 'openstreetmap:node/11491968176'),
  ('catalogo-madrid:postal_service:node-11530380932', 'Correos Madrid – Calle de la Isla Graciosa', NULL, '28079', 'Calle de la Isla Graciosa 1', '28034', 40.49309, -3.68586, 'address', 'openstreetmap:node/11530380932'),
  ('catalogo-madrid:postal_service:node-11684887669', 'Correos Majadahonda – Calle Fresa', NULL, '28080', 'Calle Fresa', '28220', 40.45481, -3.87382, 'address', 'openstreetmap:node/11684887669'),
  ('catalogo-madrid:postal_service:node-12022944880', 'Correos Valdemorillo – Calle Caracol', NULL, '28160', 'Calle Caracol 10', '28210', 40.50155, -4.06752, 'address', 'openstreetmap:node/12022944880'),
  ('catalogo-madrid:postal_service:node-12156119721', 'Correos Becerril de la Sierra – Calle Orense', NULL, '28018', 'Calle Orense 11', '28490', 40.71567, -3.98816, 'address', 'openstreetmap:node/12156119721'),
  ('catalogo-madrid:postal_service:node-12564919599', 'Correos Boadilla del Monte – calle del carmen', NULL, '28022', 'calle del carmen 1', '28660', 40.40733, -3.87679, 'address', 'openstreetmap:node/12564919599'),
  ('catalogo-madrid:postal_service:node-12731593074', 'Correos Villanueva de Perales – Calle Nueva', NULL, '28178', 'Calle Nueva 2', '28609', 40.34643, -4.10276, 'address', 'openstreetmap:node/12731593074'),
  ('catalogo-madrid:postal_service:node-13005885072', 'Correos Valdeavero – Calle Palacio', NULL, '28156', 'Calle Palacio 1', '28816', 40.63079, -3.33224, 'address', 'openstreetmap:node/13005885072'),
  ('catalogo-madrid:postal_service:node-1309053176', 'Correos Madrid – Calle de Palos de la Frontera 6-10', NULL, '28079', 'Calle de Palos de la Frontera 6-10', '28012', 40.4027, -3.69975, 'address', 'openstreetmap:node/1309053176'),
  ('catalogo-madrid:postal_service:node-1379930409', 'Correos Madrid – Calle de Carlina', NULL, '28079', 'Calle de Carlina 8', '28011', 40.4047, -3.75119, 'address', 'openstreetmap:node/1379930409'),
  ('catalogo-madrid:postal_service:node-13840165670', 'Correos San Fernando de Henares – Sierra de Aitana', NULL, '28130', 'Sierra de Aitana', '28850', 40.44971, -3.51097, 'address', 'openstreetmap:node/13840165670'),
  ('catalogo-madrid:postal_service:node-1388736683', 'Correos Madrid – Calle de Arturo Soria', NULL, '28079', 'Calle de Arturo Soria 189', '28043', 40.45843, -3.65932, 'address', 'openstreetmap:node/1388736683'),
  ('catalogo-madrid:postal_service:node-1405063989', 'Correos Madrid – Calle de La Rioja', NULL, '28079', 'Calle de La Rioja 11', '28042', 40.45754, -3.58871, 'address', 'openstreetmap:node/1405063989'),
  ('catalogo-madrid:postal_service:node-14139210101', 'Correos Villanueva de la Cañada – Travesía El Cristo', NULL, '28176', 'Travesía El Cristo 4', '28691', 40.44747, -4.00298, 'address', 'openstreetmap:node/14139210101'),
  ('catalogo-madrid:postal_service:node-1419263623', 'Correos Coslada – Calle del Doctor Michavila', NULL, '28049', 'Calle del Doctor Michavila 4', '28821', 40.42722, -3.56358, 'address', 'openstreetmap:node/1419263623'),
  ('catalogo-madrid:postal_service:node-143098064', 'Correos Madrid – Calle de Virgen de Aránzazu', NULL, '28079', 'Calle de Virgen de Aránzazu 31', '28034', 40.48693, -3.68969, 'address', 'openstreetmap:node/143098064'),
  ('catalogo-madrid:postal_service:node-1430997694', 'Correos Madrid – Avenida del Marqués de Corbera', NULL, '28079', 'Avenida del Marqués de Corbera 27', '28017', 40.42441, -3.65408, 'address', 'openstreetmap:node/1430997694'),
  ('catalogo-madrid:postal_service:node-1448622985', 'Correos Colmenar Viejo – Calle del Estanco', NULL, '28045', 'Calle del Estanco 7', '28770', 40.65943, -3.76522, 'address', 'openstreetmap:node/1448622985'),
  ('catalogo-madrid:postal_service:node-1482957188', 'Correos Móstoles – Avenida de Portugal', NULL, '28092', 'Avenida de Portugal', '28931', 40.3254, -3.86882, 'address', 'openstreetmap:node/1482957188'),
  ('catalogo-madrid:postal_service:node-1496429206', 'Correos Madrid – Calle de San Magín', NULL, '28079', 'Calle de San Magín 5', '28026', 40.38457, -3.71544, 'address', 'openstreetmap:node/1496429206'),
  ('catalogo-madrid:postal_service:node-1501744326', 'Correos Campo Real – Calle de la Flor', NULL, '28033', 'Calle de la Flor 15', '28510', 40.33845, -3.38303, 'address', 'openstreetmap:node/1501744326'),
  ('catalogo-madrid:postal_service:node-1535842816', 'Correos Madrid – Avenida del Padre Piquer', NULL, '28079', 'Avenida del Padre Piquer 13', '28024', 40.39409, -3.76766, 'address', 'openstreetmap:node/1535842816'),
  ('catalogo-madrid:postal_service:node-1576722186', 'Correos Las Rozas de Madrid – Calle del Castillo de Atienza 2B', NULL, '28127', 'Calle del Castillo de Atienza 2B', '28232', 40.50713, -3.8925, 'address', 'openstreetmap:node/1576722186'),
  ('catalogo-madrid:postal_service:node-1595009302', 'Correos Madrid – Calle de Longares', NULL, '28079', 'Calle de Longares 30', '28022', 40.42914, -3.60964, 'address', 'openstreetmap:node/1595009302'),
  ('catalogo-madrid:postal_service:node-1661261807', 'Correos Villanueva del Pardillo – Calle Ramón y Cajal', NULL, '28177', 'Calle Ramón y Cajal', '28229', 40.49348, -3.96521, 'address', 'openstreetmap:node/1661261807'),
  ('catalogo-madrid:postal_service:node-1675789543', 'Correos Madrid – Carrera de San Francisco', NULL, '28079', 'Carrera de San Francisco 13', '28005', 40.4106, -3.71321, 'address', 'openstreetmap:node/1675789543'),
  ('catalogo-madrid:postal_service:node-1687397388', 'Correos Madrid – Calle de Alanís', NULL, '28079', 'Calle de Alanís 1', '28042', 40.47114, -3.58309, 'address', 'openstreetmap:node/1687397388'),
  ('catalogo-madrid:postal_service:node-1725936542', 'Correos Paracuellos de Jarama – Calle del Valle de la Fuente Grande', NULL, '28104', 'Calle del Valle de la Fuente Grande', '28860', 40.50594, -3.52879, 'address', 'openstreetmap:node/1725936542'),
  ('catalogo-madrid:postal_service:node-1732744211', 'Correos Madrid – Calle de Margarita de Parma', NULL, '28079', 'Calle de Margarita de Parma 1', '28050', 40.49756, -3.66182, 'address', 'openstreetmap:node/1732744211'),
  ('catalogo-madrid:postal_service:node-1734554353', 'Correos Alcalá de Henares – Calle de Federico García Lorca', NULL, '28005', 'Calle de Federico García Lorca', NULL, 40.50377, -3.37082, 'address', 'openstreetmap:node/1734554353'),
  ('catalogo-madrid:postal_service:node-1758521172', 'Correos Pedrezuela – Plaza de la Constitución', NULL, '28108', 'Plaza de la Constitución 1', '28723', 40.74502, -3.6028, 'address', 'openstreetmap:node/1758521172'),
  ('catalogo-madrid:postal_service:node-1806109041', 'Correos Moralzarzal – Calle Vía del Berrocal', NULL, '28090', 'Calle Vía del Berrocal', '28411', 40.67942, -3.96559, 'address', 'openstreetmap:node/1806109041'),
  ('catalogo-madrid:postal_service:node-1812323465', 'Correos Madrid – Camino de las Hormigueras', NULL, '28079', 'Camino de las Hormigueras 169', '28031', 40.37686, -3.63542, 'address', 'openstreetmap:node/1812323465'),
  ('catalogo-madrid:postal_service:node-1816214632', 'Correos Velilla de San Antonio – Calle Libertad', NULL, '28167', 'Calle Libertad 11', '28891', 40.3688, -3.48582, 'address', 'openstreetmap:node/1816214632'),
  ('catalogo-madrid:postal_service:node-1819049871', 'Correos Navacerrada – Calle Manzanares', NULL, '28093', 'Calle Manzanares 12', '28491', 40.73012, -4.011, 'address', 'openstreetmap:node/1819049871'),
  ('catalogo-madrid:postal_service:node-1834704978', 'Correos Madrid – Calle de la Dobla', NULL, '28079', 'Calle de la Dobla 13', '28054', 40.37224, -3.74018, 'address', 'openstreetmap:node/1834704978'),
  ('catalogo-madrid:postal_service:node-1836824616', 'Correos Madrid – Calle de Jacinto Verdaguer', NULL, '28079', 'Calle de Jacinto Verdaguer 4', '28019', 40.3963, -3.71434, 'address', 'openstreetmap:node/1836824616'),
  ('catalogo-madrid:postal_service:node-1849049457', 'Correos Alcalá de Henares – Avenida de Juan Carlos I', NULL, '28005', 'Avenida de Juan Carlos I', '28806', 40.47997, -3.40049, 'address', 'openstreetmap:node/1849049457'),
  ('catalogo-madrid:postal_service:node-1849696227', 'Correos Fuenlabrada – Calle de la Paz', NULL, '28058', 'Calle de la Paz', '28944', 40.28396, -3.793, 'address', 'openstreetmap:node/1849696227'),
  ('catalogo-madrid:postal_service:node-1888551195', 'Correos Madrid – Calle de Antonio Arias', NULL, '28079', 'Calle de Antonio Arias 2', '28009', 40.41785, -3.67158, 'address', 'openstreetmap:node/1888551195'),
  ('catalogo-madrid:postal_service:node-1924941031', 'Correos Griñón – Calle Cuesta de la Frontera', NULL, '28066', 'Calle Cuesta de la Frontera', '28971', 40.21235, -3.84958, 'address', 'openstreetmap:node/1924941031'),
  ('catalogo-madrid:postal_service:node-1947497827', 'Correos Madrid – Avenida de la Plaza de Toros', NULL, '28079', 'Avenida de la Plaza de Toros 16', '28025', 40.38748, -3.73997, 'address', 'openstreetmap:node/1947497827'),
  ('catalogo-madrid:postal_service:node-2035332482', 'Correos Villalbilla – Avenida de España', NULL, '28172', 'Avenida de España 2', '28810', 40.44919, -3.36578, 'address', 'openstreetmap:node/2035332482'),
  ('catalogo-madrid:postal_service:node-2083217674', 'Correos Miraflores de la Sierra – Calle del Río', NULL, '28085', 'Calle del Río', '28792', 40.81093, -3.76888, 'address', 'openstreetmap:node/2083217674'),
  ('catalogo-madrid:postal_service:node-2094212846', 'Correos Madrid – Avenida de Monforte de Lemos', NULL, '28079', 'Avenida de Monforte de Lemos 36', '28029', 40.48062, -3.70604, 'address', 'openstreetmap:node/2094212846'),
  ('catalogo-madrid:postal_service:node-2134170650', 'Correos Camarma de Esteruelas – Calle Aguadores', NULL, '28032', 'Calle Aguadores 3', '28816', 40.55098, -3.37417, 'address', 'openstreetmap:node/2134170650'),
  ('catalogo-madrid:postal_service:node-2134285289', 'Correos Alcalá de Henares – Calle del Clavel', NULL, '28005', 'Calle del Clavel 4', '28803', 40.47744, -3.37199, 'address', 'openstreetmap:node/2134285289'),
  ('catalogo-madrid:postal_service:node-2137689220', 'Correos Madrid – Calle Tomás Borrás', NULL, '28079', 'Calle Tomás Borrás 5', '28045', 40.39539, -3.69687, 'address', 'openstreetmap:node/2137689220'),
  ('catalogo-madrid:postal_service:node-2140576882', 'Correos San Fernando de Henares – Calle de la Presa', NULL, '28130', 'Calle de la Presa 20', '28830', 40.42805, -3.52936, 'address', 'openstreetmap:node/2140576882'),
  ('catalogo-madrid:postal_service:node-2254645414', 'Correos Fuenlabrada – Calle de Burgos', NULL, '28058', 'Calle de Burgos 4', '28941', 40.29259, -3.80424, 'address', 'openstreetmap:node/2254645414'),
  ('catalogo-madrid:postal_service:node-2319902207', 'Correos Alcobendas – Calle de la Libertad', NULL, '28006', 'Calle de la Libertad', '28100', 40.54004, -3.63538, 'address', 'openstreetmap:node/2319902207'),
  ('catalogo-madrid:postal_service:node-2387504257', 'Correos Alpedrete – Calle del Calvario', NULL, '28010', 'Calle del Calvario 17', '28430', 40.65909, -4.02162, 'address', 'openstreetmap:node/2387504257'),
  ('catalogo-madrid:postal_service:node-2392712866', 'Correos Madrid – Calle de Chile', NULL, '28079', 'Calle de Chile 4', '28016', 40.45549, -3.67599, 'address', 'openstreetmap:node/2392712866'),
  ('catalogo-madrid:postal_service:node-2515777544', 'Correos El Escorial – Plaza de España', NULL, '28054', 'Plaza de España 11', '28280', 40.58484, -4.12982, 'address', 'openstreetmap:node/2515777544'),
  ('catalogo-madrid:postal_service:node-2568735837', 'Correos Madrid – Avenida Real de Pinto', NULL, '28079', 'Avenida Real de Pinto 66', '28021', 40.34339, -3.70729, 'address', 'openstreetmap:node/2568735837'),
  ('catalogo-madrid:postal_service:node-257725046', 'Correos Madrid – Calle del Padre Rubio', NULL, '28079', 'Calle del Padre Rubio 43', '28029', 40.47092, -3.69387, 'address', 'openstreetmap:node/257725046'),
  ('catalogo-madrid:postal_service:node-2619712904', 'Correos Colmenarejo – Calle Vistalegre', NULL, '28044', 'Calle Vistalegre 14', '28270', 40.56179, -4.01718, 'address', 'openstreetmap:node/2619712904'),
  ('catalogo-madrid:postal_service:node-2631391836', 'Correos Madrid – Calle de Orense', NULL, '28079', 'Calle de Orense 55', '28020', 40.45624, -3.69498, 'address', 'openstreetmap:node/2631391836'),
  ('catalogo-madrid:postal_service:node-2646180932', 'Correos Madrid – Calle del Alcalde López Casero', NULL, '28079', 'Calle del Alcalde López Casero 3', '28027', 40.43262, -3.65567, 'address', 'openstreetmap:node/2646180932'),
  ('catalogo-madrid:postal_service:node-2671134368', 'Correos Madrid – Calle de Vallehermoso', NULL, '28079', 'Calle de Vallehermoso 6', '28015', 40.43067, -3.70882, 'address', 'openstreetmap:node/2671134368'),
  ('catalogo-madrid:postal_service:node-2685726047', 'Correos Villaconejos – Plaza de la Alegría', NULL, '28170', 'Plaza de la Alegría', '28360', 40.10449, -3.48656, 'address', 'openstreetmap:node/2685726047'),
  ('catalogo-madrid:postal_service:node-268762448', 'Correos Madrid – Calle Caroli', NULL, '28079', 'Calle Caroli 10', '28023', 40.45847, -3.78474, 'address', 'openstreetmap:node/268762448'),
  ('catalogo-madrid:postal_service:node-2758388988', 'Correos Madrid – Calle de Téllez', NULL, '28079', 'Calle de Téllez 27', '28007', 40.40228, -3.678, 'address', 'openstreetmap:node/2758388988'),
  ('catalogo-madrid:postal_service:node-2782205288', 'Correos Madrid – Calle de Pizarro', NULL, '28079', 'Calle de Pizarro 17', '28004', 40.42337, -3.70576, 'address', 'openstreetmap:node/2782205288'),
  ('catalogo-madrid:postal_service:node-2799017163', 'Correos Madrid – Avenida Ensanche de Vallecas', NULL, '28079', 'Avenida Ensanche de Vallecas 104', '28051', 40.36098, -3.5949, 'address', 'openstreetmap:node/2799017163'),
  ('catalogo-madrid:postal_service:node-2841598427', 'Correos Galapagar – Calle de la Soberanía', NULL, '28061', 'Calle de la Soberanía 25', '28260', 40.57523, -4.00388, 'address', 'openstreetmap:node/2841598427'),
  ('catalogo-madrid:postal_service:node-2874783285', 'Correos Madrid – Bulevar de José Prat', NULL, '28079', 'Bulevar de José Prat 35', '28032', 40.39778, -3.61799, 'address', 'openstreetmap:node/2874783285'),
  ('catalogo-madrid:postal_service:node-2894124521', 'Correos Móstoles – Calle Simón Hernández', NULL, '28092', 'Calle Simón Hernández 62', '28937', 40.31965, -3.85616, 'address', 'openstreetmap:node/2894124521'),
  ('catalogo-madrid:postal_service:node-2954583966', 'Correos Madrid – Calle del Arroyo de la Media Legua', NULL, '28079', 'Calle del Arroyo de la Media Legua 56', '28030', 40.4103, -3.65558, 'address', 'openstreetmap:node/2954583966'),
  ('catalogo-madrid:postal_service:node-302803934', 'Correos Madrid – Calle de las Islas Palaos', NULL, '28079', 'Calle de las Islas Palaos 30', '28034', 40.49771, -3.68637, 'address', 'openstreetmap:node/302803934'),
  ('catalogo-madrid:postal_service:node-3032838374', 'Correos Alcobendas', NULL, '28006', NULL, NULL, 40.52625, -3.65183, 'address', 'openstreetmap:node/3032838374'),
  ('catalogo-madrid:postal_service:node-3034007150', 'Correos Sevilla la Nueva – Calle Nuestra Señora Del Villar', NULL, '28141', 'Calle Nuestra Señora Del Villar 5', '28609', 40.34916, -4.02618, 'address', 'openstreetmap:node/3034007150'),
  ('catalogo-madrid:postal_service:node-3039584168', 'Correos Madrid – Calle de Fernando VII', NULL, '28079', 'Calle de Fernando VII 21', '28037', 40.43454, -3.61533, 'address', 'openstreetmap:node/3039584168'),
  ('catalogo-madrid:postal_service:node-306469768', 'Correos Madrid – Calle del Sanguiño', NULL, '28079', 'Calle del Sanguiño 6', '28044', 40.38213, -3.76455, 'address', 'openstreetmap:node/306469768'),
  ('catalogo-madrid:postal_service:node-3144127115', 'Correos Madrid – Calle de Mejía Lequerica', NULL, '28079', 'Calle de Mejía Lequerica 7', '28004', 40.42658, -3.69827, 'address', 'openstreetmap:node/3144127115'),
  ('catalogo-madrid:postal_service:node-315219328', 'Correos Madrid – Calle del Sahara', NULL, '28079', 'Calle del Sahara 42', '28041', 40.35484, -3.69266, 'address', 'openstreetmap:node/315219328'),
  ('catalogo-madrid:postal_service:node-3175841578', 'Correos Meco – Avenida del Olivo', NULL, '28083', 'Avenida del Olivo', '28880', 40.54623, -3.32799, 'address', 'openstreetmap:node/3175841578'),
  ('catalogo-madrid:postal_service:node-327047325', 'Correos Pozuelo de Alarcón – Calle Sagunto', NULL, '28115', 'Calle Sagunto 10', '28223', 40.43553, -3.81264, 'address', 'openstreetmap:node/327047325'),
  ('catalogo-madrid:postal_service:node-3283849674', 'Correos Madrid – Calle de Luis Vélez de Guevara', NULL, '28079', 'Calle de Luis Vélez de Guevara 10', '28012', 40.41291, -3.70237, 'address', 'openstreetmap:node/3283849674'),
  ('catalogo-madrid:postal_service:node-3294852974', 'Correos Madrid – Calle de Tirajana', NULL, '28079', 'Calle de Tirajana 2', '28017', 40.42724, -3.63184, 'address', 'openstreetmap:node/3294852974'),
  ('catalogo-madrid:postal_service:node-3326469035', 'Correos Madrid – Calle del Corregidor Alonso de Tobar', NULL, '28079', 'Calle del Corregidor Alonso de Tobar 13', '28030', 40.40356, -3.64866, 'address', 'openstreetmap:node/3326469035'),
  ('catalogo-madrid:postal_service:node-3332492464', 'Correos Madrid – Plaza de Rogelio Enríquez', NULL, '28079', 'Plaza de Rogelio Enríquez 5', '28048', 40.5189, -3.77686, 'address', 'openstreetmap:node/3332492464'),
  ('catalogo-madrid:postal_service:node-3376089131', 'Correos Las Rozas de Madrid – Calle de San José Obrero', NULL, '28127', 'Calle de San José Obrero 13', '28290', 40.54942, -3.89436, 'address', 'openstreetmap:node/3376089131'),
  ('catalogo-madrid:postal_service:node-3393550089', 'Correos Madrid – Calle de Mariano Fernández', NULL, '28079', 'Calle de Mariano Fernández 1', '28039', 40.45604, -3.70297, 'address', 'openstreetmap:node/3393550089'),
  ('catalogo-madrid:postal_service:node-3395916985', 'Correos Collado Villalba – Calle Rincón de las Heras', NULL, '28047', 'Calle Rincón de las Heras', '28400', 40.63594, -4.00836, 'address', 'openstreetmap:node/3395916985'),
  ('catalogo-madrid:postal_service:node-3413150391', 'Correos Madrid – Calle de los Hermanos García Noblejas', NULL, '28079', 'Calle de los Hermanos García Noblejas 30', '28037', 40.4343, -3.63572, 'address', 'openstreetmap:node/3413150391'),
  ('catalogo-madrid:postal_service:node-353133926', 'Correos Madrid – Avenida del Santuario de Valverde', NULL, '28079', 'Avenida del Santuario de Valverde 45', '28049', 40.5055, -3.70191, 'address', 'openstreetmap:node/353133926'),
  ('catalogo-madrid:postal_service:node-357465007', 'Correos Torrejón de Ardoz – Carretera de la Base', NULL, '28148', 'Carretera de la Base', NULL, 40.46294, -3.45696, 'address', 'openstreetmap:node/357465007'),
  ('catalogo-madrid:postal_service:node-359261679', 'Correos Madrid – Plaza del Perú', NULL, '28079', 'Plaza del Perú 1', '28016', 40.46014, -3.67718, 'address', 'openstreetmap:node/359261679'),
  ('catalogo-madrid:postal_service:node-359500027', 'Correos Madrid – Avenida del Monasterio de Silos', NULL, '28079', 'Avenida del Monasterio de Silos 29', '28049', 40.50355, -3.704, 'address', 'openstreetmap:node/359500027'),
  ('catalogo-madrid:postal_service:node-3643091685', 'Correos San Martín de la Vega – Avenida del Doce de Octubre', NULL, '28132', 'Avenida del Doce de Octubre 29', '28330', 40.20784, -3.57869, 'address', 'openstreetmap:node/3643091685'),
  ('catalogo-madrid:postal_service:node-365384664', 'Correos Majadahonda – Calle Fresa', NULL, '28080', 'Calle Fresa 2', '28222', 40.45472, -3.87488, 'address', 'openstreetmap:node/365384664'),
  ('catalogo-madrid:postal_service:node-3812399711', 'Correos Alcalá de Henares – Calle José Caballero 5-7', NULL, '28005', 'Calle José Caballero 5-7', '28805', 40.48853, -3.35042, 'address', 'openstreetmap:node/3812399711'),
  ('catalogo-madrid:postal_service:node-3825905760', 'Correos Leganés – Plaza del Salvador', NULL, '28074', 'Plaza del Salvador', '28911', 40.32723, -3.76504, 'address', 'openstreetmap:node/3825905760'),
  ('catalogo-madrid:postal_service:node-4100193594', 'Correos Majadahonda – Calle de Oriente', NULL, '28080', 'Calle de Oriente 7', '28220', 40.47283, -3.87506, 'address', 'openstreetmap:node/4100193594'),
  ('catalogo-madrid:postal_service:node-4128102589', 'Correos Algete – Calle María Amor', NULL, '28009', 'Calle María Amor 4', '28110', 40.59918, -3.50042, 'address', 'openstreetmap:node/4128102589'),
  ('catalogo-madrid:postal_service:node-4214697662', 'Correos Madrid – Calle de los Mártires Concepcionistas', NULL, '28079', 'Calle de los Mártires Concepcionistas 21', '28006', 40.42923, -3.67071, 'address', 'openstreetmap:node/4214697662'),
  ('catalogo-madrid:postal_service:node-4266037734', 'Correos Casarrubuelos – Calle de Josefa Tomé y Orgaz', NULL, '28036', 'Calle de Josefa Tomé y Orgaz 12', '28977', 40.17092, -3.83403, 'address', 'openstreetmap:node/4266037734'),
  ('catalogo-madrid:postal_service:node-4304404995', 'Correos Madrid – Avenida del Cardenal Herrera Oria', NULL, '28079', 'Avenida del Cardenal Herrera Oria 241', '28035', 40.48165, -3.7188, 'address', 'openstreetmap:node/4304404995'),
  ('catalogo-madrid:postal_service:node-431435662', 'Correos Torrejón de Ardoz – Calle de Garabay', NULL, '28148', 'Calle de Garabay 12', '28850', 40.44329, -3.46079, 'address', 'openstreetmap:node/431435662'),
  ('catalogo-madrid:postal_service:node-431435664', 'Correos Torrejón de Ardoz – Avenida de la Constitución', NULL, '28148', 'Avenida de la Constitución 121', '28850', 40.45768, -3.47208, 'address', 'openstreetmap:node/431435664'),
  ('catalogo-madrid:postal_service:node-4369429442', 'Correos Madrid – Calle de Guzmán el Bueno', NULL, '28079', 'Calle de Guzmán el Bueno 86', '28003', 40.43992, -3.71263, 'address', 'openstreetmap:node/4369429442'),
  ('catalogo-madrid:postal_service:node-4426211799', 'Correos Madrid – Plaza del Párroco Luis Calleja', NULL, '28079', 'Plaza del Párroco Luis Calleja 12', '28022', 40.44481, -3.61164, 'address', 'openstreetmap:node/4426211799'),
  ('catalogo-madrid:postal_service:node-4426228530', 'Correos Madrid – Calle de Blasco de Garay', NULL, '28079', 'Calle de Blasco de Garay 86', '28015', 40.43829, -3.71108, 'address', 'openstreetmap:node/4426228530'),
  ('catalogo-madrid:postal_service:node-4426228531', 'Correos Madrid – Calle Maudes', NULL, '28079', 'Calle Maudes 39', '28003', 40.44523, -3.69816, 'address', 'openstreetmap:node/4426228531'),
  ('catalogo-madrid:postal_service:node-4426228532', 'Correos Madrid – Calle de Raimundo Fernández Villaverde', NULL, '28079', 'Calle de Raimundo Fernández Villaverde 79', '28003', 40.44657, -3.69218, 'address', 'openstreetmap:node/4426228532'),
  ('catalogo-madrid:postal_service:node-4426234432', 'Correos Madrid – Paseo de Santa María de la Cabeza', NULL, '28079', 'Paseo de Santa María de la Cabeza 42', '28045', 40.40385, -3.6969, 'address', 'openstreetmap:node/4426234432'),
  ('catalogo-madrid:postal_service:node-4426243691', 'Correos Madrid – Calle de Santiago Alío', NULL, '28079', 'Calle de Santiago Alío 10', '28038', 40.38841, -3.64608, 'address', 'openstreetmap:node/4426243691'),
  ('catalogo-madrid:postal_service:node-4426250149', 'Correos Madrid – Paseo del Prado', NULL, '28079', 'Paseo del Prado 1', '28014', 40.41854, -3.69259, 'address', 'openstreetmap:node/4426250149'),
  ('catalogo-madrid:postal_service:node-4426250150', 'Correos Madrid – Calle de la Princesa', NULL, '28079', 'Calle de la Princesa 42', '28008', 40.42453, -3.71214, 'address', 'openstreetmap:node/4426250150'),
  ('catalogo-madrid:postal_service:node-4428724982', 'Correos Madrid – Calle de Claudio Coello', NULL, '28079', 'Calle de Claudio Coello 100', '28006', 40.4335, -3.68542, 'address', 'openstreetmap:node/4428724982'),
  ('catalogo-madrid:postal_service:node-4432837413', 'Correos Madrid – Calle del General Ricardos', NULL, '28079', 'Calle del General Ricardos 212', '28025', 40.38511, -3.73802, 'address', 'openstreetmap:node/4432837413'),
  ('catalogo-madrid:postal_service:node-4432837414', 'Correos Madrid – Avenida de la Plaza de Toros', NULL, '28079', 'Avenida de la Plaza de Toros', '28025', 40.38568, -3.73923, 'address', 'openstreetmap:node/4432837414'),
  ('catalogo-madrid:postal_service:node-4432841455', 'Correos Madrid – Calle de Villanueva', NULL, '28079', 'Calle de Villanueva 30', '28001', 40.42229, -3.68505, 'address', 'openstreetmap:node/4432841455'),
  ('catalogo-madrid:postal_service:node-4432841456', 'Correos Madrid – Calle del Conde de Peñalver', NULL, '28079', 'Calle del Conde de Peñalver 19', '28006', 40.42661, -3.67576, 'address', 'openstreetmap:node/4432841456'),
  ('catalogo-madrid:postal_service:node-4432863914', 'Correos Madrid – Calle de Condesa Vega del Pozo', NULL, '28079', 'Calle de Condesa Vega del Pozo 29', '28032', 40.40322, -3.60597, 'address', 'openstreetmap:node/4432863914'),
  ('catalogo-madrid:postal_service:node-4433158027', 'Correos Madrid – Calle de Sierra Carbonera', NULL, '28079', 'Calle de Sierra Carbonera 75', '28053', 40.38967, -3.66537, 'address', 'openstreetmap:node/4433158027'),
  ('catalogo-madrid:postal_service:node-4433919998', 'Correos Madrid – Calle del Monte Olivetti', NULL, '28079', 'Calle del Monte Olivetti 29', '28038', 40.39777, -3.66652, 'address', 'openstreetmap:node/4433919998'),
  ('catalogo-madrid:postal_service:node-4447907880', 'Correos Madrid – Plaza de Pablo Ruiz Picasso', NULL, '28079', 'Plaza de Pablo Ruiz Picasso 1', '28020', 40.45028, -3.69282, 'address', 'openstreetmap:node/4447907880'),
  ('catalogo-madrid:postal_service:node-4447921017', 'Correos Madrid – Plaza del Movimiento Ciudadano', NULL, '28079', 'Plaza del Movimiento Ciudadano 1', '28041', 40.37054, -3.70821, 'address', 'openstreetmap:node/4447921017'),
  ('catalogo-madrid:postal_service:node-4447921018', 'Correos Madrid – Calle de Eduardo Barreiros', NULL, '28079', 'Calle de Eduardo Barreiros 5', '28041', 40.37331, -3.69528, 'address', 'openstreetmap:node/4447921018'),
  ('catalogo-madrid:postal_service:node-4457776577', 'Correos Madrid – Avenida de los Andes', NULL, '28079', 'Avenida de los Andes 50', '28042', 40.45664, -3.61819, 'address', 'openstreetmap:node/4457776577'),
  ('catalogo-madrid:postal_service:node-4457776578', 'Correos Madrid – Avenida del Partenón', NULL, '28079', 'Avenida del Partenón', '28042', 40.46943, -3.61769, 'address', 'openstreetmap:node/4457776578'),
  ('catalogo-madrid:postal_service:node-4471870144', 'Correos Madrid – Avenida de Monforte de Lemos', NULL, '28079', 'Avenida de Monforte de Lemos 36', '28029', 40.47915, -3.70853, 'address', 'openstreetmap:node/4471870144'),
  ('catalogo-madrid:postal_service:node-4585559389', 'Correos Leganés – Calle San Florentino', NULL, '28074', 'Calle San Florentino', '28917', 40.35696, -3.77784, 'address', 'openstreetmap:node/4585559389'),
  ('catalogo-madrid:postal_service:node-4654576983', 'Correos Madrid – Calle de la Sierra Gádor', NULL, '28079', 'Calle de la Sierra Gádor 50', '28031', 40.38048, -3.62365, 'address', 'openstreetmap:node/4654576983'),
  ('catalogo-madrid:postal_service:node-4696876086', 'Correos Madrid – Calle del Concejal Benito Martín Lozano 1A;1B;3', NULL, '28079', 'Calle del Concejal Benito Martín Lozano 1A;1B;3', '28005', 40.40572, -3.7109, 'address', 'openstreetmap:node/4696876086'),
  ('catalogo-madrid:postal_service:node-470878781', 'Correos Collado Villalba – Avenida de Honorio Lozano', NULL, '28047', 'Avenida de Honorio Lozano 24', '28400', 40.62906, -4.00182, 'address', 'openstreetmap:node/470878781'),
  ('catalogo-madrid:postal_service:node-4751638232', 'Correos Pozuelo de Alarcón – Calle Escalinata', NULL, '28115', 'Calle Escalinata 2', '28223', 40.43582, -3.81431, 'address', 'openstreetmap:node/4751638232'),
  ('catalogo-madrid:postal_service:node-4776641124', 'Correos Buitrago del Lozoya – Plaza de Picasso', NULL, '28027', 'Plaza de Picasso 5', '28730', 40.99333, -3.63671, 'address', 'openstreetmap:node/4776641124'),
  ('catalogo-madrid:postal_service:node-4850492224', 'Correos Leganés – Calle de La Rioja', NULL, '28074', 'Calle de La Rioja 7', '28915', 40.3329, -3.75558, 'address', 'openstreetmap:node/4850492224'),
  ('catalogo-madrid:postal_service:node-492893130', 'Correos Madrid – Calle de Turismundo', NULL, '28079', 'Calle de Turismundo 4', '28011', 40.41157, -3.73508, 'address', 'openstreetmap:node/492893130'),
  ('catalogo-madrid:postal_service:node-4953459798', 'Correos Madrid – Calle de Juan de Urbieta', NULL, '28079', 'Calle de Juan de Urbieta 37', '28007', 40.40663, -3.67591, 'address', 'openstreetmap:node/4953459798'),
  ('catalogo-madrid:postal_service:node-5254274446', 'Correos Madrid – Calle de Serrano', NULL, '28079', 'Calle de Serrano 117', '28006', 40.441, -3.68789, 'address', 'openstreetmap:node/5254274446'),
  ('catalogo-madrid:postal_service:node-5262147751', 'Correos Getafe – Travesía del Pilar', NULL, '28065', 'Travesía del Pilar 2', '28901', 40.30546, -3.72771, 'address', 'openstreetmap:node/5262147751'),
  ('catalogo-madrid:postal_service:node-5265871023', 'Correos Pinto – Calle de la Nación Dominicana', NULL, '28113', 'Calle de la Nación Dominicana 13', '28320', 40.24177, -3.69884, 'address', 'openstreetmap:node/5265871023'),
  ('catalogo-madrid:postal_service:node-5277993021', 'Correos Madrid – Calle Pegaso', NULL, '28079', 'Calle Pegaso 24', '28043', 40.46406, -3.64915, 'address', 'openstreetmap:node/5277993021'),
  ('catalogo-madrid:postal_service:node-5492013533', 'Correos Getafe – Calle de San Juan de la Cruz', NULL, '28065', 'Calle de San Juan de la Cruz', NULL, 40.32399, -3.65571, 'address', 'openstreetmap:node/5492013533'),
  ('catalogo-madrid:postal_service:node-5670402015', 'Correos Collado Mediano – Calle Real', NULL, '28046', 'Calle Real', '28450', 40.69252, -4.02677, 'address', 'openstreetmap:node/5670402015'),
  ('catalogo-madrid:postal_service:node-5851319313', 'Correos Villaviciosa de Odón – Calle del Campo', NULL, '28181', 'Calle del Campo', '28670', 40.35625, -3.90073, 'address', 'openstreetmap:node/5851319313'),
  ('catalogo-madrid:postal_service:node-6071653587', 'Correos Colmenar de Oreja – Calle de la Costanilla de los Silleros', NULL, '28043', 'Calle de la Costanilla de los Silleros', '28380', 40.10901, -3.38815, 'address', 'openstreetmap:node/6071653587'),
  ('catalogo-madrid:postal_service:node-619349015', 'Correos Ajalvir – Calle Real', NULL, '28002', 'Calle Real 44', '28864', 40.53467, -3.48328, 'address', 'openstreetmap:node/619349015'),
  ('catalogo-madrid:postal_service:node-6313090598', 'Correos Madrid – Calle de la Golondrina', NULL, '28079', 'Calle de la Golondrina 31', '28023', 40.45162, -3.78498, 'address', 'openstreetmap:node/6313090598'),
  ('catalogo-madrid:postal_service:node-6335362246', 'Correos Madrid – Avenida Central', NULL, '28079', 'Avenida Central 34', '28042', 40.45376, -3.5678, 'address', 'openstreetmap:node/6335362246'),
  ('catalogo-madrid:postal_service:node-6621513534', 'Correos Torrelodones – Calle de Manuel Pardo', NULL, '28152', 'Calle de Manuel Pardo 20', '28250', 40.57754, -3.95556, 'address', 'openstreetmap:node/6621513534'),
  ('catalogo-madrid:postal_service:node-6759002962', 'Correos Rivas-Vaciamadrid – Avenida de Pablo Iglesias', NULL, '28123', 'Avenida de Pablo Iglesias 84', '28521', 40.34512, -3.52212, 'address', 'openstreetmap:node/6759002962'),
  ('catalogo-madrid:postal_service:node-684795529', 'Correos Manzanares el Real – Calle de Morales', NULL, '28082', 'Calle de Morales', '28410', 40.72773, -3.86398, 'address', 'openstreetmap:node/684795529'),
  ('catalogo-madrid:postal_service:node-7058782391', 'Correos Nuevo Baztán – Calle Diez', NULL, '28100', 'Calle Diez', '28514', 40.35554, -3.26357, 'address', 'openstreetmap:node/7058782391'),
  ('catalogo-madrid:postal_service:node-7102356327', 'Correos Pozuelo de Alarcón – Calle de Aragón', NULL, '28115', 'Calle de Aragón 2', '28224', 40.44745, -3.80314, 'address', 'openstreetmap:node/7102356327'),
  ('catalogo-madrid:postal_service:node-7124926485', 'Correos San Sebastián de los Reyes – Calle de las Infantas', NULL, '28134', 'Calle de las Infantas 7', '28700', 40.54775, -3.63266, 'address', 'openstreetmap:node/7124926485'),
  ('catalogo-madrid:postal_service:node-746626493', 'Correos Parla – Calle Alfonso XIII', NULL, '28106', 'Calle Alfonso XIII 19', '28980', 40.23373, -3.76363, 'address', 'openstreetmap:node/746626493'),
  ('catalogo-madrid:postal_service:node-747746408', 'Correos Madrid – Calle del Mar Caspio', NULL, '28079', 'Calle del Mar Caspio 10', '28033', 40.47323, -3.64382, 'address', 'openstreetmap:node/747746408'),
  ('catalogo-madrid:postal_service:node-7695111358', 'Correos Madrid – Calle Arquitecto López Otero', NULL, '28079', 'Calle Arquitecto López Otero 3', '28040', 40.44378, -3.72863, 'address', 'openstreetmap:node/7695111358'),
  ('catalogo-madrid:postal_service:node-848297823', 'Correos Fuenlabrada – Avenida de España', NULL, '28058', 'Avenida de España 9', '28941', 40.29257, -3.80125, 'address', 'openstreetmap:node/848297823'),
  ('catalogo-madrid:postal_service:node-8503430923', 'Correos Guadalix de la Sierra – Calle Rinconcillo', NULL, '28067', 'Calle Rinconcillo', NULL, 40.78596, -3.70018, 'address', 'openstreetmap:node/8503430923'),
  ('catalogo-madrid:postal_service:node-8557831647', 'Correos Los Molinos – Calle Real', NULL, '28087', 'Calle Real', '28460', 40.7148, -4.07279, 'address', 'openstreetmap:node/8557831647'),
  ('catalogo-madrid:postal_service:node-937691832', 'Correos Madrid – Calle de Martín de los Heros', NULL, '28079', 'Calle de Martín de los Heros 57', '28008', 40.42826, -3.71696, 'address', 'openstreetmap:node/937691832'),
  ('catalogo-madrid:postal_service:node-9574094496', 'Correos Colmenar Viejo – Calle Huerta del Convento', NULL, '28045', 'Calle Huerta del Convento 18', '28770', 40.66132, -3.76548, 'address', 'openstreetmap:node/9574094496'),
  ('catalogo-madrid:postal_service:node-9576310993', 'Correos Madrid – Calle Viloria de la Rioja', NULL, '28079', 'Calle Viloria de la Rioja 46', '28050', 40.50727, -3.67417, 'address', 'openstreetmap:node/9576310993'),
  ('catalogo-madrid:postal_service:node-958170265', 'Correos Madrid – Calle de Alburquerque', NULL, '28079', 'Calle de Alburquerque 2', '28010', 40.43106, -3.70291, 'address', 'openstreetmap:node/958170265'),
  ('catalogo-madrid:postal_service:node-9899164120', 'Correos Torrejón de la Calzada – Calle 12 de Octubre', NULL, '28149', 'Calle 12 de Octubre', NULL, 40.19986, -3.79764, 'address', 'openstreetmap:node/9899164120'),
  ('catalogo-madrid:postal_service:node-993186568', 'Correos Madrid – Avenida de América', NULL, '28079', 'Avenida de América 3', '28002', 40.43797, -3.67735, 'address', 'openstreetmap:node/993186568'),
  ('catalogo-madrid:postal_service:node-993186604', 'Correos Madrid – Calle de Luis Vives', NULL, '28079', 'Calle de Luis Vives 12', '28002', 40.44419, -3.67591, 'address', 'openstreetmap:node/993186604'),
  ('catalogo-madrid:postal_service:way-1119858862', 'Correos Alcorcón – Calle París', NULL, '28007', 'Calle París', NULL, 40.3457, -3.85419, 'address', 'openstreetmap:way/1119858862'),
  ('catalogo-madrid:postal_service:way-1124510660', 'Correos Bustarviejo – Calle Real', NULL, '28028', 'Calle Real 85', '28720', 40.85923, -3.70641, 'address', 'openstreetmap:way/1124510660'),
  ('catalogo-madrid:postal_service:way-187742196', 'Correos Torrelodones – Calle de Los Ángeles', NULL, '28152', 'Calle de Los Ángeles 4', '28250', 40.57754, -3.9297, 'address', 'openstreetmap:way/187742196'),
  ('catalogo-madrid:postal_service:way-202094341', 'Correos Madrid – Calle de la Hiedra', NULL, '28079', 'Calle de la Hiedra 7', '28036', 40.47672, -3.67842, 'address', 'openstreetmap:way/202094341'),
  ('catalogo-madrid:postal_service:way-241239230', 'Correos Leganés – Gran Bretaña 36,34,32', NULL, '28074', 'Gran Bretaña 36,34,32', NULL, 40.34037, -3.74064, 'address', 'openstreetmap:way/241239230'),
  ('catalogo-madrid:postal_service:way-266315937', 'Correos Rivas-Vaciamadrid – Calle del Electrodo', NULL, '28123', 'Calle del Electrodo 3', '28522', 40.35469, -3.54669, 'address', 'openstreetmap:way/266315937'),
  ('catalogo-madrid:postal_service:way-296767747', 'Correos Alcalá de Henares – Plaza de Cervantes', NULL, '28005', 'Plaza de Cervantes', '28801', 40.48301, -3.36379, 'address', 'openstreetmap:way/296767747'),
  ('catalogo-madrid:postal_service:way-299232359', 'Correos Alcobendas – Calle de Valportillo Primera', NULL, '28006', 'Calle de Valportillo Primera 7', '28108', 40.53084, -3.65455, 'address', 'openstreetmap:way/299232359'),
  ('catalogo-madrid:postal_service:way-308191053', 'Correos Cercedilla – Calle de la Marquesa Casa López', NULL, '28038', 'Calle de la Marquesa Casa López 17', '28470', 40.73879, -4.05899, 'address', 'openstreetmap:way/308191053'),
  ('catalogo-madrid:postal_service:way-458148792', 'Correos Aranjuez – Calle de Peñarredonda', NULL, '28013', 'Calle de Peñarredonda 3', '28300', 40.03393, -3.60131, 'address', 'openstreetmap:way/458148792'),
  ('catalogo-madrid:postal_service:way-467538028', 'Correos Navalagamella – Calle la Cuesta', NULL, '28095', 'Calle la Cuesta 4', '28212', 40.46891, -4.12384, 'address', 'openstreetmap:way/467538028'),
  ('catalogo-madrid:postal_service:way-477281049', 'Correos Torres de la Alameda – Calle Mayor', NULL, '28154', 'Calle Mayor', '28813', 40.40445, -3.36045, 'address', 'openstreetmap:way/477281049'),
  ('catalogo-madrid:postal_service:way-733208844', 'Correos Cobeña – Avenida Guadalajara', NULL, '28041', 'Avenida Guadalajara 20', '28863', 40.56698, -3.50224, 'address', 'openstreetmap:way/733208844'),
  ('catalogo-madrid:postal_service:way-963354310', 'Correos Madrid – Avenida de Valladolid', NULL, '28079', 'Avenida de Valladolid 39', '28008', 40.42827, -3.72941, 'address', 'openstreetmap:way/963354310');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '28');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 28 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '28'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 190 THEN
    RAISE EXCEPTION 'Se esperaban 190 puntos de Correos en Madrid, hay %', n;
  END IF;
END;
$$;

COMMIT;
