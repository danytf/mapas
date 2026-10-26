-- Carga de la categoría Estaciones de Segovia (provincia 40), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 20 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-12284813952', 'Estación de Segovia-Guiomar – Calle Campos de Castilla', 'Tren', '40194', 'Calle Campos de Castilla', '40195', 40.91023, -4.09476, 'address', 'openstreetmap:node/12284813952'),
  ('catalogo-castilla-y-leon:estaciones:node-12284813953', 'Estación de tren de Segovia – Calle Murillo', 'Tren', '40194', 'Calle Murillo', '40006', 40.93353, -4.11348, 'address', 'openstreetmap:node/12284813953'),
  ('catalogo-castilla-y-leon:estaciones:node-1705641818', 'Estación de autobuses de Nava de la Asunción – Calle de Murillo', 'Autobús', '40138', 'Calle de Murillo', NULL, 41.15212, -4.48832, 'approximate', 'openstreetmap:node/1705641818'),
  ('catalogo-castilla-y-leon:estaciones:node-6181746482', 'Estación de tren de Los Cotos (Real Sitio de San Ildefonso) – Carretera del Puerto de Cotos', 'Tren', '40181', 'Carretera del Puerto de Cotos', '40100', 40.82232, -3.96456, 'address', 'openstreetmap:node/6181746482'),
  ('catalogo-castilla-y-leon:estaciones:way-1088785214', 'Estación de tren de Ortigosa del Monte – Avenida Leoncio Ciudad Morano', 'Tren', '40901', 'Avenida Leoncio Ciudad Morano', NULL, 40.8327, -4.16816, 'address', 'openstreetmap:way/1088785214'),
  ('catalogo-castilla-y-leon:estaciones:way-1135479477', 'Estación de tren de Los Ángeles de San Rafael (El Espinar) – Acceso estación', 'Tren', '40076', 'Acceso estación', '40424', 40.77852, -4.2074, 'address', 'openstreetmap:way/1135479477'),
  ('catalogo-castilla-y-leon:estaciones:way-1194238926', 'Terminal de Autobuses de Fuentesauco de Fuentidueña', 'Autobús', '40089', NULL, NULL, 41.42133, -4.06081, 'address', 'openstreetmap:way/1194238926'),
  ('catalogo-castilla-y-leon:estaciones:way-1201631840', 'Estación de tren de Otero-Herreros (Otero de Herreros) – Carretera de Sanchidrián', 'Tren', '40152', 'Carretera de Sanchidrián', NULL, 40.80092, -4.20356, 'address', 'openstreetmap:way/1201631840'),
  ('catalogo-castilla-y-leon:estaciones:way-1354537373', 'Estación de Autobuses de Cuéllar – Calle del Cardenal Bartolomé de la Cueva', 'Autobús', '40063', 'Calle del Cardenal Bartolomé de la Cueva 2', '40200', 41.39785, -4.31105, 'address', 'openstreetmap:way/1354537373'),
  ('catalogo-castilla-y-leon:estaciones:way-158341453', 'Estación de autobuses de Plaza de José Mata (Nava de la Asunción) – Calle de Murillo', 'Autobús', '40138', 'Calle de Murillo', NULL, 41.1521, -4.48827, 'approximate', 'openstreetmap:way/158341453'),
  ('catalogo-castilla-y-leon:estaciones:way-241765594', 'Estación de tren de El Espinar – Carretera Paso a Nivel', 'Tren', '40076', 'Carretera Paso a Nivel', NULL, 40.74084, -4.18952, 'address', 'openstreetmap:way/241765594'),
  ('catalogo-castilla-y-leon:estaciones:way-417320020', 'Estación de Autobuses del Vilorio Sierte (Cantalejo) – Calle/Polvorosa Charquillos', 'Autobús', '40040', 'Calle/Polvorosa Charquillos', '40320', 41.25868, -3.91963, 'address', 'openstreetmap:way/417320020'),
  ('catalogo-castilla-y-leon:estaciones:way-436232314', 'Estación autobuses Sepúlveda – Parada de Autobuses de Sepúlveda', 'Autobús', '40195', 'Parada de Autobuses de Sepúlveda', '40300', 41.29791, -3.7479, 'address', 'openstreetmap:way/436232314'),
  ('catalogo-castilla-y-leon:estaciones:way-436232489', 'Estación de autobuses de Boceguillas – Calle de la Cárcel', 'Autobús', '40032', 'Calle de la Cárcel', '40560', 41.34029, -3.64175, 'address', 'openstreetmap:way/436232489'),
  ('catalogo-castilla-y-leon:estaciones:way-436555128', 'Estación autobuses El Olmo (Barbolla) – Carretera de Sepúlveda', 'Autobús', '40025', 'Carretera de Sepúlveda', '40530', 41.30304, -3.66495, 'address', 'openstreetmap:way/436555128'),
  ('catalogo-castilla-y-leon:estaciones:way-582356742', 'Estación de Autobuses (Segovia) – Paseo de Ezequiel González', 'Autobús', '40194', 'Paseo de Ezequiel González 20', '40002', 40.94491, -4.12244, 'address', 'openstreetmap:way/582356742'),
  ('catalogo-castilla-y-leon:estaciones:way-669518729', 'Estación de tren de San Rafael (El Espinar) – Paseo del Apeadero', 'Tren', '40076', 'Paseo del Apeadero', '40410', 40.71494, -4.1814, 'address', 'openstreetmap:way/669518729'),
  ('catalogo-castilla-y-leon:estaciones:way-669519456', 'Estación de tren de Gudillos (El Espinar) – Camino del Apeadero', 'Tren', '40076', 'Camino del Apeadero 6', '40400', 40.71689, -4.15774, 'address', 'openstreetmap:way/669519456'),
  ('catalogo-castilla-y-leon:estaciones:way-833554401', 'Estación de autobuses de Riaza – Avenida del Docto Rafael  García Tapia', 'Autobús', '40170', 'Avenida del Docto Rafael  García Tapia', '40500', 41.27568, -3.48088, 'address', 'openstreetmap:way/833554401'),
  ('catalogo-castilla-y-leon:estaciones:way-852513103', 'Estación de tren de Navas de Riofrío-La Losa – Calle de la Estación', 'Tren', '40904', 'Calle de la Estación', NULL, 40.85665, -4.14115, 'address', 'openstreetmap:way/852513103');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '40');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 40 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '40'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 20 THEN
    RAISE EXCEPTION 'Se esperaban 20 puntos de Estaciones en Segovia, hay %', n;
  END IF;
END;
$$;

COMMIT;
