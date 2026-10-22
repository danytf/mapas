# Carga N2 de Extremadura (preparada, sin cargar)

Estado: **preparada el 22/10/2026, sin aplicar en producción**. Primera comunidad fuera de Andalucía, con el proceso ya rodado (ver `docs/DISENO_CARGA_NACIONAL.md` y `docs/CARGA_N2_ANDALUCIA_RESTO.md`).

## Origen
- Fichero: `extremadura-261020.osm.pbf` (Geofabrik, edición del 20/10/2026, 40.146.603 bytes, MD5 `2e5549bd715da4677468a8dcf3a115fd`), guardado fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/extremadura-*.json` (las de Andalucía limitadas a las provincias 06 y 10, sin la exclusión de Granada).

## Municipios (N0)
- `supabase/seeds/extremadura/municipios/municipios_06_10.sql`: 388 municipios oficiales (Badajoz 165, Cáceres 223) con código INE, de las áreas administrativas de nivel 8 de OpenStreetMap. Idempotente; no cambia nombres ni borra.
- Hoy las provincias 06 y 10 tienen 0 municipios y 0 puntos, y **están desactivadas (`is_active = false`)**. Esta carga no las activa: eso se hace desde «Usuarios y provincias» (decisión aparte).

## Puntos (1.230)
| Lote | Puntos | Badajoz | Cáceres |
|---|---|---|---|
| Correos | 104 | 68 | 36 |
| Estaciones (tren y autobús) | 84 (13 por revisar) | 56 | 28 |
| Grandes superficies (Carrefour 30, Leroy Merlin 4, Decathlon 4, El Corte Inglés 3, MediaMarkt 1) | 42 | 30 | 12 |
| Resto (Supermercado 381, Entidad oficial 426, Centro de salud 76, Hospital 38, Gimnasios 62, Centro comercial 11, Bricolaje 6) | 1.000 | 523 | 477 |
| **Total** | **1.230** | **677** | **553** |

Un SQL por provincia y lote en `supabase/seeds/extremadura/<lote>/` (transaccionales e idempotentes, `ON CONFLICT DO NOTHING`) y `excepciones.csv` con lo descartado o por revisar (148 filas en total).

## Calidad y límites
- Umbrales de siempre (duplicado a menos de 150 m, municipio por geometría INE, código postal con el prefijo de la provincia, calle de OpenStreetMap o la más cercana a ≤ 120 m, nombres genéricos a excepciones).
- Calle y código postal calculados con el propio fichero (sin Nominatim). Quedan **30 puntos sin calle y 526 sin código postal** (el 43 %: en Extremadura OpenStreetMap tiene menos direcciones con código postal que Andalucía). Entran vacíos y anotados; se rellenan después con `admin_set_postal_codes`.
- La base no tiene hoy ningún punto en estas provincias, así que no hay duplicados con lo existente.
- No probado en el PostgreSQL local (no se dispone de su contraseña en esta sesión); el esquema es el mismo que el de las cargas de Andalucía y el generador solo cambia los nombres de provincia.

## Cómo cargar (con aprobación)
```
bash scripts/catalogue/cargar.sh supabase/seeds/extremadura/municipios extremadura-municipios   # primero: los municipios
bash scripts/catalogue/cargar.sh supabase/seeds/extremadura/correos extremadura-correos catalogo-extremadura:correos:
```
(y lo mismo para `estaciones`, `grandes-superficies` y `resto`). Verificar después en solo lectura el reparto por provincia y categoría.
