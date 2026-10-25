-- Carga de la categoría (varias) de Navarra (provincia 31), trozo de la carga de Andalucía.
-- Origen: navarra-grandes-superficies-navarra.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 37 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Decathlon', 'catalogo-navarra:navarra-grandes-superficies:node-10701741114', 'Decathlon Pamplona / Iruña – Calle Emilio Arrieta', NULL, '31201', 'Calle Emilio Arrieta 2', '31002', 42.81475, -1.63987, 'address', 'openstreetmap:node/10701741114'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11229979538', 'Carrefour Huarte / Uharte – Calle Zubiarte', NULL, '31122', 'Calle Zubiarte 24', '31620', 42.83178, -1.58956, 'address', 'openstreetmap:node/11229979538'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11367255169', 'Carrefour Pamplona / Iruña – Calle Abejeras 8-10', NULL, '31201', 'Calle Abejeras 8-10', '31007', 42.80741, -1.64526, 'address', 'openstreetmap:node/11367255169'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11367264569', 'Carrefour Pamplona / Iruña – Calle Leyre', NULL, '31201', 'Calle Leyre 14', '31002', 42.814, -1.63955, 'address', 'openstreetmap:node/11367264569'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11367273669', 'Carrefour Pamplona / Iruña – Calle Iturrama', NULL, '31201', 'Calle Iturrama 4', '31006', 42.8041, -1.64977, 'address', 'openstreetmap:node/11367273669'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11367279869', 'Carrefour Pamplona / Iruña – Calle Padre Tomás Esteban', NULL, '31201', 'Calle Padre Tomás Esteban 2', '31008', 42.8105, -1.65854, 'address', 'openstreetmap:node/11367279869'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11367285869', 'Carrefour Pamplona / Iruña – Calle Iturrama', NULL, '31201', 'Calle Iturrama 43', '31007', 42.80609, -1.65637, 'address', 'openstreetmap:node/11367285869'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11367288369', 'Carrefour Pamplona / Iruña – Paseo Anelier', NULL, '31201', 'Paseo Anelier 5', '31014', 42.82262, -1.64854, 'address', 'openstreetmap:node/11367288369'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11367294069', 'Carrefour Pamplona / Iruña – Calle Cataluña 2-4', NULL, '31201', 'Calle Cataluña 2-4', '31006', 42.80725, -1.62671, 'address', 'openstreetmap:node/11367294069'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11367298669', 'Carrefour Pamplona / Iruña – Avenida de Guipúzcoa', NULL, '31201', 'Avenida de Guipúzcoa 1', '31014', 42.82038, -1.65571, 'address', 'openstreetmap:node/11367298669'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-11370975669', 'Carrefour Pamplona / Iruña – Paseo Donantes de Sangre', NULL, '31201', 'Paseo Donantes de Sangre 21', '31015', 42.83552, -1.62862, 'address', 'openstreetmap:node/11370975669'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-12009219746', 'Carrefour Aoiz / Agoitz – Urbanización Barajitoa', NULL, '31019', 'Urbanización Barajitoa', '31430', 42.78333, -1.37393, 'address', 'openstreetmap:node/12009219746'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-12065140769', 'Carrefour Ansoáin / Antsoain – Calle Hermanos Noáin', NULL, '31016', 'Calle Hermanos Noáin 3', '31013', 42.83313, -1.64219, 'address', 'openstreetmap:node/12065140769'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-12065140869', 'Carrefour Galar – Calle B', NULL, '31109', 'Calle B 2', '31191', 42.78972, -1.63971, 'address', 'openstreetmap:node/12065140869'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-12065140969', 'Carrefour Beriáin – Polígono de Beriain', NULL, '31905', 'Polígono de Beriain', '31191', 42.73614, -1.63317, 'address', 'openstreetmap:node/12065140969'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-12065141069', 'Carrefour Beriáin – CRTA PAMPLONA-ZARAGOZA km 9.4', NULL, '31905', 'CRTA PAMPLONA-ZARAGOZA km 9.4', NULL, 42.73458, -1.63363, 'address', 'openstreetmap:node/12065141069'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-12278125589', 'Carrefour Estella-Lizarra – Paseo de la Inmaculada', NULL, '31097', 'Paseo de la Inmaculada 64', '31200', 42.6719, -2.03386, 'address', 'openstreetmap:node/12278125589'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-13107772240', 'Carrefour Larraun – AUTOVIA A-15 (MRG.DCHO.) KM 134.4', NULL, '31144', 'AUTOVIA A-15 (MRG.DCHO.) KM 134.4', NULL, 43.05874, -1.95591, 'address', 'openstreetmap:node/13107772240'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-13290555298', 'Carrefour Pamplona / Iruña – Avenida de Zaragoza', NULL, '31201', 'Avenida de Zaragoza 69', '31006', 42.80306, -1.64394, 'address', 'openstreetmap:node/13290555298'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-14099788587', 'Carrefour Atetz – Junto al Camping Izarpe', NULL, '31040', 'Junto al Camping Izarpe', '31867', 42.93789, -1.69244, 'address', 'openstreetmap:node/14099788587'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-3018398836', 'Carrefour Pamplona / Iruña – Calle Mayor', NULL, '31201', 'Calle Mayor 49', '31001', 42.81765, -1.64679, 'address', 'openstreetmap:node/3018398836'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-5221766583', 'Carrefour Pamplona / Iruña – Calle Tudela', NULL, '31201', 'Calle Tudela 13', '31003', 42.81229, -1.64394, 'address', 'openstreetmap:node/5221766583'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-6863080798', 'Carrefour Pamplona / Iruña – Calle Sancho Ramírez', NULL, '31201', 'Calle Sancho Ramírez 2', '31008', 42.80688, -1.66161, 'address', 'openstreetmap:node/6863080798'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-8996668155', 'Carrefour Aribe – Santa Maria karrika', NULL, '31034', 'Santa Maria karrika', NULL, 42.94471, -1.26414, 'address', 'openstreetmap:node/8996668155'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-9180660096', 'Carrefour Pamplona / Iruña – Avenida de Bayona', NULL, '31201', 'Avenida de Bayona 2', '31011', 42.81532, -1.65567, 'address', 'openstreetmap:node/9180660096'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-9428177195', 'Carrefour Burlada / Burlata – Calle Mayor 62-64', NULL, '31060', 'Calle Mayor 62-64', '31600', 42.82719, -1.61392, 'address', 'openstreetmap:node/9428177195'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:node-9874842651', 'Carrefour Pamplona / Iruña – Calle Estafeta', NULL, '31201', 'Calle Estafeta 1', '31001', 42.81843, -1.64291, 'address', 'openstreetmap:node/9874842651'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:way-1076014870', 'Carrefour Caparroso – N-121', NULL, '31065', 'N-121', '31380', 42.34665, -1.65359, 'address', 'openstreetmap:way/1076014870'),
  ('Decathlon', 'catalogo-navarra:navarra-grandes-superficies:way-118936862', 'Decathlon Estella-Lizarra – Calle de Carlos VII', NULL, '31097', 'Calle de Carlos VII', NULL, 42.66177, -2.03252, 'address', 'openstreetmap:way/118936862'),
  ('MediaMarkt', 'catalogo-navarra:navarra-grandes-superficies:way-127632229', 'MediaMarkt Galar – Calle U', NULL, '31109', 'Calle U 2', '31191', 42.78829, -1.63394, 'address', 'openstreetmap:way/127632229'),
  ('Leroy Merlin', 'catalogo-navarra:navarra-grandes-superficies:way-1309095421', 'Leroy Merlin Tudela – Carretera Tudela - Fitero', NULL, '31232', 'Carretera Tudela - Fitero', NULL, 42.05877, -1.63127, 'address', 'openstreetmap:way/1309095421'),
  ('IKEA', 'catalogo-navarra:navarra-grandes-superficies:way-164392563', 'IKEA Galar – Calle T', NULL, '31109', 'Calle T 3', '31191', 42.78729, -1.63477, 'address', 'openstreetmap:way/164392563'),
  ('Decathlon', 'catalogo-navarra:navarra-grandes-superficies:way-183111935', 'Decathlon Berriozar – Calle Auzalor kalea', NULL, '31903', 'Calle Auzalor kalea', NULL, 42.83223, -1.66895, 'address', 'openstreetmap:way/183111935'),
  ('El Corte Inglés', 'catalogo-navarra:navarra-grandes-superficies:way-28499176', 'El Corte Inglés Pamplona / Iruña – Calle Estella', NULL, '31201', 'Calle Estella 9', '31002', 42.81369, -1.6453, 'address', 'openstreetmap:way/28499176'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:way-296945596', 'Carrefour Pamplona / Iruña – Plaza de Julio Altadill plaza', NULL, '31201', 'Plaza de Julio Altadill plaza', '31008', 42.8064, -1.67332, 'address', 'openstreetmap:way/296945596'),
  ('Carrefour', 'catalogo-navarra:navarra-grandes-superficies:way-90866559', 'Carrefour Tudela', NULL, '31232', NULL, '31500', 42.04312, -1.62101, 'address', 'openstreetmap:way/90866559'),
  ('Leroy Merlin', 'catalogo-navarra:navarra-grandes-superficies:way-94089895', 'Leroy Merlin Galar – Calle X kalea', NULL, '31109', 'Calle X kalea', '31192', 42.7864, -1.63068, 'address', 'openstreetmap:way/94089895');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '31');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 31 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '31'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 37 THEN
    RAISE EXCEPTION 'Se esperaban 37 puntos de (varias) en Navarra, hay %', n;
  END IF;
END;
$$;

COMMIT;
