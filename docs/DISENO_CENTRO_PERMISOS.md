# Centro de permisos: centro de mando y espacio de trabajo

Estado a 25/10/2026. Sustituye a las bandejas de la primera versión (#198 a #205). Todo está en `index.html` (bloque «Centro de permisos») y en las reglas compartidas de expedientes; no hay cambios de esquema ni persistencia nueva en el navegador.

## Qué es

Una sola ventana con dos espacios que comparten datos, reglas y escritura:

1. **Resumen (centro de mando).** Qué pasa, qué requiere atención y dónde actuar.
2. **Espacio de trabajo.** Solicitudes, concesiones, seguimientos y avisos de datos, con filtros, orden, detalle lateral y acciones.

Desde el Centro se abre el Calendario (semana, día por ONG y mes). El Panel resumen y el Calendario abren el Centro con los filtros de cada cifra. La ficha del punto solo da información básica y un botón al Centro.

## Reglas de negocio (una sola fuente)

| Función | Para qué |
|---|---|
| `expedientesDe`, `seguimientosDe` | Solicitudes, concesiones y seguimientos (incluidos los vinculados a una concesión) |
| `indicadores` | Cifras del Panel y del Resumen |
| `incidencias` | Avisos con gravedad (bloqueante, aviso, recomendación) |
| `calendarioSemana` | Capacidad y demanda por día (Calendario y gráfico de 14 días) |
| `resumenDatos` | Cola de trabajo, antigüedad, capacidad 14 días, vencimientos, carga, responsables, calidad, resolución y actividad |
| `savePermits`, `ejecutaOpsRel`, `verificaOps` | Escritura, recuento de operaciones y verificación por relectura |

## Definiciones de los indicadores

- **Solicitudes pendientes:** sin decisión y con la fecha de fin aún vigente. **Estancadas:** pendientes con más de 15 días desde la fecha de solicitud (no cambia su estado).
- **Concesiones vigentes:** no canceladas y con el periodo incluyendo hoy.
- **Captadores autorizados** (capacidad): el mayor número por punto y ONG entre concesiones vigentes ese día, sumando entre ONG distintas. **Por aprobar** (demanda): lo mismo con solicitudes pendientes. **Nunca se suman.**
- **Seguimientos:** tareas con fecha de una solicitud pendiente, de una concesión o del punto. Atrasado = fecha pasada. No se confunden con las solicitudes pendientes de decisión.
- **Antigüedad:** días desde la fecha de solicitud de las pendientes (0–7, 8–15, 16–30, más de 30).
- **Tiempo de resolución:** días entre solicitud y decisión, solo si ambas fechas constan y son coherentes. Se da la **mediana** (la media se distorsiona con extremos) y cuántas resueltas no cuentan por no tener fecha de decisión (las anteriores al 23/10/2026 no la guardaban).
- **Actividad de 8 semanas:** solicitudes por su fecha de solicitud y de decisión. No hay histórico de estados anteriores: no se inventa.
- **Avisos de datos:** *bloqueante* (impide leer o planificar: fechas incoherentes, concesión sin fechas), *aviso* (sin ONG, sin captadores, estancada, periodo ya empezado sin respuesta, caducada, posible duplicada, concesiones solapadas) y *recomendación* (aprobada sin concesión enlazada, concesión sin fecha de fin). No se corrigen solos.

## Diseño

- Navegación con contador de lo que pide atención (el rojo solo para seguimientos atrasados y avisos bloqueantes).
- Tarjetas con borde fino, sin sombras ni degradados. Gráficos en SVG y HTML sin dependencias: barras de hasta 14 px con extremo de 4 px, líneas guía de 1 px, valor en la barra más alta y en la actual, descripción accesible y **vista como tabla** en cada gráfico.
- Colores validados con la guía de visualización (`validate_palette`, claro y oscuro): capacidad `#16a34a` y demanda `#d97706` (la demanda lleva además textura rayada), serie única `#3b6fb6` y rampa ordinal gris-azulada para la antigüedad con el rojo Wesser solo en el tramo de más de 30 días. La gravedad usa color y forma (rombo, punto, anillo) además de texto.
- Detalle lateral que no recarga la lista ni pierde filtros, selección ni posición; en móvil ocupa la pantalla. Explica por qué una acción no está disponible.
- Móvil: la navegación se desplaza por dentro y las tablas pasan a tarjetas; objetivos táctiles de 44 px.

## Seguridad

Sin cambios. Las funciones (`approve_permit_application`, `resolve_permit_application`, `cancel_permit_grant`) son `SECURITY INVOKER` y mandan las políticas RLS por provincia (matriz de 973 celdas). Ocultar botones es solo ayuda de interfaz. El historial de cambios sale de `audit_log`, que solo lee un administrador (política `audit_log_admin_read`); a un usuario provincial no se le pide ni se le muestra.

## Escritura y fallos

Toda escritura pasa por `aplica()`: copia el estado del punto, aplica el cambio, guarda con `savePermits`, relee y **verifica** que lo guardado es lo esperado. Un conflicto recarga sin pisar lo de otra persona; un fallo parcial dice cuántos pasos se aplicaron; el estado de guardado se libera siempre; los reintentos de un alta usan el mismo identificador (no duplican). Los lotes de seguimientos (cerrar o reprogramar) piden selección explícita, enseñan un resumen previo, guardan y verifican cada registro por separado, dan el resultado de cada uno y dejan seleccionados los que fallaron.

## Pruebas

`test-centro` (150 comprobaciones), `test-expedientes` (187, con reglas, incidencias y resumen), `test-persistencia-expedientes` (14, ejecuta `ejecutaOpsRel` con un cliente simulado), `test-calendario`, `test-ficha`, `audit-persistence` y el resto de CLAUDE.md; SQL local (`permit_workflow` 42, `permit_backfill` 23, matriz RLS 973/0). En navegador con el Supabase simulado (que ahora también simula `audit_log`): administrador, usuario provincial, usuario sin puntos, móvil de 390 px, lotes con fallo individual, errores de guardado, teclado y nombres accesibles.

## Pendiente o sin verificar

- Sin probar: sesión real en producción, móvil físico, lector de pantalla, modo oscuro del sistema (el contraste se prueba por tokens y el color de los gráficos con el validador).
- Asignar responsable en lote: no se hace porque los responsables dependen de la provincia de cada punto y mezclarlas necesita una operación atómica en la base de datos.
- Previsiones y tendencias de estados: no hay histórico de estados, solo fechas de solicitud y decisión.
- `incidencias` agrupa por punto y ONG, pero con decenas de miles de concesiones activas simultáneas convendría medirla.
