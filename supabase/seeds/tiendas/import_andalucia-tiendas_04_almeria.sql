-- Carga de la categoría (varias) de Almería (provincia 04), trozo de la carga de Andalucía.
-- Origen: andalucia-tiendas-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-17T20:20:51Z).
-- 3 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-10273465533', 'Tiendanimal Huércal de Almería – Calle San Rafael', 'Mascotas', '04052', 'Calle San Rafael', NULL, 36.86722, -2.44494, 'address', 'openstreetmap:node/10273465533'),
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-10273934596', 'Tiendanimal Vícar', 'Mascotas', '04102', NULL, NULL, 36.816, -2.60083, 'address', 'openstreetmap:node/10273934596'),
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-11249099116', 'Kiwoko Roquetas de Mar – Carretera de Alicún', 'Mascotas', '04079', 'Carretera de Alicún', NULL, 36.77327, -2.61352, 'address', 'openstreetmap:node/11249099116');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '04');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 04 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '04'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 3 THEN
    RAISE EXCEPTION 'Se esperaban 3 puntos de (varias) en Almería, hay %', n;
  END IF;
END;
$$;

COMMIT;
