# Ficha del punto (panel lateral)

Estado: **implementada en la rama `feat/ficha-panel-lateral`; pendiente de PR, checks y verificación en producción** (19/10/2026). Decisión del titular (19/10/2026): rediseñar la ficha para registrar y seguir permisos, como panel lateral derecho, con siempre visibles el estado y la vigencia, la dirección y «Cómo llegar», el contacto y las notas y el próximo seguimiento.

## Qué cambia

- **Contenedor.** La burbuja del mapa pasa a ser una etiqueta mínima (nombre y municipio) y la ficha completa se abre en un panel de 440 px a la derecha (tercera columna: el mapa se reduce, no queda tapado y el pin se mantiene a la vista). En pantallas estrechas es una hoja a pantalla completa bajo la cabecera. La ficha sigue el ciclo de vida del popup de Leaflet, así que todos los caminos que ya la abrían (lista, calendario, panel resumen, teclado) o cerraban (`map.closePopup()`) funcionan igual. Pulsar el mapa **ya no la cierra**, para no perder ediciones.
- **Orden.** Cabecera (categoría, nombre, dirección con «Cómo llegar», aviso de «ubicación por revisar» con su acción) → tarjeta de estado (borde y texto por estado, vigencia, ONG, captadores) y datos secundarios (próximo seguimiento destacado, solicitado el, pendientes, concesiones) → valoración → contacto y notas → pestañas **Solicitudes / Concesiones / Ubicación** → pie fijo con **Guardar cambios**, «Cambios sin guardar» y **Más acciones** (Desactivar, Archivar para todos si eres administrador, Quitar).
- **Estilo.** Tokens de la app en claro y oscuro (antes la ficha era siempre blanca); los colores de error y de estrellas pasan a tokens con variante oscura (`--err`, `--star-on`, `--star-off`); textos de 12, 14 y 17 px y radios de 8, 12 y 16 px de `DESIGN.md`; objetivos de 44 px en pantallas estrechas o táctiles.
- **Accesibilidad.** Región con nombre, foco al título al abrir con teclado y retorno a la lista al cerrar, Escape cierra (y primero el menú «Más acciones»), pestañas con flechas, Inicio y Fin y tabindex itinerante, avisos en regiones `aria-live`.

## Cambiar municipio (solo administradores)

En la pestaña **Ubicación**, los administradores ven un bloque «Municipio» con un desplegable de los municipios **de la misma provincia** del punto (se cargan al abrir la pestaña) y el botón «Cambiar municipio», que pide confirmación («El cambio afecta a todos los usuarios») y escribe solo `municipality_id`. Existe porque `guard_sensitive_updates` solo deja cambiar el municipio a un administrador identificado desde la aplicación; por SQL de servicio no es válido y no se elude (se comprobó el 19/10/2026 con el «Lidl – Ctra. Gabia, 9», que la base asigna a Churriana de la Vega y está en Las Gabias). Un rechazo de la base se explica y no cambia nada; los usuarios normales no ven el bloque. La base no comprueba que el municipio pertenezca a la provincia del punto: lo garantiza la interfaz al ofrecer solo los de su provincia.

## Qué no cambia

Ninguna función ni regla de guardado: valoración, contacto, notas, solicitudes, concesiones y seguimientos, corrección de ubicación, revisión visual, desactivar, quitar y archivar; XP y logros; control de conflicto de versión; avisos de error. Los manejadores se reutilizan tal cual y localizan los controles por clase.

## Pruebas

- `scripts/test-ficha.mjs` (nuevo, en CI) y `scripts/test-a11y-fase-d.mjs` ampliado (97 pares de contraste, ya con estrellas y errores en claro y oscuro).
- Navegador con el Supabase simulado, que ahora **admite escribir el estado compartido** con el protocolo de la app (insertar si no hay fila, actualizar solo con la versión leída): alta de solicitud, alta de concesión, estrellas, contacto y notas dan «Guardado en Supabase», se limpia «Cambios sin guardar» y suben nivel y XP; desactivar cierra la ficha; apertura por teclado lleva el foco al título; Escape cierra el menú y luego la ficha; pestañas con flechas; sin errores de JavaScript ni datos en `localStorage` / `sessionStorage`.
- Móvil (iframe de 400 px): hoja a pantalla completa sin desbordamiento horizontal.
- En un portátil de 695 px de alto caben a la vista las cuatro prioridades; las pestañas quedan debajo, con desplazamiento dentro del panel.

## Límites

No probado: lectores de pantalla reales, modo oscuro del sistema real, móvil físico ni las acciones de administrador (archivar) en el navegador. Cambiar de punto con ediciones sin guardar las descarta (igual que antes); el aviso «Cambios sin guardar» lo hace visible.

## Código postal (solo administradores)

En la pestaña Ubicación, debajo del municipio, un administrador ve «Código postal»: el valor se lee solo al abrir la pestaña (una consulta por punto, sin ampliar la carga del catálogo), admite 5 cifras y solo escribe `postal_code`. El disparador `guard_sensitive_updates` ya exige administrador para ese campo, de modo que un no administrador no ve el bloque y, aunque lo forzara, la base lo rechazaría. Motivo: los puntos de la carga nacional (OpenStreetMap) llegan sin código postal y por SQL no se pueden completar. Pruebas: comprobaciones estáticas en `scripts/test-ficha.mjs`; sin probar en navegador ni con un administrador real.

## Panel resumen y Administración con el mismo lenguaje

Solo CSS (sin cambiar marcado ni lógica): cabecera fija con filete y título de 17 px, secciones con etiqueta de 12 px, tarjetas del resumen con borde izquierdo de estado (`--st-*`), tabla sin segunda barra de desplazamiento y casillas de verificación a 18 px (antes heredaban el alto de 38 px de los campos de texto y se veían como cuadros enormes en Administración). Prueba: `scripts/test-paneles.mjs`. Comprobado a ojo en navegador, en claro, sobre la web con la hoja inyectada; sin probar en oscuro ni en móvil.
