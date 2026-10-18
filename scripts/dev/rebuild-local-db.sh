#!/usr/bin/env bash
# Reconstruye el esquema en una base local desde cero, replicando .github/workflows/schema-smoke.yml
set -euo pipefail
REPO="${1:-/home/claude/mapas}"
DB="${2:-mapas_test}"
export PGHOST=localhost PGPORT=5432 PGUSER=postgres PGPASSWORD=postgres
psql -v ON_ERROR_STOP=1 -q -d postgres -c "DROP DATABASE IF EXISTS $DB;" -c "CREATE DATABASE $DB;"
export PGDATABASE=$DB
psql -v ON_ERROR_STOP=1 -q <<'SQL'
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='anon') THEN CREATE ROLE anon NOLOGIN; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='authenticated') THEN CREATE ROLE authenticated NOLOGIN; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='service_role') THEN CREATE ROLE service_role NOLOGIN BYPASSRLS; END IF;
END $$;
CREATE SCHEMA auth;
CREATE TABLE auth.users (id uuid PRIMARY KEY, raw_user_meta_data jsonb NOT NULL DEFAULT '{}'::jsonb, email text, last_sign_in_at timestamptz);
CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql STABLE AS $$
  SELECT nullif(current_setting('request.jwt.claim.sub', true), '')::uuid $$;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT EXECUTE ON FUNCTION auth.uid() TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO anon, authenticated, service_role;
SQL
cd "$REPO"
# Orden idéntico al workflow: se extrae de los pasos "psql ... -f" de schema-smoke.yml
grep -oE 'psql -v ON_ERROR_STOP=1 -f [^ ]+' .github/workflows/schema-smoke.yml | awk '{print $NF}' | while read -r f; do
  if [[ "$f" == supabase/tests/* ]]; then continue; fi
  echo "aplicando $f"
  psql -v ON_ERROR_STOP=1 -q -f "$f" >/dev/null
done
echo "REBUILD OK"
