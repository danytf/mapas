-- Split broad administrator ALL policies into operation-specific policies.
-- This avoids overlapping permissive policies while preserving admin access.
BEGIN;

DROP POLICY IF EXISTS provinces_admin_all ON public.provinces;
CREATE POLICY provinces_admin_insert ON public.provinces FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY provinces_admin_update ON public.provinces FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY provinces_admin_delete ON public.provinces FOR DELETE TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS profiles_admin_all ON public.profiles;
CREATE POLICY profiles_admin_insert ON public.profiles FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY profiles_admin_update ON public.profiles FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY profiles_admin_delete ON public.profiles FOR DELETE TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS user_provinces_admin_all ON public.user_provinces;
CREATE POLICY user_provinces_admin_insert ON public.user_provinces FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY user_provinces_admin_update ON public.user_provinces FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY user_provinces_admin_delete ON public.user_provinces FOR DELETE TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS municipalities_admin_all ON public.municipalities;
CREATE POLICY municipalities_admin_insert ON public.municipalities FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY municipalities_admin_update ON public.municipalities FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY municipalities_admin_delete ON public.municipalities FOR DELETE TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS categories_admin_all ON public.categories;
CREATE POLICY categories_admin_insert ON public.categories FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY categories_admin_update ON public.categories FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY categories_admin_delete ON public.categories FOR DELETE TO authenticated USING (public.is_admin());

COMMIT;
