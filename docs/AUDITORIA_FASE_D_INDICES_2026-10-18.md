# Fase D: informe de los 23 índices sin uso (18/10/2026)

Alcance: solo informe. No se ha creado ninguna migración, no se ha tocado el esquema ni los datos de producción y no se propone eliminar ningún índice. Las consultas contra producción (`wwoczmihhupofwmlmgga`) fueron solo de lectura (`pg_stat_user_indexes`, `pg_statio_user_indexes`, `pg_index`, `pg_constraint`, `pg_stat_database`, `get_advisors`), ejecutadas el 18/10/2026 a las 19:29 UTC. La prueba de plan se hizo en una base PostgreSQL 17 local (reconstruida desde las migraciones y con la carga de `supabase/tools/volume/`), ya borrada.

## 1. Cuántos son y cuáles

La cifra de «23» es correcta si se cuentan **todos** los índices de `public` con `idx_scan = 0`. El asesor de rendimiento de Supabase (`unused_index`) muestra hoy **21**, porque excluye los índices que respaldan una restricción. Los 2 que faltan son la clave primaria `establishment_app_state_history_pkey` y la restricción UNIQUE `provinces_name_key`.

| Grupo | Índices |
|---|---|
| Aparecen en el asesor (21) | 15 de claves foráneas de la migración `20261017120547` + 6 más (ver abajo) |
| Respaldan restricción (2) | `establishment_app_state_history_pkey` (PK), `provinces_name_key` (UNIQUE) |

## 2. Qué cubren los datos de uso (y qué no)

- Contadores desde el último reinicio de estadísticas: `pg_stat_database.stats_reset` = 02/10/2026 18:01 UTC. Hora de la consulta: 18/10/2026 19:29 UTC. **Ventana observada: 16 días y 1,5 horas.**
- `pg_postmaster_start_time()` = 16/10/2026 20:51 UTC (reinicio del servidor hace ~1 día 22 h). Como `stats_reset` es anterior, los contadores sobrevivieron al reinicio (reinicio limpio). No se puede demostrar desde SQL que no hubiera una caída entre medias; si la hubo, la ventana sería más corta.
- El tráfico es el de un único titular y pocos usuarios probando: el índice más usado, `profiles_pkey`, suma 142.823 escaneos (casi todos de las políticas RLS), `municipalities_pkey` 22.901 y `user_provinces_pkey` 12.933. Los índices de `establishments` que sirven a la app: `establishments_pkey` 1.328, `establishments_source_ref_unique_idx` 885, `establishments_category_idx` 69.
- 16 días de estadísticas con tablas de 0 a 800 filas no permiten concluir nada sobre volumen futuro (ver 4).

## 3. Cifras de tamaño

| Concepto | Bytes | Lectura |
|---|---|---|
| Base de datos entera | 14.243.507 (13,6 MiB) | referencia |
| Tablas de `public` con todos sus índices y TOAST | 2.121.728 (2,02 MiB) | |
| Todos los índices de `public` | 1.064.960 (1,02 MiB) | |
| **Los 23 índices con 0 escaneos** | **237.568 (232 KiB)** | 22,3 % de los índices de `public`, 11,2 % de `public`, **1,7 % de la base** |
| De ellos, los 21 del asesor | 221.184 (216 KiB) | sin PK ni UNIQUE |

Coste de mantenerlos: 232 KiB de disco y una escritura extra de índice por cada INSERT/UPDATE de la columna correspondiente. Con 791 puntos y escrituras esporádicas es despreciable. El beneficio de borrarlos sería de 232 KiB; el riesgo, que una operación (borrar un usuario, una provincia) haga un recorrido completo de una tabla grande. La relación coste/beneficio no justifica tocarlos hoy.

Por qué «sin uso» hoy no prueba que sobren: 15 de los 23 están en tablas con **0 filas** (`followups`, `permit_applications`, `permit_grants`, `import_batches`, `import_records`, `establishment_app_state_history`; `pg_class.reltuples` = -1, nunca analizadas), y `index.html` no consulta ninguna de ellas (solo `establishments`, `establishment_app_state`, `user_app_state`, `profiles`, `user_provinces`, `categories`/`municipalities`/`provinces` por relación). Con tablas de 0 a 3 filas el planificador siempre elige recorrido secuencial, que es lo correcto. Un índice no puede acumular escaneos en una tabla que nadie lee.

## 4. Los 23, uno a uno

Escaneos: `idx_scan` de producción (todos 0; `idx_tup_read` = 0). Tamaño: `pg_relation_size`. Filas: estimación de `pg_class.reltuples` (`0` = tabla vacía, nunca analizada). «FK» = el índice cubre una clave foránea con esa columna como primera; las FK `created_by`/`updated_by`/`assigned_by` apuntan a `profiles` con `ON DELETE SET NULL`, lo que obliga a la base a buscar filas hijas al borrar un perfil.

### 4.1 Índices de claves foráneas de la migración `20261017120547_index_uncovered_foreign_keys` (15)

Existen a propósito: el asesor de rendimiento avisaba de claves foráneas sin índice. Ninguna política RLS filtra por estas columnas (las políticas de `permit_*`/`followups`/`location_reviews` usan `can_access_establishment(establishment_id)` y solo comparan `created_by`/`updated_by` con `auth.uid()` en `WITH CHECK`, sin buscar por ellas), así que su única función es acelerar las comprobaciones de integridad al borrar o cambiar la fila padre.

| Índice | Tabla (filas) | Columnas | Tamaño | Escaneos | Motivo | Clasificación |
|---|---|---|---|---|---|---|
| `idx_user_provinces_province_id` | `user_provinces` (2) | `province_id` | 16 KiB | 0 | FK a `provinces` `ON DELETE RESTRICT`: evita recorrer la tabla al borrar una provincia | Mantener: respalda FK |
| `idx_user_provinces_assigned_by` | `user_provinces` (2) | `assigned_by` | 16 KiB | 0 | FK a `profiles` `SET NULL` | Mantener: respalda FK |
| `idx_establishment_app_state_updated_by` | `establishment_app_state` (3) | `updated_by` | 16 KiB | 0 | FK a `auth.users` `SET NULL` | Mantener: respalda FK; crecerá con el estado compartido |
| `idx_establishments_created_by` | `establishments` (792) | `created_by` | 16 KiB | 0 | FK a `profiles` `SET NULL`: borrar un perfil recorre `establishments` | **Mantener: respalda FK y es la tabla grande (50.000 previstos)**. Medido en 4.4 |
| `idx_permit_grants_updated_by` | `permit_grants` (0) | `updated_by` | 8 KiB | 0 | FK a `profiles` | Mantener: respalda FK; tabla sin uso aún |
| `idx_permit_grants_created_by` | `permit_grants` (0) | `created_by` | 8 KiB | 0 | FK a `profiles` | Mantener: respalda FK; tabla sin uso aún |
| `idx_permit_grants_application_id` | `permit_grants` (0) | `application_id` | 8 KiB | 0 | FK a `permit_applications` | Mantener: respalda FK; tabla sin uso aún |
| `idx_permit_applications_created_by` | `permit_applications` (0) | `created_by` | 8 KiB | 0 | FK a `profiles` | Mantener: respalda FK; tabla sin uso aún |
| `idx_permit_applications_updated_by` | `permit_applications` (0) | `updated_by` | 8 KiB | 0 | FK a `profiles` | Mantener: respalda FK; tabla sin uso aún |
| `idx_followups_application_id` | `followups` (0) | `application_id` | 8 KiB | 0 | FK a `permit_applications` | Mantener: respalda FK; tabla sin uso aún |
| `idx_followups_grant_id` | `followups` (0) | `grant_id` | 8 KiB | 0 | FK a `permit_grants` | Mantener: respalda FK; tabla sin uso aún |
| `idx_followups_created_by` | `followups` (0) | `created_by` | 8 KiB | 0 | FK a `profiles` | Mantener: respalda FK; tabla sin uso aún |
| `idx_import_batches_started_by` | `import_batches` (0) | `started_by` | 8 KiB | 0 (sin lecturas de bloque: nunca tocado) | FK a `profiles` | Mantener: respalda FK; tabla sin uso aún |
| `idx_establishment_location_reviews_created_by` | `establishment_location_reviews` (~0-1) | `created_by` | 8 KiB | 0 | FK a `profiles` | Mantener: respalda FK |
| `idx_establishment_location_reviews_reviewed_by` | `establishment_location_reviews` (~0-1) | `reviewed_by` | 8 KiB | 0 | FK a `profiles` | Mantener: respalda FK |

Suma: 5 × 16 KiB + 10 × 8 KiB = 160 KiB. (Hermanos de la misma migración que **sí** han sido escaneados: `idx_audit_log_actor_id` 1, `idx_establishments_updated_by` 1, `idx_establishment_location_history_changed_by` 1, `idx_followups_establishment_id` 4, `idx_import_records_candidate_establishment_id` 4; los usan las comprobaciones de FK cuando se borra o se actualiza algo en `profiles` o `establishments`.)

### 4.2 Otros índices del esquema (6)

| Índice | Tabla (filas) | Columnas | Tamaño | Escaneos | Motivo (origen) | Clasificación |
|---|---|---|---|---|---|---|
| `establishment_app_state_province_id_idx` | `establishment_app_state` (3) | `province_id` | 16 KiB | 0 | FK a `provinces` `ON DELETE CASCADE`; filtro natural por provincia (`20261017032027`). Las políticas RLS usan `province_id` como valor y buscan en `user_provinces`, no filtran esta tabla por él; la app tampoco filtra por provincia aquí, solo deja que RLS recorte | Mantener: respalda FK y volumen futuro (medido en 4.4) |
| `followups_due_idx` | `followups` (0) | `due_on` parcial `WHERE completed_at IS NULL` | 8 KiB | 0 | Bandeja de seguimientos pendientes por fecha (bootstrap inicial). Ninguna pantalla actual lo consulta | Revisar con volumen real o cuando exista la pantalla de seguimientos |
| `followups_assigned_idx` | `followups` (0) | `assigned_to` | 8 KiB | 0 | Seguimientos asignados a un usuario; además cubre la FK `followups_assigned_to_fkey` | Mantener: respalda FK |
| `permit_applications_follow_up_idx` | `permit_applications` (0) | `follow_up_on` parcial `WHERE follow_up_on IS NOT NULL` | 8 KiB | 0 | Aviso de próximos seguimientos de solicitudes (bootstrap). Tabla sin uso | Revisar con volumen real o cuando se use la tabla |
| `import_records_batch_status_idx` | `import_records` (0) | `(batch_id, status)` | 8 KiB | 0 | Cubre la FK `import_records_batch_id_fkey` y filtra registros de un lote por estado | Mantener: respalda FK (primera columna) |
| `establishment_app_state_history_est_changed_idx` | `establishment_app_state_history` (0) | `(establishment_id, changed_at DESC)` | 8 KiB | 0 | Historial de cambios por punto, ordenado (`20261018124030`, trigger y política `admin_read`). La tabla se creó hace menos de un día, aún sin filas | Mantener: tabla nueva, patrón de consulta previsto; revisar tras semanas con datos |

### 4.3 Índices que respaldan restricción (2)

| Índice | Tabla (filas) | Columnas | Tamaño | Escaneos | Motivo | Clasificación |
|---|---|---|---|---|---|---|
| `provinces_name_key` | `provinces` (52) | `name` UNIQUE | 16 KiB | 0 | Garantiza nombres de provincia únicos. Sin escaneos porque nadie busca por nombre | **No candidato a revisión**: no se puede quitar sin eliminar la restricción (esto es integridad de datos, no rendimiento) |
| `establishment_app_state_history_pkey` | `establishment_app_state_history` (0) | `id` PK | 8 KiB | 0 | Clave primaria de la tabla de historial | **No candidato a revisión**: es la PK |

### 4.4 Medición con volumen sintético (base local, no producción)

Base PostgreSQL 17 local reconstruida con `scripts/dev/rebuild-local-db.sh` y cargada con `supabase/tools/volume/load_synthetic_volume.sql` (50.000 puntos, 3.000 estados compartidos, 50.007 filas de auditoría). Después de `ANALYZE`, `EXPLAIN (ANALYZE, BUFFERS)` de la comprobación que hace PostgreSQL al borrar un padre (`SELECT ... FOR KEY SHARE` por la columna de la FK), con el índice y sin él (dentro de una transacción que se deshace):

| Comprobación | Con índice | Sin índice |
|---|---|---|
| `establishments WHERE created_by = <perfil sin puntos>` (50.000 filas) | Index Scan, 2 buffers, 0,023 ms | Seq Scan, 1.852 buffers, 7,1 ms |
| `establishment_app_state WHERE province_id = <provincia>` (3.000 filas, 71 coinciden) | Bitmap Index Scan, 58 buffers, 0,42 ms | Seq Scan, 109 buffers (251 en total), 0,35 ms |
| `establishment_app_state WHERE updated_by = <perfil>` (3.000 filas) | Index Scan, 2 buffers, 0,033 ms | Seq Scan, 108 buffers, 0,24 ms |

Lectura: con 50.000 puntos el planificador sí usa `idx_establishments_created_by` y la diferencia es de ~300 veces en tiempo y ~900 veces en páginas leídas. En `establishment_app_state` la diferencia es pequeña con 3.000 filas, pero crece linealmente con las filas. Matiz: en la carga sintética todos los puntos tienen el mismo `created_by`; la consulta con ese perfil usa Seq Scan porque coincide con casi toda la tabla (el planificador acierta), y la prueba de la tabla muestra el caso de un perfil sin puntos. Esto es una medición de **una** comprobación de FK en datos sintéticos; no incluye concurrencia, ni la carga real de borrados.

Las tablas con 0 filas (`followups`, `permit_*`, `import_*`, `establishment_app_state_history`) no se cargaron con datos sintéticos: la carga existente no las rellena y no hay consultas de la app que medir sobre ellas.

## 5. Conclusiones y recomendación

1. **No se propone eliminar ninguno.** De los 23: 18 respaldan una clave foránea (15 de la migración `20261017120547` + `establishment_app_state_province_id_idx`, `followups_assigned_idx` e `import_records_batch_status_idx`), 2 respaldan una restricción (PK y UNIQUE) y 3 no respaldan FK (`followups_due_idx`, `permit_applications_follow_up_idx`, `establishment_app_state_history_est_changed_idx`) pero pertenecen a tablas vacías o recién creadas.
2. Todos juntos pesan 232 KiB (1,7 % de la base); su coste hoy es irrelevante y el ahorro de quitarlos también.
3. Con 16 días de estadísticas, 791 puntos y tablas vacías, «0 escaneos» es el resultado esperado y no es evidencia contra el índice.
4. El aviso del asesor `unused_index` (21) debe tratarse como informativo y aceptado, igual que el aviso de contraseñas filtradas es conocido; si se quiere silenciar, hay que decidirlo con el titular (no se hace aquí).

## 6. Qué haría falta para revisarlos con base

1. **Más tiempo de estadísticas**: revisar de nuevo con 8-12 semanas desde `stats_reset` y con la funcionalidad de seguimientos/solicitudes/importaciones en uso (hoy ninguna pantalla las consulta). Repetir la consulta de la sección 7 y comparar `idx_scan`.
2. **Volumen real**: con 50.000 puntos o más y varios usuarios, repetir la consulta de uso. Candidatos a vigilar cuando haya datos: `followups_due_idx`, `permit_applications_follow_up_idx` (solo valen si se crea una bandeja por fecha) y, entre las FK de `created_by`/`updated_by`, las de tablas que nunca se llenen.
3. **Medir con `EXPLAIN` en local con carga sintética** (nunca producción): reconstruir con `scripts/dev/rebuild-local-db.sh`, cargar `supabase/tools/volume/load_synthetic_volume.sql`, ampliar la carga para llenar `followups`/`permit_applications`/`permit_grants`/`establishment_app_state_history` (hoy no lo hace), `ANALYZE`, y comparar con y sin el índice dentro de `BEGIN; DROP INDEX ...; EXPLAIN (ANALYZE, BUFFERS) ...; ROLLBACK;` (como en 4.4) las consultas que genere la futura pantalla y las comprobaciones de FK (`DELETE` de un perfil/provincia de prueba).
4. **Criterio de decisión sugerido** (a validar con el titular): solo plantear retirar un índice que (a) no respalde PK/UNIQUE/FK, (b) lleve 0 escaneos tras el periodo anterior con la funcionalidad correspondiente en uso, (c) no mejore ningún `EXPLAIN` con volumen sintético y (d) se retire con migración reversible, prueba y paso en `schema-smoke.yml`, con aprobación expresa. Hoy ninguno cumple (a)-(c) con datos.

## 7. Consulta de repetición (solo lectura)

```sql
select s.relname, s.indexrelname, s.idx_scan, s.idx_tup_read,
       pg_relation_size(s.indexrelid) as bytes, i.indisunique, i.indisprimary,
       (select stats_reset from pg_stat_database where datname = current_database()) as stats_reset
from pg_stat_user_indexes s
join pg_index i on i.indexrelid = s.indexrelid
where s.schemaname = 'public' and s.idx_scan = 0
order by bytes desc, s.relname;
```

## 8. Qué no se pudo verificar

- No se ha medido el efecto real de borrar un perfil o una provincia en producción (solo en datos sintéticos locales; correcto por las reglas).
- No se revisó una a una cada política RLS de tablas sin uso más allá de las de `permit_applications`, `permit_grants`, `followups`, `establishment_location_reviews` y `establishment_app_state`; no se encontró ninguna que busque por las columnas de estos índices.
- No se puede demostrar desde SQL que `pg_stat` no se reiniciara parcialmente por una caída entre el 02/10 y el 18/10.
- No se midió el tamaño de transferencia ni el uso de índices por consultas del propio Supabase (Auth, Storage, PostgREST) más allá de lo que acumula `pg_stat_user_indexes`, que ya las incluye.
- Las tablas sin filas no tienen estadísticas (`reltuples = -1`): su comportamiento con datos reales es una proyección, no una medición.
