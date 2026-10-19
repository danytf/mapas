-- Carga de la categoría (varias) de Cádiz (provincia 11), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 54 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11170027319', 'Carrefour San Fernando – Calle de San Rafael', NULL, '11031', 'Calle de San Rafael 14', '11100', 36.46947, -6.19572, 'address', 'openstreetmap:node/11170027319'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11197560707', 'Carrefour San Fernando – Avenida Puente Zuazo', NULL, '11031', 'Avenida Puente Zuazo', '11100', 36.46847, -6.18963, 'address', 'openstreetmap:node/11197560707'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-11975691989', 'MediaMarkt Los Barrios – Calle Cabotaje', NULL, '11008', 'Calle Cabotaje', '11379', 36.18852, -5.43244, 'address', 'openstreetmap:node/11975691989'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:node-12142807117', 'IKEA Algeciras', NULL, '11004', NULL, NULL, 36.13522, -5.46293, 'address', 'openstreetmap:node/12142807117'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12215002497', 'Carrefour Cádiz – Calle ancha', NULL, '11012', 'Calle ancha 31', NULL, 36.53308, -6.29727, 'address', 'openstreetmap:node/12215002497'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12478716001', 'Carrefour Tarifa', NULL, '11035', NULL, NULL, 36.0374, -5.62011, 'address', 'openstreetmap:node/12478716001'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12496243568', 'Carrefour Cádiz – Calle García Carrera', NULL, '11012', 'Calle García Carrera', NULL, 36.50893, -6.27589, 'address', 'openstreetmap:node/12496243568'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12507956748', 'Carrefour Cádiz – Avenida Segunda Aguada', NULL, '11012', 'Avenida Segunda Aguada', NULL, 36.51109, -6.27443, 'address', 'openstreetmap:node/12507956748'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-13136295701', 'Carrefour Chiclana de la Frontera – Alameda Solano', NULL, '11015', 'Alameda Solano', NULL, 36.4231, -6.14458, 'address', 'openstreetmap:node/13136295701'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-13983088601', 'Carrefour Rota – Avenida San Fernando', NULL, '11030', 'Avenida San Fernando', NULL, 36.62212, -6.36076, 'address', 'openstreetmap:node/13983088601'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-1457162876', 'Carrefour Arcos de la Frontera', NULL, '11006', NULL, NULL, 36.74794, -5.82443, 'address', 'openstreetmap:node/1457162876'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2083686171', 'Carrefour San Fernando – Calle Caño Herrera', NULL, '11031', 'Calle Caño Herrera', '11100', 36.47106, -6.20922, 'address', 'openstreetmap:node/2083686171'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2087473640', 'Carrefour Chiclana de la Frontera – Calle Marco Aurelio', NULL, '11015', 'Calle Marco Aurelio', NULL, 36.33988, -6.14781, 'address', 'openstreetmap:node/2087473640'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2749920204', 'Carrefour Algeciras – Alfonso XI', NULL, '11004', 'Alfonso XI', NULL, 36.13214, -5.44752, 'address', 'openstreetmap:node/2749920204'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3097102085', 'Carrefour El Puerto de Santa María – Avenida del Rey Felipe VI', NULL, '11027', 'Avenida del Rey Felipe VI', NULL, 36.61751, -6.21075, 'address', 'openstreetmap:node/3097102085'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3612147679', 'Carrefour Cádiz – Calle Acacias', NULL, '11012', 'Calle Acacias 4', '11007', 36.52376, -6.2857, 'address', 'openstreetmap:node/3612147679'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3811372039', 'Carrefour Cádiz – Plaza Libertad', NULL, '11012', 'Plaza Libertad', NULL, 36.53088, -6.29851, 'address', 'openstreetmap:node/3811372039'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4117413243', 'Carrefour Jerez de la Frontera – Calle Doña Blanca', NULL, '11020', 'Calle Doña Blanca 13', '11402', 36.68209, -6.13535, 'address', 'openstreetmap:node/4117413243'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4247071237', 'Carrefour Chiclana de la Frontera – Calle de la Plaza', NULL, '11015', 'Calle de la Plaza', '11130', 36.42014, -6.14957, 'address', 'openstreetmap:node/4247071237'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4450714089', 'Carrefour Conil de la Frontera – Carril de Juana Vela', NULL, '11014', 'Carril de Juana Vela', NULL, 36.34045, -6.09384, 'address', 'openstreetmap:node/4450714089'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4817489522', 'Carrefour Cádiz – Calle Diego Arias', NULL, '11012', 'Calle Diego Arias', NULL, 36.53187, -6.30314, 'address', 'openstreetmap:node/4817489522'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4959872089', 'Carrefour Paterna de Rivera – Calle Medina Sidonia', NULL, '11025', 'Calle Medina Sidonia', NULL, 36.52121, -5.86762, 'address', 'openstreetmap:node/4959872089'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4964280224', 'Carrefour Cádiz – Calle Buenos Aires', NULL, '11012', 'Calle Buenos Aires', NULL, 36.53552, -6.29799, 'address', 'openstreetmap:node/4964280224'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-499570014', 'Carrefour Los Barrios – CARRETERA CADIZ-MALAGA KM 112.9', NULL, '11008', 'CARRETERA CADIZ-MALAGA KM 112.9', NULL, 36.18082, -5.44227, 'address', 'openstreetmap:node/499570014'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5140744723', 'Carrefour Cádiz – Calle Sopranis', NULL, '11012', 'Calle Sopranis 1', '11005', 36.52947, -6.29247, 'address', 'openstreetmap:node/5140744723'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5235407522', 'Carrefour Cádiz – Avenida de la Sanidad Pública', NULL, '11012', 'Avenida de la Sanidad Pública', NULL, 36.51472, -6.27727, 'address', 'openstreetmap:node/5235407522'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5270589026', 'Carrefour San Fernando – Calle Real', NULL, '11031', 'Calle Real 90', '11100', 36.46342, -6.19904, 'address', 'openstreetmap:node/5270589026'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5480671021', 'Carrefour Cádiz – Calle Rochester', NULL, '11012', 'Calle Rochester', NULL, 36.52018, -6.28557, 'address', 'openstreetmap:node/5480671021'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5783697298', 'Carrefour Chiclana de la Frontera – Carretera de la Barrosa', NULL, '11015', 'Carretera de la Barrosa', '11139', 36.37195, -6.18166, 'address', 'openstreetmap:node/5783697298'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-873831871', 'Carrefour La Línea de la Concepción – Avenida de la Colonia', NULL, '11022', 'Avenida de la Colonia 9', '11300', 36.17446, -5.36353, 'address', 'openstreetmap:node/873831871'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9161346048', 'Carrefour San Fernando – Avenida de Cayetano Roldán', NULL, '11031', 'Avenida de Cayetano Roldán', '11100', 36.46997, -6.19917, 'address', 'openstreetmap:node/9161346048'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9251458348', 'Carrefour Rota – Avenida de la Libertad', NULL, '11030', 'Avenida de la Libertad', '11520', 36.62713, -6.36518, 'address', 'openstreetmap:node/9251458348'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-9555910517', 'Decathlon Cádiz – Calle Columela', NULL, '11012', 'Calle Columela', NULL, 36.53083, -6.29722, 'address', 'openstreetmap:node/9555910517'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9770602000', 'Carrefour El Puerto de Santa María – Avenida de la Paz', NULL, '11027', 'Avenida de la Paz 34', '11500', 36.57968, -6.2242, 'address', 'openstreetmap:node/9770602000'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-9999896287', 'Carrefour Algeciras – Calle Teniente Maroto', NULL, '11004', 'Calle Teniente Maroto', NULL, 36.12813, -5.4451, 'address', 'openstreetmap:node/9999896287'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-1023034103', 'Carrefour San Fernando – José Ramos Borrero Requetes', NULL, '11031', 'José Ramos Borrero Requetes', '11100', 36.45302, -6.20836, 'address', 'openstreetmap:way/1023034103'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-1264584551', 'Carrefour Algeciras', NULL, '11004', NULL, NULL, 36.12409, -5.43767, 'address', 'openstreetmap:way/1264584551'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-1264590949', 'Carrefour Los Barrios', NULL, '11008', NULL, NULL, 36.17714, -5.45187, 'address', 'openstreetmap:way/1264590949'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-1380641448', 'Carrefour Chipiona – Calle Ramón y Cajal', NULL, '11016', 'Calle Ramón y Cajal', NULL, 36.73776, -6.4393, 'address', 'openstreetmap:way/1380641448'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-143857632', 'El Corte Inglés Cádiz – Avenida de las Cortes de Cádiz', NULL, '11012', 'Avenida de las Cortes de Cádiz', NULL, 36.5213, -6.27723, 'address', 'openstreetmap:way/143857632'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:way-143885440', 'IKEA Jerez de la Frontera', NULL, '11020', NULL, NULL, 36.69712, -6.16217, 'address', 'openstreetmap:way/143885440'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-154741765', 'Carrefour Jerez de la Frontera – Calle Adolfo Comba Gracia', NULL, '11020', 'Calle Adolfo Comba Gracia', NULL, 36.69565, -6.11505, 'address', 'openstreetmap:way/154741765'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-204666475', 'Decathlon El Puerto de Santa María – Calle Luis M. Fernandez', NULL, '11027', 'Calle Luis M. Fernandez', '11500', 36.58634, -6.21834, 'address', 'openstreetmap:way/204666475'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-224738727', 'El Corte Inglés Jerez de la Frontera', NULL, '11020', NULL, NULL, 36.70416, -6.11566, 'address', 'openstreetmap:way/224738727'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-334403978', 'Carrefour Vejer de la Frontera – Avenida de Buenavista', NULL, '11039', 'Avenida de Buenavista 24', NULL, 36.24974, -5.9692, 'address', 'openstreetmap:way/334403978'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-396625918', 'Leroy Merlin Jerez de la Frontera – Avenida Bergantín', NULL, '11020', 'Avenida Bergantín', NULL, 36.7092, -6.12727, 'address', 'openstreetmap:way/396625918'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-44216894', 'Carrefour Jerez de la Frontera – Calle Escritor Antonio Quintero y Ramírez', NULL, '11020', 'Calle Escritor Antonio Quintero y Ramírez', NULL, 36.67268, -6.14984, 'address', 'openstreetmap:way/44216894'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-472227679', 'Decathlon Los Barrios – Calle Galera', NULL, '11008', 'Calle Galera', NULL, 36.18883, -5.43406, 'address', 'openstreetmap:way/472227679'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-481849128', 'Leroy Merlin Los Barrios – Avenida de los Empresarios', NULL, '11008', 'Avenida de los Empresarios', NULL, 36.18206, -5.43831, 'address', 'openstreetmap:way/481849128'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:way-502660315', 'MediaMarkt Puerto Real', NULL, '11028', NULL, NULL, 36.46924, -6.16955, 'address', 'openstreetmap:way/502660315'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-502660316', 'Leroy Merlin Puerto Real', NULL, '11028', NULL, NULL, 36.46916, -6.17044, 'address', 'openstreetmap:way/502660316'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-51368846', 'El Corte Inglés Algeciras – Calle Estadio', NULL, '11004', 'Calle Estadio', NULL, 36.139, -5.44838, 'address', 'openstreetmap:way/51368846'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-51368847', 'Carrefour Algeciras', NULL, '11004', NULL, NULL, 36.14387, -5.46006, 'address', 'openstreetmap:way/51368847'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-562518158', 'Carrefour Jerez de la Frontera – Avenida de la Universidad', NULL, '11020', 'Avenida de la Universidad', NULL, 36.68655, -6.11785, 'address', 'openstreetmap:way/562518158');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT c.categoria, ', ') INTO faltan FROM _carga c WHERE NOT EXISTS (SELECT 1 FROM public.categories k WHERE k.name = c.categoria);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan categorías: %', faltan;
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '11');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 11 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '11'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 54 THEN
    RAISE EXCEPTION 'Se esperaban 54 puntos de (varias) en Cádiz, hay %', n;
  END IF;
END;
$$;

COMMIT;
