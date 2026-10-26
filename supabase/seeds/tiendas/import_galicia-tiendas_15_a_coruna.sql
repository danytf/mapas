-- Carga de la categoría (varias) de A Coruña (provincia 15), trozo de la carga de Andalucía.
-- Origen: galicia-tiendas-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 5 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-galicia:galicia-tiendas:node-11913606225', 'Kiwoko A Coruña – Estrada dos Baños de Arteixo', 'Mascotas', '15030', 'Estrada dos Baños de Arteixo 43', '15008', 43.34307, -8.42838, 'address', 'openstreetmap:node/11913606225'),
  ('Tiendas', 'catalogo-galicia:galicia-tiendas:node-6648385930', 'Kiwoko Ferrol – Rúa Buque Escola Giralda', 'Mascotas', '15036', 'Rúa Buque Escola Giralda', NULL, 43.50375, -8.20424, 'address', 'openstreetmap:node/6648385930'),
  ('Tiendas', 'catalogo-galicia:galicia-tiendas:way-160513897', 'Kiwoko Santiago de Compostela – Rúa de Eslovenia', 'Mascotas', '15078', 'Rúa de Eslovenia 3', '15707', 42.90163, -8.50884, 'address', 'openstreetmap:way/160513897'),
  ('Tiendas', 'catalogo-galicia:galicia-tiendas:way-34693422', 'Tiendanimal Ferrol – Estrada Castelao', 'Mascotas', '15036', 'Estrada Castelao', '15570', 43.48824, -8.20092, 'address', 'openstreetmap:way/34693422'),
  ('Tiendas', 'catalogo-galicia:galicia-tiendas:way-682257894', 'Kiwoko Santiago de Compostela – Avenida do Camiño Francés', 'Mascotas', '15078', 'Avenida do Camiño Francés', NULL, 42.88879, -8.52648, 'address', 'openstreetmap:way/682257894');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '15');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 15 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '15'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 5 THEN
    RAISE EXCEPTION 'Se esperaban 5 puntos de (varias) en A Coruña, hay %', n;
  END IF;
END;
$$;

COMMIT;
