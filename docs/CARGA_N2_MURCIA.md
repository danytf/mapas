# Carga N2 de Murcia (cargada)

Estado: **cargada en producción el 23/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). La provincia ya figuraba como activa al terminar. Pendiente: códigos postales y calles. Cuarta región con el mismo procedimiento (Andalucía, Extremadura, La Rioja; ver `docs/CARGA_N2_EXTREMADURA.md` y `docs/CARGA_N2_LA_RIOJA.md`).

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

## Cierre (23/10/2026)
- **Carga verificada:** 45 municipios (todos con INE distinto) y 782 puntos (Supermercado 411, Entidad oficial 70, Centro de salud 67, Correos 50, Estaciones 49, Gimnasios 37, Centro comercial 27, Hospital 26, Carrefour 14, Bricolaje 14, Decathlon 5, Leroy Merlin 5, MediaMarkt 3, El Corte Inglés 3, IKEA 1). 782 `source_ref` `catalogo-murcia:` distintos; ninguno sin coordenadas o municipio. Total de la base 7.373 → 8.155.
- **Depuración tras la carga:** archivados 6 puntos que no corresponden a su categoría (con nota, recuperables desde Administración): en Bricolaje, Electro-Manga (electrodomésticos), Mármoles Daniel, Piscinas Costa Cálida y Porcelanosa; en Hospital, el Centro de Rehabilitación de Salud Mental de Cartagena y el Centro Sociosanitario «Cristo de los Mineros» (una residencia). Se mantienen las ferreterías y bricos, las clínicas (Policlínica Águilas, Clínica HLA Belén, Center of Medical Specialties de Jumilla) y dos de Bricolaje por identificar (Camina Cartagena y La Flota Murcia). Murcia queda con 776 puntos activos.
- **Códigos postales y calles:** 334 puntos sin código y 49 sin calle al cargar; completados el 23/10/2026 con Nominatim (consulta hecha por el titular) y `admin_set_postal_codes`, como en Extremadura y La Rioja. Se aceptaron 223 códigos (coinciden con un código ya conocido del municipio o el municipio solo tiene uno) y 17 calles (solo en puntos con la dirección vacía; descartados códigos de carretera RM-D, autovías y nombres que no son calle). Se rechazaron 13 códigos que contradicen el único código del municipio y se dejaron 87 dudosos (Lorca 30818, San Javier 30720, Molina de Segura 30560 y sueltos de Murcia y Cartagena) y 11 sin resultado. Verificado en solo lectura: 776 activos, **111 sin código postal y 31 sin calle**, ningún código con formato distinto de 30xxx.
- **Usuarios:** decisión del titular (23/10/2026): **no se asigna ninguna provincia nueva a nadie hasta terminar el mapa de toda España**.
- **Mejora pendiente del extractor:** afinar el filtro de Bricolaje (`shop=doityourself`) para excluir materiales de construcción, mármoles, piscinas, cerámica y electrodomésticos antes de las siguientes regiones.
