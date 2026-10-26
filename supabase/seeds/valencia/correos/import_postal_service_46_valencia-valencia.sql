-- Carga de la categoría Correos de Valencia/València (provincia 46), trozo de la carga de Andalucía.
-- Origen: postal_service-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 95 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-valencia:postal_service:node-1050408533', 'Correos Montcada / Moncada – Carrer del Regne de València', NULL, '46171', 'Carrer del Regne de València', '46113', 39.54407, -0.39444, 'address', 'openstreetmap:node/1050408533'),
  ('catalogo-valencia:postal_service:node-109980314', 'Correos València – Carrer de Nicolau Primitiu Gómez Serrano', NULL, '46250', 'Carrer de Nicolau Primitiu Gómez Serrano 13', '46014', 39.45636, -0.40336, 'address', 'openstreetmap:node/109980314'),
  ('catalogo-valencia:postal_service:node-11362988992', 'Correos València – Avinguda del Cid', NULL, '46250', 'Avinguda del Cid 22', '46018', 39.46785, -0.39369, 'address', 'openstreetmap:node/11362988992'),
  ('catalogo-valencia:postal_service:node-11568881903', 'Correos València – Calle marina alta', NULL, '46250', 'Calle marina alta 6', '46015', 39.49302, -0.40326, 'address', 'openstreetmap:node/11568881903'),
  ('catalogo-valencia:postal_service:node-1171045337', 'Correos Albal – Carrer de Lluís Arnau', NULL, '46007', 'Carrer de Lluís Arnau 46', '46470', 39.3988, -0.40728, 'address', 'openstreetmap:node/1171045337'),
  ('catalogo-valencia:postal_service:node-11748690203', 'Correos Picanya – Avinguda de Santa Maria del Puig', NULL, '46193', 'Avinguda de Santa Maria del Puig 9', '46210', 39.43361, -0.43342, 'address', 'openstreetmap:node/11748690203'),
  ('catalogo-valencia:postal_service:node-12125537891', 'Correos Manuel – Carrer Joan Moreno', NULL, '46160', 'Carrer Joan Moreno', '46660', 39.05034, -0.49362, 'address', 'openstreetmap:node/12125537891'),
  ('catalogo-valencia:postal_service:node-12128356012', 'Correos Benifaió – Carrer de Santa Bàrbara', NULL, '46060', 'Carrer de Santa Bàrbara 23', '46450', 39.28344, -0.42494, 'address', 'openstreetmap:node/12128356012'),
  ('catalogo-valencia:postal_service:node-12265700527', 'Correos València – Avinguda de la Constitució', NULL, '46250', 'Avinguda de la Constitució 111', '46009', 39.49025, -0.37542, 'address', 'openstreetmap:node/12265700527'),
  ('catalogo-valencia:postal_service:node-12548987429', 'Correos Benetússer – Carrer del 9 d’Octubre', NULL, '46054', 'Carrer del 9 d’Octubre 16', '46910', 39.42397, -0.39362, 'address', 'openstreetmap:node/12548987429'),
  ('catalogo-valencia:postal_service:node-12736403050', 'Correos Bétera – Carrer de José Gascón Sirera', NULL, '46070', 'Carrer de José Gascón Sirera 81', '46117', 39.59045, -0.45814, 'address', 'openstreetmap:node/12736403050'),
  ('catalogo-valencia:postal_service:node-13100406112', 'Correos València – 24', NULL, '46250', '24', '46002', 39.46946, -0.37551, 'address', 'openstreetmap:node/13100406112'),
  ('catalogo-valencia:postal_service:node-13204505656', 'Correos Benimodo – Avinguda d''Antoni Almela', NULL, '46063', 'Avinguda d''Antoni Almela 51', '46250', 39.21292, -0.52856, 'address', 'openstreetmap:node/13204505656'),
  ('catalogo-valencia:postal_service:node-1328433771', 'Correos Paterna – Carrer de Vicent Cardona', NULL, '46190', 'Carrer de Vicent Cardona', NULL, 39.50033, -0.44168, 'address', 'openstreetmap:node/1328433771'),
  ('catalogo-valencia:postal_service:node-13311877052', 'Correos Mislata – Avinguda del Sud', NULL, '46169', 'Avinguda del Sud', '46920', 39.47154, -0.41927, 'address', 'openstreetmap:node/13311877052'),
  ('catalogo-valencia:postal_service:node-13333794296', 'Correos Catarroja – Avinguda de Ramón y Cajal', NULL, '46094', 'Avinguda de Ramón y Cajal 54', '46470', 39.40589, -0.4021, 'address', 'openstreetmap:node/13333794296'),
  ('catalogo-valencia:postal_service:node-13977715142', 'Correos València – Carrer de Jerónima Galés (Impressora)', NULL, '46250', 'Carrer de Jerónima Galés (Impressora) 20', '46017', 39.45406, -0.38994, 'address', 'openstreetmap:node/13977715142'),
  ('catalogo-valencia:postal_service:node-14056742002', 'Correos València – Carrer dels Sornells', NULL, '46250', 'Carrer dels Sornells 12', '46006', 39.46102, -0.37128, 'address', 'openstreetmap:node/14056742002'),
  ('catalogo-valencia:postal_service:node-1407516864', 'Correos Requena – Calle Collado', NULL, '46213', 'Calle Collado 1', '46340', 39.48896, -1.1059, 'address', 'openstreetmap:node/1407516864'),
  ('catalogo-valencia:postal_service:node-1598872275', 'Correos Alaquàs – Calle de Antonia María de Oviedo', NULL, '46005', 'Calle de Antonia María de Oviedo 11', '46970', 39.45565, -0.46159, 'address', 'openstreetmap:node/1598872275'),
  ('catalogo-valencia:postal_service:node-1676339784', 'Correos l''Alqueria de la Comtessa – Carrer Sant Jaume', NULL, '46037', 'Carrer Sant Jaume 72', NULL, 38.93577, -0.15705, 'address', 'openstreetmap:node/1676339784'),
  ('catalogo-valencia:postal_service:node-1697827203', 'Correos Tavernes de la Valldigna – Passeig de Lepant', NULL, '46238', 'Passeig de Lepant 1', '46760', 39.06979, -0.26584, 'address', 'openstreetmap:node/1697827203'),
  ('catalogo-valencia:postal_service:node-1708398162', 'Correos València – Carrer de Luis Bolinches Compañ', NULL, '46250', 'Carrer de Luis Bolinches Compañ', '46023', 39.45738, -0.34664, 'address', 'openstreetmap:node/1708398162'),
  ('catalogo-valencia:postal_service:node-1720778986', 'Correos Montserrat – Carrer Bon Aire', NULL, '46172', 'Carrer Bon Aire', '46192', 39.35793, -0.59889, 'address', 'openstreetmap:node/1720778986'),
  ('catalogo-valencia:postal_service:node-1765435278', 'Correos Polinyà de Xúquer – Plaça de l''Ajuntament', NULL, '46197', 'Plaça de l''Ajuntament 1', '46688', 39.19584, -0.36953, 'address', 'openstreetmap:node/1765435278'),
  ('catalogo-valencia:postal_service:node-1792880818', 'Correos València – Avinguda del Primat Reig', NULL, '46250', 'Avinguda del Primat Reig 129', '46020', 39.4839, -0.36261, 'address', 'openstreetmap:node/1792880818'),
  ('catalogo-valencia:postal_service:node-1822959242', 'Correos Burjassot – Calle Blasco Ibáñez', NULL, '46078', 'Calle Blasco Ibáñez 88', '46100', 39.50893, -0.40985, 'address', 'openstreetmap:node/1822959242'),
  ('catalogo-valencia:postal_service:node-1825673718', 'Correos Torrent – Avinguda Al Vedat', NULL, '46244', 'Avinguda Al Vedat 60', '46900', 39.4339, -0.47012, 'address', 'openstreetmap:node/1825673718'),
  ('catalogo-valencia:postal_service:node-1825686662', 'Correos Torrent – Carrer del Mestre Sanchis Almiñano', NULL, '46244', 'Carrer del Mestre Sanchis Almiñano 5', '46900', 39.42983, -0.47496, 'address', 'openstreetmap:node/1825686662'),
  ('catalogo-valencia:postal_service:node-1904815828', 'Correos Alboraia / Alboraya – Plaça del Carme', NULL, '46013', 'Plaça del Carme', '46120', 39.49872, -0.3491, 'address', 'openstreetmap:node/1904815828'),
  ('catalogo-valencia:postal_service:node-2103296067', 'Correos Benifairó de les Valls – Plaça del Ajuntament', NULL, '46058', 'Plaça del Ajuntament', NULL, 39.7267, -0.26969, 'address', 'openstreetmap:node/2103296067'),
  ('catalogo-valencia:postal_service:node-2303307793', 'Correos Carcaixent – Carrer del Passeig', NULL, '46083', 'Carrer del Passeig 36', '46740', 39.11814, -0.44876, 'address', 'openstreetmap:node/2303307793'),
  ('catalogo-valencia:postal_service:node-2339674953', 'Correos Paterna – Carrer 13', NULL, '46190', 'Carrer 13 5', '46182', 39.52722, -0.48823, 'address', 'openstreetmap:node/2339674953'),
  ('catalogo-valencia:postal_service:node-2339674974', 'Correos Paterna – Carrer de Gijón', NULL, '46190', 'Carrer de Gijón', NULL, 39.51406, -0.46056, 'address', 'openstreetmap:node/2339674974'),
  ('catalogo-valencia:postal_service:node-2357217279', 'Correos Sot de Chera – Calle de Valencia', NULL, '46234', 'Calle de Valencia 15', NULL, 39.6213, -0.91073, 'address', 'openstreetmap:node/2357217279'),
  ('catalogo-valencia:postal_service:node-2395094378', 'Correos Gandia – Carrer Sant Rafel', NULL, '46131', 'Carrer Sant Rafel 21', '46700', 38.96756, -0.18387, 'address', 'openstreetmap:node/2395094378'),
  ('catalogo-valencia:postal_service:node-2395170721', 'Correos Xeraco – Carrer Pintor Sorolla', NULL, '46143', 'Carrer Pintor Sorolla 23', '46770', 39.03282, -0.21845, 'address', 'openstreetmap:node/2395170721'),
  ('catalogo-valencia:postal_service:node-2874315865', 'Correos San Antonio de Benagéber – Plaza de la Diputación', NULL, '46903', 'Plaza de la Diputación', '46184', 39.5613, -0.49983, 'address', 'openstreetmap:node/2874315865'),
  ('catalogo-valencia:postal_service:node-3206364451', 'Correos Alzira – Avinguda de los Santos Patronos', NULL, '46017', 'Avinguda de los Santos Patronos 20', '46600', 39.15156, -0.43768, 'address', 'openstreetmap:node/3206364451'),
  ('catalogo-valencia:postal_service:node-3683411595', 'Correos Massalfassar – Carrer Mariano Benlliure', NULL, '46163', 'Carrer Mariano Benlliure', '46560', 39.5584, -0.32828, 'address', 'openstreetmap:node/3683411595'),
  ('catalogo-valencia:postal_service:node-3762006563', 'Correos Losa del Obispo – Av. Serrania, Losa del Obispo', NULL, '46149', 'Av. Serrania, Losa del Obispo 8', NULL, 39.69702, -0.87128, 'address', 'openstreetmap:node/3762006563'),
  ('catalogo-valencia:postal_service:node-4015061393', 'Correos Oliva – Carrer de Gabriel Miró', NULL, '46181', 'Carrer de Gabriel Miró', '46780', 38.92113, -0.11584, 'address', 'openstreetmap:node/4015061393'),
  ('catalogo-valencia:postal_service:node-4027627766', 'Correos Sagunt / Sagunto – Avinguda del Camp de Morvedre', NULL, '46220', 'Avinguda del Camp de Morvedre', NULL, 39.66298, -0.22237, 'address', 'openstreetmap:node/4027627766'),
  ('catalogo-valencia:postal_service:node-430085151', 'Correos Aldaia – Carrer Major', NULL, '46021', 'Carrer Major 90', '46960', 39.46539, -0.46634, 'address', 'openstreetmap:node/430085151'),
  ('catalogo-valencia:postal_service:node-4311700037', 'Correos l''Eliana – Calle Molino', NULL, '46116', 'Calle Molino', '46183', 39.56632, -0.53151, 'address', 'openstreetmap:node/4311700037'),
  ('catalogo-valencia:postal_service:node-4383019589', 'Correos València – Carrer del Poeta Mas i Ros', NULL, '46250', 'Carrer del Poeta Mas i Ros 20', '46021', 39.47078, -0.34978, 'address', 'openstreetmap:node/4383019589'),
  ('catalogo-valencia:postal_service:node-4385851722', 'Correos València – Avinguda d''Ausiàs March', NULL, '46250', 'Avinguda d''Ausiàs March 52', '46013', 39.45135, -0.37226, 'address', 'openstreetmap:node/4385851722'),
  ('catalogo-valencia:postal_service:node-4396052433', 'Correos València – Carrer d''Antonio Sacramento (Escultor)', NULL, '46250', 'Carrer d''Antonio Sacramento (Escultor) 7', '46013', 39.4537, -0.3587, 'address', 'openstreetmap:node/4396052433'),
  ('catalogo-valencia:postal_service:node-4405518171', 'Correos Albaida – Avinguda de la Fira', NULL, '46006', 'Avinguda de la Fira 8', '46860', 38.83829, -0.51867, 'address', 'openstreetmap:node/4405518171'),
  ('catalogo-valencia:postal_service:node-4799478231', 'Correos Cullera – Avinguda Blasco Ibañez', NULL, '46105', 'Avinguda Blasco Ibañez 5', '46400', 39.16494, -0.24322, 'address', 'openstreetmap:node/4799478231'),
  ('catalogo-valencia:postal_service:node-5026968707', 'Correos València – Carrer del Doctor JJ Dòmine', NULL, '46250', 'Carrer del Doctor JJ Dòmine 13', '46011', 39.46203, -0.33144, 'address', 'openstreetmap:node/5026968707'),
  ('catalogo-valencia:postal_service:node-5097791126', 'Correos Algemesí – Carrer de Santa Ana', NULL, '46029', 'Carrer de Santa Ana 6', '46680', 39.19257, -0.43131, 'address', 'openstreetmap:node/5097791126'),
  ('catalogo-valencia:postal_service:node-5104299824', 'Correos Benaguasil – Carrer del Castell', NULL, '46051', 'Carrer del Castell 4', '46180', 39.59414, -0.58507, 'address', 'openstreetmap:node/5104299824'),
  ('catalogo-valencia:postal_service:node-5268218393', 'Correos Silla – Carrer de Sant Roc', NULL, '46230', 'Carrer de Sant Roc', NULL, 39.35779, -0.40976, 'address', 'openstreetmap:node/5268218393'),
  ('catalogo-valencia:postal_service:node-5322911214', 'Correos Almàssera – Carretera de Barcelona', NULL, '46032', 'Carretera de Barcelona', '46132', 39.51591, -0.36168, 'address', 'openstreetmap:node/5322911214'),
  ('catalogo-valencia:postal_service:node-5522801471', 'Correos la Pobla de Vallbona – Avinguda de Don José Garrido Farga', NULL, '46202', 'Avinguda de Don José Garrido Farga', '46185', 39.59263, -0.55461, 'address', 'openstreetmap:node/5522801471'),
  ('catalogo-valencia:postal_service:node-5524738952', 'Correos Llíria – Carrer de Sant Vicent de Paul', NULL, '46147', 'Carrer de Sant Vicent de Paul', '46160', 39.62711, -0.5964, 'address', 'openstreetmap:node/5524738952'),
  ('catalogo-valencia:postal_service:node-5551958324', 'Correos Daimús – Carrer Sant Pere', NULL, '46113', 'Carrer Sant Pere', '46710', 38.96999, -0.15372, 'address', 'openstreetmap:node/5551958324'),
  ('catalogo-valencia:postal_service:node-5659361261', 'Correos Buñol – Calle del Valle de Andorra', NULL, '46077', 'Calle del Valle de Andorra 3', '46360', 39.41686, -0.78941, 'address', 'openstreetmap:node/5659361261'),
  ('catalogo-valencia:postal_service:node-5659376624', 'Correos Yátova – Calle Burriel', NULL, '46261', 'Calle Burriel', NULL, 39.38529, -0.80597, 'address', 'openstreetmap:node/5659376624'),
  ('catalogo-valencia:postal_service:node-5659400299', 'Correos Chiva – Calle de Blasco Ibáñez', NULL, '46111', 'Calle de Blasco Ibáñez', '46370', 39.47217, -0.71457, 'address', 'openstreetmap:node/5659400299'),
  ('catalogo-valencia:postal_service:node-5659401819', 'Correos Cheste – Calle de Ángel Tarín Haro', NULL, '46109', 'Calle de Ángel Tarín Haro 2', '46380', 39.49413, -0.68015, 'address', 'openstreetmap:node/5659401819'),
  ('catalogo-valencia:postal_service:node-5659405999', 'Correos Riba-roja de Túria – Carrer del Cronista Cerveró', NULL, '46214', 'Carrer del Cronista Cerveró 1', '46190', 39.54499, -0.57342, 'address', 'openstreetmap:node/5659405999'),
  ('catalogo-valencia:postal_service:node-5659448040', 'Correos Vilamarxant – Carrer de Sant Miquel', NULL, '46256', 'Carrer de Sant Miquel', '46191', 39.56811, -0.62572, 'address', 'openstreetmap:node/5659448040'),
  ('catalogo-valencia:postal_service:node-5659451923', 'Correos Pedralba – Calle del Obispo Cervera', NULL, '46191', 'Calle del Obispo Cervera', '46164', 39.60516, -0.72757, 'address', 'openstreetmap:node/5659451923'),
  ('catalogo-valencia:postal_service:node-5659455625', 'Correos Villar del Arzobispo – Calle de Posadas', NULL, '46258', 'Calle de Posadas', NULL, 39.73252, -0.82278, 'address', 'openstreetmap:node/5659455625'),
  ('catalogo-valencia:postal_service:node-5659469768', 'Correos Utiel – Calle Beato Gálvez', NULL, '46249', 'Calle Beato Gálvez 2', '46300', 39.56711, -1.20509, 'address', 'openstreetmap:node/5659469768'),
  ('catalogo-valencia:postal_service:node-5794466683', 'Correos Ontinyent – Avenida Daniel Gil 17-19', NULL, '46184', 'Avenida Daniel Gil 17-19', '46870', 38.82488, -0.60192, 'address', 'openstreetmap:node/5794466683'),
  ('catalogo-valencia:postal_service:node-5820199002', 'Correos València – Carrer del Doctor Lluch', NULL, '46250', 'Carrer del Doctor Lluch 251', '46011', 39.47247, -0.32774, 'address', 'openstreetmap:node/5820199002'),
  ('catalogo-valencia:postal_service:node-6173645139', 'Correos Piles – Carrer Moreres', NULL, '46195', 'Carrer Moreres', NULL, 38.93968, -0.13279, 'address', 'openstreetmap:node/6173645139'),
  ('catalogo-valencia:postal_service:node-6465141787', 'Correos València – Joaquín Costa', NULL, '46250', 'Joaquín Costa 39', '46005', 39.4649, -0.36614, 'address', 'openstreetmap:node/6465141787'),
  ('catalogo-valencia:postal_service:node-6653328414', 'Correos Enguera – Calle Doctor Albiñana', NULL, '46118', 'Calle Doctor Albiñana 34', '46810', 38.97972, -0.6869, 'address', 'openstreetmap:node/6653328414'),
  ('catalogo-valencia:postal_service:node-6752848730', 'Correos Barx – Calle de Gandia', NULL, '46046', 'Calle de Gandia 53', '46758', 39.01259, -0.30104, 'address', 'openstreetmap:node/6752848730'),
  ('catalogo-valencia:postal_service:node-6772703146', 'Correos l''Alcúdia – Avinguda d''Antoni Almela', NULL, '46019', 'Avinguda d''Antoni Almela 51', '46250', 39.19621, -0.50283, 'address', 'openstreetmap:node/6772703146'),
  ('catalogo-valencia:postal_service:node-7233653451', 'Correos Bocairent – Sor Piedad de la Cruz', NULL, '46072', 'Sor Piedad de la Cruz 3', '46880', 38.76595, -0.60991, 'address', 'openstreetmap:node/7233653451'),
  ('catalogo-valencia:postal_service:node-7638255687', 'Correos Alcàsser – Carrer de Vicent López', NULL, '46015', 'Carrer de Vicent López', NULL, 39.36961, -0.44027, 'address', 'openstreetmap:node/7638255687'),
  ('catalogo-valencia:postal_service:node-7688131566', 'Correos Rafelbunyol – Carrer Trencat', NULL, '46207', 'Carrer Trencat 6', '46138', 39.58885, -0.3332, 'address', 'openstreetmap:node/7688131566'),
  ('catalogo-valencia:postal_service:node-7792947443', 'Correos Gandia – Carrer Sant Tomas de Villanueva', NULL, '46131', 'Carrer Sant Tomas de Villanueva 4', '46701', 38.97019, -0.17774, 'address', 'openstreetmap:node/7792947443'),
  ('catalogo-valencia:postal_service:node-7899984831', 'Correos Massamagrell – Avinguda de la Mare de Déu del Rosari', NULL, '46164', 'Avinguda de la Mare de Déu del Rosari 13', '46130', 39.56869, -0.33483, 'address', 'openstreetmap:node/7899984831'),
  ('catalogo-valencia:postal_service:node-8295053643', 'Correos Vinalesa – Carrer Major', NULL, '46260', 'Carrer Major 51', '46114', 39.53876, -0.36996, 'address', 'openstreetmap:node/8295053643'),
  ('catalogo-valencia:postal_service:node-8939509247', 'Correos Moixent / Mogente – 4', NULL, '46170', '4', '46640', 38.87449, -0.75247, 'address', 'openstreetmap:node/8939509247'),
  ('catalogo-valencia:postal_service:node-9110798447', 'Correos Corbera – Avinguda Ribera Baixa', NULL, '46098', 'Avinguda Ribera Baixa 32', '46612', 39.15879, -0.35422, 'address', 'openstreetmap:node/9110798447'),
  ('catalogo-valencia:postal_service:node-9766087693', 'Correos la Pobla de Farnals – Avinguda de l''Estatut d''Autonomia', NULL, '46199', 'Avinguda de l''Estatut d''Autonomia 5', '46139', 39.57847, -0.3247, 'address', 'openstreetmap:node/9766087693'),
  ('catalogo-valencia:postal_service:node-9868014940', 'Correos Faura – Carrer de Miguel de Cervantes', NULL, '46122', 'Carrer de Miguel de Cervantes', NULL, 39.72487, -0.26677, 'address', 'openstreetmap:node/9868014940'),
  ('catalogo-valencia:postal_service:node-9971966234', 'Correos Rocafort – Avinguda d''Ausiàs March', NULL, '46216', 'Avinguda d''Ausiàs March 14', '46111', 39.52907, -0.41266, 'address', 'openstreetmap:node/9971966234'),
  ('catalogo-valencia:postal_service:node-9986987626', 'Correos Llaurí – Plaça de la Llibertat', NULL, '46155', 'Plaça de la Llibertat 5', '46613', 39.14685, -0.33045, 'address', 'openstreetmap:node/9986987626'),
  ('catalogo-valencia:postal_service:relation-5383621', 'Correos Sagunt / Sagunto – Plaça del Cronista Chabret', NULL, '46220', 'Plaça del Cronista Chabret', '46500', 39.68122, -0.27852, 'address', 'openstreetmap:relation/5383621'),
  ('catalogo-valencia:postal_service:way-1013534468', 'Correos Sueca – Carrer del Pintor Claros', NULL, '46235', 'Carrer del Pintor Claros 1', '46410', 39.20065, -0.30684, 'address', 'openstreetmap:way/1013534468'),
  ('catalogo-valencia:postal_service:way-1157738097', 'Correos Alcàntera de Xúquer – Carrer Ausiàs March', NULL, '46016', 'Carrer Ausiàs March 2', NULL, 39.06934, -0.56018, 'address', 'openstreetmap:way/1157738097'),
  ('catalogo-valencia:postal_service:way-1318091465', 'Correos el Puig de Santa Maria – Carrer Ordre de la Mercé', NULL, '46204', 'Carrer Ordre de la Mercé', NULL, 39.58813, -0.29965, 'address', 'openstreetmap:way/1318091465'),
  ('catalogo-valencia:postal_service:way-297866889', 'Correos València – Carrer de Sant Vicent Màrtir', NULL, '46250', 'Carrer de Sant Vicent Màrtir 167', '46007', 39.45886, -0.38291, 'address', 'openstreetmap:way/297866889'),
  ('catalogo-valencia:postal_service:way-439755399', 'Correos Cullera – Plaça de Sant Isidre', NULL, '46105', 'Plaça de Sant Isidre 1', '46400', 39.16332, -0.25668, 'address', 'openstreetmap:way/439755399'),
  ('catalogo-valencia:postal_service:way-553005867', 'Correos Turís – Avinguda de Blasco Ibáñez', NULL, '46248', 'Avinguda de Blasco Ibáñez', '46389', 39.39044, -0.7124, 'address', 'openstreetmap:way/553005867'),
  ('catalogo-valencia:postal_service:way-784183234', 'Correos Xàtiva – Albereda de Jaume I', NULL, '46145', 'Albereda de Jaume I 46', '46800', 38.99025, -0.52129, 'address', 'openstreetmap:way/784183234'),
  ('catalogo-valencia:postal_service:way-986637530', 'Correos Ademuz – Calle San Vicente', NULL, '46001', 'Calle San Vicente 36', '46140', 40.06057, -1.28589, 'address', 'openstreetmap:way/986637530');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '46');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 46 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '46'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 95 THEN
    RAISE EXCEPTION 'Se esperaban 95 puntos de Correos en Valencia/València, hay %', n;
  END IF;
END;
$$;

COMMIT;
