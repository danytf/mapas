-- Carga de la categoría Estaciones de Madrid (provincia 28), trozo de la carga de Andalucía.
-- Origen: estaciones-madrid.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 119 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-madrid:estaciones:node-10313878512', 'Estación de tren de Aluche (Madrid) – Avenida de los Poblados', 'Tren', '28079', 'Avenida de los Poblados', '28047', 40.38571, -3.76144, 'address', 'openstreetmap:node/10313878512'),
  ('catalogo-madrid:estaciones:node-1152895181', 'Estación de tren de Villaverde Bajo (Madrid) – Calle de Juan José Martínez Seco', 'Tren', '28079', 'Calle de Juan José Martínez Seco 84', '28021', 40.35259, -3.68398, 'address', 'openstreetmap:node/1152895181'),
  ('catalogo-madrid:estaciones:node-12299166888', 'Intercambiador de Aluche (Madrid) – Avenida de los Poblados', 'Autobús', '28079', 'Avenida de los Poblados 41', '28047', 40.38511, -3.76022, 'address', 'openstreetmap:node/12299166888'),
  ('catalogo-madrid:estaciones:node-12442154842', 'Estación de tren de Valdemoro – Paseo de la estación', 'Tren', '28161', 'Paseo de la estación 3', NULL, 40.19603, -3.6647, 'address', 'openstreetmap:node/12442154842'),
  ('catalogo-madrid:estaciones:node-12442154843', 'Estación de tren de Aranjuez – Calle de la Estación', 'Tren', '28013', 'Calle de la Estación', NULL, 40.03483, -3.61825, 'address', 'openstreetmap:node/12442154843'),
  ('catalogo-madrid:estaciones:node-12442692463', 'Estación de tren de Getafe Centro – Calle del Ferrocarril', 'Tren', '28065', 'Calle del Ferrocarril', '28901', 40.30971, -3.73407, 'address', 'openstreetmap:node/12442692463'),
  ('catalogo-madrid:estaciones:node-12614210902', 'Estación de tren de Las Zorreras-Navalquejigo (El Escorial) – Calle Alcudia', 'Tren', '28054', 'Calle Alcudia 26', '28292', 40.60945, -4.04595, 'address', 'openstreetmap:node/12614210902'),
  ('catalogo-madrid:estaciones:node-13395053375', 'Estación de tren de Humanes (Humanes de Madrid) – Calle de Cenicientos', 'Tren', '28073', 'Calle de Cenicientos 26', '28970', 40.25563, -3.82844, 'address', 'openstreetmap:node/13395053375'),
  ('catalogo-madrid:estaciones:node-13728638056', 'Estación de tren de El Escorial – Calle Santa Rosa 85 A', 'Tren', '28054', 'Calle Santa Rosa 85 A', '28280', 40.58526, -4.13232, 'address', 'openstreetmap:node/13728638056'),
  ('catalogo-madrid:estaciones:node-13728638057', 'Estación de tren de San Yago (Galapagar) – Avenida Saltos del Sil 1D', 'Tren', '28061', 'Avenida Saltos del Sil 1D', '28292', 40.61783, -4.03108, 'address', 'openstreetmap:node/13728638057'),
  ('catalogo-madrid:estaciones:node-13728638058', 'Estación de tren de Villalba de Guadarrama (Collado Villalba) – Calle Rafael Alberti', 'Tren', '28047', 'Calle Rafael Alberti 2', '28400', 40.62638, -4.00815, 'address', 'openstreetmap:node/13728638058'),
  ('catalogo-madrid:estaciones:node-14063949035', 'Estación de tren de Parla Norte (2027)', 'Tren', '28106', NULL, NULL, 40.24335, -3.75213, 'address', 'openstreetmap:node/14063949035'),
  ('catalogo-madrid:estaciones:node-14144040822', 'Estación de tren de La Tenería (2027) (Pinto) – Calle de Matilde Salvador', 'Tren', '28113', 'Calle de Matilde Salvador', NULL, 40.25785, -3.70422, 'address', 'openstreetmap:node/14144040822'),
  ('catalogo-madrid:estaciones:node-1534461496', 'Estación de tren de Las Águilas (Madrid) – Avenida de Las Águilas', 'Tren', '28079', 'Avenida de Las Águilas', '28044', 40.38146, -3.78038, 'address', 'openstreetmap:node/1534461496'),
  ('catalogo-madrid:estaciones:node-2092341608', 'Estación de tren de Colmenar Viejo – Paseo de la Estación', 'Tren', '28045', 'Paseo de la Estación', NULL, 40.6452, -3.77656, 'address', 'openstreetmap:node/2092341608'),
  ('catalogo-madrid:estaciones:node-2251286293', 'Estación de tren de Alcalá de Henares Universidad – Calle de Inés de Ulloa', 'Tren', '28005', 'Calle de Inés de Ulloa', NULL, 40.50544, -3.3353, 'address', 'openstreetmap:node/2251286293'),
  ('catalogo-madrid:estaciones:node-2402710369', 'Estación de tren de Alcobendas - San Sebastián de los Reyes – Avenida de España', 'Tren', '28134', 'Avenida de España', '28100', 40.54675, -3.6346, 'address', 'openstreetmap:node/2402710369'),
  ('catalogo-madrid:estaciones:node-2542907152', 'Estación de tren de Alcalá de Henares – Calle Pedro Lainez', 'Tren', '28005', 'Calle Pedro Lainez', '28807', 40.48906, -3.36619, 'address', 'openstreetmap:node/2542907152'),
  ('catalogo-madrid:estaciones:node-259092311', 'Estación de tren de El Casar (Getafe) – Avenida El Casar', 'Tren', '28065', 'Avenida El Casar', NULL, 40.31853, -3.70969, 'address', 'openstreetmap:node/259092311'),
  ('catalogo-madrid:estaciones:node-2609596171', 'Estación de tren de Doce de Octubre (Madrid) – Calle de Tomelloso', 'Tren', '28079', 'Calle de Tomelloso 57', '28026', 40.37902, -3.69874, 'address', 'openstreetmap:node/2609596171'),
  ('catalogo-madrid:estaciones:node-2609596185', 'Estación de tren de Embajadores (Madrid) – Glorieta de Embajadores', 'Tren', '28079', 'Glorieta de Embajadores', '28005', 40.40523, -3.70289, 'address', 'openstreetmap:node/2609596185'),
  ('catalogo-madrid:estaciones:node-2609596192', 'Estación de tren de Maestra Justa Freire-Polideportivo Aluche (Madrid) – Avenida de Las Águilas', 'Tren', '28079', 'Avenida de Las Águilas 27', '28044', 40.38355, -3.76863, 'address', 'openstreetmap:node/2609596192'),
  ('catalogo-madrid:estaciones:node-2609596200', 'Estación de tren de Laguna (Madrid) – Calle de la Alhambra', 'Tren', '28079', 'Calle de la Alhambra', '28047', 40.39923, -3.74472, 'address', 'openstreetmap:node/2609596200'),
  ('catalogo-madrid:estaciones:node-2609596207', 'Estación de tren de Puente Alcocer (Madrid) – Calle de Alcocer', 'Tren', '28079', 'Calle de Alcocer', '28041', 40.35034, -3.70502, 'address', 'openstreetmap:node/2609596207'),
  ('catalogo-madrid:estaciones:node-315280726', 'Estación de autobuses de Felipe II (Madrid) – Calle de Alcalá', 'Autobús', '28079', 'Calle de Alcalá 147', '28009', 40.42419, -3.67658, 'address', 'openstreetmap:node/315280726'),
  ('catalogo-madrid:estaciones:node-4999319356', 'Estación de tren de Recoletos (Madrid) – Paseo de Recoletos', 'Tren', '28079', 'Paseo de Recoletos 21', '28001', 40.4225, -3.6917, 'address', 'openstreetmap:node/4999319356'),
  ('catalogo-madrid:estaciones:node-5091921153', 'Intercambiador de Canillejas (Madrid) – Calle de Josefa Valcárcel', 'Autobús', '28079', 'Calle de Josefa Valcárcel', '28022', 40.44908, -3.6095, 'address', 'openstreetmap:node/5091921153'),
  ('catalogo-madrid:estaciones:node-5318415084', 'Estación de tren de Pozuelo (Pozuelo de Alarcón) – Calle Estación', 'Tren', '28115', 'Calle Estación 1', '28224', 40.44741, -3.80006, 'address', 'openstreetmap:node/5318415084'),
  ('catalogo-madrid:estaciones:node-5318415085', 'Estación de tren de Las Rozas (Las Rozas de Madrid) – Calle San Sebastián', 'Tren', '28127', 'Calle San Sebastián 58', '28231', 40.49429, -3.86794, 'address', 'openstreetmap:node/5318415085'),
  ('catalogo-madrid:estaciones:node-5318415087', 'Estación de tren de Pinto – Calle de Fuente Vieja', 'Tren', '28113', 'Calle de Fuente Vieja', '28320', 40.24299, -3.70384, 'address', 'openstreetmap:node/5318415087'),
  ('catalogo-madrid:estaciones:node-5318415089', 'Estación de tren de Getafe Industrial', 'Tren', '28065', NULL, NULL, 40.30551, -3.70758, 'address', 'openstreetmap:node/5318415089'),
  ('catalogo-madrid:estaciones:node-5318415090', 'Estación de tren de San Cristóbal Industrial (Madrid) – Acceso a la Colonia Marconi', 'Tren', '28079', 'Acceso a la Colonia Marconi', NULL, 40.33163, -3.69938, 'address', 'openstreetmap:node/5318415090'),
  ('catalogo-madrid:estaciones:node-5318415091', 'Estación de tren de San Cristóbal de los Ángeles (Madrid) – Calle de Paterna', 'Tren', '28079', 'Calle de Paterna 17', NULL, 40.3422, -3.68375, 'address', 'openstreetmap:node/5318415091'),
  ('catalogo-madrid:estaciones:node-5318466125', 'Estación de tren de Majadahonda – Carretera de El Plantío', 'Tren', '28080', 'Carretera de El Plantío', '28221', 40.47434, -3.84597, 'address', 'openstreetmap:node/5318466125'),
  ('catalogo-madrid:estaciones:node-5318466126', 'Estación de tren de Aravaca (Madrid) – Calle de la Golondrina', 'Tren', '28079', 'Calle de la Golondrina', '28023', 40.44858, -3.7855, 'address', 'openstreetmap:node/5318466126'),
  ('catalogo-madrid:estaciones:node-5318466127', 'Estación de tren de Méndez Álvaro (Madrid) – Calle de Méndez Álvaro', 'Tren', '28079', 'Calle de Méndez Álvaro 83', '28045', 40.3956, -3.67859, 'address', 'openstreetmap:node/5318466127'),
  ('catalogo-madrid:estaciones:node-5318507233', 'Estación de tren de Valdebebas (Madrid) – Avenida de las Fuerzas Armadas', 'Tren', '28079', 'Avenida de las Fuerzas Armadas', NULL, 40.48181, -3.61642, 'address', 'openstreetmap:node/5318507233'),
  ('catalogo-madrid:estaciones:node-5318548036', 'Estación de tren de Aeropuerto T4 (Madrid) – Aeropuerto T4 Salidas', 'Tren', '28079', 'Aeropuerto T4 Salidas', '28042', 40.49233, -3.59359, 'address', 'openstreetmap:node/5318548036'),
  ('catalogo-madrid:estaciones:node-5318600155', 'Estación de tren de Asamblea de Madrid-Entrevías – Calle del Puerto de Balbarán', 'Tren', '28079', 'Calle del Puerto de Balbarán 47', '28018', 40.38163, -3.66802, 'address', 'openstreetmap:node/5318600155'),
  ('catalogo-madrid:estaciones:node-5320204128', 'Estación de tren de Torrejón de Ardoz – Paseo de la Estación', 'Tren', '28148', 'Paseo de la Estación 4', '28850', 40.45473, -3.47973, 'address', 'openstreetmap:node/5320204128'),
  ('catalogo-madrid:estaciones:node-5320204129', 'Estación de tren de Vallecas (Madrid) – Calle de la Sierra de Guadalupe', 'Tren', '28079', 'Calle de la Sierra de Guadalupe 23', '28031', 40.38206, -3.62479, 'address', 'openstreetmap:node/5320204129'),
  ('catalogo-madrid:estaciones:node-5320204130', 'Estación de tren de Santa Eugenia (Madrid) – Avenida de Santa Eugenia', 'Tren', '28079', 'Avenida de Santa Eugenia', '28031', 40.38713, -3.60909, 'address', 'openstreetmap:node/5320204130'),
  ('catalogo-madrid:estaciones:node-5320204131', 'Estación de tren de Vicálvaro (Madrid) – Calle Lago Michigan', 'Tren', '28079', 'Calle Lago Michigan', '28032', 40.40126, -3.59592, 'address', 'openstreetmap:node/5320204131'),
  ('catalogo-madrid:estaciones:node-5320204132', 'Estación de tren de San Fernando de Henares (Coslada) – Avenida de San Pablo', 'Tren', '28049', 'Avenida de San Pablo', '28821', 40.44263, -3.53411, 'address', 'openstreetmap:node/5320204132'),
  ('catalogo-madrid:estaciones:node-5320264660', 'Estación de tren de Soto del Henares (Torrejón de Ardoz) – Avenida de la Constitución', 'Tren', '28148', 'Avenida de la Constitución', NULL, 40.46386, -3.44142, 'address', 'openstreetmap:node/5320264660'),
  ('catalogo-madrid:estaciones:node-5320860232', 'Estación de tren de Ciempozuelos – Calle de San Juan de Dios', 'Tren', '28040', 'Calle de San Juan de Dios 1', '28350', 40.15906, -3.61013, 'address', 'openstreetmap:node/5320860232'),
  ('catalogo-madrid:estaciones:node-5323342056', 'Estación de tren de Zarzalejo – Calle Ferrocarril', 'Tren', '28183', 'Calle Ferrocarril', NULL, 40.53863, -4.15797, 'address', 'openstreetmap:node/5323342056'),
  ('catalogo-madrid:estaciones:node-5323342059', 'Estación de tren de Robledo de Chavela – Calle José Ortega y Gasset', 'Tren', '28125', 'Calle José Ortega y Gasset', NULL, 40.52122, -4.24714, 'address', 'openstreetmap:node/5323342059'),
  ('catalogo-madrid:estaciones:node-5448172309', 'Estación de tren de El Pozo (Madrid) – Calle del Puerto de Balbarán', 'Tren', '28079', 'Calle del Puerto de Balbarán 133', '28018', 40.37617, -3.6561, 'address', 'openstreetmap:node/5448172309'),
  ('catalogo-madrid:estaciones:node-5868423604', 'Estación de tren de Castillejo-Añover (Aranjuez)', 'Tren', '28013', NULL, NULL, 39.94957, -3.73859, 'address', 'openstreetmap:node/5868423604'),
  ('catalogo-madrid:estaciones:node-6068519469', 'Estación de tren de La Garena (Alcalá de Henares) – Calle Fernando Fernán Gómez', 'Tren', '28005', 'Calle Fernando Fernán Gómez', '28806', 40.48034, -3.39299, 'address', 'openstreetmap:node/6068519469'),
  ('catalogo-madrid:estaciones:node-6178980292', 'Estación de tren de Parla – Calle Real', 'Tren', '28106', 'Calle Real 95', '28980', 40.24105, -3.76936, 'address', 'openstreetmap:node/6178980292'),
  ('catalogo-madrid:estaciones:node-6179305125', 'Estación de tren de Villaverde Alto (Madrid) – Calle de Domingo Párraga', 'Tren', '28079', 'Calle de Domingo Párraga 15', '28021', 40.34152, -3.71159, 'address', 'openstreetmap:node/6179305125'),
  ('catalogo-madrid:estaciones:node-6179305128', 'Estación de tren de Las Margaritas Universidad (Getafe) – Calle Santo Domingo de la Calzada', 'Tren', '28065', 'Calle Santo Domingo de la Calzada', NULL, 40.32296, -3.72731, 'address', 'openstreetmap:node/6179305128'),
  ('catalogo-madrid:estaciones:node-6179305132', 'Estación de tren de Getafe Sector 3 – Calle Toledo', 'Tren', '28065', 'Calle Toledo', NULL, 40.28824, -3.73751, 'address', 'openstreetmap:node/6179305132'),
  ('catalogo-madrid:estaciones:node-6179776526', 'Estación de tren de Universidad Pontificia de Comillas (Madrid)', 'Tren', '28079', NULL, NULL, 40.55406, -3.68349, 'address', 'openstreetmap:node/6179776526'),
  ('catalogo-madrid:estaciones:node-6179776542', 'Estación de tren de Valdelasfuentes (Alcobendas) – Calle del Marqués de la Valdavia', 'Tren', '28006', 'Calle del Marqués de la Valdavia', NULL, 40.5474, -3.65439, 'address', 'openstreetmap:node/6179776542'),
  ('catalogo-madrid:estaciones:node-6185935418', 'Estación de tren de Meco – Calle La Venta', 'Tren', '28083', 'Calle La Venta', '28880', 40.53463, -3.29857, 'address', 'openstreetmap:node/6185935418'),
  ('catalogo-madrid:estaciones:node-6270304346', 'Estación de autobuses de La Veloz (cocheras) (Rivas-Vaciamadrid) – Calle de la Tuerca', 'Autobús', '28123', 'Calle de la Tuerca 2', '28522', 40.34652, -3.53637, 'address', 'openstreetmap:node/6270304346'),
  ('catalogo-madrid:estaciones:node-6823409719', 'Estación de tren de Coslada – Calle de Luis Braille', 'Tren', '28049', 'Calle de Luis Braille 8', '28822', 40.42373, -3.56101, 'address', 'openstreetmap:node/6823409719'),
  ('catalogo-madrid:estaciones:node-6970536603', 'Estación de tren de Fuente de la Mora (Madrid) – Calle de Dulce Chacón', 'Tren', '28079', 'Calle de Dulce Chacón', '28050', 40.48496, -3.66311, 'address', 'openstreetmap:node/6970536603'),
  ('catalogo-madrid:estaciones:node-7044883744', 'Estación de tren de Nuevos Ministerios (Madrid) – Paseo de la Castellana', 'Tren', '28079', 'Paseo de la Castellana', '28046', 40.44501, -3.69197, 'address', 'openstreetmap:node/7044883744'),
  ('catalogo-madrid:estaciones:node-7499028215', 'Estación de tren de Atocha-Cercanías (Madrid) – Avenida de la Ciudad de Barcelona', 'Tren', '28079', 'Avenida de la Ciudad de Barcelona', '28007', 40.40597, -3.68877, 'approximate', 'openstreetmap:node/7499028215'),
  ('catalogo-madrid:estaciones:node-7499028216', 'Estación de tren de Madrid-Puerta de Atocha-Almudena Grandes – Calle de Méndez Álvaro', 'Tren', '28079', 'Calle de Méndez Álvaro', '28045', 40.40568, -3.69002, 'approximate', 'openstreetmap:node/7499028216'),
  ('catalogo-madrid:estaciones:node-770218121', 'Estación de tren de Tres Cantos – Plaza de la Estación', 'Tren', '28903', 'Plaza de la Estación', '28760', 40.59891, -3.71565, 'address', 'openstreetmap:node/770218121'),
  ('catalogo-madrid:estaciones:node-7797479570', 'Estación de tren de Zarzaquemada (Leganés) – Calle El Roncal', 'Tren', '28074', 'Calle El Roncal', '28915', 40.34084, -3.74825, 'address', 'openstreetmap:node/7797479570'),
  ('catalogo-madrid:estaciones:node-7797548495', 'Estación de tren de Universidad-Cantoblanco (Madrid) – Avenida de Francisco Tomás y Valiente', 'Tren', '28079', 'Avenida de Francisco Tomás y Valiente', NULL, 40.5438, -3.70019, 'address', 'openstreetmap:node/7797548495'),
  ('catalogo-madrid:estaciones:node-7881485897', 'Estación de tren de T4 (Madrid) – Avenida Hispanidad', 'Tren', '28079', 'Avenida Hispanidad', '28042', 40.49133, -3.59147, 'approximate', 'openstreetmap:node/7881485897'),
  ('catalogo-madrid:estaciones:node-7881485901', 'Estación de tren de T4S (Madrid)', 'Tren', '28079', NULL, '28042', 40.49448, -3.56721, 'approximate', 'openstreetmap:node/7881485901'),
  ('catalogo-madrid:estaciones:node-79715911', 'Estación de tren de Fuencarral (Madrid)', 'Tren', '28079', NULL, NULL, 40.50154, -3.68216, 'address', 'openstreetmap:node/79715911'),
  ('catalogo-madrid:estaciones:node-8326246961', 'Estación de Mercancías Madrid - Abroñigal – Calle de Méndez Álvaro', 'Tren', '28079', 'Calle de Méndez Álvaro 84', '28053', 40.38893, -3.67772, 'address', 'openstreetmap:node/8326246961'),
  ('catalogo-madrid:estaciones:node-845763449', 'Estación de tren de El Goloso (Madrid) – Vía de servicio Autovía de Colmenar', 'Tren', '28079', 'Vía de servicio Autovía de Colmenar', NULL, 40.55847, -3.71383, 'address', 'openstreetmap:node/845763449'),
  ('catalogo-madrid:estaciones:node-9023491303', 'Estación de tren de Cercedilla – Calle de Emilio Serrano', 'Tren', '28038', 'Calle de Emilio Serrano 32', '28470', 40.73766, -4.06603, 'address', 'openstreetmap:node/9023491303'),
  ('catalogo-madrid:estaciones:node-9518317241', 'Estación de tren de Pirámides (Madrid) – Paseo de Juan Antonio Vallejo-Nájera Botas', 'Tren', '28079', 'Paseo de Juan Antonio Vallejo-Nájera Botas', '28005', 40.40296, -3.71198, 'address', 'openstreetmap:node/9518317241'),
  ('catalogo-madrid:estaciones:node-9669569787', 'Estación de tren de El Barrial-Centro Comercial Pozuelo (Madrid) – Calle de Alsasua', 'Tren', '28079', 'Calle de Alsasua', NULL, 40.46533, -3.80785, 'address', 'openstreetmap:node/9669569787'),
  ('catalogo-madrid:estaciones:node-9820978455', 'Estación de tren de Madrid-Príncipe Pío – Glorieta de San Vicente', 'Tren', '28079', 'Glorieta de San Vicente', '28008', 40.4216, -3.71903, 'address', 'openstreetmap:node/9820978455'),
  ('catalogo-madrid:estaciones:node-9821007500', 'Estación de tren de Madrid-Chamartín-Clara Campoamor – Calle de Agustín de Foxá', 'Tren', '28079', 'Calle de Agustín de Foxá', '28036', 40.47206, -3.68226, 'address', 'openstreetmap:node/9821007500'),
  ('catalogo-madrid:estaciones:node-9856257754', 'Terminal de autobuses (Alcalá de Henares) – Vía Complutense', 'Autobús', '28005', 'Vía Complutense 49', '28805', 40.48648, -3.36072, 'address', 'openstreetmap:node/9856257754'),
  ('catalogo-madrid:estaciones:way-1042045116', 'Estación de tren de Delicias (Madrid) – Calle de Ramírez de Prado', 'Tren', '28079', 'Calle de Ramírez de Prado', '28045', 40.3999, -3.69171, 'address', 'openstreetmap:way/1042045116'),
  ('catalogo-madrid:estaciones:way-106594114', 'Intercambiador de Plaza Elíptica (Madrid) – Plaza Elíptica', 'Autobús', '28079', 'Plaza Elíptica 3', '28026', 40.38444, -3.71838, 'address', 'openstreetmap:way/106594114'),
  ('catalogo-madrid:estaciones:way-1121044333', 'Estación de Las Infantas (Aranjuez)', 'Tren', '28013', NULL, NULL, 39.9972, -3.68952, 'address', 'openstreetmap:way/1121044333'),
  ('catalogo-madrid:estaciones:way-119181105', 'Intercambiador de Príncipe Pío (Madrid) – Paseo de la Florida', 'Autobús', '28079', 'Paseo de la Florida', '28008', 40.42168, -3.72112, 'address', 'openstreetmap:way/119181105'),
  ('catalogo-madrid:estaciones:way-1303719251', 'Terminal de Autobuses T4 (Madrid)', 'Autobús', '28079', NULL, NULL, 40.49517, -3.59485, 'address', 'openstreetmap:way/1303719251'),
  ('catalogo-madrid:estaciones:way-1343098437', 'Intercambiador de Valdebebas (Madrid) – Avenida de las Fuerzas Armadas', 'Autobús', '28079', 'Avenida de las Fuerzas Armadas', NULL, 40.4832, -3.61569, 'address', 'openstreetmap:way/1343098437'),
  ('catalogo-madrid:estaciones:way-1381926322', 'Intercambiador de Pavones (Madrid) – Calle de la Hacienda de Pavones', 'Autobús', '28079', 'Calle de la Hacienda de Pavones 346', '28030', 40.40006, -3.63544, 'address', 'openstreetmap:way/1381926322'),
  ('catalogo-madrid:estaciones:way-143133367', 'Estación de autobuses de La Parada (Collado Villalba) – Calle Rafael Alberti', 'Autobús', '28047', 'Calle Rafael Alberti 15', '28400', 40.62637, -4.00443, 'approximate', 'openstreetmap:way/143133367'),
  ('catalogo-madrid:estaciones:way-14665984', 'Estación de tren de Ramón y Cajal (Madrid) – Calle de San Modesto', 'Tren', '28079', 'Calle de San Modesto 50', '28034', 40.48815, -3.69496, 'address', 'openstreetmap:way/14665984'),
  ('catalogo-madrid:estaciones:way-174195150', 'Estación de autobuses de San Lorenzo de el Escorial – Calle San Juan', 'Autobús', '28131', 'Calle San Juan 11', '28200', 40.59224, -4.14393, 'address', 'openstreetmap:way/174195150'),
  ('catalogo-madrid:estaciones:way-176394438', 'Intercambiador de Moncloa Islas 2 y 3 (Madrid) – Calle de la Princesa', 'Autobús', '28079', 'Calle de la Princesa 89', '28008', 40.43534, -3.71916, 'approximate', 'openstreetmap:way/176394438'),
  ('catalogo-madrid:estaciones:way-176394440', 'Intercambiador de Moncloa Isla 1 (Madrid) – Paseo de Moret', 'Autobús', '28079', 'Paseo de Moret', '28008', 40.43466, -3.71957, 'approximate', 'openstreetmap:way/176394440'),
  ('catalogo-madrid:estaciones:way-201247467', 'Estación de tren de San José de Valderas (Alcorcón) – Calle Sahagún', 'Tren', '28007', 'Calle Sahagún', NULL, 40.35656, -3.81568, 'address', 'openstreetmap:way/201247467'),
  ('catalogo-madrid:estaciones:way-203423654', 'Estación de tren de Torrelodones – Plaza de Salvador Sánchez Frascuelo 1 D', 'Tren', '28152', 'Plaza de Salvador Sánchez Frascuelo 1 D', '28250', 40.57459, -3.95702, 'address', 'openstreetmap:way/203423654'),
  ('catalogo-madrid:estaciones:way-204188155', 'Estación de tren de Las Matas (Las Rozas de Madrid) – Calle Martín Iriarte', 'Tren', '28127', 'Calle Martín Iriarte 3', '28290', 40.55201, -3.89647, 'address', 'openstreetmap:way/204188155'),
  ('catalogo-madrid:estaciones:way-204488968', 'Estación de tren de Pinar de Las Rozas (Las Rozas de Madrid)', 'Tren', '28127', NULL, NULL, 40.52282, -3.88198, 'address', 'openstreetmap:way/204488968'),
  ('catalogo-madrid:estaciones:way-230250506', 'Estación de tren de Galapagar - La Navata – Carretera de Galapagar a La Navata', 'Tren', '28061', 'Carretera de Galapagar a La Navata 170', '28260', 40.60065, -3.98261, 'address', 'openstreetmap:way/230250506'),
  ('catalogo-madrid:estaciones:way-230359020', 'Estación de tren de Alpedrete – Camino de la Estación', 'Tren', '28010', 'Camino de la Estación', NULL, 40.65824, -4.03532, 'address', 'openstreetmap:way/230359020'),
  ('catalogo-madrid:estaciones:way-230359022', 'Estación de tren de Collado Mediano – Calle Geranios', 'Tren', '28046', 'Calle Geranios', NULL, 40.69257, -4.03519, 'address', 'openstreetmap:way/230359022'),
  ('catalogo-madrid:estaciones:way-230359023', 'Estación de tren de Los Molinos – Calle Pedro Gutiérrez', 'Tren', '28087', 'Calle Pedro Gutiérrez', NULL, 40.70658, -4.06706, 'address', 'openstreetmap:way/230359023'),
  ('catalogo-madrid:estaciones:way-230359031', 'Estación de tren de Tablada (Guadarrama)', 'Tren', '28068', NULL, '28440', 40.70563, -4.12539, 'address', 'openstreetmap:way/230359031'),
  ('catalogo-madrid:estaciones:way-23066996', 'Estación Sur de Autobuses (Madrid) – Calle de Méndez Álvaro', 'Autobús', '28079', 'Calle de Méndez Álvaro 83', '28045', 40.3943, -3.67767, 'address', 'openstreetmap:way/23066996'),
  ('catalogo-madrid:estaciones:way-255246392', 'Estación de Cuatro Vientos (Madrid) – Calle de Robert Capa', 'Tren', '28079', 'Calle de Robert Capa', NULL, 40.37805, -3.79083, 'address', 'openstreetmap:way/255246392'),
  ('catalogo-madrid:estaciones:way-255246393', 'Estación de tren de Fuenlabrada – Paseo de la Estación', 'Tren', '28058', 'Paseo de la Estación 18', '28944', 40.2834, -3.79919, 'address', 'openstreetmap:way/255246393'),
  ('catalogo-madrid:estaciones:way-255246394', 'Estación de tren de La Serna (Fuenlabrada) – Calle de Gerona', 'Tren', '28058', 'Calle de Gerona', '28945', 40.29672, -3.79248, 'address', 'openstreetmap:way/255246394'),
  ('catalogo-madrid:estaciones:way-255246395', 'Estación de tren de Leganés – Paseo de la Estación', 'Tren', '28074', 'Paseo de la Estación', '28911', 40.32921, -3.77111, 'address', 'openstreetmap:way/255246395'),
  ('catalogo-madrid:estaciones:way-255246398', 'Estación de tren de Móstoles – Parque Vosa', 'Tren', '28092', 'Parque Vosa 27', '28933', 40.32858, -3.86379, 'address', 'openstreetmap:way/255246398'),
  ('catalogo-madrid:estaciones:way-255246399', 'Estación de tren de Móstoles-El Soto – Calle Granada', 'Tren', '28092', 'Calle Granada', '28935', 40.33096, -3.88226, 'address', 'openstreetmap:way/255246399'),
  ('catalogo-madrid:estaciones:way-255246400', 'Estación de tren de Orcasitas (Madrid) – Calle de Trevélez', 'Tren', '28079', 'Calle de Trevélez 3', '28041', 40.36551, -3.70474, 'address', 'openstreetmap:way/255246400'),
  ('catalogo-madrid:estaciones:way-255246416', 'Estación de tren de Parque Polvoranca (Leganés) – Calle Alcalde Francisco Moreno Menéndez', 'Tren', '28074', 'Calle Alcalde Francisco Moreno Menéndez', NULL, 40.31168, -3.78382, 'address', 'openstreetmap:way/255246416'),
  ('catalogo-madrid:estaciones:way-275204111', 'Estación de tren de Alcorcón Central – Calle Berlín', 'Tren', '28007', 'Calle Berlín', '28922', 40.35033, -3.83182, 'address', 'openstreetmap:way/275204111'),
  ('catalogo-madrid:estaciones:way-28846676', 'Estación de autobuses de Villaverde Bajo - Cruce (Madrid) – Calle de Santa Petronila', 'Autobús', '28079', 'Calle de Santa Petronila 11', '28041', 40.35044, -3.69263, 'address', 'openstreetmap:way/28846676'),
  ('catalogo-madrid:estaciones:way-310410261', 'Estación de tren de Pitis (Madrid) – Calle María Casares', 'Tren', '28079', 'Calle María Casares', NULL, 40.4953, -3.72645, 'address', 'openstreetmap:way/310410261'),
  ('catalogo-madrid:estaciones:way-341911665', 'Intercambiador de Avenida de América (Madrid) – Avenida de América', 'Autobús', '28079', 'Avenida de América', '28002', 40.43821, -3.67638, 'address', 'openstreetmap:way/341911665'),
  ('catalogo-madrid:estaciones:way-384660236', 'Estación de Autobuses de Villa del Prado – Calle Príncipe de Asturias', 'Autobús', '28171', 'Calle Príncipe de Asturias', NULL, 40.27914, -4.30922, 'address', 'openstreetmap:way/384660236'),
  ('catalogo-madrid:estaciones:way-548233128', 'Estación de tren de Sol (Madrid) – Calle de la Montera', 'Tren', '28079', 'Calle de la Montera 18', '28013', 40.41783, -3.70222, 'approximate', 'openstreetmap:way/548233128'),
  ('catalogo-madrid:estaciones:way-559233685', 'Estación de tren de Mirasierra - Paco de Lucía (Madrid) – Calle de la Costa Brava', 'Tren', '28079', 'Calle de la Costa Brava 18', '28034', 40.49987, -3.70911, 'address', 'openstreetmap:way/559233685'),
  ('catalogo-madrid:estaciones:way-793646319', 'Estación de tren de Los Negrales (Alpedrete) – Avenida Reina Victoria', 'Tren', '28010', 'Avenida Reina Victoria 39', '28439', 40.63905, -4.02208, 'address', 'openstreetmap:way/793646319'),
  ('catalogo-madrid:estaciones:way-82887225', 'Estación de Autobuses Príncipe de Asturias (Moralzarzal) – Calle del Concejo', 'Autobús', '28090', 'Calle del Concejo 3', '28411', 40.68122, -3.96858, 'address', 'openstreetmap:way/82887225'),
  ('catalogo-madrid:estaciones:way-870929426', 'Intercambiador (Alcalá de Henares) – Avenida de Daganzo 2A', 'Autobús', '28005', 'Avenida de Daganzo 2A', '28806', 40.48988, -3.37526, 'address', 'openstreetmap:way/870929426'),
  ('catalogo-madrid:estaciones:way-90953094', 'Estación de tren de Las Retamas (Alcorcón) – Avenida de Móstoles', 'Tren', '28007', 'Avenida de Móstoles', NULL, 40.34155, -3.84283, 'address', 'openstreetmap:way/90953094');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 119 THEN
    RAISE EXCEPTION 'Se esperaban 119 puntos de Estaciones en Madrid, hay %', n;
  END IF;
END;
$$;

COMMIT;
