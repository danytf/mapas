-- Carga de la categoría Correos de Ciudad Real (provincia 13), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 20 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:postal_service:node-10881530090', 'Correos Alcázar de San Juan – Calle General Benavent García', NULL, '13005', 'Calle General Benavent García 2', '13600', 39.38956, -3.21129, 'address', 'openstreetmap:node/10881530090'),
  ('catalogo-castilla-la-mancha:postal_service:node-1857954273', 'Correos Almadén – Plaza de la Constitución', NULL, '13011', 'Plaza de la Constitución 15', NULL, 38.77575, -4.83649, 'address', 'openstreetmap:node/1857954273'),
  ('catalogo-castilla-la-mancha:postal_service:node-2019106006', 'Correos Villarrubia de los Ojos – Calle del Tirante', NULL, '13096', 'Calle del Tirante', '13670', 39.21912, -3.60798, 'address', 'openstreetmap:node/2019106006'),
  ('catalogo-castilla-la-mancha:postal_service:node-2027175495', 'Correos Manzanares – Plaza de la Constitución', NULL, '13053', 'Plaza de la Constitución 7', '13200', 38.99604, -3.3722, 'address', 'openstreetmap:node/2027175495'),
  ('catalogo-castilla-la-mancha:postal_service:node-3048175257', 'Correos Herencia – Calle Oratorio', NULL, '13047', 'Calle Oratorio', NULL, 39.36621, -3.35354, 'address', 'openstreetmap:node/3048175257'),
  ('catalogo-castilla-la-mancha:postal_service:node-3516190732', 'Correos Valdepeñas – Avenida Primero de Julio', NULL, '13087', 'Avenida Primero de Julio', '13300', 38.75798, -3.38357, 'address', 'openstreetmap:node/3516190732'),
  ('catalogo-castilla-la-mancha:postal_service:node-3721967711', 'Correos Carrión de Calatrava – Calle Rafael Gasset', NULL, '13031', 'Calle Rafael Gasset', NULL, 39.01884, -3.81535, 'address', 'openstreetmap:node/3721967711'),
  ('catalogo-castilla-la-mancha:postal_service:node-4342490589', 'Correos Santa Cruz de Mudela – Plaza Concepción', NULL, '13077', 'Plaza Concepción 5', '13730', 38.64352, -3.4693, 'address', 'openstreetmap:node/4342490589'),
  ('catalogo-castilla-la-mancha:postal_service:node-4837444594', 'Correos Villarta de San Juan – Plaza de la Paz', NULL, '13097', 'Plaza de la Paz', NULL, 39.23878, -3.42413, 'address', 'openstreetmap:node/4837444594'),
  ('catalogo-castilla-la-mancha:postal_service:node-4909477913', 'Correos Aldea del Rey – Calle Tahona', NULL, '13009', 'Calle Tahona', NULL, 38.73806, -3.84041, 'address', 'openstreetmap:node/4909477913'),
  ('catalogo-castilla-la-mancha:postal_service:node-5324471421', 'Correos Tomelloso – Calle Francisco García Pavón', NULL, '13082', 'Calle Francisco García Pavón 22', '13700', 39.15626, -3.02375, 'address', 'openstreetmap:node/5324471421'),
  ('catalogo-castilla-la-mancha:postal_service:node-5364584471', 'Correos Bolaños de Calatrava – Calle Arzobispo Calzado', NULL, '13023', 'Calle Arzobispo Calzado', NULL, 38.90479, -3.66755, 'address', 'openstreetmap:node/5364584471'),
  ('catalogo-castilla-la-mancha:postal_service:node-5760449543', 'Correos Albaladejo – Calle Mayor', NULL, '13004', 'Calle Mayor', NULL, 38.61803, -2.80539, 'address', 'openstreetmap:node/5760449543'),
  ('catalogo-castilla-la-mancha:postal_service:node-8917636575', 'Correos Alcázar de San Juan – Calle Don Quijote', NULL, '13005', 'Calle Don Quijote 20', NULL, 39.17351, -3.23648, 'address', 'openstreetmap:node/8917636575'),
  ('catalogo-castilla-la-mancha:postal_service:way-1425588986', 'Correos Villanueva de la Fuente – Calle Escuelas', NULL, '13092', 'Calle Escuelas', NULL, 38.69409, -2.69659, 'address', 'openstreetmap:way/1425588986'),
  ('catalogo-castilla-la-mancha:postal_service:way-244349150', 'Correos Daimiel – Calle Maestro Baeza', NULL, '13039', 'Calle Maestro Baeza', '13250', 39.07108, -3.61236, 'address', 'openstreetmap:way/244349150'),
  ('catalogo-castilla-la-mancha:postal_service:way-458173033', 'Correos Horcajo de los Montes – Calle de Cervantes', NULL, '13049', 'Calle de Cervantes 1', '13110', 39.32636, -4.65071, 'address', 'openstreetmap:way/458173033'),
  ('catalogo-castilla-la-mancha:postal_service:way-785429303', 'Correos Puertollano – Calle Torrecilla', NULL, '13071', 'Calle Torrecilla 6', '13500', 38.6873, -4.1107, 'address', 'openstreetmap:way/785429303'),
  ('catalogo-castilla-la-mancha:postal_service:way-863779677', 'Correos Campo de Criptana – Calle Virgen de Criptana', NULL, '13028', 'Calle Virgen de Criptana', '13610', 39.40572, -3.12257, 'address', 'openstreetmap:way/863779677'),
  ('catalogo-castilla-la-mancha:postal_service:way-903593058', 'Correos La Solana – Plaza Don Diego', NULL, '13079', 'Plaza Don Diego 6', '13240', 38.94175, -3.2397, 'address', 'openstreetmap:way/903593058');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '13');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 13 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '13'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 20 THEN
    RAISE EXCEPTION 'Se esperaban 20 puntos de Correos en Ciudad Real, hay %', n;
  END IF;
END;
$$;

COMMIT;
