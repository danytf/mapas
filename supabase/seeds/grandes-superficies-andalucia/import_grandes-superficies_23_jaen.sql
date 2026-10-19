-- Carga de la categoría (varias) de Jaén (provincia 23), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 10 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12772201639', 'Carrefour Santa Elena', NULL, '23076', NULL, NULL, 38.31486, -3.57012, 'address', 'openstreetmap:node/12772201639'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2035460105', 'Carrefour Andújar – Avenida de Estrasburgo', NULL, '23005', 'Avenida de Estrasburgo', NULL, 38.03803, -4.03895, 'address', 'openstreetmap:node/2035460105'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2131539012', 'Carrefour Jaén', NULL, '23050', NULL, NULL, 37.78071, -3.76606, 'address', 'openstreetmap:node/2131539012'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5270990911', 'Carrefour Martos – Avenida Moris Marrodán', NULL, '23060', 'Avenida Moris Marrodán', '23600', 37.71726, -3.97161, 'address', 'openstreetmap:node/5270990911'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-8151312695', 'MediaMarkt Jaén', NULL, '23050', NULL, NULL, 37.79037, -3.77377, 'address', 'openstreetmap:node/8151312695'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:node-8151312696', 'Leroy Merlin Jaén – Carretera de Bailén a Motril', NULL, '23050', 'Carretera de Bailén a Motril', NULL, 37.7901, -3.77317, 'address', 'openstreetmap:node/8151312696'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-156615374', 'El Corte Inglés Jaén – Explanada de El Corte Inglés', NULL, '23050', 'Explanada de El Corte Inglés', NULL, 37.77602, -3.78616, 'address', 'openstreetmap:way/156615374'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-216949134', 'El Corte Inglés Linares – Avenida de Andalucía', NULL, '23055', 'Avenida de Andalucía', '23700', 38.09279, -3.63689, 'address', 'openstreetmap:way/216949134'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-669303734', 'Decathlon Jaén', NULL, '23050', NULL, NULL, 37.78844, -3.77113, 'address', 'openstreetmap:way/669303734'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-99204493', 'Carrefour Úbeda – Avenida de la Ciudad de Linares', NULL, '23092', 'Avenida de la Ciudad de Linares 25', '23400', 38.01601, -3.38147, 'address', 'openstreetmap:way/99204493');

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
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 10 THEN
    RAISE EXCEPTION 'Se esperaban 10 puntos de (varias) en Jaén, hay %', n;
  END IF;
END;
$$;

COMMIT;
