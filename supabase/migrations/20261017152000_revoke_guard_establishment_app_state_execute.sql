-- Trigger functions are invoked by PostgreSQL; API callers must not execute them as RPCs.
REVOKE EXECUTE ON FUNCTION public.guard_establishment_app_state() FROM PUBLIC, anon, authenticated;
