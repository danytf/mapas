# Clasificación de datos y exposición pública

## Decisión

La aplicación requiere autenticación. El catálogo operativo se carga desde Supabase únicamente después de validar la sesión y el perfil. El código cliente no debe contener copias del catálogo maestro ni coordenadas precalculadas.

## Clasificación

| Datos | Clasificación | Regla de exposición |
|---|---|---|
| Nombre, dirección y coordenadas de establecimientos públicos/comerciales | Información de fuente pública | Puede consultarse por usuarios autorizados de la aplicación; no se considera secreto por sí sola. Evitar duplicarla en el código cliente. |
| Categoría, subtipo, municipio y precisión de ubicación | Operativa de bajo riesgo | Disponible a usuarios autenticados según el ámbito provincial asignado. |
| Solicitudes y concesiones de permisos, fechas, número de captadores y seguimiento | Interna operativa | Solo usuarios autenticados autorizados por provincia; nunca acceso anónimo. |
| Contactos, notas y observaciones internas | Interna/confidencial | Solo acceso autenticado y estrictamente necesario según las políticas de acceso. No incluir en HTML/JS, logs públicos ni exportaciones públicas. |
| Perfiles, asignaciones provinciales y roles | Confidencial de control de acceso | Solo usuarios autorizados; las asignaciones no se pueden decidir desde datos controlables por el cliente. |
| Historial de cambios de ubicación, revisiones y registros de auditoría | Interna | Acceso restringido por RLS; no acceso anónimo. |
| Estado personal, preferencias y gamificación | Personal del usuario | Cada usuario solo puede consultar/modificar su propio estado. |
| URL del proyecto y clave Supabase publishable | Pública por diseño | Puede estar en el cliente; la seguridad depende de permisos mínimos y RLS. Nunca publicar claves secret/service_role ni credenciales. |

## Controles verificados

- Las 16 tablas del esquema `public` tienen RLS habilitado.
- Las tablas del esquema `public` no conceden privilegios de tabla a `anon` ni a `PUBLIC`; los accesos pasan por usuarios autenticados y las políticas RLS.
- La aplicación valida perfil activo y ámbito provincial antes de cargar el catálogo.
- El catálogo se obtiene desde `public.establishments` tras iniciar sesión.
- La clave cliente presente en el HTML es una clave `sb_publishable_`, no una clave `service_role`.
- No hay buckets de Storage creados en el proyecto en el momento de la revisión.
- Se ha retirado del HTML el catálogo estático y el exportador público que permitía reconstruirlo desde los datos embebidos.

## Límites

El repositorio GitHub sigue siendo público. Los commits históricos pueden conservar versiones anteriores del catálogo estático; eliminarlo del HTML actual no borra el historial de Git ni copias ya descargadas. El catálogo previo contiene nombres, direcciones y coordenadas de establecimientos, clasificados aquí como información de fuente pública, no credenciales ni datos personales. No se deben incorporar datos operativos internos o personales al repositorio.

La protección efectiva de solicitudes, concesiones, contactos, notas, perfiles y auditoría depende de las políticas RLS y debe comprobarse con pruebas de acceso negativas además de la inspección de configuración.
