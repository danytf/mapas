# Auditoría de solicitudes, concesiones, panel resumen y calendario (23/10/2026)

Alcance de este documento: diagnóstico verificado contra `main` (5040588) y contra producción (solo lectura), reglas de negocio adoptadas y estado de cada mejora. La migración al modelo relacional queda diseñada aquí y **no está ejecutada** (ver «Pendiente»).

## 1. Hipótesis del encargo: verificación

| # | Hipótesis | Resultado | Evidencia |
|---|---|---|---|
| 1 | Solicitudes y concesiones viven como arrays en `establishment_app_state.state` | **Confirmada** | claves `solicitudes` e `historial` del JSONB; `savePermits` escribe solo esa tabla |
| 2 | Existen `permit_applications`, `permit_grants`, `followups` | **Confirmada** | `supabase/bootstrap/202610160001_initial_schema.sql`, con RLS, triggers de coherencia y guardas |
| 3 | Las tablas relacionales están vacías; 12 filas de estado, 3 solicitudes, 5 concesiones | **Confirmada** (consulta del 23/10/2026): 0/0/0 en las tres tablas, 12 filas en `establishment_app_state`, 3 solicitudes y 5 entradas de `historial`, 3 filas de `establishment_app_state_history` | `execute_sql` de solo lectura |
| 4 | «Conceder» borra la solicitud y no deja vínculo | **Confirmada y corregida** | `sols.splice(i, 1)` + `hist.push(...)`. Ahora la solicitud queda como `aprobada` con `resFecha` y `conc`, y la concesión lleva `sol` |
| 5 | Mensajes de éxito antes de la confirmación | **Confirmada y corregida** | `s-msg` mostraba «Solicitud guardada» antes de `await commit()`. Ahora `commit()` devuelve `true` solo si Supabase confirma |
| 6 | Panel con el estado agregado, no con expedientes | **Confirmada y corregida** | `stat()` contaba puntos por estado resumido (un punto concedido con otra solicitud pendiente no contaba como solicitado) |
| 7 | Vencimientos ocultos si hay otra concesión sin fin | **Confirmada y corregida** | `!v.some(h => !h.hasta ...)` en `soon` |
| 8 | Calendario histórico calculado con el estado actual | **Confirmada y corregida** | ver §3 |
| 9 | `today()` con `toISOString()` | **Confirmada y corregida** | desfase entre 00:00 y 02:00 en verano; ahora `Intl` con `Europe/Madrid` y aritmética de fechas en UTC puro |
| 10 | Versiones, conflictos y auditoría que hay que preservar | **Confirmada y preservada** | `version`, `saveSharedPermitRow` con verificación de lectura, historial de estado |

### Defectos adicionales hallados

- **Cambio fantasma tras un fallo de guardado (P1).** `commit()` tomaba la instantánea de la ficha *después* de mutar las listas, de modo que al fallar restauraba la lista ya mutada: la solicitud o concesión seguía visible aunque no estaba guardada. Ahora hay una copia de lo último confirmado (`base`) y, tras un fallo, se relee lo guardado en Supabase antes de decir nada.
- **Editar una concesión cancelada la reactivaba** sin avisar (el objeto se reconstruía sin `cancelada`). Ahora se conservan `id`, `sol`, `alta`, `cancelada`, `resFecha` y `motivo`.
- **Doble clic en «Conceder»** podía crear dos concesiones (las acciones se ejecutan en un `setTimeout`). Ahora se ignoran las pulsaciones con un guardado en curso y las solicitudes ya resueltas.
- Una solicitud nueva podía nacer ya caducada; ahora se rechaza.
- Estado del punto: con todas las solicitudes retiradas devolvía «denegado».

## 2. Reglas de negocio (bloque «Reglas de expedientes» de `index.html`, probadas en `scripts/test-expedientes.mjs`)

- **Unidades.** Solicitud, concesión y seguimiento son registros distintos; cada cifra declara su unidad.
- **Solicitud:** pendiente → aprobada | denegada | retirada; `caducada` si sus fechas pasan sin respuesta. Guarda `fecha` (alta), `resFecha`, `motivo`, `conc`, contacto y notas propios.
- **Concesión:** vigente | futura | terminada | cancelada (con `resFecha` y `motivo`).
- **Fechas:** inclusivas por los dos extremos; «hoy» es la fecha de `Europe/Madrid`.
- **Captadores:** dentro de un punto y una ONG se toma el mayor (una ampliación o un duplicado no se cuenta dos veces); entre ONG distintas se suma; entre puntos se suma. Autorizados (concesiones) y por aprobar (solicitudes) no se suman.
- **Vencimientos:** por concesión, en tramos 0–7, 8–15 y 16–30 días; una concesión sin fin no oculta a las demás.
- **Estancada:** solicitud pendiente con más de 15 días desde su alta (`UMBRAL_ESTANCADA`).
- **Resolución y tiempo medio:** solo con datos que lo permiten. Las solicitudes anteriores no guardaban fecha de decisión: el tiempo medio se calcula sobre las que la tienen y se muestra el tamaño de la muestra.
- **Pasado del calendario:** se reconstruye solo lo que consta (fecha de alta y de decisión; fecha de cancelación). Lo que necesita una fecha que no se guardó aparece como «estado ese día no registrado», en el histórico, y no suma. Una cronología de eventos completa necesita el modelo relacional con eventos (ver §4).

## 3. Cambios de esta rama (IMPLEMENTADO y PROBADO AUTOMÁTICAMENTE; sin cambios en Supabase)

- Ficha: guardado verificable, vuelta a lo confirmado, aprobar conservando la solicitud, denegar y retirar con motivo, cancelar con motivo, borrar con confirmación, contacto y notas por expediente, validación de captadores y fechas, `id` por expediente.
- Panel: tareas de hoy, solicitudes, concesiones (vigentes, próximas, por vencer), incoherencias, capacidad por ONG; cada cifra abre la lista exacta; filtros de provincia y ONG persistentes; acceso al expediente en la pestaña correcta.
- Calendario: autorizados, por aprobar y seguimientos por separado; histórico oculto por defecto; vista por ONG; avisos de vencimiento, inicio y atraso; aviso en semanas pasadas y futuras.
- Saneado del estado compartido ampliado (`id`, `res`, `conc`, `sol`, `alta`, `resFecha`, `motivo`, contacto y notas); compatible con filas anteriores.

## 4. Pendiente: migración al modelo relacional (diseño, no ejecutada)

Decisión: las tablas `permit_applications`, `permit_grants` y `followups` son la fuente operativa objetivo (ya tienen estados, restricciones de fechas, vínculo `application_id`, triggers de coherencia, RLS por provincia y guardas de campos inmutables). Hace falta una migración **aditiva** para:

1. `permit_events` (tabla de eventos del ciclo de vida: creada, editada, aprobada, denegada, retirada, cancelada, con autor, fecha y motivo), con RLS por provincia del establecimiento.
2. Columnas: `resolved_at`, `resolved_by`, `resolution_reason` en solicitudes; `legacy_ref` único (idempotencia del volcado); `contact`/`notes` ya existen.
3. Funciones RPC atómicas `SECURITY INVOKER`: `approve_permit_application(id, grant_data, request_key)` (actualiza la solicitud, crea la concesión y el evento en una transacción; idempotente por clave de petición), `resolve_permit_application`, `cancel_permit_grant`.
4. Volcado idempotente del JSONB (3 solicitudes, 5 concesiones) con `legacy_ref = md5(establecimiento + tipo + contenido canónico + n.º de repetición)`; no se inventan vínculos solicitud-concesión de los datos antiguos (las 5 concesiones actuales no tienen solicitud demostrable).
5. Criterio para dejar de leer y escribir los arrays: reconciliación sin diferencias (recuentos, fechas, captadores, ONG, estados, establecimientos) y una versión de la app que lea y escriba solo en las tablas.
6. Reversión: el volcado no modifica el JSONB; revertir es volver a la versión anterior de la app y marcar `legacy_ref` como retirados.
7. Pruebas SQL en PostgreSQL local (matriz RLS ampliada, aislamiento Granada/Málaga, doble ejecución, doble aprobación) y paso en `schema-smoke.yml`.

Esto exige aplicar una migración y escribir datos en producción: requiere autorización expresa del titular y una copia previa (`scripts/backup-supabase.sh`).

## 5. Validación manual necesaria

- Revisión del titular con datos reales: panel, calendario y flujo aprobar/denegar.
- Móvil físico y lector de pantalla (no probados).
- Probado en navegador solo con el Supabase simulado (`scripts/dev/mock-supabase.mjs`, ahora con `/__fail` para simular fallos y respuestas perdidas); no prueba RLS real.
