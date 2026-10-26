-- Carga de la categoría Correos de A Coruña (provincia 15), trozo de la carga de Andalucía.
-- Origen: postal_service-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 75 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-galicia:postal_service:node-10258987093', 'Correos Sada – Rúa do Río', NULL, '15075', 'Rúa do Río 19', '15160', 43.3492, -8.25297, 'address', 'openstreetmap:node/10258987093'),
  ('catalogo-galicia:postal_service:node-11827462143', 'Correos Mazaricos – Camiño da Feira Vella', NULL, '15045', 'Camiño da Feira Vella', '15258', 42.93819, -8.99441, 'address', 'openstreetmap:node/11827462143'),
  ('catalogo-galicia:postal_service:node-11835167446', 'Correos Rianxo – Rúa Rinlo', NULL, '15072', 'Rúa Rinlo', '15920', 42.65601, -8.81596, 'address', 'openstreetmap:node/11835167446'),
  ('catalogo-galicia:postal_service:node-12153673652', 'Correos A Baña – Rúa de Castelao', NULL, '15007', 'Rúa de Castelao', '15863', 42.96151, -8.75849, 'address', 'openstreetmap:node/12153673652'),
  ('catalogo-galicia:postal_service:node-12312297688', 'Correos Santiago de Compostela – Rúa das Carretas', NULL, '15078', 'Rúa das Carretas 40', '15705', 42.88209, -8.54669, 'address', 'openstreetmap:node/12312297688'),
  ('catalogo-galicia:postal_service:node-1244828660', 'Correos As Pontes de García Rodríguez – Avenida de Vilalba', NULL, '15070', 'Avenida de Vilalba 4', '15320', 43.44988, -7.8524, 'address', 'openstreetmap:node/1244828660'),
  ('catalogo-galicia:postal_service:node-1261927879', 'Correos Mañón – Praza do Mesón, O Porto do Barqueiro, Mogor', NULL, '15044', 'Praza do Mesón, O Porto do Barqueiro, Mogor 1', '15337', 43.73664, -7.70562, 'address', 'openstreetmap:node/1261927879'),
  ('catalogo-galicia:postal_service:node-1324712649', 'Correos Ames – Rúa Agro da Magdalena', NULL, '15002', 'Rúa Agro da Magdalena', '15895', 42.84353, -8.5785, 'address', 'openstreetmap:node/1324712649'),
  ('catalogo-galicia:postal_service:node-13628819701', 'Correos Cabana de Bergantiños – Estrada Buño-Laxe', NULL, '15014', 'Estrada Buño-Laxe', '15115', 43.22781, -8.91451, 'address', 'openstreetmap:node/13628819701'),
  ('catalogo-galicia:postal_service:node-1591944454', 'Correos Teo – Rúa do Agro da Ramallosa', NULL, '15082', 'Rúa do Agro da Ramallosa', NULL, 42.79465, -8.54899, 'address', 'openstreetmap:node/1591944454'),
  ('catalogo-galicia:postal_service:node-1597680867', 'Correos Teo – Travesía de Cacheiras', NULL, '15082', 'Travesía de Cacheiras 24', '15883', 42.8257, -8.54434, 'address', 'openstreetmap:node/1597680867'),
  ('catalogo-galicia:postal_service:node-1666513576', 'Correos Oleiros – Rúa Zaire', NULL, '15058', 'Rúa Zaire 9', '15172', 43.33407, -8.37418, 'address', 'openstreetmap:node/1666513576'),
  ('catalogo-galicia:postal_service:node-1704475301', 'Correos Cee – Rúa Domingo Antonio de Andrade', NULL, '15023', 'Rúa Domingo Antonio de Andrade', '15270', 42.95564, -9.19011, 'address', 'openstreetmap:node/1704475301'),
  ('catalogo-galicia:postal_service:node-1734915924', 'Correos Val do Dubra – Rúa Muiños, Bembibre', NULL, '15088', 'Rúa Muiños, Bembibre', '15873', 43.02721, -8.65646, 'address', 'openstreetmap:node/1734915924'),
  ('catalogo-galicia:postal_service:node-1759173159', 'Correos A Coruña – Rúa Xeneral Salcedo Molinuevo', NULL, '15030', 'Rúa Xeneral Salcedo Molinuevo 13', '15009', 43.35102, -8.39204, 'address', 'openstreetmap:node/1759173159'),
  ('catalogo-galicia:postal_service:node-2020486616', 'Correos Culleredo – Praza Sagrada Familia', NULL, '15031', 'Praza Sagrada Familia 3', '15174', 43.30893, -8.38359, 'address', 'openstreetmap:node/2020486616'),
  ('catalogo-galicia:postal_service:node-2030899497', 'Correos Negreira – Rúa da Cachurra', NULL, '15056', 'Rúa da Cachurra 11', '15830', 42.90984, -8.73695, 'address', 'openstreetmap:node/2030899497'),
  ('catalogo-galicia:postal_service:node-2383632729', 'Correos Mugardos – Rúa Contramestre Casado', NULL, '15051', 'Rúa Contramestre Casado 16', '15620', 43.46157, -8.25293, 'address', 'openstreetmap:node/2383632729'),
  ('catalogo-galicia:postal_service:node-2405678961', 'Correos Cedeira – Avenida da Area 14;16', NULL, '15022', 'Avenida da Area 14;16', '15350', 43.66096, -8.05233, 'address', 'openstreetmap:node/2405678961'),
  ('catalogo-galicia:postal_service:node-2448110971', 'Correos A Coruña – Avenida de Gran Canaria', NULL, '15030', 'Avenida de Gran Canaria 21', '15011', 43.37217, -8.42351, 'address', 'openstreetmap:node/2448110971'),
  ('catalogo-galicia:postal_service:node-2541020893', 'Correos Boiro – Rúa do Estatuto de Galicia', NULL, '15011', 'Rúa do Estatuto de Galicia', '15930', 42.64868, -8.87982, 'address', 'openstreetmap:node/2541020893'),
  ('catalogo-galicia:postal_service:node-280707463', 'Correos Pontedeume – Avenida de Ferrol', NULL, '15069', 'Avenida de Ferrol 7', '15600', 43.40787, -8.17389, 'address', 'openstreetmap:node/280707463'),
  ('catalogo-galicia:postal_service:node-2924568308', 'Correos A Coruña – Rúa Vizcaya 33-35', NULL, '15030', 'Rúa Vizcaya 33-35', '15007', 43.35709, -8.40973, 'address', 'openstreetmap:node/2924568308'),
  ('catalogo-galicia:postal_service:node-3489639735', 'Correos Carral – Rúa do Pan', NULL, '15021', 'Rúa do Pan 1', '15175', 43.23011, -8.35385, 'address', 'openstreetmap:node/3489639735'),
  ('catalogo-galicia:postal_service:node-3596661128', 'Correos Ordes – Rúa Mercado', NULL, '15059', 'Rúa Mercado 8', '15680', 43.07751, -8.40848, 'address', 'openstreetmap:node/3596661128'),
  ('catalogo-galicia:postal_service:node-3664517421', 'Correos Fisterra – Rúa Santa Catalina', NULL, '15037', 'Rúa Santa Catalina 1', '15155', 42.90921, -9.26237, 'address', 'openstreetmap:node/3664517421'),
  ('catalogo-galicia:postal_service:node-3738253154', 'Correos Abegondo – San Marcos, Abegondo', NULL, '15001', 'San Marcos, Abegondo 1', '15318', 43.22729, -8.28904, 'address', 'openstreetmap:node/3738253154'),
  ('catalogo-galicia:postal_service:node-392262903', 'Correos Noia – Rúa do Espírito Santo', NULL, '15057', 'Rúa do Espírito Santo', '15200', 42.78322, -8.88505, 'address', 'openstreetmap:node/392262903'),
  ('catalogo-galicia:postal_service:node-4003474858', 'Correos A Pobra do Caramiñal – Rúa de Díaz de Rábago 27-28', NULL, '15067', 'Rúa de Díaz de Rábago 27-28', '15940', 42.60832, -8.93761, 'address', 'openstreetmap:node/4003474858'),
  ('catalogo-galicia:postal_service:node-4605826882', 'Correos Cambre – Praza do Mosteiro', NULL, '15017', 'Praza do Mosteiro 4', '15660', 43.29165, -8.34505, 'address', 'openstreetmap:node/4605826882'),
  ('catalogo-galicia:postal_service:node-4769513313', 'Correos Santiago de Compostela – Rúa de Anxo Casal', NULL, '15078', 'Rúa de Anxo Casal', '15704', 42.88826, -8.53459, 'address', 'openstreetmap:node/4769513313'),
  ('catalogo-galicia:postal_service:node-4817811947', 'Correos Ferrol – Avenida de Castelao', NULL, '15036', 'Avenida de Castelao 21', '15406', 43.48427, -8.20566, 'address', 'openstreetmap:node/4817811947'),
  ('catalogo-galicia:postal_service:node-5047415711', 'Correos Arteixo – Avenida de Fisterra', NULL, '15005', 'Avenida de Fisterra 52', '15142', 43.3044, -8.51197, 'address', 'openstreetmap:node/5047415711'),
  ('catalogo-galicia:postal_service:node-5082013422', 'Correos Cee – Rúa Ourense', NULL, '15023', 'Rúa Ourense', '15270', 42.95501, -9.19189, 'address', 'openstreetmap:node/5082013422'),
  ('catalogo-galicia:postal_service:node-5152464493', 'Correos Carballo – Rúa San Martiño', NULL, '15019', 'Rúa San Martiño 2', '15100', 43.20939, -8.69179, 'address', 'openstreetmap:node/5152464493'),
  ('catalogo-galicia:postal_service:node-5167211628', 'Correos Oza Cesuras – Lois', NULL, '15902', 'Lois 6', '15380', 43.21445, -8.1862, 'address', 'openstreetmap:node/5167211628'),
  ('catalogo-galicia:postal_service:node-5225219045', 'Correos Padrón – Praza Dos Fillos e Amigos De Padron', NULL, '15065', 'Praza Dos Fillos e Amigos De Padron 1', '15900', 42.73911, -8.66122, 'address', 'openstreetmap:node/5225219045'),
  ('catalogo-galicia:postal_service:node-5260991415', 'Correos Sobrado – Sobrado dos Monxes', NULL, '15080', 'Sobrado dos Monxes', '15813', 43.03999, -8.02539, 'address', 'openstreetmap:node/5260991415'),
  ('catalogo-galicia:postal_service:node-5480105311', 'Correos Miño – Rúa da Carreira', NULL, '15048', 'Rúa da Carreira 36', '15630', 43.34725, -8.20539, 'address', 'openstreetmap:node/5480105311'),
  ('catalogo-galicia:postal_service:node-5620219084', 'Correos San Sadurniño – 16', NULL, '15076', '16', '15560', 43.53183, -8.07113, 'address', 'openstreetmap:node/5620219084'),
  ('catalogo-galicia:postal_service:node-5635213687', 'Correos A Coruña – Rúa San Vicente de Paul', NULL, '15030', 'Rúa San Vicente de Paul 9', '15002', 43.37667, -8.39741, 'address', 'openstreetmap:node/5635213687'),
  ('catalogo-galicia:postal_service:node-5638343359', 'Correos Muxía – Rúa da Virxe da Barca', NULL, '15052', 'Rúa da Virxe da Barca 4', '15124', 43.10447, -9.21712, 'address', 'openstreetmap:node/5638343359'),
  ('catalogo-galicia:postal_service:node-6012515685', 'Correos A Coruña – Rúa Rodrigo Alfredo de Santiago', NULL, '15030', 'Rúa Rodrigo Alfredo de Santiago 38', '15010', 43.36006, -8.42235, 'address', 'openstreetmap:node/6012515685'),
  ('catalogo-galicia:postal_service:node-6040099066', 'Correos Ames – Praza da Mahia', NULL, '15002', 'Praza da Mahia 10', '15220', 42.86019, -8.65201, 'address', 'openstreetmap:node/6040099066'),
  ('catalogo-galicia:postal_service:node-6061474313', 'Correos Vilasantar – Foro', NULL, '15090', 'Foro', '15807', 43.04851, -8.10785, 'address', 'openstreetmap:node/6061474313'),
  ('catalogo-galicia:postal_service:node-6103012566', 'Correos Santa Comba – Rúa da Coruña', NULL, '15077', 'Rúa da Coruña', '15840', 43.03264, -8.81184, 'address', 'openstreetmap:node/6103012566'),
  ('catalogo-galicia:postal_service:node-6111478508', 'Correos Melide – Rúa Bispo Varela Fondevila y Verea', NULL, '15046', 'Rúa Bispo Varela Fondevila y Verea 20', '15800', 42.91422, -8.0103, 'address', 'openstreetmap:node/6111478508'),
  ('catalogo-galicia:postal_service:node-6152624600', 'Correos A Capela – Estrada AC-564 As Neves', NULL, '15018', 'Estrada AC-564 As Neves', '15613', 43.43596, -8.07167, 'address', 'openstreetmap:node/6152624600'),
  ('catalogo-galicia:postal_service:node-6170618501', 'Correos Zas – Rúa do Campo, Zas', NULL, '15093', 'Rúa do Campo, Zas', '15850', 43.09954, -8.91525, 'address', 'openstreetmap:node/6170618501'),
  ('catalogo-galicia:postal_service:node-6184921761', 'Correos Corcubión – Rúa Antonio Porrúa', NULL, '15028', 'Rúa Antonio Porrúa 5', '15130', 42.94497, -9.19335, 'address', 'openstreetmap:node/6184921761'),
  ('catalogo-galicia:postal_service:node-6200352538', 'Correos Cambre – Rúa Constitución', NULL, '15017', 'Rúa Constitución 27', '15679', 43.31986, -8.3582, 'address', 'openstreetmap:node/6200352538'),
  ('catalogo-galicia:postal_service:node-6298941316', 'Correos A Coruña – Rúa Ribeira Sacra', NULL, '15030', 'Rúa Ribeira Sacra 21', '15190', 43.32463, -8.44248, 'address', 'openstreetmap:node/6298941316'),
  ('catalogo-galicia:postal_service:node-6314860335', 'Correos Oza Cesuras – O Ferrador', NULL, '15902', 'O Ferrador', '15380', 43.21728, -8.18846, 'address', 'openstreetmap:node/6314860335'),
  ('catalogo-galicia:postal_service:node-6525061657', 'Correos Valdoviño – 17', NULL, '15087', '17', '15552', 43.61052, -8.14152, 'address', 'openstreetmap:node/6525061657'),
  ('catalogo-galicia:postal_service:node-7205970027', 'Correos Laxe – Rúa Vila Amparo', NULL, '15040', 'Rúa Vila Amparo 5', '15117', 43.21797, -9.00539, 'address', 'openstreetmap:node/7205970027'),
  ('catalogo-galicia:postal_service:node-7260244556', 'Correos Narón – Rúa Garda', NULL, '15054', 'Rúa Garda 1', '15570', 43.50293, -8.19082, 'address', 'openstreetmap:node/7260244556'),
  ('catalogo-galicia:postal_service:node-7267308777', 'Correos Vedra – Avenida do Mestre Manuel Gómez Lorenzo', NULL, '15089', 'Avenida do Mestre Manuel Gómez Lorenzo 15', '15885', 42.77439, -8.48267, 'address', 'openstreetmap:node/7267308777'),
  ('catalogo-galicia:postal_service:node-7330072683', 'Correos Santiago de Compostela – Rúa de García Prieto', NULL, '15078', 'Rúa de García Prieto 12', '15706', 42.86974, -8.55302, 'address', 'openstreetmap:node/7330072683'),
  ('catalogo-galicia:postal_service:node-8042479249', 'Correos A Coruña – Rúa Entrepenas', NULL, '15030', 'Rúa Entrepenas 43', '15010', 43.36337, -8.42146, 'address', 'openstreetmap:node/8042479249'),
  ('catalogo-galicia:postal_service:node-817796671', 'Correos Arzúa – Ramon Franco', NULL, '15006', 'Ramon Franco', '15810', 42.92856, -8.16362, 'address', 'openstreetmap:node/817796671'),
  ('catalogo-galicia:postal_service:node-981251742', 'Correos Fene – Rúa da Fraga 22;24', NULL, '15035', 'Rúa da Fraga 22;24', '15500', 43.47346, -8.16404, 'address', 'openstreetmap:node/981251742'),
  ('catalogo-galicia:postal_service:node-988407850', 'Correos Oroso – Rúa do Portiño', NULL, '15060', 'Rúa do Portiño 6', '15888', 42.96801, -8.44433, 'address', 'openstreetmap:node/988407850'),
  ('catalogo-galicia:postal_service:way-100007099', 'Correos A Coruña – Avenida da Sardiñeira 1A', NULL, '15030', 'Avenida da Sardiñeira 1A', '15007', 43.35318, -8.41002, 'address', 'openstreetmap:way/100007099'),
  ('catalogo-galicia:postal_service:way-1018263749', 'Correos Brión – Avenida de Santa Minia', NULL, '15013', 'Avenida de Santa Minia', '15865', 42.86577, -8.67794, 'address', 'openstreetmap:way/1018263749'),
  ('catalogo-galicia:postal_service:way-146070649', 'Correos Santiago de Compostela – Avenida de Rodrigo de Padrón', NULL, '15078', 'Avenida de Rodrigo de Padrón 2', '15702', 42.87888, -8.54553, 'address', 'openstreetmap:way/146070649'),
  ('catalogo-galicia:postal_service:way-323632398', 'Correos Culleredo – Rúa Alfonso VII', NULL, '15031', 'Rúa Alfonso VII 1', '15670', 43.31637, -8.36521, 'address', 'openstreetmap:way/323632398'),
  ('catalogo-galicia:postal_service:way-32931829', 'Correos Ferrol – Rúa Igrexa', NULL, '15036', 'Rúa Igrexa 66', '15402', 43.48282, -8.23316, 'address', 'openstreetmap:way/32931829'),
  ('catalogo-galicia:postal_service:way-336002236', 'Correos Betanzos – Praza Alfonso IX', NULL, '15009', 'Praza Alfonso IX 2', '15300', 43.27938, -8.21168, 'address', 'openstreetmap:way/336002236'),
  ('catalogo-galicia:postal_service:way-388437049', 'Correos Bergondo – Carretera da Coruña', NULL, '15008', 'Carretera da Coruña 14', '15165', 43.31938, -8.23468, 'address', 'openstreetmap:way/388437049'),
  ('catalogo-galicia:postal_service:way-427501713', 'Correos Neda – Avenida de Algeciras', NULL, '15055', 'Avenida de Algeciras 63', '15510', 43.50014, -8.15792, 'address', 'openstreetmap:way/427501713'),
  ('catalogo-galicia:postal_service:way-464782217', 'Correos Monfero – Rebordelos, San Fiz', NULL, '15050', 'Rebordelos, San Fiz', '15619', 43.3343, -8.05604, 'address', 'openstreetmap:way/464782217'),
  ('catalogo-galicia:postal_service:way-506789098', 'Correos O Pino – Avenida de Lugo', NULL, '15066', 'Avenida de Lugo 30', '15821', 42.90721, -8.35902, 'address', 'openstreetmap:way/506789098'),
  ('catalogo-galicia:postal_service:way-794417005', 'Correos A Coruña – Rúa Alcalde Manuel Casas', NULL, '15030', 'Rúa Alcalde Manuel Casas 1', '15001', 43.36914, -8.39977, 'address', 'openstreetmap:way/794417005'),
  ('catalogo-galicia:postal_service:way-849897224', 'Correos Cerceda – Rúa Tierno Galván', NULL, '15024', 'Rúa Tierno Galván', '15185', 43.19052, -8.47307, 'address', 'openstreetmap:way/849897224'),
  ('catalogo-galicia:postal_service:way-856051096', 'Correos Camariñas – Praza Maior', NULL, '15016', 'Praza Maior', '15123', 43.13067, -9.18271, 'address', 'openstreetmap:way/856051096');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 75 THEN
    RAISE EXCEPTION 'Se esperaban 75 puntos de Correos en A Coruña, hay %', n;
  END IF;
END;
$$;

COMMIT;
