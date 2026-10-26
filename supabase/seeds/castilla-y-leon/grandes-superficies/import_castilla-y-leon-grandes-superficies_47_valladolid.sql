-- Carga de la categoría (varias) de Valladolid (provincia 47), trozo de la carga de Andalucía.
-- Origen: castilla-y-leon-grandes-superficies-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 26 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-10087622164', 'Carrefour Valladolid – 1', NULL, '47186', '1', '47012', 41.64343, -4.71586, 'address', 'openstreetmap:node/10087622164'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1014747706', 'Carrefour Valladolid – Paseo de Zorrilla', NULL, '47186', 'Paseo de Zorrilla', '47008', 41.62318, -4.74975, 'address', 'openstreetmap:node/1014747706'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-10985292737', 'Carrefour Valladolid – Avenida de Ramón y Cajal', NULL, '47186', 'Avenida de Ramón y Cajal 12', '47003', 41.65487, -4.71976, 'address', 'openstreetmap:node/10985292737'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1165805555', 'Carrefour Valladolid – Calle de Santiago', NULL, '47186', 'Calle de Santiago 13', '47001', 41.65023, -4.7287, 'address', 'openstreetmap:node/1165805555'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-12308794150', 'Carrefour Valladolid – Calle de la Epifanía', NULL, '47186', 'Calle de la Epifanía 6', '47011', 41.6569, -4.70941, 'address', 'openstreetmap:node/12308794150'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-12345010620', 'Carrefour Valladolid – Calle de Amadeo Arias', NULL, '47186', 'Calle de Amadeo Arias 27', '47014', 41.63578, -4.75956, 'address', 'openstreetmap:node/12345010620'),
  ('Leroy Merlin', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-13585942498', 'Leroy Merlin Arroyo de la Encomienda – Calle Me Falta un Tornillo', NULL, '47010', 'Calle Me Falta un Tornillo 3', '47195', 41.62883, -4.78988, 'address', 'openstreetmap:node/13585942498'),
  ('MediaMarkt', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-13585942500', 'MediaMarkt Arroyo de la Encomienda – Calle Me Falta un Tornillo', NULL, '47010', 'Calle Me Falta un Tornillo 3', '47195', 41.62946, -4.79031, 'address', 'openstreetmap:node/13585942500'),
  ('IKEA', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-13585984101', 'IKEA Arroyo de la Encomienda – Calle Me Falta un Tornillo', NULL, '47010', 'Calle Me Falta un Tornillo 5', '47195', 41.62785, -4.78812, 'address', 'openstreetmap:node/13585984101'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-13682304316', 'Carrefour Valladolid – Calle de Panaderos', NULL, '47186', 'Calle de Panaderos 75', '47004', 41.64408, -4.72217, 'address', 'openstreetmap:node/13682304316'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-13828527875', 'Carrefour Valladolid – Paseo de Juan Carlos I', NULL, '47186', 'Paseo de Juan Carlos I 141', '47011', 41.65541, -4.70435, 'address', 'openstreetmap:node/13828527875'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-3814042260', 'Carrefour Aldeamayor de San Martín – Avenida de Valladolid', NULL, '47007', 'Avenida de Valladolid 2', '47162', 41.51298, -4.63825, 'address', 'openstreetmap:node/3814042260'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-4935174380', 'Carrefour Valladolid – Plaza Circular', NULL, '47186', 'Plaza Circular', '47004', 41.64722, -4.71634, 'address', 'openstreetmap:node/4935174380'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-5290005821', 'Carrefour Valladolid – Plaza de la Libertad', NULL, '47186', 'Plaza de la Libertad 3', '47002', 41.65322, -4.72447, 'address', 'openstreetmap:node/5290005821'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-5301385927', 'Decathlon Valladolid – Calle de la Constitución', NULL, '47186', 'Calle de la Constitución 3', '47001', 41.65108, -4.72803, 'address', 'openstreetmap:node/5301385927'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-5518778054', 'Carrefour Valladolid – Paseo del Hospital Militar', NULL, '47186', 'Paseo del Hospital Militar 36', '47006', 41.64474, -4.73573, 'address', 'openstreetmap:node/5518778054'),
  ('Leroy Merlin', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6423198711', 'Leroy Merlin Valladolid – Calle del Atrio de Santiago', NULL, '47186', 'Calle del Atrio de Santiago 2', '47001', 41.65046, -4.72899, 'address', 'openstreetmap:node/6423198711'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6843804425', 'Carrefour Siete Iglesias de Trabancos – A-62 Km', NULL, '47160', 'A-62 Km 177', NULL, 41.34716, -5.17731, 'address', 'openstreetmap:node/6843804425'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-8243979470', 'Carrefour Valladolid – Calle de Tirso de Molina', NULL, '47186', 'Calle de Tirso de Molina 18', '47010', 41.66014, -4.7234, 'address', 'openstreetmap:node/8243979470'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-8243979477', 'Carrefour Valladolid – Calle del Portillo de Balboa', NULL, '47186', 'Calle del Portillo de Balboa 49', '47010', 41.66263, -4.71921, 'address', 'openstreetmap:node/8243979477'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-1099952867', 'Carrefour Valladolid – Paseo de Juan Carlos I', NULL, '47186', 'Paseo de Juan Carlos I 113', '47011', 41.65187, -4.70458, 'address', 'openstreetmap:way/1099952867'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-1133780660', 'Carrefour Arroyo de la Encomienda – Avenida de Salamanca', NULL, '47010', 'Avenida de Salamanca 25', '47195', 41.62267, -4.77178, 'address', 'openstreetmap:way/1133780660'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-26947304', 'Carrefour Valladolid – Avenida del Real Valladolid', NULL, '47186', 'Avenida del Real Valladolid', '47014', 41.64175, -4.76139, 'address', 'openstreetmap:way/26947304'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-26947403', 'Carrefour Valladolid – Calle Costa Brava', NULL, '47186', 'Calle Costa Brava 2', '47010', 41.66921, -4.70912, 'address', 'openstreetmap:way/26947403'),
  ('El Corte Inglés', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-26947567', 'El Corte Inglés Valladolid – Paseo de Zorrilla', NULL, '47186', 'Paseo de Zorrilla', '47006', 41.63731, -4.74009, 'address', 'openstreetmap:way/26947567'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-365542643', 'Decathlon Arroyo de la Encomienda – Calle María de Molina', NULL, '47010', 'Calle María de Molina 1', '47195', 41.61768, -4.78796, 'address', 'openstreetmap:way/365542643');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '47');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 47 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '47'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 26 THEN
    RAISE EXCEPTION 'Se esperaban 26 puntos de (varias) en Valladolid, hay %', n;
  END IF;
END;
$$;

COMMIT;
