-- The owner may update application state, but creation time is immutable.
DROP TRIGGER IF EXISTS guard_sensitive_updates ON public.user_app_state;
CREATE TRIGGER guard_sensitive_updates
BEFORE UPDATE ON public.user_app_state
FOR EACH ROW
EXECUTE FUNCTION public.guard_sensitive_updates();
