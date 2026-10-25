-- Carga de la categoría Estaciones de Barcelona (provincia 08), trozo de la carga de Andalucía.
-- Origen: estaciones-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 185 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cataluna:estaciones:node-10710967410', 'Estación de autobuses de Autocars Prat (Taradell) – Ronda de Ponent', 'Autobús', '08278', 'Ronda de Ponent', NULL, 41.87433, 2.28111, 'address', 'openstreetmap:node/10710967410'),
  ('catalogo-cataluna:estaciones:node-11287324208', 'Estación de autobuses de Aerobús T1 (el Prat de Llobregat) – Terminal 1 & 2 Llegadas', 'Autobús', '08169', 'Terminal 1 & 2 Llegadas', '08820', 41.28858, 2.07252, 'approximate', 'openstreetmap:node/11287324208'),
  ('catalogo-cataluna:estaciones:node-12750149615', 'Estación de tren de la Pobla de Claramunt – Carretera de L''Estació', 'Tren', '08165', 'Carretera de L''Estació', NULL, 41.55456, 1.67797, 'address', 'openstreetmap:node/12750149615'),
  ('catalogo-cataluna:estaciones:node-13429021007', 'Estación de tren de Barcelona-Fabra i Puig – Avinguda Meridiana', 'Tren', '08019', 'Avinguda Meridiana 392', '08030', 41.43098, 2.18311, 'address', 'openstreetmap:node/13429021007'),
  ('catalogo-cataluna:estaciones:node-13429021008', 'Estación de tren de Barcelona-Torre Baró | Vallbona – Carrer de Vallcivera 1C', 'Tren', '08019', 'Carrer de Vallcivera 1C', '08033', 41.46162, 2.18037, 'address', 'openstreetmap:node/13429021008'),
  ('catalogo-cataluna:estaciones:node-13429021009', 'Estación de tren de Quatre Camins (Sant Vicenç dels Horts)', 'Tren', '08263', NULL, NULL, 41.40664, 2.00157, 'address', 'openstreetmap:node/13429021009'),
  ('catalogo-cataluna:estaciones:node-13578329900', 'Estación de tren de Sabadell Parc del Nord – Carrer de Collserola', 'Tren', '08187', 'Carrer de Collserola', '08207', 41.57122, 2.08991, 'address', 'openstreetmap:node/13578329900'),
  ('catalogo-cataluna:estaciones:node-13582333050', 'Estación de tren de Terrassa Rambla – Rambla d''Ègara', 'Tren', '08279', 'Rambla d''Ègara 129', '08224', 41.5603, 2.00758, 'address', 'openstreetmap:node/13582333050'),
  ('catalogo-cataluna:estaciones:node-13614508961', 'Estación de tren de Barcelona-Arc de Triomf – Carrer de Roger de Flor 39-41', 'Tren', '08019', 'Carrer de Roger de Flor 39-41', '08010', 41.39228, 2.18103, 'address', 'openstreetmap:node/13614508961'),
  ('catalogo-cataluna:estaciones:node-13670338788', 'Estación de tren de Aeroport T1 (el Prat de Llobregat) – T1 Aparcament Sortides i Arribades', 'Tren', '08169', 'T1 Aparcament Sortides i Arribades', '08820', 41.28803, 2.07112, 'address', 'openstreetmap:node/13670338788'),
  ('catalogo-cataluna:estaciones:node-13670468509', 'Estación de tren de Igualada – Passeig Mossèn Jacint Verdaguer', 'Tren', '08102', 'Passeig Mossèn Jacint Verdaguer 170', '08700', 41.57807, 1.6298, 'address', 'openstreetmap:node/13670468509'),
  ('catalogo-cataluna:estaciones:node-13672711066', 'Barcelona-Estació de França – Avinguda del Marquès de l''Argentera 6-20', 'Tren', '08019', 'Avinguda del Marquès de l''Argentera 6-20', '08003', 41.38439, 2.18556, 'address', 'openstreetmap:node/13672711066'),
  ('catalogo-cataluna:estaciones:node-13686592278', 'Estación de tren de Aeroport T2 (el Prat de Llobregat) – Carrer de Salvador Hedilla Pineda', 'Tren', '08169', 'Carrer de Salvador Hedilla Pineda', '08820', 41.30345, 2.07432, 'approximate', 'openstreetmap:node/13686592278'),
  ('catalogo-cataluna:estaciones:node-14053607318', 'Estación de tren de la Pobla Centre (la Pobla de Lillet) – via del Carrilet', 'Tren', '08166', 'via del Carrilet', NULL, 42.24548, 1.97433, 'address', 'openstreetmap:node/14053607318'),
  ('catalogo-cataluna:estaciones:node-14204773453', 'Estación de tren de Santa Perpètua de Mogoda Riera de Caldes – Camí de la Granja', 'Tren', '08260', 'Camí de la Granja', NULL, 41.52602, 2.18599, 'address', 'openstreetmap:node/14204773453'),
  ('catalogo-cataluna:estaciones:node-1595874365', 'Estación de autobuses de L2 (Mataró) – Ronda de Ramon Turró', 'Autobús', '08121', 'Ronda de Ramon Turró', '08304', 41.54384, 2.43138, 'approximate', 'openstreetmap:node/1595874365'),
  ('catalogo-cataluna:estaciones:node-1669114248', 'Estación de tren de Rajadell – barriada de l''Estació', 'Tren', '08178', 'barriada de l''Estació 29', '08256', 41.73236, 1.69858, 'address', 'openstreetmap:node/1669114248'),
  ('catalogo-cataluna:estaciones:node-1680233321', 'Estación de tren de Aeri de Montserrat (Monistrol de Montserrat)', 'Tren', '08127', NULL, NULL, 41.59121, 1.85339, 'address', 'openstreetmap:node/1680233321'),
  ('catalogo-cataluna:estaciones:node-1834280969', 'Estación de tren de Santa Susanna – Camí de la Riera de Santa Susanna', 'Tren', '08261', 'Camí de la Riera de Santa Susanna', '08398', 41.63015, 2.71646, 'address', 'openstreetmap:node/1834280969'),
  ('catalogo-cataluna:estaciones:node-1928833209', 'Estación de tren de Monistrol Enllaç (Cremallera) (Monistrol de Montserrat) – Carrer de Salvador Espriu', 'Tren', '08127', 'Carrer de Salvador Espriu', NULL, 41.61035, 1.84922, 'address', 'openstreetmap:node/1928833209'),
  ('catalogo-cataluna:estaciones:node-1966626240', 'Estación de tren de Can Ros (Sant Vicenç dels Horts) – Avinguda del Ferrocarril', 'Tren', '08263', 'Avinguda del Ferrocarril 35', '08620', 41.39934, 2.00494, 'address', 'openstreetmap:node/1966626240'),
  ('catalogo-cataluna:estaciones:node-2049475258', 'Estación de tren de Universitat Autònoma (Cerdanyola del Vallès) – Carrer de les Alzines', 'Tren', '08266', 'Carrer de les Alzines', '08193', 41.503, 2.10242, 'address', 'openstreetmap:node/2049475258'),
  ('catalogo-cataluna:estaciones:node-2158044594', 'Estación de tren de Barcelona - Sants – Plaça dels Països Catalans 1-7', 'Tren', '08019', 'Plaça dels Països Catalans 1-7', '08014', 41.37901, 2.14, 'address', 'openstreetmap:node/2158044594'),
  ('catalogo-cataluna:estaciones:node-2242865394', 'Estación de tren de Sant Martí de Sesgueioles (Pujalt) – Passeig dels Germans Forn', 'Tren', '08176', 'Passeig dels Germans Forn', NULL, 41.70132, 1.48627, 'address', 'openstreetmap:node/2242865394'),
  ('catalogo-cataluna:estaciones:node-2242865426', 'Estación de tren de Seguers - Sant Pere Sallavinera – Carretera d''Accés a l''estació de Seguers', 'Tren', '08189', 'Carretera d''Accés a l''estació de Seguers', NULL, 41.74791, 1.5741, 'address', 'openstreetmap:node/2242865426'),
  ('catalogo-cataluna:estaciones:node-2282450274', 'Estación de tren de Aguilar de Segarra – Plaça de l''Estació', 'Tren', '08002', 'Plaça de l''Estació', NULL, 41.73875, 1.62373, 'address', 'openstreetmap:node/2282450274'),
  ('catalogo-cataluna:estaciones:node-261006106', 'Estación de tren de la Pobla de Lillet – Tren del Ciment', 'Tren', '08166', 'Tren del Ciment', NULL, 42.24131, 1.96495, 'address', 'openstreetmap:node/261006106'),
  ('catalogo-cataluna:estaciones:node-2891273096', 'Estación de tren de el Papiol – Avinguda de la Generalitat de Catalunya', 'Tren', '08158', 'Avinguda de la Generalitat de Catalunya', NULL, 41.4355, 2.00256, 'address', 'openstreetmap:node/2891273096'),
  ('catalogo-cataluna:estaciones:node-376351125', 'Estació d''Autobusos de Granollers – Avinguda de Sant Esteve', 'Autobús', '08096', 'Avinguda de Sant Esteve', '08402', 41.6065, 2.29092, 'address', 'openstreetmap:node/376351125'),
  ('catalogo-cataluna:estaciones:node-529914092', 'Estación de tren de Jardins Artigas (la Pobla de Lillet)', 'Tren', '08166', NULL, NULL, 42.2533, 1.97598, 'address', 'openstreetmap:node/529914092'),
  ('catalogo-cataluna:estaciones:node-529914130', 'Estación de tren de Museu del Ciment (Castellar de n''Hug)', 'Tren', '08052', NULL, NULL, 42.25927, 1.97715, 'address', 'openstreetmap:node/529914130'),
  ('catalogo-cataluna:estaciones:node-530777095', 'Estación de tren de Vic – Plaça de l''Estació', 'Tren', '08298', 'Plaça de l''Estació 4', '08500', 41.93099, 2.24859, 'approximate', 'openstreetmap:node/530777095'),
  ('catalogo-cataluna:estaciones:node-5313898364', 'Estación de tren de Barcelona-La Sagrera-Meridiana – Avinguda Meridiana 285B', 'Tren', '08019', 'Avinguda Meridiana 285B', '08027', 41.42299, 2.18682, 'address', 'openstreetmap:node/5313898364'),
  ('catalogo-cataluna:estaciones:node-5316201456', 'Estación de tren de Can Feu | Gràcia (Sabadell) – Passatge de l''Enginyer Playà', 'Tren', '08187', 'Passatge de l''Enginyer Playà 12', '08205', 41.54244, 2.10027, 'address', 'openstreetmap:node/5316201456'),
  ('catalogo-cataluna:estaciones:node-5316650173', 'Estación de tren de Peu del Funicular (Barcelona) – Avinguda de Vallvidrera 66B', 'Tren', '08019', 'Avinguda de Vallvidrera 66B', '08017', 41.40905, 2.11141, 'address', 'openstreetmap:node/5316650173'),
  ('catalogo-cataluna:estaciones:node-5331587812', 'Estación de tren de Pallejà – Carrer de Barcelona', 'Tren', '08157', 'Carrer de Barcelona', '08780', 41.42078, 1.99557, 'address', 'openstreetmap:node/5331587812'),
  ('catalogo-cataluna:estaciones:node-5334045983', 'Estación de tren de Palautordera (Santa Maria de Palautordera)', 'Tren', '08259', NULL, NULL, 41.67182, 2.45423, 'address', 'openstreetmap:node/5334045983'),
  ('catalogo-cataluna:estaciones:node-5336750117', 'Estación de tren de Castellbisbal', 'Tren', '08054', NULL, NULL, 41.47326, 1.96782, 'address', 'openstreetmap:node/5336750117'),
  ('catalogo-cataluna:estaciones:node-5338582288', 'Estación de tren de Cabrera de Mar - Vilassar de Mar – avinguda del Maresme', 'Tren', '08219', 'avinguda del Maresme', NULL, 41.50673, 2.40177, 'address', 'openstreetmap:node/5338582288'),
  ('catalogo-cataluna:estaciones:node-5338589672', 'Estación de tren de Ocata (el Masnou) – passeig de Prat de la Riba', 'Tren', '08118', 'passeig de Prat de la Riba 9', '08320', 41.47902, 2.31981, 'address', 'openstreetmap:node/5338589672'),
  ('catalogo-cataluna:estaciones:node-5357452240', 'Estación de tren de Sabadell Plaça Major – Passeig de la Plaça Major', 'Tren', '08187', 'Passeig de la Plaça Major 27', '08201', 41.54746, 2.10875, 'address', 'openstreetmap:node/5357452240'),
  ('catalogo-cataluna:estaciones:node-5359591632', 'Estación de tren de Manresa-Viladordis – Carrer de Viladordis', 'Tren', '08113', 'Carrer de Viladordis', NULL, 41.72467, 1.83409, 'address', 'openstreetmap:node/5359591632'),
  ('catalogo-cataluna:estaciones:node-5418171757', 'Estación de tren de la Beguda (Masquefa)', 'Tren', '08119', NULL, NULL, 41.50169, 1.83875, 'address', 'openstreetmap:node/5418171757'),
  ('catalogo-cataluna:estaciones:node-5418179612', 'Estación de tren de Lavern-Subirats', 'Tren', '08273', NULL, NULL, 41.39578, 1.76807, 'address', 'openstreetmap:node/5418179612'),
  ('catalogo-cataluna:estaciones:node-5418191428', 'Estación de tren de Volpelleres (Sant Cugat del Vallès) – Carrer d''Alfons d''Aragó', 'Tren', '08205', 'Carrer d''Alfons d''Aragó', NULL, 41.48129, 2.07286, 'address', 'openstreetmap:node/5418191428'),
  ('catalogo-cataluna:estaciones:node-5418199064', 'Estación de tren de Sabadell Sud – Plaça de Margarida Xirgu', 'Tren', '08187', 'Plaça de Margarida Xirgu', NULL, 41.52866, 2.10518, 'address', 'openstreetmap:node/5418199064'),
  ('catalogo-cataluna:estaciones:node-5418219927', 'Estación de tren de Sant Joan Despí – Passeig de Canalies', 'Tren', '08217', 'Passeig de Canalies', NULL, 41.36856, 2.0602, 'address', 'openstreetmap:node/5418219927'),
  ('catalogo-cataluna:estaciones:node-5420065015', 'Estación de tren de Sant Quirze de Besora – Carrer de l''Estació', 'Tren', '08237', 'Carrer de l''Estació', NULL, 42.10483, 2.21765, 'address', 'openstreetmap:node/5420065015'),
  ('catalogo-cataluna:estaciones:node-5420065133', 'Estación de tren de La Farga de Bebié (Montesquiu)', 'Tren', '08131', NULL, NULL, 42.12971, 2.20359, 'address', 'openstreetmap:node/5420065133'),
  ('catalogo-cataluna:estaciones:node-5420212742', 'Estación de tren de Montserrat (Monistrol de Montserrat)', 'Tren', '08127', NULL, '08199', 41.59244, 1.83667, 'address', 'openstreetmap:node/5420212742'),
  ('catalogo-cataluna:estaciones:node-5420213948', 'Estación de tren de Monistrol-Vila (Monistrol de Montserrat) – Camí del Cementiri', 'Tren', '08127', 'Camí del Cementiri', NULL, 41.61549, 1.84332, 'address', 'openstreetmap:node/5420213948'),
  ('catalogo-cataluna:estaciones:node-5434388023', 'Estación de tren de Calaf – Carretera de Manresa', 'Tren', '08031', 'Carretera de Manresa', NULL, 41.73015, 1.51519, 'address', 'openstreetmap:node/5434388023'),
  ('catalogo-cataluna:estaciones:node-5434402725', 'Estación de tren de Manresa – Antiga carretera d''Abrera a Manresa C-1411b', 'Tren', '08113', 'Antiga carretera d''Abrera a Manresa C-1411b', NULL, 41.72026, 1.82663, 'address', 'openstreetmap:node/5434402725'),
  ('catalogo-cataluna:estaciones:node-5435603698', 'Vilanova i la Geltrú (Estació) – Plaça d''Eduard Maristany', 'Autobús', '08307', 'Plaça d''Eduard Maristany 1', '08800', 41.22063, 1.73057, 'address', 'openstreetmap:node/5435603698'),
  ('catalogo-cataluna:estaciones:node-5435604026', 'Estación de tren de Vilanova i la Geltrú – Plaça d''Eduard Maristany', 'Tren', '08307', 'Plaça d''Eduard Maristany 1', '08800', 41.22018, 1.73082, 'address', 'openstreetmap:node/5435604026'),
  ('catalogo-cataluna:estaciones:node-5436083168', 'Estación de tren de el Prat de Llobregat – Carrer del Doctor Soler i Torrens', 'Tren', '08169', 'Carrer del Doctor Soler i Torrens', '08820', 41.33089, 2.08926, 'address', 'openstreetmap:node/5436083168'),
  ('catalogo-cataluna:estaciones:node-5436098130', 'Estación de tren de Bellvitge-Gornal (l''Hospitalet de Llobregat) – Avinguda de Vilanova', 'Tren', '08101', 'Avinguda de Vilanova', '08902', 41.35401, 2.11541, 'address', 'openstreetmap:node/5436098130'),
  ('catalogo-cataluna:estaciones:node-6495422017', 'Estación de tren de Sant Feliu de Llobregat – Passatge Fargas', 'Tren', '08211', 'Passatge Fargas 3', '08980', 41.38408, 2.04673, 'address', 'openstreetmap:node/6495422017'),
  ('catalogo-cataluna:estaciones:node-7196860523', 'Estación de tren de Piera – Carrer de l''estació', 'Tren', '08161', 'Carrer de l''estació', NULL, 41.52588, 1.75442, 'address', 'openstreetmap:node/7196860523'),
  ('catalogo-cataluna:estaciones:node-7201964187', 'Estación de tren de Sitges – Avinguda de les Flors', 'Tren', '08270', 'Avinguda de les Flors 11', '08870', 41.2392, 1.80973, 'address', 'openstreetmap:node/7201964187'),
  ('catalogo-cataluna:estaciones:node-7201979105', 'Estación de tren de Garraf (Sitges) – Plaça de l’Estació', 'Tren', '08270', 'Plaça de l’Estació 2', '08871', 41.2543, 1.9026, 'address', 'openstreetmap:node/7201979105'),
  ('catalogo-cataluna:estaciones:node-7201979106', 'Estación de tren de Platja de Castelldefels – Passeig del Ferrocarril', 'Tren', '08056', 'Passeig del Ferrocarril', '08860', 41.26708, 1.95728, 'address', 'openstreetmap:node/7201979106'),
  ('catalogo-cataluna:estaciones:node-7201979107', 'Estación de tren de Castelldefels – Plaça de l’Estació', 'Tren', '08056', 'Plaça de l’Estació', '08860', 41.27871, 1.9794, 'address', 'openstreetmap:node/7201979107'),
  ('catalogo-cataluna:estaciones:node-7201979108', 'Estación de tren de Gavà – Carrer Salamanca', 'Tren', '08089', 'Carrer Salamanca 2', '08850', 41.30305, 2.01035, 'address', 'openstreetmap:node/7201979108'),
  ('catalogo-cataluna:estaciones:node-7201979110', 'Estación de tren de Aeroport (el Prat de Llobregat) – Carrer de Salvador Hedilla Pineda', 'Tren', '08169', 'Carrer de Salvador Hedilla Pineda', '08820', 41.30427, 2.07347, 'approximate', 'openstreetmap:node/7201979110'),
  ('catalogo-cataluna:estaciones:node-7201979112', 'Estación de tren de Barcelona-Sant Andreu – Carrer de l''Andana de l''Estació', 'Tren', '08019', 'Carrer de l''Andana de l''Estació', '08030', 41.43627, 2.19386, 'address', 'openstreetmap:node/7201979112'),
  ('catalogo-cataluna:estaciones:node-7201979113', 'Estación de tren de Barcelona-Passeig de Gràcia – Carrer d''Aragó 280-278', 'Tren', '08019', 'Carrer d''Aragó 280-278', '08007', 41.39254, 2.16538, 'address', 'openstreetmap:node/7201979113'),
  ('catalogo-cataluna:estaciones:node-7201979114', 'Estación de tren de Barcelona-El Clot – Carrer Aragó', 'Tren', '08019', 'Carrer Aragó 602', '08018', 41.40907, 2.18741, 'address', 'openstreetmap:node/7201979114'),
  ('catalogo-cataluna:estaciones:node-7204814162', 'Estación de tren de Cornellà (Cornellà de Llobregat) – Carrer de Joan Maragall', 'Tren', '08073', 'Carrer de Joan Maragall 13', '08940', 41.35752, 2.07056, 'address', 'openstreetmap:node/7204814162'),
  ('catalogo-cataluna:estaciones:node-7204816588', 'Estación de tren de Martorell - Central – Plaça de Martí Flores', 'Tren', '08114', 'Plaça de Martí Flores', '08760', 41.47935, 1.92572, 'address', 'openstreetmap:node/7204816588'),
  ('catalogo-cataluna:estaciones:node-7204816702', 'Estación de tren de Gelida – Polígon Industrial la Gelidense', 'Tren', '08091', 'Polígon Industrial la Gelidense 1', '08790', 41.44862, 1.86538, 'address', 'openstreetmap:node/7204816702'),
  ('catalogo-cataluna:estaciones:node-7204816721', 'Estación de tren de Sant Sadurní d''Anoia – Carrer de Joan Sala', 'Tren', '08240', 'Carrer de Joan Sala', '08770', 41.42033, 1.79468, 'address', 'openstreetmap:node/7204816721'),
  ('catalogo-cataluna:estaciones:node-7204816738', 'Estación de tren de la Granada – Carrer de l''Estació', 'Tren', '08094', 'Carrer de l''Estació 151', '08792', 41.3709, 1.72523, 'address', 'openstreetmap:node/7204816738'),
  ('catalogo-cataluna:estaciones:node-7204816739', 'Estación de tren de Vilafranca del Penedès – Carrer del Comerç', 'Tren', '08305', 'Carrer del Comerç 25', '08720', 41.34462, 1.70338, 'address', 'openstreetmap:node/7204816739'),
  ('catalogo-cataluna:estaciones:node-7204816744', 'Estación de tren de els Monjos (Santa Margarida i els Monjos) – Carrer de l''Estació', 'Tren', '08251', 'Carrer de l''Estació 5', '08730', 41.31459, 1.66009, 'address', 'openstreetmap:node/7204816744'),
  ('catalogo-cataluna:estaciones:node-7204816752', 'Estación de tren de Cubelles – Avinguda dels Països Catalans', 'Tren', '08074', 'Avinguda dels Països Catalans 55', '08880', 41.20421, 1.6761, 'address', 'openstreetmap:node/7204816752'),
  ('catalogo-cataluna:estaciones:node-7206954493', 'Estación de tren de Mataró – Avinguda del Maresme / N-2', 'Tren', '08121', 'Avinguda del Maresme / N-2', '08301', 41.53305, 2.44552, 'address', 'openstreetmap:node/7206954493'),
  ('catalogo-cataluna:estaciones:node-7206954494', 'Estación de tren de Vilassar de Mar – Carrer Sant Jaume', 'Tren', '08219', 'Carrer Sant Jaume 19', '08340', 41.50049, 2.38983, 'address', 'openstreetmap:node/7206954494'),
  ('catalogo-cataluna:estaciones:node-7206954495', 'Estación de tren de Premià de Mar – Camí Ral', 'Tren', '08172', 'Camí Ral 21', '08330', 41.48761, 2.35492, 'address', 'openstreetmap:node/7206954495'),
  ('catalogo-cataluna:estaciones:node-7206954497', 'Estación de tren de el Masnou – Carrer Mossèn Jacint Verdaguer', 'Tren', '08118', 'Carrer Mossèn Jacint Verdaguer 30', '08320', 41.47691, 2.31042, 'address', 'openstreetmap:node/7206954497'),
  ('catalogo-cataluna:estaciones:node-7206954498', 'Estación de tren de Montgat Nord – Camí Ral', 'Tren', '08126', 'Camí Ral', NULL, 41.46874, 2.28686, 'address', 'openstreetmap:node/7206954498'),
  ('catalogo-cataluna:estaciones:node-7206954501', 'Estación de tren de Montgat – Carretera de Mataró', 'Tren', '08126', 'Carretera de Mataró 79', '08390', 41.46291, 2.27221, 'address', 'openstreetmap:node/7206954501'),
  ('catalogo-cataluna:estaciones:node-7206954502', 'Estación de tren de Badalona – Carrer de Sant Isidre', 'Tren', '08015', 'Carrer de Sant Isidre 5', '08912', 41.44571, 2.2491, 'address', 'openstreetmap:node/7206954502'),
  ('catalogo-cataluna:estaciones:node-7206954503', 'Estación de tren de Sant Adrià de Besòs – Avinguda d''Eduard Maristany', 'Tren', '08194', 'Avinguda d''Eduard Maristany 93', '08930', 41.42436, 2.23057, 'address', 'openstreetmap:node/7206954503'),
  ('catalogo-cataluna:estaciones:node-7209331935', 'Estación de tren de Sant Cugat Centre (Sant Cugat del Vallès) – Plaça de Lluís Millet', 'Tren', '08205', 'Plaça de Lluís Millet', '08174', 41.46797, 2.07824, 'address', 'openstreetmap:node/7209331935'),
  ('catalogo-cataluna:estaciones:node-7209331936', 'Estación de tren de Sant Joan (Sant Cugat del Vallès) – Carrer de Jesús Serra i Santamans', 'Tren', '08205', 'Carrer de Jesús Serra i Santamans', NULL, 41.49019, 2.07648, 'address', 'openstreetmap:node/7209331936'),
  ('catalogo-cataluna:estaciones:node-7209331937', 'Estación de tren de Montcada i Reixac - Santa Maria – Carrer de l''Alzina', 'Tren', '08125', 'Carrer de l''Alzina 2', '08110', 41.48125, 2.16713, 'address', 'openstreetmap:node/7209331937'),
  ('catalogo-cataluna:estaciones:node-7209331938', 'Estación de tren de Cerdanyola del Vallès – Avinguda de Catalunya', 'Tren', '08266', 'Avinguda de Catalunya 17', '08290', 41.49263, 2.14762, 'address', 'openstreetmap:node/7209331938'),
  ('catalogo-cataluna:estaciones:node-7209331959', 'Estación de tren de Cerdanyola-Universitat (Cerdanyola del Vallès)', 'Tren', '08266', NULL, NULL, 41.49709, 2.11512, 'address', 'openstreetmap:node/7209331959'),
  ('catalogo-cataluna:estaciones:node-7209331964', 'Estación de tren de Sant Cugat Coll Favà (Sant Cugat del Vallès) – Ronda Nord', 'Tren', '08205', 'Ronda Nord', NULL, 41.48116, 2.0797, 'address', 'openstreetmap:node/7209331964'),
  ('catalogo-cataluna:estaciones:node-7209349799', 'Estación de tren de Rubí Can Vallhonrat', 'Tren', '08184', NULL, NULL, 41.47536, 2.03715, 'address', 'openstreetmap:node/7209349799'),
  ('catalogo-cataluna:estaciones:node-7226723675', 'Estación de tren de Molins de Rei – Carrer del Carril', 'Tren', '08123', 'Carrer del Carril 15', '08750', 41.40995, 2.02099, 'address', 'openstreetmap:node/7226723675'),
  ('catalogo-cataluna:estaciones:node-7229128643', 'Estación de tren de Pineda de Mar – Carrer de l''Església 1-11', 'Tren', '08163', 'Carrer de l''Església 1-11', '08397', 41.62236, 2.69361, 'address', 'openstreetmap:node/7229128643'),
  ('catalogo-cataluna:estaciones:node-7229212777', 'Estación de tren de Montmeló – Carrer Primer de Maig', 'Tren', '08135', 'Carrer Primer de Maig', NULL, 41.54972, 2.24538, 'address', 'openstreetmap:node/7229212777'),
  ('catalogo-cataluna:estaciones:node-7229212778', 'Estación de tren de Granollers Centre – Plaça Josep Serrat i Bonastre', 'Tren', '08096', 'Plaça Josep Serrat i Bonastre', NULL, 41.59965, 2.29161, 'address', 'openstreetmap:node/7229212778'),
  ('catalogo-cataluna:estaciones:node-7396279594', 'Estación de tren de Caldes d''Estrac – Baixada de l''estació', 'Tren', '08032', 'Baixada de l''estació 1', '08394', 41.56844, 2.52603, 'address', 'openstreetmap:node/7396279594'),
  ('catalogo-cataluna:estaciones:node-7396279600', 'Estación de tren de Sant Andreu de Llavaneres – Avinguda del Maresme', 'Tren', '08197', 'Avinguda del Maresme', NULL, 41.5554, 2.49837, 'address', 'openstreetmap:node/7396279600'),
  ('catalogo-cataluna:estaciones:node-7399936592', 'Estación de tren de Calella – Carrer d''Anselm Clavè', 'Tren', '08035', 'Carrer d''Anselm Clavè', NULL, 41.61471, 2.66657, 'address', 'openstreetmap:node/7399936592'),
  ('catalogo-cataluna:estaciones:node-7399936636', 'Estación de tren de Sant Pol de Mar – Carrer Ferrocarril', 'Tren', '08235', 'Carrer Ferrocarril 8', '08395', 41.60163, 2.62465, 'address', 'openstreetmap:node/7399936636'),
  ('catalogo-cataluna:estaciones:node-7399936644', 'Estación de tren de Canet de Mar – Carrer del Mar', 'Tren', '08040', 'Carrer del Mar 17', '08360', 41.58645, 2.58115, 'address', 'openstreetmap:node/7399936644'),
  ('catalogo-cataluna:estaciones:node-7399936645', 'Estación de tren de Arenys de Mar – Carrer de la Platja de Cassà', 'Tren', '08006', 'Carrer de la Platja de Cassà 38', '08350', 41.57741, 2.54942, 'address', 'openstreetmap:node/7399936645'),
  ('catalogo-cataluna:estaciones:node-7403526276', 'Estación de tren de Tordera – Carrer D', 'Tren', '08284', 'Carrer D', NULL, 41.70705, 2.71948, 'address', 'openstreetmap:node/7403526276'),
  ('catalogo-cataluna:estaciones:node-7403545894', 'Estación de tren de Malgrat de Mar – Carrer de Marià Cubí', 'Tren', '08110', 'Carrer de Marià Cubí 82', '08380', 41.64153, 2.7414, 'address', 'openstreetmap:node/7403545894'),
  ('catalogo-cataluna:estaciones:node-7482996432', 'Estación de tren de Montcada i Reixac – carrer de Colon', 'Tren', '08125', 'carrer de Colon 1', '08110', 41.48405, 2.18825, 'address', 'openstreetmap:node/7482996432'),
  ('catalogo-cataluna:estaciones:node-7482996448', 'Estación de tren de les Franqueses - Granollers Nord (les Franqueses del Vallès) – Plaça Espanya', 'Tren', '08086', 'Plaça Espanya 19', '08520', 41.61723, 2.29444, 'address', 'openstreetmap:node/7482996448'),
  ('catalogo-cataluna:estaciones:node-7482996449', 'Estación de tren de Cardedeu – Avinguda del Rei En Jaume', 'Tren', '08046', 'Avinguda del Rei En Jaume 4', '08440', 41.63642, 2.35618, 'address', 'openstreetmap:node/7482996449'),
  ('catalogo-cataluna:estaciones:node-7482996450', 'Estación de tren de Llinars del Vallès – Carrer de Montserrat Cullell', 'Tren', '08106', 'Carrer de Montserrat Cullell', '08450', 41.63791, 2.4046, 'address', 'openstreetmap:node/7482996450'),
  ('catalogo-cataluna:estaciones:node-7482996465', 'Estación de tren de Sant Celoni – Plaça de l''Estació', 'Tren', '08202', 'Plaça de l''Estació', NULL, 41.68565, 2.49097, 'address', 'openstreetmap:node/7482996465'),
  ('catalogo-cataluna:estaciones:node-7482996466', 'Estación de tren de Gualba', 'Tren', '08097', NULL, NULL, 41.71796, 2.53893, 'address', 'openstreetmap:node/7482996466'),
  ('catalogo-cataluna:estaciones:node-7498825440', 'Estación de tren de la Llagosta – Carrer del Montseny', 'Tren', '08105', 'Carrer del Montseny', NULL, 41.51043, 2.19986, 'address', 'openstreetmap:node/7498825440'),
  ('catalogo-cataluna:estaciones:node-7512362027', 'Estación de tren de Sant Vicenç de Castellet – Passeig de Pau Casals', 'Tren', '08262', 'Passeig de Pau Casals', '08295', 41.66886, 1.86232, 'address', 'openstreetmap:node/7512362027'),
  ('catalogo-cataluna:estaciones:node-7512362033', 'Estación de tren de Castellbell i el Vilar - Monistrol de Montserrat', 'Tren', '08053', NULL, NULL, 41.62884, 1.86895, 'address', 'openstreetmap:node/7512362033'),
  ('catalogo-cataluna:estaciones:node-7512362034', 'Estación de tren de Vacarisses – camí del Palà', 'Tren', '08291', 'camí del Palà 3', '08233', 41.60189, 1.89392, 'address', 'openstreetmap:node/7512362034'),
  ('catalogo-cataluna:estaciones:node-7512362035', 'Estación de tren de Vacarisses - Torreblanca – Passeig de l''Estació de Torreblanca', 'Tren', '08291', 'Passeig de l''Estació de Torreblanca 5', '08233', 41.58692, 1.91695, 'address', 'openstreetmap:node/7512362035'),
  ('catalogo-cataluna:estaciones:node-7512362036', 'Estación de tren de Viladecavalls – Carrer de Joan XXIII', 'Tren', '08300', 'Carrer de Joan XXIII', '08232', 41.5639, 1.95707, 'address', 'openstreetmap:node/7512362036'),
  ('catalogo-cataluna:estaciones:node-7512362037', 'Estación de tren de Sant Miquel de Gonteres (Viladecavalls) – Carrer del Baixador', 'Tren', '08300', 'Carrer del Baixador', NULL, 41.56912, 1.97399, 'address', 'openstreetmap:node/7512362037'),
  ('catalogo-cataluna:estaciones:node-7512362038', 'Terrassa Estació del Nord – Carrer dels Ferroviaris', 'Tren', '08279', 'Carrer dels Ferroviaris 24', '08225', 41.5704, 2.01608, 'address', 'openstreetmap:node/7512362038'),
  ('catalogo-cataluna:estaciones:node-7512362040', 'Estación de tren de Terrassa Est – Passeig del Camp del Roure', 'Tren', '08279', 'Passeig del Camp del Roure 8', '08227', 41.56745, 2.03974, 'address', 'openstreetmap:node/7512362040'),
  ('catalogo-cataluna:estaciones:node-7512362042', 'Estación de tren de Sabadell Nord – Plaça d''Espanya', 'Tren', '08187', 'Plaça d''Espanya', '08207', 41.56187, 2.09611, 'address', 'openstreetmap:node/7512362042'),
  ('catalogo-cataluna:estaciones:node-7512362043', 'Estación de tren de Barberà del Vallès – Carrer d''Osona', 'Tren', '08252', 'Carrer d''Osona', '08210', 41.51357, 2.11825, 'address', 'openstreetmap:node/7512362043'),
  ('catalogo-cataluna:estaciones:node-7512362044', 'Estación de tren de Montcada i Reixac-Manresa – carretera Vella', 'Tren', '08125', 'carretera Vella 1', '08110', 41.4839, 2.18538, 'address', 'openstreetmap:node/7512362044'),
  ('catalogo-cataluna:estaciones:node-7512362045', 'Estación de tren de Montcada Bifurcació (Montcada i Reixac) – Carrer de la Bateria', 'Tren', '08125', 'Carrer de la Bateria', '08110', 41.46993, 2.18003, 'address', 'openstreetmap:node/7512362045'),
  ('catalogo-cataluna:estaciones:node-7515916368', 'Estación de tren de Colònia Güell (Santa Coloma de Cervelló) – Camí Agricola Paral·lel a la BV2002', 'Tren', '08244', 'Camí Agricola Paral·lel a la BV2002', '08690', 41.3641, 2.03161, 'address', 'openstreetmap:node/7515916368'),
  ('catalogo-cataluna:estaciones:node-7515916369', 'Estación de tren de Santa Coloma de Cervelló – Carrer Antoni Sàbat Amat', 'Tren', '08244', 'Carrer Antoni Sàbat Amat', '08690', 41.3702, 2.0239, 'address', 'openstreetmap:node/7515916369'),
  ('catalogo-cataluna:estaciones:node-7515916370', 'Estación de tren de Sant Vicenç dels Horts – Carrer de Ferrés i Costa', 'Tren', '08263', 'Carrer de Ferrés i Costa 44', '08620', 41.3881, 2.01238, 'address', 'openstreetmap:node/7515916370'),
  ('catalogo-cataluna:estaciones:node-7515916371', 'Estación de tren de Sant Andreu de la Barca – Carrer Verge del Pilar', 'Tren', '08196', 'Carrer Verge del Pilar 5', '08740', 41.44684, 1.97309, 'address', 'openstreetmap:node/7515916371'),
  ('catalogo-cataluna:estaciones:node-7515916372', 'Estación de tren de el Palau (Sant Andreu de la Barca) – Carrer de l''Anoia', 'Tren', '08196', 'Carrer de l''Anoia', '08740', 41.45564, 1.96256, 'address', 'openstreetmap:node/7515916372'),
  ('catalogo-cataluna:estaciones:node-7515916373', 'Estación de tren de Martorell - Vila | Castellbisbal – Carretera antiga de Martorell', 'Tren', '08054', 'Carretera antiga de Martorell', '08755', 41.47645, 1.93916, 'address', 'openstreetmap:node/7515916373'),
  ('catalogo-cataluna:estaciones:node-7515916374', 'Estación de tren de Abrera – Carrer de Sitges', 'Tren', '08001', 'Carrer de Sitges', NULL, 41.52259, 1.90683, 'address', 'openstreetmap:node/7515916374'),
  ('catalogo-cataluna:estaciones:node-7515916375', 'Estación de tren de Olesa de Montserrat – Carrer de Barcelona', 'Tren', '08147', 'Carrer de Barcelona', '08640', 41.54147, 1.88791, 'address', 'openstreetmap:node/7515916375'),
  ('catalogo-cataluna:estaciones:node-7515916376', 'Estación de tren de Monistrol de Montserrat – Carrer del Pla', 'Tren', '08127', 'Carrer del Pla', NULL, 41.60912, 1.85031, 'address', 'openstreetmap:node/7515916376'),
  ('catalogo-cataluna:estaciones:node-7515916377', 'Estación de tren de Castellbell i el Vilar', 'Tren', '08053', NULL, NULL, 41.64054, 1.85477, 'address', 'openstreetmap:node/7515916377'),
  ('catalogo-cataluna:estaciones:node-7515916379', 'Estación de tren de Manresa Baixador – Carrer de Camps i Fabrés', 'Tren', '08113', 'Carrer de Camps i Fabrés 13', '08242', 41.73145, 1.82796, 'address', 'openstreetmap:node/7515916379'),
  ('catalogo-cataluna:estaciones:node-7524054395', 'Estación de tren de Balenyà - Tona - Seva – Carrer del Bisbe Perelló', 'Tren', '08269', 'Carrer del Bisbe Perelló', NULL, 41.84189, 2.24726, 'address', 'openstreetmap:node/7524054395'),
  ('catalogo-cataluna:estaciones:node-7524054396', 'Estación de tren de Balenyà - Els Hostalets – Carrer de l''Estació', 'Tren', '08017', 'Carrer de l''Estació 2', '08550', 41.81482, 2.23336, 'address', 'openstreetmap:node/7524054396'),
  ('catalogo-cataluna:estaciones:node-7524054397', 'Estación de tren de Centelles – Plaça de l''Estació', 'Tren', '08067', 'Plaça de l''Estació', NULL, 41.79941, 2.22281, 'address', 'openstreetmap:node/7524054397'),
  ('catalogo-cataluna:estaciones:node-7524054398', 'Estación de tren de Sant Martí de Centelles – Carrer Piborrell', 'Tren', '08224', 'Carrer Piborrell', NULL, 41.76072, 2.24919, 'address', 'openstreetmap:node/7524054398'),
  ('catalogo-cataluna:estaciones:node-7524054399', 'Estación de tren de Figaró (Figaró-Montmany) – Carretera de Montmany', 'Tren', '08134', 'Carretera de Montmany', '08590', 41.72089, 2.27156, 'address', 'openstreetmap:node/7524054399'),
  ('catalogo-cataluna:estaciones:node-7524054400', 'Estación de tren de la Garriga – Ronda del Carril', 'Tren', '08088', 'Ronda del Carril', NULL, 41.68457, 2.28864, 'address', 'openstreetmap:node/7524054400'),
  ('catalogo-cataluna:estaciones:node-7524054401', 'Estación de tren de les Franqueses del Vallès – Carretera de Ribes', 'Tren', '08086', 'Carretera de Ribes', '08520', 41.62985, 2.29497, 'address', 'openstreetmap:node/7524054401'),
  ('catalogo-cataluna:estaciones:node-7524054408', 'Estación de tren de Granollers - Canovelles – Carrer Joan Maragall', 'Tren', '08096', 'Carrer Joan Maragall', NULL, 41.61124, 2.27658, 'address', 'openstreetmap:node/7524054408'),
  ('catalogo-cataluna:estaciones:node-7524054409', 'Estación de tren de Parets del Vallès – Avinguda de l''Estació', 'Tren', '08159', 'Avinguda de l''Estació', '08150', 41.55604, 2.22591, 'address', 'openstreetmap:node/7524054409'),
  ('catalogo-cataluna:estaciones:node-7524054410', 'Estación de tren de Mollet-Santa Rosa (Mollet del Vallès) – Carrer del Poeta Joan Maragall', 'Tren', '08124', 'Carrer del Poeta Joan Maragall', '08100', 41.53646, 2.20597, 'address', 'openstreetmap:node/7524054410'),
  ('catalogo-cataluna:estaciones:node-7524054411', 'Estación de tren de Santa Perpètua de Mogoda La Florida – Avinguda de l''Estació', 'Tren', '08260', 'Avinguda de l''Estació', NULL, 41.52172, 2.19426, 'address', 'openstreetmap:node/7524054411'),
  ('catalogo-cataluna:estaciones:node-7524054412', 'Estación de tren de Montcada-Ripollet (Montcada i Reixac) – Carrer d''Aragó', 'Tren', '08125', 'Carrer d''Aragó 68', '08110', 41.49674, 2.1821, 'address', 'openstreetmap:node/7524054412'),
  ('catalogo-cataluna:estaciones:node-7527423076', 'Estación de tren de Borgonyà (Sant Vicenç de Torelló) – Carrer Borgonyà', 'Tren', '08265', 'Carrer Borgonyà', '08571', 42.06467, 2.24193, 'address', 'openstreetmap:node/7527423076'),
  ('catalogo-cataluna:estaciones:node-7527423077', 'Estación de tren de Torelló – plaça de l''Estació', 'Tren', '08285', 'plaça de l''Estació', NULL, 42.05214, 2.25998, 'address', 'openstreetmap:node/7527423077'),
  ('catalogo-cataluna:estaciones:node-7527423078', 'Estación de tren de Manlleu – Passeig de l''Estació', 'Tren', '08112', 'Passeig de l''Estació', NULL, 41.99986, 2.26911, 'address', 'openstreetmap:node/7527423078'),
  ('catalogo-cataluna:estaciones:node-8482997018', 'Estació d''Autobusos Barcelona Sants – Carrer de Viriat', 'Autobús', '08019', 'Carrer de Viriat', '08014', 41.37989, 2.13934, 'address', 'openstreetmap:node/8482997018'),
  ('catalogo-cataluna:estaciones:node-8870114638', 'Estación de tren de Viladecans – Carrer de la Tecnologia', 'Tren', '08301', 'Carrer de la Tecnologia', '08840', 41.30929, 2.02743, 'address', 'openstreetmap:node/8870114638'),
  ('catalogo-cataluna:estaciones:node-9218144258', 'Estación de tren de Mollet-Sant Fost (Mollet del Vallès) – Ronda d''Orient', 'Tren', '08124', 'Ronda d''Orient 1', '08100', 41.53334, 2.21767, 'address', 'openstreetmap:node/9218144258'),
  ('catalogo-cataluna:estaciones:node-968361236', 'Estación de tren de l''Hospitalet de Llobregat – Avinguda de Josep Tarradellas i Joan', 'Tren', '08101', 'Avinguda de Josep Tarradellas i Joan', '08901', 41.36424, 2.10094, 'address', 'openstreetmap:node/968361236'),
  ('catalogo-cataluna:estaciones:node-9757864300', 'Estación de tren de Rubí Centre – Carrer de Jaume Balmes', 'Tren', '08184', 'Carrer de Jaume Balmes', '08191', 41.48616, 2.03161, 'address', 'openstreetmap:node/9757864300'),
  ('catalogo-cataluna:estaciones:node-9757864301', 'Estación de tren de Mira-sol (Sant Cugat del Vallès) – Plaça Ausias March', 'Tren', '08205', 'Plaça Ausias March 2', '08195', 41.46922, 2.06191, 'address', 'openstreetmap:node/9757864301'),
  ('catalogo-cataluna:estaciones:node-9757864302', 'Estación de tren de Hospital General (Sant Cugat del Vallès) – Avinguda del Ferrocarril', 'Tren', '08205', 'Avinguda del Ferrocarril', NULL, 41.47625, 2.04644, 'address', 'openstreetmap:node/9757864302'),
  ('catalogo-cataluna:estaciones:node-9757864303', 'Estación de tren de Les Fonts (Terrassa) – Carrer de la Floresta', 'Tren', '08279', 'Carrer de la Floresta', NULL, 41.52871, 2.03346, 'address', 'openstreetmap:node/9757864303'),
  ('catalogo-cataluna:estaciones:node-9757864305', 'Estación de tren de Vallparadís Universitat (Terrassa) – Plaça dels Drets Humans', 'Tren', '08279', 'Plaça dels Drets Humans 1', '08222', 41.56336, 2.01905, 'address', 'openstreetmap:node/9757864305'),
  ('catalogo-cataluna:estaciones:node-9757864306', 'Estación de tren de Terrassa Nacions Unides – Avinguda del Parlament', 'Tren', '08279', 'Avinguda del Parlament', '08225', 41.5804, 2.01335, 'address', 'openstreetmap:node/9757864306'),
  ('catalogo-cataluna:estaciones:node-9757864307', 'Estación de tren de Valldoreix (Sant Cugat del Vallès) – Avinguda de Villadelprat', 'Tren', '08205', 'Avinguda de Villadelprat', NULL, 41.45784, 2.06835, 'address', 'openstreetmap:node/9757864307'),
  ('catalogo-cataluna:estaciones:node-9757864308', 'Estación de tren de La Floresta (Sant Cugat del Vallès) – passeig de la Floresta', 'Tren', '08205', 'passeig de la Floresta 9', '08198', 41.44486, 2.0732, 'address', 'openstreetmap:node/9757864308'),
  ('catalogo-cataluna:estaciones:node-9757864309', 'Estación de tren de Les Planes (Barcelona) – Plaça Major del Rectoret', 'Tren', '08019', 'Plaça Major del Rectoret 3', '08017', 41.4275, 2.09167, 'address', 'openstreetmap:node/9757864309'),
  ('catalogo-cataluna:estaciones:node-9757864310', 'Estación de tren de Baixador de Vallvidrera (Barcelona) – Carretera de Vallvidrera a les Planes 18-10', 'Tren', '08019', 'Carretera de Vallvidrera a les Planes 18-10', '08017', 41.42008, 2.09692, 'address', 'openstreetmap:node/9757864310'),
  ('catalogo-cataluna:estaciones:node-9767567865', 'Estación de tren de Sant Quirze (Sant Quirze del Vallès) – Passeig de la Bòbila', 'Tren', '08238', 'Passeig de la Bòbila', '08192', 41.52999, 2.08876, 'address', 'openstreetmap:node/9767567865'),
  ('catalogo-cataluna:estaciones:node-9767567866', 'Estación de tren de Bellaterra (Cerdanyola del Vallès) – Plaça del Pi', 'Tren', '08266', 'Plaça del Pi 3', '08193', 41.50084, 2.09058, 'address', 'openstreetmap:node/9767567866'),
  ('catalogo-cataluna:estaciones:node-9767580901', 'Estación de tren de La Creu Alta (Sabadell) – Carrer de Pi i Margall', 'Tren', '08187', 'Carrer de Pi i Margall 36', '08208', 41.55505, 2.10027, 'address', 'openstreetmap:node/9767580901'),
  ('catalogo-cataluna:estaciones:node-9899895971', 'Estación de tren de Vilanova del Camí – Carrer de la Indústria', 'Tren', '08302', 'Carrer de la Indústria 42', '08788', 41.57369, 1.64138, 'address', 'openstreetmap:node/9899895971'),
  ('catalogo-cataluna:estaciones:node-9899950741', 'Estación de tren de Capellades (Vallbona d''Anoia) – Carretera de l''Estació', 'Tren', '08292', 'Carretera de l''Estació', NULL, 41.52156, 1.69535, 'address', 'openstreetmap:node/9899950741'),
  ('catalogo-cataluna:estaciones:node-9899950743', 'Estación de tren de Vallbona d''Anoia – Carrer de la Pedrera', 'Tren', '08292', 'Carrer de la Pedrera 5', '08785', 41.52034, 1.70851, 'address', 'openstreetmap:node/9899950743'),
  ('catalogo-cataluna:estaciones:node-9899950745', 'Estación de tren de Masquefa – Plaça de Josep Maria Vila', 'Tren', '08119', 'Plaça de Josep Maria Vila', '08783', 41.50296, 1.8125, 'address', 'openstreetmap:node/9899950745'),
  ('catalogo-cataluna:estaciones:node-9899950749', 'Estación de tren de Sant Esteve Sesrovires – Passeig de l''Estació', 'Tren', '08208', 'Passeig de l''Estació', NULL, 41.49773, 1.87254, 'address', 'openstreetmap:node/9899950749'),
  ('catalogo-cataluna:estaciones:way-1227770973', 'Estacio d''Autobusos (Terrassa) – Carretera de Montcada', 'Autobús', '08279', 'Carretera de Montcada 2', '08224', 41.55677, 2.00799, 'address', 'openstreetmap:way/1227770973'),
  ('catalogo-cataluna:estaciones:way-135893177', 'Estación de tren de Tren de l''Oreneta (Barcelona) – Passatge de la Blada 14B', 'Tren', '08019', 'Passatge de la Blada 14B', '08017', 41.40057, 2.10826, 'address', 'openstreetmap:way/135893177'),
  ('catalogo-cataluna:estaciones:way-1552650524', 'Estación de tren de Barcelona-Plaça de Catalunya – Plaça de Catalunya', 'Tren', '08019', 'Plaça de Catalunya 9', '08002', 41.38758, 2.1692, 'address', 'openstreetmap:way/1552650524'),
  ('catalogo-cataluna:estaciones:way-210287466', 'Estación de autobuses de Parc mòbil (Cerdanyola del Vallès) – Travessera dels Turons', 'Autobús', '08266', 'Travessera dels Turons', NULL, 41.50373, 2.09419, 'address', 'openstreetmap:way/210287466'),
  ('catalogo-cataluna:estaciones:way-250376708', 'Estació d''Autobusos Barcelona Nord – Carrer d''Alí Bei 80-54', 'Autobús', '08019', 'Carrer d''Alí Bei 80-54', '08013', 41.39453, 2.1828, 'address', 'openstreetmap:way/250376708'),
  ('catalogo-cataluna:estaciones:way-265906664', 'Estació d''Autobusos de Vilafranca del Penedès – Avinguda de Vilanova i la Geltrú', 'Autobús', '08305', 'Avinguda de Vilanova i la Geltrú 2', '08720', 41.34175, 1.70172, 'address', 'openstreetmap:way/265906664'),
  ('catalogo-cataluna:estaciones:way-286852317', 'Estació d''Autobusos Fabra i Puig (Barcelona) – Avinguda Meridiana 408-410', 'Autobús', '08019', 'Avinguda Meridiana 408-410', '08030', 41.43154, 2.18309, 'address', 'openstreetmap:way/286852317'),
  ('catalogo-cataluna:estaciones:way-288492040', 'Estación de tren de Can Parellada (Masquefa) – Carrer de Josep Maria Valls', 'Tren', '08119', 'Carrer de Josep Maria Valls', NULL, 41.50219, 1.83081, 'address', 'openstreetmap:way/288492040'),
  ('catalogo-cataluna:estaciones:way-42505763', 'Estació d''Autobusos de Vic – Carrer del Pare Gallissà', 'Autobús', '08298', 'Carrer del Pare Gallissà', '08500', 41.9326, 2.24933, 'address', 'openstreetmap:way/42505763'),
  ('catalogo-cataluna:estaciones:way-480922932', 'Estación de tren de Can Mercader (Cornellà de Llobregat) – Carretera de l''Hospitalet', 'Tren', '08073', 'Carretera de l''Hospitalet', '08940', 41.35672, 2.08436, 'address', 'openstreetmap:way/480922932'),
  ('catalogo-cataluna:estaciones:way-509890830', 'Estació d''autobusos de Caldes de Montbui – carrer Santa Teresa', 'Autobús', '08033', 'carrer Santa Teresa 8', '08140', 41.62946, 2.16595, 'address', 'openstreetmap:way/509890830'),
  ('catalogo-cataluna:estaciones:way-561901333', 'Estación de tren de Sabadell Centre – Carrer d''Alfons Sala', 'Tren', '08187', 'Carrer d''Alfons Sala 147', '08202', 41.54641, 2.11589, 'address', 'openstreetmap:way/561901333'),
  ('catalogo-cataluna:estaciones:way-569092839', 'Estació d''autobusos d''Igualada – Passeig Mossèn Jacint Verdaguer', 'Autobús', '08102', 'Passeig Mossèn Jacint Verdaguer', '08700', 41.57764, 1.63101, 'address', 'openstreetmap:way/569092839'),
  ('catalogo-cataluna:estaciones:way-580168958', 'Estació d''Autobusos de Sabadell – Carrer de l''Estació', 'Autobús', '08187', 'Carrer de l''Estació 40', '08202', 41.54742, 2.11515, 'address', 'openstreetmap:way/580168958'),
  ('catalogo-cataluna:estaciones:way-979373385', 'Estación de autobuses de Aeroport Barcelona T1 (el Prat de Llobregat) – T1 Sortides', 'Autobús', '08169', 'T1 Sortides', '08820', 41.28735, 2.07313, 'approximate', 'openstreetmap:way/979373385');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '08');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 08 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '08'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 185 THEN
    RAISE EXCEPTION 'Se esperaban 185 puntos de Estaciones en Barcelona, hay %', n;
  END IF;
END;
$$;

COMMIT;
