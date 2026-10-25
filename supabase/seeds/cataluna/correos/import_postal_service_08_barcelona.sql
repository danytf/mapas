-- Carga de la categoría Correos de Barcelona (provincia 08), trozo de la carga de Andalucía.
-- Origen: postal_service-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 143 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cataluna:postal_service:node-10589777448', 'Correos Vilanova i la Geltrú – Camí de la Masia d''en Frederic', NULL, '08307', 'Camí de la Masia d''en Frederic 2', '08800', 41.22856, 1.72497, 'address', 'openstreetmap:node/10589777448'),
  ('catalogo-cataluna:postal_service:node-10693051632', 'Correos Taradell – Carretera de Balenyà', NULL, '08278', 'Carretera de Balenyà', '08552', 41.87355, 2.28626, 'address', 'openstreetmap:node/10693051632'),
  ('catalogo-cataluna:postal_service:node-10976184042', 'Correos Prats de Lluçanès – Plaça Vella', NULL, '08171', 'Plaça Vella', NULL, 42.00726, 2.02944, 'address', 'openstreetmap:node/10976184042'),
  ('catalogo-cataluna:postal_service:node-11028575871', 'Correos Barcelona – Avinguda de la República Argentina', NULL, '08019', 'Avinguda de la República Argentina 274', '08023', 41.41389, 2.1383, 'address', 'openstreetmap:node/11028575871'),
  ('catalogo-cataluna:postal_service:node-11032313002', 'Correos Barcelona – Avinguda del Paral·lel', NULL, '08019', 'Avinguda del Paral·lel 86', '08015', 41.37517, 2.16676, 'address', 'openstreetmap:node/11032313002'),
  ('catalogo-cataluna:postal_service:node-11032902019', 'Correos Vilanova i la Geltrú – Plaça de les Neus', NULL, '08307', 'Plaça de les Neus 11', '08800', 41.22631, 1.72325, 'address', 'openstreetmap:node/11032902019'),
  ('catalogo-cataluna:postal_service:node-11034130538', 'Correos Barcelona – Avinguda dels Rasos de Peguera', NULL, '08019', 'Avinguda dels Rasos de Peguera 19', '08033', 41.46112, 2.17818, 'address', 'openstreetmap:node/11034130538'),
  ('catalogo-cataluna:postal_service:node-11167879561', 'Correos Centelles – Rambla Camp de l''Aigua 1-3', NULL, '08067', 'Rambla Camp de l''Aigua 1-3', NULL, 41.79714, 2.21608, 'address', 'openstreetmap:node/11167879561'),
  ('catalogo-cataluna:postal_service:node-11635077644', 'Correos Barcelona – Passeig de Sant Joan', NULL, '08019', 'Passeig de Sant Joan 196', '08037', 41.404, 2.16394, 'address', 'openstreetmap:node/11635077644'),
  ('catalogo-cataluna:postal_service:node-11933917169', 'Correos Igualada – Carrer de Piera', NULL, '08102', 'Carrer de Piera 6', '08700', 41.58652, 1.61582, 'address', 'openstreetmap:node/11933917169'),
  ('catalogo-cataluna:postal_service:node-11936652670', 'Correos Mediona – Avinguda d''en Gaudí', NULL, '08122', 'Avinguda d''en Gaudí', '08773', 41.47718, 1.61034, 'address', 'openstreetmap:node/11936652670'),
  ('catalogo-cataluna:postal_service:node-12126263942', 'Correos Vallbona d''Anoia – Carrer Major', NULL, '08292', 'Carrer Major 36', '08785', 41.51867, 1.70646, 'address', 'openstreetmap:node/12126263942'),
  ('catalogo-cataluna:postal_service:node-1240953919', 'Correos Barberà del Vallès – Carretera de Barcelona', NULL, '08252', 'Carretera de Barcelona', '08210', 41.51574, 2.12658, 'address', 'openstreetmap:node/1240953919'),
  ('catalogo-cataluna:postal_service:node-12426031526', 'Correos Badalona – Plaça de l''Assemblea de Catalunya,', NULL, '08015', 'Plaça de l''Assemblea de Catalunya, 13', '08911', 41.45188, 2.24858, 'address', 'openstreetmap:node/12426031526'),
  ('catalogo-cataluna:postal_service:node-1254266485', 'Correos Sant Pol de Mar – Carrer de Santa Clara', NULL, '08235', 'Carrer de Santa Clara 5', '08395', 41.60162, 2.62147, 'address', 'openstreetmap:node/1254266485'),
  ('catalogo-cataluna:postal_service:node-1300736846', 'Correos Gavà – Passatge de Martí l''Humà', NULL, '08089', 'Passatge de Martí l''Humà 6', '08850', 41.30419, 1.99738, 'address', 'openstreetmap:node/1300736846'),
  ('catalogo-cataluna:postal_service:node-1312325094', 'Correos Barcelona – Carrer d''Arenys', NULL, '08019', 'Carrer d''Arenys 18', '08035', 41.42189, 2.14207, 'address', 'openstreetmap:node/1312325094'),
  ('catalogo-cataluna:postal_service:node-13860663904', 'Correos Badalona – Carrer de Manuel Moreno Mauricio', NULL, '08015', 'Carrer de Manuel Moreno Mauricio 5', '08917', 41.45531, 2.22594, 'address', 'openstreetmap:node/13860663904'),
  ('catalogo-cataluna:postal_service:node-1395188535', 'Correos Sant Cugat del Vallès – Rambla de Can Mora', NULL, '08205', 'Rambla de Can Mora 11', '08172', 41.46823, 2.08255, 'address', 'openstreetmap:node/1395188535'),
  ('catalogo-cataluna:postal_service:node-14183515147', 'Correos Barcelona – Plaça d''Antonio López', NULL, '08019', 'Plaça d''Antonio López 1', '08002', 41.38162, 2.18124, 'address', 'openstreetmap:node/14183515147'),
  ('catalogo-cataluna:postal_service:node-14293777901', 'Correos Borredà – Carrer de Dalt', NULL, '08024', 'Carrer de Dalt', '08619', 42.13657, 1.99445, 'address', 'openstreetmap:node/14293777901'),
  ('catalogo-cataluna:postal_service:node-1558088706', 'Correos Barcelona – Gran Via de les Corts Catalanes', NULL, '08019', 'Gran Via de les Corts Catalanes 282', '08004', 41.37162, 2.14502, 'address', 'openstreetmap:node/1558088706'),
  ('catalogo-cataluna:postal_service:node-1621857134', 'Correos Sant Adrià de Besòs – Carrer de les Monges', NULL, '08194', 'Carrer de les Monges 7', '08930', 41.43344, 2.21513, 'address', 'openstreetmap:node/1621857134'),
  ('catalogo-cataluna:postal_service:node-1622943020', 'Correos Avià – Carrer del Portal', NULL, '08011', 'Carrer del Portal', NULL, 42.07705, 1.82506, 'address', 'openstreetmap:node/1622943020'),
  ('catalogo-cataluna:postal_service:node-1623401589', 'Correos l''Hospitalet de Llobregat – Carrer de Martí-Codolar', NULL, '08101', 'Carrer de Martí-Codolar 43', '08902', 41.36843, 2.12975, 'address', 'openstreetmap:node/1623401589'),
  ('catalogo-cataluna:postal_service:node-1623903421', 'Correos Sabadell – Carrer dels Estampadors', NULL, '08187', 'Carrer dels Estampadors', NULL, 41.52959, 2.11446, 'address', 'openstreetmap:node/1623903421'),
  ('catalogo-cataluna:postal_service:node-1631897537', 'Correos Sant Just Desvern – Carrer Font', NULL, '08221', 'Carrer Font 25', '08960', 41.38162, 2.07144, 'address', 'openstreetmap:node/1631897537'),
  ('catalogo-cataluna:postal_service:node-1643553562', 'Correos Sant Joan de Vilatorrada – carrer de Vilatorrada', NULL, '08218', 'carrer de Vilatorrada 92', '08250', 41.7457, 1.80566, 'address', 'openstreetmap:node/1643553562'),
  ('catalogo-cataluna:postal_service:node-1666836328', 'Correos Canovelles – 2', NULL, '08041', '2', '08420', 41.6195, 2.28036, 'address', 'openstreetmap:node/1666836328'),
  ('catalogo-cataluna:postal_service:node-1855324831', 'Correos el Masnou – Carrer d''Itàlia', NULL, '08118', 'Carrer d''Itàlia 10', '08320', 41.48305, 2.31828, 'address', 'openstreetmap:node/1855324831'),
  ('catalogo-cataluna:postal_service:node-1908094885', 'Correos Mollet del Vallès – Carrer d''Antònia Canet', NULL, '08124', 'Carrer d''Antònia Canet 15', '08100', 41.53913, 2.21136, 'address', 'openstreetmap:node/1908094885'),
  ('catalogo-cataluna:postal_service:node-1919115506', 'Correos Barcelona – Carrer d''Alcúdia', NULL, '08019', 'Carrer d''Alcúdia 43', '08016', 41.43614, 2.17437, 'address', 'openstreetmap:node/1919115506'),
  ('catalogo-cataluna:postal_service:node-1948958162', 'Correos Barcelona – Consell de Cent', NULL, '08019', 'Consell de Cent 445', '08013', 41.39792, 2.17458, 'address', 'openstreetmap:node/1948958162'),
  ('catalogo-cataluna:postal_service:node-1948962336', 'Correos Barcelona – Ronda de la Universitat', NULL, '08019', 'Ronda de la Universitat 23', '08007', 41.38687, 2.16673, 'address', 'openstreetmap:node/1948962336'),
  ('catalogo-cataluna:postal_service:node-1948963687', 'Correos Barcelona – Doctor Trueta 58-60', NULL, '08019', 'Doctor Trueta 58-60', '08018', 41.39258, 2.19566, 'address', 'openstreetmap:node/1948963687'),
  ('catalogo-cataluna:postal_service:node-1948965608', 'Correos Barcelona – Avinguda de Roma', NULL, '08019', 'Avinguda de Roma 119', '08036', 41.38584, 2.15494, 'address', 'openstreetmap:node/1948965608'),
  ('catalogo-cataluna:postal_service:node-1948968138', 'Correos Barcelona – Carrer Gran de Gràcia', NULL, '08019', 'Carrer Gran de Gràcia 118', '08008', 41.40127, 2.15394, 'address', 'openstreetmap:node/1948968138'),
  ('catalogo-cataluna:postal_service:node-1948969302', 'Correos Barcelona – Comte de Salvatierra', NULL, '08019', 'Comte de Salvatierra 5', '08008', 41.39637, 2.15424, 'address', 'openstreetmap:node/1948969302'),
  ('catalogo-cataluna:postal_service:node-1948969931', 'Correos Barcelona – Carrer de Pau Alsina', NULL, '08019', 'Carrer de Pau Alsina 131', '08024', 41.41204, 2.16012, 'address', 'openstreetmap:node/1948969931'),
  ('catalogo-cataluna:postal_service:node-1948970980', 'Correos Barcelona – Independencia', NULL, '08019', 'Independencia 333', '08025', 41.40994, 2.18031, 'address', 'openstreetmap:node/1948970980'),
  ('catalogo-cataluna:postal_service:node-1948973682', 'Correos Barcelona – Avinguda de Mistral', NULL, '08019', 'Avinguda de Mistral 42', '08015', 41.37647, 2.15525, 'address', 'openstreetmap:node/1948973682'),
  ('catalogo-cataluna:postal_service:node-1948974577', 'Correos Barcelona – Carrer de Rossend Nobas', NULL, '08019', 'Carrer de Rossend Nobas 31', '08018', 41.4089, 2.18964, 'address', 'openstreetmap:node/1948974577'),
  ('catalogo-cataluna:postal_service:node-1948977518', 'Correos Barcelona – Carrer de Ramon Turró 248-250', NULL, '08019', 'Carrer de Ramon Turró 248-250', '08005', 41.40192, 2.20582, 'address', 'openstreetmap:node/1948977518'),
  ('catalogo-cataluna:postal_service:node-1965879942', 'Correos Manresa – Plaça Espanya', NULL, '08113', 'Plaça Espanya 1', '08242', 41.73036, 1.82495, 'address', 'openstreetmap:node/1965879942'),
  ('catalogo-cataluna:postal_service:node-1999525833', 'Correos Calaf – Passeig de Santa Calamanda', NULL, '08031', 'Passeig de Santa Calamanda', '08280', 41.7305, 1.51503, 'address', 'openstreetmap:node/1999525833'),
  ('catalogo-cataluna:postal_service:node-2006381710', 'Correos Montmeló – Carrer de la Diputació', NULL, '08135', 'Carrer de la Diputació', '08160', 41.55127, 2.24528, 'address', 'openstreetmap:node/2006381710'),
  ('catalogo-cataluna:postal_service:node-2030907552', 'Correos Bigues i Riells del Fai – Carrer Maria de Bell-lloc', NULL, '08023', 'Carrer Maria de Bell-lloc', '08415', 41.67345, 2.21034, 'address', 'openstreetmap:node/2030907552'),
  ('catalogo-cataluna:postal_service:node-2050028584', 'Correos Canet de Mar – Carrer de la Verge del Carme', NULL, '08040', 'Carrer de la Verge del Carme 2', '08360', 41.58861, 2.57804, 'address', 'openstreetmap:node/2050028584'),
  ('catalogo-cataluna:postal_service:node-2061859777', 'Correos el Prat de Llobregat – Passatge de l''Arús', NULL, '08169', 'Passatge de l''Arús 5', '08820', 41.32859, 2.09733, 'address', 'openstreetmap:node/2061859777'),
  ('catalogo-cataluna:postal_service:node-2105333430', 'Correos Sant Quirze del Vallès – Avinguda d''Egara', NULL, '08238', 'Avinguda d''Egara 7', '08192', 41.53606, 2.07603, 'address', 'openstreetmap:node/2105333430'),
  ('catalogo-cataluna:postal_service:node-2149314803', 'Correos Malgrat de Mar – Carrer de Joan Maragall', NULL, '08110', 'Carrer de Joan Maragall', NULL, 41.64356, 2.73653, 'address', 'openstreetmap:node/2149314803'),
  ('catalogo-cataluna:postal_service:node-2151178032', 'Correos Parets del Vallès – Avinguda de Catalunya', NULL, '08159', 'Avinguda de Catalunya 155', '08150', 41.56813, 2.23076, 'address', 'openstreetmap:node/2151178032'),
  ('catalogo-cataluna:postal_service:node-2306349147', 'Correos Sant Adrià de Besòs – Carrer de l''Orient', NULL, '08194', 'Carrer de l''Orient 15', '08930', 41.41787, 2.21913, 'address', 'openstreetmap:node/2306349147'),
  ('catalogo-cataluna:postal_service:node-2395648950', 'Correos Balenyà – Carrer Major', NULL, '08017', 'Carrer Major 41', '08550', 41.81538, 2.23514, 'address', 'openstreetmap:node/2395648950'),
  ('catalogo-cataluna:postal_service:node-2492686518', 'Correos Barcelona – Carrer de Calàbria 241-243', NULL, '08019', 'Carrer de Calàbria 241-243', '08029', 41.38596, 2.14642, 'address', 'openstreetmap:node/2492686518'),
  ('catalogo-cataluna:postal_service:node-2628360575', 'Correos Pallejà – Carrer de Martí Julià', NULL, '08157', 'Carrer de Martí Julià', '08780', 41.4233, 1.99622, 'address', 'openstreetmap:node/2628360575'),
  ('catalogo-cataluna:postal_service:node-268972152', 'Correos Berga – Carrer del Roser', NULL, '08022', 'Carrer del Roser 40', '08600', 42.10002, 1.84265, 'address', 'openstreetmap:node/268972152'),
  ('catalogo-cataluna:postal_service:node-2689880360', 'Correos Aiguafreda – Carretera de Ribes', NULL, '08014', 'Carretera de Ribes 14', '08591', 41.76698, 2.25181, 'address', 'openstreetmap:node/2689880360'),
  ('catalogo-cataluna:postal_service:node-2705399252', 'Correos Sant Feliu de Llobregat – Jacint Verdaguer', NULL, '08211', 'Jacint Verdaguer 7', '08980', 41.38038, 2.05055, 'address', 'openstreetmap:node/2705399252'),
  ('catalogo-cataluna:postal_service:node-3045356723', 'Correos Tona – Carrer de la Font', NULL, '08283', 'Carrer de la Font 12', '08551', 41.84998, 2.22938, 'address', 'openstreetmap:node/3045356723'),
  ('catalogo-cataluna:postal_service:node-3095388998', 'Correos Mataró – Calassanç Marquès', NULL, '08121', 'Calassanç Marquès 14', '08303', 41.54066, 2.42611, 'address', 'openstreetmap:node/3095388998'),
  ('catalogo-cataluna:postal_service:node-3161567972', 'Correos Santa Coloma de Cervelló – Avinguda Santa Coloma', NULL, '08244', 'Avinguda Santa Coloma 5', '08690', 41.36817, 2.01877, 'address', 'openstreetmap:node/3161567972'),
  ('catalogo-cataluna:postal_service:node-3317199561', 'Correos Barcelona – Carrer de Balmes 417-421', NULL, '08019', 'Carrer de Balmes 417-421', '08022', 41.40774, 2.13796, 'address', 'openstreetmap:node/3317199561'),
  ('catalogo-cataluna:postal_service:node-3576513569', 'Correos Sant Celoni – Miquel Grive', NULL, '08202', 'Miquel Grive', '08470', 41.68723, 2.49034, 'address', 'openstreetmap:node/3576513569'),
  ('catalogo-cataluna:postal_service:node-3640952800', 'Correos l''Hospitalet de Llobregat – Carrer del Mestre Candi', NULL, '08101', 'Carrer del Mestre Candi 30', '08901', 41.36131, 2.10899, 'address', 'openstreetmap:node/3640952800'),
  ('catalogo-cataluna:postal_service:node-3661034876', 'Correos Molins de Rei – Carrer de Miquel Tort', NULL, '08123', 'Carrer de Miquel Tort 9', '08750', 41.41078, 2.01772, 'address', 'openstreetmap:node/3661034876'),
  ('catalogo-cataluna:postal_service:node-3676434136', 'Correos Monistrol de Montserrat', NULL, '08127', NULL, '08199', 41.59245, 1.83575, 'address', 'openstreetmap:node/3676434136'),
  ('catalogo-cataluna:postal_service:node-375955129', 'Correos Santa Coloma de Gramenet – Avinguda de Francesc Macià 34-36', NULL, '08245', 'Avinguda de Francesc Macià 34-36', '08921', 41.45262, 2.20492, 'address', 'openstreetmap:node/375955129'),
  ('catalogo-cataluna:postal_service:node-403798094', 'Correos Santa Eulàlia de Ronçana – Carrer Verge de la Salut', NULL, '08248', 'Carrer Verge de la Salut', NULL, 41.64149, 2.23208, 'address', 'openstreetmap:node/403798094'),
  ('catalogo-cataluna:postal_service:node-4052381451', 'Correos Barcelona – Carrer de Castellnou', NULL, '08019', 'Carrer de Castellnou 59', '08017', 41.39641, 2.12869, 'address', 'openstreetmap:node/4052381451'),
  ('catalogo-cataluna:postal_service:node-4052474545', 'Correos la Pobla de Lillet – Furrioles de Baix', NULL, '08166', 'Furrioles de Baix 4', '08696', 42.24444, 1.97569, 'address', 'openstreetmap:node/4052474545'),
  ('catalogo-cataluna:postal_service:node-4193086650', 'Correos Castellterçol – Carrer de Barcelona', NULL, '08064', 'Carrer de Barcelona 55', '08183', 41.75059, 2.12246, 'address', 'openstreetmap:node/4193086650'),
  ('catalogo-cataluna:postal_service:node-4319838227', 'Correos Cubelles – Plaça de la Font', NULL, '08074', 'Plaça de la Font 12', '08880', 41.20856, 1.67384, 'address', 'openstreetmap:node/4319838227'),
  ('catalogo-cataluna:postal_service:node-4325515442', 'Correos Gironella – Avinguda Catalunya', NULL, '08092', 'Avinguda Catalunya 22', '08680', 42.03181, 1.88052, 'address', 'openstreetmap:node/4325515442'),
  ('catalogo-cataluna:postal_service:node-4348407427', 'Correos Premià de Dalt – Plaça de la Fàbrica', NULL, '08230', 'Plaça de la Fàbrica 1', '08338', 41.50585, 2.34562, 'address', 'openstreetmap:node/4348407427'),
  ('catalogo-cataluna:postal_service:node-4375940190', 'Correos Castellar del Vallès – Carrer de Sala Boadella', NULL, '08051', 'Carrer de Sala Boadella', NULL, 41.61471, 2.08842, 'address', 'openstreetmap:node/4375940190'),
  ('catalogo-cataluna:postal_service:node-4393429492', 'Correos Sant Fost de Campsentelles – Plaça la Vila', NULL, '08209', 'Plaça la Vila 1', '08105', 41.51912, 2.23248, 'address', 'openstreetmap:node/4393429492'),
  ('catalogo-cataluna:postal_service:node-4416479589', 'Correos Collbató – Carrer de la Muntanya', NULL, '08069', 'Carrer de la Muntanya', '08293', 41.56941, 1.82682, 'address', 'openstreetmap:node/4416479589'),
  ('catalogo-cataluna:postal_service:node-4432203326', 'Correos Balsareny – Carretera de Manresa', NULL, '08018', 'Carretera de Manresa 9', '08660', 41.86375, 1.8747, 'address', 'openstreetmap:node/4432203326'),
  ('catalogo-cataluna:postal_service:node-4589420935', 'Correos les Masies de Voltregà – Carrer Sant Jordi', NULL, '08117', 'Carrer Sant Jordi', '08508', 42.01488, 2.24557, 'address', 'openstreetmap:node/4589420935'),
  ('catalogo-cataluna:postal_service:node-4598284290', 'Correos Navàs – carretera de Berga', NULL, '08141', 'carretera de Berga 45', '08670', 41.89932, 1.8784, 'address', 'openstreetmap:node/4598284290'),
  ('catalogo-cataluna:postal_service:node-4737174581', 'Correos Vallgorguina – Carretera Nova', NULL, '08294', 'Carretera Nova 54', '08471', 41.64828, 2.50892, 'address', 'openstreetmap:node/4737174581'),
  ('catalogo-cataluna:postal_service:node-4767512715', 'Correos Cerdanyola del Vallès – Avinguda de l''Eix Central', NULL, '08266', 'Avinguda de l''Eix Central', NULL, 41.50167, 2.1063, 'address', 'openstreetmap:node/4767512715'),
  ('catalogo-cataluna:postal_service:node-4859449977', 'Correos Barcelona – Passeig de Josep Carner', NULL, '08019', 'Passeig de Josep Carner 33', '08038', 41.37186, 2.17472, 'address', 'openstreetmap:node/4859449977'),
  ('catalogo-cataluna:postal_service:node-5270601158', 'Correos la Llagosta – Carrer de la Riera Seca', NULL, '08105', 'Carrer de la Riera Seca', NULL, 41.51067, 2.19181, 'address', 'openstreetmap:node/5270601158'),
  ('catalogo-cataluna:postal_service:node-5274587717', 'Correos Viladecavalls – Carrer de les Orenetes', NULL, '08300', 'Carrer de les Orenetes 5', '08232', 41.5551, 1.95451, 'address', 'openstreetmap:node/5274587717'),
  ('catalogo-cataluna:postal_service:node-5521367256', 'Correos Tiana – Carrer de Francí', NULL, '08282', 'Carrer de Francí 7', '08391', 41.48012, 2.26757, 'address', 'openstreetmap:node/5521367256'),
  ('catalogo-cataluna:postal_service:node-5782067222', 'Correos Sant Vicenç de Castellet – Passeig de Pau Casals', NULL, '08262', 'Passeig de Pau Casals 21', '08295', 41.66609, 1.86458, 'address', 'openstreetmap:node/5782067222'),
  ('catalogo-cataluna:postal_service:node-5827208272', 'Correos Ripollet – Carrer de Balmes', NULL, '08180', 'Carrer de Balmes 11', '08291', 41.4945, 2.15898, 'address', 'openstreetmap:node/5827208272'),
  ('catalogo-cataluna:postal_service:node-5827722630', 'Correos Corbera de Llobregat – Passeig dels Arbres', NULL, '08072', 'Passeig dels Arbres 15', '08757', 41.41404, 1.92657, 'address', 'openstreetmap:node/5827722630'),
  ('catalogo-cataluna:postal_service:node-5876449438', 'Correos Sabadell – Carrer de Boccaccio', NULL, '08187', 'Carrer de Boccaccio', NULL, 41.53573, 2.09617, 'address', 'openstreetmap:node/5876449438'),
  ('catalogo-cataluna:postal_service:node-5901290664', 'Correos Vic – Rambla de l''Hospital', NULL, '08298', 'Rambla de l''Hospital 48', '08500', 41.92836, 2.25204, 'address', 'openstreetmap:node/5901290664'),
  ('catalogo-cataluna:postal_service:node-6001261595', 'Correos Arenys de Munt – Carrer Nou', NULL, '08007', 'Carrer Nou 5', '08358', 41.60837, 2.53974, 'address', 'openstreetmap:node/6001261595'),
  ('catalogo-cataluna:postal_service:node-6058129325', 'Correos Cercs – carrer de la Caixa d''Estalvis de Manresa', NULL, '08268', 'carrer de la Caixa d''Estalvis de Manresa', '08698', 42.15249, 1.85668, 'address', 'openstreetmap:node/6058129325'),
  ('catalogo-cataluna:postal_service:node-6099615285', 'Correos Llinars del Vallès – Carrer del Doctor Fleming', NULL, '08106', 'Carrer del Doctor Fleming', '08450', 41.63848, 2.39938, 'address', 'openstreetmap:node/6099615285'),
  ('catalogo-cataluna:postal_service:node-6123253860', 'Correos l''Hospitalet de Llobregat – Rambla de la Marina', NULL, '08101', 'Rambla de la Marina 82', '08907', 41.35062, 2.1124, 'address', 'openstreetmap:node/6123253860'),
  ('catalogo-cataluna:postal_service:node-617248482', 'Correos Badalona – Carretera Antiga de València 75-77', NULL, '08015', 'Carretera Antiga de València 75-77', '08914', 41.43792, 2.22216, 'address', 'openstreetmap:node/617248482'),
  ('catalogo-cataluna:postal_service:node-6183975692', 'Correos Manlleu – Carrer Bisbe Morgades', NULL, '08112', 'Carrer Bisbe Morgades 7', '08560', 41.99889, 2.2843, 'address', 'openstreetmap:node/6183975692'),
  ('catalogo-cataluna:postal_service:node-6222663442', 'Correos Barcelona – Carrer de Mañé i Flaquer', NULL, '08019', 'Carrer de Mañé i Flaquer 6', '08017', 41.39715, 2.12421, 'address', 'openstreetmap:node/6222663442'),
  ('catalogo-cataluna:postal_service:node-6232798048', 'Correos Barcelona – Carrer dels Alts Forns', NULL, '08019', 'Carrer dels Alts Forns 67', '08038', 41.35903, 2.14106, 'address', 'openstreetmap:node/6232798048'),
  ('catalogo-cataluna:postal_service:node-6280497706', 'Correos Badalona – Carrer del Doctor Robert 119-121', NULL, '08015', 'Carrer del Doctor Robert 119-121', '08915', 41.46006, 2.24255, 'address', 'openstreetmap:node/6280497706'),
  ('catalogo-cataluna:postal_service:node-6381137985', 'Correos Barcelona – Avinguda de Madrid', NULL, '08019', 'Avinguda de Madrid 106', '08028', 41.37869, 2.12826, 'address', 'openstreetmap:node/6381137985'),
  ('catalogo-cataluna:postal_service:node-6447410349', 'Correos Sant Feliu de Codines – Carrer de les Creus', NULL, '08210', 'Carrer de les Creus 48', '08182', 41.69045, 2.16491, 'address', 'openstreetmap:node/6447410349'),
  ('catalogo-cataluna:postal_service:node-6565124798', 'Correos Martorell – Avinguda de Sant Antoni Maria Claret', NULL, '08114', 'Avinguda de Sant Antoni Maria Claret', '08760', 41.47753, 1.91973, 'address', 'openstreetmap:node/6565124798'),
  ('catalogo-cataluna:postal_service:node-664139408', 'Correos Sitges – Plaça del Pou Vedre', NULL, '08270', 'Plaça del Pou Vedre 5', '08870', 41.23617, 1.80514, 'address', 'openstreetmap:node/664139408'),
  ('catalogo-cataluna:postal_service:node-6704386325', 'Correos Avinyó – Carrer d''Anna Verdaguer', NULL, '08012', 'Carrer d''Anna Verdaguer', '08279', 41.86048, 1.96983, 'address', 'openstreetmap:node/6704386325'),
  ('catalogo-cataluna:postal_service:node-686243340', 'Correos Cànoves i Samalús – Plaça de Sant Muç', NULL, '08042', 'Plaça de Sant Muç 1', '08445', 41.69394, 2.35471, 'address', 'openstreetmap:node/686243340'),
  ('catalogo-cataluna:postal_service:node-6877551079', 'Correos Santa Maria de Palautordera – Carrer Avi Campas', NULL, '08259', 'Carrer Avi Campas 3', '08460', 41.69397, 2.44476, 'address', 'openstreetmap:node/6877551079'),
  ('catalogo-cataluna:postal_service:node-6897683586', 'Correos Pacs del Penedès – Camí del Salinar', NULL, '08154', 'Camí del Salinar 6', '08796', 41.36118, 1.6694, 'address', 'openstreetmap:node/6897683586'),
  ('catalogo-cataluna:postal_service:node-706314316', 'Correos Cerdanyola del Vallès – Avinguda de la Primavera', NULL, '08266', 'Avinguda de la Primavera', '08290', 41.49001, 2.14405, 'address', 'openstreetmap:node/706314316'),
  ('catalogo-cataluna:postal_service:node-7145648754', 'Correos Sant Antoni de Vilamajor – Carrer de Mossèn Cinto Verdaguer', NULL, '08198', 'Carrer de Mossèn Cinto Verdaguer 7', '08459', 41.67308, 2.39939, 'address', 'openstreetmap:node/7145648754'),
  ('catalogo-cataluna:postal_service:node-7205583987', 'Correos Montgat – Carrer de la Riera de Sant Jordi 16-18', NULL, '08126', 'Carrer de la Riera de Sant Jordi 16-18', '08390', 41.46354, 2.27118, 'address', 'openstreetmap:node/7205583987'),
  ('catalogo-cataluna:postal_service:node-7476771778', 'Correos Pineda de Mar – Carrer de Santiago Rusiñol', NULL, '08163', 'Carrer de Santiago Rusiñol 10', '08397', 41.62464, 2.69618, 'address', 'openstreetmap:node/7476771778'),
  ('catalogo-cataluna:postal_service:node-7536446239', 'Correos Sant Andreu de la Barca – Carrer de la Riera de Canals', NULL, '08196', 'Carrer de la Riera de Canals 32', '08740', 41.4485, 1.97557, 'address', 'openstreetmap:node/7536446239'),
  ('catalogo-cataluna:postal_service:node-7958759185', 'Correos Barcelona – Passeig de Sant Antoni', NULL, '08019', 'Passeig de Sant Antoni 14', '08014', 41.37631, 2.13686, 'address', 'openstreetmap:node/7958759185'),
  ('catalogo-cataluna:postal_service:node-8263475324', 'Correos Barcelona – Plaça del Doctor Letamendi 7-9', NULL, '08019', 'Plaça del Doctor Letamendi 7-9', '08011', 41.38855, 2.16073, 'address', 'openstreetmap:node/8263475324'),
  ('catalogo-cataluna:postal_service:node-8327015246', 'Correos Barcelona – Carrer de Santiago Rusiñol', NULL, '08019', 'Carrer de Santiago Rusiñol 14', '08001', 41.42838, 2.16694, 'address', 'openstreetmap:node/8327015246'),
  ('catalogo-cataluna:postal_service:node-8399930216', 'Correos Castellví de Rosanes – Carrer de la Font', NULL, '08066', 'Carrer de la Font 1', '08769', 41.45014, 1.89937, 'address', 'openstreetmap:node/8399930216'),
  ('catalogo-cataluna:postal_service:node-8400016801', 'Correos Sallent – Plaça de la Vila', NULL, '08191', 'Plaça de la Vila', '08650', 41.82434, 1.89442, 'address', 'openstreetmap:node/8400016801'),
  ('catalogo-cataluna:postal_service:node-8587103659', 'Correos Vallirana – Avinguda de la Parellada', NULL, '08295', 'Avinguda de la Parellada 6', '08759', 41.38686, 1.93258, 'address', 'openstreetmap:node/8587103659'),
  ('catalogo-cataluna:postal_service:node-9350477121', 'Correos Abrera – Plaça de la Constitució', NULL, '08001', 'Plaça de la Constitució 1', '08630', 41.51673, 1.90096, 'address', 'openstreetmap:node/9350477121'),
  ('catalogo-cataluna:postal_service:node-9431447017', 'Correos Matadepera – Carrer de Sant Joan', NULL, '08120', 'Carrer de Sant Joan 103', '08230', 41.60031, 2.02557, 'address', 'openstreetmap:node/9431447017'),
  ('catalogo-cataluna:postal_service:node-9559937795', 'Correos Sant Andreu de Llavaneres – Carrer de Closens', NULL, '08197', 'Carrer de Closens', '08392', 41.57309, 2.48325, 'address', 'openstreetmap:node/9559937795'),
  ('catalogo-cataluna:postal_service:node-9660697395', 'Correos Sant Esteve de Palautordera – Carrer Major', NULL, '08207', 'Carrer Major 38', '08461', 41.70363, 2.43576, 'address', 'openstreetmap:node/9660697395'),
  ('catalogo-cataluna:postal_service:node-9756609400', 'Correos Cardedeu – Carrer de Balmes', NULL, '08046', 'Carrer de Balmes 69', '08440', 41.64015, 2.36206, 'address', 'openstreetmap:node/9756609400'),
  ('catalogo-cataluna:postal_service:node-9792028152', 'Correos Terrassa – Avinguda d''Àngel Sallent', NULL, '08279', 'Avinguda d''Àngel Sallent 184', '08224', 41.56095, 1.99884, 'address', 'openstreetmap:node/9792028152'),
  ('catalogo-cataluna:postal_service:node-9971771033', 'Correos Torrelles de Llobregat – Carrer Rafael Casanova', NULL, '08289', 'Carrer Rafael Casanova 12', '08629', 41.3586, 1.98048, 'address', 'openstreetmap:node/9971771033'),
  ('catalogo-cataluna:postal_service:relation-11697324', 'Correos Mataró – Camí Ral', NULL, '08121', 'Camí Ral 621', '08302', 41.53243, 2.4377, 'address', 'openstreetmap:relation/11697324'),
  ('catalogo-cataluna:postal_service:way-149633942', 'Correos Gurb – Mas l''Esperança', NULL, '08100', 'Mas l''Esperança', '08503', 41.93972, 2.24351, 'address', 'openstreetmap:way/149633942'),
  ('catalogo-cataluna:postal_service:way-168747049', 'Correos Terrassa – Plaça de Mossèn Jacint Verdaguer', NULL, '08279', 'Plaça de Mossèn Jacint Verdaguer 16', '08221', 41.56631, 2.01291, 'address', 'openstreetmap:way/168747049'),
  ('catalogo-cataluna:postal_service:way-172142219', 'Correos Arenys de Mar – Carrer de la Torre', NULL, '08006', 'Carrer de la Torre 85', '08350', 41.58232, 2.54659, 'address', 'openstreetmap:way/172142219'),
  ('catalogo-cataluna:postal_service:way-265591828', 'Correos Cornellà de Llobregat – Carrer de Mossèn Jacint Verdaguer', NULL, '08073', 'Carrer de Mossèn Jacint Verdaguer 19', '08940', 41.35479, 2.07109, 'address', 'openstreetmap:way/265591828'),
  ('catalogo-cataluna:postal_service:way-349276962', 'Correos Barcelona – Carrer de l''Estartit 8-6', NULL, '08019', 'Carrer de l''Estartit 8-6', '08020', 41.42101, 2.20281, 'address', 'openstreetmap:way/349276962'),
  ('catalogo-cataluna:postal_service:way-35811766', 'Correos Premià de Mar – Carrer de Sant Cristòfol', NULL, '08172', 'Carrer de Sant Cristòfol 41', '08330', 41.49158, 2.35506, 'address', 'openstreetmap:way/35811766'),
  ('catalogo-cataluna:postal_service:way-383025639', 'Correos Artés – Carrer de Barcelona', NULL, '08010', 'Carrer de Barcelona', '08271', 41.79559, 1.95149, 'address', 'openstreetmap:way/383025639'),
  ('catalogo-cataluna:postal_service:way-393502981', 'Correos Monistrol de Montserrat – Plaça de la Font Gran', NULL, '08127', 'Plaça de la Font Gran 7', '08691', 41.60981, 1.84235, 'address', 'openstreetmap:way/393502981'),
  ('catalogo-cataluna:postal_service:way-463896059', 'Correos Sant Boi de Llobregat – Carrer Joan Salvat i Papasseit', NULL, '08200', 'Carrer Joan Salvat i Papasseit 33', '08830', 41.34313, 2.04119, 'address', 'openstreetmap:way/463896059'),
  ('catalogo-cataluna:postal_service:way-635532087', 'Correos Esparreguera – Plaça del Rei', NULL, '08076', 'Plaça del Rei', '08292', 41.53748, 1.86874, 'address', 'openstreetmap:way/635532087'),
  ('catalogo-cataluna:postal_service:way-679257028', 'Correos Sant Climent de Llobregat – Travessia Prat de la Riba', NULL, '08204', 'Travessia Prat de la Riba 33', '08849', 41.33804, 1.99774, 'address', 'openstreetmap:way/679257028'),
  ('catalogo-cataluna:postal_service:way-69325495', 'Correos Vilassar de Mar – Carrer de Santiago Russinyol', NULL, '08219', 'Carrer de Santiago Russinyol', '08340', 41.50847, 2.3963, 'address', 'openstreetmap:way/69325495'),
  ('catalogo-cataluna:postal_service:way-71534110', 'Correos Granollers – Plaça Josep Brangé', NULL, '08096', 'Plaça Josep Brangé 4', '08402', 41.60808, 2.28992, 'address', 'openstreetmap:way/71534110'),
  ('catalogo-cataluna:postal_service:way-715597448', 'Correos Piera – Carrer de Sant Bonifaci 55-57', NULL, '08161', 'Carrer de Sant Bonifaci 55-57', '08784', 41.52056, 1.74773, 'address', 'openstreetmap:way/715597448'),
  ('catalogo-cataluna:postal_service:way-801656335', 'Correos Rubí – Carrer de Terrassa', NULL, '08184', 'Carrer de Terrassa 48', '08191', 41.49372, 2.03011, 'address', 'openstreetmap:way/801656335');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 143 THEN
    RAISE EXCEPTION 'Se esperaban 143 puntos de Correos en Barcelona, hay %', n;
  END IF;
END;
$$;

COMMIT;
