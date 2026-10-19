-- Carga de la categoría Estaciones de Jaén (provincia 23), trozo de la carga de Andalucía.
-- Origen: estaciones-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 35 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:estaciones:node-1250300303', 'Estación de autobuses de 111 (Baeza)', 'Autobús', '23009', NULL, NULL, 37.99614, -3.45897, 'approximate', 'openstreetmap:node/1250300303'),
  ('catalogo-andalucia:estaciones:node-2366145381', 'Estación de tren de Cabra del Santo Cristo-Alicún', 'Tren', '23017', NULL, NULL, 37.65659, -3.26237, 'address', 'openstreetmap:node/2366145381'),
  ('catalogo-andalucia:estaciones:node-3631865473', 'Apeadero de autobuses (Génave)', 'Autobús', '23037', NULL, NULL, 38.43158, -2.73321, 'address', 'openstreetmap:node/3631865473'),
  ('catalogo-andalucia:estaciones:node-4668682266', 'Estación de tren de Mengíbar-Artichuela', 'Tren', '23061', NULL, NULL, 37.97788, -3.80155, 'address', 'openstreetmap:node/4668682266'),
  ('catalogo-andalucia:estaciones:node-5321126902', 'Estación de Autobuses de Bailén', 'Autobús', '23010', NULL, NULL, 38.09195, -3.77686, 'address', 'openstreetmap:node/5321126902'),
  ('catalogo-andalucia:estaciones:node-7747890825', 'Estación de tren de Jódar - Úbeda', 'Tren', '23092', NULL, NULL, 37.91347, -3.35018, 'address', 'openstreetmap:node/7747890825'),
  ('catalogo-andalucia:estaciones:node-7747890828', 'Estación de tren de Linares-Baeza', 'Tren', '23055', NULL, NULL, 38.06909, -3.58914, 'address', 'openstreetmap:node/7747890828'),
  ('catalogo-andalucia:estaciones:node-7752561497', 'Estación de tren de Espelúy', 'Tren', '23032', NULL, NULL, 38.01026, -3.83216, 'address', 'openstreetmap:node/7752561497'),
  ('catalogo-andalucia:estaciones:node-7752561504', 'Estación de tren de Jaén', 'Tren', '23050', NULL, NULL, 37.77998, -3.79079, 'address', 'openstreetmap:node/7752561504'),
  ('catalogo-andalucia:estaciones:node-7752653197', 'Estación de tren de Vilches', 'Tren', '23094', NULL, NULL, 38.21574, -3.5177, 'address', 'openstreetmap:node/7752653197'),
  ('catalogo-andalucia:estaciones:node-7752653211', 'Estación de tren de Andújar', 'Tren', '23005', NULL, NULL, 38.02797, -4.06603, 'address', 'openstreetmap:node/7752653211'),
  ('catalogo-andalucia:estaciones:way-103530147', 'Estación Autobuses (Martos)', 'Autobús', '23060', NULL, NULL, 37.71685, -3.97133, 'address', 'openstreetmap:way/103530147'),
  ('catalogo-andalucia:estaciones:way-104663691', 'Antigua Estacion Tren de Martos', 'Tren', '23060', NULL, NULL, 37.7191, -3.9793, 'address', 'openstreetmap:way/104663691'),
  ('catalogo-andalucia:estaciones:way-1074460987', 'Estación de Autobuses de Úbeda – Calle San José', 'Autobús', '23092', 'Calle San José 12', '23400', 38.01247, -3.37896, 'address', 'openstreetmap:way/1074460987'),
  ('catalogo-andalucia:estaciones:way-111453993', 'Estación de Autobuses de Baeza – Avenida Alcalde Puche Pardo', 'Autobús', '23009', 'Avenida Alcalde Puche Pardo 10', '23440', 37.99666, -3.45971, 'approximate', 'openstreetmap:way/111453993'),
  ('catalogo-andalucia:estaciones:way-122968564', 'Estación de autobuses de La Carolina (SAMAR)', 'Autobús', '23024', NULL, NULL, 38.2758, -3.61067, 'address', 'openstreetmap:way/122968564'),
  ('catalogo-andalucia:estaciones:way-1242050905', 'Apeadero de Mengíbar', 'Autobús', '23061', NULL, NULL, 37.97038, -3.80242, 'address', 'openstreetmap:way/1242050905'),
  ('catalogo-andalucia:estaciones:way-235326881', 'Apeadero de Autobuses de Torredelcampo', 'Autobús', '23086', NULL, NULL, 37.7752, -3.89305, 'address', 'openstreetmap:way/235326881'),
  ('catalogo-andalucia:estaciones:way-237977926', 'Jaén, Estación de Autobuses – Avenida de Madrid', 'Autobús', '23050', 'Avenida de Madrid', NULL, 37.77146, -3.7876, 'address', 'openstreetmap:way/237977926'),
  ('catalogo-andalucia:estaciones:way-251323239', 'Estación de Autobuses de Alcalá la Real', 'Autobús', '23002', NULL, NULL, 37.45601, -3.92218, 'address', 'openstreetmap:way/251323239'),
  ('catalogo-andalucia:estaciones:way-269782482', 'Estación de autobuses (Peal de Becerro)', 'Autobús', '23066', NULL, '23460', 37.91544, -3.121, 'address', 'openstreetmap:way/269782482'),
  ('catalogo-andalucia:estaciones:way-327851961', 'Estación de Begíjar', 'Tren', '23014', NULL, NULL, 37.95565, -3.53558, 'address', 'openstreetmap:way/327851961'),
  ('catalogo-andalucia:estaciones:way-332301658', 'Estación de Autobuses (Marmolejo)', 'Autobús', '23059', NULL, '23770', 38.04106, -4.1758, 'address', 'openstreetmap:way/332301658'),
  ('catalogo-andalucia:estaciones:way-332771987', 'Estación de Autobuses de Linares', 'Autobús', '23055', NULL, NULL, 38.09878, -3.63667, 'address', 'openstreetmap:way/332771987'),
  ('catalogo-andalucia:estaciones:way-342564766', 'Antigua Estación de Madrid (Linares) – 1', 'Tren', '23055', '1', NULL, 38.10049, -3.63138, 'address', 'openstreetmap:way/342564766'),
  ('catalogo-andalucia:estaciones:way-367129992', 'Parada de autobús (Ibros)', 'Autobús', '23046', NULL, NULL, 38.02113, -3.50397, 'approximate', 'openstreetmap:way/367129992'),
  ('catalogo-andalucia:estaciones:way-368983422', 'Estación de Autobuses (Castellar)', 'Autobús', '23025', NULL, NULL, 38.25566, -3.13262, 'address', 'openstreetmap:way/368983422'),
  ('catalogo-andalucia:estaciones:way-398912116', 'Estación de Autobuses (Andújar)', 'Autobús', '23005', NULL, NULL, 38.03954, -4.04542, 'address', 'openstreetmap:way/398912116'),
  ('catalogo-andalucia:estaciones:way-469030279', 'Antigua Estación de Almería-San José (Linares)', 'Tren', '23055', NULL, NULL, 38.09617, -3.62279, 'address', 'openstreetmap:way/469030279'),
  ('catalogo-andalucia:estaciones:way-478353043', 'Estación de Autobuses de Pozo Alcón – Calle Orcera', 'Autobús', '23070', 'Calle Orcera 11', '23485', 37.70055, -2.9355, 'address', 'openstreetmap:way/478353043'),
  ('catalogo-andalucia:estaciones:way-571447425', 'Estación de Autobuses de Torredonjimeno', 'Autobús', '23087', NULL, NULL, 37.76457, -3.94917, 'address', 'openstreetmap:way/571447425'),
  ('catalogo-andalucia:estaciones:way-592887709', 'Estación de Autobuses (Villanueva del Arzobispo)', 'Autobús', '23097', NULL, NULL, 38.1729, -3.00207, 'address', 'openstreetmap:way/592887709'),
  ('catalogo-andalucia:estaciones:way-661374374', 'Estación de Autobuses de Mancha Real – Calle Callejuelas Altas', 'Autobús', '23058', 'Calle Callejuelas Altas 4', '23100', 37.78851, -3.60887, 'address', 'openstreetmap:way/661374374'),
  ('catalogo-andalucia:estaciones:way-830421169', 'Antigua estación de Las Madrigueras (Linares)', 'Tren', '23055', NULL, NULL, 38.01993, -3.63742, 'address', 'openstreetmap:way/830421169'),
  ('catalogo-andalucia:estaciones:way-964730250', 'Antigua Estación de Tren de Torredelcampo', 'Tren', '23086', NULL, NULL, 37.77435, -3.90306, 'address', 'openstreetmap:way/964730250');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '23');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 23 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '23'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 35 THEN
    RAISE EXCEPTION 'Se esperaban 35 puntos de Estaciones en Jaén, hay %', n;
  END IF;
END;
$$;

COMMIT;
