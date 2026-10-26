-- Carga de la categoría (varias) de Málaga (provincia 29), trozo de la carga de Andalucía.
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
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-4964943389', 'Kiwoko Mijas – Calle Benajarafe', 'Mascotas', '29070', 'Calle Benajarafe', '29649', 36.53681, -4.6361, 'address', 'openstreetmap:node/4964943389'),
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-6041662479', 'Tiendanimal Málaga – Calle Palencia', 'Mascotas', '29067', 'Calle Palencia 5', '29004', 36.68427, -4.47115, 'address', 'openstreetmap:node/6041662479'),
  ('Tiendas', 'catalogo-andalucia:andalucia-tiendas:node-8875351396', 'Miscota Málaga – Calle Emilio Thuillier', 'Mascotas', '29067', 'Calle Emilio Thuillier 18', '29014', 36.74304, -4.42213, 'address', 'openstreetmap:node/8875351396');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '29');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 29 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '29'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 3 THEN
    RAISE EXCEPTION 'Se esperaban 3 puntos de (varias) en Málaga, hay %', n;
  END IF;
END;
$$;

COMMIT;
