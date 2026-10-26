# Carga N2 de Castilla y León (preparada)

Estado: **preparada el 26/10/2026, pendiente de carga en producción por el titular con `cargar.sh`**. Decimoséptima y última comunidad con el mismo procedimiento (ver `docs/CARGA_N2_GALICIA.md` y `docs/CARGA_N2_VALENCIA.md`). Las nueve provincias (05 Ávila, 09 Burgos, 24 León, 34 Palencia, 37 Salamanca, 40 Segovia, 42 Soria, 47 Valladolid y 49 Zamora) se cargan de una vez.

## Origen
- Fichero: `castilla-y-leon-latest.osm.pbf` (Geofabrik, edición del **26/10/2026 01:48 GMT**, 178.758.807 bytes, MD5 `03194d6ffb6a38cdd9166442b3ac7373` verificado contra el `.md5` de Geofabrik; base de datos de OpenStreetMap del 25/10/2026 21:21 UTC; guardado como `cyl-latest.osm.pbf`), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/castilla-y-leon-*.json`, derivadas de las de Castilla-La Mancha (castellano) con `solo_provincias` 05, 09, 24, 34, 37, 40, 42, 47 y 49 y `region: castilla-y-leon`. En `generar_lote.py` se añadieron los códigos de las nueve provincias.
- **Revisión tras la extracción:** (1) el filtro de Hospital dejaba pasar 2 que no lo son («Centro Polivalente Santa Teresa Zona Norte», Ávila, y «Centro Sociosanitario Hermanas Hospitalarias», Palencia): se quitaron del lote (anotados en `excepciones.csv`) y se añadieron a la definición. (2) **4 puntos traían un código postal de otra provincia** (error de OpenStreetMap) y se dejaron sin código para no cargar un dato falso: «Ayuntamiento de Montenegro de Cameros» (26127, de La Rioja), «Coaliment Candeleda» (07550, de Baleares), «Ayuntamiento de Quiñonería» (43126, de Tarragona) y «Ayuntamiento de Berzosilla» (39250, de Cantabria). Ninguna coordenada fuera de la Comunidad.

## Municipios (N0)
- `supabase/seeds/castilla-y-leon/municipios/import_municipios_05_09_24_34_37_40_42_47_49.sql`: **2.248 municipios** con código INE (Ávila 248, Burgos 371, León 211, Palencia 191, Salamanca 362, Segovia 209, Soria 183, Valladolid 225 y Zamora 248), que coinciden con las cifras que conozco (no contrastadas con el INE en esta sesión). OpenStreetMap traía 2.250: se quitaron dos que no son municipios, la «Comunidad de Barbadillo del Pez y Jaramillo de la Fuente» (09711, Burgos) y el «Coto Mancomunado de Pedrosillo el Ralo y Villaverde de Guareña» (37701, Salamanca), sin ningún punto asignado. El fichero trae además municipios de otras provincias (borde): quedan fuera por `solo_provincias`. Hoy las nueve provincias tienen 0 municipios y 0 puntos y **están activas** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (4.215)
| Lote | Puntos |
|---|---|
| Correos | 153 |
| Estaciones | 244 |
| Grandes superficies (Carrefour 70, Decathlon 11, Leroy Merlin 8, El Corte Inglés 5, IKEA 4, MediaMarkt 4) | 102 |
| Resto (Entidad oficial 2.122, Supermercado 1.044, Centro de salud 244, Gimnasios 209, Hospital 40, Centro comercial 29, Bricolaje 28) | 3.716 |
| **Total** | **4.215** |

Por provincia: Ávila 375, Burgos 625, León 556, Palencia 382, Salamanca 691, Segovia 382, Soria 244, Valladolid 587 y Zamora 373. Un SQL por lote y provincia en `supabase/seeds/castilla-y-leon/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (341 filas en total). `source_ref` con el prefijo `catalogo-castilla-y-leon:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **84 puntos sin calle y 1.498 sin código postal** (el 36 %, sobre todo en pueblos pequeños, donde OpenStreetMap trae pocas direcciones con código): Ávila 209 y 2, Burgos 213 y 22, León 187 y 20, Palencia 82 y 12, Salamanca 203 y 7, Segovia 125 y 5, Soria 125 y 2, Valladolid 112 y 4, Zamora 242 y 10 (código y calle). Se completan con Nominatim tras la carga: es la consulta más larga de toda la carga.
- Entidad oficial (2.122) es la categoría más grande: ayuntamientos de casi todos los municipios, juzgados y oficinas.
- Estaciones: 6 entran «por revisar» (dos entradas de la estación de autobuses de Astorga, dos de Nava de la Asunción y las paradas de Santa Eufemia del Arroyo y Villardiga).
- Hospital (40), dudosos tras la carga: «Policlínica Santa Marta» (Santa Marta de Tormes), «Centro Hospitalario Benito Menni» (Valladolid), «San Juan de Dios» (San Andrés del Rabanedo) y «Virgen del Mirón» (Soria).
- Centro comercial (29) incluye hipermercados («Carrefour Planet León», «Centro Comercial Camino de la Plata - Alcampo») que ya están en otras categorías.
- Carrefour (70) entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo cargar (con aprobación)
Desde la raíz del repositorio, con `main` actualizada (`git pull origin main`), en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-y-leon/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-y-leon/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-y-leon/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-y-leon/grandes-superficies grandes-superficies catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-y-leon/resto resto catalogo-castilla-y-leon:castilla-y-leon-resto:
```
Después, en solo lectura: 2.248 municipios nuevos y 4.215 puntos (la base pasaría de 34.907 a 39.122 y los municipios de 5.895 a 8.143). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026): con esta carga se completan las 17 comunidades más Ceuta y Melilla.
