-- Carga de la categoría Estaciones de Zamora (provincia 49), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 15 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-13364248776', 'Estación de tren de Sanabria Alta Velocidad (Palacios de Sanabria)', 'Tren', '49143', NULL, NULL, 42.04477, -6.56291, 'address', 'openstreetmap:node/13364248776'),
  ('catalogo-castilla-y-leon:estaciones:node-13646554042', 'Estación de tren de Carbajales de Alba', 'Tren', '49036', NULL, NULL, 41.68163, -5.97197, 'address', 'openstreetmap:node/13646554042'),
  ('catalogo-castilla-y-leon:estaciones:node-13646554043', 'Estación de tren de Ferreruela de Tábara – Calle Apeadero', 'Tren', '49068', 'Calle Apeadero', NULL, 41.76409, -6.07393, 'address', 'openstreetmap:node/13646554043'),
  ('catalogo-castilla-y-leon:estaciones:node-13646554044', 'Estación de tren de Abejera (Riofrío de Aliste)', 'Tren', '49176', NULL, NULL, 41.80942, -6.14182, 'address', 'openstreetmap:node/13646554044'),
  ('catalogo-castilla-y-leon:estaciones:node-13646554045', 'Estación de tren de Sarracín de Aliste (Riofrío de Aliste)', 'Tren', '49176', NULL, NULL, 41.84834, -6.20503, 'address', 'openstreetmap:node/13646554045'),
  ('catalogo-castilla-y-leon:estaciones:node-13646554046', 'Estación de tren de Cabañas de Aliste (Riofrío de Aliste) – Calle Tras las Casas', 'Tren', '49176', 'Calle Tras las Casas', NULL, 41.85457, -6.24638, 'address', 'openstreetmap:node/13646554046'),
  ('catalogo-castilla-y-leon:estaciones:node-13646554048', 'Estación de tren de Linarejos-Pedroso (Manzanal de Arriba)', 'Tren', '49110', NULL, NULL, 41.94696, -6.48471, 'address', 'openstreetmap:node/13646554048'),
  ('catalogo-castilla-y-leon:estaciones:node-14141879025', 'Estación de Autobuses de Zamora – Avenida de Federico Cantero Villamil', 'Autobús', '49275', 'Avenida de Federico Cantero Villamil', '49029', 41.51385, -5.73916, 'address', 'openstreetmap:node/14141879025'),
  ('catalogo-castilla-y-leon:estaciones:node-1419646439', 'Estación de tren de Puebla de Sanabria', 'Tren', '49166', NULL, NULL, 42.04552, -6.62699, 'address', 'openstreetmap:node/1419646439'),
  ('catalogo-castilla-y-leon:estaciones:node-791063229', 'Estación de tren de Zamora – Carretera de la Estación', 'Tren', '49275', 'Carretera de la Estación', NULL, 41.516, -5.73978, 'address', 'openstreetmap:node/791063229'),
  ('catalogo-castilla-y-leon:estaciones:node-9088943157', 'Estación de tren de Toro – Carretera de la Estación', 'Tren', '49219', 'Carretera de la Estación', NULL, 41.51178, -5.38333, 'address', 'openstreetmap:node/9088943157'),
  ('catalogo-castilla-y-leon:estaciones:relation-4479742', 'Estación de autobuses de Toro – Calle Alba', 'Autobús', '49219', 'Calle Alba', NULL, 41.52523, -5.38852, 'address', 'openstreetmap:relation/4479742'),
  ('catalogo-castilla-y-leon:estaciones:relation-5315990', 'Estación de autobuses de Benavente – Avenida El Ferial', 'Autobús', '49021', 'Avenida El Ferial 62', '49600', 41.99894, -5.67695, 'address', 'openstreetmap:relation/5315990'),
  ('catalogo-castilla-y-leon:estaciones:way-444428189', 'Estación de autobuses de Villalpando – Camino de Toro', 'Autobús', '49250', 'Camino de Toro', NULL, 41.85984, -5.41647, 'address', 'openstreetmap:way/444428189'),
  ('catalogo-castilla-y-leon:estaciones:way-508938589', 'Parada de Autobús de Villardiga – Carretera de Villamartín de Campos a Zamora', 'Autobús', '49266', 'Carretera de Villamartín de Campos a Zamora', NULL, 41.8189, -5.46677, 'approximate', 'openstreetmap:way/508938589');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '49');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 49 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '49'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 15 THEN
    RAISE EXCEPTION 'Se esperaban 15 puntos de Estaciones en Zamora, hay %', n;
  END IF;
END;
$$;

COMMIT;
