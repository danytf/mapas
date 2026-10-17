-- Restrict direct table privileges for the Supabase API role.
-- Row-level security remains responsible for deciding which rows are accessible.
-- Audit and location history are written by SECURITY DEFINER triggers, not by clients.

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
FROM authenticated;

GRANT SELECT ON TABLE
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
TO authenticated;

GRANT INSERT, UPDATE, DELETE ON TABLE
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
    public.import_batches,
    public.import_records
TO authenticated;

COMMIT;
