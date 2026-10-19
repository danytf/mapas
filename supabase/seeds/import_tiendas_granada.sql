-- Carga de la categoría Tiendas de Granada.
-- Origen: seeds/tiendas-granada.json (OpenStreetMap, ODbL, consulta del 2026-10-19).
-- 7 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la provincia, la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-granada:tiendas:mundo-animal-atarfe:atarfe:calle-cedazos-61', 'Mundo Animal Atarfe – Calle Cedazos', 'Mascotas', '18022', 'Calle Cedazos 61', '18230', 37.22632, -3.68499, 'address', 'openstreetmap:node/5908467134'),
  ('catalogo-granada:tiendas:cash-mascota-granada:granada:calle-parraga', 'Cash Mascota Granada – Calle Párraga', 'Mascotas', '18087', 'Calle Párraga', '18002', 37.17389, -3.60119, 'address', 'openstreetmap:node/7988299180'),
  ('catalogo-granada:tiendas:cash-mascota-granada:granada:camino-de-purchil-42b', 'Cash Mascota Granada – Camino de Purchil', 'Mascotas', '18087', 'Camino de Purchil 42b', '18004', 37.16976, -3.62055, 'address', 'openstreetmap:node/9296356730'),
  ('catalogo-granada:tiendas:kiwoko-motril:motril:rotonda-alcampo', 'Kiwoko Motril – Rotonda Alcampo', 'Mascotas', '18140', 'Rotonda Alcampo', '18600', 36.74179, -3.52759, 'address', 'openstreetmap:node/11213593936'),
  ('catalogo-granada:tiendas:cash-mascota-pulianas:pulianas:calle-de-luis-bunuel-6', 'Cash Mascota Pulianas – Calle de Luis Buñuel', 'Mascotas', '18165', 'Calle de Luis Buñuel 6', '18197', 37.21111, -3.62134, 'address', 'openstreetmap:node/6442710388'),
  ('catalogo-granada:tiendas:kiwoko-pulianas:pulianas:calle-de-luis-bunuel', 'Kiwoko Pulianas – Calle de Luis Buñuel', 'Mascotas', '18165', 'Calle de Luis Buñuel', '18197', 37.21404, -3.61721, 'address', 'openstreetmap:node/7614904582'),
  ('catalogo-granada:tiendas:tiendanimal-pulianas:pulianas:calle-cartujilla', 'Tiendanimal Pulianas – Calle Cartujilla', 'Mascotas', '18165', 'Calle Cartujilla', '18197', 37.21243, -3.62123, 'address', 'openstreetmap:node/7619624228');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.provinces WHERE code = '18') THEN
    RAISE EXCEPTION 'Falta la provincia 18.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'tiendas' AND name = 'Tiendas') THEN
    RAISE EXCEPTION 'Falta la categoría Tiendas.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m WHERE m.official_code = c.muni_ine);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id
JOIN public.categories cat ON cat.code = 'tiendas'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments WHERE source_ref LIKE 'catalogo-granada:tiendas:%';
  IF n <> 7 THEN
    RAISE EXCEPTION 'Se esperaban 7 puntos de Tiendas, hay %', n;
  END IF;
END;
$$;

COMMIT;
