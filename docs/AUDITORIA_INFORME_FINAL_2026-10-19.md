# Informe final de la auditoría integral (Fases A-F)

Fecha: 19 de octubre de 2026. Titular: Dani (Wesser). Aplicación: Mapa del Responsable de Gestión de Recursos, https://danytf.github.io/mapas/ (producción en Supabase `wwoczmihhupofwmlmgga`).

Este informe resume y enlaza la evidencia; el detalle de cada hallazgo (ID, capa, severidad, estado, evidencia, impacto, acción, prueba de regresión, riesgo residual y dependencia del titular) está en `docs/traspaso/HALLAZGOS.md` y en los informes de fase. No se afirma nada que no se haya comprobado; lo no comprobado se dice.

## 1. Resumen ejecutivo

- Se cierran las fases A a E. Hay 38 hallazgos registrados (H-01 a H-38): los P1 (H-01, H-11, H-12, H-13, H-23) y los P2 están corregidos y verificados; el resto, salvo los aceptados por el titular, también.
- Aceptados por el titular: H-09 (origen compartido `danytf.github.io`), H-24 (plan gratuito de Supabase), H-25 (umbral de distancia al corregir ubicaciones), y el aviso de contraseñas filtradas de Supabase Auth.
- La base de producción tiene hoy 29 migraciones registradas, coincidentes una a una con `supabase/migrations/`; las aplicadas durante la auditoría se probaron antes en local y se verificaron después en producción (huellas del esquema, recuentos y asesores).
- Lo más relevante que se detectó y corrigió: pérdida silenciosa de datos al guardar permisos desde dos sesiones (H-11), permisos de puntos personales que no se guardaban (H-13), límite de 1.000 filas de la API que cortaría el catálogo (H-23), carga del mapa que se congelaba con miles de puntos (H-27), accesibilidad (H-28 a H-35) y una copia de seguridad que no era restaurable con seguridad (H-38).
- Riesgo principal que queda: no hay copia automática de la base (plan gratuito); depende de la copia mensual manual del titular (H-24).

## 2. Matriz de capas (propuesta; el listado literal del encargo original no se conservó y debe confirmarlo el titular)

| Capa | Hallazgos | Estado | Evidencia principal |
|---|---|---|---|
| 1. Estado y reproducibilidad | H-01 (CDN con versión y SRI) | Cerrada | `docs/traspaso/ESTADO.md`, CI, `schema-smoke.yml` aplica todas las migraciones |
| 2. Base de datos y migraciones | H-03, H-10, H-22, H-26 | Cerrada | 29 migraciones en producción = `supabase/migrations/`; 6 huellas del esquema |
| 3. Autorización (RLS) | H-04, H-22 | Cerrada | `supabase/tests/rls_matrix.sql`: 973 celdas, 0 discrepancias, 781 denegaciones; 17 tablas con RLS |
| 4. Persistencia | H-13, H-14, H-19 | Cerrada | `scripts/audit-persistence.mjs` en CI; sin datos de negocio en el navegador |
| 5. Concurrencia e integridad | H-11, H-12, H-10 | Cerrada | `state_version.sql`, `state_history.sql`; versión por fila e historial de estados |
| 6. Aplicación y E2E | H-02, H-05, H-15 a H-21 | Cerrada | `docs/AUDITORIA_FASE_C_2026-10-18.md`; pruebas en navegador con Supabase aislado y simulado |
| 7. Dependencias y cabeceras | H-01, H-02, H-37 | Cerrada | SRI sha384, CSP en `<meta>` sin violaciones, Pages publica solo `index.html` |
| 8. Accesibilidad | H-05, H-18, H-28 a H-35 | Cerrada con pendientes | `scripts/test-a11y-fase-d.mjs`; pendiente lectores de pantalla reales, zoom y objetivos táctiles |
| 9. Rendimiento y escala | H-23, H-26, H-27, H-36 | Cerrada | 50.000 puntos: 87 ms de consulta de catálogo y 4-7 s hasta el mapa en el navegador |
| 10. Backup, restauración y despliegue | H-08, H-24, H-37, H-38 | Cerrada con riesgo aceptado | Restauración en proyecto aislado: 6 de 6 huellas y recuentos idénticos |

## 3. Defectos confirmados y correcciones

Resumen por prioridad (el detalle, en `HALLAZGOS.md`):

- **P1:** H-01 (recursos externos sin versión ni integridad), H-11 (dos sesiones se pisaban el estado de permisos), H-12 (sobrescrituras sin recuperación), H-13 (permisos de puntos personales no guardados), H-23 (límite de 1.000 filas de la API: el catálogo se cortaría; confirmado por el titular).
- **P2:** H-02 (CSP), H-05 y H-31 (teclado), H-10 (borrar un perfil con registros fallaba), H-14, H-20, H-21 (app centrada en Granada), H-24 (plan gratuito), H-26 y H-27 (escala), H-38 (copia no restaurable con seguridad).
- **P3:** el resto (H-03, H-04, H-09, H-15 a H-19, H-22, H-25, H-28 a H-30, H-32 a H-37).
- Aceptados: H-09, H-24, H-25 (y H-04 cerrado por decisión).

## 4. Recomendaciones por prioridad

1. **Alta:** hacer la copia mensual (y antes de cada migración) con `scripts/backup-supabase.sh`, guardarla cifrada fuera del ordenador; revisar el plan de Supabase si crece el uso (copias diarias solo en planes de pago, a verificar su precio).
2. **Media:** antes de cargar otra provincia, planificar la geocodificación fuera de la app (no con el Nominatim público) y revisar H-25; desarrollar el panel de administración (hoy las altas y asignaciones se hacen por SQL, `docs/ADMINISTRACION_CUENTAS.md`).
3. **Baja:** pruebas con lectores de pantalla reales, zoom y objetivos táctiles; completar el patrón de pestañas; repetir el informe de índices sin uso con 8-12 semanas de estadísticas (H-36); registrar el anuncio del recuento tras filtrar si se quiere accesibilidad avanzada.

## 5. Resultados de pruebas reproducibles

Se ejecutan en CI (`audit-static-catalog.yml` y `schema-smoke.yml`) y en local (`docs/traspaso/PRUEBAS.md`):

- SQL (sobre una base reconstruida desde las migraciones): `schema_smoke`, `state_history` (29 comprobaciones), `state_version` (20), `province_active` (23), `rls_performance` (17), `audit_db_role` (6), `rls_matrix` (973 celdas), `default_function_acl_smoke`.
- Node: `audit-persistence`, `audit-xss`, `audit-a11y`, `audit-cdn-integrity`, `audit-csp`, `audit-static-catalog`, `test-shared-state-sanitizers`, `test-paged-fetch`, `test-multiprovince`, `test-ui-fixes`, `test-list-performance` y `test-a11y-fase-d`.
- Navegador: pruebas E2E con proyecto Supabase aislado (Fase C, eliminado) y con un Supabase simulado (`scripts/dev/`), incluida la carga con 50.000 puntos sintéticos.
- No se ejecutaron contra producción pruebas con escritura ni destructivas. Las lecturas en producción se hicieron con la sesión del titular o con consultas de solo lectura.

## 6. Estado de RLS, permisos, funciones y triggers (producción, 19/10/2026)

- 17 tablas en `public`, todas con RLS; 51 políticas; 57 permisos de tabla (ninguno para `anon`); 19 funciones propias en `public` y 4 en `private`; 34 triggers. Huellas: políticas `f12aa180`, permisos `374f58c4`, funciones `a06e6e20`, privadas `8c6f87f4`, triggers `6d0afe68`, RLS `e9ad42c3`.
- Asesor de seguridad: solo el aviso de contraseñas filtradas desactivado (aceptado). Asesor de rendimiento: 21 avisos informativos de índices sin uso (no se eliminan; ver H-36).
- No se activó FORCE RLS y no se eliminó ningún índice, tabla, columna, política ni función.

## 7. Persistencia

Sin datos de negocio en `localStorage`, `sessionStorage`, IndexedDB, Cache Storage ni cookies (auditoría estática en CI y comprobación en producción). La sesión de Supabase vive solo en memoria. No hay PWA ni service worker. Los datos de negocio viven en Supabase (`establishment_app_state`, `user_app_state` y el catálogo).

## 8. Backups y restauración

- Sin copia automática (plan gratuito). Copia mensual manual con `scripts/backup-supabase.sh` (roles, esquema `public` y `private` con permisos, y datos), con sumas de control. Primera copia válida: 19/10/2026, guardada por el titular fuera de este ordenador.
- Restauración probada en un proyecto aislado (ya eliminado): esquema en 17,7 s y datos en 3,1 s, 6 de 6 huellas y mismos recuentos (791 puntos, 3 estados, 856 auditorías, 3 perfiles). No se restauran los usuarios de autenticación, la configuración de Auth ni las claves del proyecto nuevo.
- Reversión del despliegue: documentada y probada en seco (local); no probada en producción.

## 9. Commits, PR y checks

Todo el trabajo se hizo en ramas con PR hacia `main` y squash. Los PR de la auditoría van del #79 al #117 (cada uno con los checks `audit` y `postgres-smoke` en verde antes de fusionar, verificado en cada fusión). A fecha de este informe no hay PR abiertos salvo el que añade este informe. `main` está protegida (PR obligatorio, checks obligatorios, ramas actualizadas, sin force push). El despliegue de Pages se verificó con el SHA-256 de `index.html` tras cada cambio de la app.

## 10. Riesgos residuales y tareas del titular

- Sin copia automática: depende de la rutina mensual del titular (H-24).
- El proyecto gratuito se pausa tras 7 días de poca actividad; reactivar desde el panel de Supabase (retención no verificada).
- Usuarios de autenticación no incluidos en la copia: tras una restauración habría que recrear cuentas.
- Aplazado por no ser automatizable: lectores de pantalla reales, zoom y objetivos táctiles.
- Aceptados: H-09, H-24, H-25 y contraseñas filtradas.
- Lista completa y vigente de tareas del titular: `docs/traspaso/ROADMAP.md`, sección «Dependencias del titular».

## 11. Criterios de cierre por fase

| Fase | Criterio | Cumplido |
|---|---|---|
| A. Estado real | Según `docs/traspaso/ROADMAP.md` | Cerrada |
| B. Seguridad y persistencia | Según `docs/traspaso/ROADMAP.md` y `docs/CIERRE_FASE_B_2026-10-18.md` | Cerrada |
| C. E2E | Pruebas en navegador con cuentas sintéticas en entorno aislado | Sí |
| D. Integridad, dependencias, accesibilidad, rendimiento | Hallazgos corregidos o aceptados; escala medida | Sí, con pendientes manuales declarados |
| E. Backup, restauración, despliegue | Restauración demostrada con huellas; reversión documentada | Sí |
| F. Informe final | Este documento, matriz confirmada por el titular | Pendiente de confirmar la matriz de capas |
