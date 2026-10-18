# Estado del proyecto a 18/10/2026 (traspaso a Visual Studio Code)

`main` en `aac12ea`. Todo lo descrito está fusionado, desplegado y verificado salvo lo marcado como pendiente. Evidencias detalladas: `docs/AUDITORIA_FASE_B_2026-10-18.md`, `docs/CIERRE_FASE_B_2026-10-18.md`, `docs/CIERRE_AUDITORIA_FASES_1_2_2026-10-18.md`.

## Fases

| Fase | Estado |
|---|---|
| A. Reconstruir el estado real | Cerrada |
| B. Seguridad y persistencia | Cerrada (H-11 aplazado a la C por decisión del titular) |
| C. Pruebas E2E en navegador | Cerrada el 18/10/2026 (`docs/AUDITORIA_FASE_C_2026-10-18.md`): 11 pruebas y arrastre del pin; H-02, H-11, H-13 y H-14 corregidos y desplegados; H-15 a H-20 pasan a la D |
| D. Integridad, dependencias, accesibilidad, rendimiento | Cerrada el 18/10/2026 (`docs/AUDITORIA_FASE_D_2026-10-18.md`, `..._ACCESIBILIDAD_...` y `..._INDICES_...`): H-03, H-15 a H-23, H-26, H-27 y H-28 a H-35 corregidos y desplegados, H-36 informe; H-24 y H-25 aceptados por el titular. Sin probar: lectores de pantalla reales, zoom y objetivos táctiles |
| E. Backup, restauración y despliegue | **En curso**: cobertura de copia y reversión documentadas (H-37 cerrado); procedimiento de copia mensual manual documentado (`scripts/backup-supabase.sh`, sin ejecutar contra Supabase); restauración PROBADA el 19/10/2026 en un proyecto aislado (H-38): 6 huellas y recuentos idénticos a producción; no se restauran los usuarios de autenticación; falta eliminar el proyecto temporal `mapas-restore-test` (lo hace el titular) y decidir/verificar la rutina mensual |
| F. Informe final | Sin empezar |

## Producción (Supabase `wwoczmihhupofwmlmgga`)

- Migraciones: 28 registradas, última `20261018183559_rls_policy_performance` (H-26, aplicada el 18/10/2026; antes `20261018172704` de H-22 y `20261018145132` de H-11). Coinciden una a una con `supabase/migrations/`.
- Huellas del esquema público (comparables con `supabase/tools/schema_fingerprint.sql`): políticas 51 `f12aa180`, permisos de tabla 57 `374f58c4`, funciones propias 19 `976fdf1e` (sin `rls_auto_enable`, función de la plataforma), funciones privadas 4 `8c6f87f4`, triggers 34 `6d0afe68`, tablas con RLS 17 `e9ad42c3`.
- 17 tablas, todas con RLS. Ninguna concede privilegios a `anon`.
- Avisos del asesor de seguridad: solo "protección frente a contraseñas filtradas desactivada" (aceptado, no tocar).
- Datos (consulta del 18/10/2026): 791 establecimientos, todos activos y con coordenadas; 3 perfiles (1 administrador); 2 filas de `user_provinces`; 2 filas de `establishment_app_state`; 3 de `user_app_state`; 0 en `permit_applications`, `permit_grants` y `followups` (el estado real de permisos vive en el JSONB de `establishment_app_state`); 856 filas de `audit_log`; 43 de `establishment_location_history`; 0 de `establishment_app_state_history` (aún no hubo sobrescrituras).
- Catálogo limpio: sin duplicados reales; solo 2 pares de coordenadas coincidentes (un Mercadona y un centro comercial en el mismo edificio, Armilla y Granada), no son defectos.
- Auditoría: 807 de 856 filas sin usuario (carga del catálogo, arranque de perfiles y 8 actualizaciones SQL del 16-17/10); toda edición desde la app lleva autor. Es una inferencia, no un defecto confirmado. Recomendación pendiente: registrar el rol de base de datos cuando no hay JWT.

## Aplicación publicada

- https://danytf.github.io/mapas/ sirve exactamente `main` (verificado en navegador tras las fusiones del 18/10).
- Recursos externos fijados con versión exacta y SRI sha384: Leaflet 1.9.4, leaflet.markercluster 1.5.3 (unpkg) y supabase-js 2.118.0 (jsdelivr). Google Fonts exento.
- Sin CSP ni cabeceras de seguridad (GitHub Pages no permite cabeceras; solo `<meta>`). Propuesta de política en `docs/CIERRE_FASE_B_2026-10-18.md`, sin aplicar.
- Sin persistencia de negocio en el navegador (auditoría estática en CI y comprobación en producción). La sesión de Supabase vive solo en memoria. El origen `danytf.github.io` es compartido con otras apps de Wesser, cuyas claves de `localStorage` aparecen allí; la clave `rgr-auth` es de una versión antigua de este mapa y no se usa ni se limpia (observación, no cambiada).

## Repositorio y CI

- Workflows: `audit-static-catalog.yml` (job `audit`), `schema-smoke.yml` (job `postgres-smoke`, PostgreSQL 17: reconstruye el esquema, humo, historial y matriz RLS, y comprueba que toda migración está aplicada), `default-function-acl.yml`, `deploy-pages.yml`.
- Protección de `main` verificada por el titular el 18/10/2026 (ver CLAUDE.md).
- PR fusionados el 18/10/2026: #79 matriz RLS y baja de autores (H-10), #82 historial del estado compartido (H-12), #80 SRI y versiones fijas (H-01), #81 teclado en el panel (H-05), #83-#85 documentación. Antes: #78 consolidación de evidencias de las fases 1 y 2.
- Fase C (18/10/2026): #88 informe y datos sintéticos, #89 control de conflicto (H-11), #90 CSP (H-02), #91 permisos por ID y puntos personales (H-13, H-14).
- Pruebas: matriz RLS 973 celdas, 0 discrepancias, 781 denegaciones comprobadas; historial 29 comprobaciones; control de versión 20 comprobaciones; auditorías estáticas (incluida `audit-csp.mjs`) en verde.

## Hallazgos

Ver `HALLAZGOS.md`. Accesibilidad (H-28 a H-35): corregida en el PR #105 y verificada en producción (despliegue con el mismo SHA-256 que `main`; el titular comprobó los colores con su sesión en modo claro y oscuro); informe de índices sin uso (H-36): PR #104. El asesor de rendimiento de Supabase muestra 21 avisos `unused_index` (informativos y aceptados); los 23 índices con 0 escaneos incluyen 2 de restricción. H-27 (P2, latente: con 20.000 puntos el administrador esperaba 75 s al cargar el mapa): cerrado (PR #100 y PR #101), verificado en producción. H-26 (P2, latente: políticas RLS evaluadas por fila, 25 s con 50.000 puntos para el administrador): migración aplicada en producción (PR #99). Cerrados en la Fase C: H-02, H-11, H-13, H-14 y H-05 (verificado). Cerrados en la Fase D (uso en varias provincias y volumen): H-22 (PR #94 y migración aplicada), H-23 (P1, PR #95), H-20 y H-21 (PR #96), todos verificados en producción. Corregidos en el PR #98, pendiente de fusionar: H-15 a H-19 (P3, interfaz). H-25 (P3) aceptado por ahora por el titular. Riesgo actual pendiente de decisión del titular: H-24 (P2, plan gratuito de Supabase: pausa tras 7 días de poca actividad). Pendientes de producto (ROADMAP): panel de administración y ampliación del catálogo a toda España (hoy solo Granada, aún por completar). Además: H-03 (P3, recomendación), H-08 (Fase E) y H-09 (P3, aceptado).

## Entorno aislado de la Fase C

- Proyecto Supabase `mapas-e2e` (`obqodndkzznrpuwxzbsi`), creado el 18/10/2026 en plan gratuito y eliminado por el titular el mismo día al cerrar la fase. Para repetir las pruebas: `docs/traspaso/PRUEBAS.md` (sección E2E) y `supabase/e2e/seed_synthetic.sql`. Las ramas de Supabase no existen en el plan gratuito y el MCP no ofrece `get_cost`/`confirm_cost`: el coste lo presenta `create_project`/`create_branch` al llamarlas.

## Cosas verificadas por el titular o que dependen de él

- Verificado por el titular: protección de `main`; plan gratuito de la organización tras crear `mapas-e2e`.
- Verificado en la Fase C con cuenta sintética: H-05 (teclado en el panel). Verificado con la sesión del titular en producción (solo lectura): H-11 y H-02.
- Pendiente de él (limpieza local tras la Fase C): quitar los permisos temporales de `.claude/settings.local.json`, borrar `%APPDATA%\postgresql\pgpass.conf` (contraseña del proyecto ya eliminado); borrar del gestor de contraseñas de Chrome las credenciales de prueba de `127.0.0.1` si las guardó.
