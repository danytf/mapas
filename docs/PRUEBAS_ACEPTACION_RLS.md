# Pruebas de aceptación del esquema y de RLS

**Objetivo:** comprobar que la base de datos impone los permisos aunque alguien invoque la API directamente, sin depender de los controles visuales de la aplicación.

Este plan acompaña a `supabase/migrations/202610160001_initial_schema.sql`. No sustituye la ejecución de las pruebas contra un proyecto Supabase de desarrollo. No se han creado credenciales ni se ha aplicado la migración a ningún proyecto.

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
- Cambiar latitud, longitud o dirección de un establecimiento genera automáticamente una fila en establishment_location_history; cambios en otros campos no deben crearla.
- Insertar, modificar o borrar registros en las entidades auditadas genera una fila en audit_log con actor, operación, tabla, ámbito provincial y nombres de campos, sin copiar valores de contacto/notas.
- Un usuario autenticado no puede insertar, actualizar ni borrar directamente filas de audit_log, ni consumir su secuencia desde la API.
- Un usuario autenticado, incluido el administrador, no puede insertar, modificar ni borrar directamente el historial de ubicación desde la API; las nuevas entradas deben proceder del trigger de servidor.
- Las actualizaciones simultáneas no deben sobrescribir silenciosamente cambios de otro usuario.
- La importación repetida de un mismo lote no debe crear establecimientos duplicados.
- Una coordenada aproximada nunca debe presentarse como verificada sin una revisión explícita.

## 4. Controles incorporados y riesgos por validar

La migración incorpora triggers de base de datos para:
1. Rechazar concesiones cuya solicitud pertenezca a otro establecimiento.
2. Rechazar seguimientos cuya solicitud o concesión pertenezca a otro establecimiento.
3. Impedir reasignaciones del establecimiento padre que dejarían solicitudes, concesiones o seguimientos con relaciones cruzadas.
4. Registrar cambios efectivos de latitud, longitud o dirección en el historial de ubicación.
5. Escribir auditoría de servidor para establecimientos, solicitudes, concesiones, seguimientos, revisiones de ubicación, asignaciones provinciales y perfiles. El registro guarda nombres de campos cambiados, no sus valores potencialmente sensibles.
6. Mantener el historial de ubicación como solo lectura para los clientes; las inserciones las hace el trigger de servidor.

Estos controles están **implementados en el archivo SQL, pero aún no están validados mediante ejecución en PostgreSQL/Supabase**. Antes de producción siguen pendientes:

1. **Aplicación real:** ejecutar la migración en un proyecto Supabase de desarrollo limpio y resolver cualquier error de sintaxis, permisos o comportamiento de triggers.
2. **Pruebas RLS:** ejecutar toda la matriz de aislamiento con usuarios A/B y administrador, incluyendo accesos directos por UUID y cambios de provincia.
3. **Auditoría e historial:** comprobar que los triggers escriben incluso con RLS activo, que el actor es correcto y que no se filtran valores sensibles.
4. **Perfil desactivado:** probar sesiones ya abiertas tras desactivar un perfil y definir la revalidación/revocación necesaria.
5. **Campos de actualización:** confirmar que la capa de datos rellena updated_by con el usuario autenticado y que no puede suplantarse otro actor.
6. **Privilegios efectivos:** revisar roles, tablas, secuencias y políticas del proyecto real para detectar permisos heredados o adicionales.
7. **Pruebas automatizadas:** trasladar esta matriz a tests de integración contra Supabase local/CI.
8. **Catálogos:** preparar semillas verificadas de provincias, municipios y categorías, separadas de los datos de negocio.

audit_log no concede escritura directa al rol authenticated; la escritura se realiza mediante triggers de servidor. Las funciones de trigger tienen search_path vacío y no se exponen como operaciones RPC.

## 5. Criterio de salida

No conectar el frontend ni cargar el catálogo nacional hasta que:
- la migración se aplique limpiamente en un proyecto de desarrollo;
- todas las pruebas negativas de aislamiento pasen;
- la integridad entre establecimientos, solicitudes, concesiones y seguimientos esté protegida en la base de datos;
- la auditoría e historial de coordenadas estén implementados;
- el primer administrador y la recuperación de acceso estén documentados;
- quede confirmado que no se importará estado local de pruebas.
