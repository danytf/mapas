-- Municipio que faltaba en la carga de Madrid (provincia 28): Santa María de la Alameda (INE 28135) y sus 2 puntos descartados.
-- Origen: OpenStreetMap (ODbL), base 2026-10-25T21:21:21Z. Relación 347595 (nivel 8, ine:municipio=28135, wikidata Q1769405).
-- El polígono del municipio no se construyó en el extracto, por eso sus puntos quedaron «fuera de los municipios oficiales cargados» (ver docs/CARGA_N2_MADRID.md).
-- Puntos: Ayuntamiento (way/839379035) y Estación de Santa María de la Alameda-Peguerinos (node/5323342058). Sin código postal: OpenStreetMap no lo trae.
-- Transaccional e idempotente: si el municipio o el source_ref ya existen, no cambia nada. Aborta si falta la provincia o alguna categoría.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.provinces WHERE code = '28') THEN
    RAISE EXCEPTION 'Falta la provincia 28.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Entidad oficial') THEN
    RAISE EXCEPTION 'Falta la categoría Entidad oficial.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
END;
$$;

INSERT INTO public.municipalities (province_id, name, normalized_name, official_code)
SELECT p.id, 'Santa María de la Alameda', 'santa-maria-de-la-alameda', '28135'
FROM public.provinces p WHERE p.code = '28'
ON CONFLICT (province_id, normalized_name) DO UPDATE
  SET official_code = EXCLUDED.official_code
  WHERE public.municipalities.official_code IS NULL;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Entidad oficial', 'catalogo-madrid:madrid-resto:way-839379035', 'Ayuntamiento de Santa María de la Alameda – Plaza Constitución', NULL, '28135', 'Plaza Constitución 1', NULL, 40.595733, -4.257916, 'address', 'openstreetmap:way/839379035'),
  ('Estaciones', 'catalogo-madrid:estaciones:node-5323342058', 'Estación de tren de Santa María de la Alameda', 'Tren', '28135', NULL, NULL, 40.568823, -4.269318, 'address', 'openstreetmap:node/5323342058');

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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '28'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
  WHERE p.code = '28' AND m.official_code = '28135';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Se esperaba 1 municipio 28135 en Madrid, hay %', n;
  END IF;
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 2 THEN
    RAISE EXCEPTION 'Se esperaban 2 puntos de Santa María de la Alameda, hay %', n;
  END IF;
END;
$$;

COMMIT;
