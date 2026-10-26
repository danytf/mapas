-- Carga de la categoría Correos de Teruel (provincia 44), trozo de la carga de Andalucía.
-- Origen: postal_service-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 11 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-aragon:postal_service:node-11752727191', 'Correos Rubielos de Mora – Calle Sin Cabo Baja', NULL, '44201', 'Calle Sin Cabo Baja 4', '44415', 40.19004, -0.65317, 'address', 'openstreetmap:node/11752727191'),
  ('catalogo-aragon:postal_service:node-14185297995', 'Correos Urrea de Gaén – Calle General Cabañero', NULL, '44237', 'Calle General Cabañero', NULL, 41.15922, -0.47083, 'address', 'openstreetmap:node/14185297995'),
  ('catalogo-aragon:postal_service:node-3411176448', 'Correos Albarracín – Calle de la Catedral', NULL, '44009', 'Calle de la Catedral 3', '44100', 40.40761, -1.44378, 'address', 'openstreetmap:node/3411176448'),
  ('catalogo-aragon:postal_service:node-4541762608', 'Correos Monreal del Campo – Calle Montes Universales', NULL, '44153', 'Calle Montes Universales', NULL, 40.78686, -1.35617, 'address', 'openstreetmap:node/4541762608'),
  ('catalogo-aragon:postal_service:node-4733934290', 'Correos Santa Eulalia – Calle Calvo Sotelo', NULL, '44209', 'Calle Calvo Sotelo 58', '44360', 40.57085, -1.31261, 'address', 'openstreetmap:node/4733934290'),
  ('catalogo-aragon:postal_service:node-5454472738', 'Correos Híjar – Carretera Zaragoza', NULL, '44122', 'Carretera Zaragoza 1', '44530', 41.17529, -0.45332, 'address', 'openstreetmap:node/5454472738'),
  ('catalogo-aragon:postal_service:node-8850351473', 'Correos Mas de las Matas – Calle Santa Lucia', NULL, '44145', 'Calle Santa Lucia', '44564', 40.83373, -0.2436, 'address', 'openstreetmap:node/8850351473'),
  ('catalogo-aragon:postal_service:node-9020768330', 'Correos Valderrobres / Vall de Roures – Avenida de la Hispanidad', NULL, '44246', 'Avenida de la Hispanidad 11', '44580', 40.87383, 0.15422, 'address', 'openstreetmap:node/9020768330'),
  ('catalogo-aragon:postal_service:way-447002623', 'Correos Teruel – Calle Yagüe de Salas', NULL, '44216', 'Calle Yagüe de Salas 19', '44001', 40.34316, -1.10864, 'address', 'openstreetmap:way/447002623'),
  ('catalogo-aragon:postal_service:way-452694120', 'Correos Teruel – Camino del Repetidor', NULL, '44216', 'Camino del Repetidor', NULL, 40.35424, -1.1077, 'address', 'openstreetmap:way/452694120'),
  ('catalogo-aragon:postal_service:way-492712342', 'Correos Andorra – Avenida Dos de Mayo', NULL, '44025', 'Avenida Dos de Mayo 45', '44500', 40.97677, -0.44596, 'address', 'openstreetmap:way/492712342');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '44');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 44 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '44'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 11 THEN
    RAISE EXCEPTION 'Se esperaban 11 puntos de Correos en Teruel, hay %', n;
  END IF;
END;
$$;

COMMIT;
