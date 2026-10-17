-- The audit log is written by the SECURITY DEFINER trigger function owned by postgres.
-- Client roles must not be able to read, advance, or alter the audit sequence directly.
REVOKE ALL PRIVILEGES ON SEQUENCE public.audit_log_id_seq FROM anon, authenticated;
