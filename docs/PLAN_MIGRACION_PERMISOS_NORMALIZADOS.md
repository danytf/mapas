# Plan de migración de permisos a tablas normalizadas

**Estado:** diseño previo; no ejecutado.  
**Fecha:** 17 de octubre de 2026.  
**Objetivo:** definir una migración reversible desde `establishment_app_state.state` (JSONB) hacia `permit_applications`, `permit_grants` y `followups`, sin pérdida de datos ni interrupción del mapa.

## 1. Estado real comprobado

En el proyecto Supabase de desarrollo:

- `establishment_app_state`: 3 filas.
- `permit_applications`: 0 filas.
- `permit_grants`: 0 filas.
- `followups`: 0 filas.
- `user_app_state`: 3 filas; esta tabla no forma parte de la migración de permisos.

La interfaz actual guarda un objeto por establecimiento en `establishment_app_state.state`. El catálogo maestro sigue siendo `establishments`; no se debe copiar ni recrear durante esta migración. La app filtra y sanitiza el JSONB antes de renderizarlo.

## 2. Correspondencia inicial de datos

| JSONB actual | Tabla normalizada candidata | Notas |
|---|---|---|
| `solicitudes[].desde` / `hasta` | `permit_applications.requested_from` / `requested_until` | Fechas solicitadas, no fechas de concesión. |
| `solicitudes[].fecha` | `permit_applications.requested_at` | Fecha en que se pidió el permiso; debe conservarse aunque falten fechas del intervalo. |
| `solicitudes[].seg` | `permit_applications.follow_up_on` y/o `followups.due_on` | Decidir si representa el siguiente seguimiento planificado o una actividad de seguimiento; no duplicarlo automáticamente. |
| `solicitudes[].ong` / `captadores` | `permit_applications.organization` / `capturer_count` | Validar conteos y texto antes de insertar. |
| `solicitudes[].res` | `permit_applications.status` | `denegada` debe convertirse al valor de estado aceptado por el esquema; no asumir que todas las solicitudes sin `res` siguen vigentes sin evaluar sus fechas. |
| `historial[].desde` / `hasta` | `permit_grants.valid_from` / `valid_until` | Intervalo de vigencia concedida. |
| `historial[].ong` / `captadores` | `permit_grants.organization` / `capturer_count` | Mantener una concesión distinta por cada entrada histórica. |
| `historial[].cancelada` | `permit_grants.status`, `cancelled_at` / `cancelled_reason` | El booleano antiguo no aporta fecha ni motivo de cancelación; no inventarlos. |
| `contacto`, `notas` | Campos de aplicación/concesión, solo cuando su relación sea inequívoca | En el JSONB son datos del establecimiento y no siempre se sabe a qué solicitud o concesión corresponden. No duplicarlos en todas las filas. |
| `valoracion` | Sin destino equivalente confirmado | Es una valoración por establecimiento; no descartarla ni asignarla a una solicitud. Mantenerla en JSONB durante la transición o diseñar un campo/tabla específica. |
| `estado`, `fecha`, `seguimiento` de nivel superior | Campos derivados o legado | El estado actual se calcula a partir de solicitudes y concesiones. Los registros antiguos sin historial necesitan una política de conservación explícita. |

Los nombres de propiedades y estados deben contrastarse con el esquema y los tests en el momento de implementar; esta tabla es una guía de diseño, no un script de conversión.

## 3. Secuencia propuesta

1. **Congelar el contrato de datos.** Documentar estados permitidos, si las solicitudes denegadas se conservan, cómo se representa una concesión cancelada y qué significa cada fecha.
2. **Copia de seguridad y restauración aislada.** Obtener una copia lógica completa de Supabase y demostrar que puede restaurarse en un proyecto de prueba antes de tocar datos operativos.
3. **Migrador de solo lectura.** Leer el JSONB y generar un informe por establecimiento: solicitudes, concesiones, campos sin destino y entradas rechazadas. El primer modo no escribe en tablas.
4. **Validación del informe.** Exigir conteos exactos, UUID de establecimiento/provincia válidos, fechas ISO reales, contadores enteros, ausencia de duplicados y cero pérdidas silenciosas. Resolver manualmente los campos ambiguos.
5. **Migración transaccional en entorno aislado.** Insertar solicitudes, concesiones y seguimientos preservando el orden histórico y la relación con `establishment_id`. No modificar el JSONB original. Comprobar el resultado comparando cada entrada con su origen.
6. **API de escritura atómica.** Antes de cambiar la interfaz, decidir una función RPC o transacción del lado servidor que guarde la solicitud/concesión y su seguimiento relacionados de forma atómica. No hacer una serie de peticiones cliente que pueda dejar solo parte de la operación guardada.
7. **Pruebas de paridad.** Comparar la representación actual del popup con la nueva para solicitudes pendientes/denegadas/caducadas, concesiones pasadas/vigentes/futuras/canceladas, fechas, ONG, captadores, contacto, notas y valoración.
8. **Cambio de lectura controlado.** Solo tras superar las pruebas, cambiar la interfaz a las tablas normalizadas. Mantener el JSONB original sin borrar durante el periodo de validación.
9. **Reversión.** Si falla una prueba, volver a la lectura JSONB. No hacer una sincronización inversa automática desde tablas parcialmente migradas.
10. **Retirada posterior.** Solo cuando se confirme paridad en uso real, decidir si conservar el JSONB como archivo histórico o retirarlo en otra migración separada.

## 4. Pruebas de aceptación obligatorias

- Migración repetible sin duplicar solicitudes, concesiones ni seguimientos.
- Toda fila nueva referencia un UUID maestro existente y la provincia coincide con el establecimiento.
- RLS permite operar únicamente dentro de las provincias asignadas y bloquea la lectura/escritura fuera de ámbito.
- Un fallo a mitad de la operación no deja una solicitud sin sus cambios relacionados.
- Un timeout con respuesta ambigua se verifica antes de declarar éxito.
- La representación del popup antes/después es equivalente para todos los casos de prueba.
- No se modifican direcciones ni coordenadas del catálogo maestro.
- El informe final enumera explícitamente los campos que no pudieron migrarse automáticamente; no se descarta ningún dato sin decisión documentada.

## 5. Decisiones que deben cerrarse antes de implementar

- Si una solicitud denegada debe permanecer como `permit_applications.status` o convertirse en otro registro.
- Si `seg` genera una fecha planificada en la solicitud o una fila de `followups`.
- Dónde conservar la valoración y los datos de contacto/notas a nivel de establecimiento.
- Cómo representar estados históricos sin fechas y concesiones canceladas sin fecha/motivo.
- Si el JSONB se mantiene como archivo tras la migración y durante cuánto tiempo.

**Recomendación:** no migrar todavía la interfaz. El volumen actual es pequeño, pero hay campos con semántica que no se puede inferir con seguridad. Primero cerrar las decisiones y probar el migrador sobre una copia aislada.
