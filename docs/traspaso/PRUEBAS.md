# Cómo ejecutar las pruebas

## Estáticas (Node 22, desde la raíz del repositorio)
```
node scripts/audit-persistence.mjs index.html
node scripts/audit-xss.mjs index.html
node scripts/audit-a11y.mjs index.html
node scripts/audit-cdn-integrity.mjs index.html
node scripts/audit-static-catalog.mjs index.html      # genera catalog-audit-output/ (ignorado por git)
node scripts/test-shared-state-sanitizers.mjs
```
Cada una devuelve código distinto de cero si falla. `audit-a11y` y `audit-cdn-integrity` fallan en versiones anteriores a #81 y #80 (control negativo).

## SQL (PostgreSQL local, usuario con permisos de superusuario)
Reconstruir el esquema desde cero reproduciendo el orden de `schema-smoke.yml` (necesita bash, por ejemplo Git Bash en Windows, y `psql` en el PATH):
```
bash scripts/dev/rebuild-local-db.sh . mapas_test
```
Variables: `PGHOST=localhost PGPORT=5432 PGUSER=postgres PGPASSWORD=<la de tu instalación>` (el script usa postgres/postgres; ajústalo si tu instalación difiere). Después, **en este orden y sobre una base recién reconstruida** (el humo consume datos de arranque):
```
psql -v ON_ERROR_STOP=1 -f supabase/tests/schema_smoke.sql
psql -v ON_ERROR_STOP=1 -f supabase/tests/state_history.sql
psql -v ON_ERROR_STOP=1 -f supabase/tests/rls_matrix.sql
```
Resultado esperado: `state_history: 29 comprobaciones correctas` y `Matriz RLS: 973 celdas, 0 discrepancias, 0 inconclusas, 781 denegaciones esperadas verificadas`. Todas terminan en `ROLLBACK`, salvo el humo, que deja datos de prueba en la base local.

## Comparar con producción
`supabase/tools/schema_fingerprint.sql` devuelve conteo y huella MD5 de políticas, permisos, funciones, triggers y RLS. Ejecutarlo en local y, con el MCP de Supabase, en producción (excluyendo `rls_auto_enable` de las funciones públicas). Valores de referencia en la cabecera del fichero y en `ESTADO.md`.

## Control negativo de la matriz
Reconstruir sin la migración `20261018123313_allow_author_set_null_on_profile_delete.sql`: la matriz debe fallar con 2 discrepancias.
