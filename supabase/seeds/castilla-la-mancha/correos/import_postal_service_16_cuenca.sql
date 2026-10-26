-- Carga de la categoría Correos de Cuenca (provincia 16), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 13 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:postal_service:node-12396820220', 'Correos Cuenca – Calle Hermanos Becerril', NULL, '16078', 'Calle Hermanos Becerril', NULL, 40.05994, -2.13078, 'address', 'openstreetmap:node/12396820220'),
  ('catalogo-castilla-la-mancha:postal_service:node-2298853330', 'Correos Sisante – Calle Convento', NULL, '16198', 'Calle Convento', NULL, 39.40685, -2.20086, 'address', 'openstreetmap:node/2298853330'),
  ('catalogo-castilla-la-mancha:postal_service:node-3027848642', 'Correos Valverde de Júcar – Calle Reloj', NULL, '16236', 'Calle Reloj', NULL, 39.71856, -2.21898, 'address', 'openstreetmap:node/3027848642'),
  ('catalogo-castilla-la-mancha:postal_service:node-324119164', 'Correos Belmonte – Calle Conde Lucanor', NULL, '16033', 'Calle Conde Lucanor', NULL, 39.56027, -2.70564, 'address', 'openstreetmap:node/324119164'),
  ('catalogo-castilla-la-mancha:postal_service:node-4395035989', 'Correos Priego – Larga', NULL, '16170', 'Larga', NULL, 40.4492, -2.31568, 'address', 'openstreetmap:node/4395035989'),
  ('catalogo-castilla-la-mancha:postal_service:node-4419338066', 'Correos El Provencio – Calle Félix Lorca', NULL, '16171', 'Calle Félix Lorca', '16670', 39.37601, -2.57248, 'address', 'openstreetmap:node/4419338066'),
  ('catalogo-castilla-la-mancha:postal_service:node-4771875421', 'Correos Cuenca – Calle del Parque San Julián', NULL, '16078', 'Calle del Parque San Julián 15', '16001', 40.07382, -2.13457, 'address', 'openstreetmap:node/4771875421'),
  ('catalogo-castilla-la-mancha:postal_service:node-5825371153', 'Correos Cañete – Carretera Valdemeca', NULL, '16052', 'Carretera Valdemeca 4', '16300', 40.04231, -1.64731, 'address', 'openstreetmap:node/5825371153'),
  ('catalogo-castilla-la-mancha:postal_service:node-6982804053', 'Correos Villamayor de Santiago – Calle Principe Felipe', NULL, '16249', 'Calle Principe Felipe', NULL, 39.7306, -2.92417, 'address', 'openstreetmap:node/6982804053'),
  ('catalogo-castilla-la-mancha:postal_service:node-7618139617', 'Correos Huete – Calle de Juan Carlos I', NULL, '16112', 'Calle de Juan Carlos I 16', NULL, 40.14534, -2.68989, 'address', 'openstreetmap:node/7618139617'),
  ('catalogo-castilla-la-mancha:postal_service:node-7632343953', 'Correos Talayuelas – Calle Real', NULL, '16202', 'Calle Real 18', '16320', 39.84805, -1.28315, 'address', 'openstreetmap:node/7632343953'),
  ('catalogo-castilla-la-mancha:postal_service:node-8711058407', 'Correos Villalba de la Sierra – Avenida de la Constitución', NULL, '16245', 'Avenida de la Constitución', '16140', 40.23329, -2.08947, 'address', 'openstreetmap:node/8711058407'),
  ('catalogo-castilla-la-mancha:postal_service:way-1086068880', 'Correos San Lorenzo de la Parrilla – Plaza Mayor', NULL, '16191', 'Plaza Mayor 4', NULL, 39.85139, -2.36102, 'address', 'openstreetmap:way/1086068880');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '16');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 16 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '16'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 13 THEN
    RAISE EXCEPTION 'Se esperaban 13 puntos de Correos en Cuenca, hay %', n;
  END IF;
END;
$$;

COMMIT;
