-- Carga de la categoría (varias) de La Rioja (provincia 26), trozo de la carga de Andalucía.
-- Origen: la-rioja-resto-la-rioja.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:39:03Z).
-- 199 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-10586376705', 'Oficina de Extranjería - Delegación del Gobierno Logroño – Avenida Solidaridad', NULL, '26089', 'Avenida Solidaridad 72', '26003', 42.45993, -2.43441, 'address', 'openstreetmap:node/10586376705'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-10784496787', 'Lidl Logroño – Calle Ingenieros Pino y Amorena', NULL, '26089', 'Calle Ingenieros Pino y Amorena 2', '26003', 42.45875, -2.44645, 'address', 'openstreetmap:node/10784496787'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-10895628491', 'BM Logroño – Avenida República Argentina', NULL, '26089', 'Avenida República Argentina 10', '26002', 42.46269, -2.44832, 'address', 'openstreetmap:node/10895628491'),
  ('Gimnasios', 'catalogo-la-rioja:la-rioja-resto:node-11031972149', 'Big Rhino CrossFit Logroño – Calle Soto del Galo', NULL, '26089', 'Calle Soto del Galo 14', '26009', 42.46852, -2.40616, 'address', 'openstreetmap:node/11031972149'),
  ('Gimnasios', 'catalogo-la-rioja:la-rioja-resto:node-11060570395', 'Parque calistenia Nájera – Paseo de San Julián', NULL, '26102', 'Paseo de San Julián', '26300', 42.41308, -2.73185, 'address', 'openstreetmap:node/11060570395'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225176433', 'Dia Albelda de Iregua – Calle de la Constitución', NULL, '26005', 'Calle de la Constitución 11', '26120', 42.35678, -2.47472, 'address', 'openstreetmap:node/11225176433'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225215917', 'Dia Logroño – Calle Huesca', NULL, '26089', 'Calle Huesca 31', '26002', 42.45944, -2.45127, 'address', 'openstreetmap:node/11225215917'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225220960', 'Dia Alberite – Calle Doctor Pío Sicilia', NULL, '26006', 'Calle Doctor Pío Sicilia 2', '26141', 42.40492, -2.44029, 'address', 'openstreetmap:node/11225220960'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225221131', 'Dia Arnedo – Calle de Santo Domingo', NULL, '26018', 'Calle de Santo Domingo 6', '26580', 42.22604, -2.10016, 'address', 'openstreetmap:node/11225221131'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225223307', 'Dia Rincón de Soto – Avenida de la Rioja', NULL, '26125', 'Avenida de la Rioja 6', '26550', 42.23202, -1.84999, 'address', 'openstreetmap:node/11225223307'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225223657', 'Dia Logroño – Avenida Doce Ligero de Artillería', NULL, '26089', 'Avenida Doce Ligero de Artillería 8', '26004', 42.46741, -2.43766, 'address', 'openstreetmap:node/11225223657'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225228753', 'Dia Calahorra – Calle Bebricio', NULL, '26036', 'Calle Bebricio 58', '26500', 42.30581, -1.96913, 'address', 'openstreetmap:node/11225228753'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225239542', 'Dia Calahorra – Plaza del Raso', NULL, '26036', 'Plaza del Raso 2', '26500', 42.30119, -1.96158, 'address', 'openstreetmap:node/11225239542'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11225247438', 'Dia Calahorra – Avenida de la Estación', NULL, '26036', 'Avenida de la Estación', '26500', 42.30815, -1.95785, 'address', 'openstreetmap:node/11225247438'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11252514087', 'Lupa Logroño – Avenida Gonzalo de Berceo', NULL, '26089', 'Avenida Gonzalo de Berceo 18', '26005', 42.46604, -2.4568, 'address', 'openstreetmap:node/11252514087'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-11682311788', 'Alcampo Logroño – Calle Duques de Nájera', NULL, '26089', 'Calle Duques de Nájera 49', '26005', 42.45995, -2.45828, 'address', 'openstreetmap:node/11682311788'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-11901414769', 'Ayuntamiento de Villanueva de Cameros – Plaza de la Constitución', NULL, '26169', 'Plaza de la Constitución', '26123', 42.16736, -2.65012, 'address', 'openstreetmap:node/11901414769'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-12068680273', 'Co aliment Ortigosa de Cameros – calle del arco', NULL, '26112', 'calle del arco 5', NULL, 42.17602, -2.70502, 'address', 'openstreetmap:node/12068680273'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-12150539285', 'BM Ezcaray – Calle Santiago Lope', NULL, '26061', 'Calle Santiago Lope 1', '26280', 42.3237, -3.01454, 'address', 'openstreetmap:node/12150539285'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-12173990623', 'Ayuntamiento de Arnedillo – Plaza Félix Merino', NULL, '26017', 'Plaza Félix Merino', NULL, 42.21215, -2.23511, 'address', 'openstreetmap:node/12173990623'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-12205855035', 'Ayuntamiento de Alberite – Calle Ortega y Gasset', NULL, '26006', 'Calle Ortega y Gasset', '26141', 42.4063, -2.44136, 'address', 'openstreetmap:node/12205855035'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-12422962110', 'Dia Logroño – Calle Clavijo', NULL, '26089', 'Calle Clavijo 63', '26007', 42.45309, -2.46443, 'address', 'openstreetmap:node/12422962110'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-12515881769', 'Ayuntamiento de Laguna de Cameros – Calle Ranocales', NULL, '26082', 'Calle Ranocales 12', '26135', 42.17609, -2.5404, 'address', 'openstreetmap:node/12515881769'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-12634609154', 'Coviran Cenicero – Calle Martín Bastida', NULL, '26046', 'Calle Martín Bastida 5', '26350', 42.4811, -2.64324, 'address', 'openstreetmap:node/12634609154'),
  ('Bricolaje', 'catalogo-la-rioja:la-rioja-resto:node-13048046219', 'All Natural Granel Logroño – Avenida Pérez Galdós', NULL, '26089', 'Avenida Pérez Galdós 47', '26002', 42.46226, -2.45292, 'address', 'openstreetmap:node/13048046219'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13208147843', 'SEPE Oficina de prestaciones Logroño – Calle Presidente Leopoldo Calvo Sotelo', NULL, '26089', 'Calle Presidente Leopoldo Calvo Sotelo 25', '26003', 42.46402, -2.44115, 'address', 'openstreetmap:node/13208147843'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13208228035', 'Oficina de Empleo La Rioja Logroño – Calle Presidente Leopoldo Calvo Sotelo', NULL, '26089', 'Calle Presidente Leopoldo Calvo Sotelo 29', '26003', 42.464, -2.44082, 'address', 'openstreetmap:node/13208228035'),
  ('Gimnasios', 'catalogo-la-rioja:la-rioja-resto:node-13347671655', 'Torino Box Logroño – Calle del Candado', NULL, '26089', 'Calle del Candado 4', '26009', 42.47529, -2.40462, 'address', 'openstreetmap:node/13347671655'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13389111635', 'Ayuntamiento de Lagunilla del Jubera – Calle Ayuntamiento', NULL, '26083', 'Calle Ayuntamiento 3', NULL, 42.33389, -2.32142, 'address', 'openstreetmap:node/13389111635'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13390094475', 'Ayuntamiento de Foncea – Calle Crucero de la Plaza', NULL, '26062', 'Calle Crucero de la Plaza 15', NULL, 42.61448, -3.03762, 'address', 'openstreetmap:node/13390094475'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13390315637', 'Ayuntamiento de Ortigosa de Cameros – Plaza Alberta Martínez', NULL, '26112', 'Plaza Alberta Martínez 4', NULL, 42.17575, -2.7052, 'address', 'openstreetmap:node/13390315637'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13390341713', 'Ayuntamiento de Castroviejo – Plaza Vicente Fernández Lacalle', NULL, '26044', 'Plaza Vicente Fernández Lacalle 2', NULL, 42.32976, -2.6616, 'address', 'openstreetmap:node/13390341713'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13392198429', 'Ayuntamiento de Alesón – Calle Donantes de Sangre', NULL, '26010', 'Calle Donantes de Sangre 2', NULL, 42.40467, -2.69047, 'address', 'openstreetmap:node/13392198429'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13393417006', 'Ayuntamiento de Cellorigo – Calle de Arriba', NULL, '26045', 'Calle de Arriba 26a', NULL, 42.62736, -3.00052, 'address', 'openstreetmap:node/13393417006'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13399470995', 'Ayuntamiento de Grañón – Calle Mayor', NULL, '26069', 'Calle Mayor 2', '26259', 42.45057, -3.02723, 'address', 'openstreetmap:node/13399470995'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13399620718', 'Ayuntamiento de Bobadilla – Plaza Mayor', NULL, '26031', 'Plaza Mayor 1', NULL, 42.31759, -2.75933, 'address', 'openstreetmap:node/13399620718'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13401448955', 'Ayuntamiento de Corporales – Calle Real', NULL, '26055', 'Calle Real 22', NULL, 42.43277, -2.99496, 'address', 'openstreetmap:node/13401448955'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-1340274912', 'Mercadona Logroño – Calle Marqués de Murrieta', NULL, '26089', 'Calle Marqués de Murrieta 16', '26005', 42.46575, -2.45318, 'address', 'openstreetmap:node/1340274912'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-1340275073', 'Alcampo Logroño – Avenida Juan XXIII', NULL, '26089', 'Avenida Juan XXIII 3', '26003', 42.46548, -2.44141, 'address', 'openstreetmap:node/1340275073'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-1340276107', 'Suma Navarrete – Calle Abadía', NULL, '26105', 'Calle Abadía 1', '26370', 42.42961, -2.56356, 'address', 'openstreetmap:node/1340276107'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13410845564', 'Ayuntamiento de Tricio – Calle San Miguel', NULL, '26157', 'Calle San Miguel', NULL, 42.40139, -2.7194, 'address', 'openstreetmap:node/13410845564'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13421920388', 'Ayuntamiento de Grávalos – Plaza José María Fraile', NULL, '26070', 'Plaza José María Fraile 2', NULL, 42.10746, -2.00092, 'address', 'openstreetmap:node/13421920388'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13426816513', 'Ayuntamiento de Badarán – Plaza Conde Badarán', NULL, '26023', 'Plaza Conde Badarán 1', NULL, 42.36794, -2.80861, 'address', 'openstreetmap:node/13426816513'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13447576847', 'Ayuntamiento de Nestares – Calle Castroviejo', NULL, '26106', 'Calle Castroviejo', NULL, 42.27047, -2.61885, 'address', 'openstreetmap:node/13447576847'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13447584735', 'Ayuntamiento de Tobía – Calle Real de Abajo', NULL, '26149', 'Calle Real de Abajo 8', NULL, 42.2979, -2.81577, 'address', 'openstreetmap:node/13447584735'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13447593866', 'Ayuntamiento de Nieva de Cameros – Calle Antonio Merino', NULL, '26107', 'Calle Antonio Merino 2', NULL, 42.21842, -2.66708, 'address', 'openstreetmap:node/13447593866'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13447598770', 'Ayuntamiento de Tirgo – Plaza de España', NULL, '26148', 'Plaza de España 1', '26211', 42.54587, -2.94963, 'address', 'openstreetmap:node/13447598770'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13447620029', 'Ayuntamiento de Viniegra de Arriba – Plaza Mayor', NULL, '26179', 'Plaza Mayor 1', NULL, 42.09536, -2.83342, 'address', 'openstreetmap:node/13447620029'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13447640452', 'Ayuntamiento de Villaverde de Rioja – General Azofra', NULL, '26176', 'General Azofra 1', NULL, 42.32073, -2.81391, 'address', 'openstreetmap:node/13447640452'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13447647272', 'Ayuntamiento de Viniegra de Abajo – Calle Venancio Moreno', NULL, '26178', 'Calle Venancio Moreno 1', '26329', 42.15217, -2.88948, 'address', 'openstreetmap:node/13447647272'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13448961788', 'Ayuntamiento de Medrano – Plaza Mayor', NULL, '26096', 'Plaza Mayor 1', NULL, 42.38265, -2.55407, 'address', 'openstreetmap:node/13448961788'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13450617742', 'Ayuntamiento de Santurdejo – Calle Real', NULL, '26141', 'Calle Real 71', NULL, 42.37834, -2.95486, 'address', 'openstreetmap:node/13450617742'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13563631093', 'Ayuntamiento de Briones – Plaza de España', NULL, '26034', 'Plaza de España 11', NULL, 42.54364, -2.78498, 'address', 'openstreetmap:node/13563631093'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13563645250', 'Ayuntamiento de Brieva de Cameros – Plaza de Pedro Duro', NULL, '26032', 'Plaza de Pedro Duro 8', NULL, 42.16477, -2.79454, 'address', 'openstreetmap:node/13563645250'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13563666949', 'Ayuntamiento de Briñas – 1', NULL, '26033', '1', NULL, 42.60121, -2.8306, 'address', 'openstreetmap:node/13563666949'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-13965789368', 'Ayuntamiento de Sajazarra – Calle de la Rosa', NULL, '26128', 'Calle de la Rosa', NULL, 42.58857, -2.96053, 'address', 'openstreetmap:node/13965789368'),
  ('Bricolaje', 'catalogo-la-rioja:la-rioja-resto:node-14063469292', 'Saltoki Logroño – Calle de la Cordonera', NULL, '26089', 'Calle de la Cordonera', NULL, 42.45551, -2.40653, 'address', 'openstreetmap:node/14063469292'),
  ('Bricolaje', 'catalogo-la-rioja:la-rioja-resto:node-14063481501', 'Saltoki Calahorra – Calle Padre Jose Aguirre', NULL, '26036', 'Calle Padre Jose Aguirre', '26500', 42.29354, -1.95137, 'address', 'openstreetmap:node/14063481501'),
  ('Bricolaje', 'catalogo-la-rioja:la-rioja-resto:node-1672000070', 'Ancar Caraldiaz Arnedo – Avda Numancia', NULL, '26018', 'Avda Numancia 12', '26580', 42.22367, -2.11463, 'address', 'openstreetmap:node/1672000070'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-1990901851', 'Autoservicio Nuria Navarrete – Calle de La Cruz', NULL, '26105', 'Calle de La Cruz 4', '26370', 42.42909, -2.56062, 'address', 'openstreetmap:node/1990901851'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-2314460288', 'Ayuntamiento de Villalba de Rioja – Calle de D. Pedro Ruiz del Castillo', NULL, '26166', 'Calle de D. Pedro Ruiz del Castillo', '26292', 42.61021, -2.88702, 'address', 'openstreetmap:node/2314460288'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-247252690', 'Lidl Calahorra – Carretera de San Adrián', NULL, '26036', 'Carretera de San Adrián', '26500', 42.31013, -1.95446, 'address', 'openstreetmap:node/247252690'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-2555639786', 'Gama Santo Domingo de la Calzada – Calle Mayor', NULL, '26138', 'Calle Mayor 32', '26250', 42.44093, -2.9514, 'address', 'openstreetmap:node/2555639786'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-264395093', 'Hiper Simply Calahorra – Calle Tilos', NULL, '26036', 'Calle Tilos', '26500', 42.30475, -1.96118, 'address', 'openstreetmap:node/264395093'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-2701403357', 'Dia Nájera – Calle Gonzalo de Berceo', NULL, '26102', 'Calle Gonzalo de Berceo 7', '26300', 42.41848, -2.73033, 'address', 'openstreetmap:node/2701403357'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-2701403359', 'Eroski City Nájera – Calle San Fernando', NULL, '26102', 'Calle San Fernando', '26300', 42.41736, -2.72949, 'address', 'openstreetmap:node/2701403359'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-2709555509', 'Lupa Fuenmayor – Avenida de la ciudad de Cenicero', NULL, '26064', 'Avenida de la ciudad de Cenicero', NULL, 42.46631, -2.56316, 'address', 'openstreetmap:node/2709555509'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-286460735', 'Ayuntamiento de Préjano – Calle Juan XXIII', NULL, '26119', 'Calle Juan XXIII', NULL, 42.18699, -2.1786, 'address', 'openstreetmap:node/286460735'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-2928932939', 'Lupa Santo Domingo de la Calzada – Plaza San Jerónimo Hermosilla', NULL, '26138', 'Plaza San Jerónimo Hermosilla', '26250', 42.43859, -2.95287, 'address', 'openstreetmap:node/2928932939'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-2964261397', 'Covirán Nájera – Calle Reino de Nájera', NULL, '26102', 'Calle Reino de Nájera 10', '26300', 42.41839, -2.72638, 'address', 'openstreetmap:node/2964261397'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-2964261565', 'Ayuntamiento de Nájera – Calle San Marcial 1-5', NULL, '26102', 'Calle San Marcial 1-5', '26300', 42.41592, -2.73442, 'address', 'openstreetmap:node/2964261565'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-2964261903', 'Alcampo Nájera – Calle Reino de Nájera', NULL, '26102', 'Calle Reino de Nájera 10', '26300', 42.41879, -2.7276, 'address', 'openstreetmap:node/2964261903'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-2968052983', 'Lupa Nájera – Paseo Los Curas', NULL, '26102', 'Paseo Los Curas 3', '26300', 42.4179, -2.72885, 'address', 'openstreetmap:node/2968052983'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-3142213660', 'Udaco-Alea Murillo de Río Leza – Calle Mayor', NULL, '26099', 'Calle Mayor', NULL, 42.40195, -2.3247, 'address', 'openstreetmap:node/3142213660'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-3374870496', 'Eroski Santo Domingo de la Calzada – Calle Madrid', NULL, '26138', 'Calle Madrid', '26250', 42.43877, -2.95448, 'address', 'openstreetmap:node/3374870496'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:node-3847170387', 'Centro de salud de Arnedo – Avda Benidorm', NULL, '26018', 'Avda Benidorm', '26580', 42.22766, -2.09473, 'address', 'openstreetmap:node/3847170387'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-3847251904', 'ALDI Arnedo – Calle Primavera', NULL, '26018', 'Calle Primavera', '26580', 42.23166, -2.09531, 'address', 'openstreetmap:node/3847251904'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-3880062513', 'Ayuntamiento de Aguilar del Río Alhama – Plaza España', NULL, '26003', 'Plaza España 4', '26530', 41.96159, -1.99346, 'address', 'openstreetmap:node/3880062513'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:node-3951735732', 'Centro de Salud de Navarrete – Calle Carretera de Entrena', NULL, '26105', 'Calle Carretera de Entrena 5', '26370', 42.4275, -2.56123, 'address', 'openstreetmap:node/3951735732'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-4197192639', 'Ayuntamiento de Bañares', NULL, '26024', NULL, NULL, 42.46844, -2.91111, 'address', 'openstreetmap:node/4197192639'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:node-4367945790', 'Centro de Salud de Cameros Viejos San Román de Cameros', NULL, '26132', NULL, '26133', 42.23115, -2.47509, 'address', 'openstreetmap:node/4367945790'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-4663206102', 'Ayuntamiento de El Villar de Arnedo – Plaza de la Constitución', NULL, '26170', 'Plaza de la Constitución', NULL, 42.32077, -2.09528, 'address', 'openstreetmap:node/4663206102'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-4840380228', 'Gama Santo Domingo de la Calzada – Calle Alameda', NULL, '26138', 'Calle Alameda 1', '26250', 42.43996, -2.95332, 'address', 'openstreetmap:node/4840380228'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-4955531402', 'Dia Haro – Calle de la Ventilla', NULL, '26071', 'Calle de la Ventilla', '26200', 42.57402, -2.85137, 'address', 'openstreetmap:node/4955531402'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-496241544', 'Eroski Logroño – Calle Trinidad', NULL, '26089', 'Calle Trinidad 11', '26005', 42.46607, -2.45517, 'address', 'openstreetmap:node/496241544'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-496241652', 'Eroski City Logroño – Avenida Gonzalo de Berceo 2-4', NULL, '26089', 'Avenida Gonzalo de Berceo 2-4', '26005', 42.46552, -2.45494, 'address', 'openstreetmap:node/496241652'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-5043419186', 'Mercadona Logroño – Calle de la Cigüeña', NULL, '26089', 'Calle de la Cigüeña 18', '26004', 42.46526, -2.43409, 'address', 'openstreetmap:node/5043419186'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-505254429', 'Alcampo Logroño – Calle de las Tejeras', NULL, '26089', 'Calle de las Tejeras 4', '26006', 42.4514, -2.46855, 'address', 'openstreetmap:node/505254429'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-5215734964', 'BonÀrea Alfaro – Pasaje San Francisco', NULL, '26011', 'Pasaje San Francisco', '26540', 42.17977, -1.75083, 'address', 'openstreetmap:node/5215734964'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-5215734967', 'Eroski Alfaro – Avenida de Zaragoza', NULL, '26011', 'Avenida de Zaragoza 38', '26540', 42.17645, -1.75273, 'address', 'openstreetmap:node/5215734967'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-521836040', 'Alcampo Logroño – Calle Valcuerna', NULL, '26089', 'Calle Valcuerna', '26005', 42.46557, -2.45839, 'address', 'openstreetmap:node/521836040'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-5238295439', 'Eroski City Rincón de Soto – Calle Francisco Llorente', NULL, '26125', 'Calle Francisco Llorente', NULL, 42.23476, -1.8519, 'address', 'openstreetmap:node/5238295439'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-5266042531', 'Alcampo Logroño – Calle de la Cigüeña', NULL, '26089', 'Calle de la Cigüeña 28', '26004', 42.46483, -2.43156, 'address', 'openstreetmap:node/5266042531'),
  ('Gimnasios', 'catalogo-la-rioja:la-rioja-resto:node-532089207', 'Basic-Fit Logroño – Marqués de Murrieta', NULL, '26089', 'Marqués de Murrieta 44', '26005', 42.46488, -2.45672, 'address', 'openstreetmap:node/532089207'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-5356462342', 'Lupa Lardero – Calle del Nocedillo', NULL, '26084', 'Calle del Nocedillo 26', '26140', 42.42698, -2.45682, 'address', 'openstreetmap:node/5356462342'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-5393985910', 'Lupa Ezcaray – Avenida de Santo Domingo de la Calzada', NULL, '26061', 'Avenida de Santo Domingo de la Calzada 64', '26280', 42.33404, -3.01118, 'address', 'openstreetmap:node/5393985910'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-5758895966', 'Lupa Haro – Calle Federico García Lorca', NULL, '26071', 'Calle Federico García Lorca', '26200', 42.56996, -2.84868, 'address', 'openstreetmap:node/5758895966'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-6168719794', 'Alcampo Logroño – Calle de las Servillas', NULL, '26089', 'Calle de las Servillas 7', '26006', 42.45471, -2.43967, 'address', 'openstreetmap:node/6168719794'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-6168719797', 'Lupa Logroño – Avenida Jorge Vigón', NULL, '26089', 'Avenida Jorge Vigón', '26003', 42.46068, -2.43734, 'address', 'openstreetmap:node/6168719797'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-6234928918', 'Juzgados de Paz Lardero – Plaza España', NULL, '26084', 'Plaza España 12', '26140', 42.4278, -2.46308, 'address', 'openstreetmap:node/6234928918'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-6485258934', 'Supercor Logroño – Calle Estambrera', NULL, '26089', 'Calle Estambrera 19', NULL, 42.45614, -2.43337, 'address', 'openstreetmap:node/6485258934'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-679142420', 'Eroski City Haro – Calle de la Ventilla', NULL, '26071', 'Calle de la Ventilla', '26200', 42.57504, -2.84973, 'address', 'openstreetmap:node/679142420'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-6795360614', 'Supermercado Eco Logroño – Calle Garcilaso de la Vega', NULL, '26089', 'Calle Garcilaso de la Vega', '26006', 42.45684, -2.43609, 'address', 'openstreetmap:node/6795360614'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-6861781770', 'Ayuntamiento de Villamediana de Iregua – Calle Alberite', NULL, '26168', 'Calle Alberite', NULL, 42.42629, -2.41922, 'address', 'openstreetmap:node/6861781770'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-6900941695', 'Dia Pradejón – Calle Vadillos', NULL, '26117', 'Calle Vadillos 13', '26510', 42.33262, -2.07053, 'address', 'openstreetmap:node/6900941695'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-7298603105', 'Lupa Autol – Paseo Cidacos', NULL, '26021', 'Paseo Cidacos', NULL, 42.21388, -2.00423, 'address', 'openstreetmap:node/7298603105'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-7298603106', 'Dia Autol – Calle Maestro Tovar', NULL, '26021', 'Calle Maestro Tovar 7', '26560', 42.21549, -2.00392, 'address', 'openstreetmap:node/7298603106'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-7858369371', 'Ayuntamiento de Casalarreina – 16', NULL, '26042', '16', '26230', 42.54811, -2.91303, 'address', 'openstreetmap:node/7858369371'),
  ('Gimnasios', 'catalogo-la-rioja:la-rioja-resto:node-7864813099', 'Basic-Fit Logroño – Avenida de Lobete', NULL, '26089', 'Avenida de Lobete', '26006', 42.45891, -2.43736, 'address', 'openstreetmap:node/7864813099'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-7864988884', 'Eroski Logroño – Avenida Solidaridad', NULL, '26089', 'Avenida Solidaridad', '26003', 42.46086, -2.43888, 'address', 'openstreetmap:node/7864988884'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-7865256387', 'BM Logroño – Avenida de Colón', NULL, '26089', 'Avenida de Colón 30', NULL, 42.46036, -2.44127, 'address', 'openstreetmap:node/7865256387'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-7865672511', 'Dia Logroño – Avenida Club Deportivo', NULL, '26089', 'Avenida Club Deportivo 56', '26007', 42.45807, -2.46067, 'address', 'openstreetmap:node/7865672511'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-7906239185', 'Carniceria Villoslada de Cameros – Calle Agustín Muro', NULL, '26177', 'Calle Agustín Muro', '26125', 42.11037, -2.67449, 'address', 'openstreetmap:node/7906239185'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-8945185444', 'Juzgado de Santo Domingo Santo Domingo de la Calzada – Calle Margubiete', NULL, '26138', 'Calle Margubiete 1', '26250', 42.44247, -2.95435, 'address', 'openstreetmap:node/8945185444'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:node-9355390075', 'Lupa Logroño – Gran Vía Juan Carlos I', NULL, '26089', 'Gran Vía Juan Carlos I 31', '26002', 42.4636, -2.44921, 'address', 'openstreetmap:node/9355390075'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-9680721831', 'Ayuntamiento de Cornago – Plaza Mayor', NULL, '26054', 'Plaza Mayor 4', NULL, 42.06474, -2.0956, 'address', 'openstreetmap:node/9680721831'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-987967827', 'Ayuntamiento de Muro de Aguas – Calle Ancha', NULL, '26100', 'Calle Ancha 10', '26587', 42.13385, -2.11095, 'address', 'openstreetmap:node/987967827'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:node-9942010053', 'Ayuntamiento de Santurde de Rioja – Plaza Fundador', NULL, '26140', 'Plaza Fundador 22', NULL, 42.38943, -2.97986, 'address', 'openstreetmap:node/9942010053'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:relation-18284503', 'Excmo. Ayuntamiento de Logroño – Calle de las Escuelas Pías', NULL, '26089', 'Calle de las Escuelas Pías', '26001', 42.46619, -2.43918, 'address', 'openstreetmap:relation/18284503'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:relation-18354265', 'Centro De Salud General Espartero Logroño – Calle General Espartero', NULL, '26089', 'Calle General Espartero', '26003', 42.4595, -2.44305, 'address', 'openstreetmap:relation/18354265'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-101813986', 'Ayuntamiento de Ventrosa de la Sierra – Calle de la Iglesia', NULL, '26164', 'Calle de la Iglesia', NULL, 42.15717, -2.85082, 'address', 'openstreetmap:way/101813986'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1053909669', 'BM Alfaro – Pasaje San Francisco', NULL, '26011', 'Pasaje San Francisco', '26540', 42.18001, -1.75028, 'address', 'openstreetmap:way/1053909669'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1054516189', 'Juzgados de Haro – Calle Castilla', NULL, '26071', 'Calle Castilla', '26200', 42.57353, -2.85315, 'address', 'openstreetmap:way/1054516189'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1086151230', 'Ayuntamiento de Santo Domingo de la Calzada – Plaza de España', NULL, '26138', 'Plaza de España', '26250', 42.44186, -2.95274, 'address', 'openstreetmap:way/1086151230'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1096951571', 'Ayuntamiento de Cervera del Río Alhama – Carretera Aguilar de Río Alhama-Cervera de Río Alhama', NULL, '26047', 'Carretera Aguilar de Río Alhama-Cervera de Río Alhama', NULL, 42.00689, -1.95195, 'address', 'openstreetmap:way/1096951571'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-1115537723', 'Centro de Salud Murillo Murillo de Río Leza – Calle Jesús Fernández del Río', NULL, '26099', 'Calle Jesús Fernández del Río', NULL, 42.40346, -2.32373, 'address', 'openstreetmap:way/1115537723'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1115541710', 'Ayuntamiento de Murillo de Río Leza – Calle Mayor', NULL, '26099', 'Calle Mayor', NULL, 42.4016, -2.32532, 'address', 'openstreetmap:way/1115541710'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1115978680', 'Ayuntamiento de Corera – Calle Iglesia', NULL, '26053', 'Calle Iglesia 14', NULL, 42.34283, -2.21935, 'address', 'openstreetmap:way/1115978680'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-112187483', 'Mercadona Logroño', NULL, '26089', NULL, NULL, 42.45699, -2.46882, 'address', 'openstreetmap:way/112187483'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1140592852', 'Mercadona Haro – Calle de Portugal', NULL, '26071', 'Calle de Portugal 2', '26200', 42.57586, -2.85317, 'address', 'openstreetmap:way/1140592852'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1164082533', 'Delegación especial de la AEAT en La Rioja Logroño – Calle María Zambrano', NULL, '26089', 'Calle María Zambrano 4', '26001', 42.46455, -2.44786, 'address', 'openstreetmap:way/1164082533'),
  ('Hospital', 'catalogo-la-rioja:la-rioja-resto:way-1172868973', 'Hospital General de La Rioja Logroño – Avenida de Viana', NULL, '26089', 'Avenida de Viana', '26001', 42.46856, -2.442, 'address', 'openstreetmap:way/1172868973'),
  ('Hospital', 'catalogo-la-rioja:la-rioja-resto:way-1172870559', 'Hospital San Pedro Logroño – Calle Piqueras', NULL, '26089', 'Calle Piqueras 98', '26006', 42.45116, -2.42699, 'address', 'openstreetmap:way/1172870559'),
  ('Bricolaje', 'catalogo-la-rioja:la-rioja-resto:way-1177925935', 'Cuñasa Alfaro – Carretera Zaragoza', NULL, '26011', 'Carretera Zaragoza', '26540', 42.16023, -1.7311, 'address', 'openstreetmap:way/1177925935'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1192596042', 'Alcampo Logroño – Calle Marqués de la Ensenada', NULL, '26089', 'Calle Marqués de la Ensenada 16', '26003', 42.46339, -2.43895, 'address', 'openstreetmap:way/1192596042'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1260710191', 'Eroski Cervera del Río Alhama', NULL, '26047', NULL, NULL, 42.05039, -1.9217, 'address', 'openstreetmap:way/1260710191'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1271383051', 'Lupa Villamediana de Iregua – Avenida de los Caballeros Templarios', NULL, '26168', 'Avenida de los Caballeros Templarios', '26142', 42.44689, -2.41762, 'address', 'openstreetmap:way/1271383051'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1284641031', 'Lupa Logroño – Calle Holanda', NULL, '26089', 'Calle Holanda', '26007', 42.46479, -2.46907, 'address', 'openstreetmap:way/1284641031'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1285299086', 'Mercadona Logroño – Calle Ermua', NULL, '26089', 'Calle Ermua', NULL, 42.46335, -2.46428, 'address', 'openstreetmap:way/1285299086'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1286925223', 'Lidl Logroño – Calle de Clavijo', NULL, '26089', 'Calle de Clavijo 65', '26007', 42.45318, -2.4652, 'address', 'openstreetmap:way/1286925223'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1363088806', 'Ayuntamiento de Sotés – Calle Arco', NULL, '26145', 'Calle Arco', NULL, 42.39992, -2.60226, 'address', 'openstreetmap:way/1363088806'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1363093560', 'Palacio de Justicia Logroño – Calle Marqués de Murrieta', NULL, '26089', 'Calle Marqués de Murrieta 45', '26005', 42.46358, -2.45822, 'address', 'openstreetmap:way/1363093560'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1363610475', 'Ayuntamiento de Logroño – Avenida Doce Ligero de Artillería', NULL, '26089', 'Avenida Doce Ligero de Artillería', '26004', 42.46597, -2.43905, 'address', 'openstreetmap:way/1363610475'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1365836671', 'Mercadona Villamediana de Iregua – Carretera del valle del Leza', NULL, '26168', 'Carretera del valle del Leza', NULL, 42.44826, -2.4188, 'address', 'openstreetmap:way/1365836671'),
  ('Hospital', 'catalogo-la-rioja:la-rioja-resto:way-1381818193', 'Area Hospitalaria de la Duquesa de La Victoria Logroño – Calle Duquesa de la Victoria', NULL, '26089', 'Calle Duquesa de la Victoria 88', '26004', 42.462, -2.43127, 'address', 'openstreetmap:way/1381818193'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-140252117', 'Ayuntamiento de Haro – Plaza de la Paz', NULL, '26071', 'Plaza de la Paz 5', '26200', 42.57712, -2.84634, 'address', 'openstreetmap:way/140252117'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-1568097977', 'Ayuntamiento de Alfaro – Calle Las Pozas', NULL, '26011', 'Calle Las Pozas', '26540', 42.17932, -1.75023, 'address', 'openstreetmap:way/1568097977'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-1568263163', 'Mercadona Alfaro – Calle de los Pantanos', NULL, '26011', 'Calle de los Pantanos', '26540', 42.17267, -1.74448, 'address', 'openstreetmap:way/1568263163'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-205143331', 'Alcampo Logroño – Calle Manuel de Falla', NULL, '26089', 'Calle Manuel de Falla', NULL, 42.45644, -2.47654, 'address', 'openstreetmap:way/205143331'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-205208400', 'Centro de salud Joaquín Elizalde Logroño – San José de Calasanz', NULL, '26089', 'San José de Calasanz 1', '26004', 42.46639, -2.43201, 'address', 'openstreetmap:way/205208400'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-222283787', 'Centro de Salud de Siete Infantes de Lara Logroño – Calle Siete Infantes de Lara', NULL, '26089', 'Calle Siete Infantes de Lara', '26007', 42.45909, -2.46104, 'address', 'openstreetmap:way/222283787'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-229045901', 'Alcampo Haro – Avenida de Santo Domingo de la Calzada', NULL, '26071', 'Avenida de Santo Domingo de la Calzada', '26200', 42.56611, -2.86742, 'address', 'openstreetmap:way/229045901'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-238482434', 'Ayuntamiento de Lumbreras de Cameros – Calle de La Solana', NULL, '26091', 'Calle de La Solana 1', '26126', 42.1045, -2.62323, 'address', 'openstreetmap:way/238482434'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-240859226', 'Centro de Salud Cascajos Logroño – Calle de los Pedregales', NULL, '26089', 'Calle de los Pedregales 24', '26006', 42.45484, -2.435, 'address', 'openstreetmap:way/240859226'),
  ('Centro comercial', 'catalogo-la-rioja:la-rioja-resto:way-24369658', 'Centro Comercial Arcca Calahorra – Calle Tilos', NULL, '26036', 'Calle Tilos', '26500', 42.30498, -1.96133, 'address', 'openstreetmap:way/24369658'),
  ('Centro comercial', 'catalogo-la-rioja:la-rioja-resto:way-24369922', 'Eroski Calahorra', NULL, '26036', NULL, '26500', 42.31151, -1.9794, 'address', 'openstreetmap:way/24369922'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-259338676', 'ALDI Logroño – Calle de Prado Viejo', NULL, '26089', 'Calle de Prado Viejo 72', '26005', 42.45262, -2.47271, 'address', 'openstreetmap:way/259338676'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-284610373', 'Centro de Salud nº 10 - Rioja Alta Nájera – Avenida de la Rioja', NULL, '26102', 'Avenida de la Rioja', '26300', 42.41902, -2.73172, 'address', 'openstreetmap:way/284610373'),
  ('Hospital', 'catalogo-la-rioja:la-rioja-resto:way-286654287', 'Hospital Viamed los Manzanos Lardero – Travesía Avda. de Madrid', NULL, '26084', 'Travesía Avda. de Madrid', '26080', 42.43762, -2.44822, 'address', 'openstreetmap:way/286654287'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-296693087', 'Ayuntamiento de Lardero – Plaza España', NULL, '26084', 'Plaza España 12', '26140', 42.42781, -2.46277, 'address', 'openstreetmap:way/296693087'),
  ('Centro comercial', 'catalogo-la-rioja:la-rioja-resto:way-30689516', 'Centro Comercial Berceo Logroño – Calle Lérida', NULL, '26089', 'Calle Lérida 1', '26006', 42.46279, -2.42042, 'address', 'openstreetmap:way/30689516'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-309450994', 'Centro de Salud La Guindalera Logroño – Calle Nestares', NULL, '26089', 'Calle Nestares', NULL, 42.45038, -2.4567, 'address', 'openstreetmap:way/309450994'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-317178917', 'Centro de Salud Especialidades Haro – Calle Vicente Aleixandre', NULL, '26071', 'Calle Vicente Aleixandre 2', '26200', 42.56945, -2.84641, 'address', 'openstreetmap:way/317178917'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-317748139', 'Alcampo Logroño – Avenida de Madrid', NULL, '26089', 'Avenida de Madrid 171', '26007', 42.44269, -2.45061, 'address', 'openstreetmap:way/317748139'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-330519595', 'Centro de Salud de Santo Domingo Santo Domingo de la Calzada – Calle Winnenden', NULL, '26138', 'Calle Winnenden', '26250', 42.43705, -2.95065, 'address', 'openstreetmap:way/330519595'),
  ('Hospital', 'catalogo-la-rioja:la-rioja-resto:way-338039452', 'Hospital Viamed Virgen del Carmen Calahorra', NULL, '26036', NULL, '26500', 42.31446, -1.98054, 'address', 'openstreetmap:way/338039452'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-352989391', 'Eroski Haro – Avenida de Santo Domingo de la Calzada', NULL, '26071', 'Avenida de Santo Domingo de la Calzada', '26200', 42.56865, -2.86142, 'address', 'openstreetmap:way/352989391'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-352989392', 'Lidl Haro – Avenida de Santo Domingo de la Calzada', NULL, '26071', 'Avenida de Santo Domingo de la Calzada', '26200', 42.56886, -2.86111, 'address', 'openstreetmap:way/352989392'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-352989393', 'Dia Haro – Avenida de Santo Domingo de la Calzada', NULL, '26071', 'Avenida de Santo Domingo de la Calzada', '26200', 42.56939, -2.86032, 'address', 'openstreetmap:way/352989393'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-396522256', 'ALDI Calahorra', NULL, '26036', NULL, '26500', 42.31513, -1.96122, 'address', 'openstreetmap:way/396522256'),
  ('Centro comercial', 'catalogo-la-rioja:la-rioja-resto:way-41328702', 'Centro Comercial Parque Rioja Logroño – C. de las Tejeras', NULL, '26089', 'C. de las Tejeras', '26006', 42.45207, -2.46859, 'address', 'openstreetmap:way/41328702'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-452037564', 'Ayuntamiento de Enciso – Plaza Mayor', NULL, '26058', 'Plaza Mayor 1', '26586', 42.14861, -2.26884, 'address', 'openstreetmap:way/452037564'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-461911201', 'Dia Alfaro – Avenida de Zaragoza', NULL, '26011', 'Avenida de Zaragoza 38', '26540', 42.17631, -1.75339, 'address', 'openstreetmap:way/461911201'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-517934837', 'Lupa Logroño – Calle de Prado Viejo', NULL, '26089', 'Calle de Prado Viejo 72', '26005', 42.45229, -2.47285, 'address', 'openstreetmap:way/517934837'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-645702272', 'Ayuntamiento de Autol – Plaza de España', NULL, '26021', 'Plaza de España 1', NULL, 42.21541, -2.00664, 'address', 'openstreetmap:way/645702272'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-732953428', 'Ayuntamiento de Hormilleja – Plaza Constitución', NULL, '26076', 'Plaza Constitución 1', '26223', 42.45537, -2.73045, 'address', 'openstreetmap:way/732953428'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-755539251', 'Centro De Salud De Ezcaray – Calle Virgen de Allende', NULL, '26061', 'Calle Virgen de Allende', NULL, 42.32701, -3.01248, 'address', 'openstreetmap:way/755539251'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-777810852', 'Ayuntamiento de Castañares de Rioja – Plaza de Don Paulino Francia', NULL, '26043', 'Plaza de Don Paulino Francia 1', '26240', 42.51197, -2.93191, 'address', 'openstreetmap:way/777810852'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-784892572', 'Ayuntamiento de Entrena – Calle Mayor', NULL, '26059', 'Calle Mayor', NULL, 42.38828, -2.53105, 'address', 'openstreetmap:way/784892572'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-784894290', 'Lupa Arnedo – Avenida de Benidorm', NULL, '26018', 'Avenida de Benidorm 37', '26580', 42.22756, -2.0954, 'address', 'openstreetmap:way/784894290'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-784894293', 'Mercadona Arnedo – Paseo de la Constitución', NULL, '26018', 'Paseo de la Constitución', '26580', 42.22919, -2.0927, 'address', 'openstreetmap:way/784894293'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-822867082', 'Ayuntamiento de Cihuri – Calle Real', NULL, '26049', 'Calle Real', NULL, 42.56443, -2.92226, 'address', 'openstreetmap:way/822867082'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-843453123', 'Centro de salud de Gonzalo de Berceo Logroño – Avenida Gonzalo de Berceo', NULL, '26089', 'Avenida Gonzalo de Berceo 37', '26005', 42.46666, -2.46077, 'address', 'openstreetmap:way/843453123'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-848873151', 'Ayuntamiento de Arnedo – Calle de la Picota', NULL, '26018', 'Calle de la Picota', '26580', 42.22781, -2.10012, 'address', 'openstreetmap:way/848873151'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-90908495', 'Dia Santo Domingo de la Calzada – Avenida Cuerpo de Obras Publicas 9-11', NULL, '26138', 'Avenida Cuerpo de Obras Publicas 9-11', '26250', 42.43955, -2.94935, 'address', 'openstreetmap:way/90908495'),
  ('Supermercado', 'catalogo-la-rioja:la-rioja-resto:way-93793150', 'BM Logroño – Avenida Club Deportivo', NULL, '26089', 'Avenida Club Deportivo', '26007', 42.45566, -2.4483, 'address', 'openstreetmap:way/93793150'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-94830647', 'Ayuntamiento de Alesanco – Plaza de la Constitución', NULL, '26009', 'Plaza de la Constitución 6', NULL, 42.414, -2.81729, 'address', 'openstreetmap:way/94830647'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-94832022', 'Ayuntamiento de Almarza de Cameros', NULL, '26012', NULL, NULL, 42.21607, -2.59775, 'address', 'openstreetmap:way/94832022'),
  ('Centro de salud', 'catalogo-la-rioja:la-rioja-resto:way-95031488', 'Centro de Salud Alfaro – Calle Trasmuro', NULL, '26011', 'Calle Trasmuro', '26540', 42.1785, -1.75299, 'address', 'openstreetmap:way/95031488'),
  ('Hospital', 'catalogo-la-rioja:la-rioja-resto:way-95686564', 'Hospital de Calahorra', NULL, '26036', NULL, '26500', 42.31355, -1.97959, 'address', 'openstreetmap:way/95686564'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-95693778', 'Ayuntamiento de Cenicero – Plaza España', NULL, '26046', 'Plaza España 12', '26350', 42.4817, -2.64224, 'address', 'openstreetmap:way/95693778'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-95829974', 'Ayuntamiento de Cabezón de Cameros – Calle de la Plazuela', NULL, '26035', 'Calle de la Plazuela 9', NULL, 42.19752, -2.51912, 'address', 'openstreetmap:way/95829974'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-95830986', 'Ayuntamiento de Canales de la Sierra – Carretera del Najerilla', NULL, '26038', 'Carretera del Najerilla', NULL, 42.14165, -3.0245, 'address', 'openstreetmap:way/95830986'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-966515798', 'Ayuntamiento de Navarrete – Calle Mayor Alta', NULL, '26105', 'Calle Mayor Alta 2', '26370', 42.42921, -2.56173, 'address', 'openstreetmap:way/966515798'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-98655257', 'Ayuntamiento de Leza de Río Leza – Plaza del Ayuntamiento', NULL, '26088', 'Plaza del Ayuntamiento 5', NULL, 42.32913, -2.40635, 'address', 'openstreetmap:way/98655257'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-98669071', 'Ayuntamiento de Ollauri – Plaza de la Paz', NULL, '26111', 'Plaza de la Paz 1', '26220', 42.54238, -2.83319, 'address', 'openstreetmap:way/98669071'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-99200623', 'Ayuntamiento de El Redal – Calle Jazmín', NULL, '26123', 'Calle Jazmín', NULL, 42.33717, -2.20242, 'address', 'openstreetmap:way/99200623'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-99952173', 'Ayuntamiento de San Millán de Yécora', NULL, '26131', NULL, NULL, 42.54671, -3.09658, 'address', 'openstreetmap:way/99952173'),
  ('Entidad oficial', 'catalogo-la-rioja:la-rioja-resto:way-99955153', 'Ayuntamiento de Rabanera – Calle Mayor', NULL, '26121', 'Calle Mayor 37', NULL, 42.18935, -2.48608, 'address', 'openstreetmap:way/99955153');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '26');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 26 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '26'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 199 THEN
    RAISE EXCEPTION 'Se esperaban 199 puntos de (varias) en La Rioja, hay %', n;
  END IF;
END;
$$;

COMMIT;
