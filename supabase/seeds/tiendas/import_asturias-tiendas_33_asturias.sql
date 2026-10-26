-- Carga de la categoría (varias) de Asturias (provincia 33), trozo de la carga de Andalucía.
-- Origen: asturias-tiendas-asturias.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 4 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-asturias:asturias-tiendas:node-13719638899', 'Kiwoko Gijón – Autovía Oviedo - Gijón/Xixón (Autovía Industrial)', 'Mascotas', '33024', 'Autovía Oviedo - Gijón/Xixón (Autovía Industrial)', NULL, 43.51024, -5.69186, 'address', 'openstreetmap:node/13719638899'),
  ('Tiendas', 'catalogo-asturias:asturias-tiendas:node-6185852862', 'Kiwoko Siero – Carretera Oviedo - Viella', 'Mascotas', '33066', 'Carretera Oviedo - Viella', '33429', 43.39213, -5.79563, 'address', 'openstreetmap:node/6185852862'),
  ('Tiendas', 'catalogo-asturias:asturias-tiendas:node-9211865519', 'Miscota Gijón – Calle Alonso de Ojeda', 'Mascotas', '33024', 'Calle Alonso de Ojeda 26', '33208', 43.53035, -5.66876, 'address', 'openstreetmap:node/9211865519'),
  ('Tiendas', 'catalogo-asturias:asturias-tiendas:way-558597083', 'TiendAnimal Gijón – Camín del Fondo de Porceyo', 'Mascotas', '33024', 'Camín del Fondo de Porceyo', NULL, 43.50914, -5.69413, 'address', 'openstreetmap:way/558597083');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '33');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 33 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '33'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 4 THEN
    RAISE EXCEPTION 'Se esperaban 4 puntos de (varias) en Asturias, hay %', n;
  END IF;
END;
$$;

COMMIT;
