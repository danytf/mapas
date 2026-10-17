-- Reconcile the relational taxonomy with the 17 categories used by the map.
-- Legacy reference categories remain available but inactive; no establishment rows are rewritten.
BEGIN;

INSERT INTO public.categories (code, name, is_active) VALUES
  ('health_center', 'Centro de salud', true),
  ('shopping_center', 'Centro comercial', true),
  ('postal_service', 'Correos', true),
  ('hospital', 'Hospital', true),
  ('supermarket', 'Supermercado', true),
  ('bricolaje', 'Bricolaje', true),
  ('carrefour', 'Carrefour', true),
  ('decathlon', 'Decathlon', true),
  ('el-corte-ingles', 'El Corte Inglés', true),
  ('entidad-oficial', 'Entidad oficial', true),
  ('estaciones', 'Estaciones', true),
  ('eventos', 'Eventos', true),
  ('gimnasios', 'Gimnasios', true),
  ('ikea', 'IKEA', true),
  ('leroy-merlin', 'Leroy Merlin', true),
  ('mediamarkt', 'MediaMarkt', true),
  ('tiendas', 'Tiendas', true)
ON CONFLICT (code) DO UPDATE
SET name = EXCLUDED.name,
    is_active = true,
    updated_at = now();

UPDATE public.categories
SET is_active = false,
    updated_at = now()
WHERE code IN (
  'tax_agency', 'town_hall', 'clinic', 'consultorio', 'sports_center',
  'large_retail', 'courts', 'public_office', 'other', 'social_security',
  'traffic_authority'
);

COMMIT;
