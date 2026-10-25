# Carga N2 de Cataluña (cargada)

Estado: **cargada en producción el 25/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»): los 947 municipios y la primera parte (810 puntos: Correos, Estaciones y Grandes superficies), y después el lote Resto (5.500 puntos). Octava comunidad con el mismo procedimiento. Las cuatro provincias (08 Barcelona, 17 Girona, 25 Lleida y 43 Tarragona) se cargan de una vez, por decisión del titular.

## Origen
- Fichero: `cataluna-latest.osm.pbf` (Geofabrik, edición del 24/10/2026 20:20 UTC, 272.458.313 bytes, MD5 `55f0396780ccb1c244317d2cbb4b63c6` verificado contra el `.md5` de Geofabrik), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/cataluna-*.json`, derivadas de las de Murcia (Correos, Estaciones y Grandes superficies) y de Canarias (Resto), con `solo_provincias` 08, 17, 25 y 43 y `region: cataluna`. **Adaptadas al catalán**: Correos acepta «Correus»; Entidad oficial acepta «Ajuntament», «Casa de la Vila», «Jutjat», «Agència Tributària», «Seguretat Social» y «Registre civil»; Centro de salud acepta «Centre d'Atenció Primària», «Centre de Salut» y «CAP»; Gimnasios excluye «pavelló»; Supermercado excluye mercados municipales («mercat de/del/d'…», sin tocar los «supermercat…»). En `generar_lote.py` se añadieron los códigos 08, 17, 25 y 43.
- **Filtros afinados tras revisar la primera extracción:** (1) Bricolaje exige ahora nombre de ferretería o bricolaje (`brico`, `ferret`, `bauhaus`, `obramat`, `bigmat`, `saltoki`…), porque en Cataluña `shop=doityourself` está mal puesto en muchos comercios (docenas en Ulldecona: loterías, asesorías, una armería); pasó de 183 a 72. (2) La exclusión de «mercat» descartaba 204 supermercados reales («Supermercat Llobet», «Pròxim Supermercats»…); ahora solo excluye mercados. (3) Hospital excluye salud mental, psiquiatría, mutuas laborales, «urgències», nombres numerados y hospitales de día; pasó de 127 a 114.
- **Defecto del extractor, corregido en estas definiciones:** el patrón `^desa\b` del filtro de Hospital estaba guardado con un carácter de retroceso en las definiciones de Andalucía, Extremadura, La Rioja y Murcia (y no excluía nada). En las de Cataluña (y Asturias, que deriva de ellas) está bien. **Pendiente:** corregir esas cuatro definiciones antes de reutilizarlas; no cambia los datos ya cargados.

## Municipios (N0)
- `supabase/seeds/cataluna/municipios/import_municipios_08_17_25_43.sql`: 947 municipios con código INE (311 Barcelona, 221 Girona, 231 Lleida y 184 Tarragona, las cifras oficiales). **Cargados el 25/10/2026.**

## Puntos (6.310)
| Lote | Puntos | Estado |
|---|---|---|
| Correos | 264 | cargado |
| Estaciones (tren 287, autobús 53; metro, tranvía y funicular fuera) | 340 | cargado |
| Grandes superficies (Carrefour 116, Decathlon 29, MediaMarkt 20, Leroy Merlin 18, IKEA 15, El Corte Inglés 8) | 206 | cargado |
| Resto (Supermercado 3.416, Entidad oficial 964, Gimnasios 475, Centro de salud 374, Hospital 114, Centro comercial 85, Bricolaje 72) | 5.500 | cargado |
| **Total** | **6.310** | |

Por provincia, Resto: Barcelona 3.391, Girona 811, Lleida 584 y Tarragona 714. Un SQL por lote y provincia en `supabase/seeds/cataluna/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (946 filas en total). `source_ref` con el prefijo `catalogo-cataluna:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **99 puntos sin calle y 655 sin código postal** (el 10 %). Un código postal de OpenStreetMap que era de otra provincia (un Condis de Girona con 18003) se dejó vacío.
- Estaciones: 11 entran «por revisar»: aeropuerto de El Prat (varios elementos repetidos de T1 y T2), Ribes de Freser, la estación e intercambiador de autobuses de Tarragona (repetidos), y nombres dudosos («L2», «Vic», «Parada bus IES Coster de la Torre», que no es una estación). Se excluyeron 184 estaciones de metro, 16 funiculares y 3 de red de metro o tranvía. OpenStreetMap no indica si una estación tiene servicio; las de FGC que no son metro entran como tren.
- Hospital (114), dudosos tras la carga: varios repetidos con grafía distinta («Hospital Evangelic/Evangèlic», «Hospital Comarcal Sant Jaume (de) Calella», «Hospital de la Santa Creu i Sant Pau» dos veces, «Hospital-Asil de Granollers» y «Fundació Hospital Asil de Granollers»), fundaciones y mutuas («Fundació sanitaria Sant Pere Claver», «Fundació Eulàlia Torras de Beà», «Centre de Prevenció i Rehabilitació Asepeyo», «Institut Guttmann») y nombres sueltos («La República», «Sant Honorat», «Santa Fe», «VII Centenari», «la Salut», «Hispital Cima. Sanitas»).
- Centro comercial (85): incluye hipermercados y grandes almacenes etiquetados como centro comercial («Carrefour Tarragona», «El Corte Inglés Sabadell», «Alcampo Sant Quirze»…), que ya están, además, en otra categoría.
- Correos: 30 oficinas en Barcelona, plausible. Carrefour entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó la primera parte (con aprobación)
```
bash scripts/catalogue/cargar.sh supabase/seeds/cataluna/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/cataluna/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/cataluna/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/cataluna/grandes-superficies grandes-superficies catalogo-cataluna:cataluna-grandes-superficies:
```
Resultado verificado en solo lectura (25/10/2026): 947 municipios y 810 puntos (Barcelona 462, Girona 126, Lleida 99, Tarragona 123), base 10.550 -> 11.360.

## Cómo se cargó Resto (con aprobación)
```
bash scripts/catalogue/cargar.sh supabase/seeds/cataluna/resto resto catalogo-cataluna:cataluna-resto:
```
Previsto en solo lectura: 5.500 puntos más en Cataluña (6.310 en total) y la base de 12.388 a 17.888 (con Asturias ya cargada). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (25/10/2026)
- **Carga verificada en solo lectura:** 947 municipios (con sus códigos INE) y 6.310 puntos, todos activos, cada uno con su `source_ref` `catalogo-cataluna:` distinto, ninguno sin coordenadas y ningún código postal con formato distinto del de su provincia. Por provincia: Barcelona 3.853, Girona 937, Lleida 683 y Tarragona 837. Por categoría: Supermercado 3.416, Entidad oficial 964, Gimnasios 475, Centro de salud 374, Estaciones 340, Correos 264, Carrefour 116, Hospital 114, Centro comercial 85, Bricolaje 72, Decathlon 29, MediaMarkt 20, Leroy Merlin 18, IKEA 15 y El Corte Inglés 8. Total de la base 12.388 -> 17.888 y municipios 2.543 -> 2.621 (los 947 se cargaron antes de Asturias).
- **Provincias:** las cuatro ya estaban activas.
- **Pendiente:** **655 sin código postal** (Barcelona 294, Girona 156, Lleida 56, Tarragona 149) y **99 sin calle** (45, 15, 15, 24), por completar con Nominatim por provincia (`completar_cp_desde_base.py --prov NN --con-calle`) y `admin_set_postal_codes`; revisar los dudosos de «Calidad y límites». Sin asignar a usuarios hasta terminar España.
