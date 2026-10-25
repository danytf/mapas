-- Carga de la categoría (varias) de Melilla (provincia 52), trozo de la carga de Andalucía.
-- Origen: melilla-resto-melilla.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 18 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Supermercado', 'catalogo-melilla:melilla-resto:node-12717171439', 'Aldi Melilla – Calle General Polavieja', NULL, '52001', 'Calle General Polavieja', '52006', 35.28594, -2.94237, 'address', 'openstreetmap:node/12717171439'),
  ('Supermercado', 'catalogo-melilla:melilla-resto:node-3092125735', 'Suma Melilla – Calle General Pintos', NULL, '52001', 'Calle General Pintos', NULL, 35.28997, -2.9474, 'address', 'openstreetmap:node/3092125735'),
  ('Supermercado', 'catalogo-melilla:melilla-resto:node-3092337348', 'La Fuente Melilla – Calle Teniente Coronel Avellaneda', NULL, '52001', 'Calle Teniente Coronel Avellaneda 7', NULL, 35.29292, -2.94717, 'address', 'openstreetmap:node/3092337348'),
  ('Supermercado', 'catalogo-melilla:melilla-resto:node-3092340081', 'Al Día Melilla – Calle Teniente Coronel Avellaneda', NULL, '52001', 'Calle Teniente Coronel Avellaneda 10', NULL, 35.29282, -2.94665, 'address', 'openstreetmap:node/3092340081'),
  ('Gimnasios', 'catalogo-melilla:melilla-resto:node-4449930893', 'Centro Yoga Land Melilla – Antigua Ctra Aerouerto', NULL, '52001', 'Antigua Ctra Aerouerto 15', '52005', 35.27903, -2.95128, 'address', 'openstreetmap:node/4449930893'),
  ('Centro comercial', 'catalogo-melilla:melilla-resto:node-5257525120', 'Parque Murias Melilla – Carretera Cuartel de Valenzuela', NULL, '52001', 'Carretera Cuartel de Valenzuela', NULL, 35.27094, -2.93821, 'address', 'openstreetmap:node/5257525120'),
  ('Centro de salud', 'catalogo-melilla:melilla-resto:node-5490877672', 'Centro de Salud Polaviaja Zona Este Melilla – Calle Álvaro de Bazán', NULL, '52001', 'Calle Álvaro de Bazán', '52006', 35.28281, -2.94129, 'address', 'openstreetmap:node/5490877672'),
  ('Supermercado', 'catalogo-melilla:melilla-resto:node-7148140638', 'Suma Melilla – Calle Carlos V', NULL, '52001', 'Calle Carlos V', NULL, 35.2804, -2.93878, 'address', 'openstreetmap:node/7148140638'),
  ('Hospital', 'catalogo-melilla:melilla-resto:way-1472671154', 'Acceso Hospital Melilla – Calle del Ramal del Docker', NULL, '52001', 'Calle del Ramal del Docker', NULL, 35.28153, -2.94255, 'address', 'openstreetmap:way/1472671154'),
  ('Supermercado', 'catalogo-melilla:melilla-resto:way-301752472', 'Mercadona Melilla – Carlos V', NULL, '52001', 'Carlos V', '52006', 35.28193, -2.93996, 'address', 'openstreetmap:way/301752472'),
  ('Supermercado', 'catalogo-melilla:melilla-resto:way-302473141', 'Lidl Melilla – Calle Si Mohamed Tahar', NULL, '52001', 'Calle Si Mohamed Tahar', NULL, 35.29104, -2.95608, 'address', 'openstreetmap:way/302473141'),
  ('Hospital', 'catalogo-melilla:melilla-resto:way-303232733', 'Hospital Comarcal Melilla – Calle Vista Hermosa', NULL, '52001', 'Calle Vista Hermosa', '52005', 35.28638, -2.94739, 'address', 'openstreetmap:way/303232733'),
  ('Hospital', 'catalogo-melilla:melilla-resto:way-304514282', 'Hospital Universitario de Melilla – Calle Monumental', NULL, '52001', 'Calle Monumental', NULL, 35.2814, -2.94287, 'address', 'openstreetmap:way/304514282'),
  ('Centro de salud', 'catalogo-melilla:melilla-resto:way-304655135', 'Centro de Salud Zona Norte Melilla – Calle Lepanto', NULL, '52001', 'Calle Lepanto', NULL, 35.2966, -2.94994, 'address', 'openstreetmap:way/304655135'),
  ('Supermercado', 'catalogo-melilla:melilla-resto:way-304957996', 'Supersol Melilla – Calle General Polavieja', NULL, '52001', 'Calle General Polavieja 30', '52006', 35.28501, -2.94267, 'address', 'openstreetmap:way/304957996'),
  ('Centro de salud', 'catalogo-melilla:melilla-resto:way-31573143', 'Centro de Salud Zona Centro y de Donación de Sangre Melilla – Explanada de San Lorenzo', NULL, '52001', 'Explanada de San Lorenzo', '52001', 35.28949, -2.93871, 'address', 'openstreetmap:way/31573143'),
  ('Centro comercial', 'catalogo-melilla:melilla-resto:way-547955576', 'CC Parque Melilla – Paseo de las Rosas', NULL, '52001', 'Paseo de las Rosas', NULL, 35.27091, -2.93935, 'address', 'openstreetmap:way/547955576'),
  ('Supermercado', 'catalogo-melilla:melilla-resto:way-582146750', 'Family Cash Melilla – Paseo de las Rosas', NULL, '52001', 'Paseo de las Rosas', NULL, 35.27053, -2.93925, 'address', 'openstreetmap:way/582146750');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '52');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 52 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '52'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 18 THEN
    RAISE EXCEPTION 'Se esperaban 18 puntos de (varias) en Melilla, hay %', n;
  END IF;
END;
$$;

COMMIT;
