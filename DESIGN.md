---
name: Mapa del Responsable de Gestión de Recursos de Wesser
description: Sala de control de oficina para solicitar y seguir permisos de captación en toda Andalucía, sobre un mapa.
colors:
  wesser-red: "#c8102e"
  wesser-red-deep: "#9f0c24"
  wesser-red-tint: "#fdecef"
  ink: "#0f1722"
  ink-raised: "#1b2636"
  cool-paper: "#eef0f3"
  panel-white: "#ffffff"
  panel-quiet: "#f3f5f8"
  text: "#141b26"
  text-muted: "#5c6779"
  line: "#e2e6ec"
  line-strong: "#cfd5de"
  granted-deep: "#14532d"
  granted-tint: "#dcfce7"
  pending-deep: "#8a5a00"
  pending-tint: "#fff3d6"
  state-requested: "#fbbf24"
  state-granted: "#22c55e"
  state-denied: "#111827"
  state-expired: "#94a3b8"
  state-cancelled: "#dc2626"
typography:
  headline:
    fontFamily: "Figtree, Segoe UI Variable Text, Segoe UI, system-ui, sans-serif"
    fontSize: "17px"
    fontWeight: 650
    lineHeight: 1.15
    letterSpacing: "-0.015em"
  title:
    fontFamily: "Figtree, Segoe UI Variable Text, Segoe UI, system-ui, sans-serif"
    fontSize: "14px"
    fontWeight: 620
    lineHeight: 1.3
  body:
    fontFamily: "Figtree, Segoe UI Variable Text, Segoe UI, system-ui, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.45
  label:
    fontFamily: "Figtree, Segoe UI Variable Text, Segoe UI, system-ui, sans-serif"
    fontSize: "12px"
    fontWeight: 560
    lineHeight: 1.3
  numeral:
    fontFamily: "Figtree, Segoe UI Variable Text, Segoe UI, system-ui, sans-serif"
    fontSize: "28px"
    fontWeight: 680
    lineHeight: 1.05
    letterSpacing: "-0.02em"
    fontFeature: "tnum"
rounded:
  control: "8px"
  card: "12px"
  surface: "16px"
  pill: "999px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "22px"
components:
  button-default:
    backgroundColor: "{colors.panel-white}"
    textColor: "{colors.text}"
    rounded: "{rounded.control}"
    height: "36px"
    padding: "0 14px"
  button-primary:
    backgroundColor: "{colors.wesser-red}"
    textColor: "{colors.panel-white}"
    rounded: "{rounded.control}"
    height: "42px"
  input-field:
    backgroundColor: "{colors.panel-white}"
    textColor: "{colors.text}"
    rounded: "{rounded.control}"
    height: "38px"
    padding: "0 12px"
  header:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.panel-white}"
    height: "60px"
  kpi-card:
    backgroundColor: "{colors.panel-white}"
    rounded: "{rounded.card}"
    padding: "12px 14px"
  kpi-card-highlight:
    backgroundColor: "{colors.granted-tint}"
    textColor: "{colors.granted-deep}"
  kpi-card-alert:
    backgroundColor: "{colors.pending-tint}"
    textColor: "{colors.pending-deep}"
  dialog:
    backgroundColor: "{colors.panel-white}"
    rounded: "{rounded.surface}"
    padding: "22px"
  filter-chip:
    backgroundColor: "{colors.panel-white}"
    rounded: "{rounded.pill}"
    height: "32px"
---

# Design System: Mapa del Responsable de Gestión de Recursos de Wesser

## Overview

**Creative North Star: "La sala de control"**

La usa una persona de oficina que solicita permisos, los sigue y decide dónde enviar a los equipos. No es una app de calle ni de marketing: es su puesto de mando. Por eso el sistema prioriza que se vea mucho a la vez y que cada estado se lea de un golpe: un mapa que ocupa casi toda la pantalla, una lista a la izquierda, y paneles (resumen, calendario, administración) que se abren encima sin sacar a la persona de contexto.

El carácter es de tinta y papel frío con un único acento, el rojo Wesser. El rojo se reserva para lo que pide atención o acción (la línea bajo la cabecera, el botón principal, el foco, «hoy»); el resto del color pertenece a los datos: categorías en los pines, estados de permiso en los bordes y las tarjetas. El tono es cercano y motivador: la gamificación (nivel, XP, logros, retos) tiene presencia propia en la cabecera y en sus diálogos, pero nunca se mezcla con el flujo de permisos ni compite con él.

**Key Characteristics:**
- Fondo gris frío, paneles blancos con borde fino y sombra solo en lo que flota.
- Un solo acento (rojo Wesser); el color restante son datos, no decoración.
- Los estados de permiso se dicen siempre con texto además de con color.
- Densidad alta pero ordenada: números tabulares, etiquetas pequeñas, jerarquía por peso y tamaño.
- Modo claro y oscuro con los mismos roles.

## Colors

Paleta fría y neutra con una sola voz cálida: el rojo Wesser sobre tinta y papel.

### Primary
- **Rojo Wesser** (#c8102e): acción principal (Entrar, Guardar), línea de 3 px bajo la cabecera, borde de foco y marca de «hoy». Su rareza es el punto.
- **Rojo Wesser profundo** (#9f0c24): estado al pasar el ratón de la acción principal.
- **Tinte Wesser** (#fdecef): halo de foco de 3 px de los campos y fondo de elemento activo.

### Neutral
- **Tinta** (#0f1722): cabecera, toasts y elementos de marca; en oscuro baja aún más.
- **Tinta elevada** (#1b2636): segundo nivel sobre tinta (chips de la cabecera).
- **Papel frío** (#eef0f3): fondo de la aplicación y de los paneles que se abren encima.
- **Panel blanco** (#ffffff): superficie de lista, tarjetas, campos y diálogos.
- **Panel quieto** (#f3f5f8): relleno de zonas secundarias (chips, filas al pasar el ratón).
- **Texto** (#141b26) y **texto atenuado** (#5c6779): contraste verificado de 17,3:1 y 5,7:1 sobre blanco.
- **Línea** (#e2e6ec) y **línea firme** (#cfd5de): separadores y bordes de campos.

### Estados de permiso (datos, no decoración)
- **Concedido** (#22c55e), **Solicitado** (#fbbf24), **Denegado** (#111827), **Caducado** (#94a3b8), **Cancelado** (#dc2626); «sin solicitar» es blanco con borde gris. Cada uno lleva siempre su etiqueta de texto.
- **Concedido profundo** (#14532d) sobre **tinte verde** (#dcfce7) y **pendiente profundo** (#8a5a00) sobre **tinte ámbar** (#fff3d6) para indicadores destacados.

### Tokens de estado en paneles
La ficha, el calendario y sus chips usan `--st-concedido`, `--st-solicitado`, `--st-caducado`, `--st-denegado` y `--st-cancelado`, con variante en modo oscuro; todos cumplen 3:1 sobre el panel en claro y oscuro (comprobado en `test-a11y-fase-d`). Los anillos de los pines del mapa siguen siendo los de la tabla de arriba porque el mapa es siempre claro.

### Named Rules
**The One Voice Rule.** El rojo Wesser aparece en menos del 10 % de cualquier pantalla. Si todo es rojo, nada pide atención.
**The Data Color Rule.** Verde, ámbar, gris, negro y rojo de estado significan estado de permiso, y solo eso. No se usan para decorar.
**The Words Beside Color Rule.** Un estado nunca se comunica solo con color: va con su texto («Concedido», «Solicitado»…).

### Tokens de color añadidos (19/10/2026)

- **Categorías:** `--cat-hospital` … `--cat-eventos`, más `--cat-otra` (categoría desconocida) y `--cat-defecto`. La tabla `TIPOS` de `index.html` guarda el nombre del token (`var(--cat-…)`); el contraste del número de la lista se calcula resolviendo el token (`resolveColor`/`inkOn`). Los valores son los de siempre; ahora se pueden afinar en oscuro sin tocar el código.
- **Gamificación:** `--gam-gold`, `--gam-gold-soft`, `--gam-gold-ink`, `--gam-green`, `--gam-green-bright`, `--gam-amber`, `--gam-xp-a`, `--gam-xp-b`, `--gam-spark`. En oscuro, el dorado suave y su tinta usan `--warn-bg` y `--warn`.
- **Banda de la cabecera:** `--hd-line`, `--hd-line-2`, `--hd-line-3`, `--hd-fill`.
- **Estado del pin y de la leyenda:** `--pin-sin`, `--pin-sin-line`, `--pin-solicitado`, `--pin-concedido`, `--pin-denegado`, `--pin-caducado`, `--pin-cancelado`. En oscuro, `--pin-denegado` pasa a `#e2e8f0` para que se vea sobre el mapa oscuro. La tinta de la etiqueta de estado se calcula con `inkOn` a partir del color resuelto.
- **Confeti, niebla de conquista y cuadro de resultado de la ubicación:** `--confetti-1…6`, `--fog-0…3` y `--res-ok-*` / `--res-err-*`. El confeti (`canvas`) y la niebla (Leaflet) necesitan un color real, así que se resuelven con `resolveColor` al dibujar.
- Sin migrar a propósito: nada de lo que se dibuja con color fijo en la hoja de estilos de Leaflet.

## Typography

**Display y cuerpo:** Figtree (400 a 700) con pila de respaldo Segoe UI Variable / Segoe UI / system-ui. Una sola familia.

**Carácter:** neutro, geométrico y legible a tamaños pequeños. Con números tabulares activados, las cifras de captadores y fechas se alinean en columna.

### Hierarchy
- **Headline** (650, 17 px, 1,15): título de la aplicación y de cada diálogo (a 18 px en diálogos).
- **Title** (620, 14 px, 1,3): nombre del punto en la lista, cabeceras de filas.
- **Body** (400, 14 px, 1,45): texto corriente y campos.
- **Label** (560, 12 a 13 px): etiquetas de campo, chips, metadatos; es el tamaño más usado de la interfaz.
- **Numeral** (680, 28 px, 1,05, tabular): indicadores y números de día del calendario.

### Named Rules
**The Tabular Rule.** Toda cifra que se compara (captadores, fechas, recuentos) va en números tabulares.

## Layout

Rejilla de dos zonas: columna izquierda de 408 px (búsqueda, filtros y lista) y mapa a sangre en el resto, bajo una cabecera de 60 px. Los paneles (resumen, calendario, administración, progreso) son diálogos nativos que se abren sobre el mapa con anchos de 920 a 1380 px. La unidad de espaciado es de 4 px con pasos de 8, 12, 16 y 22. Puntos de corte observados: 1180, 900 y 760 px; por debajo de 900 los paneles pasan a una columna. Existe una regla para dispositivos sin cursor (`hover: none`).

## Elevation & Depth

Capas tonales con elevación solo para lo que flota. En reposo las superficies son planas: papel frío debajo, panel blanco encima, separados por un borde fino.

### Shadow Vocabulary
- **Flotante** (`0 1px 2px rgba(15,23,34,.06), 0 8px 24px rgba(15,23,34,.10)`): menú, controles del mapa, ventanas emergentes, leyenda y tarjetas al pasar el ratón.
- **Borde lateral de la columna** (`4px 0 24px rgba(15,23,34,.06)`): separa la lista del mapa.
- **Diálogo** (`0 24px 60px rgba(15,23,34,.35)`): solo en diálogos modales sobre un velo desenfocado.
- **Halo de foco** (`0 0 0 3px` del tinte Wesser): campos enfocados.

### Named Rules
**The Flat-By-Default Rule.** Una superficie es plana hasta que flota o responde. Nada lleva sombra solo por decorar.

## Shapes

Esquinas moderadas y consistentes por nivel: 8 px en controles, 12 px en tarjetas e indicadores, 14 a 16 px en diálogos y ventanas emergentes, píldora completa en chips. La hoja de estilos usa los tokens `--r-xs` (4 px), `--r-control` (8 px), `--r-card` (12 px), `--r-surface` (16 px) y `--r-pill`; quedan fuera de la escala solo los círculos (50 %), las marcas de 2 a 3 px, las barras con la parte superior redondeada y los controles de Leaflet. Los tamaños de letra son `--fs-label` (12 px), `--fs-label-lg` (13 px), `--fs-body` (14 px), `--fs-title` (17 px) y `--fs-display` (20 px); los numerales (22 a 44 px), las cifras de la cabecera y los glifos grandes se quedan con su tamaño propio. Los bordes son siempre de 1 px; la excepción deliberada es la línea de 3 px bajo la cabecera y el borde izquierdo de 5 px que codifica el estado en las tarjetas del calendario.

## Components

### Buttons
- **Shape:** esquinas de 8 px, altura de 36 px (42 px en el acceso).
- **Default:** fondo blanco, borde de línea firme, texto de peso 550; al pasar el ratón, relleno tonal y borde atenuado.
- **Primary:** relleno rojo Wesser con texto de acento; más oscuro al pasar el ratón.
- **Focus:** contorno visible de 2 px en rojo con desplazamiento de 2 px.

### Chips and filter chips
- **Style:** píldora con borde de línea firme; un punto de color indica el estado que filtran.
- **State:** `aria-pressed`; activo con borde de texto, inactivo con opacidad reducida y punto hueco.

### Cards / Containers
- **Corner Style:** 12 px en indicadores y tarjetas, 10 px en tarjetas de permiso del calendario.
- **Background:** blanco sobre papel frío; los indicadores destacados usan tinte verde o ámbar.
- **Border:** 1 px de línea; el estado de permiso se codifica con un borde izquierdo de 5 px y, si está pendiente, con trama rayada y borde discontinuo.

### Inputs / Fields
- **Style:** altura de 38 px, borde de línea firme, radio de 8 px; el buscador va sobre fondo de papel sin borde.
- **Focus:** borde rojo y halo de 3 px del tinte Wesser.

### Header
Tinta con línea inferior de 3 px en rojo Wesser; título a la izquierda y, a la derecha, indicadores (puntos, permisos vigentes, captadores hoy, seguimientos), nivel y logros, y el menú.

### Ficha del punto (componente de firma)
Panel lateral derecho de 440 px (hoja a pantalla completa en estrecho) con el mapa visible. Cabecera con categoría, nombre, dirección y «Cómo llegar»; tarjeta de estado con borde izquierdo de 5 px por estado y texto; próximo seguimiento destacado en ámbar cuando toca; valoración, contacto y notas siempre visibles; pestañas Solicitudes, Concesiones y Ubicación; pie fijo con el botón rojo Guardar y «Más acciones» para lo destructivo. Usa los tokens en claro y oscuro.

### Calendario semanal (componente de firma)
Siete columnas de lunes a domingo; sobre cada una, una silueta de barras (altura = captadores del día: verde los concedidos, trama ámbar los por aprobar), y debajo una tarjeta por permiso con estado en texto, punto, municipio, ONG con color propio y número de captadores.

## Do's and Don'ts

### Do:
- **Do** reservar el rojo Wesser (#c8102e) para acción, foco y «hoy».
- **Do** decir cada estado con texto además de color, y mantener contraste de al menos 4,5:1 en texto y 3:1 en bordes de controles.
- **Do** usar números tabulares para todo lo que se compara.
- **Do** dar a la gamificación presencia propia (cabecera, logros, retos) sin mezclarla con el flujo de permisos.
- **Do** mantener objetivos táctiles de 44 px en pantallas sin cursor.
- **Do** definir modo claro y oscuro con los mismos roles.

### Don't:
- **Don't** parecer una app de juego infantil: la herramienta sigue siendo seria y profesional.
- **Don't** convertirse en un panel corporativo genérico de tarjetas iguales llenas de ceros; el indicador importante debe pesar más que el resto.
- **Don't** parecer una plantilla de IA: sin degradados decorativos, brillos de color, bordes de acento por costumbre ni sombras anchas bajo un borde fino.
- **Don't** usar los colores de estado como decoración.
- **Don't** añadir tamaños de letra o radios fuera de la escala sin una razón de jerarquía.

## Rediseño premium (paso 1, octubre 2026)

- Paleta: carbón `#171b23` (cabecera), fondo `#f5f6f8`, texto secundario `#596478` (el `#64748b` propuesto da 4,45:1 sobre el fondo; este llega a 4,5:1 o más), rojo Wesser solo como acción y énfasis (filo de 2 px bajo la cabecera, botones primarios, «Limpiar»).
- Cabecera de 56 px con indicadores operativos sin relleno. La gamificación (Mi progreso, Logros, niveles, rachas e insignias) se conserva y usa los mismos radios, tamaños y tokens.
- Panel izquierdo: «Limpiar (n)» aparece solo con filtros activos y los restablece todos.
- Leyenda del mapa plegada por defecto para que el mapa sea el protagonista.
- Estados de la lista: cargando (esqueleto), error de carga (sin datos locales, con el motivo), ámbito vacío y sin coincidencias (con «Limpiar filtros» si hay filtros activos).
- Lista: el tipo del punto es texto, no etiqueta; las etiquetas con caja quedan para estado, seguimiento, vigencia y avisos. Buscador de 44 px.
- Mapa: el pin seleccionado crece un 30 % y lleva aro de acento; transición de 160–200 ms (`--t`), desactivada con `prefers-reduced-motion` (que también anula animaciones y desplazamiento suave).
- Ficha: el botón de guardar pasa a «Guardando…» mientras espera a Supabase.
- Móvil (hasta 760 px): mapa a pantalla completa, conmutador Mapa / Lista flotante (botones de 44 px) y filtros plegados tras un botón «Filtros (n)». La ficha sigue a pantalla completa.
- No validado: móvil físico, teclado virtual, lector de pantalla y sesión real de administrador.

## Wesser Spatial Canvas (mapa)

- Cartografía: mismo proveedor y atribución que antes (teselas de Esri; sin proveedores nuevos, claves ni cambios de CSP). Por defecto «Wesser claro» = Esri World Street Map con color atenuado por un filtro CSS en un panel propio (`wbase`): se leen carreteras, zonas urbanas, verdes, relieve y fronteras sin saturar. En oscuro, Esri Dark Gray con la referencia (rótulos) en un panel aparte. «Gris claro», «Gris oscuro», «Esri calles (color)» y OpenStreetMap siguen en el selector de capas.
- Marcador `.wm`: disco de 32 px con el color de la categoría y su glifo, anillo de estado de permiso (como antes) y un tallo con punto de anclaje en la coordenada exacta. Aviso «!» ámbar cuando la ubicación está por revisar (`isRev`, información ya existente).
- Seleccionado: halo de acento de 3 px más corona difusa, disco un 16 % mayor y tallo en acento; pulso único de 420 ms (sin él con `prefers-reduced-motion`).
- Agrupaciones: anillo con la mezcla de categorías y núcleo grafito con el recuento; tres tamaños (38, 46 y 56 px).
- Controles: zoom y capas como un mismo instrumento (40 px; 44 px en táctil), foco visible, atribución compacta (el texto completo se conserva).
- El mapa recalcula su tamaño con un `ResizeObserver` al abrir o cerrar paneles o cambiar de vista.
- Limitación: el color de zonas verdes y carreteras lo fija Esri; solo se atenúa, no se recolorea por capa. No hay capa de límites provinciales (no hay datos fiables en la aplicación y no se inventan).

## Jerarquía visual (crítica del 20/10/2026, PR de la rama feat/jerarquia-visual)

- Lista: el estado es un punto de color más texto y una sola línea de aviso en color de tinta; sin etiquetas con caja repetidas en cada fila (fila de ~214 a ~159 px con datos de prueba realistas). Los avisos de ubicación (aproximada, por confirmar, sin ubicar, duplicado, desactivado) son texto, no etiqueta.
- Agrupaciones del mapa neutras (grafito con recuento); el color de categoría solo vive en los marcadores individuales.
- Cabecera: «Seguimientos» pasa de relleno rojo sólido a contorno rojo (`--hd-hot`); el nivel de gamificación pierde el degradado dorado y queda como un indicador más, con barra de experiencia de 3 px.
- Pendiente de decisión del titular: estilo cartográfico propio (teselas vectoriales y fronteras provinciales).

## Filtros compactos (22/10/2026)

- «Por revisar» pasa a la misma fila que el estado y «Más filtros», y el panel reduce el relleno: una fila menos sin esconder provincia, municipio ni estado (decisión previa del titular: siempre a la vista).

## Provincia activa resaltada (22/10/2026)

- Al elegir una provincia en el selector, el mapa dibuja su contorno con un velo suave de acento (relleno 7 %, trazo 2 px al 55 %), que se atenúa con zoom 12 o más. Contornos: Natural Earth (dominio público, 1:10 m), redondeados a 3 decimales, de las 52 provincias (~78 KB en el propio `index.html`, `PROV_GEO`, con los nombres de la tabla `provinces`; simplificados a ~0,9 km). Una provincia cuyo nombre no coincida con ninguna clave de `PROV_GEO` no se resalta.
- Limitación: los contornos son generalizados y no coinciden al detalle con las fronteras del mapa base; por eso el resalte es un velo y no una máscara.
## Cartografía vectorial Wesser (22/10/2026)

- Capa por defecto «Wesser (vectorial, recomendado)»: teselas vectoriales de OpenFreeMap (datos de OpenStreetMap, sin clave) dibujadas con MapLibre GL a través de `@maplibre/maplibre-gl-leaflet`; la app sigue siendo Leaflet (marcadores, agrupaciones, ficha y eventos sin cambios).
- Estilo: el estilo «positron» de OpenFreeMap se descarga en tiempo de ejecución y se recolorea por identificador de capa con una paleta propia (claro y oscuro): agua azul grisácea, zonas verdes suaves, edificios neutros, carreteras blancas con borde fino y fronteras provinciales y de comunidad en discontinua (visibles desde el zoom 5).
- Fallback automático a Esri («Wesser claro (Esri)» o gris oscuro) si no hay WebGL, falla la descarga del estilo o no cargan las librerías; Esri y OpenStreetMap siguen en el selector de capas.
- Atribución visible: «OpenFreeMap © OpenMapTiles Data from OpenStreetMap» más los créditos de geocodificación.
- CSP: `tiles.openfreemap.org` en `connect-src` e `img-src` y `worker-src blob:`. Librerías con versión exacta e integridad SRI (maplibre-gl 4.7.1, maplibre-gl-leaflet 0.0.22).
- Limitaciones: el puente no hace zoom suave entre niveles enteros; las teselas solo traen líneas de frontera, así que resaltar la provincia activa requeriría un fichero de polígonos provinciales aparte; OpenFreeMap es un servicio sostenido con donaciones y sin SLA, y su uso comercial debe confirmarse con su mantenedor.

### Licencia de OpenFreeMap (22/10/2026)

Según el texto que aportó el titular (no verificado por mí contra su web): el software es MIT, el uso comercial está permitido, no hay registro, claves ni cobro por volumen, la atribución a OpenStreetMap (y a OpenFreeMap) es obligatoria (cumplida en el mapa) y se puede alojar en servidor propio. Sin SLA: servicio gratuito financiado con donaciones. Los datos del mapa siguen siendo de OpenStreetMap (ODbL). Riesgo vivo: si el servicio cae, la app cambia sola a Esri, cuya licencia comercial tampoco está confirmada.

## Revisión de oscuro y móvil con la capa vectorial (22/10/2026)

- Oscuro: la paleta recolorea ahora todas las capas de carretera, puente, túnel, camino, ferrocarril, pista y cauce (antes quedaban las vías secundarias en blanco brillante).
- Controles: la leyenda sube 26 px sobre la atribución y la atribución se limita al 72 % del ancho (78 % y 9 px en móvil) para que no se tapen en anchos pequeños; el conmutador Mapa/Lista no parte «Lista (n)» en dos líneas.

## Atajos de teclado (22/10/2026)

- `/` lleva el foco a la búsqueda (no actúa al escribir en un campo, con un diálogo abierto ni en la pantalla de acceso). Con el foco en la búsqueda, `↓` salta a la primera fila.
- En la lista: `↑` `↓` `Inicio` `Fin` recorren las filas; `↑` desde la primera vuelve a la búsqueda; `Intro` abre la ficha (como antes). La búsqueda declara `aria-keyshortcuts="/"` y tiene una pista en `title`.
- Acciones masivas: ver la sección siguiente.

## Acciones masivas de la lista (22/10/2026)

- Botón «Seleccionar» junto al estado: las filas muestran una casilla (el clic marca en lugar de abrir la ficha; Intro o Espacio también) y aparece una barra inferior con el recuento, «Todas las filas cargadas», «Ninguna» y tres acciones: **Reprogramar seguimiento** (con fecha), **Marcar seguimiento como hecho** y **Añadir a favoritos**. Escape sale del modo.
- Seguimiento: solo actúa sobre puntos con una solicitud pendiente con fecha de seguimiento (o el seguimiento antiguo); los demás se omiten y se cuentan. Pide confirmación con el número de puntos, guarda punto a punto con `savePermits` (mismo control de versión que la ficha), recarga el punto si otra persona lo cambió y restaura el estado anterior si hay un error. Una vez terminado se ofrece «Deshacer» (una vez).
- Favoritos: un solo guardado de la lista personal; si falla, no se añade ninguno.
- La selección se poda a las filas visibles al filtrar. Prueba estática: `scripts/test-acciones-masivas.mjs`.

## Ficha flotante, densidad y ayuda (22/10/2026)

- Ficha: sigue siendo la tercera columna (decisión previa: no tapa el mapa) pero como tarjeta flotante: margen de 12 px, borde, radio de superficie y elevación propios. En móvil y hasta 900 px sigue a pantalla completa.
- Densidad: capa opcional «Densidad de puntos» en el selector de capas (arriba a la derecha). Mapa de calor dibujado en un lienzo por tesela, sin librerías, con los puntos visibles según la lista y los filtros (los desactivados no cuentan); radio según el zoom y rampa del gris azulado al rojo de acento; se atenúa a zoom 12 o más. Con cientos de miles de puntos habrá que añadir un índice espacial (hoy se recorren todos los puntos por tesela).
- Ayuda: diálogo «Ayuda y atajos» (menú y tecla `?`) con búsqueda, teclado, acciones masivas, lectura del mapa y seguimientos. Es solo informativo.

## Menú desplegable reordenado (22/10/2026)

- Orden por tarea: cabecera con la cuenta y su rol (para saber con qué usuario se está) → **Informes** (Panel resumen, Calendario semanal) → **Progreso** (Mi progreso, Logros) → **Puntos** (Añadir punto, Restaurar puntos quitados) → **Datos** (Exportar CSV, Exportar estado operativo (JSON), Copiar coordenadas (JSON)) → **Administración** (solo administradores: Usuarios y provincias) → **Ayuda** (Ayuda y atajos, con la tecla `?` indicada) → **Cerrar sesión**, separado y en color de error, siempre el último.
- Cambios de nombre: «Agregar punto» pasa a «Añadir punto» (también el título del diálogo); «Exportar estado (JSON)» a «Exportar estado operativo (JSON)»; «Copiar JSON con coordenadas» a «Copiar coordenadas (JSON)». El grupo «Avanzado» desaparece: su única opción es un dato más. «Mi progreso» y «Logros» salen de Informes.
- Separadores entre grupos, y el menú se desplaza por dentro (altura máxima del visor menos 84 px) para que «Cerrar sesión» sea siempre alcanzable en ventanas bajas.

