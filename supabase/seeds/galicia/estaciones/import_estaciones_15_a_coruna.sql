-- Carga de la categoría Estaciones de A Coruña (provincia 15), trozo de la carga de Andalucía.
-- Origen: estaciones-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 59 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-galicia:estaciones:node-12563980207', 'Estación de tren de A Ponte de Mera (Ortigueira)', 'Tren', '15061', NULL, NULL, 43.66606, -7.90256, 'address', 'openstreetmap:node/12563980207'),
  ('catalogo-galicia:estaciones:node-12587231537', 'Estación de tren de Padrón – A Matanza', 'Tren', '15065', 'A Matanza', '15917', 42.73898, -8.65241, 'address', 'openstreetmap:node/12587231537'),
  ('catalogo-galicia:estaciones:node-12589966787', 'Estación de tren de Osebe (Teo)', 'Tren', '15082', NULL, NULL, 42.82523, -8.61568, 'address', 'openstreetmap:node/12589966787'),
  ('catalogo-galicia:estaciones:node-12768629140', 'Estación de tren de Santiago de Compostela - Daniel Castelao – Rúa do Hórreo', 'Tren', '15078', 'Rúa do Hórreo', '15702', 42.87044, -8.5452, 'address', 'openstreetmap:node/12768629140'),
  ('catalogo-galicia:estaciones:node-12793504327', 'Estación de tren de Cerceda-Meirama', 'Tren', '15024', NULL, NULL, 43.20766, -8.44664, 'address', 'openstreetmap:node/12793504327'),
  ('catalogo-galicia:estaciones:node-13448962867', 'Estación de tren de Piñoi (Oza Cesuras)', 'Tren', '15902', NULL, NULL, 43.14526, -8.1913, 'address', 'openstreetmap:node/13448962867'),
  ('catalogo-galicia:estaciones:node-13453006278', 'Estación de tren de Ordes', 'Tren', '15059', NULL, NULL, 43.03786, -8.44821, 'address', 'openstreetmap:node/13453006278'),
  ('catalogo-galicia:estaciones:node-13573540430', 'Estación de tren de Curtis – Praza de Compostela', 'Tren', '15032', 'Praza de Compostela', NULL, 43.1273, -8.14324, 'address', 'openstreetmap:node/13573540430'),
  ('catalogo-galicia:estaciones:node-13782316672', 'Estación de tren de A Coruña – Avenida do Ferrocarril', 'Tren', '15030', 'Avenida do Ferrocarril 2', '15008', 43.35252, -8.40995, 'address', 'openstreetmap:node/13782316672'),
  ('catalogo-galicia:estaciones:node-13782316673', 'Estación de tren de Elviña-Universidade (A Coruña) – Rúa José Pascual López Cortón', 'Tren', '15030', 'Rúa José Pascual López Cortón', '15008', 43.33525, -8.41301, 'address', 'openstreetmap:node/13782316673'),
  ('catalogo-galicia:estaciones:node-13782316674', 'Estación de tren de O Burgo-Santiago (Culleredo) – Rúa Ramón Cabanillas', 'Tren', '15031', 'Rúa Ramón Cabanillas', '15670', 43.31798, -8.36862, 'address', 'openstreetmap:node/13782316674'),
  ('catalogo-galicia:estaciones:node-13782316675', 'Estación de tren de Cambre – Estrada da Estación', 'Tren', '15017', 'Estrada da Estación 47', '15660', 43.29044, -8.35217, 'address', 'openstreetmap:node/13782316675'),
  ('catalogo-galicia:estaciones:node-13782316676', 'Estación de tren de Cecebre (Cambre) – Apeadeiro', 'Tren', '15017', 'Apeadeiro 29', '15650', 43.28785, -8.30777, 'address', 'openstreetmap:node/13782316676'),
  ('catalogo-galicia:estaciones:node-13817498309', 'Estación de Autobuses de Santiago de Compostela – Rúa de Clara Campoamor', 'Autobús', '15078', 'Rúa de Clara Campoamor', '15702', 42.87002, -8.54378, 'address', 'openstreetmap:node/13817498309'),
  ('catalogo-galicia:estaciones:node-13817498310', 'Estación de Autobuses da Coruña – Rúa Cabaleiros', 'Autobús', '15030', 'Rúa Cabaleiros', '15009', 43.35338, -8.4052, 'address', 'openstreetmap:node/13817498310'),
  ('catalogo-galicia:estaciones:node-13845431885', 'Estación de autobuses de VAC-161 Ferrol → Salamanca (con enlace a Algeciras) – Rúa do Instituto', 'Autobús', '15036', 'Rúa do Instituto 16', '15403', 43.4885, -8.22893, 'address', 'openstreetmap:node/13845431885'),
  ('catalogo-galicia:estaciones:node-14235294087', 'Estación de tren de Cabanas-O Areal – Travesía do Areal', 'Tren', '15015', 'Travesía do Areal', NULL, 43.41572, -8.16885, 'address', 'openstreetmap:node/14235294087'),
  ('catalogo-galicia:estaciones:node-14245149534', 'Estación de tren de Virxe do Mar (Narón) – Rúa Mariña Española', 'Tren', '15054', 'Rúa Mariña Española 11', '15570', 43.49652, -8.2049, 'address', 'openstreetmap:node/14245149534'),
  ('catalogo-galicia:estaciones:node-14247440613', 'Estación de tren de Santa Icía (Narón) – Rúa Estación', 'Tren', '15054', 'Rúa Estación 7', '15570', 43.4998, -8.19991, 'address', 'openstreetmap:node/14247440613'),
  ('catalogo-galicia:estaciones:node-14247483952', 'Estación de tren de O Alto do Castaño (Narón) – Rúa da Torre', 'Tren', '15054', 'Rúa da Torre 81', NULL, 43.50316, -8.19561, 'address', 'openstreetmap:node/14247483952'),
  ('catalogo-galicia:estaciones:node-14247495084', 'Estación de tren de O Ponto (Narón) – Lugar O Pedregal', 'Tren', '15054', 'Lugar O Pedregal', '15572', 43.51476, -8.17776, 'address', 'openstreetmap:node/14247495084'),
  ('catalogo-galicia:estaciones:node-14247642295', 'Estación de tren de As Ferrerías (Narón) – Avenida Malde Vizoso', 'Tren', '15054', 'Avenida Malde Vizoso 160', NULL, 43.52794, -8.15043, 'address', 'openstreetmap:node/14247642295'),
  ('catalogo-galicia:estaciones:node-14247644280', 'Estación de tren de Piñeiros (Narón) – Rúa Ortega e Gasset', 'Tren', '15054', 'Rúa Ortega e Gasset 31', '15570', 43.50953, -8.1839, 'address', 'openstreetmap:node/14247644280'),
  ('catalogo-galicia:estaciones:node-14247712608', 'Estación de tren de San Xoán (Ferrol) – Rúa Río Xubia 199-201', 'Tren', '15036', 'Rúa Río Xubia 199-201', '15404', 43.49451, -8.2142, 'address', 'openstreetmap:node/14247712608'),
  ('catalogo-galicia:estaciones:node-1625258031', 'Estación de tren de A Palla (Moeche)', 'Tren', '15049', NULL, NULL, 43.55045, -8.01871, 'address', 'openstreetmap:node/1625258031'),
  ('catalogo-galicia:estaciones:node-2012633023', 'Estación de Autobuses de Cee – Rúa Ourense', 'Autobús', '15023', 'Rúa Ourense', '15270', 42.95506, -9.19154, 'address', 'openstreetmap:node/2012633023'),
  ('catalogo-galicia:estaciones:node-2021640848', 'Estación de tren de Vedra-Ribadulla', 'Tren', '15089', NULL, NULL, 42.77648, -8.42821, 'address', 'openstreetmap:node/2021640848'),
  ('catalogo-galicia:estaciones:node-2059962962', 'Estación de tren de Pedroso (Narón) – O Carballo', 'Tren', '15054', 'O Carballo', '15597', 43.53665, -8.10927, 'address', 'openstreetmap:node/2059962962'),
  ('catalogo-galicia:estaciones:node-2059973150', 'Estación de tren de Xuvia (Narón) – Rúa Feve', 'Tren', '15054', 'Rúa Feve', '15570', 43.51723, -8.16128, 'address', 'openstreetmap:node/2059973150'),
  ('catalogo-galicia:estaciones:node-2238588521', 'Estación de tren de Barallobre (Fene) – Rúa Pablo Ares Feal', 'Tren', '15035', 'Rúa Pablo Ares Feal 63', '15528', 43.46288, -8.1886, 'address', 'openstreetmap:node/2238588521'),
  ('catalogo-galicia:estaciones:node-2238595941', 'Estación de tren de Perlío-Fene – Rúa Antonia Montero', 'Tren', '15035', 'Rúa Antonia Montero 25', '15500', 43.47234, -8.17486, 'address', 'openstreetmap:node/2238595941'),
  ('catalogo-galicia:estaciones:node-2475737415', 'Estación de tren de Miño – Rúa da Taína', 'Tren', '15048', 'Rúa da Taína 5', '15630', 43.34969, -8.20724, 'address', 'openstreetmap:node/2475737415'),
  ('catalogo-galicia:estaciones:node-357542461', 'Estación de tren de Sedes (Narón) – Camiño da Borrallada de Sedes', 'Tren', '15054', 'Camiño da Borrallada de Sedes', NULL, 43.54263, -8.1402, 'address', 'openstreetmap:node/357542461'),
  ('catalogo-galicia:estaciones:node-357554430', 'Estación de tren de San Sadurniño', 'Tren', '15076', NULL, NULL, 43.54611, -8.07807, 'address', 'openstreetmap:node/357554430'),
  ('catalogo-galicia:estaciones:node-362214339', 'Estación de tren de Neda – Avenida de Castelao', 'Tren', '15055', 'Avenida de Castelao', NULL, 43.4953, -8.16108, 'address', 'openstreetmap:node/362214339'),
  ('catalogo-galicia:estaciones:node-4321835595', 'Estación de autobuses de Fisterra – Rúa Federico Ávila', 'Autobús', '15037', 'Rúa Federico Ávila', '15155', 42.90778, -9.2633, 'address', 'openstreetmap:node/4321835595'),
  ('catalogo-galicia:estaciones:node-4440918690', 'Estación de autobuses de Autocares Rías Baixas (Santiago de Compostela) – Rúa de Muros', 'Autobús', '15078', 'Rúa de Muros', '15896', 42.87547, -8.61375, 'address', 'openstreetmap:node/4440918690'),
  ('catalogo-galicia:estaciones:node-6182281033', 'Muxía (Monbus Autobuses) – Rúa da Virxe da Barca', 'Autobús', '15052', 'Rúa da Virxe da Barca', '15124', 43.10747, -9.21649, 'address', 'openstreetmap:node/6182281033'),
  ('catalogo-galicia:estaciones:node-8008982086', 'Estación de tren de Pontedeume – Avenida de Ferrol', 'Tren', '15069', 'Avenida de Ferrol', '15609', 43.41185, -8.18034, 'address', 'openstreetmap:node/8008982086'),
  ('catalogo-galicia:estaciones:node-9374763919', 'Estación de tren de Uxes (Arteixo) – Travesía da Estación', 'Tren', '15005', 'Travesía da Estación', NULL, 43.29751, -8.44418, 'address', 'openstreetmap:node/9374763919'),
  ('catalogo-galicia:estaciones:relation-6858135', 'Estación de tren de Padrón-Barbanza', 'Tren', '15065', NULL, NULL, 42.78121, -8.65648, 'address', 'openstreetmap:relation/6858135'),
  ('catalogo-galicia:estaciones:way-108153480', 'Estación de tren de Teixeiro (Curtis) – Avenida Doutor Martínez Pardo', 'Tren', '15032', 'Avenida Doutor Martínez Pardo 5', NULL, 43.14139, -8.03768, 'address', 'openstreetmap:way/108153480'),
  ('catalogo-galicia:estaciones:way-1291522108', 'Estación de Autobuses da Pobra do Caramiñal – Rúa de Anxo Rei Ballesteros', 'Autobús', '15067', 'Rúa de Anxo Rei Ballesteros', '15940', 42.60932, -8.9358, 'address', 'openstreetmap:way/1291522108'),
  ('catalogo-galicia:estaciones:way-1433885537', 'Estación de Autobuses da Coruña – Avenida da Sardiñeira', 'Autobús', '15030', 'Avenida da Sardiñeira 30', '15007', 43.3513, -8.41246, 'address', 'openstreetmap:way/1433885537'),
  ('catalogo-galicia:estaciones:way-170951117', 'Estación de Autobuses de Padrón – Avenida de Camilo José Cela', 'Autobús', '15065', 'Avenida de Camilo José Cela', NULL, 42.74187, -8.65859, 'address', 'openstreetmap:way/170951117'),
  ('catalogo-galicia:estaciones:way-213985408', 'Estación de tren de Betanzos-Cidade – Rúa Arxentina', 'Tren', '15009', 'Rúa Arxentina', '15300', 43.28418, -8.21593, 'address', 'openstreetmap:way/213985408'),
  ('catalogo-galicia:estaciones:way-216233567', 'Estación de tren de Miño-Castro – Rúa A Barrosa', 'Tren', '15048', 'Rúa A Barrosa 18', '15630', 43.34232, -8.20542, 'address', 'openstreetmap:way/216233567'),
  ('catalogo-galicia:estaciones:way-232193966', 'Estación de Autobuses (Cedeira) – Rúa dos Deportes', 'Autobús', '15022', 'Rúa dos Deportes', '15350', 43.6573, -8.04846, 'address', 'openstreetmap:way/232193966'),
  ('catalogo-galicia:estaciones:way-238054649', 'Estación de tren de Cesuras (Oza Cesuras) – O Forte, Bragade', 'Tren', '15902', 'O Forte, Bragade 1', '15390', 43.17302, -8.20054, 'address', 'openstreetmap:way/238054649'),
  ('catalogo-galicia:estaciones:way-238055509', 'Estación de tren de Oza dos Ríos (Oza Cesuras) – Lois-Estación', 'Tren', '15902', 'Lois-Estación', '15380', 43.21871, -8.18702, 'address', 'openstreetmap:way/238055509'),
  ('catalogo-galicia:estaciones:way-238059601', 'Estación de tren de Betanzos-A Infesta – 28', 'Tren', '15009', '28', '15319', 43.27072, -8.22583, 'address', 'openstreetmap:way/238059601'),
  ('catalogo-galicia:estaciones:way-240624796', 'Estación de tren de Perbes (Miño) – 40', 'Tren', '15048', '40', '15608', 43.37819, -8.2011, 'address', 'openstreetmap:way/240624796'),
  ('catalogo-galicia:estaciones:way-24930154', 'Estación de tren de Ferrol – Avenida de Compostela', 'Tren', '15036', 'Avenida de Compostela', '15404', 43.48805, -8.231, 'address', 'openstreetmap:way/24930154'),
  ('catalogo-galicia:estaciones:way-265139620', 'Estación de tren de Ortigueira – Avenida da Penela', 'Tren', '15061', 'Avenida da Penela 32', '15330', 43.68626, -7.84952, 'address', 'openstreetmap:way/265139620'),
  ('catalogo-galicia:estaciones:way-271684182', 'Estación de tren de Cerdido (Moeche) – Sulleo, Labacengos', 'Tren', '15049', 'Sulleo, Labacengos', '15564', 43.58717, -7.93461, 'address', 'openstreetmap:way/271684182'),
  ('catalogo-galicia:estaciones:way-328337768', 'Estación de tren de Santa María de Mera (Ortigueira)', 'Tren', '15061', NULL, NULL, 43.64096, -7.91618, 'address', 'openstreetmap:way/328337768'),
  ('catalogo-galicia:estaciones:way-542736479', 'Dársena de Autobuses de Xoán XXIII (Santiago de Compostela) – Avenida do Burgo das Nacións', 'Autobús', '15078', 'Avenida do Burgo das Nacións', '15705', 42.88625, -8.54341, 'address', 'openstreetmap:way/542736479'),
  ('catalogo-galicia:estaciones:way-59425884', 'Estación de Autobuses de Noia – Peirán do Marqués', 'Autobús', '15057', 'Peirán do Marqués', '15200', 42.78563, -8.8906, 'address', 'openstreetmap:way/59425884'),
  ('catalogo-galicia:estaciones:way-761353698', 'Estación de Autobuses de Carballo – Rúa Vicente Risco', 'Autobús', '15019', 'Rúa Vicente Risco 33', '15100', 43.21003, -8.69571, 'address', 'openstreetmap:way/761353698');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '15');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 15 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '15'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 59 THEN
    RAISE EXCEPTION 'Se esperaban 59 puntos de Estaciones en A Coruña, hay %', n;
  END IF;
END;
$$;

COMMIT;
