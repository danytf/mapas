-- Carga de la categoría Correos de Girona (provincia 17), trozo de la carga de Andalucía.
-- Origen: postal_service-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 42 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cataluna:postal_service:node-10207027479', 'Correos la Cellera de Ter – Grup l''estel', NULL, '17189', 'Grup l''estel 8', '17165', 41.96701, 2.62202, 'address', 'openstreetmap:node/10207027479'),
  ('catalogo-cataluna:postal_service:node-10550631404', 'Correos Llagostera – Carrer de Pau Casals', NULL, '17089', 'Carrer de Pau Casals', '17240', 41.824, 2.89137, 'address', 'openstreetmap:node/10550631404'),
  ('catalogo-cataluna:postal_service:node-10725779229', 'Correos Castell d''Aro, Platja d''Aro i s''Agaró – Avinguda Platja d''Aro', NULL, '17048', 'Avinguda Platja d''Aro', NULL, 41.7967, 3.0481, 'address', 'openstreetmap:node/10725779229'),
  ('catalogo-cataluna:postal_service:node-10911716668', 'Correos Alp – Avinguda d''Alp', NULL, '17006', 'Avinguda d''Alp 4', '17537', 42.34533, 1.95557, 'address', 'openstreetmap:node/10911716668'),
  ('catalogo-cataluna:postal_service:node-11093340436', 'Correos Begur – Avinguda de l''Onze de Setembre', NULL, '17013', 'Avinguda de l''Onze de Setembre 3', '17255', 41.95374, 3.20652, 'address', 'openstreetmap:node/11093340436'),
  ('catalogo-cataluna:postal_service:node-11290204528', 'Correos Girona – Avinguda de Montilivi 10-8', NULL, '17079', 'Avinguda de Montilivi 10-8', '17003', 41.97162, 2.82456, 'address', 'openstreetmap:node/11290204528'),
  ('catalogo-cataluna:postal_service:node-14143068277', 'Correos Sant Joan les Fonts – GI-522 Carretera d''Olot a Castellfollit', NULL, '17185', 'GI-522 Carretera d''Olot a Castellfollit 53', '17857', 42.2121, 2.51096, 'address', 'openstreetmap:node/14143068277'),
  ('catalogo-cataluna:postal_service:node-1623713167', 'Correos Vilafant – Carrer de la Tramuntana', NULL, '17221', 'Carrer de la Tramuntana', NULL, 42.24933, 2.96028, 'address', 'openstreetmap:node/1623713167'),
  ('catalogo-cataluna:postal_service:node-1704324760', 'Correos Sant Joan de les Abadesses – Carrer Arxiver Mossèn Masdeu', NULL, '17167', 'Carrer Arxiver Mossèn Masdeu 2', '17860', 42.23356, 2.28723, 'address', 'openstreetmap:node/1704324760'),
  ('catalogo-cataluna:postal_service:node-1706159739', 'Correos Roses – Carrer de la Mainada', NULL, '17152', 'Carrer de la Mainada 28', '17480', 42.26622, 3.1752, 'address', 'openstreetmap:node/1706159739'),
  ('catalogo-cataluna:postal_service:node-1709793863', 'Correos Castelló d''Empúries – Carrer del Mestre Blanch', NULL, '17047', 'Carrer del Mestre Blanch 6', '17486', 42.25787, 3.07449, 'address', 'openstreetmap:node/1709793863'),
  ('catalogo-cataluna:postal_service:node-1793159705', 'Correos Palafrugell – Carrer de Barris i Buixó', NULL, '17117', 'Carrer de Barris i Buixó 7', '17200', 41.9156, 3.1683, 'address', 'openstreetmap:node/1793159705'),
  ('catalogo-cataluna:postal_service:node-1855968075', 'Correos Figueres – Carrer Santa Llogaia 60-62', NULL, '17066', 'Carrer Santa Llogaia 60-62', '17600', 42.26058, 2.9615, 'address', 'openstreetmap:node/1855968075'),
  ('catalogo-cataluna:postal_service:node-1905346934', 'Correos Santa Coloma de Farners – Carretera de Sant Hilari', NULL, '17180', 'Carretera de Sant Hilari', '17430', 41.86095, 2.66271, 'address', 'openstreetmap:node/1905346934'),
  ('catalogo-cataluna:postal_service:node-1998891022', 'Correos Portbou – Carrer de Méndez Núñez', NULL, '17138', 'Carrer de Méndez Núñez 2', '17497', 42.42601, 3.16002, 'address', 'openstreetmap:node/1998891022'),
  ('catalogo-cataluna:postal_service:node-2661477693', 'Correos Torroella de Montgrí – Carrer de Figueres', NULL, '17199', 'Carrer de Figueres', '17257', 42.04226, 3.1219, 'address', 'openstreetmap:node/2661477693'),
  ('catalogo-cataluna:postal_service:node-3671609125', 'Correos Palafrugell – Carrer d''August Pi i Sunyer', NULL, '17117', 'Carrer d''August Pi i Sunyer 6', '17210', 41.89006, 3.18437, 'address', 'openstreetmap:node/3671609125'),
  ('catalogo-cataluna:postal_service:node-4075613505', 'Correos Vilamalla – Carrer Borrassà', NULL, '17226', 'Carrer Borrassà', NULL, 42.21689, 2.96912, 'address', 'openstreetmap:node/4075613505'),
  ('catalogo-cataluna:postal_service:node-4276017932', 'Correos Arbúcies – Carrer Francesc Camprodon', NULL, '17009', 'Carrer Francesc Camprodon 79', '17401', 41.81516, 2.51707, 'address', 'openstreetmap:node/4276017932'),
  ('catalogo-cataluna:postal_service:node-4327113945', 'Correos el Port de la Selva – Carrer de l''Illa', NULL, '17140', 'Carrer de l''Illa 9', '17489', 42.33837, 3.20385, 'address', 'openstreetmap:node/4327113945'),
  ('catalogo-cataluna:postal_service:node-4410321325', 'Correos Lloret de Mar – Passatge de l''Oliva', NULL, '17095', 'Passatge de l''Oliva', '17310', 41.70138, 2.84468, 'address', 'openstreetmap:node/4410321325'),
  ('catalogo-cataluna:postal_service:node-4460859785', 'Correos l''Escala – Carrer del Pintor Joan Miró', NULL, '17062', 'Carrer del Pintor Joan Miró 2', '17130', 42.11814, 3.12925, 'address', 'openstreetmap:node/4460859785'),
  ('catalogo-cataluna:postal_service:node-4847794858', 'Correos Girona – Plaça de Salvador Dalí i Domènech', NULL, '17079', 'Plaça de Salvador Dalí i Domènech 1', '17003', 41.97131, 2.81462, 'address', 'openstreetmap:node/4847794858'),
  ('catalogo-cataluna:postal_service:node-4847794859', 'Correos Girona – Carrer de la Gerundense 1-3', NULL, '17079', 'Carrer de la Gerundense 1-3', '17005', 41.96386, 2.80357, 'address', 'openstreetmap:node/4847794859'),
  ('catalogo-cataluna:postal_service:node-4847794860', 'Correos Girona – Ronda de Ferran Puig', NULL, '17079', 'Ronda de Ferran Puig 17', '17001', 41.9836, 2.81804, 'address', 'openstreetmap:node/4847794860'),
  ('catalogo-cataluna:postal_service:node-5437219300', 'Correos Bordils', NULL, '17025', NULL, NULL, 42.03735, 2.9147, 'address', 'openstreetmap:node/5437219300'),
  ('catalogo-cataluna:postal_service:node-5536122960', 'Correos Torroella de Fluvià – Carrer de Torroella de Montgrí', NULL, '17198', 'Carrer de Torroella de Montgrí', NULL, 42.17473, 3.04093, 'address', 'openstreetmap:node/5536122960'),
  ('catalogo-cataluna:postal_service:node-5598723149', 'Correos Saus, Camallera i Llampaies – Carrer Banyoles', NULL, '17187', 'Carrer Banyoles 7', '17465', 42.12449, 2.96452, 'address', 'openstreetmap:node/5598723149'),
  ('catalogo-cataluna:postal_service:node-5774729673', 'Correos Vilopriu – plaça de Francesc Macià', NULL, '17232', 'plaça de Francesc Macià', NULL, 42.09913, 2.96486, 'address', 'openstreetmap:node/5774729673'),
  ('catalogo-cataluna:postal_service:node-5916463085', 'Correos la Bisbal d''Empordà – Avinguda de Prat de la Riba', NULL, '17022', 'Avinguda de Prat de la Riba 12', '17100', 41.95839, 3.03735, 'address', 'openstreetmap:node/5916463085'),
  ('catalogo-cataluna:postal_service:node-6312312985', 'Correos Anglès – Carrer Narcís Monturiol', NULL, '17008', 'Carrer Narcís Monturiol 3', '17160', 41.9574, 2.63671, 'address', 'openstreetmap:node/6312312985'),
  ('catalogo-cataluna:postal_service:node-6718196439', 'Correos Maçanet de Cabrenys – Carrer de la Paret Nova', NULL, '17102', 'Carrer de la Paret Nova', '17720', 42.38595, 2.75021, 'address', 'openstreetmap:node/6718196439'),
  ('catalogo-cataluna:postal_service:node-6749604153', 'Correos la Jonquera – Carrer Major', NULL, '17086', 'Carrer Major', NULL, 42.42165, 2.8719, 'address', 'openstreetmap:node/6749604153'),
  ('catalogo-cataluna:postal_service:node-6875269223', 'Correos Breda – Carrer de Sant Iscle', NULL, '17027', 'Carrer de Sant Iscle', '17400', 41.74789, 2.55729, 'address', 'openstreetmap:node/6875269223'),
  ('catalogo-cataluna:postal_service:node-7685677603', 'Correos Pals – Carrer de l''Enginyer Algarra', NULL, '17124', 'Carrer de l''Enginyer Algarra', '17256', 41.97111, 3.14894, 'address', 'openstreetmap:node/7685677603'),
  ('catalogo-cataluna:postal_service:node-8952111710', 'Correos Alp – Avinguda de la Tossa d''Alp', NULL, '17006', 'Avinguda de la Tossa d''Alp 6', '17538', 42.37369, 1.88752, 'address', 'openstreetmap:node/8952111710'),
  ('catalogo-cataluna:postal_service:node-9066234706', 'Correos Olot – Carrer Joaquim Vayreda', NULL, '17114', 'Carrer Joaquim Vayreda 6', '17800', 42.17981, 2.48867, 'address', 'openstreetmap:node/9066234706'),
  ('catalogo-cataluna:postal_service:node-9416095275', 'Correos Blanes – Plaça de la Solidaritat', NULL, '17023', 'Plaça de la Solidaritat 9', '17300', 41.67595, 2.79051, 'address', 'openstreetmap:node/9416095275'),
  ('catalogo-cataluna:postal_service:relation-1012034', 'Correos Girona – Avinguda de Ramon Folch', NULL, '17079', 'Avinguda de Ramon Folch 2', '17001', 41.98631, 2.82289, 'address', 'openstreetmap:relation/1012034'),
  ('catalogo-cataluna:postal_service:way-229638511', 'Correos Palamós – Avinguda de Catalunya 6-8', NULL, '17118', 'Avinguda de Catalunya 6-8', '17230', 41.85069, 3.12937, 'address', 'openstreetmap:way/229638511'),
  ('catalogo-cataluna:postal_service:way-312786294', 'Correos Banyoles – Carrer Llibertat', NULL, '17015', 'Carrer Llibertat 48', '17820', 42.11932, 2.76396, 'address', 'openstreetmap:way/312786294'),
  ('catalogo-cataluna:postal_service:way-355367133', 'Correos Llambilles – Passeig del Carrilet', NULL, '17090', 'Passeig del Carrilet', '17243', 41.92054, 2.84966, 'address', 'openstreetmap:way/355367133');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '17');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 17 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '17'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 42 THEN
    RAISE EXCEPTION 'Se esperaban 42 puntos de Correos en Girona, hay %', n;
  END IF;
END;
$$;

COMMIT;
