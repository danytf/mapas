# Cómo ejecutar las pruebas

## Estáticas (Node 22, desde la raíz del repositorio)
```
node scripts/audit-persistence.mjs index.html
node scripts/audit-xss.mjs index.html
node scripts/audit-a11y.mjs index.html
node scripts/audit-cdn-integrity.mjs index.html
node scripts/audit-csp.mjs index.html
node scripts/audit-static-catalog.mjs index.html      # genera catalog-audit-output/ (ignorado por git)
node scripts/test-shared-state-sanitizers.mjs
node scripts/test-paged-fetch.mjs
node scripts/test-multiprovince.mjs
node scripts/test-ui-fixes.mjs
node scripts/test-list-performance.mjs
node scripts/test-admin-panel.mjs
node scripts/test-app-mejoras.mjs
node scripts/test-a11y-fase-d.mjs index.html          # contraste WCAG AA claro/oscuro, nombres, aria-live y foco (Fase D)
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
psql -v ON_ERROR_STOP=1 -f supabase/tests/state_version.sql
psql -v ON_ERROR_STOP=1 -f supabase/tests/rls_matrix.sql
```
Resultado esperado: `state_history: 29 comprobaciones correctas`, `state_version: 20 comprobaciones correctas` y `Matriz RLS: 973 celdas, 0 discrepancias, 0 inconclusas, 781 denegaciones esperadas verificadas`. Todas terminan en `ROLLBACK`, salvo el humo, que deja datos de prueba en la base local.

## Comparar con producción
`supabase/tools/schema_fingerprint.sql` devuelve conteo y huella MD5 de políticas, permisos, funciones, triggers y RLS. Ejecutarlo en local y, con el MCP de Supabase, en producción (excluyendo `rls_auto_enable` de las funciones públicas). Valores de referencia en la cabecera del fichero y en `ESTADO.md`.

## E2E en navegador (Fase C)
1. Proyecto Supabase aislado y vacío (nunca producción). Montar el esquema con `psql` en el orden de `schema-smoke.yml` (sin los dos primeros pasos, que simulan Supabase) y comparar huellas con `supabase/tools/schema_fingerprint.sql`.
2. Definir `E2E_PW_ADMIN`, `E2E_PW_GRANADA`, `E2E_PW_GRANADA2`, `E2E_PW_ALMERIA`, `E2E_PW_SINPROVINCIA` y `E2E_PW_DESACTIVADO` y ejecutar `psql "<conexión>" -v ON_ERROR_STOP=1 -f supabase/e2e/seed_synthetic.sql`. Aborta si la base no está vacía o faltan las variables.
3. Copia de `index.html` fuera del repositorio con `SUPABASE_URL` y `SUPABASE_KEY` del proyecto aislado, servida en `http://127.0.0.1:<puerto>/`.
4. Guion de pruebas y resultados esperados: `docs/AUDITORIA_FASE_C_2026-10-18.md`.

## Volumen de la base de datos (sin proyecto ni coste)
Con una base PostgreSQL local reconstruida (`scripts/dev/rebuild-local-db.sh`):
1. `psql -v ON_ERROR_STOP=1 -f supabase/tools/volume/load_synthetic_volume.sql`: 50.000 puntos sintéticos en las 52 provincias, 3.000 estados compartidos y tres usuarios (administrador, dos provincias, una provincia). Solo para una base local.
2. `psql -v ON_ERROR_STOP=1 -f supabase/tools/volume/measure_catalogue_load.sql`: tiempos de la carga del catálogo (recuento exacto y páginas de 1.000 por clave) y del estado compartido con las políticas RLS reales. Referencia tras H-26: administrador unos 90 ms, dos provincias unos 10 ms, una provincia unos 2 ms. Detalle y comparación con las políticas anteriores en `docs/AUDITORIA_FASE_D_2026-10-18.md`.

## Volumen en el navegador (sin proyecto ni coste)
Con el Supabase simulado: `GET http://127.0.0.1:8766/__reset?n=<puntos>&estados=1` genera puntos sintéticos reproducibles en las 52 provincias (o `MOCK_POINTS` al arrancar). `scripts/dev/measure-load.js` mide la carga del administrador (tiempo hasta el mapa, tiempo por función, tareas largas, DOM, memoria, filtro) y `scripts/dev/list-scenarios.js` compara la lista de dos versiones de la app en 9 escenarios (mismo HTML byte a byte). Referencia tras H-27 con 50.000 puntos: 3,9 s hasta el mapa. Detalle y comparación con el código anterior en `docs/AUDITORIA_FASE_D_2026-10-18.md`. Si el navegador se queda congelado (con el código anterior ocurría con 20.000 puntos), esperar: la tarea termina.

## Interfaz con un Supabase simulado (sin proyecto ni coste)
Para probar lógica del navegador (provincias, geocodificación, valores por defecto, nombre de ficheros) sin crear un proyecto:
1. `node scripts/dev/mock-supabase.mjs` (puerto 8766): imita GoTrue y PostgREST con datos sintéticos de Granada, Almería y Jaén y un Nominatim simulado que registra las peticiones (`/__log`). Usuarios, con contraseña «x»: `multi@test.es` (dos provincias), `alm@test.es` (una), `vacio@test.es` (sin puntos), `admin@test.es`.
2. `node scripts/dev/build-mock-site.mjs index.html <salida>/index.html` y servir esa copia en un servidor estático local (p. ej. 127.0.0.1:8765).
3. Abrir la copia en el navegador. No prueba RLS ni la API real (eso lo cubren `supabase/tests/` y las pruebas en un proyecto aislado); cubre el comportamiento del cliente. Resultados de ejemplo: `docs/AUDITORIA_FASE_D_2026-10-18.md`.

## Control negativo de la matriz
Reconstruir sin la migración `20261018123313_allow_author_set_null_on_profile_delete.sql`: la matriz debe fallar con 2 discrepancias.
