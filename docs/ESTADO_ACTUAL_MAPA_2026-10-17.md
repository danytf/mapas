# Estado operativo y técnico de Mapa — 17/10/2026

## Fuente de verdad y persistencia

- El catálogo maestro se lee de `public.establishments` en Supabase. Si falla la lectura, la app vacía el catálogo visible y no recurre a coordenadas locales.
- Las correcciones de dirección/coordenadas se guardan en el registro maestro y generan historial; el estado operativo compartido se guarda en `establishment_app_state`; el estado personal se guarda en `user_app_state`.
- No se importan valores heredados del navegador ni sobrescrituras personales de coordenadas.
- La auditoría automática detecta cero escrituras de la app en `localStorage`, `sessionStorage`, IndexedDB, Cache Storage o cookies; tampoco registra service workers.
- La exportación JSON/CSV es manual, requiere confirmación y no se presenta como backup completo. No hay importador de copias antiguas.

## Catálogo de producción comprobado

Consulta de Supabase realizada el 17/10/2026:

| Comprobación | Resultado |
|---|---:|
| Establecimientos activos | 791 |
| Activos con latitud y longitud | 791 |
| Activos fuera del ámbito de coordenadas de Granada usado por la app | 0 |
| Ubicaciones con `verified` + `manual_google_maps` | 31 |
| Ubicaciones con `address` + `static_precomputed` | 760 |
| Filas del historial de ubicación | 44 |
| Establecimientos con al menos una fila de historial | 32 |
| Filas cuyo último historial coincide con dirección y coordenadas actuales | 32/32 |

**Importante:** tener coordenadas no significa que una ubicación esté verificada manualmente. No se han recalculado ni sobrescrito coordenadas como parte de esta auditoría.

## Endurecimiento de autorización aplicado

- Usuarios no administradores solo pueden cambiar dirección y campos de ubicación autorizados en el catálogo maestro; no pueden cambiar nombre, estado ni otros campos maestros.
- La inserción de establecimientos maestros exige administrador.
- La función trigger `guard_establishment_app_state()` ya no puede ejecutarse directamente como RPC por `anon` o `authenticated`.
- Las tablas `user_app_state` y `establishment_app_state` conceden a `authenticated` únicamente `SELECT`, `INSERT` y `UPDATE`; se retiraron `DELETE`, `TRUNCATE`, `REFERENCES` y `TRIGGER`.
- Las comprobaciones en transacciones revertidas verificaron que un usuario estándar puede actualizar ubicación, pero no campos maestros ni insertar establecimientos; la cuenta administradora conserva la edición.
- RLS está habilitado en las 16 tablas de `public` revisadas. Ninguna concede privilegios de tabla a `anon`.
- El asesor de seguridad ya no detecta funciones `SECURITY DEFINER` ejecutables por `anon` o `authenticated`. Permanece el aviso de protección de contraseñas filtradas desactivada; no se cambia esa configuración desde esta auditoría.

## Validaciones automatizadas

- CI de esquema PostgreSQL y RLS: correcto en `main` tras reproducir el conjunto de migraciones del repositorio.
- Auditoría de persistencia, pruebas de sanitización del estado operativo compartido, sintaxis de los scripts inline y auditoría del catálogo: correctas.
- GitHub Pages: despliegue correcto de la versión de interfaz que incorpora la sanitización del estado compartido.
- Prueba manual previa del usuario: guardado y recarga con Ctrl+F5 de los centros de salud Albaicín y Almanjáyar; sus coordenadas se conservaron.

## Pendientes que requieren herramientas o comprobación externa

1. **Prueba final en navegador real:** iniciar sesión en la URL publicada, corregir una ubicación de prueba, recargar y confirmar que la interfaz refleja el registro remoto. No hay un navegador automatizado disponible en esta sesión; no se afirma que se haya realizado esta prueba final.
2. **Alinear el historial de migraciones de Supabase con los archivos versionados.** La base activa refleja los cambios comprobados, y CI reconstruye el esquema, pero `list_migrations` no coincide uno a uno con todos los nombres/fechas de los archivos históricos. Algunas operaciones aparecen registradas bajo versiones distintas a los nombres originales del repositorio. No se ha editado directamente la tabla interna de migraciones: la reparación segura requiere Supabase CLI enlazada al proyecto, comparar `supabase migration list` y marcar como aplicadas únicamente las versiones cuya equivalencia en producción esté confirmada. No ejecutar `db push` a ciegas.
3. **Revisión de usuario tras el despliegue:** comprobar el flujo visual de login, edición y guardado en la sesión habitual. No se ha modificado ningún registro del catálogo para forzar esa prueba.

## Regla de operación

Supabase es la fuente de verdad. No recuperar datos de navegadores ni archivos experimentales, no convertir coordenadas aproximadas en verificadas sin revisión explícita y no declarar un guardado correcto sin confirmación de Supabase.
