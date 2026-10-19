-- Carga de la categoría (varias) de Málaga (provincia 29), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 88 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-10106340146', 'Carrefour Marbella – Calle López de Mena', NULL, '29069', 'Calle López de Mena', NULL, 36.4837, -4.98716, 'address', 'openstreetmap:node/10106340146'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-10212491919', 'Decathlon Málaga – Avenida Simón Bolivar', NULL, '29067', 'Avenida Simón Bolivar', '29011', 36.73452, -4.4313, 'address', 'openstreetmap:node/10212491919'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-10292015209', 'Carrefour Málaga – Calle Reding', NULL, '29067', 'Calle Reding', NULL, 36.71783, -4.41134, 'address', 'openstreetmap:node/10292015209'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-10942029779', 'Carrefour Nerja – Plaza España', NULL, '29075', 'Plaza España 2', '29780', 36.74607, -3.87745, 'address', 'openstreetmap:node/10942029779'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11404904492', 'Carrefour Málaga – Calle Héroe de Sostoa', NULL, '29067', 'Calle Héroe de Sostoa 55', '29002', 36.70779, -4.43522, 'address', 'openstreetmap:node/11404904492'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11650324969', 'Carrefour Torremolinos – Paseo del Colorado', NULL, '29901', 'Paseo del Colorado', '29620', 36.63202, -4.49261, 'address', 'openstreetmap:node/11650324969'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-11780187569', 'El Corte Inglés Málaga – Calle Obispo Ramón Buxarrais', NULL, '29067', 'Calle Obispo Ramón Buxarrais', NULL, 36.70877, -4.46018, 'address', 'openstreetmap:node/11780187569'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11863136243', 'Carrefour Torremolinos – Calle de Carmen', NULL, '29901', 'Calle de Carmen 40', NULL, 36.61079, -4.50324, 'address', 'openstreetmap:node/11863136243'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12005734669', 'Carrefour Málaga – Calle Antonio Luis Carrión', NULL, '29067', 'Calle Antonio Luis Carrión', NULL, 36.71284, -4.43782, 'address', 'openstreetmap:node/12005734669'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12424277801', 'Carrefour Estepona – Calle Viento', NULL, '29051', 'Calle Viento', NULL, 36.42502, -5.1468, 'address', 'openstreetmap:node/12424277801'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12853328983', 'Carrefour Manilva', NULL, '29068', NULL, NULL, 36.33303, -5.26598, 'address', 'openstreetmap:node/12853328983'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12984238690', 'Carrefour Benahavís – Plaza de la Iglesia', NULL, '29023', 'Plaza de la Iglesia', NULL, 36.524, -5.04642, 'address', 'openstreetmap:node/12984238690'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-13446939195', 'Carrefour Málaga – Avenida Juan Sebastián Elcano', NULL, '29067', 'Avenida Juan Sebastián Elcano', NULL, 36.72205, -4.37809, 'address', 'openstreetmap:node/13446939195'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-13512901639', 'Carrefour Málaga – Paseo Antonio Machado', NULL, '29067', 'Paseo Antonio Machado 80', NULL, 36.70066, -4.43607, 'address', 'openstreetmap:node/13512901639'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-13937895233', 'Carrefour Málaga – Calle Fernando Camino', NULL, '29067', 'Calle Fernando Camino 22', NULL, 36.71858, -4.40937, 'address', 'openstreetmap:node/13937895233'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-1676609210', 'Carrefour Estepona – Plaza Doctor Mena Arce', NULL, '29051', 'Plaza Doctor Mena Arce', NULL, 36.42969, -5.14287, 'address', 'openstreetmap:node/1676609210'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2262647756', 'Carrefour Málaga – Calle Mark Twain', NULL, '29067', 'Calle Mark Twain', NULL, 36.73502, -4.4322, 'address', 'openstreetmap:node/2262647756'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2368322220', 'Carrefour Nerja – Calle Manuel Marín', NULL, '29075', 'Calle Manuel Marín', NULL, 36.74568, -3.87973, 'address', 'openstreetmap:node/2368322220'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2376435473', 'Carrefour Benalmádena – Calle Aguamarina', NULL, '29025', 'Calle Aguamarina', NULL, 36.60344, -4.54179, 'address', 'openstreetmap:node/2376435473'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2393654927', 'Carrefour Fuengirola – Calle San Cayetano', NULL, '29054', 'Calle San Cayetano', NULL, 36.5286, -4.6323, 'address', 'openstreetmap:node/2393654927'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2408945732', 'Carrefour Benalmádena – Avenida Retamar', NULL, '29025', 'Avenida Retamar', '29639', 36.58673, -4.59099, 'address', 'openstreetmap:node/2408945732'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2496240026', 'Carrefour Marbella – Calle Ávila', NULL, '29069', 'Calle Ávila', NULL, 36.4819, -4.99376, 'address', 'openstreetmap:node/2496240026'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2499255688', 'Carrefour Cártama – Calle María Zambrano', NULL, '29038', 'Calle María Zambrano 1', NULL, 36.73704, -4.60633, 'address', 'openstreetmap:node/2499255688'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2549442733', 'Carrefour Marbella – Avenida Valeriano Rodríguez', NULL, '29069', 'Avenida Valeriano Rodríguez', NULL, 36.49601, -4.77703, 'address', 'openstreetmap:node/2549442733'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-2610845638', 'Decathlon Málaga – Calle Strachan', NULL, '29067', 'Calle Strachan 3', '29015', 36.71982, -4.42117, 'address', 'openstreetmap:node/2610845638'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2643518374', 'Carrefour Antequera – Calle F', NULL, '29015', 'Calle F', NULL, 37.02623, -4.57184, 'address', 'openstreetmap:node/2643518374'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2663350043', 'Carrefour Torremolinos – Calle Casablanca', NULL, '29901', 'Calle Casablanca', '29620', 36.62217, -4.4978, 'address', 'openstreetmap:node/2663350043'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-2802575515', 'Decathlon Mijas – Avenida María Sáenz de Tejada', NULL, '29070', 'Avenida María Sáenz de Tejada', '29651', 36.53552, -4.63562, 'address', 'openstreetmap:node/2802575515'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-2802575517', 'MediaMarkt Mijas – Calle Alfarante', NULL, '29070', 'Calle Alfarante', NULL, 36.53639, -4.63632, 'address', 'openstreetmap:node/2802575517'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-2856304578', 'El Corte Inglés Torremolinos – Calle Canadá', NULL, '29901', 'Calle Canadá', NULL, 36.63271, -4.49884, 'address', 'openstreetmap:node/2856304578'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-2952735540', 'El Corte Inglés Fuengirola – Avenida Nuestro Padre Jesús Cautivo', NULL, '29054', 'Avenida Nuestro Padre Jesús Cautivo', NULL, 36.55501, -4.61471, 'address', 'openstreetmap:node/2952735540'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2953578597', 'Carrefour Benalmádena – Avenida Antonio Machado', NULL, '29025', 'Avenida Antonio Machado', NULL, 36.59828, -4.51823, 'address', 'openstreetmap:node/2953578597'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-301152790', 'Carrefour Nerja – Calle Antonio Ferrandis Chanquete', NULL, '29075', 'Calle Antonio Ferrandis Chanquete', '29780', 36.74765, -3.88074, 'address', 'openstreetmap:node/301152790'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-321316164', 'Carrefour Estepona – Calle Arquitecto Pablo Cerezo', NULL, '29051', 'Calle Arquitecto Pablo Cerezo', NULL, 36.42849, -5.13097, 'address', 'openstreetmap:node/321316164'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-3361908105', 'MediaMarkt Málaga – Calle Héroe de Sostoa', NULL, '29067', 'Calle Héroe de Sostoa', NULL, 36.71121, -4.43156, 'address', 'openstreetmap:node/3361908105'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3430896877', 'Carrefour Benalmádena – Avenida de la Estación', NULL, '29025', 'Avenida de la Estación', NULL, 36.59846, -4.53905, 'address', 'openstreetmap:node/3430896877'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3441711515', 'Carrefour Málaga – Calle Almería', NULL, '29067', 'Calle Almería 41', NULL, 36.72079, -4.3565, 'address', 'openstreetmap:node/3441711515'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3441711516', 'Carrefour Málaga – Avenida Pío Baroja', NULL, '29067', 'Avenida Pío Baroja 16', NULL, 36.72014, -4.36292, 'address', 'openstreetmap:node/3441711516'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3576635457', 'Carrefour Vélez-Málaga – Calle Miguel Hernández', NULL, '29094', 'Calle Miguel Hernández', NULL, 36.74323, -4.09401, 'address', 'openstreetmap:node/3576635457'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3700931854', 'Carrefour Marbella – Urbanizacion El Rosario', NULL, '29069', 'Urbanizacion El Rosario', NULL, 36.50435, -4.80949, 'address', 'openstreetmap:node/3700931854'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3815635644', 'Carrefour Málaga – Calle Cervantes', NULL, '29067', 'Calle Cervantes 5', '29016', 36.72006, -4.4097, 'address', 'openstreetmap:node/3815635644'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4043585238', 'Carrefour Estepona – Avenida Juan Carlos I', NULL, '29051', 'Avenida Juan Carlos I 23', '29680', 36.42474, -5.15117, 'address', 'openstreetmap:node/4043585238'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4059474537', 'Carrefour Vélez-Málaga – Calle Jaberas', NULL, '29094', 'Calle Jaberas', NULL, 36.77421, -4.10321, 'address', 'openstreetmap:node/4059474537'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4256823674', 'Carrefour Estepona – Calle Torre Almenara', NULL, '29051', 'Calle Torre Almenara', NULL, 36.41679, -5.15929, 'address', 'openstreetmap:node/4256823674'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4404098890', 'Carrefour Málaga – Avenida Obispo Ángel Herrera Oria', NULL, '29067', 'Avenida Obispo Ángel Herrera Oria', NULL, 36.71837, -4.43834, 'address', 'openstreetmap:node/4404098890'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4531811362', 'Carrefour Málaga – Avenida de los Guindos', NULL, '29067', 'Avenida de los Guindos 31', '29004', 36.69103, -4.44743, 'address', 'openstreetmap:node/4531811362'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4678685192', 'Carrefour Rincón de la Victoria – Avenida del Mediterráneo', NULL, '29082', 'Avenida del Mediterráneo', NULL, 36.71509, -4.28352, 'address', 'openstreetmap:node/4678685192'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4718246840', 'Carrefour Málaga – Avenida Pintor Joaquín Sorolla', NULL, '29067', 'Avenida Pintor Joaquín Sorolla 7', '29016', 36.72357, -4.39662, 'address', 'openstreetmap:node/4718246840'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4861794207', 'Carrefour Málaga – Calle Gordón', NULL, '29067', 'Calle Gordón 15', '29013', 36.72929, -4.41599, 'address', 'openstreetmap:node/4861794207'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5212134821', 'Carrefour Manilva – Avenida de Manilva', NULL, '29068', 'Avenida de Manilva', NULL, 36.36718, -5.22746, 'address', 'openstreetmap:node/5212134821'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-5693245187', 'MediaMarkt Málaga – Calle Alfonso Ponce de León', NULL, '29067', 'Calle Alfonso Ponce de León', NULL, 36.65548, -4.4794, 'address', 'openstreetmap:node/5693245187'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5776676066', 'Carrefour Málaga – Alameda Principal', NULL, '29067', 'Alameda Principal 45', '29001', 36.71675, -4.42452, 'address', 'openstreetmap:node/5776676066'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5892561788', 'Carrefour Málaga – Calle Tejón y Rodríguez', NULL, '29067', 'Calle Tejón y Rodríguez 1', NULL, 36.7233, -4.42119, 'address', 'openstreetmap:node/5892561788'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6001734499', 'Carrefour Ronda – Calle Viento', NULL, '29084', 'Calle Viento', NULL, 36.74777, -5.15613, 'address', 'openstreetmap:node/6001734499'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6203189777', 'Carrefour Málaga – Calle Jano', NULL, '29067', 'Calle Jano 2', NULL, 36.72334, -4.47549, 'address', 'openstreetmap:node/6203189777'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6309099450', 'Carrefour Málaga – 5', NULL, '29067', '5', NULL, 36.7231, -4.41826, 'address', 'openstreetmap:node/6309099450'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6341984685', 'Carrefour Ronda – Calle Nueva', NULL, '29084', 'Calle Nueva 6', '29400', 36.74151, -5.1659, 'address', 'openstreetmap:node/6341984685'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6511778845', 'Carrefour Coín – Carretera de Cártama a Coín', NULL, '29042', 'Carretera de Cártama a Coín', NULL, 36.6748, -4.73323, 'address', 'openstreetmap:node/6511778845'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:node-6715434071', 'Leroy Merlin Mijas – Calle Alfarante', NULL, '29070', 'Calle Alfarante', NULL, 36.53567, -4.63617, 'address', 'openstreetmap:node/6715434071'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9017532348', 'Carrefour Fuengirola – Calle Lamo de Espinosa', NULL, '29054', 'Calle Lamo de Espinosa', NULL, 36.54368, -4.62083, 'address', 'openstreetmap:node/9017532348'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-9282711229', 'Decathlon Ronda – Calle Juan José de Puya', NULL, '29084', 'Calle Juan José de Puya', NULL, 36.74383, -5.1634, 'address', 'openstreetmap:node/9282711229'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9373406530', 'Carrefour Marbella – Calle Valentuñana', NULL, '29069', 'Calle Valentuñana', NULL, 36.51068, -4.88883, 'address', 'openstreetmap:node/9373406530'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-945494862', 'Carrefour Rincón de la Victoria – Calle Arroyo Totalán', NULL, '29082', 'Calle Arroyo Totalán', NULL, 36.72391, -4.31393, 'address', 'openstreetmap:node/945494862'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-946778263', 'Carrefour Marbella – Calle 19B', NULL, '29069', 'Calle 19B', NULL, 36.47377, -5.0049, 'address', 'openstreetmap:node/946778263'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-979976817', 'Carrefour Mijas – Calle Ana Maria de Calypso', NULL, '29070', 'Calle Ana Maria de Calypso', NULL, 36.49262, -4.71462, 'address', 'openstreetmap:node/979976817'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9873926006', 'Carrefour Málaga – Calle Especería', NULL, '29067', 'Calle Especería 7', '29005', 36.72084, -4.42318, 'address', 'openstreetmap:node/9873926006'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:relation-10628189', 'El Corte Inglés Málaga – Avenida Andalucía 4-6', NULL, '29067', 'Avenida Andalucía 4-6', '29002', 36.71749, -4.42828, 'address', 'openstreetmap:relation/10628189'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-1105145506', 'Carrefour Mijas – Calle La Noria de Noria Golf', NULL, '29070', 'Calle La Noria de Noria Golf', NULL, 36.5065, -4.68361, 'address', 'openstreetmap:way/1105145506'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-1535491253', 'Carrefour Casabermeja – Calle el Olivio', NULL, '29039', 'Calle el Olivio 4', NULL, 36.89806, -4.42571, 'address', 'openstreetmap:way/1535491253'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-223533686', 'Leroy Merlin Málaga – Camino Loma de San Julián', NULL, '29067', 'Camino Loma de San Julián', NULL, 36.66747, -4.46871, 'address', 'openstreetmap:way/223533686'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-226263896', 'Carrefour Mijas – Calle San Valentín', NULL, '29070', 'Calle San Valentín', NULL, 36.54484, -4.6354, 'address', 'openstreetmap:way/226263896'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-226727623', 'Carrefour Mijas – Bulevar de La Cala', NULL, '29070', 'Bulevar de La Cala', '29649', 36.50541, -4.67894, 'address', 'openstreetmap:way/226727623'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-277236606', 'Decathlon Málaga – Camino Loma de San Julián', NULL, '29067', 'Camino Loma de San Julián', '29004', 36.66787, -4.47015, 'address', 'openstreetmap:way/277236606'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-297610696', 'Carrefour Rincón de la Victoria – Plaza Don Antonio Estrada', NULL, '29082', 'Plaza Don Antonio Estrada', '29720', 36.71617, -4.30871, 'address', 'openstreetmap:way/297610696'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-322625755', 'Leroy Merlin Marbella', NULL, '29069', NULL, NULL, 36.52194, -4.87685, 'address', 'openstreetmap:way/322625755'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-332372813', 'Carrefour Marbella – Calle Pintor José Caballero', NULL, '29069', 'Calle Pintor José Caballero', NULL, 36.48468, -4.97922, 'address', 'openstreetmap:way/332372813'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-390615156', 'El Corte Inglés Marbella – Bulevar del Príncipe Alfonso de Hohenlohe', NULL, '29069', 'Bulevar del Príncipe Alfonso de Hohenlohe', NULL, 36.5108, -4.90304, 'address', 'openstreetmap:way/390615156'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-392669237', 'Carrefour Torremolinos – Calle Antonio Márquez Muñoz', NULL, '29901', 'Calle Antonio Márquez Muñoz', NULL, 36.61219, -4.51313, 'address', 'openstreetmap:way/392669237'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-507043903', 'Carrefour Marbella – Avenida General López Domínguez', NULL, '29069', 'Avenida General López Domínguez', '29603', 36.5136, -4.87709, 'address', 'openstreetmap:way/507043903'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:way-607957106', 'MediaMarkt Marbella', NULL, '29069', NULL, NULL, 36.52231, -4.87788, 'address', 'openstreetmap:way/607957106'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-622458776', 'Carrefour Málaga – Avenida Principal del Candado', NULL, '29067', 'Avenida Principal del Candado 2', '29018', 36.71946, -4.35035, 'address', 'openstreetmap:way/622458776'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-633694876', 'Carrefour Málaga – Calle Saint-Exupêry', NULL, '29067', 'Calle Saint-Exupêry', NULL, 36.7156, -4.45591, 'address', 'openstreetmap:way/633694876'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:way-78609629', 'IKEA Málaga – Avenida de Velázquez', NULL, '29067', 'Avenida de Velázquez 389', '29004', 36.65777, -4.4823, 'address', 'openstreetmap:way/78609629'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-81519658', 'Carrefour Nerja – Carretera Málaga-Almería', NULL, '29075', 'Carretera Málaga-Almería', '29780', 36.75873, -3.8703, 'address', 'openstreetmap:way/81519658'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-823704912', 'Carrefour Málaga – Avenida de Velázquez', NULL, '29067', 'Avenida de Velázquez 151', '29004', 36.68623, -4.45955, 'address', 'openstreetmap:way/823704912'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-89973352', 'El Corte Inglés Marbella – Calle Ramón Areces', NULL, '29069', 'Calle Ramón Areces', NULL, 36.49073, -4.95262, 'address', 'openstreetmap:way/89973352'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-90182698', 'Carrefour Benalmádena – Calle Medina Azahara', NULL, '29025', 'Calle Medina Azahara', NULL, 36.60091, -4.53156, 'address', 'openstreetmap:way/90182698'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-967259110', 'Carrefour Benalmádena – Avenida San Rafael', NULL, '29025', 'Avenida San Rafael', NULL, 36.59721, -4.55698, 'address', 'openstreetmap:way/967259110');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '29');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 29 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '29'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 88 THEN
    RAISE EXCEPTION 'Se esperaban 88 puntos de (varias) en Málaga, hay %', n;
  END IF;
END;
$$;

COMMIT;
