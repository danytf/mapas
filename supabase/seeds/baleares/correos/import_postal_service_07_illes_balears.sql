-- Carga de la categoría Correos de Illes Balears (provincia 07), trozo de la carga de Andalucía.
-- Origen: postal_service-baleares.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 53 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-baleares:postal_service:node-10592350955', 'Correos Santa Eulària des Riu – Carrer Vénda des Poble', NULL, '07054', 'Carrer Vénda des Poble 6', '07814', 38.99725, 1.42864, 'address', 'openstreetmap:node/10592350955'),
  ('catalogo-baleares:postal_service:node-1146317538', 'Correos Manacor – carrer Nou', NULL, '07033', 'carrer Nou 18', '07500', 39.56824, 3.20764, 'address', 'openstreetmap:node/1146317538'),
  ('catalogo-baleares:postal_service:node-11838231450', 'Correos Sant Joan de Labritja – Carrer d''Eivissa', NULL, '07050', 'Carrer d''Eivissa 7', '07810', 39.07737, 1.51221, 'address', 'openstreetmap:node/11838231450'),
  ('catalogo-baleares:postal_service:node-1224505921', 'Correos Palma – Plaça Progrés', NULL, '07040', 'Plaça Progrés 24', '07013', 39.57249, 2.63587, 'address', 'openstreetmap:node/1224505921'),
  ('catalogo-baleares:postal_service:node-1249626873', 'Correos Esporles – Carrer Joan Riutort', NULL, '07020', 'Carrer Joan Riutort 11', '07190', 39.66818, 2.57765, 'address', 'openstreetmap:node/1249626873'),
  ('catalogo-baleares:postal_service:node-13690678602', 'Correos Palma – Avinguda d''Alexandre Rosselló', NULL, '07040', 'Avinguda d''Alexandre Rosselló 12', '07002', 39.5736, 2.65658, 'address', 'openstreetmap:node/13690678602'),
  ('catalogo-baleares:postal_service:node-1380723207', 'Correos Muro – Plaça de ses Fotges', NULL, '07039', 'Plaça de ses Fotges', '07458', 39.80791, 3.1162, 'address', 'openstreetmap:node/1380723207'),
  ('catalogo-baleares:postal_service:node-1425701761', 'Correos Pollença – Carrer de Rubén Darío', NULL, '07042', 'Carrer de Rubén Darío', '07470', 39.9087, 3.0811, 'address', 'openstreetmap:node/1425701761'),
  ('catalogo-baleares:postal_service:node-1425704595', 'Correos Pollença – carrer de Formentor', NULL, '07042', 'carrer de Formentor 43', '07470', 39.90866, 3.08336, 'address', 'openstreetmap:node/1425704595'),
  ('catalogo-baleares:postal_service:node-1441927178', 'Correos es Mercadal – Carrer Lepant', NULL, '07037', 'Carrer Lepant 43', '07740', 39.98503, 4.09362, 'address', 'openstreetmap:node/1441927178'),
  ('catalogo-baleares:postal_service:node-1441964234', 'Correos es Migjorn Gran – Carrer Sant Jaume', NULL, '07902', 'Carrer Sant Jaume 2', '07749', 39.94752, 4.0501, 'address', 'openstreetmap:node/1441964234'),
  ('catalogo-baleares:postal_service:node-1442142116', 'Correos Maó – Carrer Ciutadella', NULL, '07032', 'Carrer Ciutadella 76', '07701', 39.89055, 4.255, 'address', 'openstreetmap:node/1442142116'),
  ('catalogo-baleares:postal_service:node-1452576348', 'Correos ses Salines – Carrer Gabriel Roca', NULL, '07059', 'Carrer Gabriel Roca 33', '07638', 39.31574, 2.99641, 'address', 'openstreetmap:node/1452576348'),
  ('catalogo-baleares:postal_service:node-1453662853', 'Correos es Castell – Carrer de Llevant', NULL, '07064', 'Carrer de Llevant 9', '07720', 39.87792, 4.29202, 'address', 'openstreetmap:node/1453662853'),
  ('catalogo-baleares:postal_service:node-1694599149', 'Correos Palma – Carrer d''Estepona', NULL, '07040', 'Carrer d''Estepona 9', NULL, 39.55177, 2.69929, 'address', 'openstreetmap:node/1694599149'),
  ('catalogo-baleares:postal_service:node-1844684324', 'Correos Santa Eulària des Riu – Passeig de s''Alamera', NULL, '07054', 'Passeig de s''Alamera 12', '07840', 38.98402, 1.53392, 'address', 'openstreetmap:node/1844684324'),
  ('catalogo-baleares:postal_service:node-1878133101', 'Correos Capdepera – 2', NULL, '07014', '2', '07580', 39.70198, 3.43369, 'address', 'openstreetmap:node/1878133101'),
  ('catalogo-baleares:postal_service:node-1976330476', 'Correos Sóller – carrer del Vicari Pastor', NULL, '07061', 'carrer del Vicari Pastor 17', '07100', 39.76597, 2.71355, 'address', 'openstreetmap:node/1976330476'),
  ('catalogo-baleares:postal_service:node-2470150152', 'Correos Palma – Carretera de Valldemossa', NULL, '07040', 'Carretera de Valldemossa 13', '07010', 39.58679, 2.65039, 'address', 'openstreetmap:node/2470150152'),
  ('catalogo-baleares:postal_service:node-2727936378', 'Correos Alaró – Avinguda de la Constitució', NULL, '07001', 'Avinguda de la Constitució 37', '07340', 39.70423, 2.79232, 'address', 'openstreetmap:node/2727936378'),
  ('catalogo-baleares:postal_service:node-2829126994', 'Correos Consell – carrer del Rector Nadal Munar', NULL, '07016', 'carrer del Rector Nadal Munar 21', '07330', 39.66798, 2.81363, 'address', 'openstreetmap:node/2829126994'),
  ('catalogo-baleares:postal_service:node-322061725', 'Correos Deià – Carrer des Puig', NULL, '07018', 'Carrer des Puig 4', '07179', 39.74848, 2.64832, 'address', 'openstreetmap:node/322061725'),
  ('catalogo-baleares:postal_service:node-3323071162', 'Correos Eivissa – Avinguda d''Isidor Macabich', NULL, '07026', 'Avinguda d''Isidor Macabich 67', '07800', 38.90908, 1.42256, 'address', 'openstreetmap:node/3323071162'),
  ('catalogo-baleares:postal_service:node-3655699452', 'Correos Selva – Carrer Major', NULL, '07058', 'Carrer Major 2', '07314', 39.77139, 2.90344, 'address', 'openstreetmap:node/3655699452'),
  ('catalogo-baleares:postal_service:node-3977873106', 'Correos Palma – Carrer del Gremi de Ferrers', NULL, '07040', 'Carrer del Gremi de Ferrers 40', NULL, 39.6031, 2.6723, 'address', 'openstreetmap:node/3977873106'),
  ('catalogo-baleares:postal_service:node-3979453437', 'Correos Manacor – avinguda de Baix des Cós', NULL, '07033', 'avinguda de Baix des Cós 74', '07500', 39.56917, 3.21686, 'address', 'openstreetmap:node/3979453437'),
  ('catalogo-baleares:postal_service:node-4314486313', 'Correos Capdepera – Carrer Juan Sebastián Elcano', NULL, '07014', 'Carrer Juan Sebastián Elcano 63', '07590', 39.71318, 3.46417, 'address', 'openstreetmap:node/4314486313'),
  ('catalogo-baleares:postal_service:node-470293534', 'Correos Calvià – avinguda de s''Hort', NULL, '07011', 'avinguda de s''Hort', '07180', 39.51899, 2.48806, 'address', 'openstreetmap:node/470293534'),
  ('catalogo-baleares:postal_service:node-4751553857', 'Correos sa Pobla – 97', NULL, '07044', '97', '07420', 39.76858, 3.02455, 'address', 'openstreetmap:node/4751553857'),
  ('catalogo-baleares:postal_service:node-4789359423', 'Correos Formentera – Carrer des Pla del Rei', NULL, '07024', 'Carrer des Pla del Rei 114', '07860', 38.70399, 1.42868, 'address', 'openstreetmap:node/4789359423'),
  ('catalogo-baleares:postal_service:node-4825740352', 'Correos Campos – carrer de sa Síquia 11B', NULL, '07013', 'carrer de sa Síquia 11B', '07630', 39.42951, 3.0182, 'address', 'openstreetmap:node/4825740352'),
  ('catalogo-baleares:postal_service:node-514907273', 'Correos Ciutadella – Plaça des Born', NULL, '07015', 'Plaça des Born 7', '07760', 40.00036, 3.83676, 'address', 'openstreetmap:node/514907273'),
  ('catalogo-baleares:postal_service:node-5507676647', 'Correos Sant Llorenç des Cardassar – passeig de Cristòfol Colom', NULL, '07051', 'passeig de Cristòfol Colom 54', '07560', 39.59771, 3.38219, 'address', 'openstreetmap:node/5507676647'),
  ('catalogo-baleares:postal_service:node-5971770988', 'Correos Sineu – carrer de Tramuntana', NULL, '07060', 'carrer de Tramuntana 42', '07510', 39.64564, 3.00925, 'address', 'openstreetmap:node/5971770988'),
  ('catalogo-baleares:postal_service:node-699768403', 'Correos Artà – Carrer de Ciutat', NULL, '07006', 'Carrer de Ciutat', '07570', 39.69244, 3.34918, 'address', 'openstreetmap:node/699768403'),
  ('catalogo-baleares:postal_service:node-7379738003', 'Correos Palma – Avinguda de Joan Miró', NULL, '07040', 'Avinguda de Joan Miró 124', '07015', 39.55839, 2.62431, 'address', 'openstreetmap:node/7379738003'),
  ('catalogo-baleares:postal_service:node-805319983', 'Correos Sant Lluís – Carrer Lluna', NULL, '07052', 'Carrer Lluna 13', '07710', 39.85063, 4.26056, 'address', 'openstreetmap:node/805319983'),
  ('catalogo-baleares:postal_service:node-8348356421', 'Correos Santanyí – Carrer des Velar', NULL, '07057', 'Carrer des Velar', '07650', 39.35612, 3.1262, 'address', 'openstreetmap:node/8348356421'),
  ('catalogo-baleares:postal_service:node-866859777', 'Correos Palma – Carrer de la Constitució', NULL, '07040', 'Carrer de la Constitució 6', '07001', 39.56938, 2.64751, 'address', 'openstreetmap:node/866859777'),
  ('catalogo-baleares:postal_service:node-954863635', 'Correos Alcúdia – carrer de Pol·lèntia', NULL, '07003', 'carrer de Pol·lèntia 57', NULL, 39.85007, 3.12691, 'address', 'openstreetmap:node/954863635'),
  ('catalogo-baleares:postal_service:node-972552639', 'Correos Santa Maria del Camí – Carrer de Bernat de Santa Eugènia', NULL, '07056', 'Carrer de Bernat de Santa Eugènia 41', '07320', 39.65042, 2.77204, 'address', 'openstreetmap:node/972552639'),
  ('catalogo-baleares:postal_service:node-973915655', 'Correos Ariany – carrer Major', NULL, '07901', 'carrer Major', '07529', 39.64895, 3.11035, 'address', 'openstreetmap:node/973915655'),
  ('catalogo-baleares:postal_service:node-995127797', 'Correos Palma – Carrer de Pau Piferrer', NULL, '07040', 'Carrer de Pau Piferrer 12', '07011', 39.57781, 2.6425, 'address', 'openstreetmap:node/995127797'),
  ('catalogo-baleares:postal_service:way-1098858828', 'Correos Sant Llorenç des Cardassar – Carrer de Porto Cristo', NULL, '07051', 'Carrer de Porto Cristo', NULL, 39.58557, 3.32131, 'address', 'openstreetmap:way/1098858828'),
  ('catalogo-baleares:postal_service:way-1192708303', 'Correos ses Salines – Avinguda de Francesc de Borja Moll', NULL, '07059', 'Avinguda de Francesc de Borja Moll 2', '07640', 39.33928, 3.05054, 'address', 'openstreetmap:way/1192708303'),
  ('catalogo-baleares:postal_service:way-1213525228', 'Correos Costitx – carrer Major', NULL, '07017', 'carrer Major', NULL, 39.65592, 2.94903, 'address', 'openstreetmap:way/1213525228'),
  ('catalogo-baleares:postal_service:way-389686947', 'Correos Inca – Plaça de l''Àngel', NULL, '07027', 'Plaça de l''Àngel 6', '07300', 39.71959, 2.91018, 'address', 'openstreetmap:way/389686947'),
  ('catalogo-baleares:postal_service:way-406141405', 'Correos Lloseta – carrer de Fra Juníper Serra', NULL, '07029', 'carrer de Fra Juníper Serra', '07360', 39.71757, 2.86832, 'address', 'openstreetmap:way/406141405'),
  ('catalogo-baleares:postal_service:way-524896926', 'Correos Andratx – carrer Maura', NULL, '07005', 'carrer Maura', '07150', 39.57588, 2.42099, 'address', 'openstreetmap:way/524896926'),
  ('catalogo-baleares:postal_service:way-715183767', 'Correos Manacor – carrer d''en San Simón', NULL, '07033', 'carrer d''en San Simón 11', '07680', 39.54195, 3.33312, 'address', 'openstreetmap:way/715183767'),
  ('catalogo-baleares:postal_service:way-730163023', 'Correos Llucmajor – Carrer d''en París', NULL, '07031', 'Carrer d''en París 43', '07620', 39.48656, 2.89264, 'address', 'openstreetmap:way/730163023'),
  ('catalogo-baleares:postal_service:way-792490812', 'Correos Binissalem – carrer Sant Vicenç de Paül', NULL, '07008', 'carrer Sant Vicenç de Paül 9', '07350', 39.68852, 2.84312, 'address', 'openstreetmap:way/792490812'),
  ('catalogo-baleares:postal_service:way-953800213', 'Correos Palma – carrer de Pàdua', NULL, '07040', 'carrer de Pàdua', '07610', 39.53678, 2.71781, 'address', 'openstreetmap:way/953800213');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 53 THEN
    RAISE EXCEPTION 'Se esperaban 53 puntos de Correos en Illes Balears, hay %', n;
  END IF;
END;
$$;

COMMIT;
