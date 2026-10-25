-- Carga de la categoría (varias) de Tarragona (provincia 43), trozo de la carga de Andalucía.
-- Origen: cataluna-grandes-superficies-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 22 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-10129688393', 'Carrefour Reus – Raval de Santa Anna', NULL, '43123', 'Raval de Santa Anna 42', '43201', 41.15676, 1.10926, 'address', 'openstreetmap:node/10129688393'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-10707783804', 'Carrefour Tarragona – Carrer A', NULL, '43148', 'Carrer A', NULL, 41.12814, 1.20724, 'address', 'openstreetmap:node/10707783804'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-11380101303', 'IKEA Tarragona – Avinguda Ramón y Cajal', NULL, '43148', 'Avinguda Ramón y Cajal 55', '43005', 41.1162, 1.24275, 'address', 'openstreetmap:node/11380101303'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-12106638502', 'IKEA Tarragona – Carrer Cardenal Vidal i Barraquer', NULL, '43148', 'Carrer Cardenal Vidal i Barraquer 15', '43005', 41.117, 1.23886, 'address', 'openstreetmap:node/12106638502'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1552739079', 'Carrefour el Vendrell – Carretera de Tarragona', NULL, '43163', 'Carretera de Tarragona 4', '43700', 41.214, 1.53453, 'address', 'openstreetmap:node/1552739079'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-2858648554', 'Decathlon Vila-seca – Avinguda de l''Alcalde Pere Molas', NULL, '43171', 'Avinguda de l''Alcalde Pere Molas 36', '43480', 41.0963, 1.151, 'address', 'openstreetmap:node/2858648554'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-2953789252', 'Carrefour Calafell – Carrer del Rin', NULL, '43037', 'Carrer del Rin 7', '43882', 41.19051, 1.60449, 'address', 'openstreetmap:node/2953789252'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4346499997', 'Carrefour Tarragona – Carrer d''August', NULL, '43148', 'Carrer d''August 13', '43003', 41.11584, 1.25401, 'address', 'openstreetmap:node/4346499997'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5736258164', 'Carrefour Reus – Carrer del Vent', NULL, '43123', 'Carrer del Vent 12', '43201', 41.15367, 1.10687, 'address', 'openstreetmap:node/5736258164'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-986951788', 'Carrefour Tarragona – Plaça Imperial Tarraco', NULL, '43148', 'Plaça Imperial Tarraco 2', '43002', 41.11975, 1.24525, 'address', 'openstreetmap:node/986951788'),
  ('El Corte Inglés', 'catalogo-cataluna:cataluna-grandes-superficies:way-177327926', 'El Corte Inglés Tarragona – Avinguda República Argentina', NULL, '43148', 'Avinguda República Argentina', '43005', 41.12162, 1.2422, 'address', 'openstreetmap:way/177327926'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-199316566', 'Decathlon Reus – Carrer de Mèxic', NULL, '43123', 'Carrer de Mèxic', '43204', 41.14497, 1.12644, 'address', 'openstreetmap:way/199316566'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-199356749', 'Carrefour Reus – Avinguda Marià Fortuny', NULL, '43123', 'Avinguda Marià Fortuny 81', '43204', 41.16208, 1.11475, 'address', 'openstreetmap:way/199356749'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-292490790', 'Carrefour Torredembarra – Passeig de Miramar', NULL, '43153', 'Passeig de Miramar', NULL, 41.14786, 1.41363, 'address', 'openstreetmap:way/292490790'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-517088336', 'Leroy Merlin Roda de Berà – Carrer de Maria Callas', NULL, '43131', 'Carrer de Maria Callas 2', '43883', 41.17875, 1.48959, 'address', 'openstreetmap:way/517088336'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-634392146', 'Decathlon Tortosa', NULL, '43155', NULL, '43500', 40.79259, 0.52213, 'address', 'openstreetmap:way/634392146'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-78353752', 'Leroy Merlin Tarragona – Carrer de Josep Maria Folch i Torres', NULL, '43148', 'Carrer de Josep Maria Folch i Torres', '43120', 41.13127, 1.20347, 'address', 'openstreetmap:way/78353752'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-78353780', 'MediaMarkt Tarragona – Carrer de Josep Maria Folch i Torres', NULL, '43148', 'Carrer de Josep Maria Folch i Torres', '43120', 41.13254, 1.20245, 'address', 'openstreetmap:way/78353780'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-78353821', 'Decathlon Tarragona – Carrer de Joan Amades i Gelats', NULL, '43148', 'Carrer de Joan Amades i Gelats', NULL, 41.12995, 1.20203, 'address', 'openstreetmap:way/78353821'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-842750588', 'Leroy Merlin Tortosa – Avinguda de la Generalitat', NULL, '43155', 'Avinguda de la Generalitat', '43518', 40.79963, 0.52108, 'address', 'openstreetmap:way/842750588'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-863294694', 'Carrefour Valls – Carrer Francesc Gumà Ferran', NULL, '43161', 'Carrer Francesc Gumà Ferran', '43800', 41.29169, 1.25861, 'address', 'openstreetmap:way/863294694'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-964761131', 'Carrefour Tarragona – Carrer Deltebre 33-35', NULL, '43148', 'Carrer Deltebre 33-35', '43006', 41.12427, 1.21241, 'address', 'openstreetmap:way/964761131');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '43');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 43 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '43'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 22 THEN
    RAISE EXCEPTION 'Se esperaban 22 puntos de (varias) en Tarragona, hay %', n;
  END IF;
END;
$$;

COMMIT;
