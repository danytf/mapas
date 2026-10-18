# Fase E: copias de seguridad, restauración y despliegue (parcial, 18/10/2026)

Estado: empezada. Hecho lo que no necesita aprobación del titular. **Pendiente: la prueba de restauración**, que exige un proyecto Supabase aislado (confirmar coste antes de crearlo).

## 1. Cobertura de copia del plan de Supabase (H-24)

- Producción: proyecto `mapas-dev` (`wwoczmihhupofwmlmgga`), `eu-west-1`, Postgres 17.11, estado `ACTIVE_HEALTHY` según `get_project`. Esa respuesta no indica el plan; el plan gratuito lo confirma el titular (la organización figura en plan gratuito según `CLAUDE.md`).
- Según la documentación de Supabase (consultada el 18/10/2026): las copias diarias automáticas existen en Pro (7 días), Team (14) y Enterprise (30); Point-in-Time Recovery es un complemento de pago. Para proyectos gratuitos la documentación recomienda exportar con `supabase db dump` y guardar copias fuera.
- Conclusión demostrable: **hoy no hay copia automática de la base de producción**. El único respaldo son las exportaciones manuales descritas en `docs/import-export-backups.md`, que no son una copia completa (el JSON/CSV de la app no incluye el catálogo completo ni el historial).
- Decisión del titular (18/10/2026): seguir en el plan gratuito. Por tanto el riesgo se mitiga con procedimiento: volcado periódico con `supabase db dump` (roles, esquema y datos) guardado fuera de Supabase y protegido, a cargo del titular o de un proceso que él autorice. **No se ha ejecutado ningún volcado ni hay uno programado**; no hay credenciales de conexión en el repositorio.
- Reactivación si el proyecto se pausa (7 días de poca actividad en el plan gratuito): desde el panel de Supabase, botón de restaurar proyecto; los datos se conservan mientras no se supere el periodo de retención del plan. La herramienta `restore_project` del MCP existe, pero no se ha probado. Cifras de retención: no verificadas.

## 2. Prueba de restauración

No hecha. Requiere un volcado real de producción y un proyecto vacío (crearlo implica coste o límite del plan gratuito: confirmar con el titular). Plan propuesto: volcar a un fichero local protegido, crear un proyecto aislado, restaurar, comparar con las 6 huellas de `supabase/tools/schema_fingerprint.sql`, los recuentos (791 puntos, 2 estados, 856 filas de auditoría) y repasar qué se pierde (usuarios de `auth` y contraseñas de roles propios no entran en el volcado de la documentación), registrar tiempos y eliminar el proyecto.

## 3. Despliegue y reversión

- Workflow `deploy-pages.yml`: se lanza al tocar `index.html` o el propio workflow en `main`, o a mano (`workflow_dispatch`).
- **Hallazgo H-37 (P3, informativo):** el workflow sube `path: .`, es decir, **todo el repositorio**, no solo `index.html`. Comprobado el 18/10/2026 en la URL pública: se sirven `CLAUDE.md`, `docs/traspaso/ESTADO.md`, `supabase/tests/rls_matrix.sql` y `scripts/dev/mock-supabase.mjs` (HTTP 200); `.github/` y `.claude/` no (404). El repositorio es público, de modo que no se expone nada que no esté ya en GitHub, y no hay credenciales en él; aun así, la web publicada contiene documentación y scripts internos. Propuesta, no aplicada porque cambia el despliegue: subir solo `index.html` (carpeta de salida con ese fichero) y comprobarlo con la URL pública.
- Reversión: como `main` exige PR y checks, revertir es: rama `fix/revertir-<PR>`, `git revert <commit de fusión>`, PR, checks `audit` y `postgres-smoke`, fusión; si cambia `index.html` el despliegue arranca solo. Prueba en seco (local, sin publicar): `git revert -n 36da309` (PR #105) se aplica sin conflictos (6 ficheros). Cambios de esquema no se revierten con esto: requieren una migración nueva (no se eliminan objetos por intuición).
- No probado: una reversión real en producción.

## Pendiente de la Fase E
1. Prueba de restauración (aprobación de coste del titular).
2. Decidir H-37 (desplegar solo `index.html`).
3. Establecer quién hace el volcado periódico y dónde se guarda.
