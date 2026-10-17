-- Ordinary provincial users may propose coordinates but must not pre-decide their proposals.
DROP POLICY IF EXISTS location_reviews_insert_scope ON public.establishment_location_reviews;
CREATE POLICY location_reviews_insert_scope
ON public.establishment_location_reviews
FOR INSERT
TO authenticated
WITH CHECK (
  public.can_access_establishment(establishment_id)
  AND created_by = (SELECT auth.uid())
  AND (
    public.is_admin()
    OR (status = 'pending' AND reviewed_by IS NULL AND reviewed_at IS NULL)
  )
);
