# Contrato de migración de datos — Mapas

## Objetivo
Preparar la evolución de la aplicación actual basada en almacenamiento local hacia una aplicación multiusuario con datos compartidos por provincia, sin alterar la aplicación publicada hasta validar el modelo y la migración.

## Estado actual conocido
- La aplicación principal está en `index.html` y usa Leaflet.
- Parte de los datos operativos vive en `localStorage`/`sessionStorage`.
- `rgr-auth` es un indicador local y no debe considerarse autenticación segura.
- El catálogo base y algunos conjuntos auxiliares están definidos en el frontend.
- Las claves locales usan nombres de establecimientos; pueden existir duplicados o variaciones de nombre.
- La exportación JSON actual declara `version: 2` e incluye permisos, puntos propios, quitados, revisados, ubicaciones, logros y gamificación.

## Principios obligatorios
1. No publicar cambios de producción antes de probar la migración en un entorno separado.
2. No poner secretos privilegiados (`service_role`, claves privadas) en HTML/JavaScript del cliente.
3. Aplicar autorización en PostgreSQL/RLS y en funciones de servidor; ocultar controles en el frontend no es seguridad.
4. Identificar establecimientos con UUID estable, no con el nombre visible.
5. Migración idempotente: repetir una importación no debe duplicar datos ni conceder permisos dos veces.
6. No descartar registros ambiguos: enviarlos a incidencias para revisión manual.
7. Mantener historial de concesiones, revocaciones y cambios de ubicación; usar archivado lógico cuando proceda.
8. Mantener el progreso y los logros personales separados de los datos operativos compartidos.

## Modelo relacional inicial
- `provinces`: provincias disponibles.
- `municipalities`: municipios vinculados a provincia.
- `categories`: catálogo controlado de categorías.
- `profiles`: perfil del usuario autenticado y rol global.
- `user_provinces`: asignaciones de usuarios a provincias.
- `establishments`: identidad canónica del establecimiento, con categoría, municipio, dirección y coordenadas.
- `establishment_operations`: estado operativo compartido por establecimiento, con autor y marcas temporales.
- `permit_applications`: solicitudes de permiso.
- `permit_grants`: concesiones y revocaciones históricas, no sobrescritas destructivamente.
- `followups`: seguimientos e incidencias operativas.
- `establishment_location_reviews`: estado de revisión geográfica.
- `establishment_location_history`: historial de cambios de dirección/coordenadas.
- `audit_log`: trazabilidad de cambios relevantes.
- `migration_batches`: cada lote de importación y su estado.
- `migration_records`: resultado por registro, con origen, destino, estado y motivo de incidencia.
- `user_progress`: XP/logros personales, separado del estado compartido.

El esquema definitivo debe validarse contra todas las funciones y campos reales del código antes de escribir migraciones SQL.

## Reglas de resolución de identidad
Orden sugerido para emparejar un registro local con `establishments`:
1. Identificador canónico previo, si existe y está validado.
2. Nombre normalizado + municipio.
3. Nombre normalizado + dirección normalizada.
4. Nombre + proximidad de coordenadas, solo como sugerencia de revisión; nunca como coincidencia automática única si hay candidatos múltiples.

La normalización puede quitar diferencias de mayúsculas, espacios y acentos, pero debe conservar el nombre original y nunca fusionar automáticamente establecimientos distintos por similitud textual.

## Claves locales conocidas
- `permisos-captacion-granada-v1`
- `puntos-propios-granada-v1`
- `puntos-quitados-granada-v1`
- `puntos-revisados-granada-v1`
- `ubicaciones-corregidas-granada-v1`
- `cs-granada-geo-v3`
- `logros-granada-v1`
- `rgr-auth`

Hay que verificar en el código el esquema exacto de cada clave, así como las constantes `CUSTOM_KEY`, `REMOVED_KEY`, `PERM_KEY`, `REV_KEY`, `LOC_KEY`, `CACHE_KEY` y `GAM_KEY` antes de implementar el importador.

## Contrato del importador
El importador deberá:
- Leer exportaciones existentes sin modificarlas.
- Validar versión, tipos, campos requeridos y límites de tamaño.
- Ofrecer modo `dry-run` con recuento de creados, actualizados, ignorados y ambiguos.
- Guardar el JSON original y un resumen de errores por lote.
- Usar una clave de idempotencia por lote y por registro de origen.
- No transformar `rgr-auth` en una identidad autenticada; los usuarios deberán iniciar sesión mediante Auth.
- No asignar permisos de provincia basándose únicamente en datos manipulables del navegador.
- Dejar los registros no resueltos en `migration_records` para revisión manual.
- Permitir reanudar un lote interrumpido sin duplicar resultados.

## Autorización y seguridad
- Autenticación mediante Supabase Auth u otro proveedor aprobado.
- RLS habilitada en todas las tablas con datos operativos.
- Un usuario estándar solo puede consultar y modificar registros de provincias asignadas, según su rol y las reglas de negocio.
- Un administrador puede gestionar usuarios y asignaciones mediante políticas verificadas y, cuando sea necesario, funciones de servidor seguras.
- La asignación de roles y provincias no debe poder elevarse desde el cliente.
- Registrar actor, fecha, acción y entidad en operaciones sensibles.
- Probar expresamente accesos entre provincias, usuarios sin asignación y sesiones expiradas.

## Pruebas mínimas antes de producción
1. Exportación JSON válida, incompleta y malformada.
2. Importación repetida del mismo lote sin duplicados.
3. Nombres duplicados entre municipios y nombres con tildes o variantes.
4. Registros sin coordenadas y coordenadas inválidas.
5. Reanudación tras fallo parcial.
6. Usuario de provincia A intentando leer o editar provincia B.
7. Usuario estándar intentando asignar roles o provincias.
8. Revocación de permisos conservando historial.
9. Conflictos de edición concurrente y detección de versión obsoleta.
10. Copia de seguridad y procedimiento probado de restauración.

## Fases recomendadas
1. Inventariar y documentar el esquema real de todas las claves locales.
2. Definir el esquema SQL, índices, restricciones y políticas RLS.
3. Crear un entorno de pruebas separado y cargar datos de muestra anonimizados.
4. Implementar y validar importador con `dry-run` y registro de incidencias.
5. Adaptar la aplicación a Auth y a la API compartida, manteniendo un modo de compatibilidad durante pruebas.
6. Ejecutar piloto con una provincia y verificar permisos, auditoría y restauración.
7. Migrar producción solo tras aprobación y plan de reversión.

## Decisiones pendientes
- Confirmar proveedor de backend y proyecto de pruebas.
- Definir roles exactos y permisos por operación.
- Definir cuáles campos operativos son compartidos y cuáles personales.
- Revisar condiciones de uso de GitHub Pages para el uso corporativo/comercial previsto.
- Verificar el esquema completo de las claves de localStorage a partir del código actual.
