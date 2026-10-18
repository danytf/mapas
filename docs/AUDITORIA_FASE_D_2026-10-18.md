# Auditoría Fase D: preparación para varias provincias y volumen (18/10/2026)

Estado: **en curso**. Recoge los hallazgos de la Fase D relacionados con el uso en varias provincias y con el volumen del catálogo (H-20 a H-23) y los arreglos de interfaz H-15 a H-19. El resto de la fase (rendimiento medido, accesibilidad más allá del teclado, H-03 y registrar el rol de base de datos en la auditoría sin sesión) sigue pendiente, además de la prueba de volumen con 50.000 puntos.

## H-22: provincia desactivada (cerrado, PR #94)

- Migración `20261018172704_province_active_in_authorization` aplicada en producción con aprobación del titular. `private.has_province_access` exige provincia activa para los no administradores y las tres políticas de `establishment_app_state` pasan a usar `public.has_province_access`. Se aplicó con `ALTER POLICY`: la primera versión, con `DROP POLICY`, fue rechazada por la herramienta de Supabase, que manda las sentencias `DROP` a una confirmación que no se puede aceptar en una sesión no interactiva; el estado final es idéntico (misma huella de políticas).
- Prueba nueva `supabase/tests/province_active.sql` (23 comprobaciones): usuario con dos provincias, una desactivada y reactivada; lectura, modificación y creación sobre establecimientos, solicitudes y estado compartido; el administrador conserva el acceso. Sin la migración fallan 8 comprobaciones. Matriz RLS sin cambios (973 celdas, 0 discrepancias).
- Producción tras aplicarla: 27 migraciones; solo cambia la huella de políticas (51, `9af6855f48a8678d36c8d375ad1a2d31`, igual que la reconstrucción local); 791 puntos y 2 estados sin cambios; asesor de seguridad solo con el aviso aceptado.

## H-23: límite de filas de la API (cerrado, PR #95)

- El titular confirma que *Data API > Max rows* es 1.000. La app pedía `.limit(5000)` sin paginar: con más de 1.000 puntos visibles el mapa saldría incompleto sin aviso.
- `fetchAllRows` pagina por clave y no devuelve nunca una lista incompleta. `scripts/test-paged-fetch.mjs`: 13 casos con un cliente simulado que recorta a 1.000 (incluidos 50.000 filas en 50 peticiones, tope por debajo del tamaño de página, error intermedio, filas borradas o añadidas durante la carga, servidor que no avanza) y un control que reproduce el fallo anterior.
- Contra producción, solo lectura, con la sesión del titular (administrador): páginas de 1.000, 300, 100 y 50 devuelven siempre las 791 filas, sin repetidos y con el mismo conjunto y orden que la lectura actual (1, 3, 8 y 16 peticiones); estado compartido (2 filas) con páginas de 1.
- Tras el despliegue (`main` `8dcbf29`, mismo SHA-256 que la URL pública): 791 puntos, una petición ordenada por clave para el catálogo y otra para el estado, sin `limit=5000`, 0 violaciones de la CSP, sin errores en consola y base de datos sin cambios.
- Pendiente: la prueba de volumen con unos 50.000 puntos en un entorno aislado (ROADMAP).

## H-20 y H-21: la app no depende de Granada (cerrados, PR #96)

Entorno: copia de `index.html` conectada a un Supabase simulado local (`scripts/dev/mock-supabase.mjs` y `scripts/dev/build-mock-site.mjs`), con usuarios `multi` (Granada y Almería), `alm` (Almería), `vacio` (Jaén, sin puntos) y `admin`. Es una prueba del cliente: no cubre RLS ni la API real, que ya están cubiertas por las pruebas SQL y las verificaciones de producción en solo lectura.

| Prueba | Resultado |
|---|---|
| Usuario de dos provincias: carga y filtro | 7 puntos (Almería 4, Granada 3); el filtro de provincia lista las dos; el mapa encuadra ambas |
| Municipio por defecto del alta | Dos provincias: vacío, y sin municipio avisa «Indica el municipio.». Una provincia (Almería): «Almería». Sin puntos: vacío |
| «Ubicar por dirección» | Con puntos: viewbox del rectángulo de los puntos del usuario más 0,15° (`-3.77,37.4,-1.71,36.594`) con `bounded=1`. Sin puntos: sin viewbox y sin `bounded`, en toda España |
| Corrección de ubicación (antes rechazada fuera del recuadro de Granada) | Este de Almería (37,24, -1,83): guardada con precisión `verified`. Madrid: aceptada. París: rechazada con el mensaje de coordenadas no reconocidas y sin cambios en la base |
| Descarga real del CSV | `permisos-captacion-almeria-granada.csv`, con los municipios reales de los puntos y el del punto personal. Una provincia: `almeria`; sin puntos: `mapa` |
| Vista inicial | Sin puntos: centro de España, zoom 6 |
| H-20: punto personal fuera del antiguo recuadro | Con el código nuevo, un punto personal en Madrid se guarda y sigue ahí tras recargar. Con el código anterior (el de `main`): se guardaba en la base pero desaparecía de la app tras recargar (0 puntos personales), y el municipio por defecto era «Granada» para cualquier usuario |
| CSP | 0 violaciones en todos los recorridos |

Regresión: `scripts/test-multiprovince.mjs` (en CI) ejecuta `inSpain`, `parseCoords`, `townOf`, `defaultTown`, el nombre del CSV y el área de búsqueda con puntos de varias provincias (Canarias, Baleares, Ceuta y Melilla incluidas; París, Rabat, el Atlántico y coordenadas cambiadas fuera) y prohíbe que vuelvan los valores fijos de Granada; `scripts/audit-persistence.mjs` exige `inSpain` en la carga de puntos personales. Se retira `locateAll`, geocodificación masiva heredada que ya no se llamaba desde ningún sitio.

Tras el despliegue (`main` `aac12ea`, mismo SHA-256 que la URL pública, sin `VIEWBOX` ni `locateAll`): sin sesión, vista inicial en el centro de España (zoom 6), formulario sin municipio por defecto, sin errores ni violaciones de CSP. Con la sesión del titular (administrador, solo lectura): 791 puntos en una petición, encuadre en Granada, municipio por defecto «Granada» (una sola provincia), CSV `permisos-captacion-granada.csv`, área de búsqueda `-4.37909,38.10923,-2.28279,36.55051`, 0 puntos personales, 0 violaciones de CSP y sin errores en consola; la base no cambia (791 puntos, 2 estados en versión 1, 43 filas de historial de ubicación, última auditoría del 17/10).

Observación nueva: H-25 (P3), aceptado por ahora por el titular el 18/10/2026 (revisar al ampliar el catálogo; si se reabre, mejor un aviso con confirmación que un rechazo). La corrección de ubicación acepta cualquier punto de España; un error de pegado a otra provincia se guarda en el catálogo maestro (queda en el historial de ubicación). Un umbral de distancia respecto a la ubicación anterior necesitaría que el titular fije el valor.

## H-15 a H-19: arreglos de interfaz (PR #98)

Entorno: copia de `index.html` contra el Supabase simulado (`scripts/dev/mock-supabase.mjs`, `scripts/dev/build-mock-site.mjs`), primero con el código de `main` y después con el nuevo.

| Hallazgo | Código anterior | Código nuevo |
|---|---|---|
| H-19: escrituras de `user_app_state` al entrar | 2 | 1 |
| H-15: triple clic en «Guardar dirección y ubicación» | 3 escrituras | 1 escritura; el botón se deshabilita mientras guarda y se libera después; un segundo guardado posterior funciona |
| H-17: búsqueda sin resultados | lista vacía sin mensaje | «Ningún punto coincide con la búsqueda y los filtros.»; la lista vuelve a mostrar los 7 puntos al borrar la búsqueda |
| H-17: etiquetas de valoración | «★★★★★ (5)», «★★★★☆ o más»… | «★★★★★ · 5 estrellas», «★★★★☆ · 4 estrellas o más», «★★★☆☆ · 3 estrellas o más» |
| H-16: guardado de ubicación sin red | «Failed to fetch» (repetido) | «No hay conexión. Revisa tu conexión a internet.» (una vez) |
| H-16: sin respuesta del servidor (corta a los 15,1 s) | «AbortError: The operation was aborted.» | «La operación no respondió a tiempo.» |
| H-16: error 500 con código técnico | texto del servidor | «El servidor devolvió un error. Inténtalo de nuevo; si se repite, avisa al administrador.» |
| H-16: sesión caducada (401, JWT expired) | «JWT expired» | «La sesión ha caducado. Vuelve a iniciar sesión.» |
| H-16: acceso sin conexión / contraseña incorrecta / error al leer el catálogo | «Failed to fetch» / correcto / texto del servidor | «No hay conexión. Revisa tu conexión a internet.» / «Correo o contraseña incorrectos.» / «Error de lectura del catálogo.» |
| H-18: menú con teclado real | las flechas no hacían nada y Intro no movía el foco | Intro abre y lleva el foco al primer elemento; Abajo, Arriba, Inicio y Fin se mueven con vuelta al principio y al final; Escape cierra y devuelve el foco al botón del menú |
| H-18: foco al cerrar «Panel resumen» y «Logros» con Escape | el foco se perdía | vuelve al botón del menú |

Durante la prueba el foco se quedaba en el botón «Cerrar» del diálogo ya cerrado: se corrigió para que vuelva siempre al botón del menú. Después se comprobó también «Agregar punto» con teclado real: Intro sobre la opción lo abre con el foco en el campo de nombre y Escape lo cierra devolviendo el foco al botón del menú. (La pestaña de pruebas se bloqueó un rato durante la prueba, sin ningún diálogo abierto: fue un bloqueo pasajero del navegador, y tras recuperarse la comprobación se repitió con éxito.)

Regresión: `scripts/test-ui-fixes.mjs` (en CI) ejecuta `friendlyError` con 22 casos (tiempo agotado, sin conexión, sesión caducada, sin permiso, error del servidor, errores propios en español que pasan tal cual, sin texto técnico) y comprueba que no vuelven los mensajes técnicos, el texto de 17 segundos ni la etiqueta «(5)», y que siguen presentes el bloqueo del botón, el mensaje de lista vacía, el teclado del menú, el foco al cerrar diálogos y la escritura única del estado personal.

## H-26 y prueba de volumen en la base de datos (PR #99)

Se hizo **sin crear ningún proyecto de Supabase**: una base PostgreSQL 17 local reconstruida desde las migraciones, con 50.000 puntos sintéticos en las 52 provincias (`supabase/tools/volume/load_synthetic_volume.sql`: 40 municipios por provincia, 3.000 estados compartidos, un administrador, un usuario de dos provincias y uno de una) y las consultas de la app ejecutadas con el rol `authenticated` y las políticas RLS reales (`supabase/tools/volume/measure_catalogue_load.sql`: recuento exacto y páginas de 1.000 por clave, con el filtro de provincia como `IN` directo, como lo genera la app). La base ocupa 59 MB (26 MB la tabla de puntos con sus índices, 22 MB la auditoría de la carga): unos 520 bytes por punto, por debajo de los 960 medidos en producción.

Primera medición, con las políticas anteriores:

| Carga | Recuento exacto | Total |
|---|---|---|
| Administrador, 50.000 puntos (50 páginas, la más lenta 1,6 s) | 9,1 s | **25,1 s** |
| Usuario con dos provincias (1.924 puntos) | 0,5 s | 1,1 s |
| Usuario con una provincia (962 puntos) | 0,26 s | 0,46 s |
| Estado compartido (3.000 filas), administrador | | 0,6 s |

Causa: las políticas de lectura llamaban a `public.has_province_access` (que llama a `private.has_province_access`, `SECURITY DEFINER`) una vez por fila, unos 0,2 ms por fila, y el planificador no puede evitarlo. Para el administrador, que no filtra por provincia, eran 50.000 llamadas. Con los 791 puntos actuales no se nota (unos 0,15 s). Un primer intento de medir los usuarios con una consulta con `OR` sobre un parámetro dio 11 s por usuario: era un artefacto de la consulta de prueba (no usaba el índice por provincia) y se descartó; la consulta real de la app tarda 137 ms para 962 filas.

Corrección: migración `20261018183559_rls_policy_performance.sql` (aplicada en producción el 18/10/2026 con aprobación del titular; versión registrada `20261018183559`). La misma regla, evaluada una vez por consulta: el administrador como subconsulta escalar y las provincias accesibles de un usuario como `province_id IN (SELECT private.accessible_province_ids())`, una función `SECURITY DEFINER` nueva con la misma condición que `private.has_province_access` (asignación, usuario activo y provincia activa). Se modifican con `ALTER POLICY` `establishments_select_scope`, `establishments_update_scope` y las tres políticas de `establishment_app_state`; las demás políticas (solicitudes, concesiones, seguimientos, revisiones e historial de ubicación) no cambian porque sus tablas están vacías.

Segunda medición, con la migración, en una base limpia:

| Carga | Antes | Después |
|---|---|---|
| Administrador, 50.000 puntos (recuento 25 ms, página más lenta 9 ms) | 25.122 ms | **87 ms** |
| Usuario con dos provincias | 1.105 ms | **9 ms** |
| Usuario con una provincia | 461 ms | **2 ms** |
| Estado compartido, administrador | 609 ms | **4 ms** |
| Estado compartido, dos provincias | 676 ms | **1 ms** |

Verificación de que la regla no cambia:
- `supabase/tests/rls_performance.sql` (17 comprobaciones, nueva, con paso en `schema-smoke.yml`): equivalencia de `has_province_access` con «administrador o provincia accesible» en 24 combinaciones de 6 actores (administrador, administrador desactivado, usuario con dos provincias, usuario desactivado, sin provincias, con una provincia inactiva) y 4 provincias; definiciones de las 5 políticas; permisos de la función nueva; lo que ve y puede modificar cada actor; y el plan de ejecución, que ya no llama a `has_province_access` por fila. Sin la migración falla.
- La matriz RLS completa sigue en **973 celdas, 0 discrepancias**; `province_active.sql` (23) y el resto de suites en verde.
- Huellas tras la migración: políticas 51 `f12aa1807b8a71c454a6854adb378ebc` y funciones privadas 4 `8c6f87f46800ea447b7a26217f409509`; permisos, funciones públicas, triggers y RLS sin cambios.

Producción tras aplicarla: 28 migraciones; solo cambian la huella de políticas (51, `f12aa1807b8a71c454a6854adb378ebc`) y la de funciones privadas (4, `8c6f87f46800ea447b7a26217f409509`), ambas iguales que en la reconstrucción local; permisos, funciones públicas, triggers y RLS sin cambios; 791 puntos y 2 estados sin cambios; la función nueva no es ejecutable por `anon` y sí por `authenticated`; el asesor de seguridad solo muestra el aviso aceptado de contraseñas filtradas y el de rendimiento solo avisos informativos de índices sin uso (21). Con el rol `authenticated` simulado dentro de una transacción que se deshace, en el Supabase real: el administrador real ve 791 puntos y 2 estados, y un usuario no administrador real con provincia asignada ve 791 y 2.

Límites de la medición: es PostgreSQL local, no el servidor de Supabase (más pequeño, así que los tiempos absolutos serían mayores; el factor de mejora es el relevante), y no incluye PostgREST ni la red. Queda pendiente la parte del navegador con 50.000 puntos (carga, lista, marcadores y filtros), que también puede hacerse sin proyecto con el Supabase simulado.

## H-27 y prueba de volumen en el navegador (PR #100)

Se hizo **sin crear ningún proyecto de Supabase**: la app real en Chrome contra el Supabase simulado (`scripts/dev/mock-supabase.mjs`, que ahora genera N puntos sintéticos reproducibles en las 52 provincias con `GET /__reset?n=<puntos>&estados=1` y los entrega paginados de 1.000 en 1.000 con el recuento exacto, como la API real). Usuario administrador, que carga todos los puntos. Guiones reutilizables: `scripts/dev/measure-load.js` y `scripts/dev/list-scenarios.js`.

Medición con el código anterior (el de `main` antes de este PR):

| Puntos | Hasta el mapa | `renderList` | Marcadores (`makeMarker`, `cluster.addLayer`) | `refreshSelects` | Filtro de categoría / búsqueda |
|---|---|---|---|---|---|
| 5.000 | 6,4 s | 3,9 s | 1,8 s (1,7 s) | 0,4 s | 0,5 s / 0,8 s |
| 10.000 | 20,4 s | **16,5 s** (×4,2) | 3,1 s (2,8 s) | 0,7 s | |
| 20.000 | **75,5 s** (una sola tarea que congela la página 75 s, más otra de 8 s) | | | | |

Con 5.000 puntos la página ya se congelaba 6,3 s. Duplicar los puntos multiplicaba `renderList` por 4 (coste cuadrático) y 20.000 puntos dejaban la página congelada más de un minuto; 50.000 eran inviables (extrapolación, no medido: varios minutos). Marcadores y selectores crecían de forma lineal.

Causas:
1. `renderList`: para agrupar los puntos con seguimiento y los que caducan en 30 días buscaba el punto de cada elemento con `CENTERS.find((x) => x.id === +li.dataset.id)`, una búsqueda lineal que además lee `dataset` del DOM en cada comparación: n² lecturas del DOM.
2. Los marcadores se añadían al agrupador uno a uno (`cluster.addLayer`, unos 0,3 ms cada uno) y, en cada filtro, se quitaban y añadían uno a uno.
3. Se dibujaba la lista entera (un elemento del DOM por punto) con cada filtro o letra de la búsqueda: con 5.000 puntos, 37.651 nodos.
4. Menor: `normalizePersonalRefs` recorría todos los puntos por cada referencia (3.553 ms con 50.000 puntos y 3.000 referencias).

Corrección (solo `index.html`):
- `renderList` filtra una vez, calcula los grupos sobre los datos y no sobre el DOM, y añade y quita los marcadores en bloque (`cluster.addLayers` y `cluster.removeLayers`).
- Los marcadores nuevos se crean y añaden en bloque (`makeMarkers`).
- La lista lateral dibuja como máximo 1.000 puntos (`LIST_PAGE`) y un pie «Mostrando 1000 de N puntos. [Mostrar 2000 más]». La primera versión usaba 300; se subió a 1.000 por decisión del titular (18/10/2026) porque con los 791 puntos de producción un límite de 300 era un cambio visible sin beneficio: el problema de rendimiento solo aparece con miles de puntos. La primera página vuelve cuando cambian la búsqueda o los filtros. Los grupos («Seguimientos de hoy o atrasados», «Caducan en 30 días», «Resto de puntos») se siguen calculando sobre todos los puntos visibles y sus contadores son los totales. Si se pulsa en el mapa el marcador de un punto que no está dibujado, la lista se amplía hasta incluirlo y lo marca como activo. Con 1.000 puntos o menos, la lista es idéntica a la de antes.
- `normalizePersonalRefs` usa índices por nombre y por referencia (3.553 ms → 23 ms).

Medición con el código nuevo:

| Puntos | Hasta el mapa | `renderList` (2 llamadas) | Marcadores (`addLayers`) | `refreshSelects` (2 llamadas) | Filtro de categoría / búsqueda | Nodos DOM | Memoria | Tarea más larga |
|---|---|---|---|---|---|---|---|---|
| 5.000 | **0,35 s** (antes 6,4 s) | 13 ms | 121 ms (89 ms) | 178 ms | 37 ms / 37 ms | 3.393 | 47 MB | 238 ms |
| **50.000** | **3,9 s** (50 peticiones) | 63 ms | 567 ms (343 ms) | 1,8 s | 176 ms / 286 ms | 3.393 | 177 MB | 1,6 s |

Descarga: unos 38 KB con gzip por cada 1.000 puntos (423 KB sin comprimir), es decir, unos 1 MB con gzip (20 MB sin comprimir) para 50.000 puntos con las columnas que pide la app.

Verificación de que no cambia lo que se ve:
- Con 250 puntos con estados de permisos (grupos incluidos), 9 escenarios (sin filtros, categoría, búsqueda, estado solicitado, estado concedido, orden por valoración, «por revisar», «seguimiento» y vuelta a la base) dan el mismo número de elementos y el **mismo HTML, byte a byte**, en la versión anterior y en la nueva.
- Con 2.000 puntos con estados: los grupos muestran los totales (67, 67 y 1.866); «Mostrar más» amplía a 900; un filtro devuelve a la primera página y con 200 resultados no hay pie; el marcador de un punto fuera de la primera página amplía la lista (304 → 2.003 elementos) y lo marca activo. Con teclado real, Intro sobre «Mostrar más» amplía a 900 puntos y el foco pasa al primer punto añadido (el botón desaparece al redibujar). 0 violaciones de CSP.
- `scripts/test-list-performance.mjs` (nuevo, en CI): equivalencia de `normalizePersonalRefs` con la versión anterior en 8 entradas, coste con 50.000 puntos y 3.000 referencias (23 ms; con `main` falla con 3.553 ms) y que no vuelven los patrones lentos.

Límites: es el navegador de la máquina de pruebas contra un simulador local, no el servidor real ni la red; no se midió el uso de varios usuarios a la vez. Lo más pesado que queda con 50.000 puntos es `refreshSelects` (1,8 s, lineal) y la memoria (177 MB); si el administrador necesitara menos, cabría cargar por provincia (decisión de producto, no necesaria hoy). En producción hoy hay 791 puntos: con el límite de 1.000 la lista es idéntica a la de antes de H-27 (ver abajo).

### Ajuste del límite de la lista a 1.000 (PR #101)

La primera versión de H-27 (PR #100) limitaba la lista a 300 puntos. Al verificarla en producción con la sesión del titular se vio que, con los 791 puntos reales, la lista mostraba «Mostrando 300 de 791 puntos» en lugar de los 791 de antes: un cambio visible sin beneficio, porque el problema de rendimiento solo aparece con miles de puntos. Se había anunciado por error que con 791 puntos no se notaría (791 supera 300). El titular eligió subir el límite a 1.000.

- Con 791 puntos con estados de permisos y el límite de 1.000, la lista de la versión **anterior a H-27** y la de la nueva son idénticas, byte a byte, en los 9 escenarios (794 elementos en la base: 791 puntos y 3 cabeceras de grupo; categoría 83; búsqueda 114; solicitado 28; concedido 55; orden por valoración 791; «por revisar» 116; «seguimiento» 28), y no aparece el pie.
- Rendimiento con el límite de 1.000 (administrador, Supabase simulado):

| Puntos | Hasta el mapa | Filtro / búsqueda / quitar filtro | Elementos en la lista | Nodos DOM |
|---|---|---|---|---|
| 791 | 0,23 s | 41 ms / 38 ms / 75 ms | 791 | 6.960 |
| 5.000 | 0,89 s | 168 ms / 157 ms / 247 ms | 1.000 | 8.493 |
| 50.000 | 6,5-6,6 s (dos mediciones) | 0,6 s / 0,4 s / 0,9 s | 1.000 | 8.493 |

Con 50.000 puntos la medición con límite 300 había dado 3,9 s; las dos mediciones con 1.000 dieron 6,5-6,6 s, pero en la repetición renderList sumó solo 263 ms y lo que se encareció fue refreshSelects (6,2 s frente a 1,8 s) y la creación de marcadores (1,6 s frente a 0,6 s), que no dependen del límite: la máquina de pruebas iba más lenta. Se documenta como un rango de 4 a 7 s según la carga de la máquina.

### Verificación en producción de H-27 (PR #100, 18/10/2026)

main 08e3f58, mismo SHA-256 que la URL pública. Sin sesión: código nuevo, sin errores ni violaciones de CSP. Con la sesión del titular (administrador, solo lectura): 791 puntos en una petición, sin errores en consola ni violaciones de CSP, 2.715 nodos DOM y 6 MB de memoria; la lista mostraba 300 de 791 (el efecto descrito arriba, corregido en el PR #101); la base no cambia (791 puntos, 2 estados en versión 1, 43 filas de historial de ubicación, última auditoría del 17/10).

### Peso de la carga inicial (medido el 18/10/2026 sobre https://danytf.github.io/mapas/, sin sesión)

Medido en Chrome con la API de rendimiento del navegador y las cabeceras de los CDN. No incluye teselas del mapa (ArcGIS, bajo demanda) ni la consulta del catálogo autenticada.

| Recurso | Transferido (comprimido) |
|---|---|
| index.html (gzip) | 87.832 B (235.122 B descomprimido) |
| supabase-js 2.118.0 (jsDelivr, brotli) | 55.911 B |
| leaflet.js 1.9.4 (unpkg, gzip) | 42.481 B |
| leaflet.markercluster.js 1.5.3 | 8.706 B |
| leaflet.css | 3.522 B |
| MarkerCluster.css + .Default.css | 251 B + 393 B |
| CSS de Google Fonts | 429 B |
| **Total sin teselas ni catálogo** | **unos 199 kB** (194 KiB) |

- Tiempos (carga fría de la sesión de pruebas): primer contenido pintado 672 ms; DOMContentLoaded 760 ms; carga completa 781 ms; primer byte 366 ms.
- Limitación: los tamaños de los recursos de otros dominios no los expone el navegador (sin Timing-Allow-Origin), por eso se leyeron con `curl` (cabeceras y bytes comprimidos); los tiempos son de un solo navegador y una sola conexión, orientativos.
- La CSP bloquea `fetch` desde la página a los CDN (comprobado: «Failed to fetch»), como se espera.
- Catálogo: el JSON completo de las 791 filas de `establishments` ocupa 640.161 B sin comprimir (809 B por fila de media; es una cota superior, porque la app pide solo algunas columnas, y la compresión de la respuesta de la API no se ha medido). La consulta del catálogo se hace en una petición (791 < 1.000) y con 50.000 puntos serían unas 50 peticiones de 1.000 filas (ver H-23 y H-27).
- Conclusión: la carga inicial es ligera (unos 0,2 MB más el catálogo) y no requiere acción. El mayor coste potencial es el catálogo cuando crezca, ya tratado en H-23, H-26 y H-27.
