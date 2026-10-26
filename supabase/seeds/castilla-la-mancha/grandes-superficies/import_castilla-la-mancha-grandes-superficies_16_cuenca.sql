-- Carga de la categoría (varias) de Cuenca (provincia 16), trozo de la carga de Andalucía.
-- Origen: castilla-la-mancha-grandes-superficies-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 6 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-11741909668', 'Carrefour Chillarón de Cuenca', NULL, '16023', NULL, NULL, 40.08454, -2.20093, 'address', 'openstreetmap:node/11741909668'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-1926189310', 'Carrefour Cuenca – Calle Fernando Yanez de la Almedina', NULL, '16078', 'Calle Fernando Yanez de la Almedina', NULL, 40.05426, -2.12069, 'address', 'openstreetmap:node/1926189310'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-6354139514', 'Carrefour Cuenca – Calle Fermín Caballero', NULL, '16078', 'Calle Fermín Caballero 19', '16004', 40.06766, -2.13495, 'address', 'openstreetmap:node/6354139514'),
  ('Leroy Merlin', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-102463220', 'Leroy Merlin Cuenca – Avenida de los Alfares', NULL, '16078', 'Avenida de los Alfares', NULL, 40.0761, -2.15216, 'address', 'openstreetmap:way/102463220'),
  ('Decathlon', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-555566784', 'Decathlon Cuenca – Camino Solana', NULL, '16078', 'Camino Solana', '16002', 40.07619, -2.15889, 'address', 'openstreetmap:way/555566784'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-683241757', 'Carrefour Las Pedroñeras – Calle de la Guardia Civil', NULL, '16154', 'Calle de la Guardia Civil', NULL, 39.44753, -2.6697, 'address', 'openstreetmap:way/683241757');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '16');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 16 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '16'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 6 THEN
    RAISE EXCEPTION 'Se esperaban 6 puntos de (varias) en Cuenca, hay %', n;
  END IF;
END;
$$;

COMMIT;
