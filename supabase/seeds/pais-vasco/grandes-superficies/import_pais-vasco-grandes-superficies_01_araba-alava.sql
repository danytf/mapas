-- Carga de la categoría (varias) de Araba/Álava (provincia 01), trozo de la carga de Andalucía.
-- Origen: pais-vasco-grandes-superficies-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 11 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('MediaMarkt', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-13339081947', 'MediaMarkt Vitoria-Gasteiz – Zaramaga kalea', NULL, '01059', 'Zaramaga kalea 1', '01013', 42.86239, -2.66979, 'address', 'openstreetmap:node/13339081947'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-4414011891', 'Carrefour Vitoria-Gasteiz – Iruraitz-Gauna kalea', NULL, '01059', 'Iruraitz-Gauna kalea 1', '01194', 42.83445, -2.66986, 'address', 'openstreetmap:node/4414011891'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-483596243', 'Carrefour Vitoria-Gasteiz – Alaba Jeneralaren kalea', NULL, '01059', 'Alaba Jeneralaren kalea 8', '01005', 42.84504, -2.67325, 'address', 'openstreetmap:node/483596243'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-5167643463', 'Carrefour Oyón-Oion – Estibalitz kalea', NULL, '01043', 'Estibalitz kalea', '01320', 42.50436, -2.43666, 'address', 'openstreetmap:node/5167643463'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-5277721722', 'Decathlon Vitoria-Gasteiz – Foru kalea', NULL, '01059', 'Foru kalea 17', '01005', 42.84461, -2.66989, 'address', 'openstreetmap:node/5277721722'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-534072571', 'Carrefour Zigoitia', NULL, '01018', NULL, NULL, 42.91252, -2.71637, 'address', 'openstreetmap:node/534072571'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-6987214109', 'Carrefour Amurrio – Landako kalea', NULL, '01002', 'Landako kalea 12', '01470', 43.05106, -3.00056, 'address', 'openstreetmap:node/6987214109'),
  ('El Corte Inglés', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-23714696', 'El Corte Inglés Vitoria-Gasteiz – Babesgabetuen Andre Mariaren plaza', NULL, '01059', 'Babesgabetuen Andre Mariaren plaza 3', '01002', 42.84486, -2.66789, 'address', 'openstreetmap:way/23714696'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-28735817', 'Decathlon Zigoitia', NULL, '01018', NULL, NULL, 42.91057, -2.71235, 'address', 'openstreetmap:way/28735817'),
  ('IKEA', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-35817407', 'IKEA Vitoria-Gasteiz – Zaramaga kalea', NULL, '01059', 'Zaramaga kalea', '01013', 42.86102, -2.66457, 'address', 'openstreetmap:way/35817407'),
  ('Leroy Merlin', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-35817410', 'Leroy Merlin Vitoria-Gasteiz', NULL, '01059', NULL, NULL, 42.8618, -2.66506, 'address', 'openstreetmap:way/35817410');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '01');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 01 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '01'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 11 THEN
    RAISE EXCEPTION 'Se esperaban 11 puntos de (varias) en Araba/Álava, hay %', n;
  END IF;
END;
$$;

COMMIT;
