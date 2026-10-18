# Auditoría Fase D: preparación para varias provincias y volumen (18/10/2026)

Estado: **en curso**. Esta primera entrega recoge los hallazgos de la Fase D relacionados con el uso en varias provincias y con el volumen del catálogo (H-20 a H-23). El resto de la fase (rendimiento medido, accesibilidad más allá del teclado, H-03, H-15 a H-19 y H-25) sigue pendiente.

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

## H-20 y H-21: la app no depende de Granada (PR #96)

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

Observación nueva: H-25 (P3). La corrección de ubicación acepta cualquier punto de España; un error de pegado a otra provincia se guarda en el catálogo maestro (queda en el historial de ubicación). Un umbral de distancia respecto a la ubicación anterior necesita que el titular fije el valor.
