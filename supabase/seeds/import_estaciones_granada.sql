-- Carga de la categoría Estaciones de Granada (tren y autobús).
-- Origen: supabase/seeds/estaciones-granada.json (OpenStreetMap, ODbL, consulta del 19/10/2026).
-- 14 filas: 7 de autobús y 7 de tren. Iznalloz, Benalúa y Huéneja-Dólar van con precisión 'approximate' (por revisar).
-- No toca nada existente: si el source_ref ya existe, no hace nada.
-- Transaccional: si falta la provincia, la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _estaciones (
  source_ref text, name text, subtype text, muni_norm text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _estaciones VALUES
  ('catalogo-granada:estaciones:estacion-de-autobuses-de-almunecar:almunecar:avenida-del-rey-juan-carlos-i', 'Estación de Autobuses de Almuñécar – Avenida del Rey Juan Carlos I', 'Autobús', 'almunecar', 'Avenida del Rey Juan Carlos I', '18690', 36.73569, -3.6884, 'address', 'openstreetmap:node/33186024'),
  ('catalogo-granada:estaciones:estacion-de-tren-de-moreda:morelabor:barrio-estacion-de-moreda', 'Estación de tren de Moreda – Barrio Estación de Moreda', 'Tren', 'morelabor', 'Barrio Estación de Moreda', '18540', 37.43113, -3.31075, 'address', 'openstreetmap:node/1857241320'),
  ('catalogo-granada:estaciones:estacion-de-tren-de-iznalloz:iznalloz:calle-explanada-de-la-estacion', 'Estación de tren de Iznalloz – Calle Explanada de la Estación', 'Tren', 'iznalloz', 'Calle Explanada de la Estación', '18550', 37.39582, -3.52776, 'approximate', 'openstreetmap:node/2364846599'),
  ('catalogo-granada:estaciones:estacion-de-tren-de-granada:granada:avenida-de-andaluces', 'Estación de tren de Granada – Avenida de Andaluces', 'Tren', 'granada', 'Avenida de Andaluces', '18071', 37.18369, -3.60863, 'address', 'openstreetmap:node/7201979115'),
  ('catalogo-granada:estaciones:estacion-de-tren-de-hueneja-dolar:hueneja:carretera-de-a-92-a-estacion-de-hueneja', 'Estación de tren de Huéneja-Dólar – Carretera de A-92 a Estación de Huéneja', 'Tren', 'hueneja', 'Carretera de A-92 a Estación de Huéneja', NULL, 37.22145, -2.94912, 'approximate', 'openstreetmap:node/7747890775'),
  ('catalogo-granada:estaciones:estacion-de-tren-de-guadix:guadix:avenida-de-la-estacion', 'Estación de tren de Guadix – Avenida de la Estación', 'Tren', 'guadix', 'Avenida de la Estación', '18500', 37.31688, -3.12702, 'address', 'openstreetmap:node/7747890785'),
  ('catalogo-granada:estaciones:apeadero-de-benalua:benalua:carretera-de-moreda-a-guadix', 'Apeadero de Benalúa – Carretera de Moreda a Guadix', 'Tren', 'benalua', 'Carretera de Moreda a Guadix', '18510', 37.34526, -3.16321, 'approximate', 'openstreetmap:node/7747890786'),
  ('catalogo-granada:estaciones:estacion-de-autobuses-de-motril:motril:calle-tegucigalpa', 'Estación de Autobuses de Motril – Calle Tegucigalpa', 'Autobús', 'motril', 'Calle Tegucigalpa', '18600', 36.74127, -3.51156, 'address', 'openstreetmap:node/13174923942'),
  ('catalogo-granada:estaciones:estacion-de-tren-de-loja:loja:calle-fuente-don-pedro', 'Estación de tren de Loja – Calle Fuente Don Pedro', 'Tren', 'loja', 'Calle Fuente Don Pedro', '18300', 37.17511, -4.13567, 'address', 'openstreetmap:node/13651827338'),
  ('catalogo-granada:estaciones:estacion-de-autobuses-de-granada:granada:avenida-juan-pablo-ii', 'Estación de Autobuses de Granada – Avenida Juan Pablo II', 'Autobús', 'granada', 'Avenida Juan Pablo II', '18013', 37.19957, -3.61401, 'address', 'openstreetmap:way/120715331'),
  ('catalogo-granada:estaciones:estacion-de-autobuses-de-guadix:guadix:calle-santa-rosa-9', 'Estación de Autobuses de Guadix – Calle Santa Rosa', 'Autobús', 'guadix', 'Calle Santa Rosa 9', '18500', 37.29976, -3.12768, 'address', 'openstreetmap:way/267968647'),
  ('catalogo-granada:estaciones:estacion-de-bus-de-salobrena:salobrena:carretera-vieja', 'Estación de Bus de Salobreña – Carretera Vieja', 'Autobús', 'salobrena', 'Carretera Vieja', '18680', 36.74677, -3.58263, 'address', 'openstreetmap:way/761460881'),
  ('catalogo-granada:estaciones:estacion-de-autobuses-de-baza:baza:avenida-reyes-catolicos', 'Estación de Autobuses de Baza – Avenida Reyes Católicos', 'Autobús', 'baza', 'Avenida Reyes Católicos', '18800', 37.49208, -2.77535, 'address', 'openstreetmap:way/1308579630'),
  ('catalogo-granada:estaciones:intercambiador-de-loja:loja:avenida-jesus', 'Intercambiador de Loja – Avenida Jesús', 'Autobús', 'loja', 'Avenida Jesús', '18300', 37.16738, -4.16109, 'address', 'openstreetmap:way/1447080229');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.provinces WHERE code = '18' AND name = 'Granada') THEN
    RAISE EXCEPTION 'Falta la provincia Granada (código 18).';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT e.muni_norm, ', ') INTO faltan
  FROM _estaciones e
  WHERE NOT EXISTS (
    SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
    WHERE p.code = '18' AND m.normalized_name = e.muni_norm
  );
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios en Granada: %', faltan;
  END IF;
END;
$$;

INSERT INTO public.establishments (
  province_id, municipality_id, category_id,
  name, normalized_name, subtype, address, postal_code,
  latitude, longitude, location_precision, location_source,
  source_ref, status
)
SELECT p.id, m.id, c.id,
       e.name, lower(trim(e.name)), e.subtype, e.address, e.postal_code,
       e.latitude, e.longitude, e.location_precision, e.location_source,
       e.source_ref, 'active'
FROM _estaciones e
JOIN public.provinces p ON p.code = '18'
JOIN public.municipalities m ON m.province_id = p.id AND m.normalized_name = e.muni_norm
JOIN public.categories c ON c.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments
  WHERE source_ref LIKE 'catalogo-granada:estaciones:%';
  IF n <> 14 THEN
    RAISE EXCEPTION 'Se esperaban 14 estaciones, hay %', n;
  END IF;
END;
$$;

COMMIT;
