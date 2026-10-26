-- Carga de la categoría Estaciones de León (provincia 24), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 72 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-1069592576', 'Estación de tren de Ponferrada – Avenida del Ferrocarril', 'Tren', '24115', 'Avenida del Ferrocarril', '24403', 42.54566, -6.60249, 'address', 'openstreetmap:node/1069592576'),
  ('catalogo-castilla-y-leon:estaciones:node-11494000079', 'Estación de tren de Grajal de Campos – Calle Estación', 'Tren', '24080', 'Calle Estación', '24340', 42.32323, -5.01331, 'address', 'openstreetmap:node/11494000079'),
  ('catalogo-castilla-y-leon:estaciones:node-12589982358', 'Estación de tren de El Burgo Ranero – Camino Estación', 'Tren', '24024', 'Camino Estación', NULL, 42.42577, -5.20845, 'address', 'openstreetmap:node/12589982358'),
  ('catalogo-castilla-y-leon:estaciones:node-13151175122', 'Estación de tren de Toral de los Vados – Plaza de la Estación', 'Tren', '24206', 'Plaza de la Estación 1', '24560', 42.54096, -6.77679, 'address', 'openstreetmap:node/13151175122'),
  ('catalogo-castilla-y-leon:estaciones:node-13298248490', 'Estación de tren de La Pola de Gordón – Calle Villarin', 'Tren', '24114', 'Calle Villarin', NULL, 42.8539, -5.6747, 'address', 'openstreetmap:node/13298248490'),
  ('catalogo-castilla-y-leon:estaciones:node-13653715565', 'Estación de tren de Santa Lucía (La Pola de Gordón) – Calle Víctor Fernández', 'Tren', '24114', 'Calle Víctor Fernández', NULL, 42.87495, -5.63958, 'address', 'openstreetmap:node/13653715565'),
  ('catalogo-castilla-y-leon:estaciones:node-13653715566', 'Estación de tren de Villamanín – Calle de la Estación', 'Tren', '24901', 'Calle de la Estación', NULL, 42.93664, -5.65784, 'address', 'openstreetmap:node/13653715566'),
  ('catalogo-castilla-y-leon:estaciones:node-13653715567', 'Estación de tren de Busdongo (Villamanín) – Carretera de Asturias', 'Tren', '24901', 'Carretera de Asturias 6', '24690', 42.98437, -5.7053, 'address', 'openstreetmap:node/13653715567'),
  ('catalogo-castilla-y-leon:estaciones:node-13683507997', 'Estación de tren de Barrientos (Valderrey)', 'Tren', '24182', NULL, NULL, 42.41444, -5.96406, 'address', 'openstreetmap:node/13683507997'),
  ('catalogo-castilla-y-leon:estaciones:node-13714561632', 'Estación de tren de Bembibre – Calle El Paso', 'Tren', '24014', 'Calle El Paso', NULL, 42.60954, -6.42221, 'address', 'openstreetmap:node/13714561632'),
  ('catalogo-castilla-y-leon:estaciones:node-14144168363', 'Estación de Autobuses de Ponferrada – Avenida de la Libertad', 'Autobús', '24115', 'Avenida de la Libertad', '24404', 42.55314, -6.60149, 'address', 'openstreetmap:node/14144168363'),
  ('catalogo-castilla-y-leon:estaciones:node-14144168377', 'Estación de Autobuses de Astorga – Calle de Plinio el Joven', 'Autobús', '24008', 'Calle de Plinio el Joven', '24700', 42.45925, -6.05574, 'approximate', 'openstreetmap:node/14144168377'),
  ('catalogo-castilla-y-leon:estaciones:node-184051644', 'Estación de tren de San Miguel de las Dueñas (Congosto) – Calle La Estación', 'Tren', '24057', 'Calle La Estación', '24398', 42.5865, -6.52393, 'address', 'openstreetmap:node/184051644'),
  ('catalogo-castilla-y-leon:estaciones:node-1876260781', 'Estación de tren de Villadepalos (Carracedelo) – Avenida Ferrocarril', 'Tren', '24038', 'Avenida Ferrocarril', NULL, 42.53685, -6.75104, 'address', 'openstreetmap:node/1876260781'),
  ('catalogo-castilla-y-leon:estaciones:node-2384166014', 'Estación de tren de Sahagún – Calle Tras de la Estacion', 'Tren', '24139', 'Calle Tras de la Estacion', NULL, 42.3694, -5.0226, 'address', 'openstreetmap:node/2384166014'),
  ('catalogo-castilla-y-leon:estaciones:node-2384202227', 'Estación de tren de Santas Martas – Calle del Muelle', 'Tren', '24160', 'Calle del Muelle', NULL, 42.45988, -5.38673, 'address', 'openstreetmap:node/2384202227'),
  ('catalogo-castilla-y-leon:estaciones:node-2384757135', 'Estación de tren de Palanquinos (Villanueva de las Manzanas) – Calle la Alegría', 'Tren', '24218', 'Calle la Alegría', NULL, 42.46073, -5.49594, 'address', 'openstreetmap:node/2384757135'),
  ('catalogo-castilla-y-leon:estaciones:node-2974661834', 'Estación de tren de Astorga – Avenida de la Estación', 'Tren', '24008', 'Avenida de la Estación', NULL, 42.4594, -6.04706, 'address', 'openstreetmap:node/2974661834'),
  ('catalogo-castilla-y-leon:estaciones:node-4217804413', 'Estación de tren de La Vecilla – Calle La Estación', 'Tren', '24193', 'Calle La Estación', NULL, 42.85511, -5.41207, 'address', 'openstreetmap:node/4217804413'),
  ('catalogo-castilla-y-leon:estaciones:node-4586092223', 'Estación de tren de La Robla – Calle Gordón Ordás', 'Tren', '24134', 'Calle Gordón Ordás 28', '24640', 42.80399, -5.62648, 'address', 'openstreetmap:node/4586092223'),
  ('catalogo-castilla-y-leon:estaciones:node-5299078295', 'Estación de tren de León – Avenida Palencia', 'Tren', '24089', 'Avenida Palencia', '24009', 42.5951, -5.58194, 'address', 'openstreetmap:node/5299078295'),
  ('catalogo-castilla-y-leon:estaciones:node-5919329912', 'Estación de tren de Valle de las Casas (Cebanico)', 'Tren', '24052', NULL, NULL, 42.76788, -5.07096, 'address', 'openstreetmap:node/5919329912'),
  ('catalogo-castilla-y-leon:estaciones:node-5919330024', 'Estación de tren de La Llama de la Guzpeña (Prado de la Guzpeña)', 'Tren', '24118', NULL, NULL, 42.7703, -5.04132, 'address', 'openstreetmap:node/5919330024'),
  ('catalogo-castilla-y-leon:estaciones:node-5919330067', 'Estación de tren de Prado de la Guzpeña – Calle Torre', 'Tren', '24118', 'Calle Torre', NULL, 42.78328, -5.02714, 'address', 'openstreetmap:node/5919330067'),
  ('catalogo-castilla-y-leon:estaciones:node-5919330154', 'Estación de tren de Cerezal de la Guzpeña (Prado de la Guzpeña) – Carretera Puerto de Cerredo a Aguilar de Campoo', 'Tren', '24118', 'Carretera Puerto de Cerredo a Aguilar de Campoo', NULL, 42.77981, -5.00559, 'address', 'openstreetmap:node/5919330154'),
  ('catalogo-castilla-y-leon:estaciones:node-5919330155', 'Estación de tren de Puente Almuhey (Valderrueda) – Calle la Estación', 'Tren', '24183', 'Calle la Estación 4', NULL, 42.7876, -4.97248, 'address', 'openstreetmap:node/5919330155'),
  ('catalogo-castilla-y-leon:estaciones:node-5920024966', 'Estación de tren de Valcuende (Valderrueda)', 'Tren', '24183', NULL, NULL, 42.76528, -4.92968, 'address', 'openstreetmap:node/5920024966'),
  ('catalogo-castilla-y-leon:estaciones:node-5920025212', 'Estación de tren de La Espina (Valderrueda) – Calle Espina', 'Tren', '24183', 'Calle Espina', NULL, 42.78668, -4.90536, 'address', 'openstreetmap:node/5920025212'),
  ('catalogo-castilla-y-leon:estaciones:node-6077734214', 'Estación de tren de Brañuelas (Villagatón) – Calle Fanal', 'Tren', '24210', 'Calle Fanal', '24360', 42.63278, -6.20097, 'address', 'openstreetmap:node/6077734214'),
  ('catalogo-castilla-y-leon:estaciones:node-6565134415', 'Estación de tren de Matallana (Matallana de Torío)', 'Tren', '24098', NULL, NULL, 42.84114, -5.52217, 'address', 'openstreetmap:node/6565134415'),
  ('catalogo-castilla-y-leon:estaciones:node-6565199914', 'Estación de tren de Boñar – Calle Herminio Rodríguez', 'Tren', '24021', 'Calle Herminio Rodríguez', NULL, 42.86278, -5.32871, 'address', 'openstreetmap:node/6565199914'),
  ('catalogo-castilla-y-leon:estaciones:node-6565205645', 'Estación de tren de La Devesa (Vegaquemada)', 'Tren', '24199', NULL, NULL, 42.82012, -5.30221, 'address', 'openstreetmap:node/6565205645'),
  ('catalogo-castilla-y-leon:estaciones:node-6565221747', 'Estación de tren de Cistierna – Calle el Hullero', 'Tren', '24056', 'Calle el Hullero', NULL, 42.80318, -5.13091, 'address', 'openstreetmap:node/6565221747'),
  ('catalogo-castilla-y-leon:estaciones:node-6566106167', 'Estación de tren de San Feliz (Garrafe de Torío) – Calle la Estación', 'Tren', '24076', 'Calle la Estación', NULL, 42.68227, -5.53796, 'address', 'openstreetmap:node/6566106167'),
  ('catalogo-castilla-y-leon:estaciones:node-6566133234', 'Estación de tren de Villaquilambre – Calle la Vía', 'Tren', '24222', 'Calle la Vía', NULL, 42.64692, -5.55398, 'address', 'openstreetmap:node/6566133234'),
  ('catalogo-castilla-y-leon:estaciones:node-6566146984', 'Estación de tren de Robles de la Valcueva (Matallana de Torío) – Calle las Fuentes', 'Tren', '24098', 'Calle las Fuentes', NULL, 42.84072, -5.50736, 'address', 'openstreetmap:node/6566146984'),
  ('catalogo-castilla-y-leon:estaciones:node-6566147688', 'Estación de tren de Villasinta (Villaquilambre) – Calle la Vía', 'Tren', '24222', 'Calle la Vía', NULL, 42.65767, -5.54921, 'address', 'openstreetmap:node/6566147688'),
  ('catalogo-castilla-y-leon:estaciones:node-6566149210', 'Estación de tren de La Valcueva (Matallana de Torío) – Calle la Riba', 'Tren', '24098', 'Calle la Riba', NULL, 42.84966, -5.48701, 'address', 'openstreetmap:node/6566149210'),
  ('catalogo-castilla-y-leon:estaciones:node-6566190548', 'Estación de tren de La Mata de la Riba (Vegaquemada)', 'Tren', '24199', NULL, NULL, 42.85855, -5.33952, 'address', 'openstreetmap:node/6566190548'),
  ('catalogo-castilla-y-leon:estaciones:node-6566199882', 'Estación de tren de Valdepiélago', 'Tren', '24179', NULL, NULL, 42.86494, -5.40324, 'address', 'openstreetmap:node/6566199882'),
  ('catalogo-castilla-y-leon:estaciones:node-6566217722', 'Estación de tren de Otero (Valdepiélago)', 'Tren', '24179', NULL, NULL, 42.85959, -5.38997, 'address', 'openstreetmap:node/6566217722'),
  ('catalogo-castilla-y-leon:estaciones:node-6566231192', 'Estación de tren de La Losilla (Vegaquemada) – Calle Real', 'Tren', '24199', 'Calle Real', NULL, 42.83857, -5.31818, 'address', 'openstreetmap:node/6566231192'),
  ('catalogo-castilla-y-leon:estaciones:node-6566235102', 'Estación de tren de Yugueros (La Ercina) – Carretera de Cistierna a Vegaquemada', 'Tren', '24068', 'Carretera de Cistierna a Vegaquemada', NULL, 42.80978, -5.18003, 'address', 'openstreetmap:node/6566235102'),
  ('catalogo-castilla-y-leon:estaciones:node-6566237027', 'Estación de tren de La Ercina – Carretera de Cistierna a Vegaquemada', 'Tren', '24068', 'Carretera de Cistierna a Vegaquemada', NULL, 42.80888, -5.21401, 'address', 'openstreetmap:node/6566237027'),
  ('catalogo-castilla-y-leon:estaciones:node-6568466839', 'Estación de tren de Villa Romana (Villaquilambre) – Avenida de la Libertad', 'Tren', '24222', 'Avenida de la Libertad', NULL, 42.6291, -5.56132, 'address', 'openstreetmap:node/6568466839'),
  ('catalogo-castilla-y-leon:estaciones:node-6568470605', 'Estación de tren de La Raya (Villaquilambre) – Calle Puerto Rico', 'Tren', '24222', 'Calle Puerto Rico', NULL, 42.63807, -5.55699, 'address', 'openstreetmap:node/6568470605'),
  ('catalogo-castilla-y-leon:estaciones:node-6572873776', 'Estación de tren de Manzaneda (Garrafe de Torío) – Villanueva - Manzaneda', 'Tren', '24076', 'Villanueva - Manzaneda', NULL, 42.75472, -5.51642, 'address', 'openstreetmap:node/6572873776'),
  ('catalogo-castilla-y-leon:estaciones:node-6572901890', 'Estación de tren de Palazuelo (Garrafe de Torío)', 'Tren', '24076', NULL, NULL, 42.70714, -5.53382, 'address', 'openstreetmap:node/6572901890'),
  ('catalogo-castilla-y-leon:estaciones:node-6572910773', 'Estación de tren de Aviados (Valdepiélago) – Carretera de Aviados', 'Tren', '24179', 'Carretera de Aviados', NULL, 42.85473, -5.44283, 'address', 'openstreetmap:node/6572910773'),
  ('catalogo-castilla-y-leon:estaciones:node-6572911886', 'Estación de tren de Valderilla (Garrafe de Torío)', 'Tren', '24076', NULL, NULL, 42.71871, -5.52995, 'address', 'openstreetmap:node/6572911886'),
  ('catalogo-castilla-y-leon:estaciones:node-6572914872', 'Estación de tren de Matueca (Garrafe de Torío) – Calle Virgen del Camino', 'Tren', '24076', 'Calle Virgen del Camino', NULL, 42.77153, -5.51191, 'address', 'openstreetmap:node/6572914872'),
  ('catalogo-castilla-y-leon:estaciones:node-6572982070', 'Estación de tren de Campohermoso (La Vecilla) – Carretera Puerto de Cerredo a Aguilar de Campoo', 'Tren', '24193', 'Carretera Puerto de Cerredo a Aguilar de Campoo', NULL, 42.85591, -5.42873, 'address', 'openstreetmap:node/6572982070'),
  ('catalogo-castilla-y-leon:estaciones:node-6572996144', 'Estación de tren de Naredo (Matallana de Torío) – Carretera Puerto de Cerredo a Aguilar de Campoo', 'Tren', '24098', 'Carretera Puerto de Cerredo a Aguilar de Campoo', NULL, 42.83346, -5.52299, 'address', 'openstreetmap:node/6572996144'),
  ('catalogo-castilla-y-leon:estaciones:node-6572996604', 'Estación de tren de Pardavé (Matallana de Torío) – Calle San Andrés', 'Tren', '24098', 'Calle San Andrés', NULL, 42.80634, -5.50822, 'address', 'openstreetmap:node/6572996604'),
  ('catalogo-castilla-y-leon:estaciones:node-6573014597', 'Estación de tren de Pedrún (Garrafe de Torío) – Carretera León-Collanzo', 'Tren', '24076', 'Carretera León-Collanzo', NULL, 42.79091, -5.50703, 'address', 'openstreetmap:node/6573014597'),
  ('catalogo-castilla-y-leon:estaciones:node-6593377381', 'Estación de tren de Asunción-Universidad (León) – Calle Esperanza', 'Tren', '24089', 'Calle Esperanza 3', '24008', 42.61595, -5.56624, 'address', 'openstreetmap:node/6593377381'),
  ('catalogo-castilla-y-leon:estaciones:node-7525442923', 'Estación de tren de Torre del Bierzo – Avenida Vicente Aleixandre', 'Tren', '24170', 'Avenida Vicente Aleixandre', NULL, 42.59556, -6.3286, 'address', 'openstreetmap:node/7525442923'),
  ('catalogo-castilla-y-leon:estaciones:node-7529630164', 'Estación de tren de Veguellina (Villarejo de Órbigo) – Paseo Estación', 'Tren', '24223', 'Paseo Estación', '24350', 42.43347, -5.8875, 'address', 'openstreetmap:node/7529630164'),
  ('catalogo-castilla-y-leon:estaciones:node-7538431844', 'Estación de tren de Nistal (San Justo de la Vega) – Calle Antonio Aceña', 'Tren', '24148', 'Calle Antonio Aceña', NULL, 42.42439, -6.00803, 'address', 'openstreetmap:node/7538431844'),
  ('catalogo-castilla-y-leon:estaciones:node-7538495683', 'Estación de tren de Villavante (Santa Marina del Rey) – Calle el Palacio', 'Tren', '24159', 'Calle el Palacio', NULL, 42.46459, -5.83896, 'address', 'openstreetmap:node/7538495683'),
  ('catalogo-castilla-y-leon:estaciones:node-7538542562', 'Estación de tren de Quintana-Raneros (Santovenia de la Valdoncina) – Calle Guzmán el Bueno', 'Tren', '24162', 'Calle Guzmán el Bueno', NULL, 42.55009, -5.63794, 'address', 'openstreetmap:node/7538542562'),
  ('catalogo-castilla-y-leon:estaciones:node-7599486979', 'Estación de tren de Porqueros (Magaz de Cepeda) – Calle la Estación', 'Tren', '24093', 'Calle la Estación', NULL, 42.59878, -6.1084, 'address', 'openstreetmap:node/7599486979'),
  ('catalogo-castilla-y-leon:estaciones:node-7599789062', 'Estación de tren de Vega-Magaz (Magaz de Cepeda) – Camino Estación', 'Tren', '24093', 'Camino Estación', NULL, 42.55352, -6.06821, 'address', 'openstreetmap:node/7599789062'),
  ('catalogo-castilla-y-leon:estaciones:node-7844651286', 'Estación de tren de Sorriba (Cistierna) – Camino Nº Uno', 'Tren', '24056', 'Camino Nº Uno', NULL, 42.78615, -5.12748, 'address', 'openstreetmap:node/7844651286'),
  ('catalogo-castilla-y-leon:estaciones:node-9130558608', 'Estación de tren de Barrio de las Ollas (Boñar) – Calle Real', 'Tren', '24021', 'Calle Real', NULL, 42.86463, -5.3345, 'address', 'openstreetmap:node/9130558608'),
  ('catalogo-castilla-y-leon:estaciones:way-1011276253', 'Estación de autobuses de Bembibre – Calle Cantarranas', 'Autobús', '24014', 'Calle Cantarranas', '24300', 42.61888, -6.41235, 'address', 'openstreetmap:way/1011276253'),
  ('catalogo-castilla-y-leon:estaciones:way-1201344337', 'Estación de Autobuses (Santa María del Páramo) – Calle Fondilla', 'Autobús', '24157', 'Calle Fondilla 17', '24240', 42.35737, -5.74579, 'address', 'openstreetmap:way/1201344337'),
  ('catalogo-castilla-y-leon:estaciones:way-1470849152', 'Estación de Autobuses Reina Doña Urraca I de León – Avenida Ingeniero Sáenz de Miera', 'Autobús', '24089', 'Avenida Ingeniero Sáenz de Miera', '24009', 42.59249, -5.5787, 'address', 'openstreetmap:way/1470849152'),
  ('catalogo-castilla-y-leon:estaciones:way-508412181', 'Estación de Autobuses (Valencia de Don Juan) – Calle Pintor Murillo', 'Autobús', '24188', 'Calle Pintor Murillo', NULL, 42.29363, -5.51251, 'address', 'openstreetmap:way/508412181'),
  ('catalogo-castilla-y-leon:estaciones:way-62115131', 'Estación de Autobuses La Bañeza – Calle Reino de León', 'Autobús', '24010', 'Calle Reino de León', NULL, 42.30271, -5.89363, 'address', 'openstreetmap:way/62115131'),
  ('catalogo-castilla-y-leon:estaciones:way-62306151', 'Estación Autobuses de Astorga – Avenida de las Murallas', 'Autobús', '24008', 'Avenida de las Murallas 46', '24700', 42.45918, -6.05563, 'approximate', 'openstreetmap:way/62306151'),
  ('catalogo-castilla-y-leon:estaciones:way-813498064', 'Estación de tren de La Granja de San Vicente (Torre del Bierzo) – Calle Estación', 'Tren', '24170', 'Calle Estación', NULL, 42.60683, -6.295, 'address', 'openstreetmap:way/813498064');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '24');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 24 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '24'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 72 THEN
    RAISE EXCEPTION 'Se esperaban 72 puntos de Estaciones en León, hay %', n;
  END IF;
END;
$$;

COMMIT;
