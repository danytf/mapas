-- Carga de la categoría (varias) de Cáceres (provincia 10), trozo de la carga de Andalucía.
-- Origen: extremadura-grandes-superficies-extremadura.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:56Z).
-- 12 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:node-10552592128', 'Carrefour Cáceres – Avenida de las Arenas', NULL, '10037', 'Avenida de las Arenas', '10005', 39.46686, -6.39562, 'address', 'openstreetmap:node/10552592128'),
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:node-13833802085', 'Carrefour Moraleja – Avenida de Lusitania', NULL, '10128', 'Avenida de Lusitania 29', '10840', 40.06517, -6.65735, 'address', 'openstreetmap:node/13833802085'),
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:node-3643289485', 'Carrefour Jarandilla de la Vera – Calle de Antonio Serrano Rodríguez', NULL, '10105', 'Calle de Antonio Serrano Rodríguez 1', '10450', 40.12965, -5.66324, 'address', 'openstreetmap:node/3643289485'),
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:node-3929623013', 'Carrefour Jaraíz de la Vera – Calle de los Derechos Humanos', NULL, '10104', 'Calle de los Derechos Humanos 7', '10400', 40.06025, -5.75419, 'address', 'openstreetmap:node/3929623013'),
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:node-6137488473', 'Carrefour Plasencia – Calle Puerta de Talavera', NULL, '10148', 'Calle Puerta de Talavera 29', '10600', 40.02922, -6.08957, 'address', 'openstreetmap:node/6137488473'),
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:node-7088471585', 'Carrefour Aldeanueva del Camino – Autovía Ruta de la Plata', NULL, '10015', 'Autovía Ruta de la Plata', '10740', 40.26521, -5.91699, 'address', 'openstreetmap:node/7088471585'),
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:node-9589430750', 'Carrefour Cáceres – Pintores', NULL, '10037', 'Pintores', '10003', 39.47385, -6.37355, 'address', 'openstreetmap:node/9589430750'),
  ('Decathlon', 'catalogo-extremadura:extremadura-grandes-superficies:way-1270214837', 'Decathlon Cáceres – Avenida de las Arenas', NULL, '10037', 'Avenida de las Arenas', '10005', 39.46767, -6.39722, 'address', 'openstreetmap:way/1270214837'),
  ('El Corte Inglés', 'catalogo-extremadura:extremadura-grandes-superficies:way-30254014', 'El Corte Inglés Cáceres – Avenida Héroes de Baler', NULL, '10037', 'Avenida Héroes de Baler', '10004', 39.48896, -6.35746, 'address', 'openstreetmap:way/30254014'),
  ('Leroy Merlin', 'catalogo-extremadura:extremadura-grandes-superficies:way-383029268', 'Leroy Merlin Cáceres – Calle de Antonio Floriano Cumbreño', NULL, '10037', 'Calle de Antonio Floriano Cumbreño', NULL, 39.46457, -6.38659, 'address', 'openstreetmap:way/383029268'),
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:way-65390236', 'Carrefour Plasencia – Calle Julián Besteiro', NULL, '10148', 'Calle Julián Besteiro', '10600', 40.03857, -6.07848, 'address', 'openstreetmap:way/65390236'),
  ('Carrefour', 'catalogo-extremadura:extremadura-grandes-superficies:way-791317247', 'Carrefour Cáceres – Calle Gredos', NULL, '10037', 'Calle Gredos', '10005', 39.4717, -6.39157, 'address', 'openstreetmap:way/791317247');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '10');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 10 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '10'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 12 THEN
    RAISE EXCEPTION 'Se esperaban 12 puntos de (varias) en Cáceres, hay %', n;
  END IF;
END;
$$;

COMMIT;
