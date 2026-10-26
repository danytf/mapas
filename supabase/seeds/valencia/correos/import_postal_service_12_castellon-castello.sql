-- Carga de la categoría Correos de Castellón/Castelló (provincia 12), trozo de la carga de Andalucía.
-- Origen: postal_service-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 26 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-valencia:postal_service:node-11101145481', 'Correos Llucena / Lucena del Cid – Carrer de la Solana', NULL, '12072', 'Carrer de la Solana', NULL, 40.13798, -0.28009, 'address', 'openstreetmap:node/11101145481'),
  ('catalogo-valencia:postal_service:node-11930170656', 'Correos Vinaròs – avinguda del País Valencià', NULL, '12138', 'avinguda del País Valencià 2', '12500', 40.46733, 0.4753, 'address', 'openstreetmap:node/11930170656'),
  ('catalogo-valencia:postal_service:node-1241169604', 'Correos Vilafranca / Villafranca del Cid – Avinguda de Castelló', NULL, '12129', 'Avinguda de Castelló 28', '12150', 40.42796, -0.25645, 'address', 'openstreetmap:node/1241169604'),
  ('catalogo-valencia:postal_service:node-12596059594', 'Correos Catí – Carrer Major', NULL, '12042', 'Carrer Major 6', '12513', 40.47118, 0.0226, 'address', 'openstreetmap:node/12596059594'),
  ('catalogo-valencia:postal_service:node-13190423656', 'Correos Moncofa – Carrer de la Trinitat', NULL, '12077', 'Carrer de la Trinitat 41', '12593', 39.80748, -0.14276, 'address', 'openstreetmap:node/13190423656'),
  ('catalogo-valencia:postal_service:node-1769819490', 'Correos Almassora – Plaça d''Espanya', NULL, '12009', 'Plaça d''Espanya 2', '12550', 39.94515, -0.06304, 'address', 'openstreetmap:node/1769819490'),
  ('catalogo-valencia:postal_service:node-2000214171', 'Correos Betxí – Avinguda del Primer de Maig', NULL, '12021', 'Avinguda del Primer de Maig', NULL, 39.92478, -0.19684, 'address', 'openstreetmap:node/2000214171'),
  ('catalogo-valencia:postal_service:node-2087854220', 'Correos Castelló de la Plana / Castellón de la Plana – Carrer de Vázquez Mella', NULL, '12040', 'Carrer de Vázquez Mella 55', '12006', 39.97897, -0.04482, 'address', 'openstreetmap:node/2087854220'),
  ('catalogo-valencia:postal_service:node-2195134256', 'Correos Viver – Plaza Mayor del Palancia', NULL, '12140', 'Plaza Mayor del Palancia 2', '12460', 39.92116, -0.59577, 'address', 'openstreetmap:node/2195134256'),
  ('catalogo-valencia:postal_service:node-2314905030', 'Correos Alcalà de Xivert – Passeig Herois del Marroc', NULL, '12004', 'Passeig Herois del Marroc 72', '12570', 40.30247, 0.22615, 'address', 'openstreetmap:node/2314905030'),
  ('catalogo-valencia:postal_service:node-2454478137', 'Correos Vinaròs – Avenida del País Valenciano', NULL, '12138', 'Avenida del País Valenciano 36', '12500', 40.4688, 0.47384, 'address', 'openstreetmap:node/2454478137'),
  ('catalogo-valencia:postal_service:node-2868929256', 'Correos Benassal – Carrer Major', NULL, '12026', 'Carrer Major', '12160', 40.37957, -0.14301, 'address', 'openstreetmap:node/2868929256'),
  ('catalogo-valencia:postal_service:node-3013328854', 'Correos Peníscola / Peñíscola – Carrer de Blasco Ibáñez', NULL, '12089', 'Carrer de Blasco Ibáñez 7', '12598', 40.36148, 0.39924, 'address', 'openstreetmap:node/3013328854'),
  ('catalogo-valencia:postal_service:node-3022848555', 'Correos Vilanova d''Alcolea – Carrer del Calvari', NULL, '12132', 'Carrer del Calvari', NULL, 40.23088, 0.07121, 'address', 'openstreetmap:node/3022848555'),
  ('catalogo-valencia:postal_service:node-3759236346', 'Correos Alcalà de Xivert – Avinguda de València', NULL, '12004', 'Avinguda de València 39', '12579', 40.2456, 0.27606, 'address', 'openstreetmap:node/3759236346'),
  ('catalogo-valencia:postal_service:node-4352241990', 'Correos Altura – Calle Cervantes', NULL, '12012', 'Calle Cervantes', NULL, 39.85067, -0.51418, 'address', 'openstreetmap:node/4352241990'),
  ('catalogo-valencia:postal_service:node-4396229168', 'Correos Vall d''Alba – Plaça Major', NULL, '12124', 'Plaça Major', NULL, 40.17626, -0.03587, 'address', 'openstreetmap:node/4396229168'),
  ('catalogo-valencia:postal_service:node-4586164299', 'Correos Nules – Carrer Beránger', NULL, '12082', 'Carrer Beránger 14', '12520', 39.85404, -0.15444, 'address', 'openstreetmap:node/4586164299'),
  ('catalogo-valencia:postal_service:node-602819835', 'Correos Onda – Carrer de Lope de Vega', NULL, '12084', 'Carrer de Lope de Vega', '12200', 39.96299, -0.26625, 'address', 'openstreetmap:node/602819835'),
  ('catalogo-valencia:postal_service:node-6779221610', 'Correos Castelló de la Plana / Castellón de la Plana – Carrer del Degà Martí 1-7', NULL, '12040', 'Carrer del Degà Martí 1-7', NULL, 39.98956, -0.042, 'address', 'openstreetmap:node/6779221610'),
  ('catalogo-valencia:postal_service:node-6831008414', 'Correos Benicarló – Passeig d''En José Febrer i Soriano', NULL, '12027', 'Passeig d''En José Febrer i Soriano 1', '12580', 40.41976, 0.42408, 'address', 'openstreetmap:node/6831008414'),
  ('catalogo-valencia:postal_service:node-7277177084', 'Correos Castelló de la Plana / Castellón de la Plana – Carrer de Serrano Lloberes', NULL, '12040', 'Carrer de Serrano Lloberes', '12100', 39.97512, 0.01495, 'address', 'openstreetmap:node/7277177084'),
  ('catalogo-valencia:postal_service:way-166699330', 'Correos Almenara – Carrer de la Cisterna', NULL, '12011', 'Carrer de la Cisterna', NULL, 39.75259, -0.22697, 'address', 'openstreetmap:way/166699330'),
  ('catalogo-valencia:postal_service:way-38040304', 'Correos Borriana / Burriana – Carrer Major', NULL, '12032', 'Carrer Major 1', '12530', 39.89018, -0.08381, 'address', 'openstreetmap:way/38040304'),
  ('catalogo-valencia:postal_service:way-55606616', 'Correos Cabanes – Carrer Hospital', NULL, '12033', 'Carrer Hospital 9', '12180', 40.15613, 0.04456, 'address', 'openstreetmap:way/55606616'),
  ('catalogo-valencia:postal_service:way-668565618', 'Correos Vila-real – Carrer de Vilanova i la Geltrú', NULL, '12135', 'Carrer de Vilanova i la Geltrú', NULL, 39.94272, -0.10737, 'address', 'openstreetmap:way/668565618');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '12');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 12 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '12'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 26 THEN
    RAISE EXCEPTION 'Se esperaban 26 puntos de Correos en Castellón/Castelló, hay %', n;
  END IF;
END;
$$;

COMMIT;
