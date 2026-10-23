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
