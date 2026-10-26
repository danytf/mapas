-- Carga de la categoría Correos de Alicante/Alacant (provincia 03), trozo de la carga de Andalucía.
-- Origen: postal_service-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 87 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-valencia:postal_service:node-10063222953', 'Correos Elda – calle Dahellos', NULL, '03066', 'calle Dahellos 2', '03600', 38.47704, -0.79388, 'address', 'openstreetmap:node/10063222953'),
  ('catalogo-valencia:postal_service:node-10673482301', 'Correos Elx / Elche – Avinguda de l''Alegria', NULL, '03065', 'Avinguda de l''Alegria 72', '03194', 38.14464, -0.64612, 'address', 'openstreetmap:node/10673482301'),
  ('catalogo-valencia:postal_service:node-1077550638', 'Correos Calp – Pintor Sorolla', NULL, '03047', 'Pintor Sorolla 12', '03710', 38.644, 0.05131, 'address', 'openstreetmap:node/1077550638'),
  ('catalogo-valencia:postal_service:node-1126166468', 'Correos Benissa – Carrer de la Palmera', NULL, '03041', 'Carrer de la Palmera 1', '03720', 38.71529, 0.05153, 'address', 'openstreetmap:node/1126166468'),
  ('catalogo-valencia:postal_service:node-11332899435', 'Correos Agost – avinguda del Doctor Fleming', NULL, '03002', 'avinguda del Doctor Fleming', NULL, 38.43904, -0.63626, 'address', 'openstreetmap:node/11332899435'),
  ('catalogo-valencia:postal_service:node-1161703701', 'Correos Xàbia / Jávea – Avinguda Princep d''Asturies', NULL, '03082', 'Avinguda Princep d''Asturies 2', '03760', 38.79022, 0.16229, 'address', 'openstreetmap:node/1161703701'),
  ('catalogo-valencia:postal_service:node-11738613471', 'Correos Biar – Calle San Cristóbal', NULL, '03043', 'Calle San Cristóbal 9', '03410', 38.62872, -0.76307, 'address', 'openstreetmap:node/11738613471'),
  ('catalogo-valencia:postal_service:node-11832850231', 'Correos Elx / Elche – carrer Mare de Déu de la Llet', NULL, '03065', 'carrer Mare de Déu de la Llet 1', NULL, 38.26194, -0.69811, 'address', 'openstreetmap:node/11832850231'),
  ('catalogo-valencia:postal_service:node-11873697279', 'Correos Benidorm – Marqués de Comillas', NULL, '03031', 'Marqués de Comillas 35', '03501', 38.53794, -0.13506, 'address', 'openstreetmap:node/11873697279'),
  ('catalogo-valencia:postal_service:node-12337510581', 'Correos Elx / Elche – Carrer Sucre 1AC', NULL, '03065', 'Carrer Sucre 1AC', NULL, 38.27074, -0.67888, 'address', 'openstreetmap:node/12337510581'),
  ('catalogo-valencia:postal_service:node-12554970916', 'Correos Castalla – Plaça de la Font Vella', NULL, '03053', 'Plaça de la Font Vella', NULL, 38.59438, -0.67231, 'address', 'openstreetmap:node/12554970916'),
  ('catalogo-valencia:postal_service:node-1268702812', 'Correos Alcalalí – Plaça de l''Ajuntament', NULL, '03006', 'Plaça de l''Ajuntament 2', '03728', 38.74963, -0.04163, 'address', 'openstreetmap:node/1268702812'),
  ('catalogo-valencia:postal_service:node-12720518003', 'Correos Beneixama – Carrer del Doctor Silvestre', NULL, '03023', 'Carrer del Doctor Silvestre', '03460', 38.70047, -0.76695, 'address', 'openstreetmap:node/12720518003'),
  ('catalogo-valencia:postal_service:node-1279123917', 'Correos Alacant / Alicante – Carrer d''Astúries', NULL, '03014', 'Carrer d''Astúries 8', '03007', 38.34375, -0.50966, 'address', 'openstreetmap:node/1279123917'),
  ('catalogo-valencia:postal_service:node-13237875901', 'Correos Villena – Calle Ferriz', NULL, '03140', 'Calle Ferriz 5', '03400', 38.62953, -0.86534, 'address', 'openstreetmap:node/13237875901'),
  ('catalogo-valencia:postal_service:node-1340163208', 'Correos Santa Pola – Carrer Ramón y Cajal', NULL, '03121', 'Carrer Ramón y Cajal 2', NULL, 38.19217, -0.56098, 'address', 'openstreetmap:node/1340163208'),
  ('catalogo-valencia:postal_service:node-13510460657', 'Correos Alacant / Alicante – Carrer d''Isaac Albéniz', NULL, '03014', 'Carrer d''Isaac Albéniz 4', NULL, 38.35508, -0.48002, 'address', 'openstreetmap:node/13510460657'),
  ('catalogo-valencia:postal_service:node-13510467913', 'Correos Alacant / Alicante – Carrer de l''Arquitecte Morell', NULL, '03014', 'Carrer de l''Arquitecte Morell 3', '03003', 38.34257, -0.49127, 'address', 'openstreetmap:node/13510467913'),
  ('catalogo-valencia:postal_service:node-13510530405', 'Correos Alacant / Alicante – Carretera d''Ocaña', NULL, '03014', 'Carretera d''Ocaña', NULL, 38.34478, -0.52731, 'address', 'openstreetmap:node/13510530405'),
  ('catalogo-valencia:postal_service:node-14087026169', 'Correos Pilar de la Horadada – Calle Ramón y Cajal', NULL, '03902', 'Calle Ramón y Cajal 25', '03190', 37.86281, -0.79191, 'address', 'openstreetmap:node/14087026169'),
  ('catalogo-valencia:postal_service:node-1667371674', 'Correos Sant Vicent del Raspeig / San Vicente del Raspeig – Avinguda Ampla de Castelar', NULL, '03122', 'Avinguda Ampla de Castelar', '03690', 38.39713, -0.52216, 'address', 'openstreetmap:node/1667371674'),
  ('catalogo-valencia:postal_service:node-1741695400', 'Correos Gata de Gorgos – Avinguda de la Marina Alta', NULL, '03071', 'Avinguda de la Marina Alta 160', '03740', 38.77259, 0.08917, 'address', 'openstreetmap:node/1741695400'),
  ('catalogo-valencia:postal_service:node-1795453317', 'Correos Catral – Calle San Juan', NULL, '03055', 'Calle San Juan 2', '03158', 38.15971, -0.80367, 'address', 'openstreetmap:node/1795453317'),
  ('catalogo-valencia:postal_service:node-1846661600', 'Correos Onil – Camino Real', NULL, '03096', 'Camino Real', NULL, 38.62984, -0.67246, 'address', 'openstreetmap:node/1846661600'),
  ('catalogo-valencia:postal_service:node-1946027797', 'Correos San Miguel de Salinas – Calle de Alberto Barberà', NULL, '03120', 'Calle de Alberto Barberà', '03193', 37.98057, -0.79139, 'address', 'openstreetmap:node/1946027797'),
  ('catalogo-valencia:postal_service:node-1950582918', 'Correos San Fulgencio – Calle Francisco de Quevedo 3 / L10', NULL, '03118', 'Calle Francisco de Quevedo 3 / L10', '03177', 38.13004, -0.67909, 'address', 'openstreetmap:node/1950582918'),
  ('catalogo-valencia:postal_service:node-1951046872', 'Correos Teulada – Calle Marjaleta', NULL, '03128', 'Calle Marjaleta 8', '03724', 38.68848, 0.13313, 'address', 'openstreetmap:node/1951046872'),
  ('catalogo-valencia:postal_service:node-1953098261', 'Correos Xaló – avinguda del Rei Juan Carlos I 23D', NULL, '03081', 'avinguda del Rei Juan Carlos I 23D', '03727', 38.74207, -0.01259, 'address', 'openstreetmap:node/1953098261'),
  ('catalogo-valencia:postal_service:node-1974315853', 'Correos Almoradí – Calle Obispo Herrero', NULL, '03015', 'Calle Obispo Herrero', '03160', 38.10697, -0.79162, 'address', 'openstreetmap:node/1974315853'),
  ('catalogo-valencia:postal_service:node-2004612815', 'Correos Formentera del Segura – Calle Gaspar Mora', NULL, '03070', 'Calle Gaspar Mora 5', NULL, 38.0836, -0.74602, 'address', 'openstreetmap:node/2004612815'),
  ('catalogo-valencia:postal_service:node-2295554630', 'Correos Pedreguer – Avinguda de Jaume I', NULL, '03101', 'Avinguda de Jaume I 18', '03750', 38.79632, 0.03352, 'address', 'openstreetmap:node/2295554630'),
  ('catalogo-valencia:postal_service:node-2344910812', 'Correos Torrevieja – Calle de la Purificación', NULL, '03133', 'Calle de la Purificación 15', '03188', 38.02555, -0.65444, 'address', 'openstreetmap:node/2344910812'),
  ('catalogo-valencia:postal_service:node-2356946778', 'Correos Dolores – Calle San Raimundo de Peñafort', NULL, '03064', 'Calle San Raimundo de Peñafort 3', '03150', 38.13941, -0.76784, 'address', 'openstreetmap:node/2356946778'),
  ('catalogo-valencia:postal_service:node-2403643581', 'Correos Altea – Avinguda de Valencia', NULL, '03018', 'Avinguda de Valencia', '03590', 38.60204, -0.04911, 'address', 'openstreetmap:node/2403643581'),
  ('catalogo-valencia:postal_service:node-246363205', 'Correos Alacant / Alicante – Carrer d''Alonso Cano', NULL, '03014', 'Carrer d''Alonso Cano 40', '03012', 38.36249, -0.47971, 'address', 'openstreetmap:node/246363205'),
  ('catalogo-valencia:postal_service:node-2473743105', 'Correos Monòver / Monóvar – carrer Alcalde Saturnino Cerdá', NULL, '03089', 'carrer Alcalde Saturnino Cerdá 2', NULL, 38.43481, -0.83853, 'address', 'openstreetmap:node/2473743105'),
  ('catalogo-valencia:postal_service:node-259592166', 'Correos Alacant / Alicante – Avinguda de l''Historiador Vicente Ramos', NULL, '03014', 'Avinguda de l''Historiador Vicente Ramos 1', '03540', 38.3657, -0.43111, 'address', 'openstreetmap:node/259592166'),
  ('catalogo-valencia:postal_service:node-288167781', 'Correos la Vila Joiosa / Villajoyosa – Avinguda del País Valencià', NULL, '03139', 'Avinguda del País Valencià', NULL, 38.50842, -0.22792, 'address', 'openstreetmap:node/288167781'),
  ('catalogo-valencia:postal_service:node-4063865242', 'Correos Orihuela – Calle de las Orquídeas', NULL, '03099', 'Calle de las Orquídeas 1', '03189', 37.93142, -0.72133, 'address', 'openstreetmap:node/4063865242'),
  ('catalogo-valencia:postal_service:node-4227832823', 'Correos Ondara – Avinguda del Doctor Flèming', NULL, '03095', 'Avinguda del Doctor Flèming 56', '03760', 38.82996, 0.01517, 'address', 'openstreetmap:node/4227832823'),
  ('catalogo-valencia:postal_service:node-4388832494', 'Correos Callosa de Segura – Avenida de la Constitución', NULL, '03049', 'Avenida de la Constitución', '03360', 38.12735, -0.87766, 'address', 'openstreetmap:node/4388832494'),
  ('catalogo-valencia:postal_service:node-4751800657', 'Correos Banyeres de Mariola – Carrer del Pintor Segrelles', NULL, '03021', 'Carrer del Pintor Segrelles 8', NULL, 38.71751, -0.6578, 'address', 'openstreetmap:node/4751800657'),
  ('catalogo-valencia:postal_service:node-491197653', 'Correos Orihuela – Plaza Nueva', NULL, '03099', 'Plaza Nueva 4', '03300', 38.08447, -0.94751, 'address', 'openstreetmap:node/491197653'),
  ('catalogo-valencia:postal_service:node-512486332', 'Correos Novelda – calle Virgen de los Desamparados', NULL, '03093', 'calle Virgen de los Desamparados 32', '03660', 38.38352, -0.76666, 'address', 'openstreetmap:node/512486332'),
  ('catalogo-valencia:postal_service:node-5310382184', 'Correos Agres – Plaça d''Espanya', NULL, '03003', 'Plaça d''Espanya 12', '03837', 38.78001, -0.51562, 'address', 'openstreetmap:node/5310382184'),
  ('catalogo-valencia:postal_service:node-5519001824', 'Correos Torrevieja – Calle Orihuela', NULL, '03133', 'Calle Orihuela', '03181', 37.97935, -0.68625, 'address', 'openstreetmap:node/5519001824'),
  ('catalogo-valencia:postal_service:node-5586278336', 'Correos els Poblets – Avinguda Jaume I', NULL, '03901', 'Avinguda Jaume I 7', '03779', 38.84911, 0.01604, 'address', 'openstreetmap:node/5586278336'),
  ('catalogo-valencia:postal_service:node-5695172934', 'Correos Sant Joan d''Alacant – Carrer Doctor Severo Ochoa', NULL, '03119', 'Carrer Doctor Severo Ochoa', '03550', 38.39541, -0.43605, 'address', 'openstreetmap:node/5695172934'),
  ('catalogo-valencia:postal_service:node-5920157743', 'Correos Crevillent – Carrer Santa María de la Cabeza', NULL, '03059', 'Carrer Santa María de la Cabeza', NULL, 38.24499, -0.8107, 'address', 'openstreetmap:node/5920157743'),
  ('catalogo-valencia:postal_service:node-6052741958', 'Correos Callosa d''en Sarrià – Ctra. de Bolulla', NULL, '03048', 'Ctra. de Bolulla 18', '03510', 38.65071, -0.12103, 'address', 'openstreetmap:node/6052741958'),
  ('catalogo-valencia:postal_service:node-6114671196', 'Correos Dénia – Carrer Major', NULL, '03063', 'Carrer Major 14', '03709', 38.82965, 0.06304, 'address', 'openstreetmap:node/6114671196'),
  ('catalogo-valencia:postal_service:node-6139703480', 'Correos l''Alfàs del Pi – Avinguda Óscar Esplá', NULL, '03011', 'Avinguda Óscar Esplá 4', '03581', 38.57325, -0.06527, 'address', 'openstreetmap:node/6139703480'),
  ('catalogo-valencia:postal_service:node-6336366574', 'Correos Orihuela – Calle Miguel Delibes', NULL, '03099', 'Calle Miguel Delibes', NULL, 38.09495, -0.86334, 'address', 'openstreetmap:node/6336366574'),
  ('catalogo-valencia:postal_service:node-6345677988', 'Correos Rojales – Calle Malecón del Carmen', NULL, '03113', 'Calle Malecón del Carmen 17', '03170', 38.08857, -0.72298, 'address', 'openstreetmap:node/6345677988'),
  ('catalogo-valencia:postal_service:node-6400574007', 'Correos Rafal – Calle Miguel Hernández', NULL, '03109', 'Calle Miguel Hernández', '03369', 38.10465, -0.84946, 'address', 'openstreetmap:node/6400574007'),
  ('catalogo-valencia:postal_service:node-6402412473', 'Correos Bigastro – Calle Velázquez', NULL, '03044', 'Calle Velázquez 26', NULL, 38.06353, -0.89279, 'address', 'openstreetmap:node/6402412473'),
  ('catalogo-valencia:postal_service:node-6467750232', 'Correos Redován – Calle Abajo', NULL, '03111', 'Calle Abajo 2', '03370', 38.11378, -0.90579, 'address', 'openstreetmap:node/6467750232'),
  ('catalogo-valencia:postal_service:node-6495804072', 'Correos Elx / Elche – Avinguda de la Llibertat', NULL, '03065', 'Avinguda de la Llibertat 110', '03205', 38.26711, -0.71007, 'address', 'openstreetmap:node/6495804072'),
  ('catalogo-valencia:postal_service:node-6504451001', 'Correos Algueña – Avinguda de la Constitució', NULL, '03013', 'Avinguda de la Constitució 13', '03668', 38.33902, -1.00537, 'address', 'openstreetmap:node/6504451001'),
  ('catalogo-valencia:postal_service:node-6567243250', 'Correos Torrevieja – Calle Caballero de Rodas', NULL, '03133', 'Calle Caballero de Rodas 53', '03181', 37.97798, -0.68087, 'address', 'openstreetmap:node/6567243250'),
  ('catalogo-valencia:postal_service:node-6721203497', 'Correos Elx / Elche – Carrer de la Puríssima', NULL, '03065', 'Carrer de la Puríssima 51', '03320', 38.29418, -0.58813, 'address', 'openstreetmap:node/6721203497'),
  ('catalogo-valencia:postal_service:node-684440536', 'Correos Guardamar del Segura – Carrer Jorge Juan', NULL, '03076', 'Carrer Jorge Juan 11', '03140', 38.08561, -0.64987, 'address', 'openstreetmap:node/684440536'),
  ('catalogo-valencia:postal_service:node-7279491505', 'Correos Rojales – Calle Los Arcos', NULL, '03113', 'Calle Los Arcos 17', '03170', 38.0643, -0.73064, 'address', 'openstreetmap:node/7279491505'),
  ('catalogo-valencia:postal_service:node-7515177547', 'Correos Elx / Elche – calle Chile 1AC', NULL, '03065', 'calle Chile 1AC', '03293', 38.25854, -0.71522, 'address', 'openstreetmap:node/7515177547'),
  ('catalogo-valencia:postal_service:node-769077518', 'Correos Alacant / Alicante – Carrer de la Verge del Rosari', NULL, '03014', 'Carrer de la Verge del Rosari 2', '03009', 38.36604, -0.50018, 'address', 'openstreetmap:node/769077518'),
  ('catalogo-valencia:postal_service:node-7904649971', 'Correos Monforte del Cid – Avenida de Aspe', NULL, '03088', 'Avenida de Aspe 17', NULL, 38.37942, -0.73151, 'address', 'openstreetmap:node/7904649971'),
  ('catalogo-valencia:postal_service:node-7925297421', 'Correos Benidorm – Avinguda d''Europa', NULL, '03031', 'Avinguda d''Europa 8', '03503', 38.53803, -0.11986, 'address', 'openstreetmap:node/7925297421'),
  ('catalogo-valencia:postal_service:node-9024626236', 'Correos Dénia – Carrer Patricio Ferràndiz 38B', NULL, '03063', 'Carrer Patricio Ferràndiz 38B', '03700', 38.83797, 0.10745, 'address', 'openstreetmap:node/9024626236'),
  ('catalogo-valencia:postal_service:node-9282942580', 'Correos Benimeli – Carrer Mestra Consuelo Sanchiz', NULL, '03040', 'Carrer Mestra Consuelo Sanchiz 36', '03769', 38.82247, -0.04369, 'address', 'openstreetmap:node/9282942580'),
  ('catalogo-valencia:postal_service:node-9468722154', 'Correos Pego – carrer Poeta Llorente', NULL, '03102', 'carrer Poeta Llorente', NULL, 38.84122, -0.11558, 'address', 'openstreetmap:node/9468722154'),
  ('catalogo-valencia:postal_service:node-975351213', 'Correos Benidorm – Carrer Actor Luís Prendes', NULL, '03031', 'Carrer Actor Luís Prendes 1', '03502', 38.531, -0.16395, 'address', 'openstreetmap:node/975351213'),
  ('catalogo-valencia:postal_service:way-1278539198', 'Correos San Fulgencio – Cardenal Belluga 2A', NULL, '03118', 'Cardenal Belluga 2A', '03177', 38.11228, -0.71928, 'address', 'openstreetmap:way/1278539198'),
  ('catalogo-valencia:postal_service:way-164874537', 'Correos Petrer – Carrer Virrei Poveda', NULL, '03104', 'Carrer Virrei Poveda', '03610', 38.48286, -0.77698, 'address', 'openstreetmap:way/164874537'),
  ('catalogo-valencia:postal_service:way-181737679', 'Correos Guardamar del Segura – Urbanizacion Buenavista', NULL, '03076', 'Urbanizacion Buenavista', '03140', 38.12614, -0.6501, 'address', 'openstreetmap:way/181737679'),
  ('catalogo-valencia:postal_service:way-190010656', 'Correos Benejúzar – Calle Antonio Machado', NULL, '03024', 'Calle Antonio Machado 12', '03390', 38.07693, -0.83672, 'address', 'openstreetmap:way/190010656'),
  ('catalogo-valencia:postal_service:way-190235813', 'Correos Algorfa – Calle Virgen del Carmen', NULL, '03012', 'Calle Virgen del Carmen 2', '03169', 38.08679, -0.79576, 'address', 'openstreetmap:way/190235813'),
  ('catalogo-valencia:postal_service:way-190258601', 'Correos Los Montesinos – Avenida de la Luz', NULL, '03903', 'Avenida de la Luz 12', '03187', 38.0288, -0.74439, 'address', 'openstreetmap:way/190258601'),
  ('catalogo-valencia:postal_service:way-191697600', 'Correos Jacarilla – Calle Marqués de Cuba', NULL, '03080', 'Calle Marqués de Cuba 1', NULL, 38.06136, -0.86669, 'address', 'openstreetmap:way/191697600'),
  ('catalogo-valencia:postal_service:way-209349305', 'Correos Granja de Rocamora – Calle Conorel Ramón Trives', NULL, '03074', 'Calle Conorel Ramón Trives', NULL, 38.15345, -0.89437, 'address', 'openstreetmap:way/209349305'),
  ('catalogo-valencia:postal_service:way-22788403', 'Correos Alacant / Alicante – Carrer de Sant Ferran', NULL, '03014', 'Carrer de Sant Ferran 40', '03001', 38.3431, -0.4854, 'address', 'openstreetmap:way/22788403'),
  ('catalogo-valencia:postal_service:way-241287400', 'Correos Benidoleig – Plaça País Valencià', NULL, '03030', 'Plaça País Valencià 5', '03759', 38.79118, -0.03075, 'address', 'openstreetmap:way/241287400'),
  ('catalogo-valencia:postal_service:way-250103068', 'Correos Alcoi / Alcoy – Carrer Oliver', NULL, '03009', 'Carrer Oliver 7', '03801', 38.69755, -0.47661, 'address', 'openstreetmap:way/250103068'),
  ('catalogo-valencia:postal_service:way-412639587', 'Correos Santa Pola – Avinguda del Mediterrani', NULL, '03121', 'Avinguda del Mediterrani', NULL, 38.22946, -0.5265, 'address', 'openstreetmap:way/412639587'),
  ('catalogo-valencia:postal_service:way-420571094', 'Correos Sax – Calle maestro Vives', NULL, '03123', 'Calle maestro Vives 1', '03630', 38.5372, -0.81764, 'address', 'openstreetmap:way/420571094'),
  ('catalogo-valencia:postal_service:way-566211161', 'Correos Altea – Carrer del Retor Llinares', NULL, '03018', 'Carrer del Retor Llinares', '03599', 38.63011, -0.04379, 'address', 'openstreetmap:way/566211161'),
  ('catalogo-valencia:postal_service:way-675757792', 'Correos el Verger – Calle Marqués de Estella', NULL, '03138', 'Calle Marqués de Estella 8', '03770', 38.84626, 0.00923, 'address', 'openstreetmap:way/675757792'),
  ('catalogo-valencia:postal_service:way-80589730', 'Correos Alacant / Alicante – Carrer del Catedràtic Senante Llaudes', NULL, '03014', 'Carrer del Catedràtic Senante Llaudes 5', '03005', 38.34528, -0.49475, 'address', 'openstreetmap:way/80589730');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 87 THEN
    RAISE EXCEPTION 'Se esperaban 87 puntos de Correos en Alicante/Alacant, hay %', n;
  END IF;
END;
$$;

COMMIT;
