# Hoja de ruta (desde el 18/10/2026)

Reglas de ejecución: ver `CLAUDE.md`. Cada fase termina con criterios de cierre explícitos y evidencia reproducible. Todo lo que escriba datos se prueba en un entorno aislado, nunca en producción.

## Fase C. Pruebas E2E en navegador (SIGUIENTE)

**Antes de empezar (depende del titular):** decidir el entorno de pruebas.
- Opción recomendada: rama aislada de Supabase (`create_branch`). Antes, consultar `get_cost` y `confirm_cost` y pedir aprobación del coste al titular. Crear cuentas sintéticas (administrador, usuario de la provincia con equipo, usuario de otra provincia, usuario activo sin provincia, usuario desactivado) y datos sintéticos. Las claves de la rama no se escriben en ningún fichero del repositorio ni en informes.
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

## Fase D. Integridad, dependencias, accesibilidad, rendimiento

Hecho: integridad del catálogo y del historial; dependencias fijadas con SRI; teclado del panel (H-05); auditoría XSS y de persistencia en CI.
Pendiente:
- Peso real de la carga inicial: bytes transferidos de `index.html`, recursos externos y consulta del catálogo (solo se sabe que las 791 filas ocupan unos 284 KB en base de datos; no es el tamaño de transferencia). Medir en el navegador (red) y registrar tiempos de primera pintura y de catálogo visible.
- Accesibilidad más allá del teclado: contraste, etiquetas de formularios, foco dentro de los diálogos, lector de pantalla en los flujos principales.
- Los 23 índices sin uso: no eliminar; si se revisan, solo informe con datos de uso reales.
- H-03 (`search_path` de `set_updated_at`): decidir si se corrige; cambio de bajo riesgo con migración y huellas.
- Registrar el rol de base de datos en `audit_log` cuando no hay JWT (mejora de trazabilidad).

## Fase E. Backup, restauración y despliegue

- Averiguar qué cobertura de copia tiene el plan de Supabase (copias diarias, PITR, retención) con `get_project` y la documentación; registrar lo que se pueda demostrar y marcar lo que no.
- Prueba de restauración en un proyecto o rama aislados (coste: pedir aprobación antes). Registrar tiempos y qué se pierde.
- Las exportaciones JSON/CSV de la app no son un backup completo.
- Despliegue: documentar cómo revertir una publicación (revertir el commit en `main` y esperar al workflow de Pages) y comprobarlo en seco; confirmar que Pages despliega solo `index.html`.
- `docs/import-export-backups.md` es el punto de partida.

## Fase F. Cierre

Informe final con: resumen ejecutivo; matriz de 10 capas (el listado literal de capas del primer encargo no se conservó: construirla agrupando las evidencias por área: estado y reproducibilidad, base de datos y migraciones, autorización RLS, persistencia, concurrencia e integridad, aplicación y E2E, dependencias, accesibilidad, rendimiento, backup y despliegue; confirmar con el titular); defectos confirmados y correcciones; recomendaciones por prioridad; resultados de pruebas reproducibles; estado de RLS, permisos, funciones y triggers; persistencia; backups y restauración; commits, PR y checks; riesgos residuales y tareas que dependen del titular; criterios de cierre por fase. Formato por hallazgo: ID, capa, severidad, estado, evidencia, impacto, acción, prueba de regresión, riesgo residual, dependencia del titular.

## Dependencias del titular (resumen)

1. Aprobar el coste de la rama aislada o elegir la alternativa con red simulada.
2. Proporcionar o autorizar la creación de cuentas sintéticas en la rama aislada (nunca las reales).
3. Verificación visual final de lo que no se pueda automatizar.
4. Decisiones de diseño que surjan (por ejemplo, migrar permisos a tablas normalizadas).
