-- Carga de la categoría (varias) de Málaga (provincia 29), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 19 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-10212491919', 'Decathlon Málaga – Avenida Simón Bolivar', NULL, '29067', 'Avenida Simón Bolivar', '29011', 36.73452, -4.4313, 'address', 'openstreetmap:node/10212491919'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-11780187569', 'El Corte Inglés Málaga – Calle Obispo Ramón Buxarrais', NULL, '29067', 'Calle Obispo Ramón Buxarrais', NULL, 36.70877, -4.46018, 'address', 'openstreetmap:node/11780187569'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-2610845638', 'Decathlon Málaga – Calle Strachan', NULL, '29067', 'Calle Strachan 3', '29015', 36.71982, -4.42117, 'address', 'openstreetmap:node/2610845638'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-2802575515', 'Decathlon Mijas – Avenida María Sáenz de Tejada', NULL, '29070', 'Avenida María Sáenz de Tejada', '29651', 36.53552, -4.63562, 'address', 'openstreetmap:node/2802575515'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-2802575517', 'MediaMarkt Mijas – Calle Alfarante', NULL, '29070', 'Calle Alfarante', NULL, 36.53639, -4.63632, 'address', 'openstreetmap:node/2802575517'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-2856304578', 'El Corte Inglés Torremolinos – Calle Canadá', NULL, '29901', 'Calle Canadá', NULL, 36.63271, -4.49884, 'address', 'openstreetmap:node/2856304578'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-2952735540', 'El Corte Inglés Fuengirola – Avenida Nuestro Padre Jesús Cautivo', NULL, '29054', 'Avenida Nuestro Padre Jesús Cautivo', NULL, 36.55501, -4.61471, 'address', 'openstreetmap:node/2952735540'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-3361908105', 'MediaMarkt Málaga – Calle Héroe de Sostoa', NULL, '29067', 'Calle Héroe de Sostoa', NULL, 36.71121, -4.43156, 'address', 'openstreetmap:node/3361908105'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-5693245187', 'MediaMarkt Málaga – Calle Alfonso Ponce de León', NULL, '29067', 'Calle Alfonso Ponce de León', NULL, 36.65548, -4.4794, 'address', 'openstreetmap:node/5693245187'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:node-6715434071', 'Leroy Merlin Mijas – Calle Alfarante', NULL, '29070', 'Calle Alfarante', NULL, 36.53567, -4.63617, 'address', 'openstreetmap:node/6715434071'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-9282711229', 'Decathlon Ronda – Calle Juan José de Puya', NULL, '29084', 'Calle Juan José de Puya', NULL, 36.74383, -5.1634, 'address', 'openstreetmap:node/9282711229'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:relation-10628189', 'El Corte Inglés Málaga – Avenida Andalucía 4-6', NULL, '29067', 'Avenida Andalucía 4-6', '29002', 36.71749, -4.42828, 'address', 'openstreetmap:relation/10628189'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-223533686', 'Leroy Merlin Málaga – Camino Loma de San Julián', NULL, '29067', 'Camino Loma de San Julián', NULL, 36.66747, -4.46871, 'address', 'openstreetmap:way/223533686'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-277236606', 'Decathlon Málaga – Camino Loma de San Julián', NULL, '29067', 'Camino Loma de San Julián', '29004', 36.66787, -4.47015, 'address', 'openstreetmap:way/277236606'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-322625755', 'Leroy Merlin Marbella', NULL, '29069', NULL, NULL, 36.52194, -4.87685, 'address', 'openstreetmap:way/322625755'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-390615156', 'El Corte Inglés Marbella – Bulevar del Príncipe Alfonso de Hohenlohe', NULL, '29069', 'Bulevar del Príncipe Alfonso de Hohenlohe', NULL, 36.5108, -4.90304, 'address', 'openstreetmap:way/390615156'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:way-607957106', 'MediaMarkt Marbella', NULL, '29069', NULL, NULL, 36.52231, -4.87788, 'address', 'openstreetmap:way/607957106'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:way-78609629', 'IKEA Málaga – Avenida de Velázquez', NULL, '29067', 'Avenida de Velázquez 389', '29004', 36.65777, -4.4823, 'address', 'openstreetmap:way/78609629'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-89973352', 'El Corte Inglés Marbella – Calle Ramón Areces', NULL, '29069', 'Calle Ramón Areces', NULL, 36.49073, -4.95262, 'address', 'openstreetmap:way/89973352');

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
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 19 THEN
    RAISE EXCEPTION 'Se esperaban 19 puntos de (varias) en Málaga, hay %', n;
  END IF;
END;
$$;

COMMIT;
