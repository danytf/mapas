# Hallazgos de la auditoría

Formato exigido por el titular para cada hallazgo: ID, capa, severidad P0-P3, estado, evidencia exacta, impacto, acción, prueba de regresión, riesgo residual y dependencia del titular. Este resumen es el estado; la evidencia completa está en `docs/AUDITORIA_FASE_B_2026-10-18.md` y `docs/CIERRE_FASE_B_2026-10-18.md`.

| ID | Sev. | Estado | Resumen | Regresión |
|---|---|---|---|---|
| H-01 | P1 | Cerrado (PR #80) | Recursos de CDN sin versión fija ni SRI. Ahora 6 recursos con versión exacta, sha384 y `crossorigin`; hash correcto aceptado y alterado rechazado en navegador | `scripts/audit-cdn-integrity.mjs` en CI |
| H-02 | P2 | **Abierto** | Sin CSP. Solo es posible por `<meta>` en GitHub Pages. Hay política candidata calculada con los orígenes reales; requiere probarla en navegador con sesión (mapas, geocodificación, exportación, importación) | Por crear en la Fase C |
| H-03 | P3 | Abierto (recomendación) | `set_updated_at` tiene `search_path=public`; no se cambia sin necesidad demostrada | Huellas del esquema |
| H-04 | P3 | Cerrado por decisión | Usuarios con provincia pueden modificar (no borrar) solicitudes, concesiones y seguimientos de otros usuarios de su provincia. Se mantiene | `rls_matrix.sql` |
| H-05 | P2 | Cerrado (PR #81), falta verificación manual | Filas del panel de estadísticas solo operables con ratón. Ahora llevan botón nativo (Tab, Enter, Espacio) | `scripts/audit-a11y.mjs` en CI |
| H-06, H-07, H-08 | - | Pendientes | Pruebas E2E en navegador y restauración de backup. La parte de base de datos de la autorización ya está cubierta por la matriz. Los detalles se concretan en la Fase C y la E | Por crear |
| H-09 | P3 | Aceptado | Origen `danytf.github.io` compartido con otras apps de Wesser | - |
| H-10 | P2 | Cerrado (PR #79, migración `20261018123313`) | Borrar un perfil/usuario con registros creados por él fallaba siempre (FK `ON DELETE SET NULL` contra la inmutabilidad de `created_by`) | `rls_matrix.sql` (bloque H-10) |
| H-11 | P1 | **Abierto, para la Fase C** | `establishment_app_state.state` se reescribe entero en cada guardado y el cliente lo carga una sola vez: el último en guardar pisa al anterior. Reproducido en local con dos usuarios de la misma provincia. Hoy el riesgo es bajo (3 perfiles, 2 filas) y lo pisado es recuperable por H-12 | `supabase/tests/state_history.sql` reproduce el caso; falta la prueba del control de conflicto |
| H-12 | P1/P2 | Cerrado (PR #82, migración `20261018124030`) | No había forma de recuperar contenido sobrescrito. Ahora cada UPDATE con estado distinto y cada DELETE guardan el estado previo en `establishment_app_state_history` (solo lectura para administradores) | `supabase/tests/state_history.sql` |

## Diseño propuesto para H-11 (opción A), por validar

Columna `version bigint` (o equivalente) en `establishment_app_state` que un trigger incrementa en cada UPDATE; el cliente guarda con condición sobre la versión leída (`update ... where establishment_id = X and version = leída`) en lugar de `upsert` ciego; si no actualiza ninguna fila, muestra un aviso de conflicto en español y ofrece recargar el estado remoto sin perder lo escrito. Evitar comparar `updated_at` desde JavaScript (pierde precisión de microsegundos). Requiere migración, paso en `schema-smoke.yml`, prueba SQL y prueba E2E con dos sesiones. Cambia el comportamiento funcional, así que necesita su prueba de regresión.

## Observaciones sin ID

- Auditoría sin usuario en escrituras sin JWT (ver ESTADO.md).
- Las tablas normalizadas de permisos (`permit_applications`, `permit_grants`, `followups`) están vacías; existe `docs/PLAN_MIGRACION_PERMISOS_NORMALIZADOS.md` como plan no ejecutado. No migrar sin decisión del titular.
- Clave `rgr-auth` de una versión antigua en el navegador del titular: no usada.
