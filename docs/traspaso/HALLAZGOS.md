# Hallazgos de la auditoría

Formato exigido por el titular para cada hallazgo: ID, capa, severidad P0-P3, estado, evidencia exacta, impacto, acción, prueba de regresión, riesgo residual y dependencia del titular. Este resumen es el estado; la evidencia completa está en `docs/AUDITORIA_FASE_B_2026-10-18.md`, `docs/CIERRE_FASE_B_2026-10-18.md` y `docs/AUDITORIA_FASE_C_2026-10-18.md`.

| ID | Sev. | Estado | Resumen | Regresión |
|---|---|---|---|---|
| H-01 | P1 | Cerrado (PR #80) | Recursos de CDN sin versión fija ni SRI. Ahora 6 recursos con versión exacta, sha384 y `crossorigin`; hash correcto aceptado y alterado rechazado en navegador | `scripts/audit-cdn-integrity.mjs` en CI |
| H-02 | P2 | **Corregido en `security/h-02-csp`, pendiente de desplegar** | Sin CSP (comprobado con las cabeceras reales el 18/10: solo HSTS). Política por `<meta>` como primer elemento de `<head>`; probada en navegador con sesión en todos los flujos: 0 violaciones, y control positivo de bloqueo. Mantiene `'unsafe-inline'` (scripts y estilos en línea) | `scripts/audit-csp.mjs` en CI |
| H-03 | P3 | Abierto (recomendación) | `set_updated_at` tiene `search_path=public`; no se cambia sin necesidad demostrada | Huellas del esquema |
| H-04 | P3 | Cerrado por decisión | Usuarios con provincia pueden modificar (no borrar) solicitudes, concesiones y seguimientos de otros usuarios de su provincia. Se mantiene | `rls_matrix.sql` |
| H-05 | P2 | Cerrado (PR #81) y verificado en navegador el 18/10/2026 | Filas del panel de estadísticas solo operables con ratón. Ahora llevan botón nativo. Verificado solo con teclado: Tab llega a las 13 filas, foco visible, Intro y Espacio filtran (Fase C, prueba 3) | `scripts/audit-a11y.mjs` en CI |
| H-06, H-07 | - | Cubiertos por la Fase C | Pruebas E2E en navegador: hechas las pruebas 1-8 y 11 en un proyecto aislado (`docs/AUDITORIA_FASE_C_2026-10-18.md`) | `supabase/e2e/seed_synthetic.sql` y guion del informe |
| H-08 | - | Pendiente (Fase E) | Restauración de backup | Por crear |
| H-09 | P3 | Aceptado | Origen `danytf.github.io` compartido con otras apps de Wesser | - |
| H-10 | P2 | Cerrado (PR #79, migración `20261018123313`) | Borrar un perfil/usuario con registros creados por él fallaba siempre (FK `ON DELETE SET NULL` contra la inmutabilidad de `created_by`) | `rls_matrix.sql` (bloque H-10) |
| H-11 | P1 | **Migración aplicada en producción (18/10/2026, `20261018145132`); cliente en PR #89, pendiente de fusionar** (diseño aprobado por el titular el 18/10/2026; verificado con dos sesiones en `mapas-e2e`) | `establishment_app_state.state` se reescribe entero en cada guardado y el cliente lo carga una sola vez: el último en guardar pisa al anterior. Reproducido en local con dos usuarios de la misma provincia. Hoy el riesgo es bajo (3 perfiles, 2 filas) y lo pisado es recuperable por H-12 | `supabase/tests/state_history.sql` reproduce el caso; falta la prueba del control de conflicto |
| H-12 | P1/P2 | Cerrado (PR #82, migración `20261018124030`) | No había forma de recuperar contenido sobrescrito. Ahora cada UPDATE con estado distinto y cada DELETE guardan el estado previo en `establishment_app_state_history` (solo lectura para administradores). Comprobado en navegador: 5 cambios de permisos, 5 filas de historial | `supabase/tests/state_history.sql` |
| H-13 | P1 | Abierto | Los permisos de un punto personal («Agregar punto») no se guardan en Supabase y la app muestra «Guardado en Supabase»; al recargar se pierden. En producción hay 0 puntos personales (18/10), sin pérdida real | Por crear |
| H-14 | P2 | Abierto (latente) | El cliente indexa el estado de permisos por nombre del punto y no por ID: dos puntos con el mismo nombre compartirían o cruzarían su estado. Hoy hay 0 nombres repetidos en producción | Por crear |
| H-15 | P3 | Abierto | «Guardar dirección y ubicación» no se bloquea mientras guarda: 3 clics rápidos generan 3 escrituras y 3 filas de auditoría (el historial solo registra 1) | Por crear |
| H-16 | P3 | Abierto | Mensajes: el aviso de tiempo agotado dice «17 segundos» y la espera es de 27 s; se muestran textos técnicos («AbortError…», el mensaje del servidor) en lugar de los previstos en español | Por crear |
| H-17 | P3 | Abierto | Usabilidad: búsqueda sin resultados sin mensaje; «★★★★★ (5)» parece un recuento; el CSV se llama siempre `permisos-captacion-granada.csv` | Por crear |
| H-18 | P3 | Abierto (Fase D) | Accesibilidad: el menú (`role="menuitem"`) no responde a las flechas; al cerrar el «Panel resumen» el foco no vuelve al botón de origen | Por crear |
| H-19 | P3 | Por investigar | Dos `POST user_app_state` seguidos al iniciar sesión | - |

## Diseño de H-11 (opción A), aprobado por el titular el 18/10/2026

Columna `version bigint` (o equivalente) en `establishment_app_state` que un trigger incrementa en cada UPDATE; el cliente guarda con condición sobre la versión leída (`update ... where establishment_id = X and version = leída`) en lugar de `upsert` ciego; si no actualiza ninguna fila, muestra un aviso de conflicto en español y ofrece recargar el estado remoto sin perder lo escrito. Evitar comparar `updated_at` desde JavaScript (pierde precisión de microsegundos). Requiere migración, paso en `schema-smoke.yml`, prueba SQL y prueba E2E con dos sesiones. Cambia el comportamiento funcional, así que necesita su prueba de regresión.

## Observaciones sin ID

- Auditoría sin usuario en escrituras sin JWT (ver ESTADO.md).
- Las tablas normalizadas de permisos (`permit_applications`, `permit_grants`, `followups`) están vacías; existe `docs/PLAN_MIGRACION_PERMISOS_NORMALIZADOS.md` como plan no ejecutado. No migrar sin decisión del titular.
- Clave `rgr-auth` de una versión antigua en el navegador del titular: no usada.
