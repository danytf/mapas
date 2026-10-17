# Pruebas de aceptación del esquema y de RLS

**Objetivo:** comprobar que la base de datos impone los permisos aunque alguien invoque la API directamente, sin depender de los controles visuales de la aplicación.

**Estado actualizado a 17 de octubre de 2026:** las migraciones están aplicadas al proyecto Supabase de desarrollo `wwoczmihhupofwmlmgga`. La revisión directa confirma que las 16 tablas públicas tienen RLS habilitado, que no hay privilegios de tabla concedidos a `anon` ni a `PUBLIC`, y que las políticas por tabla usan ámbitos de usuario/provincia o administración. El catálogo activo contiene 791 establecimientos con coordenadas y referencias de origen únicas.

La suite de GitHub Actions ejecuta los smoke tests en PostgreSQL 16 con una capa mínima de compatibilidad para Supabase Auth; esto comprueba integridad, triggers y escenarios limitados de RLS, pero no equivale a probar todos los permisos efectivos con sesiones reales de Supabase. La matriz negativa completa descrita en este documento sigue pendiente de ejecución contra usuarios de prueba autenticados en un entorno aislado. No se deben marcar las pruebas de acceso entre provincias como completas solo por haber inspeccionado las políticas.



## Resultados de comprobación limitada en Supabase real (17/10/2026)

Se ejecutaron consultas como rol `authenticated`, con `auth.uid()` establecido para las cuentas de prueba existentes. Las pruebas de actualización se ejecutaron dentro de transacciones que terminaron en `ROLLBACK`; no dejaron cambios persistentes.

| Prueba | Resultado |
|---|---|
| Administrador: lectura de establecimientos | 792 visibles en total: 791 activos y 1 registro de prueba archivado |
| Usuario asignado a Granada: lectura de Granada | 791 visibles |
| Usuario asignado a Granada: lectura del registro de prueba de Málaga | 0 visibles |
| Usuario asignado a Málaga: lectura del registro de prueba de Málaga | 1 visible |
| Usuario asignado a Málaga: lectura de Granada | 0 visibles |
| Usuario Granada: actualización dentro de Granada con `updated_by = auth.uid()` | 1 fila afectada |
| Usuario Granada: actualización del registro de Málaga | 0 filas afectadas |
| Usuario Málaga: actualización del registro de Málaga | 1 fila afectada |
| Usuario Málaga: actualización de un establecimiento de Granada | 0 filas afectadas |
| Estado personal: cada usuario lee su propia fila | 1 fila visible para cada usuario probado |
| Estado personal: leer la fila del otro usuario | 0 filas visibles |
| Estado compartido: usuario Granada | 2 filas visibles, todas de una provincia |
| Estado compartido: usuario Málaga | 1 fila visible, de una provincia |

Esto confirma el aislamiento básico de lectura y actualización entre las dos provincias y la propiedad del estado personal para las cuentas probadas. El registro de Málaga utilizado es un establecimiento de prueba archivado; no forma parte de los 791 establecimientos activos del mapa.

**No equivale a la aceptación RLS completa.** Siguen pendientes las pruebas de inserción/eliminación no autorizadas, perfiles desactivados, sesiones caducadas, matriz de permisos de todas las tablas, concurrencia y restauración aislada.


### Pruebas negativas adicionales

| Prueba | Resultado |
|---|---|
| Usuario Granada intenta actualizar el estado compartido de Málaga | 0 filas afectadas |
| Usuario Málaga actualiza su estado compartido | 1 fila afectada; transacción revertida |
| Usuario Granada intenta actualizar el estado personal de Málaga | 0 filas afectadas |
| Usuario Málaga intenta borrar el estado personal de Granada | 0 filas afectadas |
| Usuario estándar intenta cambiar su propio rol a `admin` | 0 filas afectadas |
| Usuario estándar intenta borrar su propia asignación provincial | 0 filas afectadas |
| Usuario autenticado intenta insertar directamente en `audit_log` | Denegado |
| Usuario autenticado intenta insertar directamente en `establishment_location_history` | Denegado |
| Usuario Granada intenta enviar otro UUID en `updated_by` al actualizar un establecimiento de Granada | El trigger `guard_sensitive_updates` sustituye el valor por `auth.uid()`; la prueba comprobó la identidad efectiva y revirtió la transacción |

Los intentos de escritura anteriores se realizaron en transacciones revertidas. No se dejaron cambios persistentes ni se alteraron coordenadas. El último caso no se rechaza con error: se neutraliza en el trigger de servidor, que fuerza el actor autenticado antes de que se evalúe la condición `WITH CHECK` de RLS.

## 1. Preparación de un entorno de desarrollo

1. Crear un proyecto Supabase separado de producción.
2. Ejecutar la migración inicial en el SQL Editor.
3. Crear tres usuarios mediante Supabase Auth: administrador, usuario A y usuario B.
4. Promover manualmente al primer usuario a administrador desde SQL Editor; no hacerlo desde el cliente.
5. Cargar dos provincias de prueba y asignar A a la provincia 1 y B a la provincia 2.
6. Crear al menos un establecimiento en cada provincia.
7. Usar únicamente datos ficticios para esta batería.

No importar archivos de navegador, copias JSON/CSV de las pruebas antiguas ni registros operativos anteriores.

## 2. Matriz de aislamiento

| Prueba | Usuario A (provincia 1) | Usuario B (provincia 2) | Administrador |
|---|---|---|---|
| Consultar establecimientos de provincia 1 | Permitido | No visible | Permitido |
| Consultar establecimientos de provincia 2 | No visible | Permitido | Permitido |
| Crear establecimiento en provincia asignada | Permitido, con `created_by = auth.uid()` | Permitido en la suya | Permitido con actor correcto |
| Crear establecimiento en provincia no asignada | Denegado por RLS | Denegado por RLS | Permitido |
| Leer perfiles de otros usuarios | Denegado | Denegado | Permitido |
| Cambiar su propio rol a `admin` | Denegado | Denegado | Solo administración autorizada |
| Cambiar asignaciones provinciales | Denegado | Denegado | Permitido |
| Leer solicitudes, concesiones y seguimientos de otra provincia | No visible | No visible | Permitido |
| Consultar el registro de auditoría | Denegado | Denegado | Permitido |
| Gestionar lotes de importación | Denegado | Denegado | Permitido |

**Importante:** en PostgREST/Supabase, las consultas RLS pueden devolver cero filas en vez de un error explícito. La prueba debe verificar que no se filtra ningún registro, no solo si la petición produce un error.

## 3. Pruebas negativas que no deben omitirse

- Usuario A no puede acceder por ID directo a un establecimiento de provincia 2.
- Usuario A no puede crear una solicitud, concesión, seguimiento o revisión de coordenadas vinculada a un establecimiento de provincia 2.
- Usuario A no puede modificar `province_id` de un establecimiento para moverlo fuera de su ámbito.
- Usuario A no puede alterar `role`, `is_active` o asignaciones mediante llamadas directas a la API.
- Un usuario autenticado sin perfil activo o sin asignaciones no ve datos operativos.
- Un usuario desactivado deja de tener acceso operativo aunque conserve sesión hasta que esta se renueve o revalide.
- No se puede asociar una concesión con una solicitud perteneciente a otro establecimiento; el trigger debe rechazarlo incluso en una llamada directa a la API.
- No se puede asociar un seguimiento a una solicitud o concesión de un establecimiento diferente; el trigger debe rechazarlo incluso en una llamada directa a la API.
- No se puede cambiar el establecimiento padre de una solicitud o concesión si con ello quedan hijos vinculados a otro establecimiento.
- Un establecimiento no puede vincularse a un municipio de otra provincia, y no puede cambiarse la provincia de un municipio si eso deja establecimientos con una relación incoherente.
- Cambiar latitud, longitud o dirección de un establecimiento genera automáticamente una fila en establishment_location_history; cambios en otros campos no deben crearla.
- Insertar, modificar o borrar registros en las entidades auditadas genera una fila en audit_log con actor, operación, tabla, ámbito provincial y nombres de campos, sin copiar valores de contacto/notas.
- Un usuario autenticado no puede insertar, actualizar ni borrar directamente filas de audit_log, ni consumir su secuencia desde la API.
- Un usuario autenticado, incluido el administrador, no puede insertar, modificar ni borrar directamente el historial de ubicación desde la API; las nuevas entradas deben proceder del trigger de servidor.
- Las actualizaciones simultáneas no deben sobrescribir silenciosamente cambios de otro usuario.
- La importación repetida de un mismo lote no debe crear establecimientos duplicados.
- Una coordenada marcada como aproximada en el catálogo fuente debe importarse con `location_precision = 'approximate'`; nunca debe presentarse como verificada sin revisión explícita.

## 4. Controles incorporados y riesgos por validar

La migración incorpora triggers de base de datos para:
1. Rechazar establecimientos cuyo municipio pertenezca a otra provincia.
2. Impedir que cambiar la provincia de un municipio rompa las relaciones existentes.
3. Rechazar concesiones cuya solicitud pertenezca a otro establecimiento.
4. Rechazar seguimientos cuya solicitud o concesión pertenezca a otro establecimiento.
5. Impedir reasignaciones del establecimiento padre que dejarían solicitudes, concesiones o seguimientos con relaciones cruzadas.
6. Registrar cambios efectivos de latitud, longitud o dirección en el historial de ubicación.
7. Escribir auditoría de servidor para establecimientos, solicitudes, concesiones, seguimientos, revisiones de ubicación, asignaciones provinciales y perfiles. El registro guarda nombres de campos cambiados, no sus valores potencialmente sensibles.
8. Mantener el historial de ubicación como solo lectura para los clientes; las inserciones las hace el trigger de servidor.

Los controles están implementados y la batería smoke pasa en PostgreSQL 16 en [GitHub Actions](https://github.com/danytf/mapas/actions/runs/38974728631). La prueba cubre aplicación de la migración, coherencia provincia-municipio, relaciones entre solicitudes/concesiones/seguimientos, prevención de reasignaciones incoherentes, historial y auditoría automáticos, bloqueo de escritura directa y aislamiento básico A/B. Antes de producción siguen pendientes:

1. **Supabase real:** aplicar la migración en un proyecto Supabase de desarrollo limpio y validar el comportamiento con sus roles, políticas y configuración reales.
2. **Matriz RLS completa:** ampliar la prueba a todas las tablas y operaciones, incluidos accesos por UUID, cambios de provincia, permisos de administrador y usuarios desactivados.
3. **Auditoría e historial en Supabase:** confirmar actor, permisos efectivos, retención y ausencia de datos sensibles en registros reales.
4. **Perfil desactivado:** probar sesiones ya abiertas tras desactivar un perfil y definir la revalidación/revocación necesaria.
5. **Campos de actualización:** confirmar que la capa de datos rellena updated_by con el usuario autenticado y que no puede suplantarse otro actor.
6. **Privilegios efectivos:** revisar roles, tablas, secuencias y políticas del proyecto real para detectar permisos heredados o adicionales.
7. **Integración automatizada:** extender la suite PostgreSQL actual y añadir pruebas contra Supabase local/CI.
8. **Catálogos:** preparar semillas verificadas de provincias, municipios y categorías, separadas de los datos de negocio.

audit_log no concede escritura directa al rol authenticated; la escritura se realiza mediante triggers de servidor. Las funciones de trigger tienen search_path vacío y no se exponen como operaciones RPC.

## 5. Criterio de salida para ampliar el ámbito y dar por aceptada la seguridad

La app ya está conectada a Supabase para el catálogo de Granada. No debe ampliarse a otras provincias ni darse por completada la aceptación de seguridad hasta que:
- pase la matriz negativa completa con usuarios autenticados de distintas provincias y un administrador en un entorno aislado;
- se comprueben perfiles desactivados, sesiones caducadas y conflictos de edición concurrente;
- la integridad entre establecimientos, solicitudes, concesiones y seguimientos se pruebe también con sesiones reales, no solo mediante smoke tests;
- el primer administrador y la recuperación de acceso estén documentados;
- se genere una copia lógica completa y se restaure en un entorno aislado;
- quede confirmado que no se importará estado local de pruebas;
- se decida y documente si el estado operativo seguirá en `establishment_app_state` JSONB o migrará a las tablas normalizadas, antes de modificar ese modelo.
