-- Carga de la categoría Correos de Málaga (provincia 29), trozo de la carga de Andalucía.
-- Origen: postal_service-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 69 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:postal_service:node-1013122147', 'Correos Istán – Calle San Miguel', NULL, '29061', 'Calle San Miguel', '29611', 36.58254, -4.94975, 'address', 'openstreetmap:node/1013122147'),
  ('catalogo-andalucia:postal_service:node-1024575779', 'Correos Manilva – Calle del Doctor Álvarez Leiva', NULL, '29068', 'Calle del Doctor Álvarez Leiva', '29691', 36.37648, -5.24757, 'address', 'openstreetmap:node/1024575779'),
  ('catalogo-andalucia:postal_service:node-1028234368', 'Correos Benahavís – Plaza de la Iglesia', NULL, '29023', 'Plaza de la Iglesia', '29679', 36.52368, -5.0463, 'address', 'openstreetmap:node/1028234368'),
  ('catalogo-andalucia:postal_service:node-11024989814', 'Correos Mijas – Camino del Albero', NULL, '29070', 'Camino del Albero', '29651', 36.54425, -4.64099, 'address', 'openstreetmap:node/11024989814'),
  ('catalogo-andalucia:postal_service:node-1110693968', 'Correos Casares – Calle Molinos', NULL, '29041', 'Calle Molinos', '29690', 36.4438, -5.27297, 'address', 'openstreetmap:node/1110693968'),
  ('catalogo-andalucia:postal_service:node-12455670640', 'Correos Almogía – Calle Pechillo', NULL, '29011', 'Calle Pechillo 3', '29150', 36.82575, -4.53953, 'address', 'openstreetmap:node/12455670640'),
  ('catalogo-andalucia:postal_service:node-1258766126', 'Correos Cortes de la Frontera – Calle Real', NULL, '29046', 'Calle Real', '29380', 36.61775, -5.34235, 'address', 'openstreetmap:node/1258766126'),
  ('catalogo-andalucia:postal_service:node-1262072365', 'Correos Jimera de Líbar – Calle Peña', NULL, '29063', 'Calle Peña', '29392', 36.65135, -5.27422, 'address', 'openstreetmap:node/1262072365'),
  ('catalogo-andalucia:postal_service:node-13759422341', 'Correos Monda – Calle Feria', NULL, '29073', 'Calle Feria', '29110', 36.63038, -4.83091, 'address', 'openstreetmap:node/13759422341'),
  ('catalogo-andalucia:postal_service:node-13998039712', 'Correos Riogordo – Plaza de la Constitución', NULL, '29083', 'Plaza de la Constitución', '29180', 36.91497, -4.2935, 'address', 'openstreetmap:node/13998039712'),
  ('catalogo-andalucia:postal_service:node-1668185875', 'Correos Cuevas Bajas – Calle Río', NULL, '29047', 'Calle Río', '29220', 37.23581, -4.48707, 'address', 'openstreetmap:node/1668185875'),
  ('catalogo-andalucia:postal_service:node-1714188810', 'Correos Rincón de la Victoria – Calle Poeta Manuel Alcántara', NULL, '29082', 'Calle Poeta Manuel Alcántara', '29730', 36.71639, -4.27944, 'address', 'openstreetmap:node/1714188810'),
  ('catalogo-andalucia:postal_service:node-1846927689', 'Correos Alhaurín de la Torre – Calle el Nogal', NULL, '29007', 'Calle el Nogal', '29130', 36.66213, -4.56077, 'address', 'openstreetmap:node/1846927689'),
  ('catalogo-andalucia:postal_service:node-1887331749', 'Correos Marbella – Calle de Jacinto Benavente', NULL, '29069', 'Calle de Jacinto Benavente', '29602', 36.51146, -4.89169, 'address', 'openstreetmap:node/1887331749'),
  ('catalogo-andalucia:postal_service:node-1925669868', 'Correos Gaucín – Paseo Ana Toval', NULL, '29056', 'Paseo Ana Toval', '29480', 36.51969, -5.32426, 'address', 'openstreetmap:node/1925669868'),
  ('catalogo-andalucia:postal_service:node-1987946354', 'Correos Yunquera – Plaza de la Constituciion', NULL, '29100', 'Plaza de la Constituciion', '29410', 36.73191, -4.92086, 'address', 'openstreetmap:node/1987946354'),
  ('catalogo-andalucia:postal_service:node-2030033915', 'Correos Canillas de Albaida – Calle de la Estación', NULL, '29034', 'Calle de la Estación', '29755', 36.84585, -3.98823, 'address', 'openstreetmap:node/2030033915'),
  ('catalogo-andalucia:postal_service:node-2032790243', 'Correos Ronda – Calle Virgen de la Paz', NULL, '29084', 'Calle Virgen de la Paz 20', '29400', 36.7429, -5.16669, 'address', 'openstreetmap:node/2032790243'),
  ('catalogo-andalucia:postal_service:node-2275682909', 'Correos Benalmádena – Calle Andújar', NULL, '29025', 'Calle Andújar', '29639', 36.59399, -4.57482, 'address', 'openstreetmap:node/2275682909'),
  ('catalogo-andalucia:postal_service:node-2335300002', 'Correos Antequera – Calle Nájera', NULL, '29015', 'Calle Nájera', '29200', 37.01635, -4.55722, 'address', 'openstreetmap:node/2335300002'),
  ('catalogo-andalucia:postal_service:node-2586328964', 'Correos Málaga – Calle José Calderón', NULL, '29067', 'Calle José Calderón 161', '29590', 36.72767, -4.54463, 'address', 'openstreetmap:node/2586328964'),
  ('catalogo-andalucia:postal_service:node-2663350040', 'Correos Torremolinos – Avenida Palma de Mallorca', NULL, '29901', 'Avenida Palma de Mallorca', '29620', 36.6211, -4.49973, 'address', 'openstreetmap:node/2663350040'),
  ('catalogo-andalucia:postal_service:node-2699612087', 'Correos Alhaurín el Grande – Calle Teatro', NULL, '29008', 'Calle Teatro', '29120', 36.64449, -4.6839, 'address', 'openstreetmap:node/2699612087'),
  ('catalogo-andalucia:postal_service:node-2704041362', 'Correos Málaga – Calle Maestro Vert', NULL, '29067', 'Calle Maestro Vert 3', '29140', 36.66638, -4.50328, 'address', 'openstreetmap:node/2704041362'),
  ('catalogo-andalucia:postal_service:node-2767096034', 'Correos Málaga – Calle Santa Lucía', NULL, '29067', 'Calle Santa Lucía 7', '29008', 36.7218, -4.42174, 'address', 'openstreetmap:node/2767096034'),
  ('catalogo-andalucia:postal_service:node-2967234680', 'Correos Ronda – Calle Médico Luis Peralta', NULL, '29084', 'Calle Médico Luis Peralta', '29400', 36.75297, -5.14948, 'address', 'openstreetmap:node/2967234680'),
  ('catalogo-andalucia:postal_service:node-3005072357', 'Correos Vélez-Málaga – Calle del Río', NULL, '29094', 'Calle del Río 28', '29700', 36.78099, -4.10667, 'address', 'openstreetmap:node/3005072357'),
  ('catalogo-andalucia:postal_service:node-307844902', 'Correos Nerja – Calle Almirante Ferrándiz', NULL, '29075', 'Calle Almirante Ferrándiz 6', '29780', 36.74598, -3.87566, 'address', 'openstreetmap:node/307844902'),
  ('catalogo-andalucia:postal_service:node-320541126', 'Correos Marbella – Calle Pizarro', NULL, '29069', 'Calle Pizarro', '29670', 36.48517, -4.98888, 'address', 'openstreetmap:node/320541126'),
  ('catalogo-andalucia:postal_service:node-3393754446', 'Correos Málaga – Calle Héroe de Sostoa', NULL, '29067', 'Calle Héroe de Sostoa 194', '29003', 36.70117, -4.44442, 'address', 'openstreetmap:node/3393754446'),
  ('catalogo-andalucia:postal_service:node-3431319895', 'Correos Benalmádena – Calle Dalí', NULL, '29025', 'Calle Dalí', '29631', 36.60057, -4.53495, 'address', 'openstreetmap:node/3431319895'),
  ('catalogo-andalucia:postal_service:node-3457870499', 'Correos Archidona – Calle Carrera', NULL, '29017', 'Calle Carrera', '29300', 37.09505, -4.38708, 'address', 'openstreetmap:node/3457870499'),
  ('catalogo-andalucia:postal_service:node-3925734027', 'Correos Coín – Calle Torre de Los Trinitarios', NULL, '29042', 'Calle Torre de Los Trinitarios', '29100', 36.65812, -4.75962, 'address', 'openstreetmap:node/3925734027'),
  ('catalogo-andalucia:postal_service:node-3996236708', 'Correos Estepona – Plaza García Caparrós', NULL, '29051', 'Plaza García Caparrós', '29680', 36.42503, -5.14385, 'address', 'openstreetmap:node/3996236708'),
  ('catalogo-andalucia:postal_service:node-4043585235', 'Correos Estepona – Calle Huerta Nueva', NULL, '29051', 'Calle Huerta Nueva', '29680', 36.42372, -5.15245, 'address', 'openstreetmap:node/4043585235'),
  ('catalogo-andalucia:postal_service:node-4148885917', 'Correos Mijas – Calle del Pilar', NULL, '29070', 'Calle del Pilar', '29650', 36.59461, -4.63954, 'address', 'openstreetmap:node/4148885917'),
  ('catalogo-andalucia:postal_service:node-4176617601', 'Correos Mijas – Calle San Wenceslao', NULL, '29070', 'Calle San Wenceslao', '29650', 36.48951, -4.71471, 'address', 'openstreetmap:node/4176617601'),
  ('catalogo-andalucia:postal_service:node-4296310890', 'Correos Fuente de Piedra – Avenida Andalucía', NULL, '29055', 'Avenida Andalucía 27', '29520', 37.13426, -4.73081, 'address', 'openstreetmap:node/4296310890'),
  ('catalogo-andalucia:postal_service:node-4501248280', 'Correos Málaga – Avenida de Las Postas', NULL, '29067', 'Avenida de Las Postas', '29014', 36.73802, -4.42227, 'address', 'openstreetmap:node/4501248280'),
  ('catalogo-andalucia:postal_service:node-4809627229', 'Correos Alozaina – Calle Rodahuevos', NULL, '29013', 'Calle Rodahuevos', '29567', 36.7282, -4.85635, 'address', 'openstreetmap:node/4809627229'),
  ('catalogo-andalucia:postal_service:node-4865490056', 'Correos Málaga – Alameda Capuchinos', NULL, '29067', 'Alameda Capuchinos 33', '29014', 36.73081, -4.41911, 'address', 'openstreetmap:node/4865490056'),
  ('catalogo-andalucia:postal_service:node-4902414008', 'Correos Rincón de la Victoria – Calle Arroyo Totalán', NULL, '29082', 'Calle Arroyo Totalán', '29720', 36.72323, -4.31391, 'address', 'openstreetmap:node/4902414008'),
  ('catalogo-andalucia:postal_service:node-5007820125', 'Correos Torremolinos – Camino del Pinillo', NULL, '29901', 'Camino del Pinillo', '29260', 36.61266, -4.51273, 'address', 'openstreetmap:node/5007820125'),
  ('catalogo-andalucia:postal_service:node-5046160670', 'Correos Rincón de la Victoria – Pasaje Calafate', NULL, '29082', 'Pasaje Calafate 2', '29720', 36.71623, -4.31168, 'address', 'openstreetmap:node/5046160670'),
  ('catalogo-andalucia:postal_service:node-5377714760', 'Correos Manilva – Avenida de España', NULL, '29068', 'Avenida de España', '29691', 36.36483, -5.23029, 'address', 'openstreetmap:node/5377714760'),
  ('catalogo-andalucia:postal_service:node-543636942', 'Correos Torrox – Avenida de Andalucía', NULL, '29091', 'Avenida de Andalucía 60', '29793', 36.73217, -3.96716, 'address', 'openstreetmap:node/543636942'),
  ('catalogo-andalucia:postal_service:node-5675880721', 'Correos Málaga – Calle Puerto', NULL, '29067', 'Calle Puerto 11', '29016', 36.72021, -4.4084, 'address', 'openstreetmap:node/5675880721'),
  ('catalogo-andalucia:postal_service:node-7883444406', 'Correos Málaga – Calle Pelayo', NULL, '29067', 'Calle Pelayo 2', '29009', 36.72171, -4.43251, 'address', 'openstreetmap:node/7883444406'),
  ('catalogo-andalucia:postal_service:node-7883444407', 'Correos Málaga – Calle Hilera', NULL, '29067', 'Calle Hilera 8', '29007', 36.71833, -4.43023, 'address', 'openstreetmap:node/7883444407'),
  ('catalogo-andalucia:postal_service:node-7883444408', 'Correos Málaga – Avenida Molière', NULL, '29067', 'Avenida Molière 4', '29004', 36.68966, -4.45623, 'address', 'openstreetmap:node/7883444408'),
  ('catalogo-andalucia:postal_service:node-7883472734', 'Correos Málaga', NULL, '29067', NULL, '29007', 36.71822, -4.45466, 'address', 'openstreetmap:node/7883472734'),
  ('catalogo-andalucia:postal_service:node-7883472735', 'Correos Málaga – Calle Blas de Lezo', NULL, '29067', 'Calle Blas de Lezo 4', '29011', 36.72747, -4.43471, 'address', 'openstreetmap:node/7883472735'),
  ('catalogo-andalucia:postal_service:node-7884379113', 'Correos Málaga – Calle Lope de Rueda', NULL, '29067', 'Calle Lope de Rueda 15', '29190', 36.73387, -4.47797, 'address', 'openstreetmap:node/7884379113'),
  ('catalogo-andalucia:postal_service:node-7884383391', 'Correos Málaga – Avenida Parménides', NULL, '29067', 'Avenida Parménides 13', '29010', 36.72193, -4.47981, 'address', 'openstreetmap:node/7884383391'),
  ('catalogo-andalucia:postal_service:node-7884389973', 'Correos Málaga – Calle Hamlet', NULL, '29067', 'Calle Hamlet', '29006', 36.70972, -4.46093, 'address', 'openstreetmap:node/7884389973'),
  ('catalogo-andalucia:postal_service:node-7884424174', 'Correos Málaga – Calle Jaén', NULL, '29067', 'Calle Jaén 3', '29004', 36.68593, -4.47148, 'address', 'openstreetmap:node/7884424174'),
  ('catalogo-andalucia:postal_service:node-8014122878', 'Correos Almargen – Calle Muelle', NULL, '29010', 'Calle Muelle', '29330', 37.00131, -5.02286, 'address', 'openstreetmap:node/8014122878'),
  ('catalogo-andalucia:postal_service:node-8153776483', 'Correos Estepona – Montemayor', NULL, '29051', 'Montemayor 34', '29689', 36.46218, -5.05232, 'address', 'openstreetmap:node/8153776483'),
  ('catalogo-andalucia:postal_service:node-850013049', 'Correos Málaga – Avenida Juan Sebastián Elcano', NULL, '29067', 'Avenida Juan Sebastián Elcano 178', '29017', 36.721, -4.36102, 'address', 'openstreetmap:node/850013049'),
  ('catalogo-andalucia:postal_service:node-8552329981', 'Correos Antequera – Plaza Virgen de Los Dolores', NULL, '29015', 'Plaza Virgen de Los Dolores', '29540', 37.03699, -4.727, 'address', 'openstreetmap:node/8552329981'),
  ('catalogo-andalucia:postal_service:node-878272654', 'Correos Fuengirola – Plaza de los Chinorros', NULL, '29054', 'Plaza de los Chinorros 5', '29640', 36.53806, -4.62316, 'address', 'openstreetmap:node/878272654'),
  ('catalogo-andalucia:postal_service:node-9001874740', 'Correos Villanueva del Trabuco – Plaza del Prado', NULL, '29097', 'Plaza del Prado', '29313', 37.02779, -4.33788, 'address', 'openstreetmap:node/9001874740'),
  ('catalogo-andalucia:postal_service:node-9091507210', 'Correos Vélez-Málaga – Pasaje Santo Domingo', NULL, '29094', 'Pasaje Santo Domingo', '29751', 36.74924, -4.06603, 'address', 'openstreetmap:node/9091507210'),
  ('catalogo-andalucia:postal_service:node-9307329255', 'Correos Málaga – Calle Explanada de la Estación', NULL, '29067', 'Calle Explanada de la Estación 3', '29002', 36.71205, -4.43111, 'address', 'openstreetmap:node/9307329255'),
  ('catalogo-andalucia:postal_service:node-945203434', 'Correos Villanueva de la Concepción – Calle Santa María', NULL, '29902', 'Calle Santa María', NULL, 36.93116, -4.52811, 'address', 'openstreetmap:node/945203434'),
  ('catalogo-andalucia:postal_service:node-968777389', 'Correos Algatocín – Avenida de Andalucía', NULL, '29006', 'Avenida de Andalucía', '29491', 36.57278, -5.27658, 'address', 'openstreetmap:node/968777389'),
  ('catalogo-andalucia:postal_service:node-976566151', 'Correos Benaoján – Calle Zona de La Vega', NULL, '29028', 'Calle Zona de La Vega', '29370', 36.72309, -5.25005, 'address', 'openstreetmap:node/976566151'),
  ('catalogo-andalucia:postal_service:node-9811422882', 'Correos Benalmádena – Avenida Antonio Machado', NULL, '29025', 'Avenida Antonio Machado 18', '29631', 36.59873, -4.51787, 'address', 'openstreetmap:node/9811422882'),
  ('catalogo-andalucia:postal_service:way-1200015531', 'Correos Alcaucín – Calle Egido', NULL, '29002', 'Calle Egido', '29711', 36.90351, -4.11365, 'address', 'openstreetmap:way/1200015531');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '29');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 29 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '29'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 69 THEN
    RAISE EXCEPTION 'Se esperaban 69 puntos de Correos en Málaga, hay %', n;
  END IF;
END;
$$;

COMMIT;
