-- Carga de la categoría (varias) de León (provincia 24), trozo de la carga de Andalucía.
-- Origen: castilla-y-leon-grandes-superficies-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 18 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-11383826145', 'Carrefour Fabero – Calle Gil y Carrasco', NULL, '24070', 'Calle Gil y Carrasco 12', '24420', 42.7663, -6.62652, 'address', 'openstreetmap:node/11383826145'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-11732179501', 'Carrefour La Robla – Calle Alcalde J.B. Villalobos', NULL, '24134', 'Calle Alcalde J.B. Villalobos 8', '24640', 42.8019, -5.62995, 'address', 'openstreetmap:node/11732179501'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1175094654', 'Decathlon Ponferrada – Avenida de los Escritores', NULL, '24115', 'Avenida de los Escritores', '24404', 42.54903, -6.60743, 'address', 'openstreetmap:node/1175094654'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-12118989101', 'Carrefour Vega de Espinareda – Avenida de Ancares', NULL, '24196', 'Avenida de Ancares 8', '24430', 42.7257, -6.6554, 'address', 'openstreetmap:node/12118989101'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-12944673562', 'Carrefour León – Avenida República Argentina', NULL, '24089', 'Avenida República Argentina 22', '24004', 42.59533, -5.57449, 'address', 'openstreetmap:node/12944673562'),
  ('El Corte Inglés', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1506244513', 'El Corte Inglés León – Avenida Alcalde Miguel Castaño', NULL, '24089', 'Avenida Alcalde Miguel Castaño', NULL, 42.5837, -5.55688, 'address', 'openstreetmap:node/1506244513'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-2657956631', 'Carrefour Villafranca del Bierzo – Calle Luis del Olmo', NULL, '24209', 'Calle Luis del Olmo', NULL, 42.61086, -6.80679, 'address', 'openstreetmap:node/2657956631'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-2769302541', 'Carrefour Ponferrada – Calle Juana Ginzo', NULL, '24115', 'Calle Juana Ginzo', '24404', 42.557, -6.6036, 'address', 'openstreetmap:node/2769302541'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-5221769270', 'Carrefour León – Calle Ancha', NULL, '24089', 'Calle Ancha 7', '24003', 42.59851, -5.56818, 'address', 'openstreetmap:node/5221769270'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6512916256', 'Carrefour León – Calle la Serna', NULL, '24089', 'Calle la Serna 86', NULL, 42.60841, -5.55641, 'address', 'openstreetmap:node/6512916256'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6673912577', 'Carrefour Benavides – Calle Manuel Gullón', NULL, '24015', 'Calle Manuel Gullón', NULL, 42.50396, -5.8968, 'address', 'openstreetmap:node/6673912577'),
  ('MediaMarkt', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-8264089974', 'MediaMarkt León – Avenida País Leonés', NULL, '24089', 'Avenida País Leonés', '24010', 42.61187, -5.59533, 'address', 'openstreetmap:node/8264089974'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-1018487880', 'Decathlon León – Paseo de la Granja', NULL, '24089', 'Paseo de la Granja', '24007', 42.60165, -5.55282, 'address', 'openstreetmap:way/1018487880'),
  ('Leroy Merlin', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-1257120849', 'Leroy Merlin León – Avenida de León Cuna del Parlamentarismo', NULL, '24089', 'Avenida de León Cuna del Parlamentarismo', NULL, 42.60422, -5.55277, 'address', 'openstreetmap:way/1257120849'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-1420714140', 'Carrefour León – Calle Maestros Hermanos Alvarado', NULL, '24089', 'Calle Maestros Hermanos Alvarado', NULL, 42.63134, -5.59924, 'address', 'openstreetmap:way/1420714140'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-26956134', 'Carrefour León – Arrabal San Madrid', NULL, '24089', 'Arrabal San Madrid', '24005', 42.58635, -5.55658, 'address', 'openstreetmap:way/26956134'),
  ('El Corte Inglés', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-26956135', 'El Corte Inglés León – Calle Fray Luis de León', NULL, '24089', 'Calle Fray Luis de León 29', '24005', 42.59072, -5.56925, 'address', 'openstreetmap:way/26956135'),
  ('Leroy Merlin', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-543406252', 'Leroy Merlin Ponferrada – Avenida de Asturias', NULL, '24115', 'Avenida de Asturias', NULL, 42.56154, -6.60468, 'address', 'openstreetmap:way/543406252');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '24');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 24 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '24'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 18 THEN
    RAISE EXCEPTION 'Se esperaban 18 puntos de (varias) en León, hay %', n;
  END IF;
END;
$$;

COMMIT;
