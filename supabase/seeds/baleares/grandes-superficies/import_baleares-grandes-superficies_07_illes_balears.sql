-- Carga de la categoría (varias) de Illes Balears (provincia 07), trozo de la carga de Andalucía.
-- Origen: baleares-grandes-superficies-baleares.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 34 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:node-10743482025', 'Carrefour Palma – Carrer de Blanquerna', NULL, '07040', 'Carrer de Blanquerna 56', '07010', 39.58279, 2.64907, 'address', 'openstreetmap:node/10743482025'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:node-1075471259', 'Carrefour Palma – Plaça Sant Pere Claver', NULL, '07040', 'Plaça Sant Pere Claver', '07015', 39.55128, 2.62152, 'address', 'openstreetmap:node/1075471259'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:node-12362295642', 'Carrefour Palma – carrer de la Caravel·la', NULL, '07040', 'carrer de la Caravel·la 6', '07610', 39.5319, 2.72724, 'address', 'openstreetmap:node/12362295642'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:node-13022452216', 'Carrefour Maó – Avinguda Josep Anselm Clavé', NULL, '07032', 'Avinguda Josep Anselm Clavé 116', '07703', 39.882, 4.25945, 'address', 'openstreetmap:node/13022452216'),
  ('Decathlon', 'catalogo-baleares:baleares-grandes-superficies:node-13397462981', 'Decathlon Palma – Carrer dels Caputxins', NULL, '07040', 'Carrer dels Caputxins 5', '07002', 39.57439, 2.65296, 'address', 'openstreetmap:node/13397462981'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:node-13507111102', 'Carrefour Palma – Carrer de Maria Antonia Salvà', NULL, '07040', 'Carrer de Maria Antonia Salvà 2', '07011', 39.59493, 2.61707, 'address', 'openstreetmap:node/13507111102'),
  ('MediaMarkt', 'catalogo-baleares:baleares-grandes-superficies:node-2011310860', 'MediaMarkt Palma – Carrer de Sor Catalina Maura', NULL, '07040', 'Carrer de Sor Catalina Maura 2', '07010', 39.59537, 2.64813, 'address', 'openstreetmap:node/2011310860'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:node-2092629543', 'Carrefour Sineu – Carrer Major', NULL, '07060', 'Carrer Major 21', '07510', 39.64381, 3.01127, 'address', 'openstreetmap:node/2092629543'),
  ('El Corte Inglés', 'catalogo-baleares:baleares-grandes-superficies:node-2243153720', 'El Corte Inglés Palma', NULL, '07040', NULL, NULL, 39.54948, 2.73611, 'address', 'openstreetmap:node/2243153720'),
  ('El Corte Inglés', 'catalogo-baleares:baleares-grandes-superficies:node-2271740396', 'El Corte Inglés Calvià', NULL, '07011', NULL, '07180', 39.48951, 2.47889, 'address', 'openstreetmap:node/2271740396'),
  ('El Corte Inglés', 'catalogo-baleares:baleares-grandes-superficies:node-3748050261', 'El Corte Inglés Marratxí', NULL, '07036', NULL, '07141', 39.63231, 2.73269, 'address', 'openstreetmap:node/3748050261'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:node-3859503595', 'Carrefour Palma – Carrer del Gremi de Tintorers', NULL, '07040', 'Carrer del Gremi de Tintorers 13', NULL, 39.60612, 2.67438, 'address', 'openstreetmap:node/3859503595'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:node-461811069', 'Carrefour Palma – Carrer del Cardenal Rossell', NULL, '07040', 'Carrer del Cardenal Rossell 168', '07007', 39.55252, 2.70632, 'address', 'openstreetmap:node/461811069'),
  ('El Corte Inglés', 'catalogo-baleares:baleares-grandes-superficies:node-5658227505', 'El Corte Inglés Andratx – avinguda de Gabriel Roca i Garcias', NULL, '07005', 'avinguda de Gabriel Roca i Garcias', NULL, 39.54737, 2.38244, 'address', 'openstreetmap:node/5658227505'),
  ('Decathlon', 'catalogo-baleares:baleares-grandes-superficies:node-6542386044', 'Decathlon Maó – Carrer Bèlgica', NULL, '07032', 'Carrer Bèlgica', '07714', 39.88546, 4.23536, 'address', 'openstreetmap:node/6542386044'),
  ('Decathlon', 'catalogo-baleares:baleares-grandes-superficies:node-7383297322', 'Decathlon Palma – Avinguda de Jaume III', NULL, '07040', 'Avinguda de Jaume III 21', '07012', 39.57229, 2.64338, 'address', 'openstreetmap:node/7383297322'),
  ('Decathlon', 'catalogo-baleares:baleares-grandes-superficies:node-7797483985', 'Decathlon Palma – Carrer del Cardenal Rossell', NULL, '07040', 'Carrer del Cardenal Rossell 168', '07007', 39.55266, 2.70666, 'address', 'openstreetmap:node/7797483985'),
  ('Decathlon', 'catalogo-baleares:baleares-grandes-superficies:node-986004922', 'Decathlon Palma – Camí de Jesús', NULL, '07040', 'Camí de Jesús 12', NULL, 39.59211, 2.63387, 'address', 'openstreetmap:node/986004922'),
  ('El Corte Inglés', 'catalogo-baleares:baleares-grandes-superficies:way-115392399', 'El Corte Inglés Palma – Avinguda d''Alexandre Rosselló', NULL, '07040', 'Avinguda d''Alexandre Rosselló 12', '07002', 39.57352, 2.65664, 'address', 'openstreetmap:way/115392399'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:way-1224447250', 'Carrefour Llucmajor – Carrer de Sant Llorenç', NULL, '07031', 'Carrer de Sant Llorenç 95', '07620', 39.48594, 2.89556, 'address', 'openstreetmap:way/1224447250'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:way-1224893797', 'Carrefour Andratx – Carrer de Llevant', NULL, '07005', 'Carrer de Llevant 9', '07157', 39.54391, 2.39039, 'address', 'openstreetmap:way/1224893797'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:way-157608940', 'Carrefour ses Salines – Carrer Bonança', NULL, '07059', 'Carrer Bonança', '07638', 39.31701, 2.99666, 'address', 'openstreetmap:way/157608940'),
  ('Leroy Merlin', 'catalogo-baleares:baleares-grandes-superficies:way-178601045', 'Leroy Merlin Marratxí – Carrer de Gabriel Viñas', NULL, '07036', 'Carrer de Gabriel Viñas', NULL, 39.61541, 2.7068, 'address', 'openstreetmap:way/178601045'),
  ('IKEA', 'catalogo-baleares:baleares-grandes-superficies:way-323893411', 'IKEA Eivissa – Carrer de l''Alcalde Bartomeu de Rosselló Sala', NULL, '07026', 'Carrer de l''Alcalde Bartomeu de Rosselló Sala 1', '07800', 38.91824, 1.43655, 'address', 'openstreetmap:way/323893411'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:way-356861025', 'Carrefour Sant Llorenç des Cardassar – Avinguda de les Palmeres', NULL, '07051', 'Avinguda de les Palmeres', '07560', 39.58014, 3.37291, 'address', 'openstreetmap:way/356861025'),
  ('IKEA', 'catalogo-baleares:baleares-grandes-superficies:way-370942116', 'IKEA Palma – Carrer de Miquel Miravet 10F', NULL, '07040', 'Carrer de Miquel Miravet 10F', NULL, 39.56598, 2.67842, 'address', 'openstreetmap:way/370942116'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:way-478727143', 'Carrefour Inca – Carrer de Costa i Llobera', NULL, '07027', 'Carrer de Costa i Llobera 121', '07300', 39.71731, 2.90427, 'address', 'openstreetmap:way/478727143'),
  ('Decathlon', 'catalogo-baleares:baleares-grandes-superficies:way-494890871', 'Decathlon Santa Eulària des Riu – Carrer de la Mar Mediterrània', NULL, '07054', 'Carrer de la Mar Mediterrània 38', '07813', 38.92269, 1.43427, 'address', 'openstreetmap:way/494890871'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:way-49864873', 'Carrefour Palma – carrer de Joan Muntaner i Bujosa', NULL, '07040', 'carrer de Joan Muntaner i Bujosa 1', '07011', 39.58245, 2.63261, 'address', 'openstreetmap:way/49864873'),
  ('Carrefour', 'catalogo-baleares:baleares-grandes-superficies:way-54518213', 'Carrefour Palma – Carrer del General Riera', NULL, '07040', 'Carrer del General Riera 152', '07010', 39.59418, 2.64479, 'address', 'openstreetmap:way/54518213'),
  ('Leroy Merlin', 'catalogo-baleares:baleares-grandes-superficies:way-54681213', 'Leroy Merlin Palma – Carrer del Bisbe Pere de Puigdorfila', NULL, '07040', 'Carrer del Bisbe Pere de Puigdorfila', '07010', 39.59598, 2.64947, 'address', 'openstreetmap:way/54681213'),
  ('IKEA', 'catalogo-baleares:baleares-grandes-superficies:way-631007927', 'IKEA Maó – Carrer d''Àustria', NULL, '07032', 'Carrer d''Àustria 8', '07714', 39.8893, 4.23773, 'address', 'openstreetmap:way/631007927'),
  ('Decathlon', 'catalogo-baleares:baleares-grandes-superficies:way-760779626', 'Decathlon Marratxí', NULL, '07036', NULL, '07141', 39.61535, 2.70585, 'address', 'openstreetmap:way/760779626'),
  ('El Corte Inglés', 'catalogo-baleares:baleares-grandes-superficies:way-89068139', 'El Corte Inglés Palma – Avinguda de Jaume III', NULL, '07040', 'Avinguda de Jaume III 15', '07012', 39.57204, 2.64423, 'address', 'openstreetmap:way/89068139');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '07');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 07 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '07'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 34 THEN
    RAISE EXCEPTION 'Se esperaban 34 puntos de (varias) en Illes Balears, hay %', n;
  END IF;
END;
$$;

COMMIT;
