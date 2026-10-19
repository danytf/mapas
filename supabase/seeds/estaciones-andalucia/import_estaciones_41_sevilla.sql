-- Carga de la categoría Estaciones de Sevilla (provincia 41), trozo de la carga de Andalucía.
-- Origen: estaciones-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 54 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:estaciones:node-11463615487', 'Estación de tren de Guadaíra (Sevilla)', 'Tren', '41091', NULL, NULL, 37.35819, -5.94729, 'address', 'openstreetmap:node/11463615487'),
  ('catalogo-andalucia:estaciones:node-1336831385', 'Estación de tren de Benacazón', 'Tren', '41015', NULL, NULL, 37.35711, -6.20799, 'address', 'openstreetmap:node/1336831385'),
  ('catalogo-andalucia:estaciones:node-1403430108', 'Estación de tren de Salteras', 'Tren', '41085', NULL, NULL, 37.41029, -6.09897, 'address', 'openstreetmap:node/1403430108'),
  ('catalogo-andalucia:estaciones:node-191262271', 'Estación de tren de Sevilla - Santa Justa', 'Tren', '41091', NULL, NULL, 37.39209, -5.97521, 'address', 'openstreetmap:node/191262271'),
  ('catalogo-andalucia:estaciones:node-2665829119', 'Estación de tren de Cantaelgallo (Dos Hermanas)', 'Tren', '41038', NULL, NULL, 37.27849, -5.91066, 'address', 'openstreetmap:node/2665829119'),
  ('catalogo-andalucia:estaciones:node-2665900431', 'Estación de tren de Cartuja (Sevilla)', 'Tren', '41091', NULL, NULL, 37.40724, -6.01012, 'address', 'openstreetmap:node/2665900431'),
  ('catalogo-andalucia:estaciones:node-5766641757', 'Intercambiador de Chapina (Sevilla)', 'Autobús', '41091', NULL, NULL, 37.39047, -6.00939, 'address', 'openstreetmap:node/5766641757'),
  ('catalogo-andalucia:estaciones:node-6343794072', 'Estación de Autobuses Sevilla - Plaza de Armas', 'Autobús', '41091', NULL, NULL, 37.39123, -6.00395, 'address', 'openstreetmap:node/6343794072'),
  ('catalogo-andalucia:estaciones:node-7564287755', 'Estación de tren de Casariche', 'Tren', '41026', NULL, NULL, 37.29458, -4.76421, 'address', 'openstreetmap:node/7564287755'),
  ('catalogo-andalucia:estaciones:node-7567538146', 'Estación de tren de La Roda de Andalucía', 'Tren', '41082', NULL, NULL, 37.20785, -4.77491, 'address', 'openstreetmap:node/7567538146'),
  ('catalogo-andalucia:estaciones:node-7758141421', 'Estación de tren de Dos Hermanas', 'Tren', '41038', NULL, NULL, 37.28722, -5.92332, 'address', 'openstreetmap:node/7758141421'),
  ('catalogo-andalucia:estaciones:node-7758141440', 'Estación de tren de Los Rosales (Tocina)', 'Tren', '41092', NULL, NULL, 37.59012, -5.727, 'address', 'openstreetmap:node/7758141440'),
  ('catalogo-andalucia:estaciones:node-7758175190', 'Estación de tren de Guadajoz (Carmona)', 'Tren', '41024', NULL, NULL, 37.58156, -5.66983, 'address', 'openstreetmap:node/7758175190'),
  ('catalogo-andalucia:estaciones:node-7758175205', 'Estación de tren de Peñaflor', 'Tren', '41074', NULL, NULL, 37.70737, -5.3408, 'address', 'openstreetmap:node/7758175205'),
  ('catalogo-andalucia:estaciones:node-7758175206', 'Estación de tren de Lora del Río', 'Tren', '41055', NULL, NULL, 37.66129, -5.53108, 'address', 'openstreetmap:node/7758175206'),
  ('catalogo-andalucia:estaciones:node-7763424277', 'Estación de tren de Jardines de Hércules (Sevilla)', 'Tren', '41091', NULL, NULL, 37.33292, -5.964, 'address', 'openstreetmap:node/7763424277'),
  ('catalogo-andalucia:estaciones:node-7763424278', 'Estación de tren de Virgen del Rocío (Sevilla)', 'Tren', '41091', NULL, NULL, 37.36281, -5.97582, 'address', 'openstreetmap:node/7763424278'),
  ('catalogo-andalucia:estaciones:node-7763424280', 'Estación de tren de San Bernardo (Sevilla)', 'Tren', '41091', NULL, NULL, 37.37766, -5.97954, 'address', 'openstreetmap:node/7763424280'),
  ('catalogo-andalucia:estaciones:node-7763430693', 'Estación de tren de La Rinconada', 'Tren', '41081', NULL, NULL, 37.47994, -5.9399, 'address', 'openstreetmap:node/7763430693'),
  ('catalogo-andalucia:estaciones:node-7763430694', 'Estación de tren de El Cáñamo (La Rinconada)', 'Tren', '41081', NULL, NULL, 37.48631, -5.9329, 'address', 'openstreetmap:node/7763430694'),
  ('catalogo-andalucia:estaciones:node-7763430695', 'Estación de tren de Brenes', 'Tren', '41018', NULL, NULL, 37.5461, -5.86677, 'address', 'openstreetmap:node/7763430695'),
  ('catalogo-andalucia:estaciones:node-7763430699', 'Estación de tren de Cantillana', 'Tren', '41023', NULL, NULL, 37.57474, -5.80325, 'address', 'openstreetmap:node/7763430699'),
  ('catalogo-andalucia:estaciones:node-7768387808', 'Estación de tren de Lebrija', 'Tren', '41053', NULL, NULL, 36.91154, -6.0952, 'address', 'openstreetmap:node/7768387808'),
  ('catalogo-andalucia:estaciones:node-7768401196', 'Estación de tren de Utrera', 'Tren', '41095', NULL, NULL, 37.18334, -5.79024, 'address', 'openstreetmap:node/7768401196'),
  ('catalogo-andalucia:estaciones:node-7776575278', 'Estación de tren de Estadio Olímpico (Santiponce)', 'Tren', '41089', NULL, NULL, 37.41728, -6.00751, 'address', 'openstreetmap:node/7776575278'),
  ('catalogo-andalucia:estaciones:node-7776575287', 'Estación de tren de Padre Pío-Palmete (Sevilla)', 'Tren', '41091', NULL, NULL, 37.37082, -5.93933, 'address', 'openstreetmap:node/7776575287'),
  ('catalogo-andalucia:estaciones:node-7776575291', 'Estación de tren de Palacio de Congresos (Sevilla)', 'Tren', '41091', NULL, NULL, 37.40368, -5.9364, 'address', 'openstreetmap:node/7776575291'),
  ('catalogo-andalucia:estaciones:node-7779095181', 'Estación de tren de Carrión de los Céspedes', 'Tren', '41025', NULL, NULL, 37.36889, -6.33517, 'address', 'openstreetmap:node/7779095181'),
  ('catalogo-andalucia:estaciones:node-7779139705', 'Estación de tren de Villanueva del Ariscal y Olivares', 'Tren', '41098', NULL, NULL, 37.40722, -6.14829, 'address', 'openstreetmap:node/7779139705'),
  ('catalogo-andalucia:estaciones:node-7779139742', 'Estación de tren de Sanlúcar la Mayor', 'Tren', '41087', NULL, NULL, 37.38147, -6.19374, 'address', 'openstreetmap:node/7779139742'),
  ('catalogo-andalucia:estaciones:node-7779139751', 'Estación de tren de Camas (Valencina de la Concepción)', 'Tren', '41096', NULL, NULL, 37.41795, -6.04078, 'address', 'openstreetmap:node/7779139751'),
  ('catalogo-andalucia:estaciones:node-7779139780', 'Estación de tren de San Jerónimo (Sevilla)', 'Tren', '41091', NULL, NULL, 37.43377, -5.98145, 'address', 'openstreetmap:node/7779139780'),
  ('catalogo-andalucia:estaciones:node-7779148773', 'Estación de tren de Valencina-Santiponce (Valencina de la Concepción)', 'Tren', '41096', NULL, NULL, 37.42666, -6.05688, 'address', 'openstreetmap:node/7779148773'),
  ('catalogo-andalucia:estaciones:node-7782117948', 'Estación de tren de Bellavista (Dos Hermanas)', 'Tren', '41038', NULL, NULL, 37.32152, -5.96423, 'address', 'openstreetmap:node/7782117948'),
  ('catalogo-andalucia:estaciones:node-7785762760', 'Estación de tren de Tocina', 'Tren', '41092', NULL, NULL, 37.60913, -5.73153, 'address', 'openstreetmap:node/7785762760'),
  ('catalogo-andalucia:estaciones:node-7785762784', 'Estación de tren de Alcolea del Río (Villanueva del Río y Minas)', 'Tren', '41099', NULL, NULL, 37.63547, -5.73101, 'address', 'openstreetmap:node/7785762784'),
  ('catalogo-andalucia:estaciones:node-7785762810', 'Estación de tren de Villanueva del Río y Minas', 'Tren', '41099', NULL, NULL, 37.66167, -5.71195, 'address', 'openstreetmap:node/7785762810'),
  ('catalogo-andalucia:estaciones:node-7785762816', 'Estación de tren de Pedroso (El Pedroso)', 'Tren', '41073', NULL, NULL, 37.83731, -5.76242, 'address', 'openstreetmap:node/7785762816'),
  ('catalogo-andalucia:estaciones:node-7785762820', 'Estación de tren de Cazalla - Constantina (Cazalla de la Sierra)', 'Tren', '41032', NULL, NULL, 37.9327, -5.70425, 'address', 'openstreetmap:node/7785762820'),
  ('catalogo-andalucia:estaciones:node-7785762853', 'Estación de tren de Guadalcanal', 'Tren', '41048', NULL, NULL, 38.09038, -5.80333, 'address', 'openstreetmap:node/7785762853'),
  ('catalogo-andalucia:estaciones:node-8048215376', 'Estación de tren de Pedrera', 'Tren', '41072', NULL, NULL, 37.22227, -4.89364, 'address', 'openstreetmap:node/8048215376'),
  ('catalogo-andalucia:estaciones:node-8048215384', 'Estación de tren de Osuna', 'Tren', '41068', NULL, NULL, 37.23371, -5.11497, 'address', 'openstreetmap:node/8048215384'),
  ('catalogo-andalucia:estaciones:node-8048235405', 'Estación de tren de Marchena', 'Tren', '41060', NULL, NULL, 37.33434, -5.4255, 'address', 'openstreetmap:node/8048235405'),
  ('catalogo-andalucia:estaciones:node-8048235459', 'Estación de tren de Arahal', 'Tren', '41011', NULL, NULL, 37.26822, -5.54846, 'address', 'openstreetmap:node/8048235459'),
  ('catalogo-andalucia:estaciones:node-8622716587', 'Estación de autobuses de Torneo (Puerta de San Juan) (Sevilla)', 'Autobús', '41091', NULL, NULL, 37.40063, -5.99877, 'address', 'openstreetmap:node/8622716587'),
  ('catalogo-andalucia:estaciones:node-8622716588', 'Estación de autobuses de Torneo (Barqueta) (Sevilla)', 'Autobús', '41091', NULL, NULL, 37.40299, -5.99645, 'address', 'openstreetmap:node/8622716588'),
  ('catalogo-andalucia:estaciones:node-919627525', 'Estación de tren de Las Cabezas de San Juan', 'Tren', '41020', NULL, NULL, 37.01852, -5.94569, 'address', 'openstreetmap:node/919627525'),
  ('catalogo-andalucia:estaciones:way-100114944', 'Estación de Autobuses de Utrera', 'Autobús', '41095', NULL, NULL, 37.17972, -5.78746, 'address', 'openstreetmap:way/100114944'),
  ('catalogo-andalucia:estaciones:way-1444331800', 'Apeadero de Autobuses (Camas)', 'Autobús', '41021', NULL, NULL, 37.40046, -6.03686, 'address', 'openstreetmap:way/1444331800'),
  ('catalogo-andalucia:estaciones:way-158199304', 'Apeadero de Autobuses de Arahal', 'Autobús', '41011', NULL, NULL, 37.25911, -5.54201, 'address', 'openstreetmap:way/158199304'),
  ('catalogo-andalucia:estaciones:way-248643971', 'Estación de Autobuses (Écija)', 'Autobús', '41039', NULL, NULL, 37.53442, -5.0767, 'address', 'openstreetmap:way/248643971'),
  ('catalogo-andalucia:estaciones:way-256685577', 'Estación de Autobuses de Osuna', 'Autobús', '41068', NULL, NULL, 37.23365, -5.09796, 'address', 'openstreetmap:way/256685577'),
  ('catalogo-andalucia:estaciones:way-506134419', 'Estación de autobuses (Morón de la Frontera) – Calle Bergantín', 'Autobús', '41065', 'Calle Bergantín', NULL, 37.1271, -5.45403, 'address', 'openstreetmap:way/506134419'),
  ('catalogo-andalucia:estaciones:way-70081023', 'Estación de Autobuses Prado de San Sebastián (Sevilla)', 'Autobús', '41091', NULL, NULL, 37.38125, -5.98545, 'address', 'openstreetmap:way/70081023');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '41');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 41 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '41'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 54 THEN
    RAISE EXCEPTION 'Se esperaban 54 puntos de Estaciones en Sevilla, hay %', n;
  END IF;
END;
$$;

COMMIT;
