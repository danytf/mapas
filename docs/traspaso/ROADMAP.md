# Hoja de ruta (desde el 18/10/2026)

Reglas de ejecución: ver `CLAUDE.md`. Cada fase termina con criterios de cierre explícitos y evidencia reproducible. Todo lo que escriba datos se prueba en un entorno aislado, nunca en producción.

## Fase C. Pruebas E2E en navegador (CERRADA el 18/10/2026)

**Entorno decidido el 18/10/2026:** proyecto Supabase aislado y gratuito `mapas-e2e` (las ramas no existen en el plan gratuito). Ver `ESTADO.md` y `docs/AUDITORIA_FASE_C_2026-10-18.md`. Texto original de la planificación:
- Opción recomendada: rama aislada de Supabase (`create_branch`). Antes, pedir aprobación del coste al titular. Crear cuentas sintéticas (administrador, usuario de la provincia con equipo, usuario de otra provincia, usuario activo sin provincia, usuario desactivado) y datos sintéticos. Las claves de la rama no se escriben en ningún fichero del repositorio ni en informes.
- Alternativa sin coste: Playwright con la red simulada (interceptar las llamadas a Supabase). Cubre la interfaz pero no RLS real; la autorización ya está cubierta por `rls_matrix.sql`.
- Nunca usar las cuentas ni los datos reales para pruebas con escritura.

**Pruebas a cubrir (con evidencia reproducible: guion, resultado y captura/log):**
1. Inicio de sesión y cierre; recarga exige iniciar sesión de nuevo (sesión solo en memoria).
2. Carga del catálogo desde Supabase; si falla la lectura, la app vacía el catálogo y no usa fallback local.
3. Filtros (categoría, municipio, texto, permiso) y panel de estadísticas, incluido uso solo con teclado (verificación manual de H-05).
4. Corrección de ubicación: guardar, recargar y confirmar el valor remoto; error y tiempo límite de 15 s; historial de ubicación.
5. Flujo de permisos: solicitar, conceder, caducar, cancelar; varias solicitudes por punto.
6. Visibilidad y límites por rol y provincia en la interfaz (administrador, usuario con provincia, sin provincia, desactivado).
7. Exportaciones JSON/CSV (manuales, con confirmación) y que no existe importador de copias antiguas.
8. Persistencia en el navegador: tras una sesión completa, `localStorage`, `sessionStorage`, IndexedDB, Cache Storage y cookies propias no contienen datos de negocio; sin service workers.
9. **H-11 opción A**: dos sesiones de la misma provincia guardando sobre el mismo punto; implementar el control de conflicto (diseño en `HALLAZGOS.md`), con migración, prueba SQL, paso en `schema-smoke.yml` y prueba E2E de dos sesiones.
10. **H-02 CSP por `<meta>`**: aplicar la política candidata (`docs/CIERRE_FASE_B_2026-10-18.md`), recorrer todos los flujos anteriores con la consola abierta y comprobar cero violaciones; si rompe algo, ajustar el mínimo imprescindible. Comprobar las cabeceras reales antes de afirmar nada.
11. Resistencia: pérdida de red durante un guardado, sesión caducada, respuesta de Supabase con error, doble clic en guardar.

**Criterios de cierre de la C:** todas las pruebas ejecutadas con resultado registrado en `docs/AUDITORIA_FASE_C_<fecha>.md`; cada fallo con ID, severidad y estado; H-11 cerrado o decisión escrita de aceptarlo; H-02 aplicado o decisión escrita; rama aislada eliminada al terminar (confirmar con el titular).

## Fase D. Integridad, dependencias, accesibilidad, rendimiento (SIGUIENTE)

Hecho: integridad del catálogo y del historial; dependencias fijadas con SRI; teclado del panel (H-05); auditoría XSS y de persistencia en CI.
Pendiente:
- Peso real de la carga inicial: bytes transferidos de `index.html`, recursos externos y consulta del catálogo (solo se sabe que las 791 filas ocupan unos 284 KB en base de datos; no es el tamaño de transferencia). Medir en el navegador (red) y registrar tiempos de primera pintura y de catálogo visible.
- Accesibilidad más allá del teclado: contraste, etiquetas de formularios, foco dentro de los diálogos, lector de pantalla en los flujos principales.
- Los 23 índices sin uso: no eliminar; si se revisan, solo informe con datos de uso reales.
- H-03 (`search_path` de `set_updated_at`): decidir si se corrige; cambio de bajo riesgo con migración y huellas.
- Registrar el rol de base de datos en `audit_log` cuando no hay JWT (mejora de trazabilidad).
- Hallazgos de la Fase C aplazados aquí por decisión del titular (18/10/2026), ver `HALLAZGOS.md`: H-15 a H-19 corregidos en el PR #98 (pendiente de fusionar); H-15 (bloquear «Guardar dirección y ubicación» mientras guarda), H-16 (mensajes de error en español y espera de 27 s), H-17 (lista vacía sin mensaje, etiqueta de valoración; el nombre del CSV se resolvió con H-21), H-18 (flechas en el menú y foco al cerrar el panel), H-19 (doble escritura de `user_app_state` al entrar) y H-20 (recuadro fijo de Granada en los puntos personales: P2, cerrado en el PR #96).
- Preparación para varias provincias (registrado el 18/10/2026 a petición del titular): H-21 (app centrada en Granada: geocodificación, vista inicial, municipio por defecto y nombre del CSV; P2), H-22 (la base no tiene en cuenta si la provincia está activa; P3) y H-23 (límite de 1.000 filas por petición de la API, confirmado, y la app no pagina; **P1, corregido en el PR #95**). H-20 y H-21 cerrados en el PR #96 y probados en el navegador con un Supabase simulado (usuarios de una y dos provincias, sin puntos y administrador) y en producción con la sesión del titular. H-25 (umbral de distancia al corregir ubicaciones): aceptado por ahora por el titular; revisar al ampliar el catálogo.
- Prueba de volumen para el catálogo de toda España (más de 50.000 puntos previstos por el titular): en un entorno aislado, cargar unos 50.000 puntos sintéticos y medir con un usuario de una o dos provincias y con el administrador: tiempo hasta el mapa visible, bytes transferidos, fluidez de filtros y lista (`renderList` reconstruye la lista entera en cada filtro) y marcadores. Con esas cifras, decidir si hace falta carga progresiva de marcadores, lista paginada o carga por provincia. Referencias medidas el 18/10/2026: 791 puntos ocupan 744 kB con índices (unos 960 bytes por punto) y la base entera 14 MB; 50.000 puntos serían del orden de 50 MB más la auditoría de la carga.

## Fase E. Backup, restauración y despliegue

- Averiguar qué cobertura de copia tiene el plan de Supabase (copias diarias, PITR, retención) con `get_project` y la documentación; registrar lo que se pueda demostrar y marcar lo que no.
- Prueba de restauración en un proyecto o rama aislados (coste: pedir aprobación antes). Registrar tiempos y qué se pierde.
- Las exportaciones JSON/CSV de la app no son un backup completo.
- Despliegue: documentar cómo revertir una publicación (revertir el commit en `main` y esperar al workflow de Pages) y comprobarlo en seco; confirmar que Pages despliega solo `index.html`.
- `docs/import-export-backups.md` es el punto de partida.
- H-24: documentar el plan de Supabase de producción y su efecto en la disponibilidad (pausa por inactividad del plan gratuito) y en las copias; según la decisión del titular sobre el plan, registrar cómo reactivar el proyecto si se pausa.

## Fase F. Cierre

Informe final con: resumen ejecutivo; matriz de 10 capas (el listado literal de capas del primer encargo no se conservó: construirla agrupando las evidencias por área: estado y reproducibilidad, base de datos y migraciones, autorización RLS, persistencia, concurrencia e integridad, aplicación y E2E, dependencias, accesibilidad, rendimiento, backup y despliegue; confirmar con el titular); defectos confirmados y correcciones; recomendaciones por prioridad; resultados de pruebas reproducibles; estado de RLS, permisos, funciones y triggers; persistencia; backups y restauración; commits, PR y checks; riesgos residuales y tareas que dependen del titular; criterios de cierre por fase. Formato por hallazgo: ID, capa, severidad, estado, evidencia, impacto, acción, prueba de regresión, riesgo residual, dependencia del titular.

## Pendientes de producto (fuera de la auditoría, decididos por el titular)

- **Panel de administración** (decisión del titular, 18/10/2026: se desarrollará más adelante). Hoy el administrador no tiene pantallas propias: dar de alta usuarios, asignar provincias y editar el catálogo maestro (nombres, categorías, puntos nuevos) se hace por SQL (`docs/ADMINISTRACION_CUENTAS.md`). Cuando se aborde: diseño previo con el titular, sin debilitar la autorización (las escrituras deben seguir protegidas por RLS y `is_admin()`) y con pruebas en un entorno aislado.
- **Ampliación del catálogo a toda España.** Hoy solo hay catálogo de Granada (791 puntos, aún por completar). La idea del titular es ir ampliándolo al resto de provincias. Antes de cargar otra provincia conviene tener resueltos H-20, H-21 y H-23, y cargar con el mismo procedimiento revisado que Granada (`supabase/seeds/`, `source_ref` único, sin inventar puntos ni coordenadas). Volumen previsto: más de 50.000 puntos (ver la prueba de volumen de la Fase D). La geocodificación masiva no puede hacerse con el servicio público de Nominatim que usa la app (su política de uso limita a una petición por segundo y no admite usos masivos): hará falta otra fuente de coordenadas o un procedimiento por lotes acordado, siempre fuera de la app.

## Dependencias del titular (resumen)

1. Aprobar el coste de la rama aislada o elegir la alternativa con red simulada.
2. Proporcionar o autorizar la creación de cuentas sintéticas en la rama aislada (nunca las reales).
3. Verificación visual final de lo que no se pueda automatizar.
4. Decisiones de diseño que surjan (por ejemplo, migrar permisos a tablas normalizadas).
5. Decidir el plan de Supabase de producción (H-24: el gratuito se pausa tras 7 días de poca actividad).
6. ~~Consultar el ajuste *Data API > Max rows*~~ Hecho por el titular el 18/10/2026: **1.000** (afecta a H-23, que pasa a prioridad P1).
