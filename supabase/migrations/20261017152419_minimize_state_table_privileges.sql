-- State rows are read and upserted by the application; API users must not truncate, delete, attach triggers, or create references.
REVOKE ALL PRIVILEGES ON TABLE public.user_app_state, public.establishment_app_state FROM PUBLIC, anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON TABLE public.user_app_state, public.establishment_app_state TO authenticated;
