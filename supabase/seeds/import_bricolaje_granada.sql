-- Carga de la categoría Bricolaje de Granada (grandes cadenas distintas de Leroy Merlin).
-- Origen: supabase/seeds/bricolaje-granada.json (OpenStreetMap, ODbL, consulta del 19/10/2026).
-- Una fila: Brico Dépôt de Pulianas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- Transaccional: si falta la provincia, el municipio o la categoría, aborta sin cambios.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.provinces WHERE code = '18' AND name = 'Granada') THEN
    RAISE EXCEPTION 'Falta la provincia Granada (código 18).';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'bricolaje' AND name = 'Bricolaje') THEN
    RAISE EXCEPTION 'Falta la categoría Bricolaje.';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
    WHERE p.code = '18' AND m.normalized_name = 'pulianas'
  ) THEN
    RAISE EXCEPTION 'Falta el municipio Pulianas en Granada.';
  END IF;
END;
$$;

INSERT INTO public.establishments (
  province_id, municipality_id, category_id,
  name, normalized_name, subtype, address, postal_code,
  latitude, longitude, location_precision, location_source,
  source_ref, status
)
SELECT p.id, m.id, c.id,
       'Brico Dépôt Pulianas – Calle de Orson Welles',
       lower(trim('Brico Dépôt Pulianas – Calle de Orson Welles')),
       NULL, 'Calle de Orson Welles', '18197',
       37.21284, -3.62294, 'address', 'openstreetmap:way/311295370',
       'catalogo-granada:bricolaje:brico-depot-pulianas-calle-de-orson-welles:pulianas:calle-de-orson-welles',
       'active'
FROM public.provinces p
JOIN public.municipalities m ON m.province_id = p.id AND m.normalized_name = 'pulianas'
JOIN public.categories c ON c.code = 'bricolaje'
WHERE p.code = '18'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e JOIN public.categories c ON c.id = e.category_id
  WHERE c.code = 'bricolaje' AND e.source_ref LIKE 'catalogo-granada:bricolaje:%';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Se esperaba 1 punto de Bricolaje, hay %', n;
  END IF;
END;
$$;

COMMIT;
