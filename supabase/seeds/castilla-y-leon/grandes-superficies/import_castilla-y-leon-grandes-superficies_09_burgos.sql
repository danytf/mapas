-- Carga de la categoría (varias) de Burgos (provincia 09), trozo de la carga de Andalucía.
-- Origen: castilla-y-leon-grandes-superficies-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 13 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-10695382578', 'Carrefour Burgos – Avenida la Paz', NULL, '09059', 'Avenida la Paz 25', '09004', 42.34542, -3.69143, 'address', 'openstreetmap:node/10695382578'),
  ('MediaMarkt', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-12158287221', 'MediaMarkt Burgos', NULL, '09059', NULL, '09006', 42.35853, -3.69523, 'address', 'openstreetmap:node/12158287221'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-12376613332', 'Carrefour Burgos – Calle San Pedro Cardeña', NULL, '09059', 'Calle San Pedro Cardeña 38', '09002', 42.33881, -3.68944, 'address', 'openstreetmap:node/12376613332'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-13122004844', 'Carrefour Briviesca', NULL, '09056', NULL, NULL, 42.52881, -3.33208, 'address', 'openstreetmap:node/13122004844'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1990296691', 'Carrefour Burgos – Avenida Cantabria', NULL, '09059', 'Avenida Cantabria', '09006', 42.36024, -3.69563, 'address', 'openstreetmap:node/1990296691'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6019143416', 'Carrefour Villarcayo de Merindad de Castilla la Vieja – Calle San Roque', NULL, '09903', 'Calle San Roque 6', '09550', 42.93976, -3.5711, 'address', 'openstreetmap:node/6019143416'),
  ('IKEA', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-7084873039', 'IKEA Burgos – Avenida Cantabria', NULL, '09059', 'Avenida Cantabria', '09006', 42.35992, -3.69466, 'address', 'openstreetmap:node/7084873039'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-7221151551', 'Carrefour Burgos – Avenida Islas Baleares', NULL, '09059', 'Avenida Islas Baleares', NULL, 42.36359, -3.68078, 'address', 'openstreetmap:node/7221151551'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-7259055111', 'Carrefour Burgos – Calle Presidente Adolfo Suárez', NULL, '09059', 'Calle Presidente Adolfo Suárez 8', '09006', 42.36539, -3.67477, 'address', 'openstreetmap:node/7259055111'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-8038070698', 'Carrefour Burgos', NULL, '09059', NULL, NULL, 42.31023, -3.70308, 'address', 'openstreetmap:node/8038070698'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-1257117445', 'Carrefour Briviesca', NULL, '09056', NULL, NULL, 42.526, -3.33385, 'address', 'openstreetmap:way/1257117445'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-44048381', 'Decathlon Burgos – Carretera Madrid-Irún', NULL, '09059', 'Carretera Madrid-Irún', '09001', 42.31987, -3.70447, 'address', 'openstreetmap:way/44048381'),
  ('El Corte Inglés', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-44048384', 'El Corte Inglés Burgos – Carretera Madrid-Irún', NULL, '09059', 'Carretera Madrid-Irún 236', '09001', 42.31812, -3.70435, 'address', 'openstreetmap:way/44048384');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '09');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 09 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '09'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 13 THEN
    RAISE EXCEPTION 'Se esperaban 13 puntos de (varias) en Burgos, hay %', n;
  END IF;
END;
$$;

COMMIT;
