-- Carga de la categoría (varias) de Ceuta (provincia 51), trozo de la carga de Andalucía.
-- Origen: ceuta-resto-ceuta.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 17 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Supermercado', 'catalogo-ceuta:ceuta-resto:node-1078624684', 'Lidl Ceuta – Avenida Juan de Borbón', NULL, '51001', 'Avenida Juan de Borbón', NULL, 35.89104, -5.31886, 'address', 'openstreetmap:node/1078624684'),
  ('Supermercado', 'catalogo-ceuta:ceuta-resto:node-12697009418', 'Supeco Ceuta – Calle C', NULL, '51001', 'Calle C', NULL, 35.89107, -5.31947, 'address', 'openstreetmap:node/12697009418'),
  ('Entidad oficial', 'catalogo-ceuta:ceuta-resto:node-12699360498', 'Jefatura Local de Ceuta (DGT) – Paseo de las Palmeras', NULL, '51001', 'Paseo de las Palmeras 8', '51001', 35.88866, -5.3148, 'address', 'openstreetmap:node/12699360498'),
  ('Entidad oficial', 'catalogo-ceuta:ceuta-resto:node-13256789278', 'Tesorería General de la Seguridad Social Ceuta – Calle Manuel Olivencia Amor', NULL, '51001', 'Calle Manuel Olivencia Amor', '51002', 35.88734, -5.30477, 'address', 'openstreetmap:node/13256789278'),
  ('Supermercado', 'catalogo-ceuta:ceuta-resto:node-13618076401', 'Real Market Ceuta – Calle Real', NULL, '51001', 'Calle Real', NULL, 35.88953, -5.303, 'address', 'openstreetmap:node/13618076401'),
  ('Supermercado', 'catalogo-ceuta:ceuta-resto:node-7981174278', 'Dia Ceuta – Calle A', NULL, '51001', 'Calle A', NULL, 35.8931, -5.32261, 'address', 'openstreetmap:node/7981174278'),
  ('Centro comercial', 'catalogo-ceuta:ceuta-resto:way-1425566216', 'El Coso Ceuta – Calle Bermudo Soriano', NULL, '51001', 'Calle Bermudo Soriano', NULL, 35.88644, -5.33193, 'address', 'openstreetmap:way/1425566216'),
  ('Centro de salud', 'catalogo-ceuta:ceuta-resto:way-1444798113', 'Centro de Salud Recinto Sur Ceuta – Calle Manuel Leria', NULL, '51001', 'Calle Manuel Leria', '51002', 35.88562, -5.30725, 'address', 'openstreetmap:way/1444798113'),
  ('Entidad oficial', 'catalogo-ceuta:ceuta-resto:way-249806199', 'Instituto Nacional de la Seguridad Social Ceuta – Calle Manuel Olivencia Amor', NULL, '51001', 'Calle Manuel Olivencia Amor', '51002', 35.88712, -5.30492, 'address', 'openstreetmap:way/249806199'),
  ('Centro de salud', 'catalogo-ceuta:ceuta-resto:way-363347283', 'Centro de Salud Otero Ceuta – Avenida Otero', NULL, '51001', 'Avenida Otero', '51001', 35.88843, -5.32759, 'address', 'openstreetmap:way/363347283'),
  ('Centro comercial', 'catalogo-ceuta:ceuta-resto:way-363351263', 'C.C. Parque Ceuta – Calle Alcalde Ricardo Cerni González', NULL, '51001', 'Calle Alcalde Ricardo Cerni González', NULL, 35.89391, -5.32902, 'address', 'openstreetmap:way/363351263'),
  ('Hospital', 'catalogo-ceuta:ceuta-resto:way-363354239', 'Hospital Universitario de Ceuta – Loma Colmenar', NULL, '51001', 'Loma Colmenar', '51003', 35.88034, -5.34182, 'address', 'openstreetmap:way/363354239'),
  ('Entidad oficial', 'catalogo-ceuta:ceuta-resto:way-564985642', 'Delegación del Gobierno Ceuta – Calle General Serrano Orive', NULL, '51001', 'Calle General Serrano Orive 1', '51002', 35.88675, -5.30826, 'address', 'openstreetmap:way/564985642'),
  ('Entidad oficial', 'catalogo-ceuta:ceuta-resto:way-73006122', 'Ayuntamiento de Ceuta – Paseo Alcalde Sánchez Prado', NULL, '51001', 'Paseo Alcalde Sánchez Prado', '51001', 35.88862, -5.31583, 'address', 'openstreetmap:way/73006122'),
  ('Supermercado', 'catalogo-ceuta:ceuta-resto:way-746630839', 'Mercadona Ceuta – Carlos Chocrón', NULL, '51001', 'Carlos Chocrón', NULL, 35.892, -5.32422, 'address', 'openstreetmap:way/746630839'),
  ('Supermercado', 'catalogo-ceuta:ceuta-resto:way-842034213', 'Mercadona Ceuta – Parque Barrionuevo', NULL, '51001', 'Parque Barrionuevo', NULL, 35.88078, -5.33562, 'address', 'openstreetmap:way/842034213'),
  ('Entidad oficial', 'catalogo-ceuta:ceuta-resto:way-849012383', 'Juzgado de Primera Instancia e Instrucción de Ceuta – Calle Manuel Leria', NULL, '51001', 'Calle Manuel Leria', '51001', 35.88655, -5.30706, 'address', 'openstreetmap:way/849012383');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '51');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 51 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '51'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 17 THEN
    RAISE EXCEPTION 'Se esperaban 17 puntos de (varias) en Ceuta, hay %', n;
  END IF;
END;
$$;

COMMIT;
