-- Carga de la categoría Estaciones de Málaga (provincia 29), trozo de la carga de Andalucía.
-- Origen: estaciones-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 48 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:estaciones:node-11135074555', 'Estación de tren de Antequera Alta Velocidad', 'Tren', '29015', NULL, NULL, 37.02948, -4.56137, 'address', 'openstreetmap:node/11135074555'),
  ('catalogo-andalucia:estaciones:node-11302447703', 'Estación de tren de Málaga Centro Alameda', 'Tren', '29067', NULL, NULL, 36.7154, -4.42656, 'address', 'openstreetmap:node/11302447703'),
  ('catalogo-andalucia:estaciones:node-11715993300', 'Estación de tren de Plaza Mayor (Málaga)', 'Tren', '29067', NULL, NULL, 36.65622, -4.48033, 'address', 'openstreetmap:node/11715993300'),
  ('catalogo-andalucia:estaciones:node-2379193791', 'Estación de tren de Benalmadena - Arroyo de la Miel', 'Tren', '29025', NULL, NULL, 36.59906, -4.53662, 'address', 'openstreetmap:node/2379193791'),
  ('catalogo-andalucia:estaciones:node-258980884', 'Estación de tren de Los Boliches (Fuengirola)', 'Tren', '29054', NULL, NULL, 36.55463, -4.61459, 'address', 'openstreetmap:node/258980884'),
  ('catalogo-andalucia:estaciones:node-258983214', 'Estación de tren de Fuengirola', 'Tren', '29054', NULL, NULL, 36.54181, -4.62398, 'address', 'openstreetmap:node/258983214'),
  ('catalogo-andalucia:estaciones:node-259008737', 'Estación de tren de Montemar Alto (Torremolinos)', 'Tren', '29901', NULL, NULL, 36.6137, -4.50935, 'address', 'openstreetmap:node/259008737'),
  ('catalogo-andalucia:estaciones:node-259009677', 'Estación de tren de La Colina (Torremolinos)', 'Tren', '29901', NULL, NULL, 36.64216, -4.49237, 'address', 'openstreetmap:node/259009677'),
  ('catalogo-andalucia:estaciones:node-259009686', 'Estación de tren de Los Álamos (Torremolinos)', 'Tren', '29901', NULL, NULL, 36.64475, -4.4855, 'address', 'openstreetmap:node/259009686'),
  ('catalogo-andalucia:estaciones:node-2609534280', 'Estación de tren de Málaga María Zambrano – Calle Explanada de la Estación', 'Tren', '29067', 'Calle Explanada de la Estación 1', '29002', 36.71162, -4.43236, 'address', 'openstreetmap:node/2609534280'),
  ('catalogo-andalucia:estaciones:node-2611833480', 'Estación de tren de Carvajal (Fuengirola)', 'Tren', '29054', NULL, NULL, 36.57037, -4.59388, 'address', 'openstreetmap:node/2611833480'),
  ('catalogo-andalucia:estaciones:node-2611857647', 'Estación de tren de Guadalhorce (Málaga)', 'Tren', '29067', NULL, NULL, 36.69258, -4.48311, 'address', 'openstreetmap:node/2611857647'),
  ('catalogo-andalucia:estaciones:node-2624608403', 'Estación de tren de Campillos', 'Tren', '29032', NULL, NULL, 37.03203, -4.8635, 'address', 'openstreetmap:node/2624608403'),
  ('catalogo-andalucia:estaciones:node-2961672592', 'Estación de tren de Gaucin (Cortes de la Frontera)', 'Tren', '29046', NULL, NULL, 36.54024, -5.38682, 'address', 'openstreetmap:node/2961672592'),
  ('catalogo-andalucia:estaciones:node-3084348890', 'Bus (Cañete la Real)', 'Autobús', '29035', NULL, NULL, 36.95037, -5.02226, 'approximate', 'openstreetmap:node/3084348890'),
  ('catalogo-andalucia:estaciones:node-3321848202', 'Estación de tren de Las Mellizas (Álora)', 'Tren', '29012', NULL, NULL, 36.87322, -4.7192, 'address', 'openstreetmap:node/3321848202'),
  ('catalogo-andalucia:estaciones:node-3762214740', 'Estación de tren de Arriate', 'Tren', '29020', NULL, NULL, 36.79095, -5.14057, 'address', 'openstreetmap:node/3762214740'),
  ('catalogo-andalucia:estaciones:node-3762221430', 'Estación de tren de Benaojan-Montejaque', 'Tren', '29028', NULL, NULL, 36.71371, -5.24614, 'address', 'openstreetmap:node/3762221430'),
  ('catalogo-andalucia:estaciones:node-4060435925', 'Estación de tren de Victoria Kent (Málaga)', 'Tren', '29067', NULL, NULL, 36.7009, -4.45505, 'address', 'openstreetmap:node/4060435925'),
  ('catalogo-andalucia:estaciones:node-4343762070', 'Estación de tren de Aeropuerto (Málaga)', 'Tren', '29067', NULL, NULL, 36.67775, -4.49016, 'address', 'openstreetmap:node/4343762070'),
  ('catalogo-andalucia:estaciones:node-6535024547', 'Estación de tren de Campanillas (Málaga)', 'Tren', '29067', NULL, NULL, 36.70509, -4.54554, 'address', 'openstreetmap:node/6535024547'),
  ('catalogo-andalucia:estaciones:node-704793025', 'Estación de autobuses de Tolox', 'Autobús', '29090', NULL, NULL, 36.68592, -4.90396, 'address', 'openstreetmap:node/704793025'),
  ('catalogo-andalucia:estaciones:node-739420193', 'Estación de tren de El Pinillo (Torremolinos)', 'Tren', '29901', NULL, NULL, 36.60989, -4.51544, 'address', 'openstreetmap:node/739420193'),
  ('catalogo-andalucia:estaciones:node-739420234', 'Estación de tren de Torremuelle (Benalmádena)', 'Tren', '29025', NULL, NULL, 36.5823, -4.56708, 'address', 'openstreetmap:node/739420234'),
  ('catalogo-andalucia:estaciones:node-739420235', 'Estación de tren de Torreblanca (Fuengirola)', 'Tren', '29054', NULL, NULL, 36.56497, -4.60657, 'address', 'openstreetmap:node/739420235'),
  ('catalogo-andalucia:estaciones:node-7557413126', 'Estación de tren de Antequera-Santa Ana', 'Tren', '29015', NULL, NULL, 37.07017, -4.71971, 'address', 'openstreetmap:node/7557413126'),
  ('catalogo-andalucia:estaciones:node-7567516128', 'Estación de tren de Los Prados (Málaga)', 'Tren', '29067', NULL, NULL, 36.69852, -4.47831, 'address', 'openstreetmap:node/7567516128'),
  ('catalogo-andalucia:estaciones:node-7567516148', 'Estación de tren de Cártama', 'Tren', '29038', NULL, NULL, 36.73386, -4.60857, 'address', 'openstreetmap:node/7567516148'),
  ('catalogo-andalucia:estaciones:node-7567516153', 'Estación de tren de Aljaima (Cártama)', 'Tren', '29038', NULL, NULL, 36.7329, -4.66477, 'address', 'openstreetmap:node/7567516153'),
  ('catalogo-andalucia:estaciones:node-7567516180', 'Estación de tren de Álora', 'Tren', '29012', NULL, NULL, 36.81971, -4.6994, 'address', 'openstreetmap:node/7567516180'),
  ('catalogo-andalucia:estaciones:node-7567538139', 'Estación de tren de El Chorro-Caminito del Rey (Álora)', 'Tren', '29012', NULL, NULL, 36.90707, -4.75913, 'address', 'openstreetmap:node/7567538139'),
  ('catalogo-andalucia:estaciones:node-7567538143', 'Estación de tren de Bobadilla (Antequera)', 'Tren', '29015', NULL, NULL, 37.03764, -4.72798, 'address', 'openstreetmap:node/7567538143'),
  ('catalogo-andalucia:estaciones:node-7567538144', 'Estación de tren de Fuente de Piedra', 'Tren', '29055', NULL, NULL, 37.13526, -4.73814, 'address', 'openstreetmap:node/7567538144'),
  ('catalogo-andalucia:estaciones:node-8019118067', 'Estación de tren de Ronda', 'Tren', '29084', NULL, NULL, 36.74859, -5.16197, 'address', 'openstreetmap:node/8019118067'),
  ('catalogo-andalucia:estaciones:node-8019139481', 'Estación de tren de Almargen - Cañete la Real', 'Tren', '29010', NULL, NULL, 37.00094, -5.01989, 'address', 'openstreetmap:node/8019139481'),
  ('catalogo-andalucia:estaciones:node-8022681349', 'Estación de tren de Cortes de la Frontera', 'Tren', '29046', NULL, NULL, 36.59738, -5.33263, 'address', 'openstreetmap:node/8022681349'),
  ('catalogo-andalucia:estaciones:node-8022687352', 'Estación de tren de Jimera de Líbar', 'Tren', '29063', NULL, NULL, 36.66064, -5.28134, 'address', 'openstreetmap:node/8022687352'),
  ('catalogo-andalucia:estaciones:node-895881917', 'Estación de tren de Pizarra', 'Tren', '29080', NULL, NULL, 36.76432, -4.712, 'address', 'openstreetmap:node/895881917'),
  ('catalogo-andalucia:estaciones:way-1171257339', 'Estación de tren de Torremolinos', 'Tren', '29901', NULL, NULL, 36.62272, -4.49929, 'address', 'openstreetmap:way/1171257339'),
  ('catalogo-andalucia:estaciones:way-126303874', 'Estación de autobuses de Marbella', 'Autobús', '29069', NULL, NULL, 36.5199, -4.89252, 'address', 'openstreetmap:way/126303874'),
  ('catalogo-andalucia:estaciones:way-1528868467', 'Estación de Autobuses de Antequera', 'Autobús', '29015', NULL, NULL, 37.0236, -4.56275, 'address', 'openstreetmap:way/1528868467'),
  ('catalogo-andalucia:estaciones:way-191593474', 'Estación de Autobuses de Ronda – Calle José María Castelló Madrid', 'Autobús', '29084', 'Calle José María Castelló Madrid', '29400', 36.74683, -5.16573, 'address', 'openstreetmap:way/191593474'),
  ('catalogo-andalucia:estaciones:way-264264382', 'Estación de Autobuses (Alhaurín el Grande)', 'Autobús', '29008', NULL, NULL, 36.64545, -4.68473, 'address', 'openstreetmap:way/264264382'),
  ('catalogo-andalucia:estaciones:way-396042474', 'Estación de Torre del Mar (Vélez-Málaga)', 'Autobús', '29094', NULL, NULL, 36.74035, -4.09895, 'address', 'openstreetmap:way/396042474'),
  ('catalogo-andalucia:estaciones:way-404948946', 'Estación de autobuses de Vélez-Málaga', 'Autobús', '29094', NULL, NULL, 36.78147, -4.1099, 'address', 'openstreetmap:way/404948946'),
  ('catalogo-andalucia:estaciones:way-530813709', 'Estación de Autobuses Estepona', 'Autobús', '29051', NULL, NULL, 36.43037, -5.1276, 'address', 'openstreetmap:way/530813709'),
  ('catalogo-andalucia:estaciones:way-556762623', 'Estación de Autobuses de Málaga – Paseo de los Tilos', 'Autobús', '29067', 'Paseo de los Tilos 17', '29002', 36.71277, -4.43385, 'address', 'openstreetmap:way/556762623'),
  ('catalogo-andalucia:estaciones:way-561050247', 'Estación de Muelle Heredia (Málaga)', 'Autobús', '29067', NULL, NULL, 36.71603, -4.42103, 'address', 'openstreetmap:way/561050247');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 48 THEN
    RAISE EXCEPTION 'Se esperaban 48 puntos de Estaciones en Málaga, hay %', n;
  END IF;
END;
$$;

COMMIT;
