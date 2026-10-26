-- Carga de la categoría Estaciones de Palencia (provincia 34), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 37 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-12714808106', 'Estación de tren de Alar del Rey – Plaza de Burgos', 'Tren', '34005', 'Plaza de Burgos', NULL, 42.65682, -4.31123, 'address', 'openstreetmap:node/12714808106'),
  ('catalogo-castilla-y-leon:estaciones:node-13653191408', 'Estación de tren de Guardo – Calle la Estación', 'Tren', '34080', 'Calle la Estación', NULL, 42.79097, -4.85188, 'address', 'openstreetmap:node/13653191408'),
  ('catalogo-castilla-y-leon:estaciones:node-1732357745', 'Estación de tren de Aguilar de Campoo – Barrio Estación', 'Tren', '34004', 'Barrio Estación', NULL, 42.78527, -4.23374, 'address', 'openstreetmap:node/1732357745'),
  ('catalogo-castilla-y-leon:estaciones:node-1732357748', 'Estación de tren de Amusco', 'Tren', '34011', NULL, NULL, 42.17823, -4.48058, 'address', 'openstreetmap:node/1732357748'),
  ('catalogo-castilla-y-leon:estaciones:node-1732357750', 'Estación de tren de El Carrión (Monzón de Campos) – Calle Hortelanos', 'Tren', '34108', 'Calle Hortelanos', NULL, 42.11675, -4.49586, 'address', 'openstreetmap:node/1732357750'),
  ('catalogo-castilla-y-leon:estaciones:node-1732357761', 'Estación de tren de Herrera de Pisuerga', 'Tren', '34083', NULL, NULL, 42.59868, -4.31647, 'address', 'openstreetmap:node/1732357761'),
  ('catalogo-castilla-y-leon:estaciones:node-1732357762', 'Estación de tren de Monzón de Campos', 'Tren', '34108', NULL, NULL, 42.10556, -4.50173, 'address', 'openstreetmap:node/1732357762'),
  ('catalogo-castilla-y-leon:estaciones:node-1732357763', 'Estación de tren de Osorno (Osorno la Mayor) – Avenida La Estación', 'Tren', '34901', 'Avenida La Estación', NULL, 42.41418, -4.35728, 'address', 'openstreetmap:node/1732357763'),
  ('catalogo-castilla-y-leon:estaciones:node-1782062632', 'Estación de tren de Magaz (Magaz de Pisuerga)', 'Tren', '34098', NULL, NULL, 41.97649, -4.43198, 'address', 'openstreetmap:node/1782062632'),
  ('catalogo-castilla-y-leon:estaciones:node-1939943099', 'Estación de tren de Palencia – Calle Pedro Miguel Barreda', 'Tren', '34120', 'Calle Pedro Miguel Barreda', NULL, 42.01573, -4.53386, 'address', 'openstreetmap:node/1939943099'),
  ('catalogo-castilla-y-leon:estaciones:node-2091973591', 'Estación de tren de Venta de Baños – Calle Barbotán', 'Tren', '34023', 'Calle Barbotán', NULL, 41.9174, -4.49627, 'address', 'openstreetmap:node/2091973591'),
  ('catalogo-castilla-y-leon:estaciones:node-2284687616', 'Estación de tren de Quintana del Puente', 'Tren', '34141', NULL, NULL, 42.07996, -4.19855, 'address', 'openstreetmap:node/2284687616'),
  ('catalogo-castilla-y-leon:estaciones:node-2320749276', 'Estación de tren de Villada – Calle Vía Férrea', 'Tren', '34206', 'Calle Vía Férrea', NULL, 42.24513, -4.97068, 'address', 'openstreetmap:node/2320749276'),
  ('catalogo-castilla-y-leon:estaciones:node-2383253431', 'Estación de tren de Paredes de Nava – Barrio del Pilar', 'Tren', '34123', 'Barrio del Pilar', NULL, 42.15068, -4.69763, 'address', 'openstreetmap:node/2383253431'),
  ('catalogo-castilla-y-leon:estaciones:node-2383262907', 'Estación de tren de Becerril de Campos', 'Tren', '34029', NULL, NULL, 42.10469, -4.64726, 'address', 'openstreetmap:node/2383262907'),
  ('catalogo-castilla-y-leon:estaciones:node-2383276325', 'Estación de tren de Grijota – Travesía Viejo Puente', 'Tren', '34079', 'Travesía Viejo Puente', NULL, 42.04984, -4.58491, 'address', 'openstreetmap:node/2383276325'),
  ('catalogo-castilla-y-leon:estaciones:node-258415358', 'Estación de tren de Mave (Aguilar de Campoo) – Plaza de la Estación', 'Tren', '34004', 'Plaza de la Estación', NULL, 42.72337, -4.27566, 'address', 'openstreetmap:node/258415358'),
  ('catalogo-castilla-y-leon:estaciones:node-274618728', 'Estación de tren de Frómista – Calle La Estación', 'Tren', '34074', 'Calle La Estación 2', '34440', 42.26487, -4.40239, 'address', 'openstreetmap:node/274618728'),
  ('catalogo-castilla-y-leon:estaciones:node-274618736', 'Estación de tren de Piña (Piña de Campos) – Calle de la Estación', 'Tren', '34130', 'Calle de la Estación', NULL, 42.21169, -4.43453, 'address', 'openstreetmap:node/274618736'),
  ('catalogo-castilla-y-leon:estaciones:node-3857310426', 'Estación de tren de Dueñas – Calle Estación de Ferrocarril', 'Tren', '34069', 'Calle Estación de Ferrocarril', NULL, 41.87124, -4.54073, 'address', 'openstreetmap:node/3857310426'),
  ('catalogo-castilla-y-leon:estaciones:node-498472945', 'Estación de tren de Quintanilla de las Torres (Pomar de Valdivia) – Calle de la Estación', 'Tren', '34135', 'Calle de la Estación', NULL, 42.81893, -4.2028, 'address', 'openstreetmap:node/498472945'),
  ('catalogo-castilla-y-leon:estaciones:node-569757411', 'Estación de tren de Cisneros', 'Tren', '34059', NULL, NULL, 42.19099, -4.85038, 'address', 'openstreetmap:node/569757411'),
  ('catalogo-castilla-y-leon:estaciones:node-5919339216', 'Guardo Apeadero – Paseo del Ayuntamiento', 'Tren', '34080', 'Paseo del Ayuntamiento', NULL, 42.7877, -4.8451, 'address', 'openstreetmap:node/5919339216'),
  ('catalogo-castilla-y-leon:estaciones:node-5919350285', 'Estación de tren de Vado-Cervera (Dehesa de Montejo) – Calle de la Estación', 'Tren', '34067', 'Calle de la Estación', NULL, 42.83933, -4.4944, 'address', 'openstreetmap:node/5919350285'),
  ('catalogo-castilla-y-leon:estaciones:node-5919355191', 'Estación de tren de Cillamayor (Barruelo de Santullán) – Camino de acceso al apeadero de Cillamayor', 'Tren', '34027', 'Camino de acceso al apeadero de Cillamayor', NULL, 42.8577, -4.27909, 'address', 'openstreetmap:node/5919355191'),
  ('catalogo-castilla-y-leon:estaciones:node-6565239008', 'Estación de tren de Santibáñez de la Peña – Calle Estación', 'Tren', '34171', 'Calle Estación', NULL, 42.80197, -4.74178, 'address', 'openstreetmap:node/6565239008'),
  ('catalogo-castilla-y-leon:estaciones:node-6565464317', 'Estación de tren de Salinas de Pisuerga – Calle la Estación', 'Tren', '34158', 'Calle la Estación 6', NULL, 42.85131, -4.38611, 'address', 'openstreetmap:node/6565464317'),
  ('catalogo-castilla-y-leon:estaciones:node-985942118', 'Estación de tren de Espinosa de Villagonzalo – Calle Apeadero', 'Tren', '34071', 'Calle Apeadero', NULL, 42.47895, -4.37453, 'address', 'openstreetmap:node/985942118'),
  ('catalogo-castilla-y-leon:estaciones:node-9879334814', 'Estación de tren de Villaverde-Tarilonte (Santibáñez de la Peña)', 'Tren', '34171', NULL, NULL, 42.81855, -4.68605, 'address', 'openstreetmap:node/9879334814'),
  ('catalogo-castilla-y-leon:estaciones:node-9879343525', 'Estación de tren de Castrejón de la Peña', 'Tren', '34049', NULL, NULL, 42.81211, -4.60194, 'address', 'openstreetmap:node/9879343525'),
  ('catalogo-castilla-y-leon:estaciones:way-1419435479', 'Intercambiador Internacional de Viajeros (Quintana del Puente)', 'Autobús', '34141', NULL, NULL, 42.07663, -4.20972, 'address', 'openstreetmap:way/1419435479'),
  ('catalogo-castilla-y-leon:estaciones:way-198777993', 'Estación de Autobuses Guardo – Calle Fuentes Carrionas', 'Autobús', '34080', 'Calle Fuentes Carrionas', '34880', 42.79117, -4.84789, 'address', 'openstreetmap:way/198777993'),
  ('catalogo-castilla-y-leon:estaciones:way-297063478', 'Estación de Autobuses (Saldaña) – Calle Estación', 'Autobús', '34157', 'Calle Estación', '34100', 42.52107, -4.73824, 'address', 'openstreetmap:way/297063478'),
  ('catalogo-castilla-y-leon:estaciones:way-300706089', 'Estación de Autobuses de Osorno (Osorno la Mayor) – Polígono Residencial', 'Autobús', '34901', 'Polígono Residencial', '34460', 42.41312, -4.3633, 'address', 'openstreetmap:way/300706089'),
  ('catalogo-castilla-y-leon:estaciones:way-328652497', 'Estación de autobuses (Herrera de Pisuerga) – Avenida Eusebio Salvador Merino', 'Autobús', '34083', 'Avenida Eusebio Salvador Merino 59', '34400', 42.59227, -4.33071, 'address', 'openstreetmap:way/328652497'),
  ('catalogo-castilla-y-leon:estaciones:way-381208810', 'Estación de Autobuses de Aguilar de Campoo – Avenida Ronda', 'Autobús', '34004', 'Avenida Ronda', NULL, 42.7955, -4.25974, 'address', 'openstreetmap:way/381208810'),
  ('catalogo-castilla-y-leon:estaciones:way-84031348', 'Estación de Autobuses Blanca de Castilla de Palencia – Calle Pedro Berruguete', 'Autobús', '34120', 'Calle Pedro Berruguete', '34005', 42.01682, -4.53696, 'address', 'openstreetmap:way/84031348');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '34');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 34 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '34'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 37 THEN
    RAISE EXCEPTION 'Se esperaban 37 puntos de Estaciones en Palencia, hay %', n;
  END IF;
END;
$$;

COMMIT;
