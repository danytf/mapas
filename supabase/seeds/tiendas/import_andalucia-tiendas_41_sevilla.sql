-- Carga de la categoría (varias) de Sevilla (provincia 41), trozo de la carga de Andalucía.
-- Origen: andalucia-tiendas-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-17T20:20:51Z).
-- 5 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-13650345229', 'Kiwoko Sevilla – Calle Periodista José Antonio Garmendia', 'Mascotas', '41091', 'Calle Periodista José Antonio Garmendia', '41019', 37.40798, -5.91088, 'address', 'openstreetmap:node/13650345229'),
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-3835498775', 'Kiwoko Gines – Avenida de la Industria 6A', 'Mascotas', '41047', 'Avenida de la Industria 6A', '41960', 37.38048, -6.08371, 'address', 'openstreetmap:node/3835498775'),
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-5308175137', 'Kiwoko Mundo Animal Sevilla – Calle Tamarguillo', 'Mascotas', '41091', 'Calle Tamarguillo', '41006', 37.36993, -5.96732, 'address', 'openstreetmap:node/5308175137'),
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-8131963287', 'Tiendanimal Dos Hermanas – Avenida Ingeniero José Luis Prats', 'Mascotas', '41038', 'Avenida Ingeniero José Luis Prats 3', NULL, 37.28654, -5.93955, 'address', 'openstreetmap:node/8131963287'),
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-9282688602', 'Tiendanimal San Juan de Aznalfarache', 'Mascotas', '41086', NULL, '41920', 37.3539, -6.02487, 'address', 'openstreetmap:node/9282688602');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '41');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 41 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '41'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 5 THEN
    RAISE EXCEPTION 'Se esperaban 5 puntos de (varias) en Sevilla, hay %', n;
  END IF;
END;
$$;

COMMIT;
