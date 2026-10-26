-- Carga de la categoría (varias) de Ciudad Real (provincia 13), trozo de la carga de Andalucía.
-- Origen: castilla-la-mancha-grandes-superficies-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 10 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-13790901301', 'Carrefour Torralba de Calatrava – AUTOVIA A-43 KM.', NULL, '13083', 'AUTOVIA A-43 KM. 290', NULL, 39.00585, -3.75662, 'address', 'openstreetmap:node/13790901301'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-1795969629', 'Carrefour Puertollano – Paseo de San Gregorio', NULL, '13071', 'Paseo de San Gregorio 3', '13500', 38.68717, -4.10763, 'address', 'openstreetmap:node/1795969629'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-6919839040', 'Carrefour Ciudad Real – Calle Ciruela', NULL, '13034', 'Calle Ciruela', '13001', 38.98225, -3.928, 'address', 'openstreetmap:node/6919839040'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-8350560662', 'Carrefour Manzanares – Carretera Daimiel', NULL, '13053', 'Carretera Daimiel', NULL, 39.00731, -3.38043, 'address', 'openstreetmap:node/8350560662'),
  ('Decathlon', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-1132255549', 'Decathlon Valdepeñas – Calle de Bodegas Megia', NULL, '13087', 'Calle de Bodegas Megia', '13300', 38.78023, -3.38955, 'address', 'openstreetmap:way/1132255549'),
  ('Leroy Merlin', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-1553659637', 'Leroy Merlin Ciudad Real – Calle del Ebro', NULL, '13034', 'Calle del Ebro', NULL, 38.97421, -3.91674, 'address', 'openstreetmap:way/1553659637'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-1558566984', 'Carrefour Alcázar de San Juan – Ctra. de Herencia s/n – C.C. Carrefour', NULL, '13005', 'Ctra. de Herencia s/n – C.C. Carrefour', '13600', 39.38567, -3.23615, 'address', 'openstreetmap:way/1558566984'),
  ('Decathlon', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-358498505', 'Decathlon Ciudad Real – Avenida de la Ciencia', NULL, '13034', 'Avenida de la Ciencia', '13005', 38.98566, -3.90845, 'address', 'openstreetmap:way/358498505'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-492152874', 'Carrefour Puertollano – Carretera de Argamasilla', NULL, '13071', 'Carretera de Argamasilla 42', '13500', 38.7022, -4.10127, 'address', 'openstreetmap:way/492152874'),
  ('MediaMarkt', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-511116152', 'MediaMarkt Ciudad Real – Avenida de la Ciencia', NULL, '13034', 'Avenida de la Ciencia', '13005', 38.98542, -3.90834, 'address', 'openstreetmap:way/511116152');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '13');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 13 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '13'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 10 THEN
    RAISE EXCEPTION 'Se esperaban 10 puntos de (varias) en Ciudad Real, hay %', n;
  END IF;
END;
$$;

COMMIT;
