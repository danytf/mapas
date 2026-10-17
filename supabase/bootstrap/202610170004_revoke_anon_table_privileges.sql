-- Remove unintended direct table privileges from anonymous API clients.
-- Keep authenticated privileges unchanged; RLS policies continue to scope rows.
-- Audit and location-history tables remain writable only through trusted triggers.

BEGIN;

REVOKE ALL PRIVILEGES ON TABLE
    public.provinces,
    public.profiles,
    public.user_provinces,
    public.municipalities,
    public.categories,
    public.establishments,
    public.permit_applications,
    public.permit_grants,
    public.followups,
    public.establishment_location_reviews,
    public.establishment_location_history,
    public.audit_log,
    public.import_batches,
    public.import_records
FROM anon, PUBLIC;

COMMIT;
