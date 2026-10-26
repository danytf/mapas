-- Carga de la categoría (varias) de Illes Balears (provincia 07), trozo de la carga de Andalucía.
-- Origen: baleares-tiendas-baleares.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 4 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-baleares:baleares-tiendas:node-9171867960', 'Kiwoko Manacor – carretera Palma, Carrer d''Artà, Km 47, 07500 Manacor, Illes Balears, Spain', 'Mascotas', '07033', 'carretera Palma, Carrer d''Artà, Km 47, 07500 Manacor, Illes Balears, Spain', '07500', 39.57113, 3.19223, 'address', 'openstreetmap:node/9171867960'),
  ('Tiendas', 'catalogo-baleares:baleares-tiendas:way-115984115', 'Tiendanimal Palma – Carrer de Sor Catalina Maura', 'Mascotas', '07040', 'Carrer de Sor Catalina Maura 10', '07010', 39.59628, 2.65027, 'address', 'openstreetmap:way/115984115'),
  ('Tiendas', 'catalogo-baleares:baleares-tiendas:way-423872211', 'Kiwoko Inca – Carrer dels Pagesos', 'Mascotas', '07027', 'Carrer dels Pagesos', '07300', 39.71129, 2.91005, 'address', 'openstreetmap:way/423872211'),
  ('Tiendas', 'catalogo-baleares:baleares-tiendas:way-777857732', 'Tiendanimal Marratxí – Carrer Antoni Planas Juan', 'Mascotas', '07036', 'Carrer Antoni Planas Juan', NULL, 39.6288, 2.73331, 'address', 'openstreetmap:way/777857732');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '07');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 07 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '07'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 4 THEN
    RAISE EXCEPTION 'Se esperaban 4 puntos de (varias) en Illes Balears, hay %', n;
  END IF;
END;
$$;

COMMIT;
