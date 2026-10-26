# Carga N2 de Galicia (cargada)

Estado: **cargada en producción el 26/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Decimosexta comunidad con el mismo procedimiento (ver `docs/CARGA_N2_VALENCIA.md` y `docs/CARGA_N2_CASTILLA_LA_MANCHA.md`). Las cuatro provincias (15 A Coruña, 27 Lugo, 32 Ourense y 36 Pontevedra) se cargan de una vez.

## Origen
- Fichero: `galicia-latest.osm.pbf` (Geofabrik, edición del **26/10/2026 01:59 GMT**, 111.945.842 bytes, MD5 `23a8d24069f50392cf14154ca68c7ce6` verificado contra el `.md5` de Geofabrik; base de datos de OpenStreetMap del 25/10/2026 21:21 UTC), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/galicia-*.json`, derivadas de las de Valencia (castellano y catalán) con `solo_provincias` 15, 27, 32 y 36 y `region: galicia`, más los términos gallegos «concello», «casa do concello», «xulgado», «pazo de xustiza», «rexistro civil», «axencia tributaria», «seguridade social», «centro de saúde» y «ferraría». En `generar_lote.py` se añadieron los códigos 15, 27, 32 y 36.
- **Revisión tras la extracción:** el filtro de Hospital dejaba pasar 3 que no lo son («Cruz Vermella» de Cedeira y de Burela y «Medicina Nuclear» de Santiago). Se quitaron del lote (anotados en `excepciones.csv`) y se añadieron a la definición de Resto de Galicia. Ningún código postal de otra provincia y ninguna coordenada fuera de Galicia.

## Municipios (N0)
- `supabase/seeds/galicia/municipios/import_municipios_15_27_32_36.sql`: **313 municipios** con código INE (93 de A Coruña, 67 de Lugo, 92 de Ourense y 61 de Pontevedra, las cifras oficiales). El fichero trae además un municipio de Zamora (borde): queda fuera por `solo_provincias`. Hoy las cuatro provincias tienen 0 municipios y 0 puntos y **están activas** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (2.737)
| Lote | Puntos |
|---|---|
| Correos | 194 |
| Estaciones | 167 |
| Grandes superficies (Carrefour 35, Decathlon 12, Leroy Merlin 10, MediaMarkt 6, El Corte Inglés 5, IKEA 1) | 69 |
| Resto (Supermercado 1.135, Entidad oficial 441, Centro de salud 408, Gimnasios 203, Centro comercial 57, Hospital 33, Bricolaje 30) | 2.307 |
| **Total** | **2.737** |

Por provincia: A Coruña 1.160, Lugo 482, Ourense 396 y Pontevedra 699. Un SQL por lote y provincia en `supabase/seeds/galicia/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (145 filas en total). `source_ref` con el prefijo `catalogo-galicia:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **225 puntos sin calle y 570 sin código postal** (el 21 %): A Coruña 105 y 59, Lugo 159 y 49, Ourense 159 y 51, Pontevedra 147 y 66 (código y calle). Se completan con Nominatim tras la carga.
- Estaciones: 2 entran «por revisar» («Estación de tren de Foz» y «Estación de tren de Tui», por nombre dudoso).
- Hospital (33), dudosos tras la carga: «Centro Oncolóxico de Galicia», «Centro Materno Infantil Nosa Sra. de Belén», «Hospital Naval» (Ferrol), «Sanatorio Hestia La Robleda» y los dos de Pontevedra «Hospital Montecelo» y «Hospital Gran Montecelo» (no verificado si es el mismo centro).
- Centro comercial (57) incluye hipermercados («Centro Comercial Alcampo», «Centro Comercial Carrefour») que ya están en otras categorías.
- Entidad oficial (441) es mayor que el número de concellos porque incluye juzgados, audiencias y oficinas de la Agencia Tributaria y la Seguridad Social.
- Carrefour (35) entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, con `main` actualizada (`git pull origin main`), en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/galicia/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/galicia/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/galicia/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/galicia/grandes-superficies grandes-superficies catalogo-galicia:galicia-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/galicia/resto resto catalogo-galicia:galicia-resto:
```
Previsto en solo lectura: 313 municipios nuevos y 2.737 puntos (la base pasaría de 32.170 a 34.907 y los municipios de 5.582 a 5.895). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (26/10/2026)
- **Carga verificada en solo lectura:** 313 municipios (A Coruña 93, Lugo 67, Ourense 92, Pontevedra 61) y 2.737 puntos (1.160, 482, 396 y 699), 2.737 `source_ref` `catalogo-galicia:` distintos, todos activos, ninguno sin coordenadas y ningún código postal con formato erróneo. Por categoría: Supermercado 1.135, Entidad oficial 441, Centro de salud 408, Gimnasios 203, Correos 194, Estaciones 167, Centro comercial 57, Carrefour 35, Hospital 33, Bricolaje 30, Decathlon 12, Leroy Merlin 10, MediaMarkt 6, El Corte Inglés 5, IKEA 1. Total de la base 32.170 -> 34.907 y municipios 5.582 -> 5.895.
- **Pendiente:** 570 códigos postales (A Coruña 105, Lugo 159, Ourense 159, Pontevedra 147) y 225 calles (59, 49, 51 y 66), por completar con Nominatim por provincia (`completar_cp_desde_base.py --prov NN --con-calle`) y `admin_set_postal_codes`; revisar los dudosos de «Calidad y límites». Sin asignar a usuarios hasta terminar España.
- **Códigos postales y calles (26/10/2026), A Coruña, Ourense y Pontevedra:** 475 puntos consultados con Nominatim. Se escribieron **305 códigos** con `admin_set_postal_codes` desde la sesión de administrador (305 actualizados, 0 omitidos, auditados) y **28 calles** (solo en puntos con la dirección vacía); se descartaron 19 calles que eran tramos de carretera («Estrada Ourense - Santiago», «Estrada Cotelas - Límite provincia de Pontevedra»…). Se dejaron sin escribir 106 dudosos (sobre todo Verín, Muros, Santiago de Compostela y Moaña). Verificado por recuentos: **33 sin código y 48 sin calle en A Coruña, 25 y 47 en Ourense y 48 y 53 en Pontevedra**, ningún código con formato erróneo (esta vez no se comparó la huella md5 de los pares). **Lugo (27), consultada después (168 puntos):** 119 códigos y 9 calles escritos (119 y 9 actualizados, 0 omitidos, auditados); se dejaron 35 dudosos y 5 sin respuesta, y se descartaron 12 calles que eran tramos de carretera. Quedan **40 sin código postal y 40 sin calle**, ningún código con formato erróneo (verificado por recuentos: 159 y 49 antes).
