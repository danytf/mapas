DO $default_function_acl_test$
BEGIN
  IF EXISTS (
    SELECT 1
      FROM pg_catalog.pg_default_acl d
      CROSS JOIN LATERAL pg_catalog.aclexplode(d.defaclacl) a
     WHERE d.defaclrole = 'postgres'::regrole
       AND d.defaclnamespace = 'public'::regnamespace
       AND d.defaclobjtype = 'f'
       AND a.privilege_type = 'EXECUTE'
       AND a.grantee IN (0, 'anon'::regrole, 'authenticated'::regrole)
  ) THEN
    RAISE EXCEPTION 'Unsafe default EXECUTE grants remain for public functions';
  END IF;
END
$default_function_acl_test$;
