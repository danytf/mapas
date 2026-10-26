-- Carga de la categoría Correos de Zaragoza (provincia 50), trozo de la carga de Andalucía.
-- Origen: postal_service-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 44 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-aragon:postal_service:node-10280126081', 'Correos Villanueva de Gállego – Calle de Allue Salvador', NULL, '50288', 'Calle de Allue Salvador 32', '50830', 41.76707, -0.82609, 'address', 'openstreetmap:node/10280126081'),
  ('catalogo-aragon:postal_service:node-10296829507', 'Correos Zuera – Plaza del Ayuntamiento', NULL, '50298', 'Plaza del Ayuntamiento 7', '50810', 41.93615, -0.75626, 'address', 'openstreetmap:node/10296829507'),
  ('catalogo-aragon:postal_service:node-11399894105', 'Correos Alhama de Aragón – Avenida de Aragón', NULL, '50020', 'Avenida de Aragón 37', NULL, 41.29773, -1.89333, 'address', 'openstreetmap:node/11399894105'),
  ('catalogo-aragon:postal_service:node-11492118811', 'Correos Cuarte de Huerva – Calle Miguel Servet', NULL, '50089', 'Calle Miguel Servet', NULL, 41.59148, -0.92885, 'address', 'openstreetmap:node/11492118811'),
  ('catalogo-aragon:postal_service:node-11492154815', 'Correos Muel – Avenida Garcia Gimenez', NULL, '50181', 'Avenida Garcia Gimenez', NULL, 41.46785, -1.08596, 'address', 'openstreetmap:node/11492154815'),
  ('catalogo-aragon:postal_service:node-11492155770', 'Correos María de Huerva – Avenida de Goya', NULL, '50163', 'Avenida de Goya', '50430', 41.53875, -0.99563, 'address', 'openstreetmap:node/11492155770'),
  ('catalogo-aragon:postal_service:node-11854238001', 'Correos Fayón / Faió – Plaza Mayor / Plaça Major', NULL, '50105', 'Plaza Mayor / Plaça Major 9', '50795', 41.23996, 0.33358, 'address', 'openstreetmap:node/11854238001'),
  ('catalogo-aragon:postal_service:node-12633470194', 'Correos Ainzón – Plaza Mayor', NULL, '50006', 'Plaza Mayor', NULL, 41.8169, -1.52023, 'address', 'openstreetmap:node/12633470194'),
  ('catalogo-aragon:postal_service:node-1293849351', 'Correos Maluenda – Plaza Cardenal Casanova', NULL, '50159', 'Plaza Cardenal Casanova 1', '50340', 41.28735, -1.61607, 'address', 'openstreetmap:node/1293849351'),
  ('catalogo-aragon:postal_service:node-13390306627', 'Correos Fabara / Favara – Plaza de España', NULL, '50102', 'Plaza de España 1', '50793', 41.1779, 0.16746, 'address', 'openstreetmap:node/13390306627'),
  ('catalogo-aragon:postal_service:node-1416741339', 'Correos Pastriz – La Portalada', NULL, '50203', 'La Portalada 8', '50195', 41.61916, -0.78368, 'address', 'openstreetmap:node/1416741339'),
  ('catalogo-aragon:postal_service:node-1474617710', 'Correos Pedrola – Calle de la Duquesa de Villahermosa', NULL, '50204', 'Calle de la Duquesa de Villahermosa 6', '50690', 41.79049, -1.21411, 'address', 'openstreetmap:node/1474617710'),
  ('catalogo-aragon:postal_service:node-1484641654', 'Correos Utebo – Calle Buenos Aires', NULL, '50272', 'Calle Buenos Aires 20', '50180', 41.70537, -1.00143, 'address', 'openstreetmap:node/1484641654'),
  ('catalogo-aragon:postal_service:node-1797598349', 'Correos Zaragoza – Avenida de Navarra', NULL, '50297', 'Avenida de Navarra 180', '50017', 41.65932, -0.92082, 'address', 'openstreetmap:node/1797598349'),
  ('catalogo-aragon:postal_service:node-1797598351', 'Correos Zaragoza – Calle de El Globo', NULL, '50297', 'Calle de El Globo 3', '50015', 41.68357, -0.87149, 'address', 'openstreetmap:node/1797598351'),
  ('catalogo-aragon:postal_service:node-1797598354', 'Correos Zaragoza – Calle de Federico García Lorca', NULL, '50297', 'Calle de Federico García Lorca 7', '50007', 41.63503, -0.87885, 'address', 'openstreetmap:node/1797598354'),
  ('catalogo-aragon:postal_service:node-1797598356', 'Correos Zaragoza – Paseo de Fernando el Católico', NULL, '50297', 'Paseo de Fernando el Católico 57', '50006', 41.63885, -0.89641, 'address', 'openstreetmap:node/1797598356'),
  ('catalogo-aragon:postal_service:node-1797598358', 'Correos Zaragoza – Calle de Florentino Vallesteros 10-12-14', NULL, '50297', 'Calle de Florentino Vallesteros 10-12-14', '50013', 41.64451, -0.86815, 'address', 'openstreetmap:node/1797598358'),
  ('catalogo-aragon:postal_service:node-1797598361', 'Correos Zaragoza – Calle de Fray Julián Garcés', NULL, '50297', 'Calle de Fray Julián Garcés 19', '50007', 41.63094, -0.88636, 'address', 'openstreetmap:node/1797598361'),
  ('catalogo-aragon:postal_service:node-1797598365', 'Correos Zaragoza – Calle de José Oto', NULL, '50297', 'Calle de José Oto', '50014', 41.66259, -0.86193, 'address', 'openstreetmap:node/1797598365'),
  ('catalogo-aragon:postal_service:node-1797598370', 'Correos Zaragoza – Paseo de María Agustín', NULL, '50297', 'Paseo de María Agustín 113', '50004', 41.65863, -0.89338, 'address', 'openstreetmap:node/1797598370'),
  ('catalogo-aragon:postal_service:node-1797598375', 'Correos Zaragoza – Calle Poetisa María Zambrano', NULL, '50297', 'Calle Poetisa María Zambrano 35', '50018', 41.67142, -0.88999, 'address', 'openstreetmap:node/1797598375'),
  ('catalogo-aragon:postal_service:node-1797598377', 'Correos Zaragoza – Avenida de Real Zaragoza', NULL, '50297', 'Avenida de Real Zaragoza 2', '50016', 41.66596, -0.82437, 'address', 'openstreetmap:node/1797598377'),
  ('catalogo-aragon:postal_service:node-1797598381', 'Correos Zaragoza – Vía Hispanidad', NULL, '50297', 'Vía Hispanidad 100', '50010', 41.64866, -0.9177, 'address', 'openstreetmap:node/1797598381'),
  ('catalogo-aragon:postal_service:node-1877430096', 'Correos Alagón – Calle D. José Chacón', NULL, '50008', 'Calle D. José Chacón', '50630', 41.77029, -1.11999, 'address', 'openstreetmap:node/1877430096'),
  ('catalogo-aragon:postal_service:node-2389286015', 'Correos Caspe – Avenida Joaquín Costa', NULL, '50074', 'Avenida Joaquín Costa 8', '50700', 41.23421, -0.04414, 'address', 'openstreetmap:node/2389286015'),
  ('catalogo-aragon:postal_service:node-2419623896', 'Correos Zuera – Calle Conserans', NULL, '50298', 'Calle Conserans', '50800', 41.8671, -0.78656, 'address', 'openstreetmap:node/2419623896'),
  ('catalogo-aragon:postal_service:node-2538388647', 'Correos Zaragoza – Calle del Arco', NULL, '50297', 'Calle del Arco 8', '50120', 41.70189, -0.96894, 'address', 'openstreetmap:node/2538388647'),
  ('catalogo-aragon:postal_service:node-4350331530', 'Correos La Puebla de Alfindén – Calle de Fernando Moliné', NULL, '50219', 'Calle de Fernando Moliné 5', '50171', 41.63064, -0.75055, 'address', 'openstreetmap:node/4350331530'),
  ('catalogo-aragon:postal_service:node-4481404604', 'Correos Zaragoza – Calle Madre Teresa de Calcuta', NULL, '50297', 'Calle Madre Teresa de Calcuta 1', '50009', 41.64423, -0.9112, 'address', 'openstreetmap:node/4481404604'),
  ('catalogo-aragon:postal_service:node-4512766479', 'Correos Alfajarín – Calle Nuestra Señora del Pilar', NULL, '50017', 'Calle Nuestra Señora del Pilar 2', NULL, 41.61476, -0.70294, 'address', 'openstreetmap:node/4512766479'),
  ('catalogo-aragon:postal_service:node-4906804568', 'Correos Pina de Ebro – Calle Barrio Nuevo', NULL, '50208', 'Calle Barrio Nuevo', NULL, 41.48692, -0.531, 'address', 'openstreetmap:node/4906804568'),
  ('catalogo-aragon:postal_service:node-4911669883', 'Correos Gallur – Avenida Pignatelli', NULL, '50118', 'Avenida Pignatelli', NULL, 41.86841, -1.31596, 'address', 'openstreetmap:node/4911669883'),
  ('catalogo-aragon:postal_service:node-5005855014', 'Correos Daroca – Calle San Martín de la Parra', NULL, '50094', 'Calle San Martín de la Parra', NULL, 41.11302, -1.4168, 'address', 'openstreetmap:node/5005855014'),
  ('catalogo-aragon:postal_service:node-5343882527', 'Correos Mallén – Calle Tudela', NULL, '50160', 'Calle Tudela', '50550', 41.90094, -1.42003, 'address', 'openstreetmap:node/5343882527'),
  ('catalogo-aragon:postal_service:node-5355130570', 'Correos Monegrillo – Calle San Benito', NULL, '50170', 'Calle San Benito', NULL, 41.64032, -0.41752, 'address', 'openstreetmap:node/5355130570'),
  ('catalogo-aragon:postal_service:node-5857023088', 'Correos Zaragoza – Paseo Antonio Negre García', NULL, '50297', 'Paseo Antonio Negre García 26', '50820', 41.71875, -0.84223, 'address', 'openstreetmap:node/5857023088'),
  ('catalogo-aragon:postal_service:node-680050532', 'Correos Zaragoza – Paseo de la Independencia', NULL, '50297', 'Paseo de la Independencia 35', '50004', 41.64919, -0.88351, 'address', 'openstreetmap:node/680050532'),
  ('catalogo-aragon:postal_service:node-7046683349', 'Correos Sos del Rey Católico – Calle Emilio Alfaro', NULL, '50248', 'Calle Emilio Alfaro 3', '50680', 42.49486, -1.21601, 'address', 'openstreetmap:node/7046683349'),
  ('catalogo-aragon:postal_service:node-7651163529', 'Correos Zaragoza – Paseo de Los Olvidados', NULL, '50297', 'Paseo de Los Olvidados 49', '50019', 41.6186, -0.92244, 'address', 'openstreetmap:node/7651163529'),
  ('catalogo-aragon:postal_service:node-8852632479', 'Correos Escatrón – Calle Sastago', NULL, '50101', 'Calle Sastago', NULL, 41.28903, -0.32287, 'address', 'openstreetmap:node/8852632479'),
  ('catalogo-aragon:postal_service:node-8861181428', 'Correos Gelsa – Calle de la Barca', NULL, '50119', 'Calle de la Barca', '50786', 41.40561, -0.46285, 'address', 'openstreetmap:node/8861181428'),
  ('catalogo-aragon:postal_service:node-9630147282', 'Correos Piedratajada – Calle de la Balsa', NULL, '50207', 'Calle de la Balsa 1', NULL, 42.11997, -0.80554, 'address', 'openstreetmap:node/9630147282'),
  ('catalogo-aragon:postal_service:way-147489585', 'Correos Zaragoza – Calle Escritor Gabriel García Márquez', NULL, '50297', 'Calle Escritor Gabriel García Márquez 4', '50018', 41.67307, -0.89408, 'address', 'openstreetmap:way/147489585');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '50');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 50 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '50'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 44 THEN
    RAISE EXCEPTION 'Se esperaban 44 puntos de Correos en Zaragoza, hay %', n;
  END IF;
END;
$$;

COMMIT;
