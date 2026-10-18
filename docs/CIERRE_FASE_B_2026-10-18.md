# Cierre de la Fase B (seguridad y persistencia)

**Fecha:** 18/10/2026 · **Proyecto Supabase:** `wwoczmihhupofwmlmgga` · Detalle de evidencias: `docs/AUDITORIA_FASE_B_2026-10-18.md`.

## 1. Criterios de cierre

| Criterio | Estado | Evidencia |
|---|---|---|
| El esquema del repositorio reproduce producción | Cumplido | Huellas MD5 locales = producción, antes y después de aplicar las dos migraciones de hoy (políticas 51, permisos 57, triggers 33, RLS 17, funciones propias 18) |
| Matriz de autorización tabla x operación x actor | Cumplido | `supabase/tests/rls_matrix.sql`: 973 celdas, 0 discrepancias, 0 inconclusas, 781 denegaciones comprobadas; falla sin la corrección de H-10 |
| La matriz y las pruebas se ejecutan en CI | Cumplido | `schema-smoke.yml`: smoke, historial y matriz; comprobación de que toda migración del repositorio se aplica en el flujo |
| Sin persistencia de negocio en el navegador | Cumplido (estático + producción) | `scripts/audit-persistence.mjs` en CI; la única aparición de `localStorage`/`sessionStorage` es la limpieza de claves antiguas y un adaptador de autenticación en memoria; sin service worker, IndexedDB, Cache Storage ni cookies propias |
| Persistencia de negocio solo en Supabase | Cumplido | Escrituras verificadas con tiempo límite y lectura posterior; ver sección 4 de la auditoría |
| Recursos de terceros fijados y verificables | Pendiente de fusión | H-01, PR #80 |
| Pérdida de datos por escritura concurrente | Parcial | H-11 sin resolver; H-12 resuelto (recuperable). Opción A pendiente |
| Cabeceras HTTP de seguridad | No aplicable en GitHub Pages | Solo `<meta>`; ver H-02 |

## 2. Hallazgos de la Fase B

| ID | Sev. | Estado | Detalle |
|---|---|---|---|
| H-01 | P1 | Corregido en PR #80 (sin fusionar) | CDN sin versión fija ni SRI; 6 recursos con sha384 y versión exacta; regresión en CI |
| H-02 | P2 | Abierto | Sin CSP. Propuesta en la sección 3; no aplicada |
| H-03 | P3 | Abierto (recomendación) | `set_updated_at` tiene `search_path=public`; no se cambia sin necesidad demostrada |
| H-04 | P3 | Cerrado por decisión del titular (18/10/2026): se mantiene | Usuarios con provincia pueden modificar (no borrar) solicitudes, concesiones y seguimientos creados por otros usuarios de su provincia. Es una decisión de diseño: el equipo de cada provincia trabaja sobre los mismos puntos. La matriz (`rls_matrix.sql`) fija el comportamiento y avisará si cambia |
| H-09 | P3 | Aceptado | Origen compartido `danytf.github.io` con otras aplicaciones |
| H-10 | P2 | Cerrado | Migración `20261018123313` aplicada en producción; prueba de baja de autor en la matriz |
| H-11 | P1 | Abierto, aplazado a la Fase C por decisión del titular (18/10/2026) | Último en guardar pisa al anterior en `establishment_app_state.state`; reproducido en local. Se implementará la opción A (control de versión en el cliente con aviso de conflicto) donde se pueda probar en navegador con sesión. Mientras tanto, lo pisado es recuperable (H-12) |
| H-12 | P1/P2 | Cerrado | Migración `20261018124030` aplicada; historial de estados previos; 29 pruebas |

Fuera de la B pero resuelto hoy: H-05 (teclado en filas del panel, PR #81).

## 3. Propuesta para H-02 (no aplicada)

Orígenes que usa la aplicación, obtenidos del código: `unpkg.com` (Leaflet y MarkerCluster), `cdn.jsdelivr.net` (supabase-js), `fonts.googleapis.com` y su origen de fuentes, `tile.openstreetmap.org` y `server.arcgisonline.com` (mapas base), `nominatim.openstreetmap.org` (geocodificación), el proyecto de Supabase, y enlaces a `www.google.com/maps` (solo navegación, no cargan recursos). Hay 3 bloques `<script>` en línea y 28 atributos `style`, por lo que `script-src` y `style-src` necesitan `'unsafe-inline'` salvo que se refactorice.

Política candidata para un `<meta http-equiv="Content-Security-Policy">`: `default-src 'self'; script-src 'self' 'unsafe-inline' https://unpkg.com https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://unpkg.com https://fonts.googleapis.com; font-src https://fonts.gstatic.com; img-src 'self' data: blob: https://unpkg.com https://tile.openstreetmap.org https://server.arcgisonline.com; connect-src https://wwoczmihhupofwmlmgga.supabase.co https://nominatim.openstreetmap.org; object-src 'none'; base-uri 'none'; form-action 'none'`.

No se aplica porque requiere validación en navegador con sesión iniciada (mapas, geocodificación, exportaciones, importación) y no se ha podido hacer en esta fase. `frame-ancestors` no funciona en `<meta>`. Se hará junto con la Fase C, después de fusionar el PR #80.

## 4. Pendiente para dar la B por completamente cerrada (depende del titular)

1. ~~Fusionar los PR #79, #80, #81 y #82~~ Hecho el 18/10/2026; `main` en producción verificado en navegador.
2. ~~Decidir H-04 y H-11~~ Decidido: H-04 se mantiene y se documenta; H-11 (opción A) pasa a la Fase C.
3. Confirmar en GitHub que `main` exige los checks `audit` y `postgres-smoke` y PR obligatorio. Lo comprueba el titular (no verificable por API desde esta sesión); hasta entonces figura como no verificado.

## 5. Límites conocidos

- Las pruebas de autorización se ejecutan sobre PostgreSQL con una capa mínima de `auth` (no sobre Supabase real): comprueban políticas, permisos y triggers, no GoTrue ni PostgREST.
- Los registros de auditoría de origen sin usuario (807 de 856) se atribuyen por inferencia a la carga del catálogo y a actualizaciones SQL del 16-17/10; no es un hallazgo confirmado.
- La protección frente a contraseñas filtradas sigue desactivada por decisión del titular.
