# Estado del proyecto a 18/10/2026 (traspaso a Visual Studio Code)

`main` en `10d5743`. Todo lo descrito está fusionado, desplegado y verificado salvo lo marcado como pendiente. Evidencias detalladas: `docs/AUDITORIA_FASE_B_2026-10-18.md`, `docs/CIERRE_FASE_B_2026-10-18.md`, `docs/CIERRE_AUDITORIA_FASES_1_2_2026-10-18.md`.

## Fases

| Fase | Estado |
|---|---|
| A. Reconstruir el estado real | Cerrada |
| B. Seguridad y persistencia | Cerrada (H-11 aplazado a la C por decisión del titular) |
| C. Pruebas E2E en navegador | **En curso**: 11 pruebas hechas (`docs/AUDITORIA_FASE_C_2026-10-18.md`); H-11 con migración en producción y cliente en PR; H-02 en PR; pendientes H-13 a H-17 |
| D. Integridad, dependencias, accesibilidad, rendimiento | Parcial (ver ROADMAP) |
| E. Backup, restauración y despliegue | Sin empezar |
| F. Informe final | Sin empezar |

## Producción (Supabase `wwoczmihhupofwmlmgga`)

- Migraciones: 26 registradas, última `20261018145132_establishment_app_state_version` (H-11, aplicada el 18/10/2026). Coinciden una a una con `supabase/migrations/`.
- Huellas del esquema público (comparables con `supabase/tools/schema_fingerprint.sql`): políticas 51 `7f65af3e`, permisos de tabla 57 `374f58c4`, funciones propias 19 `976fdf1e` (sin `rls_auto_enable`, función de la plataforma), funciones privadas 3 `de9d04b4`, triggers 34 `6d0afe68`, tablas con RLS 17 `e9ad42c3`.
- 17 tablas, todas con RLS. Ninguna concede privilegios a `anon`.
- Avisos del asesor de seguridad: solo "protección frente a contraseñas filtradas desactivada" (aceptado, no tocar).
- Datos (consulta del 18/10/2026): 791 establecimientos, todos activos y con coordenadas; 3 perfiles (1 administrador); 2 filas de `user_provinces`; 2 filas de `establishment_app_state`; 3 de `user_app_state`; 0 en `permit_applications`, `permit_grants` y `followups` (el estado real de permisos vive en el JSONB de `establishment_app_state`); 856 filas de `audit_log`; 43 de `establishment_location_history`; 0 de `establishment_app_state_history` (aún no hubo sobrescrituras).
- Catálogo limpio: sin duplicados reales; solo 2 pares de coordenadas coincidentes (un Mercadona y un centro comercial en el mismo edificio, Armilla y Granada), no son defectos.
- Auditoría: 807 de 856 filas sin usuario (carga del catálogo, arranque de perfiles y 8 actualizaciones SQL del 16-17/10); toda edición desde la app lleva autor. Es una inferencia, no un defecto confirmado. Recomendación pendiente: registrar el rol de base de datos cuando no hay JWT.

## Aplicación publicada

- https://danytf.github.io/mapas/ sirve exactamente `main` (verificado en navegador tras las fusiones del 18/10).
- Recursos externos fijados con versión exacta y SRI sha384: Leaflet 1.9.4, leaflet.markercluster 1.5.3 (unpkg) y supabase-js 2.118.0 (jsdelivr). Google Fonts exento.
- Sin CSP ni cabeceras de seguridad (GitHub Pages no permite cabeceras; solo `<meta>`). Propuesta de política en `docs/CIERRE_FASE_B_2026-10-18.md`, sin aplicar.
- Sin persistencia de negocio en el navegador (auditoría estática en CI y comprobación en producción). La sesión de Supabase vive solo en memoria. El origen `danytf.github.io` es compartido con otras apps de Wesser, cuyas claves de `localStorage` aparecen allí; la clave `rgr-auth` es de una versión antigua de este mapa y no se usa ni se limpia (observación, no cambiada).

## Repositorio y CI

- Workflows: `audit-static-catalog.yml` (job `audit`), `schema-smoke.yml` (job `postgres-smoke`, PostgreSQL 17: reconstruye el esquema, humo, historial y matriz RLS, y comprueba que toda migración está aplicada), `default-function-acl.yml`, `deploy-pages.yml`.
- Protección de `main` verificada por el titular el 18/10/2026 (ver CLAUDE.md).
- PR fusionados el 18/10/2026: #79 matriz RLS y baja de autores (H-10), #82 historial del estado compartido (H-12), #80 SRI y versiones fijas (H-01), #81 teclado en el panel (H-05), #83-#85 documentación. Antes: #78 consolidación de evidencias de las fases 1 y 2.
- Pruebas: matriz RLS 973 celdas, 0 discrepancias, 781 denegaciones comprobadas; historial 29 comprobaciones; auditorías estáticas en verde.

## Hallazgos

Ver `HALLAZGOS.md`. Abiertos: H-11 (P1, migración aplicada; cliente pendiente de fusionar), H-02 (P2, en PR), H-13 (P1), H-14 (P2), H-15 a H-19 (P3), H-03 (P3, recomendación) y H-09 (P3, aceptado). H-05 verificado en navegador.

## Entorno aislado de la Fase C

- Proyecto Supabase `mapas-e2e` (`obqodndkzznrpuwxzbsi`, eu-west-1), creado el 18/10/2026 en la organización Wesser (plan gratuito, coste 0 confirmado por el titular). Las ramas de Supabase no están disponibles en el plan gratuito y el MCP no ofrece `get_cost`/`confirm_cost`: el coste lo presenta `create_project`/`create_branch` al llamarlas.
- Esquema montado con `psql` desde el repositorio y huellas idénticas a producción (6 de 6). Datos sintéticos de `supabase/e2e/seed_synthetic.sql`.
- Acceso del equipo del titular: `psql` por el pooler de sesión (`aws-0-eu-west-1.pooler.supabase.com:5432`, usuario `postgres.obqodndkzznrpuwxzbsi`) con la contraseña en `%APPDATA%\postgresql\pgpass.conf` (fuera del repositorio). Las contraseñas de las cuentas sintéticas están fuera del repositorio.
- Se elimina al cerrar la Fase C, con confirmación del titular.

## Cosas verificadas por el titular o que dependen de él

- Verificado por el titular: protección de `main`; plan gratuito de la organización tras crear `mapas-e2e`.
- Verificado en la Fase C con cuenta sintética: H-05 (teclado en el panel).
- Pendiente de él: fusionar los PR de H-11 y H-02 (migración de H-11 aprobada y aplicada el 18/10/2026); confirmar la eliminación de `mapas-e2e` al terminar; borrar del gestor de contraseñas de Chrome las credenciales de prueba de `127.0.0.1` si las guardó.
