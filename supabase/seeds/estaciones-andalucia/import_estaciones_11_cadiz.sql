-- Carga de la categoría Estaciones de Cádiz (provincia 11), trozo de la carga de Andalucía.
-- Origen: estaciones-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 39 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:estaciones:node-10137800757', 'Estación de tren de Río Arillo (San Fernando)', 'Tren', '11031', NULL, NULL, 36.45753, -6.22469, 'address', 'openstreetmap:node/10137800757'),
  ('catalogo-andalucia:estaciones:node-1014650979', 'Estación de tren de Universidad (Puerto Real)', 'Tren', '11028', NULL, NULL, 36.52948, -6.20598, 'address', 'openstreetmap:node/1014650979'),
  ('catalogo-andalucia:estaciones:node-1028108477', 'Estación de tren de Las Aletas (Puerto Real)', 'Tren', '11028', NULL, NULL, 36.54413, -6.19845, 'address', 'openstreetmap:node/1028108477'),
  ('catalogo-andalucia:estaciones:node-10632862335', 'Estación de tren de San Roque - La Línea', 'Tren', '11033', NULL, NULL, 36.21268, -5.43165, 'address', 'openstreetmap:node/10632862335'),
  ('catalogo-andalucia:estaciones:node-1068898380', 'Estación de tren de San Severiano (Cádiz)', 'Tren', '11012', NULL, NULL, 36.52139, -6.28062, 'address', 'openstreetmap:node/1068898380'),
  ('catalogo-andalucia:estaciones:node-10922195562', 'Estación de tren de Jerez de la Frontera', 'Tren', '11020', NULL, NULL, 36.67981, -6.1261, 'address', 'openstreetmap:node/10922195562'),
  ('catalogo-andalucia:estaciones:node-1123926567', 'Estación de tren de Jimena de la Frontera', 'Tren', '11021', NULL, NULL, 36.42426, -5.43417, 'address', 'openstreetmap:node/1123926567'),
  ('catalogo-andalucia:estaciones:node-1560751686', 'Estación de tren de Los Barrios', 'Tren', '11008', NULL, NULL, 36.17377, -5.46063, 'address', 'openstreetmap:node/1560751686'),
  ('catalogo-andalucia:estaciones:node-1567648473', 'Estación de tren de Aeropuerto de Jerez (Jerez de la Frontera)', 'Tren', '11020', NULL, NULL, 36.75123, -6.06645, 'address', 'openstreetmap:node/1567648473'),
  ('catalogo-andalucia:estaciones:node-1738646773', 'Estación de tren de El Puerto de Santa María', 'Tren', '11027', NULL, NULL, 36.6042, -6.217, 'address', 'openstreetmap:node/1738646773'),
  ('catalogo-andalucia:estaciones:node-2182333421', 'Estación de tren de Algeciras', 'Tren', '11004', NULL, NULL, 36.12664, -5.45017, 'address', 'openstreetmap:node/2182333421'),
  ('catalogo-andalucia:estaciones:node-2340360836', 'Estación de tren de San Fernando-Bahía Sur', 'Tren', '11031', NULL, NULL, 36.46792, -6.20688, 'address', 'openstreetmap:node/2340360836'),
  ('catalogo-andalucia:estaciones:node-259625422', 'Estación de tren de Cádiz', 'Tren', '11012', NULL, NULL, 36.52794, -6.28688, 'address', 'openstreetmap:node/259625422'),
  ('catalogo-andalucia:estaciones:node-260383905', 'Estación de tren de Cortadura (Cádiz)', 'Tren', '11012', NULL, NULL, 36.49436, -6.26811, 'address', 'openstreetmap:node/260383905'),
  ('catalogo-andalucia:estaciones:node-3762224319', 'Estación de tren de San Pablo (Jimena de la Frontera)', 'Tren', '11021', NULL, NULL, 36.46793, -5.41923, 'address', 'openstreetmap:node/3762224319'),
  ('catalogo-andalucia:estaciones:node-3762227970', 'Estación de tren de Setenil (Setenil de las Bodegas)', 'Tren', '11034', NULL, NULL, 36.8626, -5.12135, 'address', 'openstreetmap:node/3762227970'),
  ('catalogo-andalucia:estaciones:node-3909008955', 'Estación de tren de Almoraima (Castellar de la Frontera)', 'Tren', '11013', NULL, NULL, 36.27665, -5.42997, 'address', 'openstreetmap:node/3909008955'),
  ('catalogo-andalucia:estaciones:node-4084578570', 'Apeadero de autobuses de Puerto Serrano', 'Autobús', '11029', NULL, NULL, 36.91904, -5.54799, 'address', 'openstreetmap:node/4084578570'),
  ('catalogo-andalucia:estaciones:node-496496219', 'Estación de tren de Estadio (Cádiz)', 'Tren', '11012', NULL, NULL, 36.50292, -6.27205, 'address', 'openstreetmap:node/496496219'),
  ('catalogo-andalucia:estaciones:node-5302170172', 'Estación de tren de Segunda Aguada (Cádiz)', 'Tren', '11012', NULL, NULL, 36.5135, -6.27696, 'address', 'openstreetmap:node/5302170172'),
  ('catalogo-andalucia:estaciones:node-7768387859', 'Estación de tren de Puerto Real', 'Tren', '11028', NULL, NULL, 36.53083, -6.1853, 'address', 'openstreetmap:node/7768387859'),
  ('catalogo-andalucia:estaciones:node-7768387860', 'Estación de tren de San Fernando-Centro', 'Tren', '11031', NULL, '11100', 36.47588, -6.19402, 'address', 'openstreetmap:node/7768387860'),
  ('catalogo-andalucia:estaciones:node-7808311339', 'Estación de tren de Valdelagrana (El Puerto de Santa María)', 'Tren', '11027', NULL, NULL, 36.58471, -6.21605, 'address', 'openstreetmap:node/7808311339'),
  ('catalogo-andalucia:estaciones:node-9527680936', 'Estación de autobuses (Olvera)', 'Autobús', '11024', NULL, NULL, 36.93598, -5.25841, 'address', 'openstreetmap:node/9527680936'),
  ('catalogo-andalucia:estaciones:way-1148155453', 'Estación de Autobuses (Medina Sidonia)', 'Autobús', '11023', NULL, NULL, 36.46207, -5.93019, 'address', 'openstreetmap:way/1148155453'),
  ('catalogo-andalucia:estaciones:way-117671807', 'Estación de Autobuses Socibus (San Fernando)', 'Autobús', '11031', NULL, NULL, 36.4717, -6.18977, 'address', 'openstreetmap:way/117671807'),
  ('catalogo-andalucia:estaciones:way-1423300827', 'Intercambiador de El Puerto de Santa María – Avenida del Monasterio', 'Autobús', '11027', 'Avenida del Monasterio', NULL, 36.60437, -6.21719, 'address', 'openstreetmap:way/1423300827'),
  ('catalogo-andalucia:estaciones:way-186256109', 'Terminal de Autobuses de Tarifa', 'Autobús', '11035', NULL, '11380', 36.01912, -5.60925, 'address', 'openstreetmap:way/186256109'),
  ('catalogo-andalucia:estaciones:way-231213556', 'Estación de Autobuses de Sanlúcar de Barrameda – Avenida de Guzmán el Bueno', 'Autobús', '11032', 'Avenida de Guzmán el Bueno 4', '11540', 36.78155, -6.35844, 'address', 'openstreetmap:way/231213556'),
  ('catalogo-andalucia:estaciones:way-262788227', 'Estación de Autobuses (Jerez de la Frontera)', 'Autobús', '11020', NULL, NULL, 36.67912, -6.12646, 'address', 'openstreetmap:way/262788227'),
  ('catalogo-andalucia:estaciones:way-272017813', 'Estación de Autobuses de Arcos de la Frontera', 'Autobús', '11006', NULL, NULL, 36.74933, -5.8178, 'address', 'openstreetmap:way/272017813'),
  ('catalogo-andalucia:estaciones:way-339720669', 'Estación de Autobuses de Barbate – Plaza Reyes Católicos', 'Autobús', '11007', 'Plaza Reyes Católicos', '11160', 36.19471, -5.91806, 'address', 'openstreetmap:way/339720669'),
  ('catalogo-andalucia:estaciones:way-406389461', 'Estación de Autobuses de Villamartín – Avenida de la Feria', 'Autobús', '11041', 'Avenida de la Feria', NULL, 36.85873, -5.64738, 'address', 'openstreetmap:way/406389461'),
  ('catalogo-andalucia:estaciones:way-42896656', 'Estación de Autobuses de La Línea de La Concepción – Plaza Europa', 'Autobús', '11022', 'Plaza Europa', '11300', 36.15801, -5.34998, 'address', 'openstreetmap:way/42896656'),
  ('catalogo-andalucia:estaciones:way-475920603', 'Estación de Autobuses de Prado del Rey', 'Autobús', '11026', NULL, NULL, 36.7856, -5.55647, 'address', 'openstreetmap:way/475920603'),
  ('catalogo-andalucia:estaciones:way-588025388', 'Estación de Autobuses de Cádiz', 'Autobús', '11012', NULL, '11006', 36.52727, -6.28548, 'address', 'openstreetmap:way/588025388'),
  ('catalogo-andalucia:estaciones:way-671261151', 'Apeadero de Autobuses del Puerto de Algeciras – Apeadero de Autobuses del Puerto de Algeciras', 'Autobús', '11004', 'Apeadero de Autobuses del Puerto de Algeciras', NULL, 36.12985, -5.44124, 'address', 'openstreetmap:way/671261151'),
  ('catalogo-andalucia:estaciones:way-809572177', 'Estación de Autobuses San Bernardo (Algeciras) – Calle San Bernardo', 'Autobús', '11004', 'Calle San Bernardo 1', '11207', 36.12582, -5.44752, 'address', 'openstreetmap:way/809572177'),
  ('catalogo-andalucia:estaciones:way-810158758', 'Apeadero de Autobuses de Los Barrios – Paseo de Coca', 'Autobús', '11008', 'Paseo de Coca', '11370', 36.18319, -5.49433, 'address', 'openstreetmap:way/810158758');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '11');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 11 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '11'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 39 THEN
    RAISE EXCEPTION 'Se esperaban 39 puntos de Estaciones en Cádiz, hay %', n;
  END IF;
END;
$$;

COMMIT;
