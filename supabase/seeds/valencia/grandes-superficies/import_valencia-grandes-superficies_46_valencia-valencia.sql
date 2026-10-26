-- Carga de la categoría (varias) de Valencia/València (provincia 46), trozo de la carga de Andalucía.
-- Origen: valencia-grandes-superficies-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 77 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10257592365', 'Carrefour Gandia – Avinguda Blasco Ibáñez', NULL, '46131', 'Avinguda Blasco Ibáñez', '46701', 38.97034, -0.17032, 'address', 'openstreetmap:node/10257592365'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10686423243', 'Carrefour Cullera – Camí dels Magranerets', NULL, '46105', 'Camí dels Magranerets', NULL, 39.17921, -0.26069, 'address', 'openstreetmap:node/10686423243'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10782285836', 'Carrefour València – Carrer del Músic Peydró', NULL, '46250', 'Carrer del Músic Peydró 13', '46001', 39.47193, -0.37815, 'address', 'openstreetmap:node/10782285836'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-11328320508', 'Carrefour València – Avinguda de França', NULL, '46250', 'Avinguda de França 19', '46023', 39.46028, -0.35075, 'address', 'openstreetmap:node/11328320508'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-12063874987', 'Carrefour València – Avinguda del Regne de València', NULL, '46250', 'Avinguda del Regne de València 80', '46005', 39.46269, -0.36382, 'address', 'openstreetmap:node/12063874987'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-12770792984', 'Carrefour València – Avinguda d''Amado Granell Mesado (Militar)', NULL, '46250', 'Avinguda d''Amado Granell Mesado (Militar) 65', '46013', 39.45453, -0.36016, 'address', 'openstreetmap:node/12770792984'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-12853912123', 'Carrefour València – Carrer de l''Abadia de Sant Martí', NULL, '46250', 'Carrer de l''Abadia de Sant Martí 10', '46002', 39.47304, -0.37519, 'address', 'openstreetmap:node/12853912123'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-13179003764', 'Carrefour València – Carrer de l''Illa Formentera', NULL, '46250', 'Carrer de l''Illa Formentera 56', '46026', 39.44662, -0.37434, 'address', 'openstreetmap:node/13179003764'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-13372837226', 'Carrefour Sagunt / Sagunto', NULL, '46220', NULL, '46520', 39.67431, -0.24922, 'address', 'openstreetmap:node/13372837226'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-13720483501', 'Carrefour València – Avinguda d''Antonio Ferrandis (Actor)', NULL, '46250', 'Avinguda d''Antonio Ferrandis (Actor) 16', '46013', 39.44953, -0.36197, 'address', 'openstreetmap:node/13720483501'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-13846886716', 'Carrefour València – Carrer del Baladre', NULL, '46250', 'Carrer del Baladre 3', '46018', 39.47413, -0.39726, 'address', 'openstreetmap:node/13846886716'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-14024800102', 'Carrefour València – Gran Via de les Germanies', NULL, '46250', 'Gran Via de les Germanies 33', '46006', 39.46366, -0.37607, 'address', 'openstreetmap:node/14024800102'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-14209849571', 'Carrefour València – Plaça del Doctor Collado', NULL, '46250', 'Plaça del Doctor Collado 4', '46001', 39.4744, -0.378, 'address', 'openstreetmap:node/14209849571'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-1563550248', 'Carrefour València – Carrer d''Hernández Lázaro', NULL, '46250', 'Carrer d''Hernández Lázaro', '46015', 39.47714, -0.40473, 'address', 'openstreetmap:node/1563550248'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-1933038729', 'Carrefour l''Eliana – Carrer de Tuéjar', NULL, '46116', 'Carrer de Tuéjar', '46183', 39.57744, -0.52856, 'address', 'openstreetmap:node/1933038729'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:node-2189620264', 'Leroy Merlin Burjassot – Avenida de la Ilustración', NULL, '46078', 'Avenida de la Ilustración 6', '46100', 39.49967, -0.40868, 'address', 'openstreetmap:node/2189620264'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-2506490495', 'Carrefour València – Carrer del Doctor Manuel Candela', NULL, '46250', 'Carrer del Doctor Manuel Candela 56', '46021', 39.47073, -0.34892, 'address', 'openstreetmap:node/2506490495'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:node-3657800645', 'MediaMarkt València – Carrer de Colón', NULL, '46250', 'Carrer de Colón 4', '46004', 39.46724, -0.37445, 'address', 'openstreetmap:node/3657800645'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-3658278547', 'Carrefour València – Carrer de Russafa', NULL, '46250', 'Carrer de Russafa 50', '46006', 39.46382, -0.37287, 'address', 'openstreetmap:node/3658278547'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-3759076807', 'Carrefour València – Gran Via de Ferran el Catòlic', NULL, '46250', 'Gran Via de Ferran el Catòlic 22', '46008', 39.47121, -0.38509, 'address', 'openstreetmap:node/3759076807'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-3957283072', 'Carrefour València – Avinguda de Blasco Ibáñez', NULL, '46250', 'Avinguda de Blasco Ibáñez 153', '46022', 39.47182, -0.33884, 'address', 'openstreetmap:node/3957283072'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:node-4002633468', 'MediaMarkt Gandia – Avinguda de Blasco Ibáñez', NULL, '46131', 'Avinguda de Blasco Ibáñez 6', '46701', 38.9725, -0.17081, 'address', 'openstreetmap:node/4002633468'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-4023371093', 'Carrefour Sagunt / Sagunto – Carrer de l''Illa de Menorca', NULL, '46220', 'Carrer de l''Illa de Menorca', '46520', 39.66448, -0.21046, 'address', 'openstreetmap:node/4023371093'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-4601469192', 'Carrefour València – Avinguda del Cardenal Benlloch', NULL, '46250', 'Avinguda del Cardenal Benlloch 19', '46021', 39.46821, -0.3562, 'address', 'openstreetmap:node/4601469192'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:node-4917673721', 'Decathlon València – Avinguda de Tirso de Molina', NULL, '46250', 'Avinguda de Tirso de Molina 16', '46015', 39.47742, -0.39528, 'address', 'openstreetmap:node/4917673721'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-4989867672', 'Carrefour València – Avinguda del Port', NULL, '46250', 'Avinguda del Port 243', '46011', 39.46148, -0.33716, 'address', 'openstreetmap:node/4989867672'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-5046860625', 'Carrefour València – Avinguda del Marqués de Sotelo', NULL, '46250', 'Avinguda del Marqués de Sotelo 6', '46002', 39.46899, -0.3771, 'address', 'openstreetmap:node/5046860625'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-5165386599', 'Carrefour Bétera – Carrer del Riu Llucena', NULL, '46070', 'Carrer del Riu Llucena', NULL, 39.54987, -0.45704, 'address', 'openstreetmap:node/5165386599'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-5236449487', 'Carrefour València – Carrer de Quart', NULL, '46250', 'Carrer de Quart 64', '46008', 39.47567, -0.38508, 'address', 'openstreetmap:node/5236449487'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-5270314527', 'Carrefour València – Carrer del Miracle', NULL, '46250', 'Carrer del Miracle 7', '46003', 39.47466, -0.37413, 'address', 'openstreetmap:node/5270314527'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-554917705', 'Carrefour Paterna – Avinguda de Francisco Tomás i Valiente', NULL, '46190', 'Avinguda de Francisco Tomás i Valiente', '46980', 39.53044, -0.44112, 'address', 'openstreetmap:node/554917705'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-5960061091', 'Carrefour València – Carrer de la Marina Alta', NULL, '46250', 'Carrer de la Marina Alta 4', '46015', 39.49064, -0.40247, 'address', 'openstreetmap:node/5960061091'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-6015890628', 'Carrefour Quart de Poblet – Avinguda de les Comarques del País Valencià', NULL, '46102', 'Avinguda de les Comarques del País Valencià', NULL, 39.47411, -0.49114, 'address', 'openstreetmap:node/6015890628'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-6239409007', 'Carrefour València – Carrer dels Serrans', NULL, '46250', 'Carrer dels Serrans', '46003', 39.47765, -0.37667, 'address', 'openstreetmap:node/6239409007'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-6320623003', 'Carrefour València – Plaça del Músic Albéniz', NULL, '46250', 'Plaça del Músic Albéniz 2', '46010', 39.48391, -0.36323, 'address', 'openstreetmap:node/6320623003'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-6377789599', 'Carrefour València – Carrer de Ramon Llull', NULL, '46250', 'Carrer de Ramon Llull 19', '46021', 39.47617, -0.34717, 'address', 'openstreetmap:node/6377789599'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:node-6824015527', 'Decathlon Cullera – Carrer d''Amparo Belda', NULL, '46105', 'Carrer d''Amparo Belda', NULL, 39.16817, -0.24192, 'address', 'openstreetmap:node/6824015527'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-7832190146', 'Carrefour Burjassot – Avenida de María Ros', NULL, '46078', 'Avenida de María Ros 9', '46100', 39.51461, -0.4131, 'address', 'openstreetmap:node/7832190146'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-8118284227', 'Carrefour la Pobla de Vallbona – AUTOVIA CV-35 KM.', NULL, '46202', 'AUTOVIA CV-35 KM. 17', NULL, 39.58335, -0.53188, 'address', 'openstreetmap:node/8118284227'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-8880463715', 'Carrefour Cullera – Avinguda del Racó', NULL, '46105', 'Avinguda del Racó 14', '46400', 39.17289, -0.24218, 'address', 'openstreetmap:node/8880463715'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:node-9641270109', 'Decathlon València – Carrer de Ciril Amorós', NULL, '46250', 'Carrer de Ciril Amorós 62', '46004', 39.46861, -0.36813, 'address', 'openstreetmap:node/9641270109'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-9976737534', 'Carrefour Xàtiva – PLAZA ESPAÑA', NULL, '46145', 'PLAZA ESPAÑA 1', '46800', 38.99059, -0.51345, 'address', 'openstreetmap:node/9976737534'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:relation-7461507', 'Leroy Merlin Gandia – Carrer de l''Exportació', NULL, '46131', 'Carrer de l''Exportació', NULL, 38.95757, -0.17289, 'address', 'openstreetmap:relation/7461507'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:way-1000789307', 'MediaMarkt Massalfassar', NULL, '46163', NULL, NULL, 39.55313, -0.30223, 'address', 'openstreetmap:way/1000789307'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-118397987', 'El Corte Inglés València – Calle de Colón', NULL, '46250', 'Calle de Colón 27', '46004', 39.46946, -0.3722, 'address', 'openstreetmap:way/118397987'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-118397988', 'El Corte Inglés València – Carrer del Pintor Sorolla', NULL, '46250', 'Carrer del Pintor Sorolla 26', '46002', 39.47065, -0.37134, 'address', 'openstreetmap:way/118397988'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-1279071976', 'El Corte Inglés València – Avinguda de Menéndez Pidal', NULL, '46250', 'Avinguda de Menéndez Pidal', '46009', 39.4799, -0.38957, 'address', 'openstreetmap:way/1279071976'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-1279071980', 'El Corte Inglés València – Avinguda de Pius XII 2-6', NULL, '46250', 'Avinguda de Pius XII 2-6', '46009', 39.48065, -0.39146, 'address', 'openstreetmap:way/1279071980'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-1281158367', 'Carrefour Xirivella', NULL, '46110', NULL, '46014', 39.46475, -0.41313, 'address', 'openstreetmap:way/1281158367'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-1283628782', 'Carrefour València – Carrer de Ricardo Muñoz Suay', NULL, '46250', 'Carrer de Ricardo Muñoz Suay', '46013', 39.45285, -0.35611, 'address', 'openstreetmap:way/1283628782'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-144599760', 'El Corte Inglés València – Avenida de Pío XII', NULL, '46250', 'Avenida de Pío XII 51', '46015', 39.48481, -0.39675, 'address', 'openstreetmap:way/144599760'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-149289684', 'Decathlon San Antonio de Benagéber – Avenida Pobla de Vallbona', NULL, '46903', 'Avenida Pobla de Vallbona 39', '46184', 39.57643, -0.51596, 'address', 'openstreetmap:way/149289684'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-150109792', 'Leroy Merlin la Pobla de Vallbona – Carrer de la Covatella', NULL, '46202', 'Carrer de la Covatella', '46183', 39.58029, -0.53203, 'address', 'openstreetmap:way/150109792'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-150146972', 'Leroy Merlin Aldaia – Avinguda de les Comarques del País Valencià', NULL, '46021', 'Avinguda de les Comarques del País Valencià', NULL, 39.47354, -0.48624, 'address', 'openstreetmap:way/150146972'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-150150002', 'Decathlon Aldaia – Avinguda Venta de l''Aire', NULL, '46021', 'Avinguda Venta de l''Aire', NULL, 39.47184, -0.48434, 'address', 'openstreetmap:way/150150002'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-158684012', 'El Corte Inglés València – Carrer del Pintor Maella', NULL, '46250', 'Carrer del Pintor Maella 37', '46023', 39.4573, -0.34692, 'address', 'openstreetmap:way/158684012'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-171798400', 'Carrefour Paterna – Calle Cuiners', NULL, '46190', 'Calle Cuiners', NULL, 39.51526, -0.44075, 'address', 'openstreetmap:way/171798400'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:way-195035951', 'MediaMarkt Quart de Poblet – Ronda Sud-oest d''Alaquàs i Oest d''Aldaia', NULL, '46102', 'Ronda Sud-oest d''Alaquàs i Oest d''Aldaia', NULL, 39.4754, -0.48315, 'address', 'openstreetmap:way/195035951'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-200433385', 'Decathlon Gandia – Carrer del Transport', NULL, '46131', 'Carrer del Transport', NULL, 38.95723, -0.17571, 'address', 'openstreetmap:way/200433385'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:way-23761012', 'MediaMarkt València – Carrer de la Safor', NULL, '46250', 'Carrer de la Safor 12', '46015', 39.49033, -0.40062, 'address', 'openstreetmap:way/23761012'),
  ('IKEA', 'catalogo-valencia:valencia-grandes-superficies:way-247412488', 'IKEA Alfafar – Edificio Alqueria Nova', NULL, '46022', 'Edificio Alqueria Nova 12', '46910', 39.4149, -0.38748, 'address', 'openstreetmap:way/247412488'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-248226004', 'Leroy Merlin Massanassa – Carrer Medi Ambient', NULL, '46165', 'Carrer Medi Ambient 1', '46470', 39.4108, -0.38433, 'address', 'openstreetmap:way/248226004'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:way-248226012', 'MediaMarkt Alfafar – Carrer Alcalde José Puertes', NULL, '46022', 'Carrer Alcalde José Puertes 9', '46910', 39.41392, -0.38095, 'address', 'openstreetmap:way/248226012'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-248271871', 'Carrefour Alfafar – Avenida Albufera', NULL, '46022', 'Avenida Albufera 72', '46910', 39.41895, -0.37914, 'address', 'openstreetmap:way/248271871'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-248451599', 'El Corte Inglés Sedaví – Avinguda del Mediterrani', NULL, '46223', 'Avinguda del Mediterrani 28', '46910', 39.42038, -0.37616, 'address', 'openstreetmap:way/248451599'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-291009862', 'Decathlon Xàtiva – Carrer Braçal de les Dones', NULL, '46145', 'Carrer Braçal de les Dones', NULL, 38.99534, -0.52953, 'address', 'openstreetmap:way/291009862'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-30093280', 'Leroy Merlin Alboraia / Alboraya – Passeig Marítim', NULL, '46013', 'Passeig Marítim', '46120', 39.50365, -0.32385, 'address', 'openstreetmap:way/30093280'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-302343227', 'Carrefour Gandia – Carrer de Cibeles', NULL, '46131', 'Carrer de Cibeles 46', NULL, 38.99693, -0.16245, 'address', 'openstreetmap:way/302343227'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-472724429', 'Decathlon Alfafar – Carrer de Pérez Llácer', NULL, '46022', 'Carrer de Pérez Llácer', '46910', 39.41547, -0.38493, 'address', 'openstreetmap:way/472724429'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-495235482', 'Carrefour València – Carrer de la Pau', NULL, '46250', 'Carrer de la Pau 29', '46003', 39.47324, -0.37152, 'address', 'openstreetmap:way/495235482'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-532075271', 'Carrefour Massalfassar', NULL, '46163', NULL, '46560', 39.55288, -0.30117, 'address', 'openstreetmap:way/532075271'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-593649244', 'Decathlon Carcaixent', NULL, '46083', NULL, NULL, 39.12921, -0.44348, 'address', 'openstreetmap:way/593649244'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-594275940', 'Leroy Merlin Xàtiva – Ronda Nord', NULL, '46145', 'Ronda Nord', '46800', 38.99524, -0.52748, 'address', 'openstreetmap:way/594275940'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-607904107', 'Leroy Merlin Sagunt / Sagunto – Camí dels Rolls', NULL, '46220', 'Camí dels Rolls', '46500', 39.6703, -0.26543, 'address', 'openstreetmap:way/607904107'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-724078343', 'Decathlon Torrent', NULL, '46244', NULL, '46900', 39.41905, -0.50565, 'address', 'openstreetmap:way/724078343'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-741663763', 'Decathlon Sagunt / Sagunto – Avinguda del Racó de l''Horta', NULL, '46220', 'Avinguda del Racó de l''Horta', NULL, 39.67459, -0.26497, 'address', 'openstreetmap:way/741663763'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-96571876', 'Carrefour Alzira – Avinguda de la Dignitat Humana', NULL, '46017', 'Avinguda de la Dignitat Humana 2', '46600', 39.16434, -0.42991, 'address', 'openstreetmap:way/96571876');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT c.categoria, ', ') INTO faltan FROM _carga c WHERE NOT EXISTS (SELECT 1 FROM public.categories k WHERE k.name = c.categoria);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan categorías: %', faltan;
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
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 77 THEN
    RAISE EXCEPTION 'Se esperaban 77 puntos de (varias) en Valencia/València, hay %', n;
  END IF;
END;
$$;

COMMIT;
