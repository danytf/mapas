-- Trigger functions are internal implementation details, not callable RPC endpoints.
REVOKE ALL ON FUNCTION public.set_user_app_state_updated_at() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.set_establishment_app_state_updated_at() FROM PUBLIC, anon, authenticated;
