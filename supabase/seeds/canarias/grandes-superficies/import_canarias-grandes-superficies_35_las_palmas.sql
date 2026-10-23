-- Carga de la categoría (varias) de Las Palmas (provincia 35), trozo de la carga de Andalucía.
-- Origen: canarias-grandes-superficies-canarias.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-21T20:21:46Z).
-- 21 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('IKEA', 'catalogo-canarias:canarias-grandes-superficies:node-11366646011', 'IKEA Antigua – Calle Tabajoste', NULL, '35003', 'Calle Tabajoste', '35630', 28.42098, -13.86482, 'address', 'openstreetmap:node/11366646011'),
  ('MediaMarkt', 'catalogo-canarias:canarias-grandes-superficies:node-11396898267', 'MediaMarkt Arrecife – Calle Tenderete', NULL, '35004', 'Calle Tenderete 7', '35500', 28.97481, -13.56335, 'address', 'openstreetmap:node/11396898267'),
  ('El Corte Inglés', 'catalogo-canarias:canarias-grandes-superficies:node-11504519493', 'El Corte Inglés Telde – Lugar Bocabarranco', NULL, '35026', 'Lugar Bocabarranco', NULL, 28.02931, -15.39553, 'address', 'openstreetmap:node/11504519493'),
  ('Carrefour', 'catalogo-canarias:canarias-grandes-superficies:node-1903040816', 'Carrefour Las Palmas de Gran Canaria – Carretera del Norte', NULL, '35016', 'Carretera del Norte 112', '35013', 28.10063, -15.44287, 'address', 'openstreetmap:node/1903040816'),
  ('El Corte Inglés', 'catalogo-canarias:canarias-grandes-superficies:node-3237667079', 'El Corte Inglés Las Palmas de Gran Canaria – Calle Juan Manuel Durán González', NULL, '35016', 'Calle Juan Manuel Durán González 14', '35007', 28.13513, -15.43163, 'address', 'openstreetmap:node/3237667079'),
  ('MediaMarkt', 'catalogo-canarias:canarias-grandes-superficies:node-442395246', 'MediaMarkt Telde – Lugar Bocabarranco', NULL, '35026', 'Lugar Bocabarranco', '35220', 28.02811, -15.39355, 'address', 'openstreetmap:node/442395246'),
  ('Decathlon', 'catalogo-canarias:canarias-grandes-superficies:node-4450652993', 'Decathlon Arrecife', NULL, '35004', NULL, NULL, 28.97199, -13.56256, 'address', 'openstreetmap:node/4450652993'),
  ('Carrefour', 'catalogo-canarias:canarias-grandes-superficies:node-602097905', 'Carrefour Santa Lucía de Tirajana – Calle Agaldar', NULL, '35022', 'Calle Agaldar', '35110', 27.84352, -15.44107, 'address', 'openstreetmap:node/602097905'),
  ('MediaMarkt', 'catalogo-canarias:canarias-grandes-superficies:node-6431551296', 'MediaMarkt Las Palmas de Gran Canaria – Hermanos Domínguez Santana', NULL, '35016', 'Hermanos Domínguez Santana', NULL, 28.09509, -15.47409, 'address', 'openstreetmap:node/6431551296'),
  ('Carrefour', 'catalogo-canarias:canarias-grandes-superficies:node-6762722194', 'Carrefour Las Palmas de Gran Canaria', NULL, '35016', NULL, '35010', 28.12768, -15.44875, 'address', 'openstreetmap:node/6762722194'),
  ('MediaMarkt', 'catalogo-canarias:canarias-grandes-superficies:node-6762722291', 'MediaMarkt Las Palmas de Gran Canaria – Carretera del Rincón', NULL, '35016', 'Carretera del Rincón', '35010', 28.12741, -15.44763, 'address', 'openstreetmap:node/6762722291'),
  ('Decathlon', 'catalogo-canarias:canarias-grandes-superficies:way-127927726', 'Decathlon Telde – Lugar La Finca Mareta', NULL, '35026', 'Lugar La Finca Mareta', NULL, 28.0125, -15.39075, 'address', 'openstreetmap:way/127927726'),
  ('Leroy Merlin', 'catalogo-canarias:canarias-grandes-superficies:way-127927730', 'Leroy Merlin Telde – Lugar La Finca Mareta', NULL, '35026', 'Lugar La Finca Mareta', NULL, 28.01266, -15.38586, 'address', 'openstreetmap:way/127927730'),
  ('IKEA', 'catalogo-canarias:canarias-grandes-superficies:way-189539189', 'IKEA Telde', NULL, '35026', NULL, NULL, 28.00933, -15.38745, 'address', 'openstreetmap:way/189539189'),
  ('El Corte Inglés', 'catalogo-canarias:canarias-grandes-superficies:way-31508327', 'El Corte Inglés Las Palmas de Gran Canaria – Avenida Pintor Felo Monzón', NULL, '35016', 'Avenida Pintor Felo Monzón', NULL, 28.09559, -15.45724, 'address', 'openstreetmap:way/31508327'),
  ('IKEA', 'catalogo-canarias:canarias-grandes-superficies:way-398396577', 'IKEA Telde – Calle Físico', NULL, '35026', 'Calle Físico', NULL, 27.97902, -15.39001, 'address', 'openstreetmap:way/398396577'),
  ('Carrefour', 'catalogo-canarias:canarias-grandes-superficies:way-40358173', 'Carrefour Las Palmas de Gran Canaria – Paseo Blas Cabrera Felipe "Físico"', NULL, '35016', 'Paseo Blas Cabrera Felipe "Físico" 38', '35016', 28.07185, -15.41854, 'address', 'openstreetmap:way/40358173'),
  ('Carrefour', 'catalogo-canarias:canarias-grandes-superficies:way-426459788', 'Carrefour Telde – AUTOVIA GC-1 (AEROPUERTO DE GRAN CANARIA ) KM.', NULL, '35026', 'AUTOVIA GC-1 (AEROPUERTO DE GRAN CANARIA ) KM. 16', NULL, 27.94063, -15.39001, 'address', 'openstreetmap:way/426459788'),
  ('Leroy Merlin', 'catalogo-canarias:canarias-grandes-superficies:way-542515971', 'Leroy Merlin Las Palmas de Gran Canaria – Hermanos Domínguez Santana', NULL, '35016', 'Hermanos Domínguez Santana', NULL, 28.09527, -15.47113, 'address', 'openstreetmap:way/542515971'),
  ('Decathlon', 'catalogo-canarias:canarias-grandes-superficies:way-542515972', 'Decathlon Las Palmas de Gran Canaria – Hermanos Domínguez Santana', NULL, '35016', 'Hermanos Domínguez Santana', NULL, 28.09493, -15.47294, 'address', 'openstreetmap:way/542515972'),
  ('IKEA', 'catalogo-canarias:canarias-grandes-superficies:way-96653477', 'IKEA Arrecife – Calle Oceano Indico', NULL, '35004', 'Calle Oceano Indico', NULL, 28.97465, -13.53525, 'address', 'openstreetmap:way/96653477');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '35');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 35 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '35'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 21 THEN
    RAISE EXCEPTION 'Se esperaban 21 puntos de (varias) en Las Palmas, hay %', n;
  END IF;
END;
$$;

COMMIT;
