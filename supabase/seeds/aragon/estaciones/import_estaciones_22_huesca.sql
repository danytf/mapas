-- Carga de la categoría Estaciones de Huesca (provincia 22), trozo de la carga de Andalucía.
-- Origen: estaciones-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 31 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-aragon:estaciones:node-10284908056', 'Estación de tren de Villanúa-Letranz', 'Tren', '22250', NULL, NULL, 42.68857, -0.52349, 'address', 'openstreetmap:node/10284908056'),
  ('catalogo-aragon:estaciones:node-12123676705', 'Estación de tren de Almudévar', 'Tren', '22021', NULL, NULL, 41.99613, -0.6427, 'address', 'openstreetmap:node/12123676705'),
  ('catalogo-aragon:estaciones:node-12547037421', 'Estación de tren de Marcén-Poliñino (Lalueza)', 'Tren', '22136', NULL, NULL, 41.88191, -0.28332, 'address', 'openstreetmap:node/12547037421'),
  ('catalogo-aragon:estaciones:node-12549357005', 'Estación de tren de Tormillo-Lastanosa (Peralta de Alcofea)', 'Tren', '22174', NULL, NULL, 41.84902, -0.03763, 'address', 'openstreetmap:node/12549357005'),
  ('catalogo-aragon:estaciones:node-2190026009', 'Estación de tren de Monzón-Río Cinca – Calle de la Estación', 'Tren', '22158', 'Calle de la Estación', '22400', 41.91372, 0.1969, 'address', 'openstreetmap:node/2190026009'),
  ('catalogo-aragon:estaciones:node-36130230', 'Estación de tren de Selgua (Monzón)', 'Tren', '22158', NULL, NULL, 41.90596, 0.14847, 'address', 'openstreetmap:node/36130230'),
  ('catalogo-aragon:estaciones:node-36130273', 'Estación de tren de Binefar – Avenida Aragón', 'Tren', '22061', 'Avenida Aragón 50', '22500', 41.84974, 0.29141, 'address', 'openstreetmap:node/36130273'),
  ('catalogo-aragon:estaciones:node-4338239783', 'Estación de tren de Tardienta – Calle Fidel y Mario Seral', 'Tren', '22226', 'Calle Fidel y Mario Seral', NULL, 41.97557, -0.53843, 'address', 'openstreetmap:node/4338239783'),
  ('catalogo-aragon:estaciones:node-6127183265', 'Estación de tren de Santa María y La Peña (Las Peñas de Riglos)', 'Tren', '22173', NULL, NULL, 42.38025, -0.69581, 'address', 'openstreetmap:node/6127183265'),
  ('catalogo-aragon:estaciones:node-6221123437', 'Estación de tren de Tamarite - Altorricón (Tamarite de Litera / Tamarit de Llitera)', 'Tren', '22225', NULL, NULL, 41.77899, 0.37499, 'address', 'openstreetmap:node/6221123437'),
  ('catalogo-aragon:estaciones:node-7572455884', 'Estación de tren de Canfranc', 'Tren', '22078', NULL, NULL, 42.75112, -0.51311, 'address', 'openstreetmap:node/7572455884'),
  ('catalogo-aragon:estaciones:node-7593094343', 'Estación de tren de Plasencia del Monte (La Sotonera)', 'Tren', '22904', NULL, NULL, 42.20504, -0.56099, 'address', 'openstreetmap:node/7593094343'),
  ('catalogo-aragon:estaciones:node-7593193736', 'Estación de tren de Riglos (Las Peñas de Riglos)', 'Tren', '22173', NULL, NULL, 42.34424, -0.73147, 'address', 'openstreetmap:node/7593193736'),
  ('catalogo-aragon:estaciones:node-7593193756', 'Estación de tren de Riglos-Concilio (Las Peñas de Riglos)', 'Tren', '22173', NULL, NULL, 42.31632, -0.72733, 'address', 'openstreetmap:node/7593193756'),
  ('catalogo-aragon:estaciones:node-8051540821', 'Estación de tren de Huesca (Huesca/Uesca) – Calle de José Gil Cávez', 'Tren', '22125', 'Calle de José Gil Cávez 10', '22005', 42.13275, -0.40985, 'address', 'openstreetmap:node/8051540821'),
  ('catalogo-aragon:estaciones:node-8051540823', 'Estación de tren de Castiello (Castiello de Jaca)', 'Tren', '22086', NULL, NULL, 42.64995, -0.55516, 'address', 'openstreetmap:node/8051540823'),
  ('catalogo-aragon:estaciones:node-8051540827', 'Estación de tren de Castiello-Pueblo (Castiello de Jaca)', 'Tren', '22086', NULL, '22710', 42.6256, -0.54382, 'address', 'openstreetmap:node/8051540827'),
  ('catalogo-aragon:estaciones:node-8051540831', 'Estación de tren de Jaca – Calle Estación', 'Tren', '22130', 'Calle Estación', '22700', 42.57773, -0.53846, 'address', 'openstreetmap:node/8051540831'),
  ('catalogo-aragon:estaciones:node-8051540853', 'Estación de tren de Sabiñánigo – Calle del Serrablo', 'Tren', '22199', 'Calle del Serrablo 4', '22600', 42.52022, -0.37335, 'address', 'openstreetmap:node/8051540853'),
  ('catalogo-aragon:estaciones:node-8051540854', 'Estación de tren de Caldearenas-Aquilué – Barrio Estación', 'Tren', '22072', 'Barrio Estación', NULL, 42.39785, -0.49928, 'address', 'openstreetmap:node/8051540854'),
  ('catalogo-aragon:estaciones:node-8051540855', 'Estación de tren de Anzánigo (Caldearenas)', 'Tren', '22072', NULL, NULL, 42.4032, -0.64308, 'address', 'openstreetmap:node/8051540855'),
  ('catalogo-aragon:estaciones:node-8051540856', 'Estación de tren de Ayerbe – Avenida de Loarre', 'Tren', '22039', 'Avenida de Loarre', NULL, 42.27553, -0.68243, 'address', 'openstreetmap:node/8051540856'),
  ('catalogo-aragon:estaciones:node-9256006949', 'Estación de tren de Grañén – Avenida de Ramón y Cajal', 'Tren', '22116', 'Avenida de Ramón y Cajal', '22260', 41.93796, -0.36931, 'address', 'openstreetmap:node/9256006949'),
  ('catalogo-aragon:estaciones:way-1088564497', 'Estación de tren de Sariñena', 'Tren', '22213', NULL, NULL, 41.81725, -0.17266, 'address', 'openstreetmap:way/1088564497'),
  ('catalogo-aragon:estaciones:way-118626608', 'Estación de Autobuses de Jaca – Avenida Jacetania', 'Autobús', '22130', 'Avenida Jacetania', '22700', 42.57151, -0.54751, 'address', 'openstreetmap:way/118626608'),
  ('catalogo-aragon:estaciones:way-1309414418', 'Estación de tren de Marcén-Poleñino (Lalueza)', 'Tren', '22136', NULL, NULL, 41.88355, -0.28607, 'address', 'openstreetmap:way/1309414418'),
  ('catalogo-aragon:estaciones:way-176767767', 'Estación de autobuses de Fraga – Avenida del Parque', 'Autobús', '22112', 'Avenida del Parque', '22520', 41.52289, 0.34392, 'address', 'openstreetmap:way/176767767'),
  ('catalogo-aragon:estaciones:way-184335073', 'Estacion de Autobuses Monzón – Calle San José de Calasanz', 'Autobús', '22158', 'Calle San José de Calasanz 2', '22400', 41.91247, 0.19023, 'address', 'openstreetmap:way/184335073'),
  ('catalogo-aragon:estaciones:way-198157302', 'Estación de autobuses de Binéfar – Avenida Aragón', 'Autobús', '22061', 'Avenida Aragón 50', '22500', 41.8499, 0.29198, 'address', 'openstreetmap:way/198157302'),
  ('catalogo-aragon:estaciones:way-376842306', 'Estación de Autobuses Sabiñánigo – Calle del Serrablo', 'Autobús', '22199', 'Calle del Serrablo 4', '22600', 42.52021, -0.37294, 'address', 'openstreetmap:way/376842306'),
  ('catalogo-aragon:estaciones:way-550832959', 'Estación de Autobuses de Barbastro – Plaza de Aragón', 'Autobús', '22048', 'Plaza de Aragón 4', '22300', 42.03545, 0.12045, 'address', 'openstreetmap:way/550832959');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '22');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 22 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '22'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 31 THEN
    RAISE EXCEPTION 'Se esperaban 31 puntos de Estaciones en Huesca, hay %', n;
  END IF;
END;
$$;

COMMIT;
