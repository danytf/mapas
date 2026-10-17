-- Restrict direct execution of public-schema functions.
-- Authorization helpers used by RLS remain executable by authenticated users.
-- Trigger/event-trigger functions are invoked by PostgreSQL, not by direct client RPC.

BEGIN;

REVOKE EXECUTE ON FUNCTION public.can_access_establishment(uuid) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.guard_sensitive_updates() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.handle_new_auth_user() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.has_province_access(uuid) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.is_admin() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.prevent_application_reassignment_conflicts() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.prevent_grant_reassignment_conflicts() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.prevent_municipality_reassignment_conflicts() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.record_establishment_location_history() FROM PUBLIC, anon;
DO $migration$
BEGIN
  IF to_regprocedure('public.rls_auto_enable()') IS NOT NULL THEN
    EXECUTE 'REVOKE EXECUTE ON FUNCTION public.rls_auto_enable() FROM PUBLIC, anon';
  END IF;
END
$migration$;
REVOKE EXECUTE ON FUNCTION public.set_updated_at() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.validate_establishment_municipality_province() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.validate_followup_targets() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.validate_permit_grant_application() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.write_audit_log() FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.can_access_establishment(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.has_province_access(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

-- Prevent PUBLIC from receiving EXECUTE on future functions created by the
-- migration owner in public. Default privileges are owner-specific.
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

-- There are currently no public-schema sequences. Keep their direct access
-- restricted if sequences are added later under this migration owner.
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    REVOKE ALL ON SEQUENCES FROM PUBLIC;

COMMIT;
