# Estado de migración y contrato de datos — Mapa

**Actualizado:** 17 de octubre de 2026.  
**Aplicación:** `index.html` en GitHub Pages.  
**Backend:** proyecto Supabase de desarrollo `wwoczmihhupofwmlmgga`.

## Estado actual verificado

La migración del catálogo maestro está realizada. La aplicación ya no usa el catálogo embebido ni los datos del navegador como fuente de verdad.

- **791 establecimientos activos** en `public.establishments`.
- **791/791** tienen latitud y longitud; no hay coordenadas fuera de los límites geográficos revisados ni nombres activos duplicados.
- **791 referencias `source_ref` únicas** en el catálogo activo.
- 31 registros están marcados `verified` con origen `manual_google_maps`; los otros 760 tienen precisión `address`.
- Las 27 filas marcadas inicialmente como aproximadas en el seed fueron revisadas manualmente en la interfaz: 25 tienen cambios de coordenadas registrados en el historial y 2 se confirmaron sin cambiar sus coordenadas.
- El historial más reciente coincide con la ubicación actual en los 32 establecimientos con historial.
- Las 16 tablas públicas tienen RLS habilitado y no se encontraron privilegios de tabla para `anon` ni `PUBLIC`.
- El catálogo se carga tras validar la sesión, el perfil activo y las provincias asignadas.
- La sesión de Supabase se mantiene en memoria. La aplicación no escribe datos operativos en `localStorage`, `sessionStorage`, IndexedDB ni Cache Storage.
- La importación de copias JSON antiguas se ha retirado para evitar reintroducir datos experimentales.
- GitHub Actions comprueba la sintaxis JavaScript, las reglas de persistencia y el inventario estático. La prueba visual de usuario sigue siendo necesaria para validar la interfaz en un navegador real.

## Fuentes de verdad y persistencia

| Datos | Fuente de verdad actual | Uso en la aplicación |
|---|---|---|
| Identidad, categoría, municipio, dirección y coordenadas maestras | `public.establishments` y catálogos relacionados | Lectura desde Supabase; los cambios de ubicación actualizan el establecimiento por UUID |
| Ámbito territorial y rol | `public.profiles`, `public.user_provinces`, `public.provinces` | Se validan antes de cargar datos |
| Estado operativo compartido de permisos | `public.establishment_app_state` | La interfaz guarda un bloque JSONB por establecimiento; incluye solicitudes, concesiones e historial funcional |
| Puntos personalizados, puntos ocultos, revisiones y progreso personal | `public.user_app_state` | Estado JSONB restringido al usuario autenticado |
| Historial de ubicación y auditoría | `public.establishment_location_history`, `public.audit_log` | Trazabilidad de cambios efectivos; el historial lo genera el servidor |
| Modelo relacional de solicitudes, concesiones y seguimientos | `public.permit_applications`, `public.permit_grants`, `public.followups` | Las tablas existen y tienen RLS, pero la interfaz actual todavía guarda su estado operativo en `establishment_app_state`; la integración completa con el modelo normalizado queda pendiente de decisión |

Las identidades del catálogo son UUID persistentes. El nombre visible no se utiliza como identificador maestro para actualizar coordenadas.

## Reglas que no deben romperse

1. No leer, importar ni restaurar datos experimentales de almacenamiento local del navegador.
2. No incluir el catálogo maestro ni claves privilegiadas en el HTML/JavaScript público.
3. No mostrar datos de respaldo local cuando falle la lectura de Supabase: mostrar error y no cargar un catálogo alternativo.
4. No afirmar que un guardado se completó hasta recibir confirmación de Supabase.
5. No modificar coordenadas maestras a partir de una exportación JSON. Las correcciones se hacen sobre el UUID del establecimiento, con usuario autenticado y registro de auditoría.
6. Mantener RLS como barrera de seguridad; los controles visuales no sustituyen autorización en la base de datos.
7. Los usuarios no administradores solo pueden modificar dirección y ubicación del catálogo maestro; cambiar identidad/estado e insertar establecimientos exige administrador.
8. No etiquetar una ubicación como verificada sin confirmación explícita. La precisión de dirección y la verificación manual son estados distintos.
9. Tratar CSV/JSON exportados como datos operativos: pueden contener contactos, notas e historial. La exportación de interfaz no es un backup completo de Supabase.
10. Probar cualquier restauración en un proyecto aislado, nunca sobre la base de datos usada por la aplicación.

## Catálogo y categorías

La interfaz define 17 categorías. En la base de datos actual, 13 categorías contienen establecimientos activos; las otras cuatro permanecen sin registros y no deben rellenarse con datos inventados. No se deben borrar categorías vacías sin revisar antes las referencias y el modelo de negocio.

El catálogo inicial versionado se generó desde las fuentes del repositorio, no desde el navegador. La validación de recuentos y coordenadas no certifica por sí sola la exactitud geográfica; los registros aproximados deben seguir distinguiéndose de los verificados.

## Tareas pendientes

### Necesitan pruebas con usuario o un entorno aislado

- Ejecutar una batería real de RLS con administrador, usuario asignado a Granada, usuario sin asignación y perfil desactivado.
- Probar la interfaz desplegada con una sesión real: inicio/cierre de sesión, lectura de catálogo, filtros, modificación de ubicación, guardado de permisos y estado personal.
- Generar una copia lógica completa de Supabase y restaurarla en un proyecto aislado. No se ha hecho esa restauración desde esta integración.
- Comprobar conflictos de edición concurrente y comportamiento tras caducidad/revocación de sesión.
- Revisar oficialmente los puntos de servicio que faltan en el inventario; no añadir centros inferidos sin fuente verificable.

### Trabajo técnico que puede abordarse después

- Decidir si migrar las operaciones de permisos desde el JSONB de `establishment_app_state` a las tablas normalizadas `permit_applications`, `permit_grants` y `followups`. El plan reversible y las ambigüedades de mapeo están documentados en [Plan de migración de permisos normalizados](./PLAN_MIGRACION_PERMISOS_NORMALIZADOS.md); no se ha cambiado la interfaz ni se han migrado datos.
- Completar las pruebas negativas RLS en CI usando un entorno Supabase de prueba, además de los smoke tests PostgreSQL.
- Mantener la auditoría de persistencia del navegador como condición de CI.
- Revisar y documentar el procedimiento de administración y recuperación de cuentas.

## Referencias

- [Auditoría inicial del catálogo](./auditoria-catalogo-inicial.md)
- [Pruebas de aceptación RLS](./PRUEBAS_ACEPTACION_RLS.md)
- [Clasificación de datos y exposición pública](./clasificacion-datos-y-exposicion-publica.md)
- [Exportaciones y copias de seguridad](./import-export-backups.md)
- [Supabase — Database Backups](https://supabase.com/docs/guides/platform/backups)
