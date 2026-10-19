# Carga N1: Estaciones de Andalucía (piloto de la carga nacional)

Estado: **preparada y probada en local; pendiente de aprobación del titular para producción** (19/10/2026). Cadena: `extraer.py` → `validar.py` → `generar_lote.py` → `cargar.sh` (`scripts/catalogue/README.md`). Definición de la categoría: `scripts/catalogue/categorias/estaciones.json`. Ficheros del lote: `supabase/seeds/estaciones-andalucia/`.

Reproducir: fichero `andalucia-latest.osm.pbf` (MD5 `fc5f4003e4840d4f91e702005cc25e40`, base de OpenStreetMap del 17/10/2026 20:20:51 UTC), `ref-andalucia.json` (de `referencia.py`) y los puntos ya existentes de la categoría (consulta de solo lectura).

## Pruebas en local (PostgreSQL 17, base reconstruida con las migraciones + catálogo de Granada + municipios de Andalucía + estaciones de Granada)

- Carga de los 7 trozos: 246 puntos nuevos (total 805 → 1.051). Segunda carga: sin cambios (idempotente).
- Sin puntos sin municipio ni coordenadas. Alta registrada en `audit_log` (`insert`).
- Prueba negativa: con un código INE ausente, el trozo aborta con «Faltan municipios…» y no deja filas.
- Auditorías estáticas del repositorio en verde.

## Decisiones de extracción que conviene conocer

- **Granada**: la cadena reproduce exactamente los 14 puntos cargados a mano (12 por el identificador de OpenStreetMap y 2 por distancia: Iznalloz y Apeadero de Benalúa tienen la ubicación corregida a mano, `manual_google_maps`, por eso el filtro de existentes usa también la distancia). Granada no recibe puntos nuevos.
- **Tranvía-tren de la bahía de Cádiz** (Venta de Vargas, Alameda Solano, Plaza de la Iglesia): están etiquetados `light_rail=yes` sin `train=yes` (Renfe, red Cercanías Cádiz). Se excluyen como tren ligero, igual que el Metro de Granada. Los demás con `light_rail=yes` y `train=yes` (p. ej. Río Arillo) entran.
- El nombre se compone con el tipo cuando OpenStreetMap solo da el topónimo («Granada» → «Estación de tren de Granada») y se añade el municipio entre paréntesis si no aparece en el nombre (106 de 246 puntos; por ejemplo, 18 se llaman solo «Estación de Autobuses» en OpenStreetMap). Es una etiqueta de presentación; el nombre original está en `location_source`.
- La dirección queda vacía cuando OpenStreetMap no trae calle (223 de 246). No se ha enriquecido con Nominatim (ver «Decisiones pendientes»).


Origen: OpenStreetMap (ODbL 1.0, © colaboradores de OpenStreetMap). Criterio: Estaciones de tren (railway=station/halt de ferrocarril convencional) y de autobus (amenity=bus_station). Excluidos: metro, tren ligero, tranvia, funicular, estaciones maritimas, elementos en desuso, abandonados o en construccion, y elementos de autobus que son andenes o paradas (public_transport=platform/stop_position). Sin nombre se descarta. Mismo tipo y mismo nombre a menos de 300 m: se conserva uno.

- Elementos extraídos: 384. Entran: 246 (por revisar: 8). Descartados: 138.

## Entran por provincia

| Provincia | Tren | Autobús | Total |
|---|---|---|---|
| Almería | 10 | 9 | 19 |
| Cádiz | 22 | 17 | 39 |
| Córdoba | 12 | 10 | 22 |
| Huelva | 19 | 10 | 29 |
| Jaén | 14 | 21 | 35 |
| Málaga | 37 | 11 | 48 |
| Sevilla | 43 | 11 | 54 |
| **Total** | 157 | 89 | 246 |

## Descartados por motivo

- etiqueta station=light_rail: 61
- sin nombre en OpenStreetMap: 23
- etiqueta station=subway: 23
- ya existe en la base (mismo identificador de OpenStreetMap): 12
- etiqueta public_transport=platform: 7
- etiqueta light_rail=yes sin train=yes: 3
- duplicado en el lote  (): 3
- ya existe en la base a: 2
- etiqueta public_transport=stop_position: 2
- etiqueta disused=yes: 2

## Datos que faltan en lo que entra

- Sin calle (OpenStreetMap no la trae): 223 de 246. El campo dirección queda vacío; no se inventa.
- Sin código postal: 225 de 246.
- OpenStreetMap no indica si una estación tiene hoy servicio de viajeros; no se puede deducir de las etiquetas.

## Muestra aleatoria (semilla 1)

| Nombre | Subtipo | Municipio | Coordenadas | Origen |
|---|---|---|---|---|
| ESTACIÓN DE AUTOBUSES (Puente Genil) | Autobús | Puente Genil | 37.396024, -4.762742 | way/1041899260 |
| Estación de Autobuses (Écija) | Autobús | Écija | 37.534416, -5.076702 | way/248643971 |
| Estación de Autobuses de El Ejido | Autobús | El Ejido | 36.773129, -2.807935 | way/374774454 |
| Estación de Begíjar | Tren | Begíjar | 37.95565, -3.535578 | way/327851961 |
| Estación de autobuses (Peal de Becerro) | Autobús | Peal de Becerro | 37.915435, -3.121003 | way/269782482 |
| Estación de tren de Cantillana | Tren | Cantillana | 37.574743, -5.80325 | node/7763430699 |
| Estación de tren de Cumbres Mayores | Tren | Cumbres Mayores | 38.053081, -6.630903 | node/7788690536 |
| Estación de tren de Estadio Olímpico (Santiponce) | Tren | Santiponce | 37.417281, -6.007513 | node/7776575278 |
| Estación de tren de Los Boliches (Fuengirola) | Tren | Fuengirola | 36.554625, -4.614587 | node/258980884 |
| Estación de tren de Los Álamos (Torremolinos) | Tren | Torremolinos | 36.644749, -4.4855 | node/259009686 |
| Estación de tren de Salteras | Tren | Salteras | 37.410291, -6.098971 | node/1403430108 |
| Estación de tren de Segunda Aguada (Cádiz) | Tren | Cádiz | 36.513503, -6.276963 | node/5302170172 |
| Estación de tren de Vilches | Tren | Vilches | 38.215735, -3.5177 | node/7752653197 |
| Estación de tren de Villanueva del Ariscal y Olivares | Tren | Villanueva del Ariscal | 37.407225, -6.148288 | node/7779139705 |
| Jaén, Estación de Autobuses – Avenida de Madrid | Autobús | Jaén | 37.771465, -3.787598 | way/237977926 |

## Por revisar (8 puntos, `approximate`)

Los marca `validar.py`: posibles duplicados a menos de 150 m con otro nombre (Baeza, Huelva/«Zafra») y nombres dudosos («111», «Bus», «Autobuses Salidas», «Parada de autobús», «Jaén»). Lista con motivo en `excepciones.csv`. El resto entra con precisión `address`, igual que Granada.

## Decisiones pendientes del titular

1. **Aprobar la carga en producción** de los 7 trozos (246 puntos). Se aplicaría con `bash scripts/catalogue/cargar.sh supabase/seeds/estaciones-andalucia estaciones` desde su equipo (la cadena de conexión no se guarda). Solo inserta; ningún punto existente cambia.
2. **Provincias**: solo Granada y Málaga están activas. Los puntos de Almería, Cádiz, Córdoba, Huelva, Jaén y Sevilla se cargarían pero no serían visibles hasta activar esas provincias en Administración. Los de Málaga (48) sí serían visibles desde la carga para los usuarios de esa provincia (hoy sin puntos).
3. **Calles**: 223 de 246 sin calle. Opción: completarlas con Nominatim inverso (~4 minutos a 1 petición por segundo, `enriquecer.py`, que envía el correo de contacto del titular en el User-Agent) o dejarlas vacías.
4. Revisar la lista «por revisar» y confirmar el criterio de tranvía-tren de Cádiz.
