# Carga N2 de La Rioja (preparada, sin cargar)

Estado: **preparada el 23/10/2026, sin aplicar en producción**. Tercera región tras Andalucía y Extremadura, con el mismo procedimiento (`docs/CARGA_N2_EXTREMADURA.md`).

## Origen
- Fichero: `la-rioja-261020.osm.pbf` (Geofabrik, edición del 20/10/2026, 13.589.836 bytes, MD5 `e14e4d47e31124a03135ff3a588dbeaa` verificado), fuera del repositorio. OpenStreetMap, licencia ODbL. (La primera descarga salió truncada, 11.120.149 bytes y MD5 distinto, y se descartó; la buena se descargó de nuevo y se comprobó.)
- Definiciones: `scripts/catalogue/categorias/la-rioja-*.json` (las de Extremadura limitadas a la provincia 26, con el filtro de Hospital afinado).

## Municipios (N0)
- `supabase/seeds/la-rioja/municipios/import_municipios_26.sql`: 174 municipios con código INE. Hoy la provincia 26 tiene 0 municipios y 0 puntos y **está desactivada** (`is_active = false`); la carga no la activa.

## Puntos (246)
| Lote | Puntos |
|---|---|
| Correos | 12 |
| Estaciones (tren y autobús) | 21 |
| Grandes superficies (Carrefour 10, El Corte Inglés, MediaMarkt, Leroy Merlin y Decathlon, 1 cada uno) | 14 |
| Resto (Entidad oficial 78, Supermercado 86, Centro de salud 15, Hospital 6, Gimnasios 5, Bricolaje 5, Centro comercial 4) | 199 |
| **Total** | **246** |

Un SQL por lote en `supabase/seeds/la-rioja/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (50 filas en total). `source_ref` con el prefijo `catalogo-la-rioja:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **12 puntos sin calle y 83 sin código postal** (el 34 %).
- Los 6 hospitales son hospitales de verdad (sin zonas, urgencias ni Cruz Roja gracias al filtro afinado).
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo cargar (con aprobación)
Desde la raíz del repositorio, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/la-rioja/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/la-rioja/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/la-rioja/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/la-rioja/grandes-superficies grandes-superficies catalogo-la-rioja:la-rioja-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/la-rioja/resto resto catalogo-la-rioja:la-rioja-resto:
```
Después, en solo lectura: 174 municipios nuevos y 246 puntos en total. Para verlos hay que activar La Rioja y asignarla a los usuarios desde «Usuarios y provincias».
