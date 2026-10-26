-- Carga de la categoría (varias) de Tarragona (provincia 43), trozo de la carga de Andalucía.
-- Origen: cataluna-tiendas-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 3 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-10707544296', 'Tiendanimal Tarragona – Carrer del Mestre Xavier Gols', 'Mascotas', '43148', 'Carrer del Mestre Xavier Gols', NULL, 41.13242, 1.20577, 'address', 'openstreetmap:node/10707544296'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-12480257803', 'Guaw Reus – Avinguda de la Cambra de Comerç', 'Mascotas', '43123', 'Avinguda de la Cambra de Comerç', '43204', 41.14536, 1.12725, 'address', 'openstreetmap:node/12480257803'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:way-85564869', 'Kiwoko Tarragona – Carrer A', 'Mascotas', '43148', 'Carrer A', NULL, 41.13009, 1.20525, 'address', 'openstreetmap:way/85564869');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '43');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 43 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '43'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 3 THEN
    RAISE EXCEPTION 'Se esperaban 3 puntos de (varias) en Tarragona, hay %', n;
  END IF;
END;
$$;

COMMIT;
