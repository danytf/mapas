# Carga N2 del País Vasco (preparada)

Estado: **preparada el 26/10/2026, pendiente de carga en producción por el titular con `cargar.sh`**. Undécima comunidad con el mismo procedimiento (ver `docs/CARGA_N2_NAVARRA.md` y `docs/CARGA_N2_CATALUNYA.md`). Las tres provincias (01 Araba/Álava, 20 Gipuzkoa y 48 Bizkaia) se cargan de una vez.

## Origen
- Fichero: `pais-vasco-latest.osm.pbf` (Geofabrik, edición del **25/10/2026 21:21 UTC**, 69.185.578 bytes, MD5 `141ca19847e0f9c7c2cfa6eacc8ccf28` verificado contra el `.md5` de Geofabrik; guardado como `paisvasco-latest.osm.pbf`), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/pais-vasco-*.json`, derivadas de las de Navarra (que ya traen términos en euskera) con `solo_provincias` 01, 20 y 48 y `region: pais-vasco`. Añadidos: Correos acepta «Posta bulegoa» y excluye «Akropost»; Entidad oficial acepta «Justizia jauregia», «Bake epaitegia», «Gizarte segurantza», «Ogasun», «Hacienda foral» y «Diputación foral»; Centro de salud acepta «Ambulatorio» (los ambulatorios de Osakidetza son centros de atención primaria); Hospital excluye «psikiatriko», «osasun mental», «eguneko ospital» (día) y «adikzio».
- `generar_lote.py`: códigos 01, 20 y 48, y **corrección de un defecto del generador**: el nombre «Araba/Álava» (con barra) se usaba en el nombre del fichero y fallaba al crear el SQL. Ahora la barra se cambia por un guion (el SQL sale como `…_01_araba-alava.sql`). Habría fallado igual con Alicante/Alacant, Castellón/Castelló y Valencia/València.

## Municipios (N0)
- `supabase/seeds/pais-vasco/municipios/import_municipios_01_20_48.sql`: **251 municipios** con código INE (51 de Araba/Álava, 88 de Gipuzkoa y 112 de Bizkaia, las cifras oficiales). El fichero trae además municipios de Burgos, La Rioja, Navarra y Cantabria (borde): quedan fuera por `solo_provincias`. Hoy las tres provincias tienen 0 municipios y 0 puntos y **están activas** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (1.778)
| Lote | Puntos |
|---|---|
| Correos | 101 |
| Estaciones | 206 |
| Grandes superficies (Carrefour 46, Decathlon 9, Leroy Merlin 6, MediaMarkt 5, IKEA 3, El Corte Inglés 2) | 71 |
| Resto (Supermercado 805, Entidad oficial 221, Gimnasios 147, Centro de salud 144, Centro comercial 36, Hospital 34, Bricolaje 13) | 1.400 |
| **Total** | **1.778** |

Por provincia: Araba/Álava 230, Gipuzkoa 654 y Bizkaia 894. Un SQL por lote y provincia en `supabase/seeds/pais-vasco/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (263 filas en total). `source_ref` con el prefijo `catalogo-pais-vasco:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **24 puntos sin calle y 104 sin código postal** (el 6 %).
- Estaciones: 11 entran «por revisar»: estaciones de autobuses de Vitoria-Gasteiz, Donostia y Gernika-Lumo repetidas con distinta grafía en castellano y euskera, estaciones de mercancías («Bilbao – Mercancías», «Puerto (CLH)») y «Ola (Sondika)». Se excluyen el metro de Bilbao y los tranvías.
- Hospital (34), dudosos tras la carga: «Aita Menni ospitalea» (salud mental), «Kanpañanea» (Alegia), «MiKS» (Vitoria-Gasteiz), clínicas y policlínicas privadas (IMQ, Pakea, Policlinica Gipuzkoa); el resto son hospitales públicos de Osakidetza.
- Centro comercial (36) incluye hipermercados y supermercados etiquetados como centro comercial («Alcampo Oiartzun», «Eroski Donostia», «Hiper Asia Durango»), que son duplicados de otras categorías.
- Carrefour (46) entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo cargar (con aprobación)
Desde la raíz del repositorio, con la rama `main` actualizada (`git pull origin main`), en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/pais-vasco/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/pais-vasco/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/pais-vasco/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/pais-vasco/grandes-superficies grandes-superficies catalogo-pais-vasco:pais-vasco-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/pais-vasco/resto resto catalogo-pais-vasco:pais-vasco-resto:
```
Después, en solo lectura: 251 municipios nuevos y 1.778 puntos (la base pasaría de 19.678 a 21.456 y los municipios de 2.959 a 3.210). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).
