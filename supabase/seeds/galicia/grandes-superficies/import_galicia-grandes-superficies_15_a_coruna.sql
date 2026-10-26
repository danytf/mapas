-- Carga de la categoría (varias) de A Coruña (provincia 15), trozo de la carga de Andalucía.
-- Origen: galicia-grandes-superficies-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 39 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-10296757301', 'Carrefour A Coruña – Avenida Alcalde Pérez Ardá', NULL, '15030', 'Avenida Alcalde Pérez Ardá 47', '15009', 43.35098, -8.40368, 'address', 'openstreetmap:node/10296757301'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-11270245287', 'Carrefour A Coruña – Avenida de Rubine', NULL, '15030', 'Avenida de Rubine', '15004', 43.36789, -8.40856, 'address', 'openstreetmap:node/11270245287'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-11764429053', 'Carrefour Culleredo – Avenida de Ermida', NULL, '15031', 'Avenida de Ermida', NULL, 43.30593, -8.38096, 'address', 'openstreetmap:node/11764429053'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-12118852307', 'Carrefour A Coruña – Ronda de Monte Alto', NULL, '15030', 'Ronda de Monte Alto 15', '15002', 43.3812, -8.40171, 'address', 'openstreetmap:node/12118852307'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-12530484752', 'Carrefour Cambre – Rúa Río Gándara', NULL, '15017', 'Rúa Río Gándara 31', '15660', 43.30698, -8.35378, 'address', 'openstreetmap:node/12530484752'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-12626535858', 'Carrefour Santiago de Compostela – Rúa do Preguntoiro', NULL, '15078', 'Rúa do Preguntoiro 29', '15704', 42.88021, -8.54219, 'address', 'openstreetmap:node/12626535858'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-1769899524', 'Carrefour Santiago de Compostela – Rúa da República de El Salvador', NULL, '15078', 'Rúa da República de El Salvador 28', '15701', 42.87488, -8.54816, 'address', 'openstreetmap:node/1769899524'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-2485127656', 'Carrefour Ferrol – Rúa Buque Escola Giralda', NULL, '15036', 'Rúa Buque Escola Giralda', NULL, 43.5039, -8.20484, 'address', 'openstreetmap:node/2485127656'),
  ('MediaMarkt', 'catalogo-galicia:galicia-grandes-superficies:node-2485129816', 'MediaMarkt Ferrol – Avenida Buque Escola Galatea', NULL, '15036', 'Avenida Buque Escola Galatea', NULL, 43.50442, -8.20345, 'address', 'openstreetmap:node/2485129816'),
  ('MediaMarkt', 'catalogo-galicia:galicia-grandes-superficies:node-2971377063', 'MediaMarkt A Coruña – Estrada dos Baños de Arteixo', NULL, '15030', 'Estrada dos Baños de Arteixo 43', '15008', 43.34317, -8.42806, 'address', 'openstreetmap:node/2971377063'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-2977336908', 'Carrefour A Coruña – Rúa Juana de Vega', NULL, '15030', 'Rúa Juana de Vega 10', '15003', 43.36718, -8.40558, 'address', 'openstreetmap:node/2977336908'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:node-3143894320', 'Leroy Merlin Oleiros – Rúa do Barbanza', NULL, '15058', 'Rúa do Barbanza', '15179', 43.32116, -8.31689, 'address', 'openstreetmap:node/3143894320'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-3167555967', 'Carrefour Cee – Avenida Lino Rodríguez Madero', NULL, '15023', 'Avenida Lino Rodríguez Madero 6', '15270', 42.95567, -9.19153, 'address', 'openstreetmap:node/3167555967'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-3287502058', 'Carrefour Cambre – Costa da Tapia', NULL, '15017', 'Costa da Tapia 37', '15679', 43.31938, -8.3542, 'address', 'openstreetmap:node/3287502058'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:node-4294668420', 'Leroy Merlin A Coruña – Estrada dos Baños de Arteixo', NULL, '15030', 'Estrada dos Baños de Arteixo 43', '15008', 43.34346, -8.42848, 'address', 'openstreetmap:node/4294668420'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-470328680', 'Carrefour A Coruña – Ronda de Outeiro', NULL, '15030', 'Ronda de Outeiro 419', '15011', 43.37363, -8.42566, 'address', 'openstreetmap:node/470328680'),
  ('El Corte Inglés', 'catalogo-galicia:galicia-grandes-superficies:node-4774721107', 'El Corte Inglés Santiago de Compostela – Rúa do Restollal', NULL, '15078', 'Rúa do Restollal', '15702', 42.86294, -8.54289, 'address', 'openstreetmap:node/4774721107'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:node-5412099165', 'Decathlon A Coruña – Rúa Real', NULL, '15030', 'Rúa Real 48', '15003', 43.36977, -8.40059, 'address', 'openstreetmap:node/5412099165'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-5592798238', 'Carrefour A Coruña – Rúa Francisco Pérez Carballo', NULL, '15030', 'Rúa Francisco Pérez Carballo 5', '15008', 43.33877, -8.40838, 'address', 'openstreetmap:node/5592798238'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:node-6402616585', 'Decathlon Santiago de Compostela – Rúa da República de El Salvador', NULL, '15078', 'Rúa da República de El Salvador 31', '15701', 42.87437, -8.54867, 'address', 'openstreetmap:node/6402616585'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:node-7049880689', 'Decathlon Ferrol', NULL, '15036', NULL, '15405', 43.50785, -8.21637, 'address', 'openstreetmap:node/7049880689'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:way-116619875', 'Decathlon Santiago de Compostela – Rúa de Polonia', NULL, '15078', 'Rúa de Polonia 2', '15707', 42.90191, -8.51026, 'address', 'openstreetmap:way/116619875'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:way-128762961', 'Leroy Merlin Santiago de Compostela – Rúa de Polonia', NULL, '15078', 'Rúa de Polonia 1', '15707', 42.90329, -8.51078, 'address', 'openstreetmap:way/128762961'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-1532774527', 'Carrefour Mazaricos – AC-400 KM 93.6', NULL, '15045', 'AC-400 KM 93.6', NULL, 42.91054, -8.9552, 'address', 'openstreetmap:way/1532774527'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:way-159320757', 'Leroy Merlin Ferrol – Estrada da Gándara', NULL, '15036', 'Estrada da Gándara', '15570', 43.49263, -8.2069, 'address', 'openstreetmap:way/159320757'),
  ('IKEA', 'catalogo-galicia:galicia-grandes-superficies:way-165639265', 'IKEA A Coruña – Estrada dos Baños de Arteixo', NULL, '15030', 'Estrada dos Baños de Arteixo 45', '15008', 43.34449, -8.4299, 'address', 'openstreetmap:way/165639265'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-185194124', 'Carrefour A Coruña – Estrada de Feáns', NULL, '15030', 'Estrada de Feáns', '15190', 43.32843, -8.4269, 'address', 'openstreetmap:way/185194124'),
  ('MediaMarkt', 'catalogo-galicia:galicia-grandes-superficies:way-243080159', 'MediaMarkt Santiago de Compostela – Rúa de Malta', NULL, '15078', 'Rúa de Malta 2', '15707', 42.90027, -8.50972, 'address', 'openstreetmap:way/243080159'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:way-253315894', 'Decathlon A Coruña – Estrada dos Baños de Arteixo', NULL, '15030', 'Estrada dos Baños de Arteixo 43', '15008', 43.34314, -8.42935, 'address', 'openstreetmap:way/253315894'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-260532644', 'Carrefour Oleiros – Rúa O Morrazo', NULL, '15058', 'Rúa O Morrazo 11', '15171', 43.32274, -8.31859, 'address', 'openstreetmap:way/260532644'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-40549706', 'Carrefour Coristanco – Lugar de Capelán', NULL, '15029', 'Lugar de Capelán', '15147', 43.19566, -8.72396, 'address', 'openstreetmap:way/40549706'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-459829497', 'Carrefour Ames – Rúa Entrerríos', NULL, '15002', 'Rúa Entrerríos 7', '15220', 42.85958, -8.64865, 'address', 'openstreetmap:way/459829497'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-504903534', 'Carrefour Arzúa – Rúa do Piñeiral', NULL, '15006', 'Rúa do Piñeiral', '15810', 42.92952, -8.15298, 'address', 'openstreetmap:way/504903534'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:way-610763008', 'Leroy Merlin Santiago de Compostela – Rúa de Eslovenia', NULL, '15078', 'Rúa de Eslovenia', '15707', 42.90211, -8.5092, 'address', 'openstreetmap:way/610763008'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-64279343', 'Carrefour Sada', NULL, '15075', NULL, '15160', 43.35641, -8.25116, 'address', 'openstreetmap:way/64279343'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-682257897', 'Carrefour Santiago de Compostela – Avenida de Xoán Paulo II', NULL, '15078', 'Avenida de Xoán Paulo II', NULL, 42.88946, -8.52691, 'address', 'openstreetmap:way/682257897'),
  ('El Corte Inglés', 'catalogo-galicia:galicia-grandes-superficies:way-70256365', 'El Corte Inglés Cambre', NULL, '15017', NULL, NULL, 43.25404, -8.36613, 'address', 'openstreetmap:way/70256365'),
  ('El Corte Inglés', 'catalogo-galicia:galicia-grandes-superficies:way-793955752', 'El Corte Inglés A Coruña – Rúa Ramón y Cajal', NULL, '15030', 'Rúa Ramón y Cajal 57', '15006', 43.35425, -8.4029, 'address', 'openstreetmap:way/793955752'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:way-97219397', 'Decathlon Oleiros – Rúa do Barbanza', NULL, '15058', 'Rúa do Barbanza', '15171', 43.32015, -8.31698, 'address', 'openstreetmap:way/97219397');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '15');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 15 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '15'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 39 THEN
    RAISE EXCEPTION 'Se esperaban 39 puntos de (varias) en A Coruña, hay %', n;
  END IF;
END;
$$;

COMMIT;
