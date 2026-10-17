-- Profile IDs mirror auth.users IDs and must never be reassigned, including by admins.
-- The shared guard already rejects changes to id and created_at for default tables.
DROP TRIGGER IF EXISTS guard_sensitive_updates ON public.profiles;
CREATE TRIGGER guard_sensitive_updates
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.guard_sensitive_updates();
