# Consolidación de evidencia — auditoría de Mapas (fases 1 y 2)

**Fecha de corte:** 18/10/2026  
**Repositorio:** `danytf/mapas`  
**Rama auditada:** `main`  
**Commit de referencia comprobado:** `c71ec2c7da344260b4e117bacaff2ff2efb259e4`  
**Proyecto Supabase:** `wwoczmihhupofwmlmgga`

## 1. Persistencia local del navegador

### Evidencia inspeccionada en `index.html`

- El catálogo maestro se consulta en `public.establishments` mediante Supabase; no hay catálogo estático de establecimientos (`CENTERS = []`, `PRECOMPUTED` vacío).
- Si falla la lectura del catálogo, la función de sincronización limpia los marcadores, caché en memoria y catálogo visible; no utiliza datos locales como alternativa.
- `saveCache` es una función vacía (`const saveCache = () => {}`).
- La sesión de Supabase usa un adaptador `authStorage` respaldado por un objeto en memoria. Aunque la configuración del cliente declara `persistSession: true`, sus métodos `getItem/setItem/removeItem` operan sobre ese objeto en memoria, no sobre Web Storage.
- La aplicación solo consulta `localStorage` y `sessionStorage` para eliminar claves heredadas del mapa y el token antiguo específico de este proyecto. Las llamadas de limpieza usan `removeItem`; no guardan estado nuevo.
- No se detectaron referencias a IndexedDB, Cache Storage, cookies de documento ni registro de service workers en el HTML inspeccionado.
- El estado personal, estado operativo compartido y catálogo se gestionan en Supabase. Las correcciones de ubicación del catálogo maestro se escriben en Supabase y la interfaz verifica la respuesta o realiza una lectura posterior antes de declarar éxito.

### Auditoría automatizada

El workflow `.github/workflows/audit-static-catalog.yml` ejecuta `scripts/audit-persistence.mjs index.html`, además de validación sintáctica de scripts, pruebas de sanitización y auditoría XSS. El check `audit` terminó en **success** para el commit de referencia.

El script de persistencia falla si detecta llamadas de escritura persistente a `localStorage/sessionStorage`, IndexedDB, Cache Storage, cookies o registro de service worker; también valida las invariantes del guardado y verificación posterior de ubicaciones y estados.

**Conclusión estática:** la versión auditada no persiste estado operativo ni sesión en almacenamiento persistente del navegador. La limpieza de claves antiguas es una operación de eliminación, no una escritura. No se deben eliminar claves de otras aplicaciones del mismo origen.

**Límite pendiente:** en esta sesión no se ha ejecutado una prueba visual automatizada en un navegador real contra la URL publicada. Por tanto, la evidencia de código y CI es sólida, pero no se afirma una prueba de navegador que no se ha realizado.

## 2. Persistencia real de direcciones y coordenadas

Consulta directa de Supabase realizada el 18/10/2026:

- 791 establecimientos activos; los 791 tienen latitud y longitud.
- 43 filas en `public.establishment_location_history`, correspondientes a 31 establecimientos.
- Los últimos registros de historial de los 31 establecimientos reflejan cambios reales de dirección o coordenadas, y los valores nuevos coinciden con los valores actuales de `public.establishments` en los 31 casos.
- 856 filas en `public.audit_log`.
- Caso contrastado de forma independiente: **Juzgados – Santa Fe**, actualización del 17/10/2026 12:00:17.031368 UTC. Historial y auditoría comparten marca temporal; la auditoría incluye `address`, `latitude` y `longitude` entre los campos cambiados. La dirección y las dos coordenadas actuales coinciden con el historial.

No se alteraron datos para efectuar estas consultas.

## 3. Esquema, RLS y migraciones

- 16 tablas base en el esquema `public`; RLS habilitado en las 16.
- 23 migraciones registradas en Supabase y 23 ficheros de migración versionados en el repositorio.
- El workflow `postgres-smoke` terminó en **success** para el commit de referencia. Reconstruye el esquema y ejecuta `supabase/tests/schema_smoke.sql`, incluyendo controles de triggers, auditoría, escritura del catálogo maestro y escenarios de aislamiento RLS.
- Las consultas y pruebas disponibles respaldan el aislamiento básico por provincia y los permisos de edición de ubicación. El smoke test no equivale a una matriz completa de todos los permisos con sesiones reales de Supabase.
- La conexión GitHub no puede leer el endpoint de protección de ramas (403 por permisos de integración). El usuario confirmó visualmente que las comprobaciones obligatorias de `main` incluyen `audit` y `postgres-smoke`. Esto queda registrado como verificación manual; no como lectura independiente por API.

## 4. Limitaciones y pendientes no ocultos

1. **Prueba final de navegador real:** falta comprobar en la URL publicada el flujo de inicio de sesión, lectura remota, modificación legítima de una ubicación y recarga. No debe simularse ni darse por hecha.
2. **Matriz RLS completa:** la documentación de pruebas aún señala pendientes para operaciones no autorizadas, cuentas desactivadas, sesiones caducadas, cobertura completa por tabla/operación y otras combinaciones. Los smoke tests y las pruebas parciales no permiten declarar esa matriz completa.
3. **Restauración aislada:** no hay evidencia de una restauración completa desde backup en un entorno aislado.
4. **Aviso de Auth:** la protección de contraseñas filtradas continúa desactivada por la limitación de coste aceptada para el plan actual.
5. **Índices sin uso:** el asesor de rendimiento informa de 23 índices sin uso observado. No se eliminan sin analizar cargas reales y dependencias.

## 5. Estado de cierre

| Control | Resultado |
|---|---|
| No persistencia local en el código auditado | **Acreditada por código + CI** |
| Persistencia real de ubicación en Supabase | **Acreditada por historial + auditoría + estado actual** |
| RLS habilitado en tablas públicas | **16/16** |
| Checks de CI del commit de referencia | **Ambos correctos** |
| Checks obligatorios de `main` | **Confirmación manual del usuario; API no autorizada** |
| Fases 1 y 2 cerradas al 100 % | **No declarar aún**: faltan prueba de navegador real, matriz RLS completa y restauración aislada |

La regla operativa se mantiene: **no comenzar la fase 3** hasta resolver o aceptar explícitamente, con evidencia, los pendientes que formen parte del criterio de cierre de las fases 1 y 2.
