-- Carga de la categoría Correos de Araba/Álava (provincia 01), trozo de la carga de Andalucía.
-- Origen: postal_service-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 13 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-pais-vasco:postal_service:node-10247469966', 'Correos Vitoria-Gasteiz – Plaza Nagusia', NULL, '01059', 'Plaza Nagusia 6', '01013', 42.87616, -2.67794, 'address', 'openstreetmap:node/10247469966'),
  ('catalogo-pais-vasco:postal_service:node-10700128020', 'Correos Amurrio – Landako kalea', NULL, '01002', 'Landako kalea 10', '01470', 43.05124, -3.00099, 'address', 'openstreetmap:node/10700128020'),
  ('catalogo-pais-vasco:postal_service:node-1950559325', 'Correos Vitoria-Gasteiz – Praga hiribidea', NULL, '01059', 'Praga hiribidea 17', '01003', 42.84619, -2.65082, 'address', 'openstreetmap:node/1950559325'),
  ('catalogo-pais-vasco:postal_service:node-2197201255', 'Correos Asparrena – Elizalde kalea', NULL, '01009', 'Elizalde kalea 5', '01250', 42.88983, -2.31664, 'address', 'openstreetmap:node/2197201255'),
  ('catalogo-pais-vasco:postal_service:node-2360180011', 'Correos Elciego – Avda. Marqués de Riscal', NULL, '01022', 'Avda. Marqués de Riscal', '01340', 42.51637, -2.61988, 'address', 'openstreetmap:node/2360180011'),
  ('catalogo-pais-vasco:postal_service:node-501607630', 'Correos Vitoria-Gasteiz – Kuba kalea', NULL, '01059', 'Kuba kalea 1', '01012', 42.85788, -2.6804, 'address', 'openstreetmap:node/501607630'),
  ('catalogo-pais-vasco:postal_service:node-5589399730', 'Correos Oyón-Oion – Santa Luzia kalea', NULL, '01043', 'Santa Luzia kalea', '01320', 42.5025, -2.43492, 'address', 'openstreetmap:node/5589399730'),
  ('catalogo-pais-vasco:postal_service:node-5929576381', 'Correos Vitoria-Gasteiz – Trenbide kalea', NULL, '01059', 'Trenbide kalea 10', '01006', 42.84003, -2.66782, 'address', 'openstreetmap:node/5929576381'),
  ('catalogo-pais-vasco:postal_service:node-5929576383', 'Correos Vitoria-Gasteiz – Legutianoko atea', NULL, '01059', 'Legutianoko atea 12', '01002', 42.85307, -2.6688, 'address', 'openstreetmap:node/5929576383'),
  ('catalogo-pais-vasco:postal_service:node-5929578785', 'Correos Vitoria-Gasteiz – Iruñea kalea', NULL, '01059', 'Iruñea kalea 31', '01010', 42.86351, -2.69999, 'address', 'openstreetmap:node/5929578785'),
  ('catalogo-pais-vasco:postal_service:node-679656879', 'Correos Vitoria-Gasteiz – Mediterraneoaren hiribidea 39-41', NULL, '01059', 'Mediterraneoaren hiribidea 39-41', '01015', 42.84471, -2.69476, 'address', 'openstreetmap:node/679656879'),
  ('catalogo-pais-vasco:postal_service:node-9689456804', 'Correos Alegría-Dulantzi – Dulantzi kalea', NULL, '01001', 'Dulantzi kalea 3', '01240', 42.84219, -2.51127, 'address', 'openstreetmap:node/9689456804'),
  ('catalogo-pais-vasco:postal_service:relation-8201119', 'Correos Vitoria-Gasteiz – Posta kalea', NULL, '01059', 'Posta kalea 9', '01001', 42.84615, -2.67142, 'address', 'openstreetmap:relation/8201119');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '01');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 01 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '01'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 13 THEN
    RAISE EXCEPTION 'Se esperaban 13 puntos de Correos en Araba/Álava, hay %', n;
  END IF;
END;
$$;

COMMIT;
