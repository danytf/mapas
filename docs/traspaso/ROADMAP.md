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

## Fase D. Integridad, dependencias, accesibilidad, rendimiento (CERRADA el 18/10/2026)

Hecho: integridad del catálogo y del historial; dependencias fijadas con SRI; teclado del panel (H-05); auditoría XSS y de persistencia en CI.
Pendiente:
- ~~Peso real de la carga inicial~~ Hecho el 18/10/2026: unos 199 kB comprimidos sin teselas ni catálogo, primer contenido pintado a 672 ms (ver `docs/AUDITORIA_FASE_D_2026-10-18.md`).
- Accesibilidad más allá del teclado: **hecha en el PR #105 (H-28 a H-35)**; queda sin probar el modo oscuro del sistema real, lectores de pantalla reales, zoom y objetivos táctiles, y como decisiones aparte el glifo IKEA, el patrón completo de pestañas, la estructura de la lista y el anuncio del recuento tras filtrar (ver `docs/AUDITORIA_FASE_D_ACCESIBILIDAD_2026-10-18.md`).
- Los 23 índices sin uso: **informe hecho (PR #104, H-36), sin acción; no se elimina ninguno.** Repetir la consulta con 8-12 semanas de estadísticas y funciones de seguimientos o importación en uso.
- ~~H-03 (`search_path` de `set_updated_at`)~~ y ~~registrar el rol de base de datos en `audit_log` cuando no hay JWT~~: hechos en el PR #102 (migración `20261018192324`), aplicados y verificados en producción.
- Hallazgos de la Fase C aplazados aquí por decisión del titular (18/10/2026), ver `HALLAZGOS.md`: H-15 a H-19 corregidos en el PR #98 (fusionado); H-15 (bloquear «Guardar dirección y ubicación» mientras guarda), H-16 (mensajes de error en español y espera de 27 s), H-17 (lista vacía sin mensaje, etiqueta de valoración; el nombre del CSV se resolvió con H-21), H-18 (flechas en el menú y foco al cerrar el panel), H-19 (doble escritura de `user_app_state` al entrar) y H-20 (recuadro fijo de Granada en los puntos personales: P2, cerrado en el PR #96).
- Preparación para varias provincias (registrado el 18/10/2026 a petición del titular): H-21 (app centrada en Granada: geocodificación, vista inicial, municipio por defecto y nombre del CSV; P2), H-22 (la base no tiene en cuenta si la provincia está activa; P3) y H-23 (límite de 1.000 filas por petición de la API, confirmado, y la app no pagina; **P1, corregido en el PR #95**). H-20 y H-21 cerrados en el PR #96 y probados en el navegador con un Supabase simulado (usuarios de una y dos provincias, sin puntos y administrador) y en producción con la sesión del titular. H-25 (umbral de distancia al corregir ubicaciones): aceptado por ahora por el titular; revisar al ampliar el catálogo.
- Prueba de volumen para el catálogo de toda España (más de 50.000 puntos previstos por el titular): **la parte de base de datos está hecha en una base local con 50.000 puntos (H-26, PR #99, `supabase/tools/volume/`); no hace falta un proyecto de Supabase.** **La parte del navegador también está hecha con el Supabase simulado (H-27, PR #100): 3,9 s hasta el mapa con 50.000 puntos tras la corrección (antes, minutos).** Medir con un usuario de una o dos provincias y con el administrador: tiempo hasta el mapa visible, bytes transferidos, fluidez de filtros y lista (`renderList` reconstruye la lista entera en cada filtro) y marcadores. Con esas cifras, decidir si hace falta carga progresiva de marcadores, lista paginada o carga por provincia. Referencias medidas el 18/10/2026: 791 puntos ocupan 744 kB con índices (unos 960 bytes por punto) y la base entera 14 MB; 50.000 puntos serían del orden de 50 MB más la auditoría de la carga.

## Fase E. Backup, restauración y despliegue (CERRADA el 19/10/2026; ver `docs/AUDITORIA_FASE_E_2026-10-18.md` y `docs/import-export-backups.md`)

- Averiguar qué cobertura de copia tiene el plan de Supabase (copias diarias, PITR, retención) con `get_project` y la documentación; registrar lo que se pueda demostrar y marcar lo que no.
- Prueba de restauración en un proyecto o rama aislados (coste: pedir aprobación antes). Registrar tiempos y qué se pierde.
- Las exportaciones JSON/CSV de la app no son un backup completo.
- Despliegue: documentar cómo revertir una publicación (revertir el commit en `main` y esperar al workflow de Pages) y comprobarlo en seco; confirmar que Pages despliega solo `index.html`.
- `docs/import-export-backups.md` es el punto de partida.
- H-24: documentar el plan de Supabase de producción y su efecto en la disponibilidad (pausa por inactividad del plan gratuito) y en las copias; según la decisión del titular sobre el plan, registrar cómo reactivar el proyecto si se pausa.

## Fase F. Cierre (CERRADA el 19/10/2026: `docs/AUDITORIA_INFORME_FINAL_2026-10-19.md`, matriz confirmada con escala Cerrada/Parcial/No cubierta/Bloqueada)

Informe final con: resumen ejecutivo; matriz de 10 capas (el listado literal de capas del primer encargo no se conservó: construirla agrupando las evidencias por área: estado y reproducibilidad, base de datos y migraciones, autorización RLS, persistencia, concurrencia e integridad, aplicación y E2E, dependencias, accesibilidad, rendimiento, backup y despliegue; confirmar con el titular); defectos confirmados y correcciones; recomendaciones por prioridad; resultados de pruebas reproducibles; estado de RLS, permisos, funciones y triggers; persistencia; backups y restauración; commits, PR y checks; riesgos residuales y tareas que dependen del titular; criterios de cierre por fase. Formato por hallazgo: ID, capa, severidad, estado, evidencia, impacto, acción, prueba de regresión, riesgo residual, dependencia del titular.

## Auditorías futuras (no cubiertas)

- Privacidad: parte técnica auditada (`docs/AUDITORIA_PRIVACIDAD_2026-10-19.md`, H-39 y H-40 abiertos); falta la parte jurídica (base jurídica, aviso a usuarios, contratos con Supabase y GitHub) con quien lleve la protección de datos en Wesser.
- Observabilidad y respuesta a incidentes.
- Identidad: auditada en `docs/AUDITORIA_IDENTIDAD_2026-10-19.md` (revocación en base de datos verificada; falta leer en el panel de Supabase la duración de sesión y probar la recuperación por correo con una cuenta controlada por el titular).
- Accesibilidad manual: lectores de pantalla reales, zoom y objetivos táctiles.
- Reversión real de un despliegue en producción.

## Pendientes de producto (fuera de la auditoría, decididos por el titular)

- **Panel de administración** (decisión del titular, 18/10/2026; diseño de la v1 aprobado el 19/10/2026 en `docs/DISENO_PANEL_ADMINISTRACION.md`; **v1 HECHA el 19/10/2026**: PR A (base de datos, migraciones `20261018231945` y `20261018232107`) y PR B (pantalla, PR #124) fusionados y desplegados; el titular lo probó con su sesión de administrador (solo lectura). Alcance original: usuarios y provincias, alta en Supabase, correo visible solo para administradores). Hoy el administrador no tiene pantallas propias: dar de alta usuarios, asignar provincias y editar el catálogo maestro (nombres, categorías, puntos nuevos) se hace por SQL (`docs/ADMINISTRACION_CUENTAS.md`). Cuando se aborde: diseño previo con el titular, sin debilitar la autorización (las escrituras deben seguir protegidas por RLS y `is_admin()`) y con pruebas en un entorno aislado.
- **Catálogo de Granada: terminado el 19/10/2026** (procedimiento y registro en `docs/CARGA_CATALOGO_GRANADA.md`): Bricolaje (1 punto), Estaciones (14, con 3 por revisar), Tiendas de mascotas (7: Tiendanimal, Kiwoko, Cash Mascota, Mundo Animal; OpenStreetMap solo recoge 1 Tiendanimal, se ampliará con una lista del titular si la facilita). **Eventos queda vacía de momento por decisión del titular.**
- **Calendario semanal: HECHO el 19/10/2026** (PR #137, `docs/DISENO_CALENDARIO_SEMANAL.md`). Pendiente: revisión del titular con permisos reales.
- **Auditoría visual de la app** (decisión del titular, 19/10/2026; método y hallazgos en la sesión del 19/10/2026 con Impeccable 4.5.0, sistema documentado en `DESIGN.md` y `.impeccable/design.json`; puntuación inicial 14/20). **Hecho:** cabecera con indicadores agrupados, filtros plegables con contador y botón «Entrar» legible en oscuro (PR #140); texto mínimo de 12 px (PR #141); ficha del punto en panel lateral (PR #142, `docs/DISENO_FICHA_PUNTO.md`); calendario semanal (PR #137). **Pendiente, por orden de impacto:**
  1. Colores de estado y de gamificación como tokens con variante oscura (`extract`); hoy hay 157 colores fijos y el detector marca 44 fuera de `DESIGN.md`.
  2. Escala de radios (hoy ~20 distintos) y de tamaños de letra (hoy 20) en el resto de la app (`typeset`).
  3. Objetivos táctiles de 44 px fuera de la ficha (`adapt`); los controles medidos van de 16 a 42 px.
  4. Panel resumen y Administración con el mismo lenguaje visual que el calendario y la ficha (hoy 8 tarjetas iguales llenas de ceros y tablas planas).
  5. Posible fallo de contraste de AA en los bordes de los campos (`--line-2` 1,48:1, criterio 1.4.11): comprobar si los campos tienen otra señal.
  6. Leyenda del mapa tapa la esquina inferior izquierda; dos `h1`; transición de ancho en 2 barras; calendario con scroll horizontal entre 900 y 1150 px.
  7. Sin probar: lectores de pantalla reales, modo oscuro del sistema real, móvil físico, «Archivar para todos» en el navegador; revisión de la ficha y del calendario por el titular con datos reales.
  8. Actualizar Impeccable a 4.6.0 (opcional, `npx impeccable update`; apaga la telemetría; solo con petición del titular).
- **Carga nacional de puntos** (decisión del titular, 19/10/2026: miles de puntos, lo más rápido posible): diseño en `docs/DISENO_CARGA_NACIONAL.md` (OpenStreetMap, revisión por excepciones, referencia + categoría piloto). Herramientas instaladas (`scripts/catalogue/`, fichero de Andalucía descargado). **N0 hecha**: 785 municipios andaluces con código INE cargados. **N1 hecha el 19/10/2026** (PR #133, `docs/CARGA_N1_ESTACIONES_ANDALUCIA.md`): cadena `extraer.py` → `validar.py` → `generar_lote.py` → `cargar.sh`; 246 estaciones de tren y autobús cargadas en producción (Almería 19, Cádiz 39, Córdoba 22, Huelva 29, Jaén 35, Málaga 48, Sevilla 54) y 216 calles completadas con Nominatim (vía más cercana, orientativa; el código postal no se pudo completar porque `guard_sensitive_updates` lo impide por SQL). **N1 cerrada**: los 8 puntos «por revisar» se resolvieron el 19/10/2026 (6 archivados: Almería «Autobuses Salidas», Cañete la Real «Bus», Villaviciosa de Córdoba «ARRIBAS SUR S.L.», Ibros «Parada de autobús», Baeza «111» y Huelva «Zafra»; 2 conservados y verificados con ubicación manual: Baeza y Huelva). Decisión del titular (criterio A): los 3 tranvías-tren de Cádiz (Venta de Vargas, Alameda Solano, Plaza de la Iglesia) quedan fuera, como el Metro de Granada; si algún día se quieren metro y tranvía, serían una categoría o subtipo propio. Revisión visual del titular: 3-4 puntos con diferencias de pocos metros, correctos. **N2 en curso**: añadir categorías una a una reutilizando la cadena (cada una con su definición en `scripts/catalogue/categorias/`, informe y aprobación). Hecha el 19/10/2026: **Correos** (400 oficinas de Andalucía, `docs/CARGA_N2_CORREOS_ANDALUCIA.md`; Granada solo con Orce y Puebla de Don Fadrique). **Grandes superficies preparadas** (258 puntos: Carrefour 187, Decathlon 20, El Corte Inglés 19, Leroy Merlin 16, MediaMarkt 11, IKEA 5; `docs/CARGA_N2_GRANDES_SUPERFICIES_ANDALUCIA.md`), probadas en local y **sin cargar: esperan la aprobación del titular**, con Carrefour completo por decisión del titular.
- **Ampliación del catálogo a toda España.** Hoy solo hay catálogo de Granada (791 puntos, aún por completar). La idea del titular es ir ampliándolo al resto de provincias. Antes de cargar otra provincia conviene tener resueltos H-20, H-21 y H-23, y cargar con el mismo procedimiento revisado que Granada (`supabase/seeds/`, `source_ref` único, sin inventar puntos ni coordenadas). Volumen previsto: más de 50.000 puntos (ver la prueba de volumen de la Fase D). La geocodificación masiva no puede hacerse con el servicio público de Nominatim que usa la app (su política de uso limita a una petición por segundo y no admite usos masivos): hará falta otra fuente de coordenadas o un procedimiento por lotes acordado, siempre fuera de la app.

## Dependencias del titular (resumen, 19/10/2026)

Hechas: coste de la rama aislada (se usaron proyectos aislados gratuitos, ya eliminados), cuentas sintéticas, plan de Supabase (seguir en gratuito, H-24), ajuste Data API > Max rows (1.000), verificación visual de colores, copia y restauración.

Pendientes y recurrentes:
1. **Copia mensual** con `scripts/backup-supabase.sh` (y antes de cada migración), guardada fuera de este ordenador, de GitHub y de Supabase.
2. **Limpieza local**: borrar las copias de prueba antiguas de `~/backups-mapas` cuando exista una válida guardada a salvo; dejar `.claude/settings.local.json` en `{"permissions":{"allow":[]}}`; borrar de Chrome las credenciales de prueba de 127.0.0.1 si las hubiera.
3. **Pruebas manuales no automatizables** (aplazadas, ver `docs/AUDITORIA_FASE_D_ACCESIBILIDAD_2026-10-18.md`): lectores de pantalla reales, zoom y objetivos táctiles.
4. **Decisiones de producto**: panel de administración, ampliación del catálogo a toda España y revisar H-25 al ampliar; revisar el plan de pago si crece el uso (H-24).
5. Repetir la consulta de índices sin uso con 8-12 semanas de estadísticas (H-36).
