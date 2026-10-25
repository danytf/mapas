# Estado del proyecto a 18/10/2026 (traspaso a Visual Studio Code)

`main` en `aac12ea`. Todo lo descrito está fusionado, desplegado y verificado salvo lo marcado como pendiente. Evidencias detalladas: `docs/AUDITORIA_FASE_B_2026-10-18.md`, `docs/CIERRE_FASE_B_2026-10-18.md`, `docs/CIERRE_AUDITORIA_FASES_1_2_2026-10-18.md`.

## Fases

| Fase | Estado |
|---|---|
| A. Reconstruir el estado real | Cerrada |
| B. Seguridad y persistencia | Cerrada (H-11 aplazado a la C por decisión del titular) |
| C. Pruebas E2E en navegador | Cerrada el 18/10/2026 (`docs/AUDITORIA_FASE_C_2026-10-18.md`): 11 pruebas y arrastre del pin; H-02, H-11, H-13 y H-14 corregidos y desplegados; H-15 a H-20 pasan a la D |
| D. Integridad, dependencias, accesibilidad, rendimiento | Cerrada el 18/10/2026 (`docs/AUDITORIA_FASE_D_2026-10-18.md`, `..._ACCESIBILIDAD_...` y `..._INDICES_...`): H-03, H-15 a H-23, H-26, H-27 y H-28 a H-35 corregidos y desplegados, H-36 informe; H-24 y H-25 aceptados por el titular. Sin probar: lectores de pantalla reales, zoom y objetivos táctiles |
| E. Backup, restauración y despliegue | Cerrada el 19/10/2026 (`docs/AUDITORIA_FASE_E_2026-10-18.md`, `docs/import-export-backups.md`): H-37 y H-38 cerrados; restauración probada en un proyecto aislado (ya eliminado) con las 6 huellas y los recuentos idénticos a producción; plan gratuito aceptado (H-24) con copia mensual manual |
| F. Informe final | Cerrada el 19/10/2026 (`docs/AUDITORIA_INFORME_FINAL_2026-10-19.md`); capas 8 y 10 parciales; privacidad parcial (auditoría técnica del 19/10/2026) y observabilidad no cubierta (ver ROADMAP, «Auditorías futuras») |

## Producción (Supabase `wwoczmihhupofwmlmgga`)

- Migraciones: 31 registradas, última `20261018232107_admin_list_users_private_wrapper` (panel de administración, PR A: `admin_list_users()` y protección del último administrador; antes `20261018192324` de H-03). Coinciden una a una con `supabase/migrations/`.
- Huellas del esquema público (comparables con `supabase/tools/schema_fingerprint.sql`, verificadas también en la restauración de prueba del 19/10/2026): políticas 51 `f12aa180`, permisos de tabla 57 `374f58c4`, funciones propias 21 `a3b79a0d` (sin `rls_auto_enable`, función de la plataforma), funciones privadas 5 `f09ad78b`, triggers 36 `bf342f42`, tablas con RLS 17 `e9ad42c3`.
- 17 tablas, todas con RLS. Ninguna concede privilegios a `anon`.
- Avisos del asesor de seguridad: solo "protección frente a contraseñas filtradas desactivada" (aceptado, no tocar).
- Datos (consulta del 18/10/2026): 791 establecimientos, todos activos y con coordenadas; 3 perfiles (1 administrador); 2 filas de `user_provinces`; 3 filas de `establishment_app_state` (versión máxima 2; la tercera es de uso real del 18/10/2026); 3 de `user_app_state`; 0 en `permit_applications`, `permit_grants` y `followups` (el estado real de permisos vive en el JSONB de `establishment_app_state`); 856 filas de `audit_log`; 43 de `establishment_location_history`; 0 de `establishment_app_state_history` (aún no hubo sobrescrituras).
- Catálogo limpio: sin duplicados reales; solo 2 pares de coordenadas coincidentes (un Mercadona y un centro comercial en el mismo edificio, Armilla y Granada), no son defectos.
- Auditoría: 807 de 856 filas sin usuario (carga del catálogo, arranque de perfiles y 8 actualizaciones SQL del 16-17/10); toda edición desde la app lleva autor. Es una inferencia, no un defecto confirmado. Recomendación pendiente: registrar el rol de base de datos cuando no hay JWT.

## Carga nacional (19/10/2026)

- N0 (municipios de Andalucía con código INE) y N1 (246 estaciones de Andalucía, `docs/CARGA_N1_ESTACIONES_ANDALUCIA.md`) cargadas en producción y verificadas en solo lectura. Tras N1: 1.059 establecimientos (Estaciones 260). Los puntos de la N1 llevan `source_ref` `catalogo-andalucia:estaciones:<tipo>-<id>` y `location_source` `openstreetmap:<tipo>/<id>`; los 8 que quedaron «por revisar» se resolvieron el mismo día (6 archivados, 2 verificados con ubicación manual), de modo que el lote tiene 240 activos y 6 archivados.
- **Favoritos y altas de Granada (19/10/2026):** `formacion@wesser.es` tiene 59 favoritos de trabajo en Granada; se añadieron 5 puntos al catálogo para completarlos (1.464 puntos en total). El municipio del «Lidl – Ctra. Gabia, 9» está corregido (Las Gabias, con la acción de administrador «Cambiar municipio» de la ficha, PR #146) y el CS Padul está revisado y verificado. Detalle en `docs/CARGA_CATALOGO_GRANADA.md`.
- N2 (Correos de Andalucía, 400 oficinas, `docs/CARGA_N2_CORREOS_ANDALUCIA.md`) cargada y verificada: 1.459 establecimientos (Correos 481).
- N2 (grandes superficies de Andalucía, 258 puntos: Carrefour 187, Decathlon 20, El Corte Inglés 19, Leroy Merlin 16, MediaMarkt 11, IKEA 5; `docs/CARGA_N2_GRANDES_SUPERFICIES_ANDALUCIA.md`) cargada y verificada el 19/10/2026: 1.722 establecimientos. Calles completadas después (12 con Nominatim y 14 facilitadas por el titular; `docs/COMPLETAR_DIRECCIONES_GRANDES_SUPERFICIES.md`). Quedan sin calle los 2 cerrados permanentemente (IKEA Algeciras y Carrefour Santa Elena), pendientes de archivar desde la ficha. Los códigos postales (14 del titular y unos 182 sugeridos por Nominatim) se escriben a mano desde la ficha con la acción de administrador del PR #151 (`supabase/seeds/grandes-superficies-andalucia/codigos_postales_*.csv`); no se pueden escribir por SQL.
- **Catálogo completo (19/10/2026, verificado en solo lectura):** 1.709 puntos activos y 13 archivados (1.722 en total). Todos los activos tienen dirección, código postal de 5 cifras de su provincia, coordenadas y municipio. Los códigos postales los escribió el administrador desde la ficha (PR #151) a partir de Nominatim inverso (`scripts/catalogue/completar_cp_desde_base.py`, solo lectura) y de búsqueda por municipio, con 16 códigos dudosos y 3 de Calañas/La Zarza-Perrunal resueltos uno a uno por el titular. Son el código del lugar consultado, no una verificación postal; en estaciones fuera de pueblo, el del municipio. Archivados por cierre o fuera de servicio (el titular, desde la ficha): IKEA Algeciras, Carrefour Santa Elena, estaciones de Río Arillo, Guadaíra, Las Madrigueras y Los Milanos, más los 7 anteriores. Direcciones y coordenadas facilitadas por el titular: `supabase/seeds/grandes-superficies-andalucia/calles_titular.sql`, `direcciones_titular_2026-10-19.sql` y `direcciones_motril_2026-10-19.sql` (aplicados). Correos San Juan de Aznalfarache cambió de coordenadas (37.35846, -6.03525).
- App (19/10/2026, PR #144 a #162, todos fusionados y desplegados): favoritos personales, ficha del punto en panel lateral, cambio de municipio y de código postal para administradores desde la ficha (#146, #151), tokens de color de estado con modo oscuro (#148), objetivos táctiles de 44 px (#149) y Panel resumen y Administración con el lenguaje visual de la ficha (#154). Verificados por hash público contra `main`; sin probar en navegador con sesión de administrador, lector de pantalla ni móvil físico.
- **Sesión del 19/10/2026 (PR #157 a #162, todos fusionados y desplegados):** botones de municipio y código postal con aspecto de botón (#157, #159); función `public.admin_set_postal_codes(p_items jsonb, p_only_empty boolean)` aplicada en producción (versión `20261019191833`, `SECURITY INVOKER`, solo administradores; `docs/CODIGOS_POSTALES_MASIVOS.md`; probada en producción con llamadas que no escriben, falta una escritura masiva real) (#158); escala de radios y tamaños de letra con tokens `--r-*` y `--fs-*` (#159); colores de categoría, gamificación, cabecera, estado del pin, confeti, niebla y resultado de la ubicación como tokens `--cat-*`, `--gam-*`, `--hd-*`, `--pin-*`, `--confetti-*`, `--fog-*`, `--res-*` (#160, #162); formularios de solicitudes y concesiones de la ficha sin barra horizontal (#161); pestañas de «Mi progreso» que caben en móvil (#162); botón de cerrar unificado en Panel resumen, Administración y Calendario. Revisado en un navegador local con el Supabase simulado, en claro y oscuro y en marcos de 390 px; sin probar en móvil físico ni con lector de pantalla. La prueba de accesibilidad (`test-a11y-fase-d.mjs`) dejó de comprobar el contraste de categorías y estados al pasar a tokens (pasaba en vacío) y desde #162 los resuelve en claro y oscuro (129 pares).
- Catálogo (19/10/2026, tras archivar el titular 13 apeaderos de autobús): 1.696 puntos activos y 26 archivados.
- N2 (resto de Andalucía, 4.175 puntos en 7 categorías: Supermercado 2.338, Entidad oficial 832, Gimnasios 353, Centro de salud 268, Centro comercial 160, Hospital 126, Bricolaje 98; `docs/CARGA_N2_ANDALUCIA_RESTO.md`) cargada y verificada el 19/10/2026: 5.897 establecimientos en total. Calle y código postal calculados en local desde el pbf, sin Nominatim; 1.060 puntos sin código postal y 78 sin calle por completar. Decisiones del titular para acelerar la carga nacional: código postal local, Andalucía primero, aprobación permanente para lotes que pasan los umbrales. Depuración de Hospital en Andalucía (23/10/2026): 18 puntos archivados con nota (11 antes por no ser hospitales y 7 tras revisar los dudosos: el Valme duplicado, los ambulatorios de La Luisiana y Nueva Andalucía, CARE Los Alcores, Centro de Alta Resolución Nicolás Salmerón de Almería, el Hospital de Alta Resolución de Écija duplicado de la Avenida Dr. Sánchez Malo y Barbarela Málaga, que es un café bar). Se mantienen Macarena y Policlínico Macarena, Valme y GenesisCare Málaga por decisión del titular; recuperables desde Administración.
- Provincias activas: las 8 de Andalucía (activadas el 19/10/2026 por SQL con el procedimiento de `docs/ADMINISTRACION_CUENTAS.md`). Asignadas las 8 a `daniel.marrero@wesser.es` y `formacion@wesser.es` (administrador); `rsc@wesser.es` solo Málaga.
- Límites conocidos: calles de la N1 orientativas (7 puntos sin calle); 225 sin código postal; OpenStreetMap no indica si una estación tiene servicio.

## Aplicación publicada

- **Auditoría visual, fases 1 a 3** (19/10/2026, desplegadas y verificadas por hash): cabecera con indicadores operativos y de progreso en grupos, filtros de categoría, valoración, orden y cadena plegados bajo «Más filtros» con contador (PR #140); texto mínimo de 12 px (PR #141); **ficha del punto como panel lateral derecho** con estado, seguimiento, dirección y contacto siempre visibles, pestañas Solicitudes/Concesiones/Ubicación y acciones destructivas en «Más acciones» (PR #142, `docs/DISENO_FICHA_PUNTO.md`). `DESIGN.md` documenta el sistema visual (PR #139). El Supabase simulado (`scripts/dev/mock-supabase.mjs`) ahora admite escribir el estado compartido con el protocolo de versiones. Pendientes visuales: ver `ROADMAP.md`.
- **Calendario semanal** (19/10/2026, PR #137): sección propia en el menú (Informes → Calendario semanal) con provincia, ONG, semana, filtros de estado, resumen de captadores y siete columnas con una silueta de barras y una tarjeta por permiso; se retiró «Permisos por semana» del panel resumen. Solo lee datos en memoria (sin cambios de base de datos ni persistencia en el navegador). Verificado en producción por hash; probado en el navegador con el Supabase simulado. Sin probar: lectores de pantalla, modo oscuro del sistema real y revisión con permisos reales del titular. Diseño en `docs/DISENO_CALENDARIO_SEMANAL.md`.
- Panel de administración v1 (19/10/2026): menú «Usuarios y provincias» solo para administradores (rol, estado, nombre, provincias y activación de provincias; el alta de cuentas sigue en Supabase). Verificado: URL pública con el mismo SHA-256 que `main`, opción oculta sin sesión, prueba del titular como administrador (lectura). Las escrituras se probaron solo contra el Supabase simulado y en SQL local, nunca en producción. Diseño en `docs/DISENO_PANEL_ADMINISTRACION.md`, uso en `docs/ADMINISTRACION_CUENTAS.md`.
- Mejoras de la app (19/10/2026, desplegadas y probadas por el titular): filtro de **Municipio** en la búsqueda; **Agregar punto** con desplegables de provincia y municipio (municipios leídos de Supabase, paginados); y **desactivar punto** (personal: `user_app_state.inactive`; sigue en la lista, marcado, y no se dibuja en el mapa).
- **Archivar puntos** (administradores): botón «Archivar para todos» en la ficha y sección «Puntos archivados» en Administración para restaurarlos. Se añadió porque la protección de la base (`guard_sensitive_updates`) solo permite cambiar el estado de un punto a un administrador identificado, y un cambio por SQL de servicio no es válido (ni debe saltarse). Probado contra el Supabase simulado.
- https://danytf.github.io/mapas/ sirve exactamente `main` (verificado en navegador tras las fusiones del 18/10).
- Recursos externos fijados con versión exacta y SRI sha384: Leaflet 1.9.4, leaflet.markercluster 1.5.3 (unpkg) y supabase-js 2.118.0 (jsdelivr). Google Fonts exento.
- Cabeceras de seguridad: GitHub Pages no permite cabeceras HTTP; la CSP va como `<meta>` en `index.html` (H-02, PR #90, comprobada en producción sin violaciones). GitHub Pages publica solo `index.html` (H-37, PR #109).
- Sin persistencia de negocio en el navegador (auditoría estática en CI y comprobación en producción). La sesión de Supabase vive solo en memoria. El origen `danytf.github.io` es compartido con otras apps de Wesser, cuyas claves de `localStorage` aparecen allí; la clave `rgr-auth` es de una versión antigua de este mapa y no se usa ni se limpia (observación, no cambiada).

## Repositorio y CI

- Workflows: `audit-static-catalog.yml` (job `audit`), `schema-smoke.yml` (job `postgres-smoke`, PostgreSQL 17: reconstruye el esquema, humo, historial y matriz RLS, y comprueba que toda migración está aplicada), `default-function-acl.yml`, `deploy-pages.yml`.
- Protección de `main` verificada por el titular el 18/10/2026 (ver CLAUDE.md).
- PR fusionados el 18/10/2026: #79 matriz RLS y baja de autores (H-10), #82 historial del estado compartido (H-12), #80 SRI y versiones fijas (H-01), #81 teclado en el panel (H-05), #83-#85 documentación. Antes: #78 consolidación de evidencias de las fases 1 y 2.
- Fase C (18/10/2026): #88 informe y datos sintéticos, #89 control de conflicto (H-11), #90 CSP (H-02), #91 permisos por ID y puntos personales (H-13, H-14).
- Pruebas: matriz RLS 973 celdas, 0 discrepancias, 781 denegaciones comprobadas; historial 29 comprobaciones; control de versión 20 comprobaciones; auditorías estáticas (incluida `audit-csp.mjs`) en verde.

## Hallazgos

Ver `HALLAZGOS.md`. Accesibilidad (H-28 a H-35): corregida en el PR #105 y verificada en producción (despliegue con el mismo SHA-256 que `main`; el titular comprobó los colores con su sesión en modo claro y oscuro); informe de índices sin uso (H-36): PR #104. El asesor de rendimiento de Supabase muestra 21 avisos `unused_index` (informativos y aceptados); los 23 índices con 0 escaneos incluyen 2 de restricción. H-27 (P2, latente: con 20.000 puntos el administrador esperaba 75 s al cargar el mapa): cerrado (PR #100 y PR #101), verificado en producción. H-26 (P2, latente: políticas RLS evaluadas por fila, 25 s con 50.000 puntos para el administrador): migración aplicada en producción (PR #99). Cerrados en la Fase C: H-02, H-11, H-13, H-14 y H-05 (verificado). Cerrados en la Fase D (uso en varias provincias y volumen): H-22 (PR #94 y migración aplicada), H-23 (P1, PR #95), H-20 y H-21 (PR #96), todos verificados en producción. Corregidos en el PR #98, pendiente de fusionar: H-15 a H-19 (P3, interfaz). H-25 (P3) aceptado por ahora por el titular. Riesgo actual pendiente de decisión del titular: H-24 (P2, plan gratuito de Supabase: pausa tras 7 días de poca actividad). Pendientes de producto (ROADMAP): panel de administración y ampliación del catálogo a toda España (hoy solo Granada, aún por completar). Además: H-03 (P3, recomendación), H-08 (Fase E) y H-09 (P3, aceptado).

## Copia de seguridad y restauración (Fase E)

- Copia: `scripts/backup-supabase.sh` (a mano, una vez al mes y antes de cada migración; la cadena de conexión no se guarda en ningún sitio). Primera copia válida con sumas de control: 19/10/2026, guardada por el titular fuera de GitHub y de Supabase. Procedimiento de restauración probado en `docs/import-export-backups.md`.
- Proyecto aislado de la prueba (`mapas-restore-test`, plan gratuito): eliminado por el titular el 19/10/2026; `list_projects` solo muestra `mapas-dev`.
- No se restauran los usuarios de autenticación, la configuración de Auth ni las claves del proyecto nuevo.

## Entorno aislado de la Fase C

- Proyecto Supabase `mapas-e2e` (`obqodndkzznrpuwxzbsi`), creado el 18/10/2026 en plan gratuito y eliminado por el titular el mismo día al cerrar la fase. Para repetir las pruebas: `docs/traspaso/PRUEBAS.md` (sección E2E) y `supabase/e2e/seed_synthetic.sql`. Las ramas de Supabase no existen en el plan gratuito y el MCP no ofrece `get_cost`/`confirm_cost`: el coste lo presenta `create_project`/`create_branch` al llamarlas.

## Cosas verificadas por el titular o que dependen de él

- Verificado por el titular: protección de `main`; plan gratuito de la organización tras crear `mapas-e2e`.
- Verificado en la Fase C con cuenta sintética: H-05 (teclado en el panel). Verificado con la sesión del titular en producción (solo lectura): H-11 y H-02.
- Pendiente de él (limpieza local tras la Fase C): quitar los permisos temporales de `.claude/settings.local.json`, borrar `%APPDATA%\postgresql\pgpass.conf` (contraseña del proyecto ya eliminado); borrar del gestor de contraseñas de Chrome las credenciales de prueba de `127.0.0.1` si las guardó.


## Rediseño visual premium (PR #164, rama feat/rediseno-premium, sin fusionar)

La gamificación se retiró en el PR #164 por error de interpretación y se restauró en el PR siguiente (decisión del titular). Paleta carbón/papel; cabecera de 56 px; «Limpiar filtros»; estados de la lista; buscador y lista más escaneables; pin seleccionado; «Guardando…» en la ficha; móvil con conmutador Mapa/Lista y filtros plegables; microinteracciones con un token de duración y `prefers-reduced-motion`. Detalle en `DESIGN.md`. Verificado en local con el Supabase simulado (1440×900, 1366×768, 768×1024 y 390×844; claro y oscuro). Pendiente del titular: móvil físico, lector de pantalla y sesión real.


## Cierre del 19/10/2026

- Rediseño premium (PR #164), gamificación restaurada (PR #165) y Wesser Spatial Canvas, el rediseño del mapa (PR #167), fusionados y desplegados.
- Códigos postales: 918 escritos en producción (142 puntos siguen sin código). Detalle en `docs/traspaso/ROADMAP.md`.
- Pendiente del titular: probar en móvil físico y con lector de pantalla; comprobar la licencia de Esri para uso comercial de las teselas; valorar los ~139 favoritos de Andalucía; copia mensual con `scripts/backup-supabase.sh`.

## Extremadura (22/10/2026)

Cargada en producción (388 municipios, 1.230 puntos: Badajoz 677, Cáceres 553) y provincias activadas. Códigos postales: 307 escritos, 219 sin código; calles: 12 escritas, 18 sin calle. 18 puntos que no eran hospitales archivados (7 + 11 en Andalucía). Total de la base: 7.127 puntos, 7.083 visibles. Falta asignar las provincias a los usuarios. Detalle en `docs/CARGA_N2_EXTREMADURA.md`.

## La Rioja (23/10/2026)

Cargada en producción (174 municipios, 246 puntos) y provincia activada. Códigos postales: 68 escritos, 15 sin código; calles: 5 escritas, 7 sin calle. Total de la base: 7.373 puntos, 7.329 visibles. Falta asignar la provincia a los usuarios. Detalle en `docs/CARGA_N2_LA_RIOJA.md`.

## Murcia (23/10/2026)

Cargada en producción (45 municipios, 782 puntos; 6 archivados por no corresponder a su categoría). Total de la base: 8.155 puntos. Sin asignar a usuarios por decisión del titular hasta terminar toda España. Códigos postales y calles completados (223 y 17); pendientes 111 códigos y 31 calles. Detalle en `docs/CARGA_N2_MURCIA.md`.

## Canarias (23/10/2026)

Cargada en producción (88 municipios, 1.627 puntos: Las Palmas 779, Santa Cruz de Tenerife 848). Total de la base: 9.782 puntos. Pendientes: 437 códigos postales y 41 calles. Sin asignar a usuarios por decisión del titular hasta terminar toda España. Detalle en `docs/CARGA_N2_CANARIAS.md`.

## Expedientes en tablas (23/10/2026)

- **Fuente de verdad:** solicitudes, concesiones y seguimientos de los puntos del catálogo viven en `permit_applications`, `permit_grants` y `followups`. `establishment_app_state` solo guarda contacto, notas y valoración del punto; sus listas antiguas (`solicitudes`, `historial`) se conservan sin tocar como copia de reversión. Los puntos personales siguen en `user_app_state.customPermits`.
- **Migración `20261023160115_permit_workflow`** (aditiva, aplicada en producción): datos de la decisión, `legacy_ref`, una concesión por solicitud, trigger de ciclo de vida, comprobación del responsable de un seguimiento y funciones atómicas e idempotentes `approve_permit_application`, `resolve_permit_application` y `cancel_permit_grant`. Detalle y reversión: `docs/MIGRACION_PERMISOS_RELACIONAL.md`.
- **Volcado del JSON a las tablas:** hecho el 23/10/2026 por el titular en el editor SQL (2 solicitudes, 6 concesiones, 1 seguimiento; reconciliación con 0 diferencias). Las herramientas `supabase/tools/backfill_permits_from_state.sql` y `reconcile_permits.sql` son idempotentes.
- **Aplicación:** PR #191 (ficha con guardado verificable, aprobar conservando la solicitud, panel por expedientes, calendario con autorizados/por aprobar/seguimientos por separado, fechas en `Europe/Madrid`) y PR #193 (lectura y escritura en las tablas con control de versión). Reglas de negocio en `index.html` (bloque «Reglas de expedientes») y probadas en `scripts/test-expedientes.mjs`. Diagnóstico: `docs/AUDITORIA_EXPEDIENTES_2026-10-23.md`.
- **Pruebas:** SQL local `permit_workflow` (42) y `permit_backfill` (23); estáticas de CLAUDE.md; navegador solo con el Supabase simulado (`scripts/dev/mock-supabase.mjs` simula las tres tablas, las funciones y fallos con `/__fail`). **Sin probar:** sesión real en producción, móvil físico, lector de pantalla, dos usuarios con permisos reales.
- **Huellas del esquema (23/10/2026, idénticas en local y producción):** políticas 51 `f12aa180`, permisos de tabla 57 `374f58c4`, funciones propias 28 `8e76f7c5`, funciones privadas 6 `39b74823`, triggers 39 `12e54ed8`, tablas con RLS 17 `e9ad42c3`. Sustituyen a las del 18/10/2026 más arriba.
- **Seguimientos:** responsable (cualquier administrador o usuario con la provincia del punto, vía `list_establishment_assignees`, migración `20261023164238`: devuelve id y etiqueta, nunca el correo) y siguiente acción en la ficha; el seguimiento de un punto sin solicitud se muestra en la ficha con el botón «Hecho».
- **Límites:** sin copia previa a la migración (necesita la cadena de conexión del titular); los permisos temporales de `.claude/settings.local.json` deben quedar vacíos; los seguimientos de un punto sin solicitud solo se pueden cerrar, no crear, desde la ficha.
- **Incidente corregido (23/10/2026):** las funciones de aprobar, denegar y cancelar señalaban el conflicto con SQLSTATE `40001`, que la API de Supabase reintenta sin límite: una cancelación en conflicto dejó tres conexiones repitiendo la llamada cada 10 ms hasta cerrarlas a mano con `pg_terminate_backend`. Migración `20261023170237_permit_conflict_code`: el conflicto es ahora `PT409` (HTTP 409). Regla: no usar `40001` ni `40P01` en funciones expuestas por la API. Huellas de funciones públicas recalculadas tras este cambio: ver `schema_fingerprint.sql`.
- **Registros de prueba en producción (23/10/2026, a borrar antes del lanzamiento):** ONG `PRUEBA-CLAUDE` y `PRUEBA-CLAUDE-2` en el punto Covirán de Cenes de la Vega (2 solicitudes, 1 concesión, 1 seguimiento cerrado); y, creada antes por el titular o por otra persona, 1 concesión sin solicitud enlazada.

## Centro de permisos v1 (25/10/2026)

- PR #198 (`7990fb8`), desplegado y verificado: la URL pública sirve el mismo SHA-256 que `main` y contiene el botón del menú. Entrada «Centro de permisos» (menú → Informes): bandejas de Solicitudes y Concesiones de todos los puntos del ámbito del usuario, con filtros de provincia, ONG, estado y texto, cinco cifras clicables y apertura de la ficha del punto desde cada fila. **Solo lectura**: usa los expedientes ya en memoria y las reglas compartidas (`expedientesDe`, `indicadores`), por lo que sus cifras son las del Panel resumen. Prueba: `scripts/test-centro.mjs` (en CI).
- Probado en navegador solo con el Supabase simulado (administrador sintético, 4 solicitudes y 4 concesiones). **Sin probar:** sesión real en producción, usuario provincial, móvil físico, lector de pantalla.
- Detalle conocido: la cabecera de la app cuenta como «permisos vigentes» los puntos con estado «concedido», que incluye concesiones futuras; el Centro y el Panel cuentan concesiones vigentes. No se ha cambiado.
