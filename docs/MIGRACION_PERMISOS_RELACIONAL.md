# Migración de solicitudes, concesiones y seguimientos al modelo relacional

Estado (23/10/2026): **migración APLICADA en producción el 23/10/2026 (versión `20261023160115`; 7 columnas, 5 funciones, tablas vacías, `anon` sin ejecución, asesor de seguridad sin avisos nuevos). El volcado de datos y el cambio de la aplicación están PENDIENTES.** Diseño y diagnóstico: `docs/AUDITORIA_EXPEDIENTES_2026-10-23.md`.

## Qué incluye
- `supabase/migrations/20261023160115_permit_workflow.sql` (aditiva): columnas de decisión (`resolved_at`, `resolved_by`, `resolution_reason`), `legacy_ref` único, una concesión por solicitud, trigger de ciclo de vida (una solicitud resuelta no vuelve a pendiente; autor y fecha de la decisión), comprobación del responsable de un seguimiento y funciones atómicas e idempotentes `approve_permit_application`, `resolve_permit_application` y `cancel_permit_grant` (SECURITY INVOKER: mandan RLS y las guardas; conflicto 40001 si la fecha de lectura es obsoleta). Quién y cuándo sigue en `audit_log`.
- `supabase/tools/backfill_permits_from_state.sql`: volcado idempotente del JSON (no lo modifica).
- `supabase/tools/reconcile_permits.sql`: 10 comprobaciones de reconciliación (solo lectura).
- Pruebas: `supabase/tests/permit_workflow.sql` (42) y `permit_backfill.sql` (23), en `schema-smoke.yml`.

## Orden de despliegue
1. Copia previa (`scripts/backup-supabase.sh`).
2. Aplicar la migración (aditiva; la aplicación actual no se ve afectada). Renombrar el fichero a la versión que registre `list_migrations` y la referencia en `schema-smoke.yml`.
3. Verificar huellas (`supabase/tools/schema_fingerprint.sql`) y avisos del asesor.
4. **Congelar** la escritura del JSON (ventana corta sin editar), ejecutar el volcado en una transacción y la reconciliación: todo en 0.
5. Publicar la versión de la aplicación que lee y escribe solo en las tablas (siguiente PR) y dejar de escribir los arrays.

## Reversión (sin restaurar la base)
El volcado no toca el JSON: volver a la versión anterior de la aplicación. Las filas volcadas se identifican por `legacy_ref` y pueden retirarse con `DELETE ... WHERE legacy_ref IS NOT NULL`. La migración de esquema es aditiva y no hace falta deshacerla.

## Versión de la aplicación que usa las tablas (rama `feat/expedientes-tablas`, apilada sobre el PR #191)
- Carga: solicitudes, concesiones y seguimientos se leen de sus tablas (paginado, sin copia local); si la lectura falla, la carga falla. El JSON de `establishment_app_state` solo aporta contacto, notas y valoración del punto; sus listas antiguas se conservan sin tocar (copia de reversión).
- Guardado: `savePermits` compara lo último confirmado con lo editado (`diffRel`) y envía altas, cambios con control de versión (`updated_at`), bajas (solo administradores) y las funciones atómicas `approve_permit_application`, `resolve_permit_application` y `cancel_permit_grant`. Tras cada guardado, o fallo, se relee el punto: la memoria es siempre lo que hay en Supabase.
- Seguimientos: una fila de `followups` por solicitud pendiente; cerrar un seguimiento marca `completed_at`; resolver la solicitud lo cierra.
- Puntos personales (sin fila en el catálogo) siguen en `user_app_state.customPermits`.
- Aviso de seguridad: si hay puntos con listas antiguas en el JSON sin fila en las tablas (volcado sin hacer), la aplicación lo anota en la consola (`window.mapaExpedientesSinVolcar`).
- **No fusionar antes del volcado:** al desplegar, los expedientes que solo estén en el JSON dejarían de verse. Orden: fusionar #191 → ventana sin ediciones → volcado y reconciliación a 0 → fusionar esta rama → verificar la URL pública.
- Seguimiento de un punto sin solicitud: se muestra en la ficha («Seguimiento del punto») y se cierra con «Hecho»; no se crea desde la ficha.
- Responsable y siguiente acción de los seguimientos: en la ficha; las personas asignables salen de `list_establishment_assignees` (migración `20261023164238`, solo id y etiqueta).
- Probado con el Supabase simulado (`scripts/dev/mock-supabase.mjs` ahora simula las tres tablas y las tres funciones): alta, seguimiento, aprobar con doble clic (una sola concesión enlazada), denegar con motivo, conflicto por cambio de otra persona, recarga. La integridad y RLS reales se prueban en `supabase/tests/permit_workflow.sql`.
