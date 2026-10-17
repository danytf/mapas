-- Remove direct EXECUTE grants from authenticated users on internal trigger
-- and event-trigger functions. PostgreSQL does not require callers to have
-- EXECUTE on a trigger function when its trigger fires.
BEGIN;

REVOKE EXECUTE ON FUNCTION public.guard_sensitive_updates() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.handle_new_auth_user() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.prevent_application_reassignment_conflicts() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.prevent_grant_reassignment_conflicts() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.prevent_municipality_reassignment_conflicts() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.record_establishment_location_history() FROM authenticated;
DO $migration$
BEGIN
  IF to_regprocedure('public.rls_auto_enable()') IS NOT NULL THEN
    EXECUTE 'REVOKE EXECUTE ON FUNCTION public.rls_auto_enable() FROM authenticated';
  END IF;
END
$migration$;
REVOKE EXECUTE ON FUNCTION public.set_updated_at() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.validate_establishment_municipality_province() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.validate_followup_targets() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.validate_permit_grant_application() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.write_audit_log() FROM authenticated;

COMMIT;
