-- Carga de la categoría Estaciones de Soria (provincia 42), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 13 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-12582187376', 'Estación de tren de Santa María de Huerta – Calle de la Estación', 'Tren', '42167', 'Calle de la Estación', NULL, 41.26407, -2.17796, 'address', 'openstreetmap:node/12582187376'),
  ('catalogo-castilla-y-leon:estaciones:node-12704481908', 'Estación de tren de Arcos de Jalón – Calle Gerardo Diego', 'Tren', '42025', 'Calle Gerardo Diego 4', '42257', 41.21565, -2.27769, 'address', 'openstreetmap:node/12704481908'),
  ('catalogo-castilla-y-leon:estaciones:node-13648729797', 'Estación de tren de Torralba (Medinaceli)', 'Tren', '42113', NULL, NULL, 41.13631, -2.49305, 'address', 'openstreetmap:node/13648729797'),
  ('catalogo-castilla-y-leon:estaciones:node-2091476633', 'Estación de tren de Almazán - Villa – Avenida de la Estación', 'Tren', '42020', 'Avenida de la Estación', '42200', 41.4892, -2.52534, 'address', 'openstreetmap:node/2091476633'),
  ('catalogo-castilla-y-leon:estaciones:node-257347410', 'Estación de tren de Soria – Calle Guadalajara', 'Tren', '42173', 'Calle Guadalajara', NULL, 41.75535, -2.47561, 'address', 'openstreetmap:node/257347410'),
  ('catalogo-castilla-y-leon:estaciones:node-257474716', 'Estación de tren de Quintana Redonda – Carretera de la Estación', 'Tren', '42144', 'Carretera de la Estación', NULL, 41.63962, -2.60959, 'address', 'openstreetmap:node/257474716'),
  ('catalogo-castilla-y-leon:estaciones:node-445961560', 'Estación de tren de Tardelcuende – Avenida de la Estación', 'Tren', '42181', 'Avenida de la Estación', NULL, 41.59354, -2.63926, 'address', 'openstreetmap:node/445961560'),
  ('catalogo-castilla-y-leon:estaciones:node-4864432351', 'Estación de tren de Medinaceli – Plaza de la Estación', 'Tren', '42113', 'Plaza de la Estación', '42240', 41.16522, -2.42117, 'address', 'openstreetmap:node/4864432351'),
  ('catalogo-castilla-y-leon:estaciones:node-9788409088', 'Estación de autobuses de Ágreda – Calle José Luis Palomar', 'Autobús', '42004', 'Calle José Luis Palomar', NULL, 41.8581, -1.92372, 'address', 'openstreetmap:node/9788409088'),
  ('catalogo-castilla-y-leon:estaciones:node-9788630213', 'Estación de autobuses de Soria – Avenida de Valladolid', 'Autobús', '42173', 'Avenida de Valladolid 40', '42004', 41.76702, -2.47943, 'address', 'openstreetmap:node/9788630213'),
  ('catalogo-castilla-y-leon:estaciones:way-254831771', 'Terminal de autobuses (Ólvega) – Plaza de la Constitución', 'Autobús', '42134', 'Plaza de la Constitución 1', '42110', 41.77836, -1.98556, 'address', 'openstreetmap:way/254831771'),
  ('catalogo-castilla-y-leon:estaciones:way-297327760', 'Estación de autobuses de Almazán – Avenida de la Estación', 'Autobús', '42020', 'Avenida de la Estación', '42200', 41.48947, -2.52862, 'address', 'openstreetmap:way/297327760'),
  ('catalogo-castilla-y-leon:estaciones:way-838265563', 'Estación de autobuses de San Esteban de Gozmaz (San Esteban de Gormaz) – Avenida de Valladolid', 'Autobús', '42162', 'Avenida de Valladolid 131', '42330', 41.57287, -3.20026, 'address', 'openstreetmap:way/838265563');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '42');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 42 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '42'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 13 THEN
    RAISE EXCEPTION 'Se esperaban 13 puntos de Estaciones en Soria, hay %', n;
  END IF;
END;
$$;

COMMIT;
