-- Carga de la categoría Correos de Burgos (provincia 09), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 25 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-1095007736', 'Correos Melgar de Fernamental – Avenida Castrojeriz', NULL, '09211', 'Avenida Castrojeriz', NULL, 42.40171, -4.24663, 'address', 'openstreetmap:node/1095007736'),
  ('catalogo-castilla-y-leon:postal_service:node-1181974884', 'Correos Condado de Treviño – Calle Salceda', NULL, '09109', 'Calle Salceda', '09215', 42.73419, -2.74921, 'address', 'openstreetmap:node/1181974884'),
  ('catalogo-castilla-y-leon:postal_service:node-1270451633', 'Correos Aranda de Duero – Calle Burgo de Osma', NULL, '09018', 'Calle Burgo de Osma 24', '09400', 41.66796, -3.68916, 'address', 'openstreetmap:node/1270451633'),
  ('catalogo-castilla-y-leon:postal_service:node-1301135612', 'Correos Medina de Pomar – Avenida Burgos', NULL, '09209', 'Avenida Burgos 18', '09500', 42.93022, -3.48404, 'address', 'openstreetmap:node/1301135612'),
  ('catalogo-castilla-y-leon:postal_service:node-13780043571', 'Correos Sotillo de la Ribera – Calle Real', NULL, '09369', 'Calle Real 21', '09441', 41.77752, -3.82598, 'address', 'openstreetmap:node/13780043571'),
  ('catalogo-castilla-y-leon:postal_service:node-1457733538', 'Correos Burgos – Avenida Castilla y León', NULL, '09059', 'Avenida Castilla y León 46', NULL, 42.35536, -3.67913, 'address', 'openstreetmap:node/1457733538'),
  ('catalogo-castilla-y-leon:postal_service:node-1460384183', 'Correos Villadiego – Avenida de los Reyes Católicos', NULL, '09427', 'Avenida de los Reyes Católicos', '09120', 42.51395, -4.01007, 'address', 'openstreetmap:node/1460384183'),
  ('catalogo-castilla-y-leon:postal_service:node-1935193772', 'Correos Villarcayo de Merindad de Castilla la Vieja – Calle San Roque', NULL, '09903', 'Calle San Roque 1', '09550', 42.93989, -3.57121, 'address', 'openstreetmap:node/1935193772'),
  ('catalogo-castilla-y-leon:postal_service:node-1937463017', 'Correos Briviesca – Paseo de la Epitafia', NULL, '09056', 'Paseo de la Epitafia 1', '09240', 42.55128, -3.31991, 'address', 'openstreetmap:node/1937463017'),
  ('catalogo-castilla-y-leon:postal_service:node-2058775409', 'Correos Lerma – Calle la Cigüeña', NULL, '09194', 'Calle la Cigüeña', NULL, 42.02398, -3.75838, 'address', 'openstreetmap:node/2058775409'),
  ('catalogo-castilla-y-leon:postal_service:node-2080225926', 'Correos Burgos – Avenida de los Derechos Humanos', NULL, '09059', 'Avenida de los Derechos Humanos 53', '09007', 42.349, -3.6665, 'address', 'openstreetmap:node/2080225926'),
  ('catalogo-castilla-y-leon:postal_service:node-2090925562', 'Correos Belorado – Calle Redecilla del Campo 7 - 1ºB', NULL, '09048', 'Calle Redecilla del Campo 7 - 1ºB', '09250', 42.4195, -3.19273, 'address', 'openstreetmap:node/2090925562'),
  ('catalogo-castilla-y-leon:postal_service:node-2092410604', 'Correos Quintanar de la Sierra – Calle Ernesto Sanz Sanz', NULL, '09289', 'Calle Ernesto Sanz Sanz 2', '09670', 41.98153, -3.04033, 'address', 'openstreetmap:node/2092410604'),
  ('catalogo-castilla-y-leon:postal_service:node-2104302779', 'Correos Espinosa de los Monteros – Plaza Sancho García', NULL, '09124', 'Plaza Sancho García 1', '09560', 43.0769, -3.5524, 'address', 'openstreetmap:node/2104302779'),
  ('catalogo-castilla-y-leon:postal_service:node-2119275767', 'Correos Valle de Mena – Calle Amistad', NULL, '09410', 'Calle Amistad 4', '09580', 43.09987, -3.28143, 'address', 'openstreetmap:node/2119275767'),
  ('catalogo-castilla-y-leon:postal_service:node-2139291281', 'Correos Salas de los Infantes – Calle Santa María', NULL, '09330', 'Calle Santa María', NULL, 42.02206, -3.28392, 'address', 'openstreetmap:node/2139291281'),
  ('catalogo-castilla-y-leon:postal_service:node-3043033357', 'Correos Cerezo de Río Tirón – Avenida Andrés Gutiérrez de Cerezo', NULL, '09098', 'Avenida Andrés Gutiérrez de Cerezo 5', '09270', 42.49119, -3.13578, 'address', 'openstreetmap:node/3043033357'),
  ('catalogo-castilla-y-leon:postal_service:node-3375031993', 'Correos Pradoluengo – Calle Mariano Santos', NULL, '09274', 'Calle Mariano Santos', '09260', 42.32353, -3.19997, 'address', 'openstreetmap:node/3375031993'),
  ('catalogo-castilla-y-leon:postal_service:node-367768929', 'Correos Roa – Plaza del Estudio', NULL, '09321', 'Plaza del Estudio', '09300', 41.69749, -3.92837, 'address', 'openstreetmap:node/367768929'),
  ('catalogo-castilla-y-leon:postal_service:node-514550172', 'Correos Burgos – Calle Rosa de Lima Manzano 14A', NULL, '09059', 'Calle Rosa de Lima Manzano 14A', NULL, 42.34754, -3.7145, 'address', 'openstreetmap:node/514550172'),
  ('catalogo-castilla-y-leon:postal_service:node-5805004194', 'Correos Sasamón – Plaza de Segisama', NULL, '09363', 'Plaza de Segisama', '09123', 42.41722, -4.04291, 'address', 'openstreetmap:node/5805004194'),
  ('catalogo-castilla-y-leon:postal_service:node-764953202', 'Correos Oña – Calle de Barruso', NULL, '09238', 'Calle de Barruso 1', '09530', 42.73456, -3.41352, 'address', 'openstreetmap:node/764953202'),
  ('catalogo-castilla-y-leon:postal_service:node-7824505580', 'Correos Burgos – Calle Polvorín Viejo de Santa Ana', NULL, '09059', 'Calle Polvorín Viejo de Santa Ana 2', '09001', 42.33125, -3.70954, 'address', 'openstreetmap:node/7824505580'),
  ('catalogo-castilla-y-leon:postal_service:way-209515198', 'Correos Miranda de Ebro – Plaza de Abastos', NULL, '09219', 'Plaza de Abastos 6', '09200', 42.68545, -2.94535, 'address', 'openstreetmap:way/209515198'),
  ('catalogo-castilla-y-leon:postal_service:way-81162010', 'Correos Burgos – Plaza Conde de Castro', NULL, '09059', 'Plaza Conde de Castro', '09002', 42.3393, -3.69921, 'address', 'openstreetmap:way/81162010');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '09');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 09 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '09'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 25 THEN
    RAISE EXCEPTION 'Se esperaban 25 puntos de Correos en Burgos, hay %', n;
  END IF;
END;
$$;

COMMIT;
