-- Make catalogue imports idempotent without changing existing rows.
-- Multiple NULL source_ref values remain allowed; populated references must be unique.
-- If duplicates already exist, fail explicitly rather than deleting or merging records.

BEGIN;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM public.establishments
    WHERE source_ref IS NOT NULL
    GROUP BY source_ref
    HAVING count(*) > 1
  ) THEN
    RAISE EXCEPTION
      'Cannot create unique source_ref index: duplicate non-null source_ref values already exist. Review them before applying this migration.';
  END IF;
END;
$$;

CREATE UNIQUE INDEX IF NOT EXISTS establishments_source_ref_unique_idx
  ON public.establishments (source_ref)
  WHERE source_ref IS NOT NULL;

COMMIT;
