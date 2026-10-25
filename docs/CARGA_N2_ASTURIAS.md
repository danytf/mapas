# Carga N2 de Asturias (preparada)

Estado: **preparada el 25/10/2026, pendiente de carga en producción por el titular con `cargar.sh`**. Séptima comunidad con el mismo procedimiento (Andalucía, Extremadura, La Rioja, Murcia, Canarias, Cantabria; ver `docs/CARGA_N2_CANTABRIA.md`).

## Origen
- Fichero: `asturias-latest.osm.pbf` (Geofabrik, edición del 24/10/2026 20:20 UTC, 36.627.279 bytes, MD5 `b2a1f297f0f9f7c141ba1424078daff6` verificado contra el `.md5` de Geofabrik), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/asturias-*.json`, derivadas de las de Cataluña (que ya llevan los filtros afinados de Bricolaje, Hospital y Supermercado) con `solo_provincias` 33 y `region: asturias`, más los términos asturianos «ayuntamientu», «conceyu» y «xulgáu». En `generar_lote.py` se añadió el código 33.

## Municipios (N0)
- `supabase/seeds/asturias/municipios/import_municipios_33.sql`: 78 municipios con código INE (los 78 oficiales de Asturias). Hoy la provincia 33 tiene 0 municipios y 0 puntos y **está activa** (`is_active = true`, comprobado en solo lectura el 25/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (1.028)
| Lote | Puntos |
|---|---|
| Correos | 65 |
| Estaciones (tren 184, autobús 24) | 208 |
| Grandes superficies (Carrefour 24, Decathlon 5, El Corte Inglés 5, Leroy Merlin 3, MediaMarkt 2, IKEA 1) | 40 |
| Resto (Supermercado 435, Entidad oficial 105, Gimnasios 67, Centro de salud 66, Hospital 19, Centro comercial 18, Bricolaje 5) | 715 |
| **Total** | **1.028** |

Un SQL por lote en `supabase/seeds/asturias/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (118 filas en total). `source_ref` con el prefijo `catalogo-asturias:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **130 puntos sin calle y 293 sin código postal** (el 28 %), sobre todo en Estaciones (84 sin calle y 153 sin código: apeaderos rurales).
- Estaciones: 7 entran «por revisar»: estaciones repetidas de El Berrón (Siero; 2) y de autobuses de Gijón (3), y nombres dudosos («Po», «Tol»). Hay 184 de tren, muchos apeaderos de la red de cercanías y ancho métrico; OpenStreetMap no indica si tienen servicio.
- Hospital (19), dudosos tras la carga: «Centro PET Asturias Hospital de Jove» (Gijón), «Entrada Oncología Radioterápica» (Oviedo, parece un acceso) e «Instituto Nacional de Silicosis».
- Centro comercial (18), dudosos: «Gijón El Llano – Piensos y Forrajes» y «KASAGRADO Grado» no parecen centros comerciales; también están en el lote «Costa Verde – El Corte Inglés» y «El Corte Inglés Avilés», que repiten un El Corte Inglés ya incluido en Grandes superficies (otra categoría).
- Correos (65): hasta 9 oficinas en Oviedo y 5 en Gijón, plausible. Carrefour (24) entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo cargar (con aprobación)
Desde la raíz del repositorio, con la rama `feat/carga-asturias`, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/asturias/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/asturias/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/asturias/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/asturias/grandes-superficies grandes-superficies catalogo-asturias:asturias-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/asturias/resto resto catalogo-asturias:asturias-resto:
```
Después, en solo lectura: 78 municipios nuevos y 1.028 puntos (la base pasaría de 11.360 a 12.388, antes de cargar el Resto de Cataluña, y los municipios de 2.543 a 2.621). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).
