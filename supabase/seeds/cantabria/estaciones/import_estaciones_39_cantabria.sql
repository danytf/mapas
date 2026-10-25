-- Carga de la categoría Estaciones de Cantabria (provincia 39), trozo de la carga de Andalucía.
-- Origen: estaciones-cantabria.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 104 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cantabria:estaciones:node-12492170553', 'Estación de autobuses de Hospital Sierrallana (Torrelavega) – Calle de Manuel Teira Fernández', 'Autobús', '39087', 'Calle de Manuel Teira Fernández', '39300', 43.36278, -4.07544, 'address', 'openstreetmap:node/12492170553'),
  ('catalogo-cantabria:estaciones:node-12926284069', 'Estación de tren de Unquera (Val de San Vicente) – Plaza de la Estación', 'Tren', '39095', 'Plaza de la Estación 2', '39560', 43.37492, -4.51436, 'address', 'openstreetmap:node/12926284069'),
  ('catalogo-cantabria:estaciones:node-12926284070', 'Estación de tren de San Vicente de la Barquera', 'Tren', '39080', NULL, NULL, 43.36775, -4.40456, 'address', 'openstreetmap:node/12926284070'),
  ('catalogo-cantabria:estaciones:node-12926284071', 'Estación de tren de Cabezón de la Sal – Avenida Textil Santanderina', 'Tren', '39012', 'Avenida Textil Santanderina 6', '39005', 43.30784, -4.23176, 'address', 'openstreetmap:node/12926284071'),
  ('catalogo-cantabria:estaciones:node-12926284072', 'Estación de tren de San Pedro de Rudagüera (Alfoz de Lloredo)', 'Tren', '39001', NULL, '39539', 43.36115, -4.1494, 'address', 'openstreetmap:node/12926284072'),
  ('catalogo-cantabria:estaciones:node-12926284073', 'Estación de tren de Puente San Miguel (Reocín) – Calle de Miguel Ruiz de Salazar', 'Tren', '39060', 'Calle de Miguel Ruiz de Salazar', '39530', 43.35877, -4.08772, 'address', 'openstreetmap:node/12926284073'),
  ('catalogo-cantabria:estaciones:node-12926284074', 'Estación de tren de Barreda (Torrelavega) – Avenida de Solvay 113C', 'Tren', '39087', 'Avenida de Solvay 113C', '39300', 43.37402, -4.04207, 'address', 'openstreetmap:node/12926284074'),
  ('catalogo-cantabria:estaciones:node-12926284075', 'Estación de tren de Cazoña (Santander) – Avenida de Cajo', 'Tren', '39075', 'Avenida de Cajo 17', '39011', 43.45431, -3.84043, 'address', 'openstreetmap:node/12926284075'),
  ('catalogo-cantabria:estaciones:node-12926284076', 'Estación de tren de Requejada (Polanco) – Acceso al puerto de Requejada', 'Tren', '39054', 'Acceso al puerto de Requejada', NULL, 43.39133, -4.02854, 'address', 'openstreetmap:node/12926284076'),
  ('catalogo-cantabria:estaciones:node-13333702354', 'Estación de tren de Ceceñas (Medio Cudeyo) – Barrio La Estación', 'Tren', '39042', 'Barrio La Estación 68', '39724', 43.37651, -3.71809, 'address', 'openstreetmap:node/13333702354'),
  ('catalogo-cantabria:estaciones:node-13333702365', 'Estación de tren de Gornazo (Miengo) – Calle Cascabel', 'Tren', '39044', 'Calle Cascabel 137', '39310', 43.4098, -3.98848, 'address', 'openstreetmap:node/13333702365'),
  ('catalogo-cantabria:estaciones:node-13333702366', 'Estación de tren de Mar (Polanco) – Barrio La Cantera', 'Tren', '39054', 'Barrio La Cantera', NULL, 43.3983, -4.01003, 'approximate', 'openstreetmap:node/13333702366'),
  ('catalogo-cantabria:estaciones:node-13333702368', 'Estación de tren de Altamira (Torrelavega) – 21', 'Tren', '39087', '21', '39300', 43.35191, -4.057, 'address', 'openstreetmap:node/13333702368'),
  ('catalogo-cantabria:estaciones:node-13333702370', 'Estación de tren de Santa Isabel (Reocín) – Villapresente-San Pedro de Rudaguera', 'Tren', '39060', 'Villapresente-San Pedro de Rudaguera', NULL, 43.35904, -4.11184, 'address', 'openstreetmap:node/13333702370'),
  ('catalogo-cantabria:estaciones:node-13333702371', 'Estación de tren de Valdecilla (Santander) – Calle de Jerónimo Sainz de la Maza', 'Tren', '39075', 'Calle de Jerónimo Sainz de la Maza 27', '39011', 43.45398, -3.8278, 'address', 'openstreetmap:node/13333702371'),
  ('catalogo-cantabria:estaciones:node-13333702385', 'Estación de tren de Guarnizo (El Astillero) – Barrio La Frontera', 'Tren', '39008', 'Barrio La Frontera', NULL, 43.39154, -3.85953, 'address', 'openstreetmap:node/13333702385'),
  ('catalogo-cantabria:estaciones:node-13333708244', 'Estación de tren de Parbayón (Piélagos) – Barrio El Jurrió', 'Tren', '39052', 'Barrio El Jurrió', '39612', 43.37677, -3.89423, 'address', 'openstreetmap:node/13333708244'),
  ('catalogo-cantabria:estaciones:node-13333708245', 'Estación de tren de Sierrapando (Torrelavega) – Barrio Sierrapando', 'Tren', '39087', 'Barrio Sierrapando 431', '39300', 43.34179, -4.02644, 'address', 'openstreetmap:node/13333708245'),
  ('catalogo-cantabria:estaciones:node-13333752667', 'Estación de tren de Treto (Bárcena de Cicero) – Calle La Estación', 'Tren', '39009', 'Calle La Estación 12', '39761', 43.39418, -3.46936, 'address', 'openstreetmap:node/13333752667'),
  ('catalogo-cantabria:estaciones:node-13333752668', 'Estación de tren de Puente Agüero (Marina de Cudeyo) – Rubayo-Puente Agüero', 'Tren', '39040', 'Rubayo-Puente Agüero', '39719', 43.40642, -3.7195, 'address', 'openstreetmap:node/13333752668'),
  ('catalogo-cantabria:estaciones:node-13333752683', 'Estación de tren de Ontoria (Cabezón de la Sal) – Avenida de Santiago Salas', 'Tren', '39012', 'Avenida de Santiago Salas', '39500', 43.31529, -4.2154, 'address', 'openstreetmap:node/13333752683'),
  ('catalogo-cantabria:estaciones:node-13333752684', 'Estación de tren de Treceño (Valdáliga)', 'Tren', '39091', NULL, NULL, 43.31839, -4.309, 'address', 'openstreetmap:node/13333752684'),
  ('catalogo-cantabria:estaciones:node-13333752685', 'Estación de tren de Roiz (Valdáliga) – Barrio Las Cuevas', 'Tren', '39091', 'Barrio Las Cuevas', '39593', 43.32834, -4.34917, 'address', 'openstreetmap:node/13333752685'),
  ('catalogo-cantabria:estaciones:node-13333752686', 'Estación de tren de El Barcenal (San Vicente de la Barquera)', 'Tren', '39080', NULL, NULL, 43.341, -4.38378, 'address', 'openstreetmap:node/13333752686'),
  ('catalogo-cantabria:estaciones:node-13333752687', 'Estación de tren de Pesués (Val de San Vicente) – Valle de Cabuérniga-Puentenansa', 'Tren', '39095', 'Valle de Cabuérniga-Puentenansa', '39548', 43.37028, -4.48016, 'address', 'openstreetmap:node/13333752687'),
  ('catalogo-cantabria:estaciones:node-13333752689', 'Estación de tren de Virgen de la Peña (Cabezón de la Sal) – Virgen de la Peña', 'Tren', '39012', 'Virgen de la Peña', '39509', 43.32301, -4.19355, 'address', 'openstreetmap:node/13333752689'),
  ('catalogo-cantabria:estaciones:node-13333752690', 'Estación de tren de Casar de Periedo (Cabezón de la Sal)', 'Tren', '39012', NULL, NULL, 43.33881, -4.17491, 'address', 'openstreetmap:node/13333752690'),
  ('catalogo-cantabria:estaciones:node-13333752691', 'Estación de tren de Golbardo (Reocín)', 'Tren', '39060', NULL, NULL, 43.34077, -4.15564, 'address', 'openstreetmap:node/13333752691'),
  ('catalogo-cantabria:estaciones:node-13333883588', 'Estación de tren de Reinosa – Calle Casimiro Sainz', 'Tren', '39059', 'Calle Casimiro Sainz', '39200', 42.99477, -4.14045, 'approximate', 'openstreetmap:node/13333883588'),
  ('catalogo-cantabria:estaciones:node-13333883589', 'Estación de tren de Río Ebro (Reinosa) – Calle de Duque y Merino', 'Tren', '39059', 'Calle de Duque y Merino', '39200', 43.00076, -4.13438, 'address', 'openstreetmap:node/13333883589'),
  ('catalogo-cantabria:estaciones:node-13335703977', 'Estación de tren de La Cavada (Riotuerto) – Carretera de La Cavada a Rucandio', 'Tren', '39064', 'Carretera de La Cavada a Rucandio', '39720', 43.35061, -3.70719, 'address', 'openstreetmap:node/13335703977'),
  ('catalogo-cantabria:estaciones:node-13335703978', 'Estación de tren de Solares (Medio Cudeyo) – Paseo de la Estación', 'Tren', '39042', 'Paseo de la Estación 12', '39710', 43.38723, -3.73145, 'address', 'openstreetmap:node/13335703978'),
  ('catalogo-cantabria:estaciones:node-13338126376', 'Estación de tren de Torrelavega-Centro – Calle de Lasaga Larreta', 'Tren', '39087', 'Calle de Lasaga Larreta 1', '39300', 43.35104, -4.05127, 'address', 'openstreetmap:node/13338126376'),
  ('catalogo-cantabria:estaciones:node-13389024736', 'Estación de tren de Muriedas-Bahía (Camargo) – Calle del Carmen', 'Tren', '39016', 'Calle del Carmen 12', '39600', 43.42174, -3.84413, 'address', 'openstreetmap:node/13389024736'),
  ('catalogo-cantabria:estaciones:node-13389024737', 'Estación de tren de Boo (El Astillero) – Calle del Boo', 'Tren', '39008', 'Calle del Boo', NULL, 43.41041, -3.84145, 'approximate', 'openstreetmap:node/13389024737'),
  ('catalogo-cantabria:estaciones:node-13389024738', 'Estación de tren de Las Caldas de Besaya (San Felices de Buelna) – Las Caldas de Besaya', 'Tren', '39069', 'Las Caldas de Besaya', '39408', 43.29859, -4.07311, 'address', 'openstreetmap:node/13389024738'),
  ('catalogo-cantabria:estaciones:node-13700059276', 'Estación de autobuses de Santander – Plaza de las Estaciones', 'Autobús', '39075', 'Plaza de las Estaciones', '39002', 43.45952, -3.80968, 'address', 'openstreetmap:node/13700059276'),
  ('catalogo-cantabria:estaciones:node-13728429302', 'Estación de tren de Los Corrales de Buelna – Andén de la estación', 'Tren', '39025', 'Andén de la estación', '39400', 43.25513, -4.06388, 'address', 'openstreetmap:node/13728429302'),
  ('catalogo-cantabria:estaciones:node-13728429303', 'Estación de tren de Renedo (Piélagos) – Avenida de Luis de la Concha', 'Tren', '39052', 'Avenida de Luis de la Concha', '39470', 43.35305, -3.94951, 'approximate', 'openstreetmap:node/13728429303'),
  ('catalogo-cantabria:estaciones:node-13728429304', 'Estación de tren de Vioño (Piélagos) – Oruña-Vioño', 'Tren', '39052', 'Oruña-Vioño', NULL, 43.36066, -3.96487, 'address', 'openstreetmap:node/13728429304'),
  ('catalogo-cantabria:estaciones:node-13787040246', 'Estación de tren de Ganzo (Torrelavega) – Calle de José María Cabañas', 'Tren', '39087', 'Calle de José María Cabañas 61', '39300', 43.35649, -4.07015, 'address', 'openstreetmap:node/13787040246'),
  ('catalogo-cantabria:estaciones:node-14247580210', 'Estación de tren de Pesquera', 'Tren', '39051', NULL, NULL, 43.08223, -4.07374, 'address', 'openstreetmap:node/14247580210'),
  ('catalogo-cantabria:estaciones:node-14247759432', 'Estación de tren de Lantueno (Santiurde de Reinosa)', 'Tren', '39077', NULL, NULL, 43.0582, -4.08423, 'address', 'openstreetmap:node/14247759432'),
  ('catalogo-cantabria:estaciones:node-14273209205', 'Estación de tren de Mataporquera (Valdeolea) – Calle de la Constitución 16E', 'Tren', '39092', 'Calle de la Constitución 16E', '39410', 42.87266, -4.16416, 'address', 'openstreetmap:node/14273209205'),
  ('catalogo-cantabria:estaciones:node-1906593808', 'Estación de tren de Molledo Portolín', 'Tren', '39046', NULL, NULL, 43.14548, -4.03906, 'address', 'openstreetmap:node/1906593808'),
  ('catalogo-cantabria:estaciones:node-246573025', 'Estación de tren de Viérnoles (Torrelavega) – Barrio La Robleda 100B', 'Tren', '39087', 'Barrio La Robleda 100B', '39315', 43.32439, -4.05404, 'address', 'openstreetmap:node/246573025'),
  ('catalogo-cantabria:estaciones:node-266131580', 'Estación de tren de Villaverde de Pontones (Ribamontán al Monte) – Hoznayo-Villaverde de Pontones', 'Tren', '39062', 'Hoznayo-Villaverde de Pontones', NULL, 43.41124, -3.70366, 'address', 'openstreetmap:node/266131580'),
  ('catalogo-cantabria:estaciones:node-291282434', 'Estación de tren de Marrón (Ampuero) – Barrio Marrón', 'Tren', '39002', 'Barrio Marrón', '39849', 43.34652, -3.42105, 'address', 'openstreetmap:node/291282434'),
  ('catalogo-cantabria:estaciones:node-3141688651', 'Estación de autobuses de Parada Riocorvo (Cartes) – San José', 'Autobús', '39018', 'San José', NULL, 43.31096, -4.07259, 'approximate', 'openstreetmap:node/3141688651'),
  ('catalogo-cantabria:estaciones:node-3150316666', 'Estación de tren de Mogro (Miengo) – Mies de la Dehesa', 'Tren', '39044', 'Mies de la Dehesa', NULL, 43.425, -3.96043, 'address', 'openstreetmap:node/3150316666'),
  ('catalogo-cantabria:estaciones:node-33727552', 'Estación de tren de Nueva Montaña (Santander) – Calle de la Isla del Óleo 33A', 'Tren', '39075', 'Calle de la Isla del Óleo 33A', '39011', 43.4444, -3.84724, 'address', 'openstreetmap:node/33727552'),
  ('catalogo-cantabria:estaciones:node-3826212457', 'Estación de tren de Bárcena (Bárcena de Pie de Concha) – Camino Real', 'Tren', '39010', 'Camino Real', NULL, 43.12859, -4.05381, 'address', 'openstreetmap:node/3826212457'),
  ('catalogo-cantabria:estaciones:node-4547815449', 'Estación de tren de Adarzo (Santander) – Calle Adarzo', 'Tren', '39075', 'Calle Adarzo 77', '39011', 43.45345, -3.8558, 'address', 'openstreetmap:node/4547815449'),
  ('catalogo-cantabria:estaciones:node-4955025224', 'Estación de tren de Mompía-Mortera (Santa Cruz de Bezana) – Avenida de los Condes', 'Tren', '39073', 'Avenida de los Condes', '39108', 43.43522, -3.9182, 'address', 'openstreetmap:node/4955025224'),
  ('catalogo-cantabria:estaciones:node-4969016461', 'Estación de tren de Boo de Piélagos – Barrio San Juan', 'Tren', '39052', 'Barrio San Juan', NULL, 43.43169, -3.94632, 'address', 'openstreetmap:node/4969016461'),
  ('catalogo-cantabria:estaciones:node-5338732626', 'Estación de tren de Santa Cruz de Iguña (Molledo) – Calle Estación', 'Tren', '39046', 'Calle Estación', '39440', 43.17011, -4.04509, 'address', 'openstreetmap:node/5338732626'),
  ('catalogo-cantabria:estaciones:node-5338732628', 'Estación de tren de Las Fraguas (Arenas de Iguña) – Barrio Collantes', 'Tren', '39004', 'Barrio Collantes', NULL, 43.19323, -4.05416, 'address', 'openstreetmap:node/5338732628'),
  ('catalogo-cantabria:estaciones:node-5393997094', 'Estación de tren de Beranga (Hazas de Cesto) – Barrio La Estación', 'Tren', '39031', 'Barrio La Estación', '39730', 43.41363, -3.57707, 'address', 'openstreetmap:node/5393997094'),
  ('catalogo-cantabria:estaciones:node-5888262511', 'Estación de tren de Udalla (Rasines)', 'Tren', '39058', NULL, NULL, 43.31366, -3.44564, 'address', 'openstreetmap:node/5888262511'),
  ('catalogo-cantabria:estaciones:node-5893228216', 'Estación de tren de Santander – Calle de Atilano Rodríguez', 'Tren', '39075', 'Calle de Atilano Rodríguez', '39002', 43.45865, -3.81123, 'address', 'openstreetmap:node/5893228216'),
  ('catalogo-cantabria:estaciones:node-5893258391', 'Estación de tren de Valdecilla-La Marga (Santander) – Avenida de Candina', 'Tren', '39075', 'Avenida de Candina 5', '39011', 43.45269, -3.82857, 'address', 'openstreetmap:node/5893258391'),
  ('catalogo-cantabria:estaciones:node-6283393015', 'Estación de tren de Valle Real (Camargo) – Calle de Alday', 'Tren', '39016', 'Calle de Alday', '39600', 43.42746, -3.84041, 'address', 'openstreetmap:node/6283393015'),
  ('catalogo-cantabria:estaciones:node-6283406177', 'Estación de tren de Maliaño - La Vidriera (Camargo) – Avenida de Cantabria', 'Tren', '39016', 'Avenida de Cantabria 26', '39600', 43.41612, -3.84096, 'address', 'openstreetmap:node/6283406177'),
  ('catalogo-cantabria:estaciones:node-6283409470', 'Estación de tren de Astillero (El Astillero) – Avenida de Chiclana', 'Tren', '39008', 'Avenida de Chiclana', '39610', 43.40396, -3.8209, 'address', 'openstreetmap:node/6283409470'),
  ('catalogo-cantabria:estaciones:node-6283419316', 'Estación de tren de La Cantábrica (El Astillero) – Calle de la Cantábrica', 'Tren', '39008', 'Calle de la Cantábrica', NULL, 43.39727, -3.81489, 'address', 'openstreetmap:node/6283419316'),
  ('catalogo-cantabria:estaciones:node-6284885840', 'Estación de tren de Heras (Medio Cudeyo) – Barrio La Estación', 'Tren', '39042', 'Barrio La Estación', '39792', 43.40105, -3.76655, 'address', 'openstreetmap:node/6284885840'),
  ('catalogo-cantabria:estaciones:node-6284896256', 'Estación de tren de San Salvador (Medio Cudeyo) – Barrio La Iglesia', 'Tren', '39042', 'Barrio La Iglesia 57', '39619', 43.39373, -3.80377, 'address', 'openstreetmap:node/6284896256'),
  ('catalogo-cantabria:estaciones:node-6285101623', 'Estación de tren de Nueva Montaña (Santander) – Barrio Santiago el Mayor 35K', 'Tren', '39075', 'Barrio Santiago el Mayor 35K', '39011', 43.44013, -3.84953, 'address', 'openstreetmap:node/6285101623'),
  ('catalogo-cantabria:estaciones:node-6570251746', 'Estación de tren de Llano (Las Rozas de Valdearroyo) – Llano', 'Tren', '39065', 'Llano', '39213', 42.98795, -3.98261, 'address', 'openstreetmap:node/6570251746'),
  ('catalogo-cantabria:estaciones:node-6570292849', 'Estación de tren de Montes Claros (Valdeprado del Río) – Acceso a la estación de Montesclaros', 'Tren', '39093', 'Acceso a la estación de Montesclaros', NULL, 42.9321, -4.04268, 'address', 'openstreetmap:node/6570292849'),
  ('catalogo-cantabria:estaciones:node-6570309847', 'Estación de tren de Los Carabeos (Valdeprado del Río)', 'Tren', '39093', NULL, NULL, 42.91033, -4.07531, 'address', 'openstreetmap:node/6570309847'),
  ('catalogo-cantabria:estaciones:node-6570337796', 'Estación de tren de Las Rozas de Valdearroyo – Las Rozas', 'Tren', '39065', 'Las Rozas 2', '39213', 42.97362, -4.02985, 'address', 'openstreetmap:node/6570337796'),
  ('catalogo-cantabria:estaciones:node-6570580746', 'Estación de tren de Bezana (Santa Cruz de Bezana) – Calle de la Respuela', 'Tren', '39073', 'Calle de la Respuela', '39100', 43.44073, -3.89957, 'address', 'openstreetmap:node/6570580746'),
  ('catalogo-cantabria:estaciones:node-6577768899', 'Estación de tren de Hoz de Anero (Ribamontán al Monte) – Barrio La Estación', 'Tren', '39062', 'Barrio La Estación', NULL, 43.40502, -3.66666, 'address', 'openstreetmap:node/6577768899'),
  ('catalogo-cantabria:estaciones:node-6578031737', 'Estación de tren de Limpias (Voto) – Limpias-Las Viñas', 'Tren', '39102', 'Limpias-Las Viñas', NULL, 43.35883, -3.43336, 'address', 'openstreetmap:node/6578031737'),
  ('catalogo-cantabria:estaciones:node-6578037831', 'Estación de tren de Gama (Bárcena de Cicero) – Calle El Crucero', 'Tren', '39009', 'Calle El Crucero', NULL, 43.42303, -3.52496, 'address', 'openstreetmap:node/6578037831'),
  ('catalogo-cantabria:estaciones:node-6578040275', 'Estación de tren de Cicero (Bárcena de Cicero) – Cicero-Santoña', 'Tren', '39009', 'Cicero-Santoña', NULL, 43.41708, -3.49051, 'address', 'openstreetmap:node/6578040275'),
  ('catalogo-cantabria:estaciones:node-739895218', 'Estación de autobuses de Torrelavega – Travesía Vía del Grillo', 'Autobús', '39087', 'Travesía Vía del Grillo 2', '39316', 43.34538, -4.0473, 'address', 'openstreetmap:node/739895218'),
  ('catalogo-cantabria:estaciones:node-8038471610', 'Estación de tren de Torrelavega – Paseo de Joaquín Fernández Vallejo', 'Tren', '39087', 'Paseo de Joaquín Fernández Vallejo', '39316', 43.32744, -4.04246, 'address', 'openstreetmap:node/8038471610'),
  ('catalogo-cantabria:estaciones:node-8038499695', 'Estación de tren de Arenas de Iguña – Barrio El Arrabal', 'Tren', '39004', 'Barrio El Arrabal', NULL, 43.18477, -4.04995, 'address', 'openstreetmap:node/8038499695'),
  ('catalogo-cantabria:estaciones:node-8038502915', 'Estación de tren de Lombera (Los Corrales de Buelna) – Calle Daoiz y Verlarde', 'Tren', '39025', 'Calle Daoiz y Verlarde 53', '39400', 43.26581, -4.06759, 'address', 'openstreetmap:node/8038502915'),
  ('catalogo-cantabria:estaciones:node-8038507760', 'Estación de tren de Pujayo (Bárcena de Pie de Concha)', 'Tren', '39010', NULL, NULL, 43.12277, -4.0825, 'address', 'openstreetmap:node/8038507760'),
  ('catalogo-cantabria:estaciones:node-8267660124', 'Estación de tren de Orejo (Marina de Cudeyo) – Barrio la Estación', 'Tren', '39040', 'Barrio la Estación', NULL, 43.39942, -3.73816, 'address', 'openstreetmap:node/8267660124'),
  ('catalogo-cantabria:estaciones:node-8267660220', 'Estación de tren de Gibaja (Ramales de la Victoria) – Calle La Bolera', 'Tren', '39057', 'Calle La Bolera', NULL, 43.28203, -3.43829, 'address', 'openstreetmap:node/8267660220'),
  ('catalogo-cantabria:estaciones:node-862119341', 'Terminales de Autobuses (Suances) – Plaza de Viares', 'Autobús', '39085', 'Plaza de Viares', '39340', 43.42596, -4.04139, 'address', 'openstreetmap:node/862119341'),
  ('catalogo-cantabria:estaciones:node-8738434083', 'Estación de tren de Liérganes – Paseo de Velasco', 'Tren', '39037', 'Paseo de Velasco 25', '39722', 43.34499, -3.7418, 'address', 'openstreetmap:node/8738434083'),
  ('catalogo-cantabria:estaciones:node-915443518', 'Estación de tren de Zurita (Piélagos) – Barrio San Martín', 'Tren', '39052', 'Barrio San Martín', '39479', 43.34768, -3.991, 'address', 'openstreetmap:node/915443518'),
  ('catalogo-cantabria:estaciones:relation-10313070', 'Terminal de Autobuses de Santillana del Mar – Barreda-La Revilla', 'Autobús', '39076', 'Barreda-La Revilla', NULL, 43.38715, -4.10344, 'address', 'openstreetmap:relation/10313070'),
  ('catalogo-cantabria:estaciones:relation-6439767', 'Estación de Renfe, ADIF (Reinosa) – Calle Casimiro Sainz', 'Tren', '39059', 'Calle Casimiro Sainz', '39200', 42.99434, -4.14103, 'approximate', 'openstreetmap:relation/6439767'),
  ('catalogo-cantabria:estaciones:way-1227809634', 'Intercambiador de El Astillero – Calle de la Industria', 'Autobús', '39008', 'Calle de la Industria', '39610', 43.39473, -3.81554, 'address', 'openstreetmap:way/1227809634'),
  ('catalogo-cantabria:estaciones:way-1567280785', 'Estación de Autobus de Noja – Calle del Marqués de Velasco', 'Autobús', '39047', 'Calle del Marqués de Velasco', '39180', 43.48067, -3.52194, 'address', 'openstreetmap:way/1567280785'),
  ('catalogo-cantabria:estaciones:way-199117088', 'Estación de autobuses de Laredo – Calle de la Reconquista de Sevilla', 'Autobús', '39035', 'Calle de la Reconquista de Sevilla', '39770', 43.40968, -3.41313, 'address', 'openstreetmap:way/199117088'),
  ('catalogo-cantabria:estaciones:way-213752326', 'Estación de autobuses de Sarón (Santa María de Cayón) – Calle de Correos', 'Autobús', '39074', 'Calle de Correos', NULL, 43.32327, -3.85461, 'address', 'openstreetmap:way/213752326'),
  ('catalogo-cantabria:estaciones:way-221268538', 'Estación de Autobuses San Vicente de la Barquera – Avenida Miramar', 'Autobús', '39080', 'Avenida Miramar', '39540', 43.38207, -4.39715, 'address', 'openstreetmap:way/221268538'),
  ('catalogo-cantabria:estaciones:way-224871994', 'Estación de tren de Maliaño (Camargo) – Calle del Norte', 'Tren', '39016', 'Calle del Norte 6', '39600', 43.41741, -3.84206, 'address', 'openstreetmap:way/224871994'),
  ('catalogo-cantabria:estaciones:way-28268286', 'Terminal de autobuses de Solares (Medio Cudeyo) – Paseo de la Virgen del Pilar', 'Autobús', '39042', 'Paseo de la Virgen del Pilar', '39710', 43.38665, -3.73206, 'address', 'openstreetmap:way/28268286'),
  ('catalogo-cantabria:estaciones:way-408644840', 'Estación de Autobuses de Castro-Urdiales – Calle de Leonardo Rucabado', 'Autobús', '39020', 'Calle de Leonardo Rucabado', '39700', 43.3703, -3.21717, 'address', 'openstreetmap:way/408644840'),
  ('catalogo-cantabria:estaciones:way-432558973', 'Estación de tren de Renedo de Piélagos – Avenida de Luis de la Concha', 'Tren', '39052', 'Avenida de Luis de la Concha', '39470', 43.353, -3.94952, 'approximate', 'openstreetmap:way/432558973'),
  ('catalogo-cantabria:estaciones:way-460068608', 'Estación de autobuses de Unquera (Val de San Vicente) – Plaza de la Estación', 'Autobús', '39095', 'Plaza de la Estación 2', '39560', 43.3748, -4.51393, 'address', 'openstreetmap:way/460068608'),
  ('catalogo-cantabria:estaciones:way-568553578', 'Estación de Autobuses (Potes) – Calle de la Serna', 'Autobús', '39055', 'Calle de la Serna 6', '39570', 43.15431, -4.62646, 'address', 'openstreetmap:way/568553578'),
  ('catalogo-cantabria:estaciones:way-611191444', 'Estación de autobuses Los Corrales de Buelna – Avenida Cantabria', 'Autobús', '39025', 'Avenida Cantabria', '39400', 43.25845, -4.06796, 'address', 'openstreetmap:way/611191444'),
  ('catalogo-cantabria:estaciones:way-69902921', 'Estación de Autobuses (Reinosa) – Calle de los Héroes de la Guardia Civil', 'Autobús', '39059', 'Calle de los Héroes de la Guardia Civil', '39200', 42.99421, -4.1416, 'address', 'openstreetmap:way/69902921'),
  ('catalogo-cantabria:estaciones:way-747836370', 'Estación de autobuses de Ramales (Ramales de la Victoria) – Calle Alcalde Pedro Mate Arconada', 'Autobús', '39057', 'Calle Alcalde Pedro Mate Arconada 6', '39800', 43.25804, -3.4633, 'address', 'openstreetmap:way/747836370'),
  ('catalogo-cantabria:estaciones:way-933604865', 'Estación de autobuses de Santoña – Calle Marinos de Santoña', 'Autobús', '39079', 'Calle Marinos de Santoña 6', '39740', 43.44609, -3.45513, 'address', 'openstreetmap:way/933604865');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '39');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 39 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '39'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 104 THEN
    RAISE EXCEPTION 'Se esperaban 104 puntos de Estaciones en Cantabria, hay %', n;
  END IF;
END;
$$;

COMMIT;
