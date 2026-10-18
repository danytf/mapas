# Auditoría — Fase B (seguridad y persistencia)

**Fecha:** 18/10/2026 · **Base:** `main` en `2b721f3` · **Proyecto Supabase:** `wwoczmihhupofwmlmgga`

Este documento recoge solo lo que se ha ejecutado y su resultado. Las limitaciones están en la sección 6.

## 1. Reconstrucción desde migraciones equivale a producción

El esquema se reconstruyó desde cero en PostgreSQL local aplicando los ficheros en el orden de `schema-smoke.yml`. Se calculó una huella MD5 de cada bloque en la base local y, con la misma consulta de solo lectura, en producción:

| Bloque | Elementos | Huella (8 primeros caracteres) | Local = producción |
|---|---|---|---|
| Políticas RLS (`public`) | 50 | `6bbc89fb` | sí |
| Privilegios de tabla para `anon`/`authenticated`/`PUBLIC` | 56 | `b3201656` | sí |
| Funciones propias de `public` (sin extensiones ni `rls_auto_enable` de Supabase) | 17 | `bfc221b1` | sí |
| Funciones de `private` | 3 | `de9d04b4` | sí |
| Triggers de `public` | 32 | `5643370d` | sí |
| Tablas con RLS habilitado | 16 | `ffc09271` | sí |

La huella de funciones incluye propietario de ejecución (`SECURITY DEFINER`), `search_path` y permiso de ejecución de `anon`/`authenticated`; no incluye el cuerpo de las funciones.

## 2. Matriz de autorización (`supabase/tests/rls_matrix.sql`)

- **Alcance:** 16 tablas, 7 actores (administrador, usuario de la provincia G, usuario de otra provincia O, usuario activo sin provincia, usuario desactivado con provincia asignada, segundo usuario de la provincia G, y rol `anon`), y las operaciones `SELECT`/`INSERT`/`UPDATE`/`DELETE` (más `update_location` / `update_master` en el catálogo y `delete_referenced` en solicitudes y concesiones).
- **Resultado:** 973 celdas, 0 discrepancias, 0 inconclusas; 781 denegaciones esperadas comprobadas.
- **Método:** cada celda se ejecuta bajo el rol de API real (`set local role`) con el usuario suplantado mediante `request.jwt.claim.sub`, dentro de una subtransacción que siempre se revierte. La expectativa sale de la función `expected()`, escrita aparte de las políticas, y no de leer las políticas. Una celda que termina por un error distinto de una denegación (por ejemplo una clave foránea) se marca como inconclusa y hace fallar la prueba: esa celda no estaría probando lo que dice probar.
- **Validez de la prueba:** ejecutada sin la migración de H-10 falla (2 discrepancias, ver sección 3). Esto demuestra que la matriz detecta una regresión real.
- **Datos:** sintéticos, dentro de una transacción que termina en `ROLLBACK`.

Comportamientos verificados que conviene conocer:

- Un usuario activo con provincia puede **actualizar** solicitudes, concesiones y seguimientos de su provincia aunque no los haya creado (lo comprueba el segundo usuario de la provincia G). El borrado es solo de administración. Es el comportamiento actual de equipo provincial; **no hay documento que fije que deba ser así** (ver H-04).
- Un usuario desactivado conserva lectura de las tablas de referencia y de su propio perfil y asignaciones, y pierde todo lo demás.
- Nadie, ni la administración, puede escribir directamente en `audit_log` ni en `establishment_location_history` a través de la API (solo lectura).
- Borrar una solicitud o concesión con seguimientos asociados se rechaza incluso para administración (`followups.application_id`/`grant_id` son inmutables): fallo cerrado, sin pérdida de datos. Queda fijado por la matriz.

## 3. Defecto confirmado y corregido — H-10 (P2)

**Qué pasaba:** borrar un perfil (o su usuario de Auth) que hubiera creado cualquier registro fallaba siempre con «El campo created_by no se puede modificar después de crear el registro». Las claves foráneas `*_created_by_fkey` usan `ON DELETE SET NULL`, pero `guard_sensitive_updates()` declara `created_by` inmutable y rechazaba esa misma acción referencial. En el borrado desde Auth (sin usuario suplantado, `is_admin()` falso) el segundo control del guard, la lista de columnas editables por no administradores, también lo rechazaba para el catálogo.

**Impacto real:** no hay pérdida ni corrupción de datos (el fallo es cerrado). Impide la baja definitiva de cualquier persona que haya dado de alta algo, y el mensaje confunde. `docs/ADMINISTRACION_CUENTAS.md` recomienda desactivar en lugar de borrar, de modo que el flujo habitual no se ve afectado.

**Corrección:** `supabase/migrations/20261018123313_allow_author_set_null_on_profile_delete.sql`. `created_by` solo puede pasar a `NULL` cuando el perfil que figuraba como autor ya no existe, en los dos controles del guard. Mientras el autor exista, la inmutabilidad sigue intacta.

**Pruebas de regresión (en `rls_matrix.sql`):**

- Baja real de una persona autora sin usuario suplantado: se eliminan perfil, asignaciones y estado personal; las solicitudes, concesiones, seguimientos y propuestas de ubicación y el establecimiento que creó se conservan con `created_by` nulo.
- Un usuario normal no puede anular ni reasignar `created_by` mientras el autor existe (solicitudes y catálogo).
- Un registro huérfano no se puede volver a atribuir a otra persona, ni siquiera por administración.
- Un administrador no puede borrar su propio perfil mientras es autor de registros: sigue rechazado. No se amplía el alcance a ese caso.

## 4. Persistencia local del navegador (revisión estática)

Búsqueda exhaustiva en `index.html`: `localStorage`, `sessionStorage`, `indexedDB`, `caches`, `document.cookie`, `serviceWorker`, `navigator.storage`, `openDatabase`, `BroadcastChannel`, `SharedWorker`, `window.name`, History API, `eval`, `new Function` e `import()`.

- Las únicas referencias a Web Storage son la limpieza de claves heredadas del propio mapa mediante `removeItem` (líneas 573–579). No hay `setItem` contra Web Storage.
- La sesión de Supabase usa un adaptador con objeto en memoria (líneas 2235–2237).
- No hay IndexedDB, Cache Storage, cookies, service workers, History API ni código dinámico.
- Las exportaciones (`Blob` + `a[download]`, líneas 1984–1985) son descargas iniciadas por la persona usuaria, no persistencia en el navegador.

Comprobación en producción con la página cargada: 0 service workers, 0 Cache Storage, 0 bases IndexedDB y 0 claves en `sessionStorage`. `localStorage` del origen contiene 12 claves, ninguna de ellas aparece en el código del mapa: pertenecen a otras aplicaciones del mismo origen `danytf.github.io`.

## 5. Cambios de CI

- `schema-smoke.yml`: aplica la nueva migración, ejecuta `rls_matrix.sql` y añade un paso que **falla si algún fichero de `supabase/migrations/` no está en el workflow**. Hasta ahora la lista de migraciones era manual y una migración nueva no listada no se validaba.

## 6. Límites de esta evidencia

- La matriz se ejecutó en **PostgreSQL 16** local; el CI usa PostgreSQL 17. Ambas versiones ejecutan el mismo SQL; el paso del CI es la confirmación definitiva.
- Se simula Supabase Auth con un shim mínimo (`auth.users`, `auth.uid()`). No se ejercitan PostgREST, GoTrue, JWT reales ni sesiones caducadas: eso corresponde a las pruebas de navegador de la Fase C.
- La migración H-10 **no se ha aplicado a producción**. Requiere autorización expresa.
- Quedan fuera de esta fase: pruebas de concurrencia entre dos usuarios (capa 5), rendimiento, accesibilidad y restauración de backup.


## Aplicación en producción de la migración H-10

Autorizada por el titular el 2026-10-18. Aplicada en Supabase (proyecto `wwoczmihhupofwmlmgga`) con versión `20261018123313`; el fichero del repositorio usa esa misma versión para mantener el libro de migraciones alineado.

Verificación posterior en producción: la función `guard_sensitive_updates` contiene la excepción `author_removed`; ACL sin cambios (solo `postgres` y `service_role`); huellas sin variación: políticas 50 `6bbc89fb`, permisos de tabla 56 `b3201656`, triggers 32 `5643370d`, funciones públicas (sin `rls_auto_enable`, función de la plataforma) 17 `bfc221b1`.
