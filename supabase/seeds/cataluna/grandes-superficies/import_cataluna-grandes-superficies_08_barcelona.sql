-- Carga de la categoría (varias) de Barcelona (provincia 08), trozo de la carga de Andalucía.
-- Origen: cataluna-grandes-superficies-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 134 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:node-10139433704', 'Leroy Merlin Vilanova i la Geltrú – Ronda d''Europa', NULL, '08307', 'Ronda d''Europa 46', '08800', 41.22726, 1.7407, 'address', 'openstreetmap:node/10139433704'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-10175799670', 'Carrefour Barcelona – Carrer de Còrsega', NULL, '08019', 'Carrer de Còrsega 388', '08037', 41.39956, 2.16359, 'address', 'openstreetmap:node/10175799670'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-10235173646', 'MediaMarkt Mataró – Carrer d''Estrasburg', NULL, '08121', 'Carrer d''Estrasburg', NULL, 41.55526, 2.43532, 'address', 'openstreetmap:node/10235173646'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-10235694997', 'MediaMarkt Gavà – Carrer del Progrès', NULL, '08089', 'Carrer del Progrès 69', '08850', 41.29487, 2.00767, 'address', 'openstreetmap:node/10235694997'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-11077789665', 'Carrefour Vilanova i la Geltrú – Avinguda del Penedès', NULL, '08307', 'Avinguda del Penedès 7', '08800', 41.22468, 1.73157, 'address', 'openstreetmap:node/11077789665'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-11245418169', 'Decathlon Granollers – Carrer d''Anselm Clavé', NULL, '08096', 'Carrer d''Anselm Clavé 35', '08400', 41.60734, 2.28886, 'address', 'openstreetmap:node/11245418169'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-11255746009', 'IKEA Barcelona – Avinguda Diagonal', NULL, '08019', 'Avinguda Diagonal 532', '08006', 41.39495, 2.15223, 'address', 'openstreetmap:node/11255746009'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-11265524697', 'MediaMarkt Barcelona – Avinguda Diagonal', NULL, '08019', 'Avinguda Diagonal 3', '08019', 41.40984, 2.21566, 'address', 'openstreetmap:node/11265524697'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-11433029546', 'Carrefour Manresa – Carrer del Ginjoler', NULL, '08113', 'Carrer del Ginjoler', '08242', 41.73082, 1.82285, 'address', 'openstreetmap:node/11433029546'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-11818060769', 'Carrefour Mataró – Carrer de Lepant', NULL, '08121', 'Carrer de Lepant', '08301', 41.53433, 2.44592, 'address', 'openstreetmap:node/11818060769'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-12628090501', 'Carrefour Barcelona – Carrer de Roger de Flor', NULL, '08019', 'Carrer de Roger de Flor 168', '08013', 41.39789, 2.17404, 'address', 'openstreetmap:node/12628090501'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:node-12855660301', 'Leroy Merlin Sant Boi de Llobregat – Carrer de les Alberedes', NULL, '08200', 'Carrer de les Alberedes 17', '08830', 41.32889, 2.04799, 'address', 'openstreetmap:node/12855660301'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-12888842328', 'Carrefour Sitges – Passeig de Vilanova', NULL, '08270', 'Passeig de Vilanova 27', '08870', 41.23778, 1.80575, 'address', 'openstreetmap:node/12888842328'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1300736841', 'Carrefour Gavà – Carrer de l''Energia', NULL, '08089', 'Carrer de l''Energia 30', '08850', 41.29588, 2.00759, 'address', 'openstreetmap:node/1300736841'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13062015849', 'Carrefour Vallromanes – Rambla de Vallromanes 42,44', NULL, '08296', 'Rambla de Vallromanes 42,44', '08188', 41.53102, 2.2978, 'address', 'openstreetmap:node/13062015849'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13278170359', 'Carrefour Barcelona – Carrer de Blai 20-18', NULL, '08019', 'Carrer de Blai 20-18', '08004', 41.37355, 2.16503, 'address', 'openstreetmap:node/13278170359'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13283310687', 'Carrefour Barcelona – Carrer de Rocafort', NULL, '08019', 'Carrer de Rocafort 31', '08015', 41.37641, 2.15692, 'address', 'openstreetmap:node/13283310687'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13283342695', 'Carrefour Barcelona – Carrer de Sants', NULL, '08019', 'Carrer de Sants 76', '08014', 41.37548, 2.13707, 'address', 'openstreetmap:node/13283342695'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13406424601', 'Carrefour Barcelona – Carrer del Congrés 70-64', NULL, '08019', 'Carrer del Congrés 70-64', '08042', 41.43673, 2.16159, 'address', 'openstreetmap:node/13406424601'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-13464094883', 'IKEA Barcelona – Avinguda Diagonal', NULL, '08019', 'Avinguda Diagonal 208', '08018', 41.4061, 2.19153, 'address', 'openstreetmap:node/13464094883'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-13472238601', 'Decathlon Sabadell – la Rambla', NULL, '08187', 'la Rambla 91', '08202', 41.54381, 2.11058, 'address', 'openstreetmap:node/13472238601'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13708126602', 'Carrefour Badalona – Avinguda de Catalunya', NULL, '08015', 'Avinguda de Catalunya', '08917', 41.45277, 2.23047, 'address', 'openstreetmap:node/13708126602'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1374317065', 'Carrefour Barcelona – Carrer del Capità Arenas 50-38', NULL, '08019', 'Carrer del Capità Arenas 50-38', '08034', 41.39202, 2.12594, 'address', 'openstreetmap:node/1374317065'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13758992369', 'Carrefour Pineda de Mar – Carrer del Doctor Josep M. Bertomeu', NULL, '08163', 'Carrer del Doctor Josep M. Bertomeu 12', '08397', 41.6236, 2.69084, 'address', 'openstreetmap:node/13758992369'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-1378087195', 'Decathlon Barcelona – Avinguda Diagonal', NULL, '08019', 'Avinguda Diagonal 557', '08029', 41.38936, 2.1333, 'address', 'openstreetmap:node/1378087195'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13905808569', 'Carrefour Barcelona – Carrer de la Renaixença 28-26', NULL, '08019', 'Carrer de la Renaixença 28-26', '08041', 41.41698, 2.17655, 'address', 'openstreetmap:node/13905808569'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13982703096', 'Carrefour Barcelona – Carrer de Maria Barrientos', NULL, '08019', 'Carrer de Maria Barrientos 2', '08028', 41.38001, 2.12699, 'address', 'openstreetmap:node/13982703096'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-14070891185', 'IKEA Sant Pere de Ribes – Rambla del Garraf', NULL, '08231', 'Rambla del Garraf', '08812', 41.23714, 1.75276, 'address', 'openstreetmap:node/14070891185'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1412078179', 'Carrefour Sant Cugat del Vallès – Avinguda de la Via Augusta 2-14', NULL, '08205', 'Avinguda de la Via Augusta 2-14', '08174', 41.48214, 2.05342, 'address', 'openstreetmap:node/1412078179'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-14166622608', 'MediaMarkt Sabadell – Centre Comercial Via Sabadell', NULL, '08187', 'Centre Comercial Via Sabadell', '08205', 41.5119, 2.1075, 'address', 'openstreetmap:node/14166622608'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-14173306746', 'Carrefour Vilanova i la Geltrú – Avinguda de Francesc Macià', NULL, '08307', 'Avinguda de Francesc Macià 90', '08800', 41.22226, 1.71965, 'address', 'openstreetmap:node/14173306746'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-14212464501', 'Carrefour Barcelona – Carrer de la Font Honrada', NULL, '08019', 'Carrer de la Font Honrada 25', '08004', 41.3737, 2.15602, 'address', 'openstreetmap:node/14212464501'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1722117637', 'Carrefour Barcelona – Carrer de la Marina', NULL, '08019', 'Carrer de la Marina 265', '08025', 41.40489, 2.17374, 'address', 'openstreetmap:node/1722117637'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1754693997', 'Carrefour Cabrera de Mar', NULL, '08029', NULL, NULL, 41.5195, 2.42238, 'address', 'openstreetmap:node/1754693997'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1800561623', 'Carrefour Terrassa – Carrer de Sant Llorenç', NULL, '08279', 'Carrer de Sant Llorenç 137', '08221', 41.5687, 2.01085, 'address', 'openstreetmap:node/1800561623'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-2077949590', 'Carrefour l''Hospitalet de Llobregat – Travessera de les Corts', NULL, '08101', 'Travessera de les Corts 50', '08903', 41.37761, 2.12128, 'address', 'openstreetmap:node/2077949590'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-2193421646', 'Carrefour Barcelona – Carrer del Perú 3-37', NULL, '08019', 'Carrer del Perú 3-37', '08018', 41.40563, 2.1917, 'address', 'openstreetmap:node/2193421646'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-2275100915', 'MediaMarkt Barcelona – Carrer de Casanova', NULL, '08019', 'Carrer de Casanova 2', '08011', 41.38227, 2.16328, 'address', 'openstreetmap:node/2275100915'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-2283772148', 'MediaMarkt Sant Cugat del Vallès – Avinguda de la Via Augusta 2-14', NULL, '08205', 'Avinguda de la Via Augusta 2-14', '08174', 41.48377, 2.05385, 'address', 'openstreetmap:node/2283772148'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-2821487621', 'Decathlon Barcelona – Carrer de la Canuda 8-20', NULL, '08019', 'Carrer de la Canuda 8-20', '08002', 41.38475, 2.17261, 'address', 'openstreetmap:node/2821487621'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-2962042533', 'Carrefour Barcelona – Carrer de Menorca', NULL, '08019', 'Carrer de Menorca', '08020', 41.42002, 2.19628, 'address', 'openstreetmap:node/2962042533'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-296278854', 'Carrefour Pineda de Mar – Carrer de Santiago Rusiñol', NULL, '08163', 'Carrer de Santiago Rusiñol 93', '08397', 41.62938, 2.69222, 'address', 'openstreetmap:node/296278854'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-312050319', 'Carrefour Granollers – Avinguda Europa', NULL, '08096', 'Avinguda Europa 4', '08400', 41.596, 2.28423, 'address', 'openstreetmap:node/312050319'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:node-3123673058', 'Leroy Merlin Barcelona – Paseo Portesí', NULL, '08019', 'Paseo Portesí 2', '08030', 41.44128, 2.19892, 'address', 'openstreetmap:node/3123673058'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-3743057425', 'Carrefour Barcelona – Carrer Nou de la Rambla 65-71', NULL, '08019', 'Carrer Nou de la Rambla 65-71', '08001', 41.37678, 2.17201, 'address', 'openstreetmap:node/3743057425'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-393934062', 'Carrefour l''Ametlla del Vallès – Autovia Barcelona - Vic - Ripoll C-17', NULL, '08005', 'Autovia Barcelona - Vic - Ripoll C-17 27', '08480', 41.6639, 2.26971, 'address', 'openstreetmap:node/393934062'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:node-4067806289', 'Leroy Merlin Manresa – Carrer d''Agustí Coll', NULL, '08113', 'Carrer d''Agustí Coll 2', '08243', 41.72322, 1.8482, 'address', 'openstreetmap:node/4067806289'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4254708858', 'Carrefour Barcelona – Carrer de Bailèn', NULL, '08019', 'Carrer de Bailèn 33', '08010', 41.39326, 2.17523, 'address', 'openstreetmap:node/4254708858'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-4317312311', 'Decathlon Barcelona – Carrer Gran de Gràcia', NULL, '08019', 'Carrer Gran de Gràcia 54', '08012', 41.39936, 2.15623, 'address', 'openstreetmap:node/4317312311'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4464201889', 'Carrefour Barcelona – Carrer de Casanova', NULL, '08019', 'Carrer de Casanova 89', '08011', 41.38626, 2.15735, 'address', 'openstreetmap:node/4464201889'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:node-4487191396', 'Leroy Merlin Sant Feliu de Llobregat – Carretera de Laureà Miró', NULL, '08211', 'Carretera de Laureà Miró 361', '08980', 41.38735, 2.04005, 'address', 'openstreetmap:node/4487191396'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-4643743349', 'MediaMarkt Barcelona – Carrer de Fontanella 6-8', NULL, '08019', 'Carrer de Fontanella 6-8', '08010', 41.38728, 2.17197, 'address', 'openstreetmap:node/4643743349'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-4675157089', 'MediaMarkt Barcelona – Avinguda Diagonal', NULL, '08019', 'Avinguda Diagonal 477', '08036', 41.39278, 2.14575, 'address', 'openstreetmap:node/4675157089'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4709933979', 'Carrefour l''Hospitalet de Llobregat – Avinguda de la Granvia de l''Hospitalet 75-93', NULL, '08101', 'Avinguda de la Granvia de l''Hospitalet 75-93', '08908', 41.35868, 2.1299, 'address', 'openstreetmap:node/4709933979'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4823518621', 'Carrefour Barcelona – Plaça de Rosa Galobardes i Alsina 1-2', NULL, '08019', 'Plaça de Rosa Galobardes i Alsina 1-2', '08041', 41.4193, 2.17894, 'address', 'openstreetmap:node/4823518621'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4987483486', 'Carrefour Vilafranca del Penedès – Carrer de Santa Digna', NULL, '08305', 'Carrer de Santa Digna 3', '08720', 41.34553, 1.70192, 'address', 'openstreetmap:node/4987483486'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5198201128', 'Carrefour Barcelona – Carrer del Torrent de l''Olla', NULL, '08019', 'Carrer del Torrent de l''Olla', '08012', 41.40092, 2.15892, 'address', 'openstreetmap:node/5198201128'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5199743029', 'Carrefour Barcelona – Carrer de Balmes', NULL, '08019', 'Carrer de Balmes 62', '08007', 41.38973, 2.16233, 'address', 'openstreetmap:node/5199743029'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-533817733', 'Carrefour Badalona – AVDA COMUNIDAD EUROPEA S/N', NULL, '08015', 'AVDA COMUNIDAD EUROPEA S/N', NULL, 41.45631, 2.22765, 'address', 'openstreetmap:node/533817733'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5462444822', 'Carrefour Pineda de Mar – Carrer Garbí 123-137', NULL, '08163', 'Carrer Garbí 123-137', '08397', 41.62264, 2.6735, 'address', 'openstreetmap:node/5462444822'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5647371592', 'Carrefour Badalona – Avinguda d''en Martí Pujol', NULL, '08015', 'Avinguda d''en Martí Pujol', '08911', 41.44671, 2.24805, 'address', 'openstreetmap:node/5647371592'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5660831206', 'Carrefour Santa Susanna – Plaça del Sot de la Bòbila', NULL, '08261', 'Plaça del Sot de la Bòbila', NULL, 41.63674, 2.71744, 'address', 'openstreetmap:node/5660831206'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5807191693', 'Carrefour Barberà del Vallès', NULL, '08252', NULL, '08210', 41.50787, 2.13885, 'address', 'openstreetmap:node/5807191693'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-5834511041', 'MediaMarkt Barcelona – Carrer de São Paulo 11-31', NULL, '08019', 'Carrer de São Paulo 11-31', '08030', 41.43954, 2.19909, 'address', 'openstreetmap:node/5834511041'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-5834511055', 'Decathlon Barcelona – Carrer de la República Dominicana 1-23', NULL, '08019', 'Carrer de la República Dominicana 1-23', '08030', 41.43951, 2.19706, 'address', 'openstreetmap:node/5834511055'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5948445348', 'Carrefour Castelldefels – Carrer de Granada 43B', NULL, '08056', 'Carrer de Granada 43B', '08860', 41.27067, 1.98098, 'address', 'openstreetmap:node/5948445348'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-6005784586', 'Carrefour Barcelona – Carrer d''Escuder', NULL, '08019', 'Carrer d''Escuder 10', '08003', 41.37955, 2.18889, 'address', 'openstreetmap:node/6005784586'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-630717835', 'Carrefour Badalona – Ronda de Sant Antoni de Llefià 108-112', NULL, '08015', 'Ronda de Sant Antoni de Llefià 108-112', '08913', 41.44165, 2.21919, 'address', 'openstreetmap:node/630717835'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-6355587421', 'Carrefour Barcelona – Carrer de Sants', NULL, '08019', 'Carrer de Sants 311', '08028', 41.37546, 2.12828, 'address', 'openstreetmap:node/6355587421'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-6786006488', 'Carrefour Barcelona – Carrer de Sant Antoni Abat 8-6', NULL, '08019', 'Carrer de Sant Antoni Abat 8-6', '08001', 41.37953, 2.16558, 'address', 'openstreetmap:node/6786006488'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:node-7023809585', 'Leroy Merlin Lliçà d''Amunt – Comerç', NULL, '08107', 'Comerç 3', '08186', 41.60331, 2.25971, 'address', 'openstreetmap:node/7023809585'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-7331412969', 'Decathlon l''Hospitalet de Llobregat – Avinguda de la Granvia de l''Hospitalet', NULL, '08101', 'Avinguda de la Granvia de l''Hospitalet 75', '08908', 41.35983, 2.13013, 'address', 'openstreetmap:node/7331412969'),
  ('El Corte Inglés', 'catalogo-cataluna:cataluna-grandes-superficies:node-7800879757', 'El Corte Inglés Sabadell – Avinguda de Francesc Macià', NULL, '08187', 'Avinguda de Francesc Macià 58', '08208', 41.55449, 2.09799, 'address', 'openstreetmap:node/7800879757'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-8005860686', 'Carrefour Barcelona – Carrer de l''Alcalde de Móstoles', NULL, '08019', 'Carrer de l''Alcalde de Móstoles 12', '08025', 41.41031, 2.16702, 'address', 'openstreetmap:node/8005860686'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-8280569572', 'Carrefour Olèrdola – Avinguda del Garraf', NULL, '08145', 'Avinguda del Garraf', '08799', 41.35555, 1.73958, 'address', 'openstreetmap:node/8280569572'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-8561846807', 'Carrefour Badalona – Carretera Antiga de València', NULL, '08015', 'Carretera Antiga de València 41', '08914', 41.43841, 2.22468, 'address', 'openstreetmap:node/8561846807'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-8686618295', 'Carrefour Barcelona – Carrer dels Caponata 10-12', NULL, '08019', 'Carrer dels Caponata 10-12', '08034', 41.39567, 2.12165, 'address', 'openstreetmap:node/8686618295'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-8709834299', 'Carrefour Barcelona – Carrer de Dante Alighieri', NULL, '08019', 'Carrer de Dante Alighieri 119', '08032', 41.42665, 2.15514, 'address', 'openstreetmap:node/8709834299'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-8848625517', 'Decathlon Sant Cugat del Vallès – Avinguda de la Via Augusta', NULL, '08205', 'Avinguda de la Via Augusta', '08174', 41.48273, 2.05399, 'address', 'openstreetmap:node/8848625517'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-9020073542', 'Decathlon Barcelona – Avinguda Diagonal', NULL, '08019', 'Avinguda Diagonal 3', '08001', 41.41027, 2.21797, 'address', 'openstreetmap:node/9020073542'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:node-9040148067', 'Leroy Merlin Barcelona – Carrer de Fontanella', NULL, '08019', 'Carrer de Fontanella 12', '08002', 41.38763, 2.17224, 'address', 'openstreetmap:node/9040148067'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-9237881397', 'Carrefour Barcelona – Gran Via de les Corts Catalanes', NULL, '08019', 'Gran Via de les Corts Catalanes 573', '08011', 41.38506, 2.16199, 'address', 'openstreetmap:node/9237881397'),
  ('El Corte Inglés', 'catalogo-cataluna:cataluna-grandes-superficies:node-9445951495', 'El Corte Inglés Cornellà de Llobregat – Carrer Salvador Dalí 15-17', NULL, '08073', 'Carrer Salvador Dalí 15-17', '08940', 41.3548, 2.0881, 'address', 'openstreetmap:node/9445951495'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-9759339663', 'Carrefour Barcelona – Via Laietana 48A', NULL, '08019', 'Via Laietana 48A', '08003', 41.38677, 2.17523, 'address', 'openstreetmap:node/9759339663'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-9796858352', 'Carrefour Barcelona – Carrer de Lleida', NULL, '08019', 'Carrer de Lleida 1', '08004', 41.37468, 2.15451, 'address', 'openstreetmap:node/9796858352'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-9825433617', 'IKEA Barcelona – Travessera de Gràcia', NULL, '08019', 'Travessera de Gràcia 12', '08021', 41.39386, 2.14624, 'address', 'openstreetmap:node/9825433617'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-9874079961', 'Carrefour Barcelona – La Rambla', NULL, '08019', 'La Rambla 113', '08002', 41.38395, 2.17083, 'address', 'openstreetmap:node/9874079961'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-9959872822', 'Carrefour Barcelona – Carrer de l''Or', NULL, '08019', 'Carrer de l''Or 48', '08012', 41.40497, 2.15788, 'address', 'openstreetmap:node/9959872822'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:relation-18325338', 'Carrefour Martorell – Passatge del Masset', NULL, '08114', 'Passatge del Masset', NULL, 41.48252, 1.91861, 'address', 'openstreetmap:relation/18325338'),
  ('El Corte Inglés', 'catalogo-cataluna:cataluna-grandes-superficies:relation-9081595', 'El Corte Inglés Barcelona – Gran Via de Carles III', NULL, '08019', 'Gran Via de Carles III 100', '08028', 41.38728, 2.12814, 'address', 'openstreetmap:relation/9081595'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-1119270733', 'MediaMarkt Vilanova i la Geltrú – Carrer de l''Acer', NULL, '08307', 'Carrer de l''Acer', '08800', 41.23775, 1.72863, 'address', 'openstreetmap:way/1119270733'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-1119270740', 'Decathlon Vilanova i la Geltrú – Carrer del Ciment', NULL, '08307', 'Carrer del Ciment', '08800', 41.2372, 1.72697, 'address', 'openstreetmap:way/1119270740'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-1186002287', 'Leroy Merlin Sabadell – Centre Comercial Via Sabadell', NULL, '08187', 'Centre Comercial Via Sabadell', '08205', 41.51348, 2.10535, 'address', 'openstreetmap:way/1186002287'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-124198596', 'Carrefour Viladecans – Avinguda de Gavà', NULL, '08301', 'Avinguda de Gavà', '08840', 41.30948, 2.01279, 'address', 'openstreetmap:way/124198596'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-124215558', 'MediaMarkt Sant Boi de Llobregat – Carrer dels Hortells 6-8', NULL, '08200', 'Carrer dels Hortells 6-8', '08830', 41.32791, 2.04723, 'address', 'openstreetmap:way/124215558'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-1526542561', 'MediaMarkt el Prat de Llobregat', NULL, '08169', NULL, '08940', 41.34727, 2.07674, 'address', 'openstreetmap:way/1526542561'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-1553650736', 'Carrefour Sitges – Carrer de la Devesa', NULL, '08270', 'Carrer de la Devesa 7', '08870', 41.23883, 1.81997, 'address', 'openstreetmap:way/1553650736'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-155797494', 'Leroy Merlin Cabrera de Mar', NULL, '08029', NULL, '08349', 41.51864, 2.4205, 'address', 'openstreetmap:way/155797494'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-1558213121', 'Decathlon el Prat de Llobregat', NULL, '08169', NULL, '08940', 41.34685, 2.07716, 'address', 'openstreetmap:way/1558213121'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-156357088', 'Carrefour Manresa – Carrer de Mercè Rodoreda', NULL, '08113', 'Carrer de Mercè Rodoreda', NULL, 41.7228, 1.84477, 'address', 'openstreetmap:way/156357088'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-156357101', 'Decathlon Manresa – Carrer de Damià Rius', NULL, '08113', 'Carrer de Damià Rius', NULL, 41.72569, 1.84693, 'address', 'openstreetmap:way/156357101'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-166369644', 'Leroy Merlin Vic – Carretera de Manlleu a Vic', NULL, '08298', 'Carretera de Manlleu a Vic', '08500', 41.94398, 2.2585, 'address', 'openstreetmap:way/166369644'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-166369664', 'Decathlon Vic – Carrer d''Abraham Cresques', NULL, '08298', 'Carrer d''Abraham Cresques', NULL, 41.94499, 2.25899, 'address', 'openstreetmap:way/166369664'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-180222391', 'Carrefour Vic – Carrer Torelló', NULL, '08298', 'Carrer Torelló', NULL, 41.93037, 2.26609, 'address', 'openstreetmap:way/180222391'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-183256010', 'Decathlon Mollet del Vallès – Avinguda dels Rabassaires', NULL, '08124', 'Avinguda dels Rabassaires', '08100', 41.54256, 2.22291, 'address', 'openstreetmap:way/183256010'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:way-196187036', 'IKEA Sabadell – Centre Comercial Via Sabadell', NULL, '08187', 'Centre Comercial Via Sabadell', '08205', 41.51019, 2.10668, 'address', 'openstreetmap:way/196187036'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-197369439', 'Decathlon Mataró – Plaça de França', NULL, '08121', 'Plaça de França', NULL, 41.55056, 2.42994, 'address', 'openstreetmap:way/197369439'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-212508031', 'Carrefour Cubelles – Carrer del Rosselló', NULL, '08074', 'Carrer del Rosselló', '08880', 41.20035, 1.64984, 'address', 'openstreetmap:way/212508031'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-213373783', 'Carrefour Sant Fruitós de Bages – CARRETERA MANRESA A BERGA KM.', NULL, '08213', 'CARRETERA MANRESA A BERGA KM. 1', '08272', 41.75119, 1.86201, 'address', 'openstreetmap:way/213373783'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-224092662', 'Carrefour Castelldefels – Carrer Antic Camí Ral de Valencia 21-39', NULL, '08056', 'Carrer Antic Camí Ral de Valencia 21-39', '08860', 41.28031, 1.98396, 'address', 'openstreetmap:way/224092662'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-234908177', 'Decathlon Badalona – Carrer de Luxemburg', NULL, '08015', 'Carrer de Luxemburg', '08917', 41.45838, 2.22608, 'address', 'openstreetmap:way/234908177'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-234908179', 'Leroy Merlin Badalona – Carrer de Dinamarca', NULL, '08015', 'Carrer de Dinamarca 4', '08917', 41.45929, 2.22775, 'address', 'openstreetmap:way/234908179'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:way-234908182', 'IKEA Badalona – Carrer de Luxemburg', NULL, '08015', 'Carrer de Luxemburg 7', '08917', 41.45929, 2.22541, 'address', 'openstreetmap:way/234908182'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-255352392', 'Carrefour Cardedeu – Carrer de Mossèn Garriga', NULL, '08046', 'Carrer de Mossèn Garriga', NULL, 41.63765, 2.37332, 'address', 'openstreetmap:way/255352392'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-259239861', 'MediaMarkt Parets del Vallès – Carrer Comte de Montemolín', NULL, '08159', 'Carrer Comte de Montemolín 16', '08150', 41.55962, 2.23066, 'address', 'openstreetmap:way/259239861'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-295253356', 'Carrefour el Prat de Llobregat – Autovia de Castelldefels', NULL, '08169', 'Autovia de Castelldefels', '08820', 41.33499, 2.0884, 'address', 'openstreetmap:way/295253356'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-316081856', 'Carrefour Vic – Carrer de la Llotja', NULL, '08298', 'Carrer de la Llotja 6', '08500', 41.92622, 2.24617, 'address', 'openstreetmap:way/316081856'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:way-33778434', 'IKEA l''Hospitalet de Llobregat – Avinguda de la Gran Via de l''Hospitalet 115-134', NULL, '08101', 'Avinguda de la Gran Via de l''Hospitalet 115-134', '08908', 41.35472, 2.12385, 'address', 'openstreetmap:way/33778434'),
  ('El Corte Inglés', 'catalogo-cataluna:cataluna-grandes-superficies:way-338512116', 'El Corte Inglés Barcelona – Plaça de Catalunya 14-16', NULL, '08019', 'Plaça de Catalunya 14-16', '08002', 41.38786, 2.17116, 'address', 'openstreetmap:way/338512116'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-351080377', 'Carrefour Berga – Carrer de Gironella', NULL, '08022', 'Carrer de Gironella', NULL, 42.09565, 1.84904, 'address', 'openstreetmap:way/351080377'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-365148076', 'Leroy Merlin Sant Cugat del Vallès – Carrertera de Rubí', NULL, '08205', 'Carrertera de Rubí 7', '08174', 41.48185, 2.04526, 'address', 'openstreetmap:way/365148076'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-36845031', 'Carrefour Igualada – Avinguda dels Països Catalans', NULL, '08102', 'Avinguda dels Països Catalans', NULL, 41.59056, 1.61696, 'address', 'openstreetmap:way/36845031'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-377631479', 'Decathlon Terrassa – Avinguda del Tèxtil', NULL, '08279', 'Avinguda del Tèxtil', '08223', 41.5445, 2.02681, 'address', 'openstreetmap:way/377631479'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-380042322', 'MediaMarkt Terrassa – Avinguda del Tèxtil', NULL, '08279', 'Avinguda del Tèxtil', '08223', 41.54539, 2.02542, 'address', 'openstreetmap:way/380042322'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-51245229', 'Carrefour Terrassa – Carrer d''Extremadura', NULL, '08279', 'Carrer d''Extremadura', '08227', 41.56511, 2.03694, 'address', 'openstreetmap:way/51245229'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-52493273', 'Carrefour Terrassa – Carrer d''Europa', NULL, '08279', 'Carrer d''Europa', NULL, 41.54162, 2.0437, 'address', 'openstreetmap:way/52493273'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-525051681', 'Carrefour Cerdanyola del Vallès – RONDA CERDANYOLA, S/N', NULL, '08266', 'RONDA CERDANYOLA, S/N', NULL, 41.48935, 2.15131, 'address', 'openstreetmap:way/525051681'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-531844020', 'Decathlon Sant Boi de Llobregat – Carrer de la Riera Roja 33-35', NULL, '08200', 'Carrer de la Riera Roja 33-35', NULL, 41.32747, 2.04766, 'address', 'openstreetmap:way/531844020'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-619213975', 'Carrefour Barcelona – Carrer de la Ciutat d''Asunción', NULL, '08019', 'Carrer de la Ciutat d''Asunción 69', '08030', 41.44212, 2.19875, 'address', 'openstreetmap:way/619213975'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-651581556', 'Decathlon Esplugues de Llobregat – Carrer de Sant Mateu', NULL, '08077', 'Carrer de Sant Mateu', '08950', 41.3771, 2.09933, 'address', 'openstreetmap:way/651581556'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-651581560', 'MediaMarkt Esplugues de Llobregat – Carrer Sant Mateu', NULL, '08077', 'Carrer Sant Mateu 9', '08950', 41.3772, 2.09738, 'address', 'openstreetmap:way/651581560'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-668160156', 'Carrefour Palau-solità i Plegamans – Carrer dels Boters', NULL, '08156', 'Carrer dels Boters', NULL, 41.57805, 2.18132, 'address', 'openstreetmap:way/668160156'),
  ('El Corte Inglés', 'catalogo-cataluna:cataluna-grandes-superficies:way-82608130', 'El Corte Inglés Barcelona – Passeig d''Andreu Nin', NULL, '08019', 'Passeig d''Andreu Nin 51', '08016', 41.43623, 2.18145, 'address', 'openstreetmap:way/82608130'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-948429213', 'Carrefour Igualada – Passeig Mossèn Jacint Verdaguer', NULL, '08102', 'Passeig Mossèn Jacint Verdaguer 199', '08700', 41.57818, 1.63088, 'address', 'openstreetmap:way/948429213');

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
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 134 THEN
    RAISE EXCEPTION 'Se esperaban 134 puntos de (varias) en Barcelona, hay %', n;
  END IF;
END;
$$;

COMMIT;
