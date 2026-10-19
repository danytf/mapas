-- Carga de la categoría (varias) de Sevilla (provincia 41), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 16 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-1239265180', 'Decathlon San Juan de Aznalfarache – Avenida de Coria', NULL, '41086', 'Avenida de Coria', '41920', 37.35301, -6.02492, 'address', 'openstreetmap:node/1239265180'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-6324312199', 'MediaMarkt San Juan de Aznalfarache – Autovía de San Juan de Aznalfarache a Mairena del Aljarafe', NULL, '41086', 'Autovía de San Juan de Aznalfarache a Mairena del Aljarafe', NULL, 37.36277, -6.04438, 'address', 'openstreetmap:node/6324312199'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-6892086685', 'Decathlon Sevilla – Pasaje Francisco Molina', NULL, '41091', 'Pasaje Francisco Molina', NULL, 37.39294, -5.99417, 'address', 'openstreetmap:node/6892086685'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:node-7999257633', 'Leroy Merlin Dos Hermanas – Avenida 4 de Diciembre', NULL, '41038', 'Avenida 4 de Diciembre', NULL, 37.28484, -5.93923, 'address', 'openstreetmap:node/7999257633'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-912084443', 'El Corte Inglés San Juan de Aznalfarache', NULL, '41086', NULL, NULL, 37.37203, -6.03094, 'address', 'openstreetmap:node/912084443'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-9310729605', 'Decathlon Dos Hermanas – Avenida Hermanos Rus Velázquez', NULL, '41038', 'Avenida Hermanos Rus Velázquez', NULL, 37.28586, -5.94063, 'address', 'openstreetmap:node/9310729605'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-129286126', 'Leroy Merlin Alcalá de Guadaíra – Calle Fridex Tres', NULL, '41004', 'Calle Fridex Tres', NULL, 37.37737, -5.89425, 'address', 'openstreetmap:way/129286126'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:way-202211678', 'IKEA Castilleja de la Cuesta – Calle Virgen de Loreto', NULL, '41029', 'Calle Virgen de Loreto', NULL, 37.3837, -6.0472, 'address', 'openstreetmap:way/202211678'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-219492365', 'El Corte Inglés Sevilla', NULL, '41091', NULL, NULL, 37.38796, -5.93993, 'address', 'openstreetmap:way/219492365'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-256169163', 'El Corte Inglés Sevilla – Calle San Pablo', NULL, '41091', 'Calle San Pablo 1', NULL, 37.39031, -5.99718, 'address', 'openstreetmap:way/256169163'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-31292884', 'El Corte Inglés Sevilla – Plaza del Duque de la Victoria', NULL, '41091', 'Plaza del Duque de la Victoria', NULL, 37.39322, -5.99652, 'address', 'openstreetmap:way/31292884'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-45110577', 'El Corte Inglés Sevilla – Calle Luis Montoto', NULL, '41091', 'Calle Luis Montoto 122', '41018', 37.38665, -5.97165, 'address', 'openstreetmap:way/45110577'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-452722999', 'Leroy Merlin Tomares – Calle Olvera', NULL, '41093', 'Calle Olvera', NULL, 37.37802, -6.02828, 'address', 'openstreetmap:way/452722999'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-59988991', 'Decathlon Alcalá de Guadaíra – Calle Palmetillo Catorce', NULL, '41004', 'Calle Palmetillo Catorce', NULL, 37.37418, -5.91063, 'address', 'openstreetmap:way/59988991'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-77490684', 'Decathlon Camas – Calle Poetisa Mariquita Fuentes', NULL, '41021', 'Calle Poetisa Mariquita Fuentes', NULL, 37.39203, -6.0286, 'address', 'openstreetmap:way/77490684'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-77492797', 'Leroy Merlin Tomares – Calle Cala', NULL, '41093', 'Calle Cala', NULL, 37.37481, -6.03221, 'address', 'openstreetmap:way/77492797');

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
  IF n <> 16 THEN
    RAISE EXCEPTION 'Se esperaban 16 puntos de (varias) en Sevilla, hay %', n;
  END IF;
END;
$$;

COMMIT;
