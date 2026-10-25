# Carga N2 de Illes Balears (preparada)

Estado: **preparada el 26/10/2026, pendiente de carga en producción por el titular con `cargar.sh`**. Décima comunidad con el mismo procedimiento (ver `docs/CARGA_N2_CATALUNYA.md` y `docs/CARGA_N2_NAVARRA.md`).

## Origen
- Fichero: `islas-baleares-latest.osm.pbf` (Geofabrik, edición del 24/10/2026 20:20 UTC, 46.812.905 bytes, MD5 `9e89386638ab52ec7ff86f0c13064b5a` verificado contra el `.md5` de Geofabrik; guardado como `baleares-latest.osm.pbf`), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/baleares-*.json`, derivadas de las de Cataluña (los nombres están en catalán: Correus, Ajuntament, Jutjat, CAP…) con `solo_provincias` 07 y `region: baleares`. En `generar_lote.py` se añadió el código 07.

## Municipios (N0)
- `supabase/seeds/baleares/municipios/import_municipios_07.sql`: 67 municipios con código INE (los 67 oficiales de las Illes Balears). Hoy la provincia 07 tiene 0 municipios y 0 puntos y **está activa** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (1.119)
| Lote | Puntos |
|---|---|
| Correos | 53 |
| Estaciones | 33 |
| Grandes superficies (Carrefour 15, Decathlon 7, El Corte Inglés 6, IKEA 3, Leroy Merlin 2, MediaMarkt 1) | 34 |
| Resto (Supermercado 734, Gimnasios 109, Entidad oficial 69, Centro de salud 28, Centro comercial 30, Hospital 20, Bricolaje 9) | 999 |
| **Total** | **1.119** |

Un SQL por lote en `supabase/seeds/baleares/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (231 filas en total). `source_ref` con el prefijo `catalogo-baleares:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **30 puntos sin calle y 193 sin código postal** (el 17 %). Todas las coordenadas caen dentro del archipiélago.
- Estaciones: 2 entran «por revisar» («Estación de tren de Palma» y «Plaça d'Espanya (Palma)», posible duplicado). No hay estaciones de metro de Palma en el lote por las reglas de siempre.
- Hospital (20), dudosos tras la carga: «Muro» (nombre de una sola palabra), «UBS Pla de na Tesa» (parece un centro de salud) y «Hospital de Caubet» (Bunyola); varias clínicas privadas (Juaneda, Rotger, Quirón) que son reales.
- Centro comercial (30), dudosos: «Es Mercat» y «Mercat Nou», que pueden ser mercados municipales, y establecimientos que ya están en otras categorías («Alcampo Marratxí»).
- Supermercado (734) es la categoría más grande; incluye comercios pequeños de alimentación de las zonas turísticas. Carrefour (15) entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo cargar (con aprobación)
Desde la raíz del repositorio, con la rama `feat/carga-baleares`, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/baleares/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/baleares/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/baleares/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/baleares/grandes-superficies grandes-superficies catalogo-baleares:baleares-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/baleares/resto resto catalogo-baleares:baleares-resto:
```
Después, en solo lectura: 67 municipios nuevos y 1.119 puntos (la base pasaría de 18.559 a 19.678 y los municipios de 2.892 a 2.959). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).
