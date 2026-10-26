-- Carga de la categoría Estaciones de Bizkaia (provincia 48), trozo de la carga de Andalucía.
-- Origen: estaciones-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 110 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-pais-vasco:estaciones:node-10212476577', 'Estación de tren de Santurtzi – Santurtziko parkea', 'Tren', '48082', 'Santurtziko parkea', '48980', 43.32863, -3.0296, 'address', 'openstreetmap:node/10212476577'),
  ('catalogo-pais-vasco:estaciones:node-11872156804', 'Estación de tren de Trápaga (Valle de Trápaga-Trapagaran) – Barrio Galindo', 'Tren', '48080', 'Barrio Galindo', NULL, 43.30298, -3.01691, 'address', 'openstreetmap:node/11872156804'),
  ('catalogo-pais-vasco:estaciones:node-11872156805', 'Estación de tren de Sagrada Familia (Ortuella) – Paseo de Europa', 'Tren', '48083', 'Paseo de Europa', '48530', 43.30858, -3.05369, 'address', 'openstreetmap:node/11872156805'),
  ('catalogo-pais-vasco:estaciones:node-11872156806', 'Estación de tren de Gallarta (Ortuella) – Loredo auzoa', 'Tren', '48083', 'Loredo auzoa', '48530', 43.31936, -3.06749, 'address', 'openstreetmap:node/11872156806'),
  ('catalogo-pais-vasco:estaciones:node-12509820931', 'Estación de tren de Muxika – 93', 'Tren', '48067', '93', '48392', 43.28679, -2.68942, 'address', 'openstreetmap:node/12509820931'),
  ('catalogo-pais-vasco:estaciones:node-12616331078', 'Estación de tren de Portugalete – Calle Manuel Calvo 26,28,30', 'Tren', '48078', 'Calle Manuel Calvo 26,28,30', '48920', 43.31848, -3.01502, 'address', 'openstreetmap:node/12616331078'),
  ('catalogo-pais-vasco:estaciones:node-12771090377', 'Estación de tren de Abaroa-San Miguel (Basauri) – Errekalde auzoa', 'Tren', '48015', 'Errekalde auzoa', NULL, 43.22559, -2.88689, 'address', 'openstreetmap:node/12771090377'),
  ('catalogo-pais-vasco:estaciones:node-12771113925', 'Estación de tren de Basauri – Uriarte kalea', 'Tren', '48015', 'Uriarte kalea', NULL, 43.2235, -2.88221, 'address', 'openstreetmap:node/12771113925'),
  ('catalogo-pais-vasco:estaciones:node-12771120499', 'Estación de tren de Ugao-Miraballes – Torre de Ugao kalea', 'Tren', '48065', 'Torre de Ugao kalea', '48490', 43.1792, -2.90285, 'address', 'openstreetmap:node/12771120499'),
  ('catalogo-pais-vasco:estaciones:node-12779959265', 'Estación de tren de Ola (Sondika) – Izartza bidea', 'Tren', '48904', 'Izartza bidea', NULL, 43.29188, -2.92524, 'approximate', 'openstreetmap:node/12779959265'),
  ('catalogo-pais-vasco:estaciones:node-12779959266', 'Estación de tren de Zangroiz (Sondika) – Txorierri etorbidea', 'Tren', '48904', 'Txorierri etorbidea', NULL, 43.30029, -2.94099, 'address', 'openstreetmap:node/12779959266'),
  ('catalogo-pais-vasco:estaciones:node-12779959267', 'Estación de tren de Elotxelerri (Loiu) – Molinaga bidea', 'Tren', '48903', 'Molinaga bidea', NULL, 43.29444, -2.90599, 'address', 'openstreetmap:node/12779959267'),
  ('catalogo-pais-vasco:estaciones:node-12779959274', 'Estación de tren de Lekunbiz (Zamudio) – Astintze kalea', 'Tren', '48905', 'Astintze kalea', '48170', 43.28673, -2.87469, 'address', 'openstreetmap:node/12779959274'),
  ('catalogo-pais-vasco:estaciones:node-12779959275', 'Estación de tren de Zamudio – Sabino Arana plaza', 'Tren', '48905', 'Sabino Arana plaza 5', '48170', 43.28426, -2.86521, 'address', 'openstreetmap:node/12779959275'),
  ('catalogo-pais-vasco:estaciones:node-12779959276', 'Estación de tren de Lezama – Txorierri errepidea', 'Tren', '48081', 'Txorierri errepidea', '48196', 43.27345, -2.83577, 'address', 'openstreetmap:node/12779959276'),
  ('catalogo-pais-vasco:estaciones:node-12817736834', 'Estación de tren de Amorebieta Geralekua (Amorebieta-Etxano) – San Pedro kalea', 'Tren', '48003', 'San Pedro kalea 4', '48340', 43.22177, -2.73499, 'address', 'openstreetmap:node/12817736834'),
  ('catalogo-pais-vasco:estaciones:node-12818133688', 'Estación de tren de Lurgorri (Gernika-Lumo) – Juan Kaltzada kalea 105D', 'Tren', '48046', 'Juan Kaltzada kalea 105D', '48300', 43.30673, -2.68023, 'address', 'openstreetmap:node/12818133688'),
  ('catalogo-pais-vasco:estaciones:node-12818133689', 'Estación de tren de Institutoa (Gernika-Lumo) – Zubigorri kalea', 'Tren', '48046', 'Zubigorri kalea', '48300', 43.31991, -2.67683, 'address', 'openstreetmap:node/12818133689'),
  ('catalogo-pais-vasco:estaciones:node-12837551100', 'Estación de tren de San Kristobal-Busturia – San Kristobal auzoa', 'Tren', '48021', 'San Kristobal auzoa 10', NULL, 43.36796, -2.69036, 'address', 'openstreetmap:node/12837551100'),
  ('catalogo-pais-vasco:estaciones:node-12837552101', 'Estación de tren de Busturia Axpe – Axpe auzoa', 'Tren', '48021', 'Axpe auzoa 36', NULL, 43.38017, -2.69302, 'address', 'openstreetmap:node/12837552101'),
  ('catalogo-pais-vasco:estaciones:node-12837552119', 'Estación de tren de Mundaka – Geltoki kalea', 'Tren', '48068', 'Geltoki kalea 8', '48360', 43.40889, -2.70104, 'address', 'openstreetmap:node/12837552119'),
  ('catalogo-pais-vasco:estaciones:node-13827574220', 'Estación de tren de Errotabarri (Ermua) – Gipuzkoa hiribidea', 'Tren', '48034', 'Gipuzkoa hiribidea', NULL, 43.1831, -2.49878, 'address', 'openstreetmap:node/13827574220'),
  ('catalogo-pais-vasco:estaciones:node-13827574221', 'Estación de tren de San Lorentzo (Ermua) – Gipuzkoa hiribidea', 'Tren', '48034', 'Gipuzkoa hiribidea', NULL, 43.17948, -2.49561, 'address', 'openstreetmap:node/13827574221'),
  ('catalogo-pais-vasco:estaciones:node-1604259381', 'Estación de tren de Mimetiz (Zalla) – Avenida Sabino Arana', 'Tren', '48096', 'Avenida Sabino Arana', '48860', 43.21575, -3.13114, 'address', 'openstreetmap:node/1604259381'),
  ('catalogo-pais-vasco:estaciones:node-1711853299', 'Estación de Autobuses de Abando (Bilbao) – Hurtado de Amezaga kalea', 'Autobús', '48020', 'Hurtado de Amezaga kalea 6', '48008', 43.26029, -2.92869, 'address', 'openstreetmap:node/1711853299'),
  ('catalogo-pais-vasco:estaciones:node-2615500571', 'Estación de Autobuses de Barakaldo-Centro – Calle León', 'Autobús', '48013', 'Calle León 11', '48902', 43.29333, -2.98915, 'address', 'openstreetmap:node/2615500571'),
  ('catalogo-pais-vasco:estaciones:node-2746335504', 'Estación de Autobuses de Muskiz – Calle Gurugu Memerea kalea', 'Autobús', '48071', 'Calle Gurugu Memerea kalea', '48550', 43.32083, -3.1132, 'address', 'openstreetmap:node/2746335504'),
  ('catalogo-pais-vasco:estaciones:node-3183926517', 'Estación de autobuses de Autocares Arzabe (Zalla) – Artzabe auzoa', 'Autobús', '48096', 'Artzabe auzoa 1', '48860', 43.2062, -3.12452, 'address', 'openstreetmap:node/3183926517'),
  ('catalogo-pais-vasco:estaciones:node-3778184661', 'Gernikako Autobus geltokia (Gernika-Lumo) – Iparragirre kalea', 'Autobús', '48046', 'Iparragirre kalea 14', '48300', 43.31374, -2.67671, 'approximate', 'openstreetmap:node/3778184661'),
  ('catalogo-pais-vasco:estaciones:node-3899928383', 'Estación de tren de Bilbao - Mercancías / Merkantziak (Santurtzi)', 'Tren', '48082', NULL, NULL, 43.34472, -3.06072, 'approximate', 'openstreetmap:node/3899928383'),
  ('catalogo-pais-vasco:estaciones:node-3899928384', 'Estación de tren de Puerto (CLH) (Santurtzi)', 'Tren', '48082', NULL, NULL, 43.34419, -3.06035, 'approximate', 'openstreetmap:node/3899928384'),
  ('catalogo-pais-vasco:estaciones:node-3934265377', 'Terminal de Cruceros (Getxo)', 'Autobús', '48044', NULL, NULL, 43.34141, -3.0257, 'address', 'openstreetmap:node/3934265377'),
  ('catalogo-pais-vasco:estaciones:node-5031902270', 'Estación de tren de Sondika – Lehendakari Aguirre etorbidea', 'Tren', '48904', 'Lehendakari Aguirre etorbidea', NULL, 43.29831, -2.92823, 'address', 'openstreetmap:node/5031902270'),
  ('catalogo-pais-vasco:estaciones:node-5034308998', 'Estación de tren de Durango – Askatasun etorbidea', 'Tren', '48027', 'Askatasun etorbidea', '48200', 43.1694, -2.63455, 'address', 'openstreetmap:node/5034308998'),
  ('catalogo-pais-vasco:estaciones:node-5034309156', 'Estación de tren de Traña (Abadiño) – Trañabarren etorbidea', 'Tren', '48001', 'Trañabarren etorbidea', NULL, 43.16528, -2.61256, 'address', 'openstreetmap:node/5034309156'),
  ('catalogo-pais-vasco:estaciones:node-5059976456', 'Estación de tren de Desertu-Barakaldo – Calle Sociedad Santa Águeda', 'Tren', '48013', 'Calle Sociedad Santa Águeda 1', '48901', 43.30053, -2.98467, 'address', 'openstreetmap:node/5059976456'),
  ('catalogo-pais-vasco:estaciones:node-5059982652', 'Estación de tren de Muskiz – Avenida La Estación', 'Tren', '48071', 'Avenida La Estación', '48550', 43.32121, -3.11219, 'address', 'openstreetmap:node/5059982652'),
  ('catalogo-pais-vasco:estaciones:node-5155885328', 'Estación de tren de Zabalburu (Bilbao) – García Salazar kalea', 'Tren', '48020', 'García Salazar kalea 32', '48003', 43.25647, -2.9325, 'address', 'openstreetmap:node/5155885328'),
  ('catalogo-pais-vasco:estaciones:node-521760210', 'Estación de Autobuses de Bermeo (Portua) – Kai bidea', 'Autobús', '48017', 'Kai bidea', '48370', 43.41884, -2.72273, 'address', 'openstreetmap:node/521760210'),
  ('catalogo-pais-vasco:estaciones:node-5254810527', 'Estación de tren de La Peña (Bilbao) – Lekanda kalea', 'Tren', '48020', 'Lekanda kalea 4', '48003', 43.24012, -2.92411, 'address', 'openstreetmap:node/5254810527'),
  ('catalogo-pais-vasco:estaciones:node-5254817178', 'Estación de tren de Ollargan (Arrigorriaga)', 'Tren', '48011', NULL, '48480', 43.24237, -2.91641, 'address', 'openstreetmap:node/5254817178'),
  ('catalogo-pais-vasco:estaciones:node-5259835085', 'Estación de tren de Bidebieta-Basauri – Piru Gainza kalea', 'Tren', '48015', 'Piru Gainza kalea', '48970', 43.23679, -2.88969, 'address', 'openstreetmap:node/5259835085'),
  ('catalogo-pais-vasco:estaciones:node-5289510526', 'Estación de tren de Olabeaga (Bilbao) – San Nikolas Olabeaga kalea', 'Tren', '48020', 'San Nikolas Olabeaga kalea 23', '48013', 43.26419, -2.95527, 'address', 'openstreetmap:node/5289510526'),
  ('catalogo-pais-vasco:estaciones:node-5299959449', 'Estación de tren de Ametzola (Bilbao) – Trenbideko etorbidea', 'Tren', '48020', 'Trenbideko etorbidea', '48012', 43.25454, -2.94313, 'address', 'openstreetmap:node/5299959449'),
  ('catalogo-pais-vasco:estaciones:node-5299959451', 'Estación de tren de Autonomía (Bilbao) – Maria Diaz Haroko kalea', 'Tren', '48020', 'Maria Diaz Haroko kalea 60', '48010', 43.25859, -2.94611, 'address', 'openstreetmap:node/5299959451'),
  ('catalogo-pais-vasco:estaciones:node-5299959452', 'Estación de tren de San Mamés (Bilbao) – Torres Quevedo ingeniariaren plaza', 'Tren', '48020', 'Torres Quevedo ingeniariaren plaza 1', '48013', 43.26211, -2.94928, 'address', 'openstreetmap:node/5299959452'),
  ('catalogo-pais-vasco:estaciones:node-5299959453', 'Estación de tren de Zorrotza (Bilbao) – Soka kalea', 'Tren', '48020', 'Soka kalea 5', '48013', 43.27771, -2.97203, 'address', 'openstreetmap:node/5299959453'),
  ('catalogo-pais-vasco:estaciones:node-5299959454', 'Estación de tren de Lutxana (Barakaldo) – Padre Obispo Olaetxea kalea', 'Tren', '48013', 'Padre Obispo Olaetxea kalea 61', '48903', 43.2877, -2.9753, 'address', 'openstreetmap:node/5299959454'),
  ('catalogo-pais-vasco:estaciones:node-5299959455', 'Estación de tren de Sestao – Calle Rivas kalea', 'Tren', '48084', 'Calle Rivas kalea', '48910', 43.30856, -2.99396, 'address', 'openstreetmap:node/5299959455'),
  ('catalogo-pais-vasco:estaciones:node-5299959481', 'Estación de tren de La Iberia (Sestao) – Iberia kalea', 'Tren', '48084', 'Iberia kalea 41', '48910', 43.31281, -3.00479, 'address', 'openstreetmap:node/5299959481'),
  ('catalogo-pais-vasco:estaciones:node-5299959493', 'Estación de tren de Peñota (Santurtzi) – Paseo de la Reina Victoria Eugenia', 'Tren', '48082', 'Paseo de la Reina Victoria Eugenia', '48980', 43.32625, -3.02363, 'address', 'openstreetmap:node/5299959493'),
  ('catalogo-pais-vasco:estaciones:node-5301954661', 'Estación de tren de Miribilla (Bilbao) – Konpostelako Done Jakue kalea', 'Tren', '48020', 'Konpostelako Done Jakue kalea 12', '48003', 43.25009, -2.93052, 'address', 'openstreetmap:node/5301954661'),
  ('catalogo-pais-vasco:estaciones:node-5301954666', 'Estación de tren de Zalla – Avenida Taramona', 'Tren', '48096', 'Avenida Taramona 5', '48860', 43.21283, -3.13333, 'address', 'openstreetmap:node/5301954666'),
  ('catalogo-pais-vasco:estaciones:node-5301954667', 'Estación de tren de Kastrexana (Bilbao) – Carretera Basurto-Castrejana', 'Tren', '48020', 'Carretera Basurto-Castrejana', NULL, 43.25544, -2.97199, 'address', 'openstreetmap:node/5301954667'),
  ('catalogo-pais-vasco:estaciones:node-5301954668', 'Estación de tren de Irauregi Alonsotegi – Bazteita auzoa', 'Tren', '48912', 'Bazteita auzoa', NULL, 43.24843, -2.98991, 'address', 'openstreetmap:node/5301954668'),
  ('catalogo-pais-vasco:estaciones:node-5301954681', 'Estación de tren de Zorrotza Zorrotzgoiti (Bilbao) – Zorrotza-Kastrexana errepidea', 'Tren', '48020', 'Zorrotza-Kastrexana errepidea 34', '48013', 43.27399, -2.97414, 'address', 'openstreetmap:node/5301954681'),
  ('catalogo-pais-vasco:estaciones:node-5301954698', 'Estación de tren de Arrigorriaga – Urgoiti pasealekua', 'Tren', '48011', 'Urgoiti pasealekua 4', '48480', 43.21008, -2.88877, 'address', 'openstreetmap:node/5301954698'),
  ('catalogo-pais-vasco:estaciones:node-5301954699', 'Estación de tren de Basurto-Ospitalea/Hospital (Bilbao) – Basurtu-Kastrexana errepidea', 'Tren', '48020', 'Basurtu-Kastrexana errepidea 33', '48002', 43.25965, -2.95322, 'address', 'openstreetmap:node/5301954699'),
  ('catalogo-pais-vasco:estaciones:node-5451395346', 'Estación de tren de Santa Águeda (Bilbao) – Zorrotza-Kastrexana errepidea', 'Tren', '48020', 'Zorrotza-Kastrexana errepidea 150', '48013', 43.26171, -2.97268, 'address', 'openstreetmap:node/5451395346'),
  ('catalogo-pais-vasco:estaciones:node-5451405664', 'Estación de tren de Gernika (Gernika-Lumo) – Loizaga kalea', 'Tren', '48046', 'Loizaga kalea 1', '48300', 43.31396, -2.67622, 'address', 'openstreetmap:node/5451405664'),
  ('catalogo-pais-vasco:estaciones:node-5451405665', 'Estación de tren de Busturia Itsasbegi – Axpe auzoa', 'Tren', '48021', 'Axpe auzoa 134', NULL, 43.39087, -2.69367, 'address', 'openstreetmap:node/5451405665'),
  ('catalogo-pais-vasco:estaciones:node-5454334442', 'Estación de tren de Aranguren (Zalla) – Arangoiti auzoa', 'Tren', '48096', 'Arangoiti auzoa', '48860', 43.2105, -3.10896, 'address', 'openstreetmap:node/5454334442'),
  ('catalogo-pais-vasco:estaciones:node-5454334453', 'Estación de tren de Sodupe (Güeñes) – Urrestieta kalea', 'Tren', '48045', 'Urrestieta kalea 8', '48830', 43.20173, -3.05073, 'address', 'openstreetmap:node/5454334453'),
  ('catalogo-pais-vasco:estaciones:node-5454334458', 'Estación de tren de Zaramillo (Güeñes) – Geltoki bidea', 'Tren', '48045', 'Geltoki bidea', '48840', 43.23336, -3.01643, 'address', 'openstreetmap:node/5454334458'),
  ('catalogo-pais-vasco:estaciones:node-5661900464', 'Estación de tren de Derio – Astintze kalea', 'Tren', '48901', 'Astintze kalea 4', '48160', 43.29089, -2.88744, 'address', 'openstreetmap:node/5661900464'),
  ('catalogo-pais-vasco:estaciones:node-5661950836', 'Estación de tren de Kurtzea (Lezama) – Txorierri errepidea', 'Tren', '48081', 'Txorierri errepidea', NULL, 43.27659, -2.84634, 'address', 'openstreetmap:node/5661950836'),
  ('catalogo-pais-vasco:estaciones:node-5869099562', 'Estación de tren de Arakaldo – Usilarra alderdia', 'Tren', '48005', 'Usilarra alderdia', '48498', 43.15307, -2.93843, 'address', 'openstreetmap:node/5869099562'),
  ('catalogo-pais-vasco:estaciones:node-5872061988', 'Estación de tren de Arbide (Arrankudiaga-Zollo) – Arbide auzoa', 'Tren', '48009', 'Arbide auzoa', NULL, 43.16323, -2.92766, 'address', 'openstreetmap:node/5872061988'),
  ('catalogo-pais-vasco:estaciones:node-5872101431', 'Estación de tren de Arrankudiaga (Arrankudiaga-Zollo) – Uribarri auzoa', 'Tren', '48009', 'Uribarri auzoa', NULL, 43.16992, -2.91815, 'address', 'openstreetmap:node/5872101431'),
  ('catalogo-pais-vasco:estaciones:node-5888318522', 'Estación de tren de Karrantza (Karrantza Harana / Valle de Carranza) – Ambasaguas auzoa', 'Tren', '48022', 'Ambasaguas auzoa', NULL, 43.23893, -3.35775, 'address', 'openstreetmap:node/5888318522'),
  ('catalogo-pais-vasco:estaciones:node-5919402025', 'Estación de tren de Balmaseda – Avenida de la Estación', 'Tren', '48090', 'Avenida de la Estación', NULL, 43.19654, -3.1898, 'address', 'openstreetmap:node/5919402025'),
  ('catalogo-pais-vasco:estaciones:node-5938653111', 'Estación de tren de Urioste (Ortuella) – Grupo Aiega etxaldea', 'Tren', '48083', 'Grupo Aiega etxaldea 61', '48530', 43.30752, -3.04094, 'address', 'openstreetmap:node/5938653111'),
  ('catalogo-pais-vasco:estaciones:node-6077520291', 'Estación de tren de Bakiola (Arrankudiaga-Zollo) – Bakiola industrialdea', 'Tren', '48009', 'Bakiola industrialdea 3', NULL, 43.1769, -2.90914, 'address', 'openstreetmap:node/6077520291'),
  ('catalogo-pais-vasco:estaciones:node-6090575843', 'Estación de tren de Traslaviña (Artzentales)', 'Tren', '48008', NULL, NULL, 43.23336, -3.19827, 'address', 'openstreetmap:node/6090575843'),
  ('catalogo-pais-vasco:estaciones:node-6148706086', 'Estación de tren de La Calzada (Balmaseda) – Calle La Calzada', 'Tren', '48090', 'Calle La Calzada', '48800', 43.19006, -3.19746, 'address', 'openstreetmap:node/6148706086'),
  ('catalogo-pais-vasco:estaciones:node-6148706088', 'Estación de tren de La Herrera (Zalla) – Barrio La Herrera-Ijalde', 'Tren', '48096', 'Barrio La Herrera-Ijalde 9', '48860', 43.20317, -3.17052, 'address', 'openstreetmap:node/6148706088'),
  ('catalogo-pais-vasco:estaciones:node-6148706090', 'Aranguren Apeadero (Zalla) – Nicolas Maria Urgoiti kalea', 'Tren', '48096', 'Nicolas Maria Urgoiti kalea 6', '48860', 43.21033, -3.11376, 'address', 'openstreetmap:node/6148706090'),
  ('catalogo-pais-vasco:estaciones:node-6148706091', 'Estación de tren de Güeñes – Enkarterri kalea', 'Tren', '48045', 'Enkarterri kalea', '48840', 43.20896, -3.09533, 'address', 'openstreetmap:node/6148706091'),
  ('catalogo-pais-vasco:estaciones:node-6148706092', 'Estación de tren de La Quadra (Güeñes) – Puente San Pedro', 'Tren', '48045', 'Puente San Pedro', NULL, 43.22282, -3.02489, 'address', 'openstreetmap:node/6148706092'),
  ('catalogo-pais-vasco:estaciones:node-6148706093', 'Estación de tren de Lámbarri (Güeñes) – Lambarri kalea', 'Tren', '48045', 'Lambarri kalea', NULL, 43.20599, -3.08246, 'address', 'openstreetmap:node/6148706093'),
  ('catalogo-pais-vasco:estaciones:node-6235968974', 'Estación de tren de Ermua – Gipuzkoa hiribidea', 'Tren', '48034', 'Gipuzkoa hiribidea', NULL, 43.18483, -2.50116, 'address', 'openstreetmap:node/6235968974'),
  ('catalogo-pais-vasco:estaciones:node-6566500313', 'Estación de tren de Ibarra (Zalla) – Barrio Gobeo', 'Tren', '48096', 'Barrio Gobeo 14', '48860', 43.20392, -3.14487, 'address', 'openstreetmap:node/6566500313'),
  ('catalogo-pais-vasco:estaciones:node-6570628980', 'Estación de tren de Villaverde de Trucios (Artzentales)', 'Tren', '48008', NULL, NULL, 43.24123, -3.25055, 'address', 'openstreetmap:node/6570628980'),
  ('catalogo-pais-vasco:estaciones:node-6570688409', 'Estación de tren de Artzentales', 'Tren', '48008', NULL, NULL, 43.23572, -3.21328, 'address', 'openstreetmap:node/6570688409'),
  ('catalogo-pais-vasco:estaciones:node-6609322923', 'Estación de tren de Etxebarri – Santa Ana kalea', 'Tren', '48029', 'Santa Ana kalea 18', '48450', 43.24506, -2.89031, 'address', 'openstreetmap:node/6609322923'),
  ('catalogo-pais-vasco:estaciones:node-683405040', 'Estación de tren de Artxube (Güeñes) – Acceso a San Pedro Goikuría', 'Tren', '48045', 'Acceso a San Pedro Goikuría', NULL, 43.20101, -3.07164, 'address', 'openstreetmap:node/683405040'),
  ('catalogo-pais-vasco:estaciones:node-683629988', 'Estación de tren de Colegio (Zalla) – Avenida Lehendakari Agirre', 'Tren', '48096', 'Avenida Lehendakari Agirre 13', '48860', 43.21095, -3.13853, 'address', 'openstreetmap:node/683629988'),
  ('catalogo-pais-vasco:estaciones:node-7014928155', 'Estación de autobuses de Bilbao Intermodal – Gurtubay kalea', 'Autobús', '48020', 'Gurtubay kalea 1', '48013', 43.26113, -2.94963, 'address', 'openstreetmap:node/7014928155'),
  ('catalogo-pais-vasco:estaciones:node-7873767680', 'Estación de tren de Galindo (Sestao) – Calle Vía Galindo A0A', 'Tren', '48084', 'Calle Vía Galindo A0A', '48910', 43.3041, -3.01017, 'address', 'openstreetmap:node/7873767680'),
  ('catalogo-pais-vasco:estaciones:node-7894403635', 'Estación de tren de Valle de Trápaga-Trapagaran – Paseo de la Estación', 'Tren', '48080', 'Paseo de la Estación', '48510', 43.30146, -3.02846, 'address', 'openstreetmap:node/7894403635'),
  ('catalogo-pais-vasco:estaciones:node-7894423036', 'Estación de tren de Ortuella – Geltoki etorbidea', 'Tren', '48083', 'Geltoki etorbidea', '48530', 43.31149, -3.06041, 'address', 'openstreetmap:node/7894423036'),
  ('catalogo-pais-vasco:estaciones:node-7894425820', 'Estación de tren de Putxeta (Abanto y Ciérvana-Abanto Zierbena) – Santa Juliana auzoa', 'Tren', '48002', 'Santa Juliana auzoa', NULL, 43.31559, -3.09114, 'address', 'openstreetmap:node/7894425820'),
  ('catalogo-pais-vasco:estaciones:node-8044485140', 'Estación de tren de Bermeo – Santamañe kalea', 'Tren', '48017', 'Santamañe kalea 4', '48370', 43.41787, -2.72334, 'address', 'openstreetmap:node/8044485140'),
  ('catalogo-pais-vasco:estaciones:node-8044521461', 'Estación de tren de Larrondo (Loiu) – Larrondo Goiko kalea', 'Tren', '48903', 'Larrondo Goiko kalea', NULL, 43.29433, -2.91581, 'address', 'openstreetmap:node/8044521461'),
  ('catalogo-pais-vasco:estaciones:node-8044557264', 'Estación de tren de Zugastieta (Muxika) – Zugastieta auzoa', 'Tren', '48067', 'Zugastieta auzoa 23', '48392', 43.25212, -2.69283, 'address', 'openstreetmap:node/8044557264'),
  ('catalogo-pais-vasco:estaciones:node-8044648579', 'Estación de tren de Amorebieta (Amorebieta-Etxano) – Leginetxe auzoa', 'Tren', '48003', 'Leginetxe auzoa', '48340', 43.21676, -2.73646, 'address', 'openstreetmap:node/8044648579'),
  ('catalogo-pais-vasco:estaciones:node-8044660052', 'Estación de tren de Bedia – Barroeta auzoa', 'Tren', '48092', 'Barroeta auzoa', NULL, 43.20612, -2.79761, 'address', 'openstreetmap:node/8044660052'),
  ('catalogo-pais-vasco:estaciones:node-8044660107', 'Estación de tren de Lemoa', 'Tren', '48055', NULL, NULL, 43.20714, -2.77541, 'address', 'openstreetmap:node/8044660107'),
  ('catalogo-pais-vasco:estaciones:node-8044661068', 'Estación de tren de Usansolo – Oletxe kalea', 'Tren', '48916', 'Oletxe kalea', '48960', 43.21774, -2.82176, 'address', 'openstreetmap:node/8044661068'),
  ('catalogo-pais-vasco:estaciones:node-8044677096', 'Estación de tren de Zuhatzu (Galdakao) – Txomin Egileor kalea', 'Tren', '48036', 'Txomin Egileor kalea', '48960', 43.22878, -2.85419, 'address', 'openstreetmap:node/8044677096'),
  ('catalogo-pais-vasco:estaciones:node-8044688384', 'Estación de tren de Euba (Amorebieta-Etxano) – Euba auzoa', 'Tren', '48003', 'Euba auzoa', NULL, 43.19475, -2.69688, 'address', 'openstreetmap:node/8044688384'),
  ('catalogo-pais-vasco:estaciones:node-8044694902', 'Estación de tren de Berriz – Arkaraz', 'Tren', '48019', 'Arkaraz', '48240', 43.16846, -2.57443, 'address', 'openstreetmap:node/8044694902'),
  ('catalogo-pais-vasco:estaciones:node-8047931566', 'Estación de tren de Zaldibar – Zalduaran kalea', 'Tren', '48095', 'Zalduaran kalea', '48250', 43.17163, -2.54802, 'address', 'openstreetmap:node/8047931566'),
  ('catalogo-pais-vasco:estaciones:node-8738524371', 'Estación de tren de Ariz (Basauri) – Solokoetxe kalea', 'Tren', '48015', 'Solokoetxe kalea', '48970', 43.2398, -2.87897, 'address', 'openstreetmap:node/8738524371'),
  ('catalogo-pais-vasco:estaciones:node-9828481382', 'Estación de tren de Forua – Elexalde auzoa', 'Tren', '48906', 'Elexalde auzoa 69', '48393', 43.33203, -2.67367, 'address', 'openstreetmap:node/9828481382'),
  ('catalogo-pais-vasco:estaciones:way-1252784911', 'Autobus geltokia (Ispaster) – Iñigo Egiluz plaza', 'Autobús', '48049', 'Iñigo Egiluz plaza', '48288', 43.36212, -2.5454, 'address', 'openstreetmap:way/1252784911'),
  ('catalogo-pais-vasco:estaciones:way-218664177', 'Estación autobuses Gernika (Gernika-Lumo) – Iparragirre kalea', 'Autobús', '48046', 'Iparragirre kalea 14', '48300', 43.31368, -2.67654, 'approximate', 'openstreetmap:way/218664177'),
  ('catalogo-pais-vasco:estaciones:way-28776478', 'Estación de tren de Abando Indalecio Prieto (Bilbao) – Plaza Biribila', 'Tren', '48020', 'Plaza Biribila 2', '48008', 43.25984, -2.92862, 'address', 'openstreetmap:way/28776478'),
  ('catalogo-pais-vasco:estaciones:way-44113519', 'Estación de tren de Bilbao La Concordia – Bailen kalea', 'Tren', '48020', 'Bailen kalea 1', '48003', 43.25991, -2.9265, 'address', 'openstreetmap:way/44113519'),
  ('catalogo-pais-vasco:estaciones:way-454915677', 'Estación de Autobuses de Barakaldo – Ismael Gorostiza etorbidea', 'Autobús', '48013', 'Ismael Gorostiza etorbidea', '48902', 43.28923, -2.98707, 'address', 'openstreetmap:way/454915677');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '48');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 48 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '48'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 110 THEN
    RAISE EXCEPTION 'Se esperaban 110 puntos de Estaciones en Bizkaia, hay %', n;
  END IF;
END;
$$;

COMMIT;
