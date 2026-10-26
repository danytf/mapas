# Carga N2 de Navarra (cargada)

Estado: **cargada en producción el 26/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Novena comunidad con el mismo procedimiento (ver `docs/CARGA_N2_ASTURIAS.md` y `docs/CARGA_N2_CATALUNYA.md`).

## Origen
- Fichero: `navarra-latest.osm.pbf` (Geofabrik, edición del 24/10/2026 20:20 UTC, 37.504.269 bytes, MD5 `8de2bad7a5efe1d8bc5acab1e59a1403` verificado contra el `.md5` de Geofabrik), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/navarra-*.json`, derivadas de las de Asturias (que vienen de las afinadas de Cataluña) con `solo_provincias` 31 y `region: navarra`, más términos en euskera: «Postetxea» (Correos), «Udaletxea», «Udal» y «Herriko etxea» (ayuntamiento), «Epaitegi» (juzgado) y «Osasun etxea» / «Osasun zentroa» (centro de salud). En `generar_lote.py` se añadió el código 31.

## Municipios (N0)
- `supabase/seeds/navarra/municipios/import_municipios_31.sql`: **271 municipios** con código INE, que son los que trae OpenStreetMap. **Límite no resuelto:** creo que Navarra tiene 272 municipios oficiales (no verificado), así que podría faltar uno; sus puntos, si los hay, quedarían fuera como «fuera de los municipios oficiales cargados» (hoy 3 puntos fronterizos en esa situación). Las 67 áreas de nivel 8 sin código INE que trae el fichero no son municipios: son facerías, montes comunales (Urbasa, Aralar, Andia), las Bardenas Reales y territorio francés (Biriatou, Sare). Hoy la provincia 31 tiene 0 municipios y 0 puntos y **está activa** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (671)
| Lote | Puntos |
|---|---|
| Correos | 33 |
| Estaciones | 26 |
| Grandes superficies (Carrefour 29, Decathlon 3, Leroy Merlin 2, MediaMarkt 1, IKEA 1, El Corte Inglés 1) | 37 |
| Resto (Supermercado 237, Entidad oficial 226, Centro de salud 55, Gimnasios 33, Centro comercial 10, Hospital 10, Bricolaje 4) | 575 |
| **Total** | **671** |

Un SQL por lote en `supabase/seeds/navarra/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (74 filas en total). `source_ref` con el prefijo `catalogo-navarra:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **16 puntos sin calle y 179 sin código postal** (el 27 %).
- Hospital (10), dudosos tras la carga: «Benito Menni CASM» (salud mental), «Centro Infanta Elena» (Galar) y «Solera La Vaguada» (Pamplona), que no parecen hospitales.
- Centro comercial (10), dudosos: las «ventas» fronterizas de Urdax (Axular Venta, Benta Peio ×2, Biok), «Nafarmendi» (Baztan) y «Roncesvalles» (Pamplona).
- Estaciones: 1 entra «por revisar» («Parada de la Baztanesa – Zubio», que parece una parada y no una estación).
- Carrefour (29) entra completo (Market y Express), por decisión del titular. Fuera de municipios: «La Rhune», «Torino Box» y «La Venta Des Pottoks» (zona fronteriza).
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, con la rama `feat/carga-navarra`, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/navarra/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/navarra/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/navarra/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/navarra/grandes-superficies grandes-superficies catalogo-navarra:navarra-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/navarra/resto resto catalogo-navarra:navarra-resto:
```
Previsto en solo lectura: 271 municipios nuevos y 671 puntos (la base pasaría de 17.888 a 18.559 y los municipios de 2.621 a 2.892). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (26/10/2026)
- **Carga verificada en solo lectura:** 271 municipios (271 códigos INE distintos) y 671 puntos, 671 `source_ref` `catalogo-navarra:` distintos, todos activos, ninguno sin coordenadas y ningún código postal con formato distinto de 31xxx. Por categoría: Supermercado 237, Entidad oficial 226, Centro de salud 55, Correos 33, Gimnasios 33, Carrefour 29, Estaciones 26, Centro comercial 10, Hospital 10, Bricolaje 4, Decathlon 3, Leroy Merlin 2, El Corte Inglés 1, IKEA 1, MediaMarkt 1. Total de la base 17.888 -> 18.559 y municipios 2.621 -> 2.892.
- **Provincia:** Navarra (31) ya estaba activa.
- **Códigos postales y calles (26/10/2026):** 182 puntos consultados con Nominatim (`completar_cp_desde_base.py --prov 31 --con-calle`, lanzado por el titular). Se escribieron **157 códigos** con `admin_set_postal_codes` desde la sesión de administrador (157 actualizados, 0 omitidos, 157 entradas en `audit_log`; la huella md5 de los pares id:código escritos coincide con la de la base). Se dejaron **7 dudosos sin escribir**, 2 con nombre repetido y 13 sin respuesta. **Calles: ninguna**: las 16 sin calle solo recibieron de Nominatim carreteras o accesos, que no se usan. Verificado en solo lectura: 671 puntos, **22 sin código postal y 16 sin calle**, ningún código con formato distinto de 31xxx.
- **Pendiente:** revisar los dudosos de «Calidad y límites». Sin asignar a usuarios hasta terminar España.
- **Municipio que falta (identificado 26/10/2026):** comparando la lista de municipios de Navarra de Wikipedia (272) con los 271 cargados, el que falta es **Petilla de Aragón** (INE 31203), un enclave navarro dentro de la provincia de Zaragoza. Está en el extracto de Aragón (relación 344399, nivel 8), no en el de Navarra, y su Ayuntamiento (node 3878143316) quedó descartado en el lote de Aragón como «fuera de las provincias del lote (31)». Sigue sin cargarse: habría que añadir el municipio (provincia 31) y ese punto con aprobación del titular.
