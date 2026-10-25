-- Carga de la categoría Estaciones de Illes Balears (provincia 07), trozo de la carga de Andalucía.
-- Origen: estaciones-baleares.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 33 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-baleares:estaciones:node-11269865264', 'Estación de tren de Constància / Hospital d’Inca – Carretera Palma - Alcúdia', 'Tren', '07027', 'Carretera Palma - Alcúdia', '07300', 39.71481, 2.91473, 'address', 'openstreetmap:node/11269865264'),
  ('catalogo-baleares:estaciones:node-13595296210', 'Estación de tren de Son Sardina (Palma) – Carretera de Sóller', 'Tren', '07040', 'Carretera de Sóller 179', '07002', 39.6203, 2.66095, 'address', 'openstreetmap:node/13595296210'),
  ('catalogo-baleares:estaciones:node-13718285901', 'Estación de autobuses de Servicio de transporte para alquiler de coches (Palma)', 'Autobús', '07040', NULL, '07002', 39.54591, 2.72954, 'address', 'openstreetmap:node/13718285901'),
  ('catalogo-baleares:estaciones:node-13926992525', 'Estación de tren de Llubí (Inca) – Camí de s''Ermita', 'Tren', '07027', 'Camí de s''Ermita', NULL, 39.71155, 2.99425, 'address', 'openstreetmap:node/13926992525'),
  ('catalogo-baleares:estaciones:node-14022668773', 'Entrada Estación Intermodal (Palma) – Pl. d''Espanya', 'Autobús', '07040', 'Pl. d''Espanya', '07002', 39.57629, 2.65412, 'address', 'openstreetmap:node/14022668773'),
  ('catalogo-baleares:estaciones:node-1550465165', 'Estación de tren de Sa Coma / Santa Maria (Bunyola) – carrer d''es Murta', 'Tren', '07010', 'carrer d''es Murta', '07193', 39.66734, 2.68357, 'address', 'openstreetmap:node/1550465165'),
  ('catalogo-baleares:estaciones:node-295249249', 'Estación de tren de Bunyola – Carrer de l''Estació', 'Tren', '07010', 'Carrer de l''Estació', NULL, 39.69745, 2.69415, 'address', 'openstreetmap:node/295249249'),
  ('catalogo-baleares:estaciones:node-295249299', 'Estación de tren de Mirador des Pujol d’en Banya (Sóller)', 'Tren', '07061', NULL, NULL, 39.76059, 2.70635, 'address', 'openstreetmap:node/295249299'),
  ('catalogo-baleares:estaciones:node-295249363', 'Estación de tren de Sóller – Plaça d''Espanya', 'Tren', '07061', 'Plaça d''Espanya 6', '07100', 39.76468, 2.71512, 'address', 'openstreetmap:node/295249363'),
  ('catalogo-baleares:estaciones:node-297351175', 'Estación de tren de Caubet (Bunyola)', 'Tren', '07010', NULL, NULL, 39.67412, 2.68519, 'address', 'openstreetmap:node/297351175'),
  ('catalogo-baleares:estaciones:node-2990597927', 'Estación de tren de Son Reus (Palma)', 'Tren', '07040', NULL, '07002', 39.6379, 2.6683, 'address', 'openstreetmap:node/2990597927'),
  ('catalogo-baleares:estaciones:node-2990602242', 'Estación de tren de Can Tambor (Sóller) – Camí de Son Pons', 'Tren', '07061', 'Camí de Son Pons', NULL, 39.76299, 2.70879, 'address', 'openstreetmap:node/2990602242'),
  ('catalogo-baleares:estaciones:node-4327711505', 'Estación de tren de Enllaç (Inca) – Camí de s''Empalme', 'Tren', '07027', 'Camí de s''Empalme', NULL, 39.69067, 2.95126, 'address', 'openstreetmap:node/4327711505'),
  ('catalogo-baleares:estaciones:node-4329414305', 'Estación de tren de Inca – Carrer des Tren 25,27', 'Tren', '07027', 'Carrer des Tren 25,27', '07300', 39.7181, 2.90584, 'address', 'openstreetmap:node/4329414305'),
  ('catalogo-baleares:estaciones:node-4455669566', 'Estación de tren de Sa Pobla – Ronda Sud (SE)', 'Tren', '07044', 'Ronda Sud (SE) 4', '07420', 39.76447, 3.02926, 'address', 'openstreetmap:node/4455669566'),
  ('catalogo-baleares:estaciones:node-4889927721', 'Estació d''autobusos (Santa Eulària des Riu) – Avinguda d''es Canar', 'Autobús', '07054', 'Avinguda d''es Canar 118', '07849', 39.00138, 1.57689, 'address', 'openstreetmap:node/4889927721'),
  ('catalogo-baleares:estaciones:node-5216013158', 'Estación de tren de Palma – Carrer d''Eusebi Estada', 'Tren', '07040', 'Carrer d''Eusebi Estada 1', '07002', 39.5768, 2.65387, 'approximate', 'openstreetmap:node/5216013158'),
  ('catalogo-baleares:estaciones:node-5263686386', 'Estación de tren de Plaça d''Espanya (Palma) – Pl. d''Espanya', 'Tren', '07040', 'Pl. d''Espanya', '07002', 39.57646, 2.65436, 'approximate', 'openstreetmap:node/5263686386'),
  ('catalogo-baleares:estaciones:node-748204748', 'Estación de tren de Muro', 'Tren', '07039', NULL, NULL, 39.73416, 3.03208, 'address', 'openstreetmap:node/748204748'),
  ('catalogo-baleares:estaciones:node-8045369950', 'Estación de tren de Sineu – carrer Gran', 'Tren', '07060', 'carrer Gran 9', '07510', 39.6437, 3.01437, 'address', 'openstreetmap:node/8045369950'),
  ('catalogo-baleares:estaciones:node-8045369959', 'Estación de tren de Petra', 'Tren', '07041', NULL, NULL, 39.61817, 3.11091, 'address', 'openstreetmap:node/8045369959'),
  ('catalogo-baleares:estaciones:node-8048732329', 'Estación de tren de Santa Maria (Santa Maria del Camí) – Carrer de Bearn', 'Tren', '07056', 'Carrer de Bearn 13', '07320', 39.65317, 2.77409, 'address', 'openstreetmap:node/8048732329'),
  ('catalogo-baleares:estaciones:node-8048752171', 'Estación de tren de Es Pont d''Inca Nou (Marratxí) – Carrer Son Frau', 'Tren', '07036', 'Carrer Son Frau', NULL, 39.60449, 2.70155, 'address', 'openstreetmap:node/8048752171'),
  ('catalogo-baleares:estaciones:node-8048763086', 'Estación de tren de Binissalem – carrer de Gaspar Vallès "es Torero"', 'Tren', '07008', 'carrer de Gaspar Vallès "es Torero" 15', '07350', 39.69249, 2.84122, 'address', 'openstreetmap:node/8048763086'),
  ('catalogo-baleares:estaciones:node-8048771452', 'Estación de tren de Consell/Alaró – camí de Son Jordi', 'Tren', '07016', 'camí de Son Jordi', NULL, 39.67767, 2.80865, 'address', 'openstreetmap:node/8048771452'),
  ('catalogo-baleares:estaciones:node-8048771641', 'Estación de tren de Marratxí – carrer del Comte de Villardompardo', 'Tren', '07036', 'carrer del Comte de Villardompardo', NULL, 39.62539, 2.72547, 'address', 'openstreetmap:node/8048771641'),
  ('catalogo-baleares:estaciones:node-8048772619', 'Estación de tren de Lloseta – Carrer Truiola', 'Tren', '07029', 'Carrer Truiola', NULL, 39.71634, 2.86918, 'address', 'openstreetmap:node/8048772619'),
  ('catalogo-baleares:estaciones:node-8048775801', 'Estación de tren de Es Caülls (Marratxí)', 'Tren', '07036', NULL, NULL, 39.63204, 2.73649, 'address', 'openstreetmap:node/8048775801'),
  ('catalogo-baleares:estaciones:node-9498118566', 'Estación de tren de Manacor – passeig de s''Estació', 'Tren', '07033', 'passeig de s''Estació', '07500', 39.57056, 3.20284, 'address', 'openstreetmap:node/9498118566'),
  ('catalogo-baleares:estaciones:node-9760182063', 'Estación de tren de Alfàbia (Bunyola) – Carretera Palma - Port de Sóller', 'Tren', '07010', 'Carretera Palma - Port de Sóller', NULL, 39.71511, 2.69137, 'address', 'openstreetmap:node/9760182063'),
  ('catalogo-baleares:estaciones:way-1216587414', 'Estació d''autobusos de Ciutadella de Menorca – Carrer de Josepa Rossinyol', 'Autobús', '07015', 'Carrer de Josepa Rossinyol 29', '07760', 39.99819, 3.83913, 'address', 'openstreetmap:way/1216587414'),
  ('catalogo-baleares:estaciones:way-158347670', 'CETIS Bus station (Eivissa) – Carrer de Canàries', 'Autobús', '07026', 'Carrer de Canàries 35', '07800', 38.91188, 1.42472, 'address', 'openstreetmap:way/158347670'),
  ('catalogo-baleares:estaciones:way-41859774', 'Estació Autobusos (Maó) – Plaça Esplanada', 'Autobús', '07032', 'Plaça Esplanada', '07703', 39.88685, 4.25835, 'address', 'openstreetmap:way/41859774');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 33 THEN
    RAISE EXCEPTION 'Se esperaban 33 puntos de Estaciones en Illes Balears, hay %', n;
  END IF;
END;
$$;

COMMIT;
