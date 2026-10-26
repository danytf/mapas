-- Carga de la categoría Estaciones de Guadalajara (provincia 19), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 12 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:estaciones:node-11753241224', 'Estación de tren de Espinosa de Henares – Calle Rivera del Henares', 'Tren', '19113', 'Calle Rivera del Henares', NULL, 40.90971, -3.07316, 'address', 'openstreetmap:node/11753241224'),
  ('catalogo-castilla-la-mancha:estaciones:node-12442692485', 'Estación de tren de Yunquera de Henares – Paso de La Estación', 'Tren', '19331', 'Paso de La Estación', NULL, 40.74699, -3.16308, 'address', 'openstreetmap:node/12442692485'),
  ('catalogo-castilla-la-mancha:estaciones:node-13641576097', 'Estación de tren de Humanes de Mohernando – Paseo Estación', 'Tren', '19151', 'Paseo Estación', NULL, 40.83117, -3.13891, 'address', 'openstreetmap:node/13641576097'),
  ('catalogo-castilla-la-mancha:estaciones:node-2461676724', 'Estación de tren de Carrascosa de Henares (Espinosa de Henares) – Paseo Apeadero', 'Tren', '19113', 'Paseo Apeadero', NULL, 40.90586, -3.01438, 'address', 'openstreetmap:node/2461676724'),
  ('catalogo-castilla-la-mancha:estaciones:node-26382278', 'Estación de tren de Guadalajara - Yebes', 'Tren', '19326', NULL, NULL, 40.58637, -3.12643, 'address', 'openstreetmap:node/26382278'),
  ('catalogo-castilla-la-mancha:estaciones:node-321577458', 'Estación de tren de Sigüenza – Carretera de Atienza', 'Tren', '19257', 'Carretera de Atienza', NULL, 41.07144, -2.64622, 'address', 'openstreetmap:node/321577458'),
  ('catalogo-castilla-la-mancha:estaciones:node-6185935419', 'Estación de tren de Azuqueca (Azuqueca de Henares) – Parking Renfe Azuqueca', 'Tren', '19046', 'Parking Renfe Azuqueca', NULL, 40.56101, -3.26534, 'address', 'openstreetmap:node/6185935419'),
  ('catalogo-castilla-la-mancha:estaciones:node-6186096064', 'Estación de tren de Jadraque', 'Tren', '19156', NULL, NULL, 40.93, -2.93585, 'address', 'openstreetmap:node/6186096064'),
  ('catalogo-castilla-la-mancha:estaciones:node-6186096065', 'Estación de tren de Matillas', 'Tren', '19174', NULL, NULL, 40.95385, -2.84328, 'address', 'openstreetmap:node/6186096065'),
  ('catalogo-castilla-la-mancha:estaciones:node-6186096067', 'Estación de tren de Baides', 'Tren', '19047', NULL, NULL, 41.00489, -2.78602, 'address', 'openstreetmap:node/6186096067'),
  ('catalogo-castilla-la-mancha:estaciones:node-6313228293', 'Estación de tren de Guadalajara – Calle de Francisco Aritio', 'Tren', '19130', 'Calle de Francisco Aritio', NULL, 40.64408, -3.18225, 'address', 'openstreetmap:node/6313228293'),
  ('catalogo-castilla-la-mancha:estaciones:way-1446528228', 'Estación de Autobuses de Guadalajara – Calle Dos de Mayo', 'Autobús', '19130', 'Calle Dos de Mayo 2', '19004', 40.63614, -3.17326, 'address', 'openstreetmap:way/1446528228');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '19');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 19 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '19'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 12 THEN
    RAISE EXCEPTION 'Se esperaban 12 puntos de Estaciones en Guadalajara, hay %', n;
  END IF;
END;
$$;

COMMIT;
