# Carga N2 de Canarias (cargada)

Estado: **cargada en producción el 23/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Quinta región con el mismo procedimiento (Andalucía, Extremadura, La Rioja, Murcia). Las dos provincias, Las Palmas (35) y Santa Cruz de Tenerife (38), se cargan de una vez por decisión del titular.

## Origen
- Fichero: `canary-islands-latest.osm.pbf` (Geofabrik, edición del 21/10/2026, 60.034.717 bytes, MD5 `fa59112afab00d09999e404f8a7c6dac` verificado), fuera del repositorio. OpenStreetMap, licencia ODbL. No existe un fichero solo de Tenerife: el de Canarias incluye todas las islas.
- Definiciones: `scripts/catalogue/categorias/canarias-*.json`, derivadas de las de Murcia con `solo_provincias` 35 y 38 y `region: canarias`. Hospital con filtros añadidos para Canarias (centros de salud escritos «Centro Salud» o «CS», bases del 112, centros médicos, mutuas, CAE y centros de especialidades, gerencias). Las de «Centro de salud» aceptan también «Centro Salud» y «CS». Estaciones excluye «autobuses hoteles».

## Municipios (N0)
- `supabase/seeds/canarias/municipios/import_municipios_35_38.sql`: 88 municipios con código INE (34 en Las Palmas y 54 en Santa Cruz de Tenerife, las cifras oficiales). Hoy ambas provincias tienen 0 municipios y 0 puntos y **están desactivadas**; la carga no las activa. Un área de nivel 8 sin código INE se ignora.

## Puntos (1.627)
| Lote | Las Palmas | Santa Cruz de Tenerife | Total |
|---|---|---|---|
| Correos | 35 | 66 | 101 |
| Estaciones (autobús; no hay tren convencional) | 31 | 25 | 56 |
| Grandes superficies (Carrefour 8, MediaMarkt 7, IKEA 7, Decathlon 6, Leroy Merlin 5, El Corte Inglés 4) | 21 | 16 | 37 |
| Resto (Supermercado 903, Entidad oficial 133, Centro comercial 123, Gimnasios 112, Centro de salud 88, Hospital 42, Bricolaje 32) | 692 | 741 | 1.433 |
| **Total** | **779** | **848** | **1.627** |

Un SQL por lote y provincia en `supabase/seeds/canarias/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (240 filas en total). `source_ref` con el prefijo `catalogo-canarias:`. Un mismo elemento (Carrefour de Santa Cruz, dentro del centro comercial Añaza) entra en dos lotes con categorías distintas y `source_ref` distintos.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **41 puntos sin calle y 437 sin código postal** (el 27 %).
- Todas las coordenadas caen dentro del archipiélago; 88 municipios con INE distinto.
- Hospital (42): hospitales y clínicas reales, con algunos dudosos por revisar tras la carga (Hospiten Tamaragua, La Inmaculada, Clínica Vida, El Mojón, Nuestra Señora de la Concepción de Garachico, Hospital del Sur y Hospital Universitario Hospiten Sur en Arona, que podrían ser el mismo).
- Estaciones: «PB Bus (Granadilla de Abona)» aparece dos veces sin calle y no está claro que sea una estación; «Terminal Fred Olsen» es una terminal de ferris y guaguas.
- Se detectó que el patrón `^desa\b` del filtro de Hospital de las definiciones anteriores quedó guardado con un carácter de retroceso (`\x08`) y nunca excluyó nada; la de Canarias ya lo lleva bien. No se ha tocado el resto.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/canarias/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/canarias/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/canarias/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/canarias/grandes-superficies grandes-superficies catalogo-canarias:canarias-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/canarias/resto resto catalogo-canarias:canarias-resto:
```
Después, en solo lectura: 88 municipios nuevos y 1.627 puntos (la base pasaría de 8.155 a 9.782). Para verlos hay que activar las dos provincias desde «Usuarios y provincias». Sin asignar a usuarios hasta terminar toda España.

## Cierre (23/10/2026)
- **Carga verificada:** 88 municipios (34 y 54, todos con INE distinto) y 1.627 puntos (Las Palmas 779, Santa Cruz de Tenerife 848), 1.627 `source_ref` `catalogo-canarias:` distintos; ninguno sin coordenadas o municipio y todos activos. Por categoría: Supermercado 903, Entidad oficial 133, Centro comercial 123, Gimnasios 112, Correos 101, Centro de salud 88, Hospital 42, Estaciones 56, Bricolaje 32, Carrefour 8, IKEA 7, MediaMarkt 7, Decathlon 6, Leroy Merlin 5, El Corte Inglés 4. Total de la base 8.155 -> 9.782.
- **Provincias:** en la verificación ya constaban como activas (`is_active = true`).
- **Códigos postales y calles:** 437 puntos sin código (Las Palmas 246, Santa Cruz de Tenerife 191) y 41 sin calle (20 y 21). Pendientes de completar con Nominatim.
- **Usuarios:** sin asignar a nadie hasta terminar el mapa de toda España (decisión del titular).
- **Pendiente de revisar:** los hospitales y estaciones dudosos de «Calidad y límites».
