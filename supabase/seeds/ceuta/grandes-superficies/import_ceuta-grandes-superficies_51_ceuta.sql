-- Carga de la categoría (varias) de Ceuta (provincia 51), trozo de la carga de Andalucía.
-- Origen: ceuta-grandes-superficies-ceuta.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 4 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Decathlon', 'catalogo-ceuta:ceuta-grandes-superficies:node-12697009416', 'Decathlon Ceuta – Calle A', NULL, '51001', 'Calle A', NULL, 35.8938, -5.32355, 'address', 'openstreetmap:node/12697009416'),
  ('Carrefour', 'catalogo-ceuta:ceuta-grandes-superficies:node-5062994852', 'Carrefour Ceuta – Calle Alcalde Ricardo Cerni González', NULL, '51001', 'Calle Alcalde Ricardo Cerni González', NULL, 35.8937, -5.32907, 'address', 'openstreetmap:node/5062994852'),
  ('Carrefour', 'catalogo-ceuta:ceuta-grandes-superficies:node-8428039734', 'Carrefour Ceuta – Calle Real', NULL, '51001', 'Calle Real', NULL, 35.88947, -5.3031, 'address', 'openstreetmap:node/8428039734'),
  ('Carrefour', 'catalogo-ceuta:ceuta-grandes-superficies:node-9911249121', 'Carrefour Ceuta – Paseo de Colón', NULL, '51001', 'Paseo de Colón', '51001', 35.88705, -5.31231, 'address', 'openstreetmap:node/9911249121');

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
  IF n <> 4 THEN
    RAISE EXCEPTION 'Se esperaban 4 puntos de (varias) en Ceuta, hay %', n;
  END IF;
END;
$$;

COMMIT;
