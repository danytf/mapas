# Fase E: copias de seguridad, restauración y despliegue (parcial, 18/10/2026)

Estado: **cerrada el 19/10/2026**. La restauración se probó tres veces en un proyecto aislado (`mapas-restore-test`, plan gratuito, sin coste, eliminado después); la tercera dio las 6 huellas y los recuentos idénticos a producción. Detalle de la prueba y procedimiento en `docs/import-export-backups.md` y H-38 en `HALLAZGOS.md`.

## 1. Cobertura de copia del plan de Supabase (H-24)

- Producción: proyecto `mapas-dev` (`wwoczmihhupofwmlmgga`), `eu-west-1`, Postgres 17.11, estado `ACTIVE_HEALTHY` según `get_project`. Esa respuesta no indica el plan; el plan gratuito lo confirma el titular (la organización figura en plan gratuito según `CLAUDE.md`).
- Según la documentación de Supabase (consultada el 18/10/2026): las copias diarias automáticas existen en Pro (7 días), Team (14) y Enterprise (30); Point-in-Time Recovery es un complemento de pago. Para proyectos gratuitos la documentación recomienda exportar con `supabase db dump` y guardar copias fuera.
- Conclusión demostrable: **hoy no hay copia automática de la base de producción**. El único respaldo son las exportaciones manuales descritas en `docs/import-export-backups.md`, que no son una copia completa (el JSON/CSV de la app no incluye el catálogo completo ni el historial).
- Decisión del titular (18/10/2026): seguir en el plan gratuito. Por tanto el riesgo se mitiga con procedimiento: volcado periódico con `supabase db dump` (roles, esquema y datos) guardado fuera de Supabase y protegido, a cargo del titular o de un proceso que él autorice. **No se ha ejecutado ningún volcado ni hay uno programado**; no hay credenciales de conexión en el repositorio.
- Reactivación si el proyecto se pausa (7 días de poca actividad en el plan gratuito): desde el panel de Supabase, botón de restaurar proyecto; los datos se conservan mientras no se supere el periodo de retención del plan. La herramienta `restore_project` del MCP existe, pero no se ha probado. Cifras de retención: no verificadas.

## 2. Prueba de restauración

Hecha el 19/10/2026 en un proyecto aislado (ver H-38). Resultado final: políticas, funciones privadas, funciones públicas, permisos, triggers y RLS idénticos a producción (6 de 6) y mismos recuentos (791 puntos, 3 estados con versión máxima 2, 856 auditorías, 3 perfiles). Tiempos con la conexión del titular: esquema 17,7 s, datos 3,1 s. No se restauran los usuarios de autenticación, la configuración de Auth ni las claves del proyecto nuevo.

## 3. Despliegue y reversión

- Workflow `deploy-pages.yml`: se lanza al tocar `index.html` o el propio workflow en `main`, o a mano (`workflow_dispatch`).
- **Hallazgo H-37 (P3, cerrado en el PR #109 el 19/10/2026; el texto siguiente describe la situación inicial):** el workflow sube `path: .`, es decir, **todo el repositorio**, no solo `index.html`. Comprobado el 18/10/2026 en la URL pública: se sirven `CLAUDE.md`, `docs/traspaso/ESTADO.md`, `supabase/tests/rls_matrix.sql` y `scripts/dev/mock-supabase.mjs` (HTTP 200); `.github/` y `.claude/` no (404). El repositorio es público, de modo que no se expone nada que no esté ya en GitHub, y no hay credenciales en él; aun así, la web publicada contiene documentación y scripts internos. Propuesta, no aplicada porque cambia el despliegue: subir solo `index.html` (carpeta de salida con ese fichero) y comprobarlo con la URL pública.
- Reversión: como `main` exige PR y checks, revertir es: rama `fix/revertir-<PR>`, `git revert <commit de fusión>`, PR, checks `audit` y `postgres-smoke`, fusión; si cambia `index.html` el despliegue arranca solo. Prueba en seco (local, sin publicar): `git revert -n 36da309` (PR #105) se aplica sin conflictos (6 ficheros). Cambios de esquema no se revierten con esto: requieren una migración nueva (no se eliminan objetos por intuición).
- No probado: una reversión real en producción.

## Pendiente tras la Fase E

- Rutina mensual de copia a cargo del titular (script y procedimiento documentados).
- Una reversión real de un despliegue no se ha probado en producción (solo en seco).
- Con crecimiento del uso, valorar el plan de pago (H-24) o copias semanales.
