-- Carga de la categoría (varias) de Araba/Álava (provincia 01), trozo de la carga de Andalucía.
-- Origen: pais-vasco-resto-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 189 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-10698834903', 'Supermercado UNIDE Artziniega – Arteko aldapa', NULL, '01004', 'Arteko aldapa 6', '01474', 43.12204, -3.13186, 'address', 'openstreetmap:node/10698834903'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-10853584405', 'La Cabaña Pottery and Plants Zuia – Haitz kalea', NULL, '01063', 'Haitz kalea 4', '01139', 42.96692, -2.8252, 'address', 'openstreetmap:node/10853584405'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-10894963365', 'Eroski Vitoria-Gasteiz – Domingo Beltran de Otazu kalea', NULL, '01059', 'Domingo Beltran de Otazu kalea 17', '01012', 42.85137, -2.67765, 'address', 'openstreetmap:node/10894963365'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:node-10961850645', 'Zaballako Osasun Zentroa - Espetxea Iruña Oka / Iruña de Oca', NULL, '01901', NULL, '01230', 42.80084, -2.78651, 'address', 'openstreetmap:node/10961850645'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:node-10976678700', 'Sansomendiko Osasun Zentroa Vitoria-Gasteiz – Paula Montal kalea', NULL, '01059', 'Paula Montal kalea 28', '01010', 42.85628, -2.69842, 'address', 'openstreetmap:node/10976678700'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:node-10989585660', 'Oiongo Osasun Zentroa Oyón-Oion – Kale Nagusia', NULL, '01043', 'Kale Nagusia', '01320', 42.5056, -2.43505, 'address', 'openstreetmap:node/10989585660'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-11006142872', 'Herri Gimnasioa Vitoria-Gasteiz – Errekaleor kalea', NULL, '01059', 'Errekaleor kalea 23', '01006', 42.8348, -2.65027, 'address', 'openstreetmap:node/11006142872'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-11500396813', 'Wudang Pai Kung Fu Vitoria-Gasteiz – Gasteiz hiribidea', NULL, '01059', 'Gasteiz hiribidea 46', '01008', 42.84873, -2.68116, 'address', 'openstreetmap:node/11500396813'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-11634022349', 'PrimaPrix Vitoria-Gasteiz – Castro Urdiales kalea', NULL, '01059', 'Castro Urdiales kalea 1', '01006', 42.83903, -2.66606, 'address', 'openstreetmap:node/11634022349'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-11645102632', 'Maritierrra Amurrio – Aiara kalea', NULL, '01002', 'Aiara kalea 1', '01470', 43.0518, -3.00275, 'address', 'openstreetmap:node/11645102632'),
  ('Hospital', 'catalogo-pais-vasco:pais-vasco-resto:node-11800444526', 'San Jose Ospitalea Vitoria-Gasteiz – Tomas Zumarraga dohatsuaren kalea', NULL, '01059', 'Tomas Zumarraga dohatsuaren kalea 10', '01008', 42.84973, -2.67665, 'address', 'openstreetmap:node/11800444526'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-12486234391', 'Supermercado Okondo – 17', NULL, '01042', '17', '01409', 43.15753, -3.02597, 'address', 'openstreetmap:node/12486234391'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-12839838029', 'Eroski City Vitoria-Gasteiz – Vicente Aleixandre kalea', NULL, '01059', 'Vicente Aleixandre kalea 24', '01003', 42.84287, -2.65666, 'address', 'openstreetmap:node/12839838029'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-12880703162', 'K2 Vitoria-Gasteiz – Izardui Komandantearen kalea', NULL, '01059', 'Izardui Komandantearen kalea 20', '01006', 42.83745, -2.66906, 'address', 'openstreetmap:node/12880703162'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-12883394860', 'COVIRAN Vitoria-Gasteiz – Zumakadi plazatxoa', NULL, '01059', 'Zumakadi plazatxoa 4', '01006', 42.83592, -2.67069, 'address', 'openstreetmap:node/12883394860'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-13175881722', 'Synergym Borinbizkarra Vitoria-Gasteiz – Ozeano Barearen kalea', NULL, '01059', 'Ozeano Barearen kalea 31', '01010', 42.84988, -2.70292, 'address', 'openstreetmap:node/13175881722'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-13261198903', 'Judo Club San Ignacio Vitoria-Gasteiz – Errota kalea 4B', NULL, '01059', 'Errota kalea 4B', '01006', 42.83652, -2.66387, 'address', 'openstreetmap:node/13261198903'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-13311249703', 'Administración de la Seguridad Social Llodio – Karmen kalea', NULL, '01036', 'Karmen kalea 27', '01400', 43.14527, -2.95914, 'address', 'openstreetmap:node/13311249703'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-13339526858', 'Fitness Park Vitoria-Gasteiz – Zaramaga kalea', NULL, '01059', 'Zaramaga kalea 1', '01013', 42.8616, -2.66906, 'address', 'openstreetmap:node/13339526858'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-13390076051', 'Ayuntamiento de Peñacerrada-Urizaharra – Plaza Fray Jacinto', NULL, '01044', 'Plaza Fray Jacinto 2', '01211', 42.64433, -2.71357, 'address', 'openstreetmap:node/13390076051'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-13421828011', 'Ayuntamiento de Leza – Herriko plaza', NULL, '01034', 'Herriko plaza 3', '01309', 42.56512, -2.63486, 'address', 'openstreetmap:node/13421828011'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-13603027403', 'Ayuntamiento de Samaniego – Sor Felicias kalea', NULL, '01052', 'Sor Felicias kalea 1', NULL, 42.56811, -2.67922, 'address', 'openstreetmap:node/13603027403'),
  ('Bricolaje', 'catalogo-pais-vasco:pais-vasco-resto:node-14063469251', 'Saltoki Vitoria-Gasteiz – Zurbaoko atea', NULL, '01059', 'Zurbaoko atea 25', '01013', 42.86423, -2.64569, 'address', 'openstreetmap:node/14063469251'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-2138773548', 'BM Vitoria-Gasteiz – Jesus Guridi kalea', NULL, '01059', 'Jesus Guridi kalea 1', '01002', 42.84446, -2.66734, 'address', 'openstreetmap:node/2138773548'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-2148893944', 'Covirán Vitoria-Gasteiz – Florida kalea', NULL, '01059', 'Florida kalea 15', '01005', 42.84338, -2.67359, 'address', 'openstreetmap:node/2148893944'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-2191618996', 'Araiako Udala Asparrena – Goikoetxe kalea', NULL, '01009', 'Goikoetxe kalea 1', '01250', 42.8896, -2.31744, 'address', 'openstreetmap:node/2191618996'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-2360179193', 'Ayuntamiento de Elciego – Plaza Mayor', NULL, '01022', 'Plaza Mayor', '01340', 42.51516, -2.61814, 'address', 'openstreetmap:node/2360179193'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-2360232237', 'La Tienda de Regina Elciego – Barco kalea', NULL, '01022', 'Barco kalea 19', '01340', 42.51452, -2.61798, 'address', 'openstreetmap:node/2360232237'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-2360234030', 'Supermercado Elciego – Gallarza Kapitaina kalea', NULL, '01022', 'Gallarza Kapitaina kalea', '01340', 42.51503, -2.61988, 'address', 'openstreetmap:node/2360234030'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-2577983368', 'Aliprox Campezo / Kanpezu – Samuel Picaza plaza', NULL, '01017', 'Samuel Picaza plaza 29', '01110', 42.66959, -2.35058, 'address', 'openstreetmap:node/2577983368'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-2882127901', 'BM Vitoria-Gasteiz – Paraguai kalea', NULL, '01059', 'Paraguai kalea 1', '01012', 42.8569, -2.67885, 'address', 'openstreetmap:node/2882127901'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-3005113139', 'Ayuntamiento de Lagrán – Calle Herrería', NULL, '01030', 'Calle Herrería 1', NULL, 42.62613, -2.58434, 'address', 'openstreetmap:node/3005113139'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-3678636274', 'BM Vitoria-Gasteiz – San Prudentzio kalea', NULL, '01059', 'San Prudentzio kalea 6', '01005', 42.84399, -2.67347, 'address', 'openstreetmap:node/3678636274'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-3745112510', 'Erosky City Vitoria-Gasteiz – Arkupeduna plaza', NULL, '01059', 'Arkupeduna plaza 1', '01015', 42.84146, -2.70294, 'address', 'openstreetmap:node/3745112510'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-3792449478', 'Veritas Vitoria-Gasteiz – Foru kalea', NULL, '01059', 'Foru kalea 13', '01002', 42.84562, -2.6695, 'address', 'openstreetmap:node/3792449478'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-3829258365', 'Covirán Legutio – Comercio kalea', NULL, '01058', 'Comercio kalea 14', '01170', 42.97892, -2.64232, 'address', 'openstreetmap:node/3829258365'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-4424087701', 'Martín Martin Vitoria-Gasteiz – Gurutze Zuriko kalea', NULL, '01059', 'Gurutze Zuriko kalea 7', '01012', 42.85249, -2.67847, 'address', 'openstreetmap:node/4424087701'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-4498785338', 'Rodas Vitoria-Gasteiz – Sebastian Fernandez de Lezeta kalea', NULL, '01059', 'Sebastian Fernandez de Lezeta kalea 2', '01009', 42.8507, -2.6824, 'address', 'openstreetmap:node/4498785338'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-4571980892', 'Laudioko udaletxea Llodio – Herriko plaza', NULL, '01036', 'Herriko plaza 8', '01400', 43.14323, -2.96269, 'address', 'openstreetmap:node/4571980892'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-4602261445', 'Legutioko Frontoia Legutio – La Unión plazatxoa', NULL, '01058', 'La Unión plazatxoa 5', '01170', 42.97856, -2.64165, 'address', 'openstreetmap:node/4602261445'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-4742693250', 'Bio Alai Vitoria-Gasteiz – Zumakadi ibilbidea', NULL, '01059', 'Zumakadi ibilbidea 25', '01006', 42.83619, -2.66549, 'address', 'openstreetmap:node/4742693250'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-4764335360', 'Eroski Vitoria-Gasteiz – Tomas Zumarraga dohatsuaren kalea', NULL, '01059', 'Tomas Zumarraga dohatsuaren kalea 58', '01009', 42.85068, -2.68405, 'address', 'openstreetmap:node/4764335360'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-477301385', 'Alcampo Vitoria-Gasteiz – Heraclio Fournier kalea', NULL, '01059', 'Heraclio Fournier kalea 7', '01006', 42.83921, -2.66666, 'address', 'openstreetmap:node/477301385'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-477301841', 'Eroski City Vitoria-Gasteiz – Castro Urdiales kalea', NULL, '01059', 'Castro Urdiales kalea 4', '01006', 42.83899, -2.66508, 'address', 'openstreetmap:node/477301841'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-486583649', 'Simply Market Vitoria-Gasteiz – Herrandarren kalea', NULL, '01059', 'Herrandarren kalea 28', '01002', 42.84432, -2.66467, 'address', 'openstreetmap:node/486583649'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-486584506', 'Eroski Vitoria-Gasteiz – Pio XII.aren kalea', NULL, '01059', 'Pio XII.aren kalea 11', '01002', 42.84431, -2.66588, 'address', 'openstreetmap:node/486584506'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-4879963685', 'Eroski Vitoria-Gasteiz – Zaramaga kalea', NULL, '01059', 'Zaramaga kalea 1', '01013', 42.86186, -2.66674, 'address', 'openstreetmap:node/4879963685'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-493551053', 'BM complet Vitoria-Gasteiz – Askatasun kalea', NULL, '01059', 'Askatasun kalea 6', '01002', 42.84759, -2.66712, 'address', 'openstreetmap:node/493551053'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-4944602755', 'Ayuntamiento de Baños de Ebro Baños de Ebro / Mañueta – Udaletxe plaza', NULL, '01011', 'Udaletxe plaza 5', '01307', 42.53016, -2.67952, 'address', 'openstreetmap:node/4944602755'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:node-4951243983', 'Zalduondoko udaletxea Zalduondo – Arbin kalea', NULL, '01061', 'Arbin kalea 3', '01208', 42.88544, -2.34781, 'address', 'openstreetmap:node/4951243983'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-497267950', 'Eroski Vitoria-Gasteiz – Tomas Zumarraga dohatsuaren kalea', NULL, '01059', 'Tomas Zumarraga dohatsuaren kalea 6', '01008', 42.84943, -2.67629, 'address', 'openstreetmap:node/497267950'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-497269512', 'Simply Market Vitoria-Gasteiz – Mauro Ortiz de Urbina margolariaren kalea', NULL, '01059', 'Mauro Ortiz de Urbina margolariaren kalea 6', '01008', 42.8499, -2.68516, 'address', 'openstreetmap:node/497269512'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-499199521', 'Simply Vitoria-Gasteiz – Abendaño kalea', NULL, '01059', 'Abendaño kalea 32', '01008', 42.84511, -2.68334, 'address', 'openstreetmap:node/499199521'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-4992839021', 'Mercadona Vitoria-Gasteiz – Simon de Anda kalea', NULL, '01059', 'Simon de Anda kalea 19', '01012', 42.85516, -2.67439, 'address', 'openstreetmap:node/4992839021'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-499446498', 'BM Vitoria-Gasteiz – Tomas Zumarraga dohatsuaren kalea', NULL, '01059', 'Tomas Zumarraga dohatsuaren kalea 30', '01008', 42.85012, -2.68032, 'address', 'openstreetmap:node/499446498'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-503580029', 'Alcampo Vitoria-Gasteiz – Gasteiz hiribidea', NULL, '01059', 'Gasteiz hiribidea 89', '01009', 42.8533, -2.68079, 'address', 'openstreetmap:node/503580029'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-5042730786', 'Eroski City Vitoria-Gasteiz – Salbaterrabide kalea', NULL, '01059', 'Salbaterrabide kalea 16', '01007', 42.83755, -2.67854, 'address', 'openstreetmap:node/5042730786'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-5044602885', 'Covirán Valdegovía / Gaubea – Bilbao Errepidea, 42, 01423 Espejo, Araba', NULL, '01055', 'Bilbao Errepidea, 42, 01423 Espejo, Araba', NULL, 42.80863, -3.04659, 'address', 'openstreetmap:node/5044602885'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:node-5167598574', 'Osasun zentroa - Centro de salud Yécora / Iekora – Hegoalde kalea', NULL, '01060', 'Hegoalde kalea', NULL, 42.56746, -2.47001, 'address', 'openstreetmap:node/5167598574'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-520447982', 'Eroski City Vitoria-Gasteiz – Simon de Anda kalea', NULL, '01059', 'Simon de Anda kalea 15', '01012', 42.85505, -2.67486, 'address', 'openstreetmap:node/520447982'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-520447986', 'El Hambra Vitoria-Gasteiz – Julian Apraiz kalea', NULL, '01059', 'Julian Apraiz kalea 13', '01012', 42.85479, -2.67488, 'address', 'openstreetmap:node/520447986'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:node-529393667', 'Habana-Kubako Osasun Zentroa Vitoria-Gasteiz – Kuba kalea', NULL, '01059', 'Kuba kalea 7', '01012', 42.85871, -2.68023, 'address', 'openstreetmap:node/529393667'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-529409951', 'Lidl Vitoria-Gasteiz – Domingo Beltran de Otazu kalea', NULL, '01059', 'Domingo Beltran de Otazu kalea 34', '01012', 42.8527, -2.67704, 'address', 'openstreetmap:node/529409951'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:node-534603984', 'Olarizuko Osasun Zentroa Vitoria-Gasteiz – Heraclio Fournier kalea', NULL, '01059', 'Heraclio Fournier kalea 23', '01006', 42.8382, -2.66462, 'address', 'openstreetmap:node/534603984'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-546914243', 'Eroski City Vitoria-Gasteiz – Florida kalea', NULL, '01059', 'Florida kalea 54', '01005', 42.84261, -2.6692, 'address', 'openstreetmap:node/546914243'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-5518162379', 'Supermercado Itziar Zuia – Domingo de Sautu kalea', NULL, '01063', 'Domingo de Sautu kalea 27', '01130', 42.95606, -2.82056, 'address', 'openstreetmap:node/5518162379'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-5518179536', 'Supermercado Onda Zuia – Domaikiako errepidea', NULL, '01063', 'Domaikiako errepidea 1', '01130', 42.95625, -2.81889, 'address', 'openstreetmap:node/5518179536'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-562876654', 'Eroski City Vitoria-Gasteiz – Judimendi hiribidea', NULL, '01059', 'Judimendi hiribidea 24', '01003', 42.84562, -2.66159, 'address', 'openstreetmap:node/562876654'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-562884448', 'BM Vitoria-Gasteiz – Martxoak 8 etorbidea', NULL, '01059', 'Martxoak 8 etorbidea 2', '01002', 42.85488, -2.65677, 'address', 'openstreetmap:node/562884448'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-5633459997', 'Bizipen Vitoria-Gasteiz – San Martin Abendañokoaren plaza', NULL, '01059', 'San Martin Abendañokoaren plaza 2', '01009', 42.85144, -2.68761, 'address', 'openstreetmap:node/5633459997'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-5633600811', 'Om Vitoria-Gasteiz – Badaia kalea', NULL, '01059', 'Badaia kalea 14', '01012', 42.8508, -2.6769, 'address', 'openstreetmap:node/5633600811'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-5633641523', 'Atlas Vitoria-Gasteiz – Domingo Beltran de Otazu kalea', NULL, '01059', 'Domingo Beltran de Otazu kalea 28', '01012', 42.85164, -2.67733, 'address', 'openstreetmap:node/5633641523'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-5633736844', 'Senshi Dojo Vitoria-Gasteiz – Badaia kalea', NULL, '01059', 'Badaia kalea 25', '01012', 42.85083, -2.6783, 'address', 'openstreetmap:node/5633736844'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-5633750464', 'Vitanova Vitoria-Gasteiz – Domingo Beltran de Otazu kalea 1B', NULL, '01059', 'Domingo Beltran de Otazu kalea 1B', '01012', 42.84997, -2.67812, 'address', 'openstreetmap:node/5633750464'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:node-565021211', 'Alde Zaharreko Osasun Zentroa Vitoria-Gasteiz – Hedegile kalea', NULL, '01059', 'Hedegile kalea 108', '01001', 42.85065, -2.67337, 'address', 'openstreetmap:node/565021211'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:node-565021244', 'Aranbizkarra-1 Osasun Zentroa Vitoria-Gasteiz – Sierras Alavesas kalea', NULL, '01059', 'Sierras Alavesas kalea 20', '01002', 42.85153, -2.66446, 'address', 'openstreetmap:node/565021244'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-5659107159', 'Covirán Vitoria-Gasteiz – Diputazio kalea', NULL, '01059', 'Diputazio kalea 9', '01001', 42.84656, -2.67422, 'address', 'openstreetmap:node/5659107159'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-5659126244', 'Bodytec Vitoria-Gasteiz – Diputazio kalea', NULL, '01059', 'Diputazio kalea 12', '01001', 42.84701, -2.67451, 'address', 'openstreetmap:node/5659126244'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-5664286597', 'Fit Gune Vitoria-Gasteiz – Gaztelako atea', NULL, '01059', 'Gaztelako atea 3', '01007', 42.8439, -2.67858, 'address', 'openstreetmap:node/5664286597'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-566600992', 'Eroski Vitoria-Gasteiz – Brusela hiribidea', NULL, '01059', 'Brusela hiribidea 8', '01003', 42.84991, -2.65016, 'address', 'openstreetmap:node/566600992'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-568287996', 'Pepco Vitoria-Gasteiz – Gorbeia kalea', NULL, '01059', 'Gorbeia kalea 14', '01008', 42.84957, -2.67984, 'address', 'openstreetmap:node/568287996'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-569949284', 'Eroski City Vitoria-Gasteiz – Done Jakue hiribidea', NULL, '01059', 'Done Jakue hiribidea 47', '01003', 42.84788, -2.66065, 'address', 'openstreetmap:node/569949284'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-573686409', 'Eroski Vitoria-Gasteiz – Herminio Madinabeitia kalea', NULL, '01059', 'Herminio Madinabeitia kalea 8', '01006', 42.83694, -2.67057, 'address', 'openstreetmap:node/573686409'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-574303708', 'Simply Market Vitoria-Gasteiz – Arana kalea', NULL, '01059', 'Arana kalea 25', '01002', 42.8505, -2.66463, 'address', 'openstreetmap:node/574303708'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-574314936', 'PrimaPrix Vitoria-Gasteiz – Simon de Anda kalea', NULL, '01059', 'Simon de Anda kalea 2', '01012', 42.85453, -2.6759, 'address', 'openstreetmap:node/574314936'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-583228809', 'Covirán Vitoria-Gasteiz – Jacinto Benavente kalea', NULL, '01059', 'Jacinto Benavente kalea 7', '01003', 42.84536, -2.65783, 'address', 'openstreetmap:node/583228809'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-6037728436', 'Aiaraldea ekintzen faktoria Llodio – Errotari kalea 4-8', NULL, '01036', 'Errotari kalea 4-8', '01400', 43.13461, -2.96822, 'address', 'openstreetmap:node/6037728436'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-6037728441', 'Gorobel Kirol Gunea Llodio – 4-3', NULL, '01036', '4-3', '01400', 43.13423, -2.96894, 'address', 'openstreetmap:node/6037728441'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:node-6037728442', 'Crossfit Gorobel Llodio – 4-2', NULL, '01036', '4-2', '01400', 43.13415, -2.96909, 'address', 'openstreetmap:node/6037728442'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-6256048551', 'Covirán Vitoria-Gasteiz – Hondarribi kalea', NULL, '01059', 'Hondarribi kalea', '01010', 42.86592, -2.69544, 'address', 'openstreetmap:node/6256048551'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-6384413986', 'preco Oyón-Oion – Andra Mari Zuriaren kalea', NULL, '01043', 'Andra Mari Zuriaren kalea', '01320', 42.50378, -2.43649, 'address', 'openstreetmap:node/6384413986'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-6555143889', 'Covirán Aramaio – Nardeaga kalea', NULL, '01003', 'Nardeaga kalea 11', '01160', 43.05123, -2.56491, 'address', 'openstreetmap:node/6555143889'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-664006698', 'Eroski Llodio – Lamuza kalea', NULL, '01036', 'Lamuza kalea 5', '01400', 43.14366, -2.96342, 'address', 'openstreetmap:node/664006698'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-685782790', 'Rosa y Carmen Labastida / Bastida – Florida kalea', NULL, '01028', 'Florida kalea 6', '01330', 42.59006, -2.79416, 'address', 'openstreetmap:node/685782790'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-694745135', 'Eroski City Vitoria-Gasteiz – Ramiro Maeztu kalea', NULL, '01059', 'Ramiro Maeztu kalea 4', '01008', 42.847, -2.67889, 'address', 'openstreetmap:node/694745135'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-695211643', 'BM Llodio – Zumalakarregi etorbidea', NULL, '01036', 'Zumalakarregi etorbidea 15', '01400', 43.14547, -2.96021, 'address', 'openstreetmap:node/695211643'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-705054439', 'Dia Amurrio – Frontoi kalea', NULL, '01002', 'Frontoi kalea', '01470', 43.05326, -3.00095, 'address', 'openstreetmap:node/705054439'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-705058932', 'BM Amurrio – Intxaurdui kalea', NULL, '01002', 'Intxaurdui kalea', '01470', 43.05472, -2.9993, 'address', 'openstreetmap:node/705058932'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-762002132', 'Eroski City Vitoria-Gasteiz – Gasteiz hiribidea', NULL, '01059', 'Gasteiz hiribidea 9', '01008', 42.84355, -2.68288, 'address', 'openstreetmap:node/762002132'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-762002133', 'Eroski Vitoria-Gasteiz – Teodoro Dublang margolariaren kalea', NULL, '01059', 'Teodoro Dublang margolariaren kalea 51', '01008', 42.84314, -2.68363, 'address', 'openstreetmap:node/762002133'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-793171424', 'Aliprox Asparrena – Presalde kalea', NULL, '01009', 'Presalde kalea 2', '01250', 42.88944, -2.31664, 'address', 'openstreetmap:node/793171424'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-8725394817', 'Hiper Mendi Vitoria-Gasteiz – Sansomendi kalea', NULL, '01059', 'Sansomendi kalea 7', '01010', 42.85476, -2.69951, 'address', 'openstreetmap:node/8725394817'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-8872074817', 'Alcampo Vitoria-Gasteiz – Gasteiz hiribidea', NULL, '01059', 'Gasteiz hiribidea', '01008', 42.84485, -2.68261, 'address', 'openstreetmap:node/8872074817'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-9153171567', 'Eroski City Vitoria-Gasteiz – Manuel Iradier kalea', NULL, '01059', 'Manuel Iradier kalea 78', '01005', 42.84163, -2.66755, 'address', 'openstreetmap:node/9153171567'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:node-9689456807', 'Eroski City Alegría-Dulantzi – Gasteiz bidea', NULL, '01001', 'Gasteiz bidea 4', '01240', 42.84193, -2.51147, 'address', 'openstreetmap:node/9689456807'),
  ('Hospital', 'catalogo-pais-vasco:pais-vasco-resto:relation-10173615', 'Txagorritxuko ospitalea Vitoria-Gasteiz – Jose Atxotegi kalea', NULL, '01059', 'Jose Atxotegi kalea', '01009', 42.85476, -2.69033, 'address', 'openstreetmap:relation/10173615'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-1123855569', 'Eroski Agurain / Salvatierra – Foru kalea', NULL, '01051', 'Foru kalea', '01200', 42.85068, -2.38436, 'address', 'openstreetmap:way/1123855569'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-1131300143', 'Eroski Vitoria-Gasteiz – Voluntaria Entrega kalea', NULL, '01059', 'Voluntaria Entrega kalea', '01010', 42.86561, -2.68484, 'address', 'openstreetmap:way/1131300143'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-1183769273', 'Zabalganeko Osasun Zentroa Vitoria-Gasteiz – Ilustrazioaren hiribidea', NULL, '01059', 'Ilustrazioaren hiribidea 47', '01015', 42.84248, -2.7005, 'address', 'openstreetmap:way/1183769273'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-1202385978', 'Gizarte Segurantza Vitoria-Gasteiz – Eduardo Dato kalea', NULL, '01059', 'Eduardo Dato kalea 36', '01005', 42.84332, -2.67282, 'address', 'openstreetmap:way/1202385978'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-1226264146', 'Aldi Vitoria-Gasteiz – Budapest hiribidea', NULL, '01059', 'Budapest hiribidea', '01003', 42.84762, -2.65309, 'address', 'openstreetmap:way/1226264146'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-1226264147', 'BM Vitoria-Gasteiz – Praga hiribidea', NULL, '01059', 'Praga hiribidea', '01003', 42.84784, -2.65236, 'address', 'openstreetmap:way/1226264147'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-1230701513', 'Mercadona Vitoria-Gasteiz – Oñati kalea', NULL, '01059', 'Oñati kalea 2', '01013', 42.8583, -2.65985, 'address', 'openstreetmap:way/1230701513'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-1245732346', 'ALDI Vitoria-Gasteiz – Bremen kalea', NULL, '01059', 'Bremen kalea 4', '01010', 42.85507, -2.70844, 'address', 'openstreetmap:way/1245732346'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-1318508740', 'Centro de Salud Zuia-Murgia – Aiurdin kalea', NULL, '01063', 'Aiurdin kalea 6', '01130', 42.9578, -2.81845, 'address', 'openstreetmap:way/1318508740'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-1378028610', 'Centro de Salud de Samaniego – El Ochavo kalea', NULL, '01052', 'El Ochavo kalea', NULL, 42.56913, -2.67811, 'address', 'openstreetmap:way/1378028610'),
  ('Hospital', 'catalogo-pais-vasco:pais-vasco-resto:way-1442173706', 'MiKS Vitoria-Gasteiz – Baia ibaiaren kalea', NULL, '01059', 'Baia ibaiaren kalea 12', '01010', 42.86748, -2.69809, 'address', 'openstreetmap:way/1442173706'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-150169555', 'ALDI Vitoria-Gasteiz – Kantabrikoaren hiribidea', NULL, '01059', 'Kantabrikoaren hiribidea 10', '01013', 42.86433, -2.6599, 'address', 'openstreetmap:way/150169555'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-150169558', 'Lidl Vitoria-Gasteiz – Gamarrako atea', NULL, '01059', 'Gamarrako atea 38', '01013', 42.86321, -2.66042, 'address', 'openstreetmap:way/150169558'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-1531632265', 'Ayuntamiento de Añana – Plaza Don Miguel Díaz de Tuesta', NULL, '01049', 'Plaza Don Miguel Díaz de Tuesta 1', '01426', 42.80237, -2.98652, 'address', 'openstreetmap:way/1531632265'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-165816636', 'Zaramagako Osasun Zentroa Vitoria-Gasteiz – Barazar mendatearen kalea', NULL, '01059', 'Barazar mendatearen kalea 4', '01013', 42.85791, -2.67129, 'address', 'openstreetmap:way/165816636'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:way-192750509', 'Iota Vitoria-Gasteiz – Jeronimo Roure kalea', NULL, '01059', 'Jeronimo Roure kalea 22', '01010', 42.8505, -2.69499, 'address', 'openstreetmap:way/192750509'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-203559198', 'Mercadona Vitoria-Gasteiz – Andia mendiaren kalea', NULL, '01059', 'Andia mendiaren kalea 10', '01010', 42.86496, -2.68745, 'address', 'openstreetmap:way/203559198'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-204089965', 'Mercadona Vitoria-Gasteiz – Olarizu hiribidea', NULL, '01059', 'Olarizu hiribidea 1', '01006', 42.83468, -2.65936, 'address', 'openstreetmap:way/204089965'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-205029769', 'Lidl Vitoria-Gasteiz – Armentiagana kalea', NULL, '01059', 'Armentiagana kalea 1', '01007', 42.83674, -2.69795, 'address', 'openstreetmap:way/205029769'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-206313482', 'Dia Vitoria-Gasteiz – Triana kalea', NULL, '01059', 'Triana kalea 11', '01006', 42.83914, -2.6619, 'address', 'openstreetmap:way/206313482'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-210176581', 'Eroski City Vitoria-Gasteiz – Ozeano Barearen kalea 37-39', NULL, '01059', 'Ozeano Barearen kalea 37-39', '01010', 42.84993, -2.70169, 'address', 'openstreetmap:way/210176581'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-230059433', 'Guardiako Osasun Zentroa Laguardia – Espetxe plaza', NULL, '01031', 'Espetxe plaza 1', '01300', 42.55221, -2.58423, 'address', 'openstreetmap:way/230059433'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-235134402', 'Ayuntamiento de Urkabustaiz - Urkabustaizko Udaletxea – Udal plaza', NULL, '01054', 'Udal plaza 2', '01440', 42.9524, -2.90035, 'address', 'openstreetmap:way/235134402'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-236866843', 'Abetxukoko Osasun Zentroa Vitoria-Gasteiz – Kristo kalea', NULL, '01059', 'Kristo kalea 4', '01013', 42.87557, -2.6792, 'address', 'openstreetmap:way/236866843'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-237011986', 'Ayuntamiento de Zuia – 1', NULL, '01063', '1', '01130', 42.95631, -2.81997, 'address', 'openstreetmap:way/237011986'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-237013021', 'Ayuntamiento de Arratzua-Ubarrundia – Uribea kalea', NULL, '01008', 'Uribea kalea 12', '01520', 42.8899, -2.64022, 'address', 'openstreetmap:way/237013021'),
  ('Hospital', 'catalogo-pais-vasco:pais-vasco-resto:way-23714651', 'Santiagoko ospitalea Vitoria-Gasteiz – Olagibel kalea', NULL, '01059', 'Olagibel kalea 29', '01004', 42.84646, -2.66684, 'address', 'openstreetmap:way/23714651'),
  ('Centro comercial', 'catalogo-pais-vasco:pais-vasco-resto:way-239333776', 'Aretxaplaza Vitoria-Gasteiz – Iruraitz-Gauna kalea', NULL, '01059', 'Iruraitz-Gauna kalea 1', '01194', 42.83442, -2.66969, 'address', 'openstreetmap:way/239333776'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-239851213', 'Makro Vitoria-Gasteiz – Haitz kalea', NULL, '01059', 'Haitz kalea 11', '01013', 42.87177, -2.66862, 'address', 'openstreetmap:way/239851213'),
  ('Centro comercial', 'catalogo-pais-vasco:pais-vasco-resto:way-28735721', 'Centro Comercial Gorbeia Zigoitia', NULL, '01018', NULL, '01196', 42.91204, -2.71518, 'address', 'openstreetmap:way/28735721'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-288612604', 'Ayuntamiento de Bernedo – Gaztelu plaza', NULL, '01016', 'Gaztelu plaza', '01118', 42.62644, -2.49888, 'address', 'openstreetmap:way/288612604'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-289526060', 'Gizarte segurantzaren diruzaintza orokorra Vitoria-Gasteiz – Wellingtongo dukearen kalea', NULL, '01059', 'Wellingtongo dukearen kalea 31', '01010', 42.86599, -2.69687, 'address', 'openstreetmap:way/289526060'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-290655865', 'ALDI Vitoria-Gasteiz – Armentiagana kalea', NULL, '01059', 'Armentiagana kalea 11', '01007', 42.83599, -2.70014, 'address', 'openstreetmap:way/290655865'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-316079412', 'Eroski Llodio – Zumalakarregi etorbidea', NULL, '01036', 'Zumalakarregi etorbidea 64', '01400', 43.13762, -2.96922, 'address', 'openstreetmap:way/316079412'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-316358946', 'Mercadona Vitoria-Gasteiz – Armentiagana kalea', NULL, '01059', 'Armentiagana kalea 15', '01007', 42.8357, -2.7009, 'address', 'openstreetmap:way/316358946'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-34693624', 'Vitoria-Gasteizko Udaletxea Vitoria-Gasteiz – Mateo Benigno Moraza kalea', NULL, '01059', 'Mateo Benigno Moraza kalea 13', '01001', 42.84681, -2.67233, 'address', 'openstreetmap:way/34693624'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-35693976', 'Justizia Jauregia Vitoria-Gasteiz – Laskarai kalea', NULL, '01059', 'Laskarai kalea 8', '01008', 42.84363, -2.68187, 'address', 'openstreetmap:way/35693976'),
  ('Centro comercial', 'catalogo-pais-vasco:pais-vasco-resto:way-35817669', 'Lakua Vitoria-Gasteiz – Wellingtongo dukearen kalea 6A', NULL, '01059', 'Wellingtongo dukearen kalea 6A', '01010', 42.86171, -2.69272, 'address', 'openstreetmap:way/35817669'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-375123378', 'Arabako Ogasun Forala Vitoria-Gasteiz – Félix María Samaniego kalea', NULL, '01059', 'Félix María Samaniego kalea 18', '01008', 42.84836, -2.67803, 'address', 'openstreetmap:way/375123378'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-377963591', 'Eroski Vitoria-Gasteiz – Bremen kalea', NULL, '01059', 'Bremen kalea 6', '01010', 42.85455, -2.70953, 'address', 'openstreetmap:way/377963591'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-377973851', 'Mercadona Vitoria-Gasteiz – Düsseldorf kalea', NULL, '01059', 'Düsseldorf kalea 8', '01010', 42.8554, -2.71033, 'address', 'openstreetmap:way/377973851'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-396773147', 'Ayuntamiento Páganos Laguardia – Camino de Navaridas', NULL, '01031', 'Camino de Navaridas', '01309', 42.55779, -2.60505, 'address', 'openstreetmap:way/396773147'),
  ('Centro comercial', 'catalogo-pais-vasco:pais-vasco-resto:way-39960584', 'Centro Comercial Gazalbide merkataritza gunea Vitoria-Gasteiz – Jeanne Jugan kalea', NULL, '01059', 'Jeanne Jugan kalea 41', '01009', 42.85687, -2.68492, 'address', 'openstreetmap:way/39960584'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-40069657', 'Aranbizkarra-2 Osasun Zentroa Vitoria-Gasteiz – Burgos kalea', NULL, '01059', 'Burgos kalea 23', '01002', 42.85431, -2.65903, 'address', 'openstreetmap:way/40069657'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-40162822', 'E.Leclerc Vitoria-Gasteiz – Mahatma Ghandi kalea', NULL, '01059', 'Mahatma Ghandi kalea 1', '01015', 42.83881, -2.6993, 'address', 'openstreetmap:way/40162822'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-41174942', 'Gazalbide-Txagorritxuko Osasun Zentroa Vitoria-Gasteiz – Txile kalea', NULL, '01059', 'Txile kalea 9', '01009', 42.85183, -2.68571, 'address', 'openstreetmap:way/41174942'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-41624711', 'Lakuabizkarreko Osasun Zentroa Vitoria-Gasteiz – Wellingtongo dukearen kalea', NULL, '01059', 'Wellingtongo dukearen kalea 27', '01010', 42.86266, -2.69446, 'address', 'openstreetmap:way/41624711'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-41626652', 'San Martingo Osasun Zentroa Vitoria-Gasteiz – Teodoro Dublang margolariaren kalea', NULL, '01059', 'Teodoro Dublang margolariaren kalea 23', '01008', 42.84417, -2.68736, 'address', 'openstreetmap:way/41626652'),
  ('Centro comercial', 'catalogo-pais-vasco:pais-vasco-resto:way-44598761', 'Dendaraba Vitoria-Gasteiz – Bake kalea', NULL, '01059', 'Bake kalea 9', '01002', 42.8451, -2.66877, 'address', 'openstreetmap:way/44598761'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-45474575', 'Arabako Foru Aldundia Vitoria-Gasteiz – Probintzia plaza', NULL, '01059', 'Probintzia plaza 15', '01001', 42.84731, -2.67575, 'address', 'openstreetmap:way/45474575'),
  ('Centro comercial', 'catalogo-pais-vasco:pais-vasco-resto:way-45774297', 'Centro Salburua Vitoria-Gasteiz – Salburua bulebarra', NULL, '01059', 'Salburua bulebarra', '01003', 42.84949, -2.65001, 'address', 'openstreetmap:way/45774297'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-481328210', 'Lidl Vitoria-Gasteiz – Jauregilanda kalea', NULL, '01059', 'Jauregilanda kalea 12', '01006', 42.83357, -2.66718, 'address', 'openstreetmap:way/481328210'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-488531088', 'Aguraingo Osasun Zentroa Agurain / Salvatierra – Galzar kalea', NULL, '01051', 'Galzar kalea 1', '01200', 42.85067, -2.39075, 'address', 'openstreetmap:way/488531088'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-488535003', 'Aguraingo udaletxea Agurain / Salvatierra – Zapatari kalea', NULL, '01051', 'Zapatari kalea 15', '01200', 42.85038, -2.38991, 'address', 'openstreetmap:way/488535003'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-488543643', 'Donemiliagako Udaletxea San Millán / Donemiliaga – Andia kalea', NULL, '01053', 'Andia kalea 9', '01208', 42.87258, -2.37748, 'address', 'openstreetmap:way/488543643'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-488931079', 'Ayuntamiento de Elburgo/Burgelu – Burgeluko etorbidea', NULL, '01021', 'Burgeluko etorbidea 17', '01192', 42.85027, -2.5459, 'address', 'openstreetmap:way/488931079'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-489101505', 'Okondoko udaletxea Okondo – 1', NULL, '01042', '1', '01409', 43.16114, -3.02019, 'address', 'openstreetmap:way/489101505'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-489650478', 'Lapuebla de Labarcako udaletxea Lapuebla de Labarca – Plaza el Plano', NULL, '01033', 'Plaza el Plano', '01306', 42.49365, -2.57293, 'address', 'openstreetmap:way/489650478'),
  ('Centro comercial', 'catalogo-pais-vasco:pais-vasco-resto:way-496289777', 'El Boulevard Vitoria-Gasteiz – Zaramaga kalea', NULL, '01059', 'Zaramaga kalea 1', '01013', 42.86205, -2.66819, 'address', 'openstreetmap:way/496289777'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-496480244', 'Ayuntamiento de Ayala Ayala / Aiara – 3', NULL, '01010', '3', '01476', 43.07792, -3.04296, 'address', 'openstreetmap:way/496480244'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-496491221', 'Eroski Amurrio – Bañuetaibar kalea', NULL, '01002', 'Bañuetaibar kalea', '01470', 43.0532, -2.99728, 'address', 'openstreetmap:way/496491221'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-496491765', 'Amurrioko Osasun Zentroa Amurrio – Mendiko kalea', NULL, '01002', 'Mendiko kalea', '01470', 43.05462, -3.00302, 'address', 'openstreetmap:way/496491765'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-496491773', 'Amurrioko Udaletxea Amurrio – Larrinaga kalea', NULL, '01002', 'Larrinaga kalea', '01470', 43.05263, -3.00103, 'address', 'openstreetmap:way/496491773'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-504579257', 'Ayuntamiento de Zigoitia – Bengolarra kalea', NULL, '01018', 'Bengolarra kalea 1', '01138', 42.95767, -2.72991, 'address', 'openstreetmap:way/504579257'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-508776233', 'Eroski Ribera Baja / Erriberabeitia – Almendrondo kalea', NULL, '01047', 'Almendrondo kalea 1', '01213', 42.70526, -2.91895, 'address', 'openstreetmap:way/508776233'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-508776546', 'Ayuntamiento de Ribera Baja Ribera Baja / Erriberabeitia – San Martin plaza', NULL, '01047', 'San Martin plaza 1', '01213', 42.71229, -2.91869, 'address', 'openstreetmap:way/508776546'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-509083614', 'Lantaron Udaletxea – Udaletxe kalea', NULL, '01902', 'Udaletxe kalea 2', '01213', 42.71541, -2.98084, 'address', 'openstreetmap:way/509083614'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-509201816', 'Gaubeako udaletxea Valdegovía / Gaubea – Arquitecto Jesus Guinea Kalea', NULL, '01055', 'Arquitecto Jesus Guinea Kalea 48', '01426', 42.84824, -3.09822, 'address', 'openstreetmap:way/509201816'),
  ('Gimnasios', 'catalogo-pais-vasco:pais-vasco-resto:way-509206395', 'gym oyon Oyón-Oion – Zuia kalea', NULL, '01043', 'Zuia kalea', NULL, 42.50835, -2.4426, 'address', 'openstreetmap:way/509206395'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-509431042', 'Zanbranako udaletxea Zambrana – Udaletxe kalea', NULL, '01062', 'Udaletxe kalea 2', '01212', 42.66098, -2.87788, 'address', 'openstreetmap:way/509431042'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-509457701', 'Bastidako Osasun Zentroa Labastida / Bastida – Larrazuria kalea', NULL, '01028', 'Larrazuria kalea 2', '01330', 42.59136, -2.79538, 'address', 'openstreetmap:way/509457701'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-509592393', 'Ayuntamiento de Ribera Alta Erriberagoitia / Ribera Alta – Araba kalea', NULL, '01046', 'Araba kalea 2', '01420', 42.80555, -2.90736, 'address', 'openstreetmap:way/509592393'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-509613169', 'Kuartangoko Udaletxea Kuartango – 21A', NULL, '01020', '21A', '01430', 42.86977, -2.88739, 'address', 'openstreetmap:way/509613169'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-531739340', 'Kanpezuko Osasun Zentroa Campezo / Kanpezu – Samuel Picaza plaza', NULL, '01017', 'Samuel Picaza plaza 29', '01110', 42.66973, -2.35052, 'address', 'openstreetmap:way/531739340'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-54378304', 'BM Vitoria-Gasteiz – Wellingtongo dukearen kalea', NULL, '01059', 'Wellingtongo dukearen kalea 25', '01010', 42.86145, -2.69362, 'address', 'openstreetmap:way/54378304'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-586121368', 'Lakua-Arriagako Osasun Zentroa Vitoria-Gasteiz – Julian Arrese kalea', NULL, '01059', 'Julian Arrese kalea 5', '01010', 42.86698, -2.6844, 'address', 'openstreetmap:way/586121368'),
  ('Centro de salud', 'catalogo-pais-vasco:pais-vasco-resto:way-650341278', 'Salburuko Osasun Zentroa Vitoria-Gasteiz – Praga hiribidea', NULL, '01059', 'Praga hiribidea 2', '01003', 42.84828, -2.65193, 'address', 'openstreetmap:way/650341278'),
  ('Hospital', 'catalogo-pais-vasco:pais-vasco-resto:way-669430266', 'Lezako Ospitalea Laguardia – Lezako ospitalea kalea', NULL, '01031', 'Lezako ospitalea kalea', '01309', 42.57573, -2.6385, 'address', 'openstreetmap:way/669430266'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-721300120', 'Covirán Vitoria-Gasteiz – Oto hiribidea', NULL, '01059', 'Oto hiribidea 5', '01010', 42.85311, -2.69774, 'address', 'openstreetmap:way/721300120'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-76829364', 'Eroski City Vitoria-Gasteiz – Arriagako kofradiaren kalea', NULL, '01059', 'Arriagako kofradiaren kalea 12', '01012', 42.85684, -2.67721, 'address', 'openstreetmap:way/76829364'),
  ('Supermercado', 'catalogo-pais-vasco:pais-vasco-resto:way-82077869', 'Eroski Vitoria-Gasteiz – Bernedoko gazteluaren kalea', NULL, '01059', 'Bernedoko gazteluaren kalea 9', '01007', 42.84024, -2.69182, 'address', 'openstreetmap:way/82077869'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-82254392', 'Delegación del Gobierno Vitoria-Gasteiz – Frai Francisco Vitoria ibilbidea', NULL, '01059', 'Frai Francisco Vitoria ibilbidea 17', '01007', 42.84004, -2.6813, 'address', 'openstreetmap:way/82254392'),
  ('Entidad oficial', 'catalogo-pais-vasco:pais-vasco-resto:way-844251283', 'Bastidako udaletxea Labastida / Bastida – Kale Nagusia', NULL, '01028', 'Kale Nagusia 2', '01330', 42.59013, -2.79321, 'address', 'openstreetmap:way/844251283');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '01');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 01 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '01'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 189 THEN
    RAISE EXCEPTION 'Se esperaban 189 puntos de (varias) en Araba/Álava, hay %', n;
  END IF;
END;
$$;

COMMIT;
