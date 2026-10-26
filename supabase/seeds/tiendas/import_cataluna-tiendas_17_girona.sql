-- Carga de la categoría (varias) de Girona (provincia 17), trozo de la carga de Andalucía.
-- Origen: cataluna-tiendas-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 4 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-10725872327', 'Kiwoko Castell d''Aro, Platja d''Aro i s''Agaró – Avinguda s''Agaró', 'Mascotas', '17048', 'Avinguda s''Agaró', '17249', 41.80582, 3.05493, 'address', 'openstreetmap:node/10725872327'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-12170257397', 'TiendAnimal Blanes – Avinguda de l''Estació', 'Mascotas', '17023', 'Avinguda de l''Estació', '17310', 41.67538, 2.7752, 'address', 'openstreetmap:node/12170257397'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-14031987801', 'Tiendanimal Palafrugell – Carrer de Rosa Parks', 'Mascotas', '17117', 'Carrer de Rosa Parks', NULL, 41.92431, 3.15033, 'address', 'openstreetmap:node/14031987801'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-1559471422', 'Tiendanimal Salt – Carrer Camí dels Carlins', 'Mascotas', '17155', 'Carrer Camí dels Carlins 8', '17190', 41.96632, 2.78457, 'address', 'openstreetmap:node/1559471422');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '17');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 17 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '17'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 4 THEN
    RAISE EXCEPTION 'Se esperaban 4 puntos de (varias) en Girona, hay %', n;
  END IF;
END;
$$;

COMMIT;
