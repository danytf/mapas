-- Carga de la categoría (varias) de Cantabria (provincia 39), trozo de la carga de Andalucía.
-- Origen: cantabria-grandes-superficies-cantabria.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 25 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-11348206900', 'Carrefour Bareyo – Avenida Benedicto Ruiz', NULL, '39011', 'Avenida Benedicto Ruiz 517', '39170', 43.48062, -3.61252, 'address', 'openstreetmap:node/11348206900'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-11497517169', 'Carrefour Santander – Calle del Marqués de la Hermida', NULL, '39075', 'Calle del Marqués de la Hermida 14', '39009', 43.45547, -3.81393, 'address', 'openstreetmap:node/11497517169'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-11828781498', 'Carrefour Santander – Calle de Gerona', NULL, '39075', 'Calle de Gerona 13', '39004', 43.46626, -3.79008, 'address', 'openstreetmap:node/11828781498'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-12647754348', 'Carrefour Ribamontán al Monte – Barrio La Sota', NULL, '39062', 'Barrio La Sota', '39794', 43.39109, -3.66515, 'address', 'openstreetmap:node/12647754348'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-12956616104', 'Carrefour Piélagos – Urbanización La Mina', NULL, '39052', 'Urbanización La Mina', NULL, 43.41364, -3.94561, 'address', 'openstreetmap:node/12956616104'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-13250006950', 'Carrefour Camargo – Avenida de Bilbao', NULL, '39016', 'Avenida de Bilbao 64', '39600', 43.41685, -3.8455, 'address', 'openstreetmap:node/13250006950'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-1773085422', 'Carrefour Castro-Urdiales – Calle de La Ronda', NULL, '39020', 'Calle de La Ronda 32', '39700', 43.38061, -3.21973, 'address', 'openstreetmap:node/1773085422'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-1800298569', 'Carrefour Santander – Centro Comercial Carrefour El Alisal', NULL, '39075', 'Centro Comercial Carrefour El Alisal', '39011', 43.45812, -3.86196, 'address', 'openstreetmap:node/1800298569'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-1800298590', 'Carrefour Santander – Centro Comercial Peñacastillo', NULL, '39075', 'Centro Comercial Peñacastillo', '39011', 43.44548, -3.85428, 'address', 'openstreetmap:node/1800298590'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-1800298626', 'Carrefour Camargo – Calle de Alday', NULL, '39016', 'Calle de Alday', NULL, 43.42719, -3.83807, 'address', 'openstreetmap:node/1800298626'),
  ('Leroy Merlin', 'catalogo-cantabria:cantabria-grandes-superficies:node-1800298708', 'Leroy Merlin Camargo – Calle de Alday', NULL, '39016', 'Calle de Alday', '39600', 43.42845, -3.84016, 'address', 'openstreetmap:node/1800298708'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-2320483146', 'Carrefour Liérganes – Calle del Doctor Martinez Bernal', NULL, '39037', 'Calle del Doctor Martinez Bernal', '39722', 43.34727, -3.74676, 'address', 'openstreetmap:node/2320483146'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-2595425525', 'Carrefour Santander – Avenida de los Castros', NULL, '39075', 'Avenida de los Castros 79', '39005', 43.46963, -3.80729, 'address', 'openstreetmap:node/2595425525'),
  ('El Corte Inglés', 'catalogo-cantabria:cantabria-grandes-superficies:node-262959237', 'El Corte Inglés Santander – Centro Comercial Bahía de Santander', NULL, '39075', 'Centro Comercial Bahía de Santander', '39011', 43.43837, -3.83903, 'address', 'openstreetmap:node/262959237'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-2781109622', 'Carrefour Noja – Calle del Cine', NULL, '39047', 'Calle del Cine 2', '39180', 43.48092, -3.52279, 'address', 'openstreetmap:node/2781109622'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-5181782068', 'Carrefour Castro-Urdiales – Subida Campijo 3 5 / 6 /', NULL, '39020', 'Subida Campijo 3 5 / 6 / 7', '39700', 43.38773, -3.23173, 'address', 'openstreetmap:node/5181782068'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-705088923', 'Carrefour Santander – Calle de Jesús de Monasterio', NULL, '39075', 'Calle de Jesús de Monasterio 25', '39008', 43.46159, -3.8132, 'address', 'openstreetmap:node/705088923'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:node-9907212300', 'Carrefour Noja – Avenida Ris', NULL, '39047', 'Avenida Ris 8', '39180', 43.48159, -3.52882, 'address', 'openstreetmap:node/9907212300'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:way-1020589594', 'Carrefour Santander – Calle de Josefina de la Maza', NULL, '39075', 'Calle de Josefina de la Maza 4', '39012', 43.46711, -3.83396, 'address', 'openstreetmap:way/1020589594'),
  ('Decathlon', 'catalogo-cantabria:cantabria-grandes-superficies:way-244052834', 'Decathlon Santander – Calle de Joaquín Rodrigo', NULL, '39075', 'Calle de Joaquín Rodrigo 4', '39011', 43.45582, -3.86466, 'address', 'openstreetmap:way/244052834'),
  ('MediaMarkt', 'catalogo-cantabria:cantabria-grandes-superficies:way-244052837', 'MediaMarkt Santander – Calle de Joaquín Rodrigo', NULL, '39075', 'Calle de Joaquín Rodrigo 10', '39011', 43.45516, -3.8661, 'address', 'openstreetmap:way/244052837'),
  ('IKEA', 'catalogo-cantabria:cantabria-grandes-superficies:way-244052841', 'IKEA Santander – Calle de Joaquín Rodrigo', NULL, '39075', 'Calle de Joaquín Rodrigo 8', '39011', 43.45526, -3.8656, 'address', 'openstreetmap:way/244052841'),
  ('Carrefour', 'catalogo-cantabria:cantabria-grandes-superficies:way-636529885', 'Carrefour Torrelavega – Barrio Sierrapando', NULL, '39087', 'Barrio Sierrapando', '39300', 43.3413, -4.03285, 'address', 'openstreetmap:way/636529885'),
  ('Leroy Merlin', 'catalogo-cantabria:cantabria-grandes-superficies:way-657047326', 'Leroy Merlin Torrelavega – Avenida de Bilbao', NULL, '39087', 'Avenida de Bilbao 124', '39300', 43.33994, -4.02965, 'address', 'openstreetmap:way/657047326'),
  ('Decathlon', 'catalogo-cantabria:cantabria-grandes-superficies:way-671932020', 'Decathlon Torrelavega – Área Comercial La Maderera', NULL, '39087', 'Área Comercial La Maderera', '39300', 43.35851, -4.06367, 'address', 'openstreetmap:way/671932020');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '39');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 39 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '39'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 25 THEN
    RAISE EXCEPTION 'Se esperaban 25 puntos de (varias) en Cantabria, hay %', n;
  END IF;
END;
$$;

COMMIT;
