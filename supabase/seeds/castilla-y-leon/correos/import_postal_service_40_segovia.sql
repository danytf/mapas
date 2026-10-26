-- Carga de la categoría Correos de Segovia (provincia 40), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 14 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-10836741758', 'Correos Villacastín – Calle los Caballeros', NULL, '40225', 'Calle los Caballeros 10', '40150', 40.77939, -4.41121, 'address', 'openstreetmap:node/10836741758'),
  ('catalogo-castilla-y-leon:postal_service:node-11866685359', 'Correos Segovia', NULL, '40194', NULL, '40006', 40.92191, -4.11237, 'address', 'openstreetmap:node/11866685359'),
  ('catalogo-castilla-y-leon:postal_service:node-12715664145', 'Correos Torrecaballeros – Calle Potro', NULL, '40203', 'Calle Potro 20', '40160', 40.99182, -4.02433, 'address', 'openstreetmap:node/12715664145'),
  ('catalogo-castilla-y-leon:postal_service:node-13011576318', 'Correos Riaza – Calle de la Cava', NULL, '40170', 'Calle de la Cava 21', '40500', 41.27958, -3.48047, 'address', 'openstreetmap:node/13011576318'),
  ('catalogo-castilla-y-leon:postal_service:node-1404339589', 'Correos Carbonero el Mayor – Calle Frontón', NULL, '40043', 'Calle Frontón', '40270', 41.12231, -4.26816, 'address', 'openstreetmap:node/1404339589'),
  ('catalogo-castilla-y-leon:postal_service:node-1435005988', 'Correos Cuéllar – Calle de los Lavaderos', NULL, '40063', 'Calle de los Lavaderos', '40200', 41.40249, -4.31364, 'address', 'openstreetmap:node/1435005988'),
  ('catalogo-castilla-y-leon:postal_service:node-1822240849', 'Correos Coca – Calle Canongía', NULL, '40057', 'Calle Canongía', '40480', 41.21758, -4.52343, 'address', 'openstreetmap:node/1822240849'),
  ('catalogo-castilla-y-leon:postal_service:node-2264633538', 'Correos Real Sitio de San Ildefonso – Plazuela de la Calandria', NULL, '40181', 'Plazuela de la Calandria', '40100', 40.90056, -4.00471, 'address', 'openstreetmap:node/2264633538'),
  ('catalogo-castilla-y-leon:postal_service:node-3690537447', 'Correos El Espinar – Calle Convento', NULL, '40076', 'Calle Convento', '40400', 40.71674, -4.24827, 'address', 'openstreetmap:node/3690537447'),
  ('catalogo-castilla-y-leon:postal_service:node-4135688860', 'Correos Fuentepelayo – Plaza Mayor', NULL, '40086', 'Plaza Mayor 1', '40260', 41.22167, -4.17653, 'address', 'openstreetmap:node/4135688860'),
  ('catalogo-castilla-y-leon:postal_service:way-1122473042', 'Correos Sepúlveda – Calle de Espinacar 2,4', NULL, '40195', 'Calle de Espinacar 2,4', '40300', 41.29629, -3.74805, 'address', 'openstreetmap:way/1122473042'),
  ('catalogo-castilla-y-leon:postal_service:way-1183895866', 'Correos Valverde del Majano – Calle Álamo', NULL, '40216', 'Calle Álamo 85', '40140', 40.9586, -4.19771, 'address', 'openstreetmap:way/1183895866'),
  ('catalogo-castilla-y-leon:postal_service:way-1296048807', 'Correos Fresno de Cantespino', NULL, '40079', NULL, NULL, 41.34301, -3.52388, 'address', 'openstreetmap:way/1296048807'),
  ('catalogo-castilla-y-leon:postal_service:way-294501050', 'Correos Segovia – Plaza de San Facundo', NULL, '40194', 'Plaza de San Facundo 5', '40001', 40.95032, -4.12066, 'address', 'openstreetmap:way/294501050');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 14 THEN
    RAISE EXCEPTION 'Se esperaban 14 puntos de Correos en Segovia, hay %', n;
  END IF;
END;
$$;

COMMIT;
