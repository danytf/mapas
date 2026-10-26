# Mi jornada: la bandeja de trabajo

Estado a 26/10/2026 (rama `feat/mi-jornada`). Todo está en `index.html`: las reglas en el bloque «Reglas de expedientes» (`jornada`, `jornadaCumple`, `jornadaConteos`) y la pantalla en el bloque del Centro de permisos (`drawJornada`). Sin cambios de esquema, sin tablas nuevas y sin persistencia en el navegador.

## Qué es

La primera sección del Centro de permisos y la puerta de entrada tras iniciar sesión: una lista de actuaciones reales, de lo más a lo menos urgente, que se resuelven sin salir de ella.

- **Se abre sola al entrar** si hay al menos una actuación (una vez por sesión; la marca vive en memoria). Sin trabajo, o si la carga falló, no se abre.
- **El mapa sigue a un clic:** botón rojo «Ir al mapa» en la cabecera de la bandeja (y la × del diálogo o Escape).
- **Entradas:** menú → Informes → «Mi jornada (n)» (el número se calcula al abrir el menú) y la primera pestaña del Centro.

## Qué entra (solo datos y reglas que ya existían)

Es una vista derivada de los mismos expedientes (`expedientesDe`), seguimientos (`seguimientosDe`) e incidencias (`incidencias`) que usan el Panel, el Calendario y el Centro.

| Grado | Motivo | Banda | Regla |
|---|---|---|---|
| 1 | Seguimiento atrasado N días | Urgente | Fecha del seguimiento anterior a hoy |
| 2 | La concesión termina hoy | Urgente | Concesión vigente con fin = hoy |
| 3 | Dato bloqueante | Urgente | Incidencia «bloqueante» (fechas incoherentes, concesión sin fechas) |
| 4 | Seguimiento para hoy | Hoy | Fecha del seguimiento = hoy |
| 5 | El periodo solicitado empieza en N días (o ya empezó) y sigue sin respuesta | Atención | Solicitud pendiente con inicio en 7 días o menos (la misma regla que la antigua cola del Resumen y el aviso «el periodo ya empezó») |
| 6 | Solicitud sin respuesta desde hace N días | Atención | Pendiente con más de `UMBRAL_ESTANCADA` (15) días |
| 7 | La concesión termina en N días | Atención | Vigente con fin en 1 a 7 días |
| 8 | Solicitud pendiente sin seguimiento programado | Atención | Igual que «Pendientes sin seguimiento» del Panel |
| 9 | Aviso de datos | Atención | Incidencia «aviso» (sin ONG, sin captadores, caducada sin respuesta, duplicada, solapada); las «recomendaciones» se quedan en «Avisos de datos» |

- **Una fila por expediente.** Si un expediente cumple varios criterios, el de menor grado es el motivo principal y los demás aparecen en «También». Los seguimientos se asignan a su expediente exacto (solicitud, concesión o, si no cuelgan de ninguno, el punto).
- **Orden determinista y explicable:** grado del motivo principal → medida de su urgencia dentro del grado (más días de retraso o de espera primero; la concesión que antes termina primero) → antigüedad de la solicitud → nombre del punto. Se explica en la propia pantalla («Cómo se ordena y qué entra en Mi jornada»).
- **No cambia nada por el paso del tiempo:** una solicitud caducada se señala, pero sigue «caducada»; nunca se deniega ni se cancela sola.

## Cada fila

Punto y municipio (con la provincia), tipo de expediente y estado (con texto), ONG, periodo, captadores, gravedad (forma, color y texto: Urgente / Hoy / Atención), motivo principal, alertas adicionales, siguiente acción recomendada (la acción prevista del seguimiento si consta), fecha relevante y responsable del seguimiento.

Acciones (todas existentes, por `aplica()`): **Hecho** y **Cambiar fecha** cuando el seguimiento de la fila es de hoy o está atrasado, y **Abrir**, que enseña el detalle al lado sin perder la lista, con «Por qué está en Mi jornada», todas las acciones del expediente (conceder, denegar, retirar, editar, cancelar…), «Abrir en Solicitudes/Concesiones/Seguimientos» (lleva al expediente exacto, filtrado por su punto y con su detalle abierto) y «Abrir el punto en el mapa».

Los **lotes** de seguimientos del Centro (marcar como hechos, reprogramar, asignar responsable) funcionan también aquí, con el mismo resumen previo, guardado y verificación por registro y resultado individual. La selección solo puede contener seguimientos visibles.

## Filtros y recuentos

Provincia, ONG, responsable del seguimiento, tipo de actuación (el de su motivo principal), búsqueda y vistas rápidas «Urgentes», «Para hoy» (seguimientos de hoy y concesiones que terminan hoy), «Sin seguimiento» y «Todas». Se combinan con Y; cada número dice lo que saldría al elegir esa opción con todos los demás filtros aplicados (`jornadaConteos`). «Quitar filtros (n)» lo restablece todo (la provincia, solo si el usuario tiene más de una).

## Estados

Lista por bandas (Urgente, Seguimientos de hoy, Requieren atención) con «Mostrar más» de 100 en 100; «Todo al día»; «Ninguna actuación con estos filtros» con su botón; «Todavía no hay solicitudes ni concesiones»; y, si la lectura de Supabase falló, un aviso que dice expresamente que eso no significa que no haya trabajo (nunca una bandeja vacía). Avisa también si hay expedientes antiguos sin pasar a las tablas.

## Guardado y fallos

Sin cambios en la escritura: todo pasa por `aplica()` (control de versión, verificación por relectura, conflictos y guardados parciales explicados). Mientras se guarda, la bandeja sigue pintando las filas ya confirmadas (`jorSnap`), los botones y los filtros se bloquean, y nada aparece como resuelto hasta la confirmación. Tras una acción, el foco pasa a la fila que ocupa su sitio (la siguiente tarea) o al título si no queda ninguna.

## Coherencia con el resto de la aplicación

- La cola «Requieren atención ahora» del Resumen del Centro **es** Mi jornada (las mismas filas en el mismo orden): ya no hay una segunda regla.
- Atrasados, de hoy, estancadas, sin seguimiento y concesiones que terminan en 7 días coinciden con el Panel resumen; los seguimientos de hoy y las concesiones que terminan hoy, con el día de hoy del Calendario (`test-jornada` y E2E).
- Ámbito: la bandeja solo lee los puntos cargados para la sesión (provincias del usuario por RLS y por la consulta) y excluye los quitados o archivados. No tiene lecturas de red propias.

## Diseño

Lista compacta en tarjetas finas con un filo izquierdo de 4 px: rojo Wesser solo para lo urgente, ámbar para lo de hoy y neutro para el resto. Estados siempre con texto; gravedad con forma (rombo, punto, anillo). Tokens de color en claro y oscuro, foco visible, objetivos de 44 px en táctil, sin animaciones. En móvil las acciones bajan bajo el texto y los filtros van en dos columnas.

## Pruebas

`scripts/test-jornada.mjs` (reglas con reloj falso: clasificación, orden, determinismo con datos barajados, ayer/hoy/mañana y cambios de día y de hora en Madrid, una fila por expediente, 384 combinaciones de filtros, coherencia con Panel/Centro/Calendario/Resumen, actualización tras completar o reprogramar, ámbito por provincia, estados y rendimiento con 39.000 puntos) y la sección «3j» de `scripts/e2e-centro.mjs` (apertura automática, recuentos frente al Panel, filtros, navegación, «Hecho» con relectura de la base, caída del guardado, conflicto, lote parcial, teclado, contraste en oscuro, usuario de una provincia, estados vacío y de error, móvil de 390 px). Capturas: `node scripts/dev/capturas-jornada.mjs <carpeta>`.

## Pendiente o sin verificar

- Sin probar: sesión real en producción, dos usuarios reales de provincias distintas, móvil físico y lector de pantalla.
- El Calendario se abre desde el Centro, pero no hay un enlace por fila al día concreto (el Calendario no admite abrirse en un punto y fecha; no se ha añadido).
- La bandeja se recalcula al dibujar; si otra persona cambia un expediente, se ve al guardar (conflicto) o al volver a entrar, no en tiempo real.
- `relListas` representa un solo seguimiento por solicitud (limitación ya conocida): si un punto tiene varios seguimientos del punto abiertos, la bandeja muestra el más próximo y, al cerrarlo, pasa al siguiente.
