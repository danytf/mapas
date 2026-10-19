-- Carga de la categoría (varias) de Sevilla (provincia 41), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 55 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-10212900179', 'Carrefour Sevilla – Avenida de Eduardo Dato', NULL, '41091', 'Avenida de Eduardo Dato 22', '41018', 37.38298, -5.97501, 'address', 'openstreetmap:node/10212900179'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11273890647', 'Carrefour Sevilla – Calle Crédito', NULL, '41091', 'Calle Crédito', NULL, 37.40172, -5.99406, 'address', 'openstreetmap:node/11273890647'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11327874070', 'Carrefour Sevilla – Ronda de Capuchinos', NULL, '41091', 'Ronda de Capuchinos 9', NULL, 37.3998, -5.98348, 'address', 'openstreetmap:node/11327874070'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12188089311', 'Carrefour Sevilla – Calle Cardenal Cervantes', NULL, '41091', 'Calle Cardenal Cervantes', NULL, 37.39174, -5.98722, 'address', 'openstreetmap:node/12188089311'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-1239265180', 'Decathlon San Juan de Aznalfarache – Avenida de Coria', NULL, '41086', 'Avenida de Coria', '41920', 37.35301, -6.02492, 'address', 'openstreetmap:node/1239265180'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12500943452', 'Carrefour Las Cabezas de San Juan – Calle Camino de la Peña', NULL, '41020', 'Calle Camino de la Peña', NULL, 36.98511, -5.93575, 'address', 'openstreetmap:node/12500943452'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12527079687', 'Carrefour San Juan de Aznalfarache', NULL, '41086', NULL, NULL, 37.36715, -6.03559, 'address', 'openstreetmap:node/12527079687'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12531371219', 'Carrefour Sevilla – Calle José Jesús García Díaz', NULL, '41091', 'Calle José Jesús García Díaz', NULL, 37.40734, -5.93934, 'address', 'openstreetmap:node/12531371219'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-1323182414', 'Carrefour Sevilla – Calle Amor de Dios', NULL, '41091', 'Calle Amor de Dios 45', NULL, 37.39653, -5.99405, 'address', 'openstreetmap:node/1323182414'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-1366913038', 'Carrefour Sevilla – Calle Asunción', NULL, '41091', 'Calle Asunción', NULL, 37.37797, -5.99755, 'address', 'openstreetmap:node/1366913038'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-1537230572', 'Carrefour Sevilla – Calle Julio César', NULL, '41091', 'Calle Julio César', NULL, 37.39005, -6.00074, 'address', 'openstreetmap:node/1537230572'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-1752157720', 'Carrefour Sevilla – Calle Amador de Los Ríos', NULL, '41091', 'Calle Amador de Los Ríos', NULL, 37.39268, -5.9818, 'address', 'openstreetmap:node/1752157720'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2526791425', 'Carrefour Sevilla – Calle Feria', NULL, '41091', 'Calle Feria 108', '41003', 37.39996, -5.99165, 'address', 'openstreetmap:node/2526791425'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2580437926', 'Carrefour Sevilla – Calle Feria 1-3', NULL, '41091', 'Calle Feria 1-3', NULL, 37.39561, -5.99142, 'address', 'openstreetmap:node/2580437926'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2616456828', 'Carrefour Sevilla – Calle Sauceda', NULL, '41091', 'Calle Sauceda 5', '41001', 37.39189, -5.99748, 'address', 'openstreetmap:node/2616456828'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2645223332', 'Carrefour Écija', NULL, '41039', NULL, NULL, 37.53044, -5.08568, 'address', 'openstreetmap:node/2645223332'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3163390801', 'Carrefour Sevilla – Calle Marqués de la Mina', NULL, '41091', 'Calle Marqués de la Mina', NULL, 37.39792, -5.99799, 'address', 'openstreetmap:node/3163390801'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3835498761', 'Carrefour Gines – Calle Tecnología', NULL, '41047', 'Calle Tecnología', NULL, 37.3798, -6.08368, 'address', 'openstreetmap:node/3835498761'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4336924169', 'Carrefour Sevilla – Calle Tetuán', NULL, '41091', 'Calle Tetuán', NULL, 37.38952, -5.99508, 'address', 'openstreetmap:node/4336924169'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4633763590', 'Carrefour Sevilla – Ronda de Triana', NULL, '41091', 'Ronda de Triana 2', '41010', 37.38886, -6.01075, 'address', 'openstreetmap:node/4633763590'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4810968925', 'Carrefour Sevilla – Calle Resolana', NULL, '41091', 'Calle Resolana', NULL, 37.40324, -5.99025, 'address', 'openstreetmap:node/4810968925'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4880582607', 'Carrefour Sevilla – Calle Sierpes', NULL, '41091', 'Calle Sierpes', NULL, 37.39163, -5.9948, 'address', 'openstreetmap:node/4880582607'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5164312804', 'Carrefour Sevilla – Calle Zaragoza', NULL, '41091', 'Calle Zaragoza 31', NULL, 37.38833, -5.99718, 'address', 'openstreetmap:node/5164312804'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5349815429', 'Carrefour La Algaba – Avenida Juan Molina', NULL, '41007', 'Avenida Juan Molina', NULL, 37.45933, -6.013, 'address', 'openstreetmap:node/5349815429'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6314437714', 'Carrefour Sevilla – Calle Felipe II', NULL, '41091', 'Calle Felipe II', NULL, 37.37173, -5.98272, 'address', 'openstreetmap:node/6314437714'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-6324312199', 'MediaMarkt San Juan de Aznalfarache – Autovía de San Juan de Aznalfarache a Mairena del Aljarafe', NULL, '41086', 'Autovía de San Juan de Aznalfarache a Mairena del Aljarafe', NULL, 37.36277, -6.04438, 'address', 'openstreetmap:node/6324312199'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6668220386', 'Carrefour Sevilla – Calle Pureza', NULL, '41091', 'Calle Pureza', NULL, 37.38483, -6.00307, 'address', 'openstreetmap:node/6668220386'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-6892086685', 'Decathlon Sevilla – Pasaje Francisco Molina', NULL, '41091', 'Pasaje Francisco Molina', NULL, 37.39294, -5.99417, 'address', 'openstreetmap:node/6892086685'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6984487785', 'Carrefour Sevilla – Calle Puente y Pellón', NULL, '41091', 'Calle Puente y Pellón', NULL, 37.39101, -5.9923, 'address', 'openstreetmap:node/6984487785'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-747703011', 'Carrefour Sevilla – Calle Alfalfa', NULL, '41091', 'Calle Alfalfa', NULL, 37.3902, -5.99032, 'address', 'openstreetmap:node/747703011'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-7803821442', 'Carrefour Sevilla – Calle Parque de Despeñaperros', NULL, '41091', 'Calle Parque de Despeñaperros', NULL, 37.41866, -5.97432, 'address', 'openstreetmap:node/7803821442'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:node-7999257633', 'Leroy Merlin Dos Hermanas – Avenida 4 de Diciembre', NULL, '41038', 'Avenida 4 de Diciembre', NULL, 37.28484, -5.93923, 'address', 'openstreetmap:node/7999257633'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-807239965', 'Carrefour Sevilla – Calle Forjadores', NULL, '41091', 'Calle Forjadores', NULL, 37.42103, -5.96373, 'address', 'openstreetmap:node/807239965'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-8419960340', 'Carrefour Sevilla – Calle Matahacas', NULL, '41091', 'Calle Matahacas', NULL, 37.39378, -5.98525, 'address', 'openstreetmap:node/8419960340'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-912049203', 'Carrefour Camas', NULL, '41021', NULL, NULL, 37.39186, -6.03086, 'address', 'openstreetmap:node/912049203'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-912084443', 'El Corte Inglés San Juan de Aznalfarache', NULL, '41086', NULL, NULL, 37.37203, -6.03094, 'address', 'openstreetmap:node/912084443'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9149443626', 'Carrefour Sevilla – Pasaje de Zamora', NULL, '41091', 'Pasaje de Zamora', NULL, 37.38752, -5.98529, 'address', 'openstreetmap:node/9149443626'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-9310729605', 'Decathlon Dos Hermanas – Avenida Hermanos Rus Velázquez', NULL, '41038', 'Avenida Hermanos Rus Velázquez', NULL, 37.28586, -5.94063, 'address', 'openstreetmap:node/9310729605'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9707689196', 'Carrefour Sevilla – Calle Clara de Jesús Montero', NULL, '41091', 'Calle Clara de Jesús Montero', NULL, 37.38634, -6.00798, 'address', 'openstreetmap:node/9707689196'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9767513533', 'Carrefour Sevilla – Plaza de Zurbarán', NULL, '41091', 'Plaza de Zurbarán', NULL, 37.39397, -5.9927, 'address', 'openstreetmap:node/9767513533'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9895923240', 'Carrefour Sevilla – Calle Harinas', NULL, '41091', 'Calle Harinas', NULL, 37.38714, -5.99553, 'address', 'openstreetmap:node/9895923240'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9895948417', 'Carrefour Sevilla – Calle Antonia Díaz', NULL, '41091', 'Calle Antonia Díaz 31', NULL, 37.38542, -5.99781, 'address', 'openstreetmap:node/9895948417'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-1072391718', 'Carrefour Mairena del Alcor – Calle Utrera', NULL, '41058', 'Calle Utrera', NULL, 37.38101, -5.7353, 'address', 'openstreetmap:way/1072391718'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-129286126', 'Leroy Merlin Alcalá de Guadaíra – Calle Fridex Tres', NULL, '41004', 'Calle Fridex Tres', NULL, 37.37737, -5.89425, 'address', 'openstreetmap:way/129286126'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:way-202211678', 'IKEA Castilleja de la Cuesta – Calle Virgen de Loreto', NULL, '41029', 'Calle Virgen de Loreto', NULL, 37.3837, -6.0472, 'address', 'openstreetmap:way/202211678'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-219492365', 'El Corte Inglés Sevilla', NULL, '41091', NULL, NULL, 37.38796, -5.93993, 'address', 'openstreetmap:way/219492365'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-256169163', 'El Corte Inglés Sevilla – Calle San Pablo', NULL, '41091', 'Calle San Pablo 1', NULL, 37.39031, -5.99718, 'address', 'openstreetmap:way/256169163'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-31292884', 'El Corte Inglés Sevilla – Plaza del Duque de la Victoria', NULL, '41091', 'Plaza del Duque de la Victoria', NULL, 37.39322, -5.99652, 'address', 'openstreetmap:way/31292884'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-45110577', 'El Corte Inglés Sevilla – Calle Luis Montoto', NULL, '41091', 'Calle Luis Montoto 122', '41018', 37.38665, -5.97165, 'address', 'openstreetmap:way/45110577'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-452722999', 'Leroy Merlin Tomares – Calle Olvera', NULL, '41093', 'Calle Olvera', NULL, 37.37802, -6.02828, 'address', 'openstreetmap:way/452722999'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-59988991', 'Decathlon Alcalá de Guadaíra – Calle Palmetillo Catorce', NULL, '41004', 'Calle Palmetillo Catorce', NULL, 37.37418, -5.91063, 'address', 'openstreetmap:way/59988991'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-77490684', 'Decathlon Camas – Calle Poetisa Mariquita Fuentes', NULL, '41021', 'Calle Poetisa Mariquita Fuentes', NULL, 37.39203, -6.0286, 'address', 'openstreetmap:way/77490684'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-77492797', 'Leroy Merlin Tomares – Calle Cala', NULL, '41093', 'Calle Cala', NULL, 37.37481, -6.03221, 'address', 'openstreetmap:way/77492797'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-88220443', 'Carrefour Dos Hermanas – Avenida de España', NULL, '41038', 'Avenida de España', NULL, 37.2844, -5.93782, 'address', 'openstreetmap:way/88220443'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-91315402', 'Carrefour Sevilla', NULL, '41091', NULL, NULL, 37.35346, -5.95259, 'address', 'openstreetmap:way/91315402');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '41');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 41 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '41'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 55 THEN
    RAISE EXCEPTION 'Se esperaban 55 puntos de (varias) en Sevilla, hay %', n;
  END IF;
END;
$$;

COMMIT;
