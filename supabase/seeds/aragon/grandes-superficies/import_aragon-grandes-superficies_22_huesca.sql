-- Carga de la categoría (varias) de Huesca (provincia 22), trozo de la carga de Andalucía.
-- Origen: aragon-grandes-superficies-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 6 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-1120260312', 'Carrefour Huesca/Uesca – Avenida del Doctor Artero', NULL, '22125', 'Avenida del Doctor Artero 31', '22004', 42.14718, -0.42563, 'address', 'openstreetmap:node/1120260312'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-13062130501', 'Carrefour Jaca – Calle Mayor', NULL, '22130', 'Calle Mayor 51', '22700', 42.56884, -0.54741, 'address', 'openstreetmap:node/13062130501'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-14203483163', 'Carrefour Benasque – Calle San Marcial', NULL, '22054', 'Calle San Marcial', '22440', 42.60416, 0.5228, 'address', 'openstreetmap:node/14203483163'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-4032069535', 'Carrefour Jaca – Polígono Campacián', NULL, '22130', 'Polígono Campacián', '22700', 42.57697, -0.52801, 'address', 'openstreetmap:node/4032069535'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-7728853589', 'Carrefour Fraga – Calle de Torrente de Cinca', NULL, '22112', 'Calle de Torrente de Cinca', '22520', 41.5083, 0.32841, 'address', 'openstreetmap:node/7728853589'),
  ('Decathlon', 'catalogo-aragon:aragon-grandes-superficies:way-62362707', 'Decathlon Huesca/Uesca – Ronda de Valdabra', NULL, '22125', 'Ronda de Valdabra', '22197', 42.1075, -0.44704, 'address', 'openstreetmap:way/62362707');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '22');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 22 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '22'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 6 THEN
    RAISE EXCEPTION 'Se esperaban 6 puntos de (varias) en Huesca, hay %', n;
  END IF;
END;
$$;

COMMIT;
