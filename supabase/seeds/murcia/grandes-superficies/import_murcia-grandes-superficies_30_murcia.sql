-- Carga de la categoría (varias) de Murcia (provincia 30), trozo de la carga de Andalucía.
-- Origen: murcia-grandes-superficies-murcia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:36Z).
-- 31 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Decathlon', 'catalogo-murcia:murcia-grandes-superficies:node-10267136259', 'Decathlon San Javier – Avenida del Pinatar', NULL, '30035', 'Avenida del Pinatar', NULL, 37.82085, -0.81532, 'address', 'openstreetmap:node/10267136259'),
  ('Leroy Merlin', 'catalogo-murcia:murcia-grandes-superficies:node-10660894069', 'Leroy Merlin San Pedro del Pinatar', NULL, '30036', NULL, NULL, 37.82248, -0.80885, 'address', 'openstreetmap:node/10660894069'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-1109085931', 'Carrefour Águilas – Calle Andrés Segovia', NULL, '30003', 'Calle Andrés Segovia 10', '30880', 37.41154, -1.56409, 'address', 'openstreetmap:node/1109085931'),
  ('Leroy Merlin', 'catalogo-murcia:murcia-grandes-superficies:node-11371406089', 'Leroy Merlin Lorca', NULL, '30024', NULL, NULL, 37.63768, -1.69869, 'address', 'openstreetmap:node/11371406089'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-1389767573', 'Carrefour San Javier', NULL, '30035', NULL, NULL, 37.81987, -0.81276, 'address', 'openstreetmap:node/1389767573'),
  ('El Corte Inglés', 'catalogo-murcia:murcia-grandes-superficies:node-1531810210', 'El Corte Inglés Murcia – Gran Vía Escultor Francisco Salzillo', NULL, '30030', 'Gran Vía Escultor Francisco Salzillo 32', '30005', 37.98851, -1.13194, 'address', 'openstreetmap:node/1531810210'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-2329292750', 'Carrefour Cartagena – Calle Londres', NULL, '30016', 'Calle Londres', NULL, 37.62539, -0.9478, 'address', 'openstreetmap:node/2329292750'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-313491751', 'Carrefour Murcia – Avenida Lope de Vega', NULL, '30030', 'Avenida Lope de Vega', '30011', 37.98063, -1.11231, 'address', 'openstreetmap:node/313491751'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-3743429309', 'Carrefour Cartagena – Calle Puerta de Murcia', NULL, '30016', 'Calle Puerta de Murcia 8', '30201', 37.60212, -0.98725, 'address', 'openstreetmap:node/3743429309'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-4633441792', 'Carrefour Murcia – Ronda de Garay', NULL, '30030', 'Ronda de Garay 10', '30003', 37.98409, -1.12224, 'address', 'openstreetmap:node/4633441792'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-617137186', 'Carrefour Cartagena – Paseo de Alfonso XIII', NULL, '30016', 'Paseo de Alfonso XIII', NULL, 37.60772, -0.97528, 'address', 'openstreetmap:node/617137186'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-6355784974', 'Carrefour Murcia – Calle José Antonio Ponzoa', NULL, '30030', 'Calle José Antonio Ponzoa', '30004', 37.9872, -1.13123, 'address', 'openstreetmap:node/6355784974'),
  ('Decathlon', 'catalogo-murcia:murcia-grandes-superficies:node-672832149', 'Decathlon Murcia – Calle Manueles', NULL, '30030', 'Calle Manueles', NULL, 37.95667, -1.21777, 'address', 'openstreetmap:node/672832149'),
  ('MediaMarkt', 'catalogo-murcia:murcia-grandes-superficies:node-691584072', 'MediaMarkt Murcia – Avenida de Los Dolores', NULL, '30030', 'Avenida de Los Dolores', '30011', 37.97618, -1.11363, 'address', 'openstreetmap:node/691584072'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-7172943535', 'Carrefour Murcia – Calle Molina de Segura', NULL, '30030', 'Calle Molina de Segura 10', '30007', 37.99145, -1.11264, 'address', 'openstreetmap:node/7172943535'),
  ('Decathlon', 'catalogo-murcia:murcia-grandes-superficies:node-778670455', 'Decathlon Murcia – Avenida Princesa Doña Letizia', NULL, '30030', 'Avenida Princesa Doña Letizia', NULL, 38.03218, -1.14782, 'address', 'openstreetmap:node/778670455'),
  ('MediaMarkt', 'catalogo-murcia:murcia-grandes-superficies:node-779951398', 'MediaMarkt Murcia', NULL, '30030', NULL, NULL, 38.04285, -1.1499, 'address', 'openstreetmap:node/779951398'),
  ('Leroy Merlin', 'catalogo-murcia:murcia-grandes-superficies:node-780172124', 'Leroy Merlin Murcia – Avenida Nueva Condomina', NULL, '30030', 'Avenida Nueva Condomina', NULL, 38.03817, -1.15174, 'address', 'openstreetmap:node/780172124'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-7882196214', 'Carrefour Lorca', NULL, '30024', NULL, NULL, 37.6343, -1.70016, 'address', 'openstreetmap:node/7882196214'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:node-811067372', 'Carrefour Murcia – Calle Pintor Molina Sánchez', NULL, '30030', 'Calle Pintor Molina Sánchez', '30009', 38.00158, -1.14217, 'address', 'openstreetmap:node/811067372'),
  ('Leroy Merlin', 'catalogo-murcia:murcia-grandes-superficies:relation-9383038', 'Leroy Merlin Murcia – Camino de la Paloma', NULL, '30030', 'Camino de la Paloma 25', '30150', 37.93825, -1.15025, 'address', 'openstreetmap:relation/9383038'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:way-1122684609', 'Carrefour Fuente Álamo de Murcia – CALLE ESPINA, S/N', NULL, '30021', 'CALLE ESPINA, S/N', '30320', 37.72376, -1.16496, 'address', 'openstreetmap:way/1122684609'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:way-136786563', 'Carrefour Murcia – CARRETERA N-301A KM 395.000', NULL, '30030', 'CARRETERA N-301A KM 395.000', '30152', 37.94944, -1.1567, 'address', 'openstreetmap:way/136786563'),
  ('Decathlon', 'catalogo-murcia:murcia-grandes-superficies:way-146412198', 'Decathlon Águilas', NULL, '30003', NULL, NULL, 37.4176, -1.56044, 'address', 'openstreetmap:way/146412198'),
  ('Decathlon', 'catalogo-murcia:murcia-grandes-superficies:way-24341283', 'Decathlon Cartagena – Calle Riga', NULL, '30016', 'Calle Riga', NULL, 37.62274, -0.94947, 'address', 'openstreetmap:way/24341283'),
  ('El Corte Inglés', 'catalogo-murcia:murcia-grandes-superficies:way-48960439', 'El Corte Inglés Cartagena – Calle Almirante Baldasano', NULL, '30016', 'Calle Almirante Baldasano', '30205', 37.61404, -0.99378, 'address', 'openstreetmap:way/48960439'),
  ('El Corte Inglés', 'catalogo-murcia:murcia-grandes-superficies:way-553710033', 'El Corte Inglés Murcia – Avenida de la Libertad', NULL, '30030', 'Avenida de la Libertad 1', '30009', 37.98959, -1.13391, 'address', 'openstreetmap:way/553710033'),
  ('MediaMarkt', 'catalogo-murcia:murcia-grandes-superficies:way-57816969', 'MediaMarkt Cartagena – Calle Budapest', NULL, '30016', 'Calle Budapest', '30353', 37.62506, -0.95205, 'address', 'openstreetmap:way/57816969'),
  ('Leroy Merlin', 'catalogo-murcia:murcia-grandes-superficies:way-57816985', 'Leroy Merlin Cartagena – Calle Londres', NULL, '30016', 'Calle Londres', NULL, 37.6242, -0.94785, 'address', 'openstreetmap:way/57816985'),
  ('IKEA', 'catalogo-murcia:murcia-grandes-superficies:way-62329201', 'IKEA Murcia – Avenida Xarrat', NULL, '30030', 'Avenida Xarrat', NULL, 38.02746, -1.14549, 'address', 'openstreetmap:way/62329201'),
  ('Carrefour', 'catalogo-murcia:murcia-grandes-superficies:way-790671984', 'Carrefour Murcia – Calle Llanos', NULL, '30030', 'Calle Llanos', '30002', 37.97668, -1.13356, 'address', 'openstreetmap:way/790671984');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '30');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 30 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '30'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 31 THEN
    RAISE EXCEPTION 'Se esperaban 31 puntos de (varias) en Murcia, hay %', n;
  END IF;
END;
$$;

COMMIT;
