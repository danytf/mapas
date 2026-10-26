-- Carga de la categoría (varias) de Gipuzkoa (provincia 20), trozo de la carga de Andalucía.
-- Origen: pais-vasco-grandes-superficies-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 22 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-10910825334', 'Carrefour Donostia / San Sebastián – Urbieta kalea', NULL, '20069', 'Urbieta kalea 44', '20006', 43.31486, -1.98146, 'address', 'openstreetmap:node/10910825334'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-12520264295', 'Carrefour Donostia / San Sebastián – Juan Zaragueta kalea', NULL, '20069', 'Juan Zaragueta kalea 3', '20014', 43.31139, -1.9728, 'address', 'openstreetmap:node/12520264295'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-12855110651', 'Carrefour Irun – Eihera plaza', NULL, '20045', 'Eihera plaza 13', '20305', 43.33647, -1.81961, 'address', 'openstreetmap:node/12855110651'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-13925366921', 'Carrefour Irun – Lope de Primaut kalea', NULL, '20045', 'Lope de Primaut kalea 2', '20303', 43.3345, -1.79501, 'address', 'openstreetmap:node/13925366921'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-1801148078', 'Carrefour Donostia / San Sebastián – Zarautz kalea', NULL, '20069', 'Zarautz kalea 88', '20018', 43.30504, -2.0052, 'address', 'openstreetmap:node/1801148078'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-3323804269', 'Carrefour Irun – Alzukaitz kalea', NULL, '20045', 'Alzukaitz kalea 15', '20305', 43.33706, -1.78093, 'address', 'openstreetmap:node/3323804269'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-3323804270', 'Carrefour Irun – Sebastián Errazu', NULL, '20045', 'Sebastián Errazu 2', '20302', 43.33888, -1.79794, 'address', 'openstreetmap:node/3323804270'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-3359962805', 'Carrefour Donostia / San Sebastián – Usandizaga kalea', NULL, '20069', 'Usandizaga kalea 17', '20002', 43.32387, -1.97714, 'address', 'openstreetmap:node/3359962805'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-4159969789', 'Carrefour Ibarra – Euskal Herria kalea', NULL, '20042', 'Euskal Herria kalea 17', '20400', 43.13322, -2.06895, 'address', 'openstreetmap:node/4159969789'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-5173717995', 'Decathlon Donostia / San Sebastián – San Martzial kalea', NULL, '20069', 'San Martzial kalea 21', '20005', 43.31888, -1.98155, 'address', 'openstreetmap:node/5173717995'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-5756050419', 'Carrefour Zarautz – Gipuzkoa kalea', NULL, '20079', 'Gipuzkoa kalea 12', '20800', 43.28479, -2.17213, 'address', 'openstreetmap:node/5756050419'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-619801662', 'Carrefour Donostia / San Sebastián – Boulevard zumardia', NULL, '20069', 'Boulevard zumardia 17', '20003', 43.32198, -1.98381, 'address', 'openstreetmap:node/619801662'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-9434701749', 'Carrefour Andoain – Arteta kalea', NULL, '20009', 'Arteta kalea 9', '20140', 43.22167, -2.02127, 'address', 'openstreetmap:node/9434701749'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-1125280125', 'Carrefour Andoain – Aranaztegi hiribidea', NULL, '20009', 'Aranaztegi hiribidea 15', '20140', 43.23186, -1.99992, 'address', 'openstreetmap:way/1125280125'),
  ('IKEA', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-1249995120', 'IKEA Donostia / San Sebastián – Garbera zeharbidea', NULL, '20069', 'Garbera zeharbidea', NULL, 43.30892, -1.94651, 'address', 'openstreetmap:way/1249995120'),
  ('Leroy Merlin', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-200462947', 'Leroy Merlin Oiartzun – 12A', NULL, '20063', '12A', '20180', 43.31348, -1.87559, 'address', 'openstreetmap:way/200462947'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-242651251', 'Carrefour Olaberria – Poligono IÐausti', NULL, '20058', 'Poligono IÐausti', '20212', 43.03351, -2.21752, 'address', 'openstreetmap:way/242651251'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-32873927', 'Decathlon Donostia / San Sebastián – Fernando Mugica kalea', NULL, '20069', 'Fernando Mugica kalea 2', '20018', 43.27969, -2.01384, 'address', 'openstreetmap:way/32873927'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-33136929', 'Carrefour Oiartzun – Lintzirin poligonoa', NULL, '20063', 'Lintzirin poligonoa 11', '20180', 43.31479, -1.87941, 'address', 'openstreetmap:way/33136929'),
  ('MediaMarkt', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-34867796', 'MediaMarkt Donostia / San Sebastián – Garbera zeharbidea', NULL, '20069', 'Garbera zeharbidea 1', '20017', 43.30789, -1.9443, 'address', 'openstreetmap:way/34867796'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-354561576', 'Carrefour Tolosa – Larramendi kalea', NULL, '20071', 'Larramendi kalea 32', '20400', 43.14659, -2.0713, 'address', 'openstreetmap:way/354561576'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-37743377', 'Decathlon Irun', NULL, '20045', NULL, '20305', 43.32059, -1.83797, 'address', 'openstreetmap:way/37743377');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '20');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 20 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '20'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 22 THEN
    RAISE EXCEPTION 'Se esperaban 22 puntos de (varias) en Gipuzkoa, hay %', n;
  END IF;
END;
$$;

COMMIT;
