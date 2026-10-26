-- Carga de la categoría (varias) de Bizkaia (provincia 48), trozo de la carga de Andalucía.
-- Origen: pais-vasco-tiendas-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 5 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-pais-vasco:pais-vasco-tiendas:node-10011108966', 'Kiwoko Berango – Errementariena bidea', 'Mascotas', '48016', 'Errementariena bidea 2', '48640', 43.3684, -2.99504, 'address', 'openstreetmap:node/10011108966'),
  ('Tiendas', 'catalogo-pais-vasco:pais-vasco-tiendas:node-10236122607', 'Guaw Portugalete – Avenida La Sierra etorbidea', 'Mascotas', '48078', 'Avenida La Sierra etorbidea', '48920', 43.31143, -3.02081, 'address', 'openstreetmap:node/10236122607'),
  ('Tiendas', 'catalogo-pais-vasco:pais-vasco-tiendas:node-11064877451', 'Tiendanimal Sestao – Avenida de Babcock & Wilcox', 'Mascotas', '48084', 'Avenida de Babcock & Wilcox', '48910', 43.30157, -3.00695, 'address', 'openstreetmap:node/11064877451'),
  ('Tiendas', 'catalogo-pais-vasco:pais-vasco-tiendas:way-276753261', 'Kiwoko Barakaldo – Erribera etorbidea', 'Mascotas', '48013', 'Erribera etorbidea 11', NULL, 43.29275, -3.0067, 'address', 'openstreetmap:way/276753261'),
  ('Tiendas', 'catalogo-pais-vasco:pais-vasco-tiendas:way-501309825', 'TiendAnimal Leioa – Barrio Peruri', 'Mascotas', '48054', 'Barrio Peruri 33', '48940', 43.34213, -2.99271, 'address', 'openstreetmap:way/501309825');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '48');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 48 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '48'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 5 THEN
    RAISE EXCEPTION 'Se esperaban 5 puntos de (varias) en Bizkaia, hay %', n;
  END IF;
END;
$$;

COMMIT;
