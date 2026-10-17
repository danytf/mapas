-- Seed the province required for the static Granada catalogue import.
-- Idempotent: safe to apply repeatedly. Does not touch establishments or test rows.

BEGIN;

INSERT INTO public.provinces (code, name, is_active)
VALUES ('18', 'Granada', true)
ON CONFLICT (code) DO UPDATE
SET name = EXCLUDED.name,
    is_active = true,
    updated_at = now();

COMMIT;
