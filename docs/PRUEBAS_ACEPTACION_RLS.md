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
- No se puede asociar una concesión con una solicitud perteneciente a otro establecimiento.
- No se puede asociar un seguimiento a una solicitud o concesión de un establecimiento diferente.
- Las actualizaciones simultáneas no deben sobrescribir silenciosamente cambios de otro usuario.
- La importación repetida de un mismo lote no debe crear establecimientos duplicados.
- Una coordenada aproximada nunca debe presentarse como verificada sin una revisión explícita.

## 4. Riesgos de diseño pendientes antes de producción

1. **Consistencia entre relaciones:** el esquema inicial aplica el ámbito RLS a través del establecimiento, pero necesita validaciones adicionales para garantizar que `application_id` y `grant_id` pertenezcan al mismo establecimiento que el seguimiento/concesión correspondiente. Añadir restricciones o triggers de integridad antes de habilitar estas escrituras en producción.
2. **Auditoría:** la tabla `audit_log` no permite escritura desde el rol `authenticated`. La siguiente iteración debe añadir triggers o funciones de servidor para registrar cambios de forma no manipulable por el cliente.
3. **Historial de ubicación:** el esquema dispone de una tabla de historial, pero aún falta automatizar su escritura en cada cambio de coordenadas/dirección.
4. **Perfil desactivado:** probar el comportamiento de sesiones ya abiertas tras desactivar un perfil y definir la revocación/revalidación necesaria.
5. **Campos de actualización:** las políticas de algunas tablas requieren que `updated_by` sea el usuario actual. La capa de datos debe rellenarlo explícitamente; probar que un cliente no pueda suplantar a otro actor.
6. **Catálogos:** las tablas de provincias y categorías nacen vacías. Preparar semillas de referencia verificadas, separadas de los datos de negocio.
7. **Roles SQL:** revisar los privilegios efectivos por tabla/secuencia en el proyecto real y comprobar que no haya políticas adicionales heredadas del proyecto.
8. **Pruebas automatizadas:** trasladar la matriz a tests de integración contra Supabase local/CI antes de conectar el frontend.

## 5. Criterio de salida

No conectar el frontend ni cargar el catálogo nacional hasta que:
- la migración se aplique limpiamente en un proyecto de desarrollo;
- todas las pruebas negativas de aislamiento pasen;
- la integridad entre establecimientos, solicitudes, concesiones y seguimientos esté protegida en la base de datos;
- la auditoría e historial de coordenadas estén implementados;
- el primer administrador y la recuperación de acceso estén documentados;
- quede confirmado que no se importará estado local de pruebas.
