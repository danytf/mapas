# Carga N2 de Murcia (preparada, sin cargar)

Estado: **preparada el 23/10/2026, sin aplicar en producción**. Cuarta región con el mismo procedimiento (Andalucía, Extremadura, La Rioja; ver `docs/CARGA_N2_EXTREMADURA.md` y `docs/CARGA_N2_LA_RIOJA.md`).

## Origen
- Fichero: `murcia-261020.osm.pbf` (Geofabrik, edición del 20/10/2026, 35.362.671 bytes, MD5 `c7d9b36804bfd30ade396a5180a180f7` verificado), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/murcia-*.json` (las de La Rioja limitadas a la provincia 30, con el filtro de Hospital afinado).

## Municipios (N0)
- `supabase/seeds/murcia/municipios/import_municipios_30.sql`: 45 municipios con código INE (los 45 reales de la Región de Murcia). Hoy la provincia 30 tiene 0 municipios y 0 puntos y **está desactivada** (`is_active = false`); la carga no la activa.

## Puntos (782)
| Lote | Puntos |
|---|---|
| Correos | 50 |
| Estaciones (tren y autobús) | 49 |
| Grandes superficies (Carrefour 14, Decathlon 5, Leroy Merlin 5, El Corte Inglés 3, MediaMarkt 3, IKEA 1) | 31 |
| Resto (Supermercado 411, Entidad oficial 70, Centro de salud 67, Gimnasios 37, Centro comercial 27, Hospital 26, Bricolaje 14) | 652 |
| **Total** | **782** |

Un SQL por lote en `supabase/seeds/murcia/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (132 filas en total). `source_ref` con el prefijo `catalogo-murcia:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **49 puntos sin calle y 334 sin código postal** (el 43 %).
- Hospital (26): hospitales y clínicas reales; 3 borderline por revisar (Center of Medical Specialties Jumilla, Centro de Rehabilitación de Salud Mental de Cartagena y Centro Sociosanitario «Cristo de los Mineros»).
- Bricolaje (14): contiene ruido de OpenStreetMap (materiales de construcción, mármoles, piscinas, Porcelanosa); la categoría usa `shop=doityourself` sin más filtro. Se puede depurar tras la carga.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo cargar (con aprobación)
Desde la raíz del repositorio, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/murcia/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/murcia/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/murcia/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/murcia/grandes-superficies grandes-superficies catalogo-murcia:murcia-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/murcia/resto resto catalogo-murcia:murcia-resto:
```
Después, en solo lectura: 45 municipios nuevos y 782 puntos en total (la base pasaría de 7.373 a 8.155). Para verlos hay que activar Murcia y asignarla a los usuarios desde «Usuarios y provincias».
