-- Carga de la categoría (varias) de Cantabria (provincia 39), trozo de la carga de Andalucía.
-- Origen: cantabria-tiendas-cantabria.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 3 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-cantabria:cantabria-tiendas:node-13070314115', 'Kiwoko Santander – Calle Joaquín Rodrigo', 'Mascotas', '39075', 'Calle Joaquín Rodrigo 2', '39011', 43.45691, -3.86306, 'address', 'openstreetmap:node/13070314115'),
  ('Tiendas', 'catalogo-cantabria:cantabria-tiendas:node-9923945247', 'Tiendanimal Camargo – Calle de Enrique Gran', 'Mascotas', '39016', 'Calle de Enrique Gran 2', '39600', 43.42447, -3.83874, 'address', 'openstreetmap:node/9923945247'),
  ('Tiendas', 'catalogo-cantabria:cantabria-tiendas:way-741769495', 'Kiwoko Torrelavega – Área Comercial La Maderera', 'Mascotas', '39087', 'Área Comercial La Maderera', '39300', 43.35778, -4.06367, 'address', 'openstreetmap:way/741769495');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '39');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 39 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '39'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 3 THEN
    RAISE EXCEPTION 'Se esperaban 3 puntos de (varias) en Cantabria, hay %', n;
  END IF;
END;
$$;

COMMIT;
