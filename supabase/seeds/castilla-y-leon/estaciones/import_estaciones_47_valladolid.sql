-- Carga de la categoría Estaciones de Valladolid (provincia 47), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 21 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-13364278536', 'Estación de tren de Medina del Campo Alta Velocidad – Carretera de Las Salinas', 'Tren', '47085', 'Carretera de Las Salinas', '47400', 41.29133, -4.92298, 'address', 'openstreetmap:node/13364278536'),
  ('catalogo-castilla-y-leon:estaciones:node-13364278537', 'Estación de tren de Medina del Campo – Avenida de la Estación', 'Tren', '47085', 'Avenida de la Estación', NULL, 41.31726, -4.90968, 'address', 'openstreetmap:node/13364278537'),
  ('catalogo-castilla-y-leon:estaciones:node-13640759008', 'Estación de tren de Nava del Rey – Calle Juan Antonio Carmona', 'Tren', '47101', 'Calle Juan Antonio Carmona', '47500', 41.3348, -5.07673, 'address', 'openstreetmap:node/13640759008'),
  ('catalogo-castilla-y-leon:estaciones:node-1986914415', 'Estación de tren de Corcos-Aguilarejo', 'Tren', '47055', NULL, NULL, 41.76635, -4.62337, 'address', 'openstreetmap:node/1986914415'),
  ('catalogo-castilla-y-leon:estaciones:node-2232327698', 'Estación de tren de Campillo (El Campillo) – Carretera de la Estación', 'Tren', '47031', 'Carretera de la Estación', NULL, 41.25959, -5.01792, 'address', 'openstreetmap:node/2232327698'),
  ('catalogo-castilla-y-leon:estaciones:node-2288362387', 'Estación de tren de Matapozuelos', 'Tren', '47082', NULL, NULL, 41.4219, -4.80147, 'address', 'openstreetmap:node/2288362387'),
  ('catalogo-castilla-y-leon:estaciones:node-2288768949', 'Estación de tren de Viana (Viana de Cega) – Calle Estación', 'Tren', '47193', 'Calle Estación', NULL, 41.52407, -4.75456, 'address', 'openstreetmap:node/2288768949'),
  ('catalogo-castilla-y-leon:estaciones:node-255454508', 'Estación de tren de Cabezón de Pisuerga – Barrio de la Estación', 'Tren', '47027', 'Barrio de la Estación', NULL, 41.73725, -4.65127, 'address', 'openstreetmap:node/255454508'),
  ('catalogo-castilla-y-leon:estaciones:node-255455773', 'Estación de tren de Cubillas de Santa Marta – Barrio Vegalatorre', 'Tren', '47057', 'Barrio Vegalatorre', NULL, 41.80898, -4.57957, 'address', 'openstreetmap:node/255455773'),
  ('catalogo-castilla-y-leon:estaciones:node-2969107075', 'Estación de tren de Carpio – Paseo de Isidora Carbonero', 'Tren', '47035', 'Paseo de Isidora Carbonero', NULL, 41.21556, -5.11453, 'address', 'openstreetmap:node/2969107075'),
  ('catalogo-castilla-y-leon:estaciones:node-2969107097', 'Estación de tren de Fresno el Viejo – Calle Cándido Sánchez', 'Tren', '47065', 'Calle Cándido Sánchez', NULL, 41.19126, -5.13795, 'address', 'openstreetmap:node/2969107097'),
  ('catalogo-castilla-y-leon:estaciones:node-3711686028', 'Estación de tren de Valdestillas – Calle Real', 'Tren', '47182', 'Calle Real', '47240', 41.48874, -4.77295, 'address', 'openstreetmap:node/3711686028'),
  ('catalogo-castilla-y-leon:estaciones:node-598602872', 'Estación de tren de Pozaldez', 'Tren', '47124', NULL, NULL, 41.36766, -4.83566, 'address', 'openstreetmap:node/598602872'),
  ('catalogo-castilla-y-leon:estaciones:node-7699368435', 'Estación de tren de Valladolid-Universidad – Paseo de Juan Carlos I', 'Tren', '47186', 'Paseo de Juan Carlos I 200', '47011', 41.66016, -4.70422, 'address', 'openstreetmap:node/7699368435'),
  ('catalogo-castilla-y-leon:estaciones:node-9175580427', 'Estación de tren de Valladolid - Campo Grande – Calle de Recondo', 'Tren', '47186', 'Calle de Recondo 12', '47007', 41.64213, -4.72695, 'address', 'openstreetmap:node/9175580427'),
  ('catalogo-castilla-y-leon:estaciones:way-1049459768', 'Estación de Autobuses de Medina de Rioseco. – Calle Ruedo', 'Autobús', '47086', 'Calle Ruedo', NULL, 41.87946, -5.04585, 'address', 'openstreetmap:way/1049459768'),
  ('catalogo-castilla-y-leon:estaciones:way-1202207379', 'Estación de Autobuses de Valladolid – Calle del Puente Colgante', 'Autobús', '47186', 'Calle del Puente Colgante 2', '47007', 41.64162, -4.73303, 'address', 'openstreetmap:way/1202207379'),
  ('catalogo-castilla-y-leon:estaciones:way-1357083575', 'Estación de Autobuses de Villalón de Campos – Carretera Palencia', 'Autobús', '47214', 'Carretera Palencia 4', '47600', 42.09742, -5.03144, 'address', 'openstreetmap:way/1357083575'),
  ('catalogo-castilla-y-leon:estaciones:way-146663302', 'Estación de Autobuses (Tordesillas) – Calle Valdehuertos', 'Autobús', '47165', 'Calle Valdehuertos', '47100', 41.50266, -5.00476, 'address', 'openstreetmap:way/146663302'),
  ('catalogo-castilla-y-leon:estaciones:way-483704811', 'Estación de autobuses de Peñafiel – Avenida de Soria', 'Autobús', '47114', 'Avenida de Soria 15', '47300', 41.59916, -4.12263, 'address', 'openstreetmap:way/483704811'),
  ('catalogo-castilla-y-leon:estaciones:way-496433202', 'Parada de Autobús de Santa Eufemia del Arroyo – Calle Toro León', 'Autobús', '47152', 'Calle Toro León', '47811', 41.89637, -5.26592, 'approximate', 'openstreetmap:way/496433202');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 21 THEN
    RAISE EXCEPTION 'Se esperaban 21 puntos de Estaciones en Valladolid, hay %', n;
  END IF;
END;
$$;

COMMIT;
