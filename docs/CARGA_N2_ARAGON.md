# Carga N2 de Aragón (cargada)

Estado: **cargada en producción el 26/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Decimotercera comunidad con el mismo procedimiento (ver `docs/CARGA_N2_MADRID.md` y `docs/CARGA_N2_ASTURIAS.md`). Las tres provincias (22 Huesca, 44 Teruel y 50 Zaragoza) se cargan de una vez.

## Origen
- Fichero: `aragon-latest.osm.pbf` (Geofabrik, edición del **25/10/2026 21:21 UTC**, 95.177.811 bytes, MD5 `cafae40507bfe5acc42d2231f9d1ff29` verificado contra el `.md5` de Geofabrik), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/aragon-*.json`, derivadas de las de Asturias (castellano, con los términos en catalán de Cataluña para la Franja oriental) con `solo_provincias` 22, 44 y 50 y `region: aragon`. En `generar_lote.py` se añadieron los códigos 22, 44 y 50.
- **Revisión tras la extracción:** el filtro de Hospital dejaba pasar 5 que no son hospitales (una farmacia, «Consultas Externas Miguel Servet», dos centros de rehabilitación y «CME San José»). Se quitaron del lote (anotados en `excepciones.csv` con su motivo) y se añadieron esas exclusiones a la definición de Resto de Aragón.

## Municipios (N0)
- `supabase/seeds/aragon/municipios/import_municipios_22_44_50.sql`: **731 municipios** con código INE (202 de Huesca, 236 de Teruel y 293 de Zaragoza, las cifras oficiales). El fichero trae además municipios de Castellón, Guadalajara, Lleida, Navarra, Soria, Tarragona y Valencia (borde): quedan fuera por `solo_provincias`. Hoy las tres provincias tienen 0 municipios y 0 puntos y **están activas** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (1.594)
| Lote | Puntos |
|---|---|
| Correos | 81 |
| Estaciones | 113 |
| Grandes superficies (Carrefour 15, Decathlon 5, El Corte Inglés 3, Leroy Merlin 2, MediaMarkt 1, IKEA 1) | 27 |
| Resto (Entidad oficial 668, Supermercado 480, Gimnasios 89, Centro de salud 80, Hospital 26, Centro comercial 16, Bricolaje 14) | 1.373 |
| **Total** | **1.594** |

Por provincia: Huesca 356, Teruel 358 y Zaragoza 880. Un SQL por lote y provincia en `supabase/seeds/aragon/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (178 filas en total). `source_ref` con el prefijo `catalogo-aragon:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **80 puntos sin calle y 624 sin código postal** (el 39 %), sobre todo en pueblos pequeños, donde OpenStreetMap trae pocas direcciones con código. Se completan con Nominatim tras la carga.
- Entidad oficial (668) es la categoría más grande: ayuntamientos de casi todos los municipios, juzgados de paz y oficinas.
- Estaciones: 2 entran «por revisar» («Estación de Autobuses de Teruel», repetida).
- Hospital (26), dudosos tras la carga: «Clínica Manzanera», «Hospital Militar», «Ernest Lluch» (Calatayud, un centro de salud) y «Centro Sanitario Bajo Cinca» (Fraga).
- Centro comercial (16) incluye hipermercados («Alcampo», «Centro Comercial Carrefour») que ya están en otras categorías.
- Carrefour (15) entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, con `main` actualizada (`git pull origin main`), en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/aragon/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/aragon/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/aragon/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/aragon/grandes-superficies grandes-superficies catalogo-aragon:aragon-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/aragon/resto resto catalogo-aragon:aragon-resto:
```
Previsto en solo lectura: 731 municipios nuevos y 1.594 puntos (la base pasaría de 25.076 a 26.670 y los municipios de 3.388 a 4.119). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (26/10/2026)
- **Carga verificada en solo lectura:** 731 municipios (Huesca 202, Teruel 236, Zaragoza 293) y 1.594 puntos (356, 358 y 880), 1.594 `source_ref` `catalogo-aragon:` distintos, todos activos, ninguno sin coordenadas y ningún código postal con formato erróneo. Por categoría: Entidad oficial 668, Supermercado 480, Estaciones 113, Gimnasios 89, Correos 81, Centro de salud 80, Hospital 26, Centro comercial 16, Carrefour 15, Bricolaje 14, Decathlon 5, El Corte Inglés 3, Leroy Merlin 2, IKEA 1, MediaMarkt 1. Total de la base 25.076 -> 26.670 y municipios 3.388 -> 4.119.
- **Pendiente:** 624 códigos postales (Huesca 98, Teruel 209, Zaragoza 317) y 80 calles (27, 18 y 35), por completar con Nominatim por provincia y `admin_set_postal_codes`; revisar los dudosos de «Calidad y límites». Sin asignar a usuarios hasta terminar España.
- **Códigos postales y calles (26/10/2026):** 637 puntos consultados con Nominatim (`completar_cp_desde_base.py --con-calle`, lanzado por el titular). Se escribieron **370 códigos** con `admin_set_postal_codes` desde la sesión de administrador (Huesca 71, Teruel 87 y Zaragoza 212; 370 actualizados, 0 omitidos, auditados; verificado en solo lectura: 370 de 370 coinciden y la huella md5 de los pares id:código es idéntica a la esperada). Se escribieron **17 calles** (solo en puntos con la dirección vacía); se descartaron 5: cuatro «Vía Verde» (rutas) y un «camino». Quedan sin escribir los dudosos (el código de Nominatim no coincide con los del municipio) y 235 puntos sin respuesta de Nominatim (pueblos pequeños).
- **Estado tras escribir (solo lectura):** **254 sin código postal** (Huesca 27, Teruel 122 y Zaragoza 105) y **63 sin calle** (21, 15 y 27); ningún código con formato erróneo. Los 624 y 80 de «Calidad y límites» eran los previos.
