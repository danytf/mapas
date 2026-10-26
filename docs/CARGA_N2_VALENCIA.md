# Carga N2 de la Comunidad Valenciana (cargada)

Estado: **cargada en producción el 26/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Decimoquinta comunidad con el mismo procedimiento (ver `docs/CARGA_N2_CASTILLA_LA_MANCHA.md` y `docs/CARGA_N2_ARAGON.md`). Las tres provincias (03 Alicante/Alacant, 12 Castellón/Castelló y 46 Valencia/València) se cargan de una vez.

## Origen
- Fichero: `valencia-latest.osm.pbf` (Geofabrik, edición del **25/10/2026 21:21 UTC**, 140.860.862 bytes, MD5 `5d700aa4cd73648760c2abc14eae4a62` verificado contra el `.md5` de Geofabrik), fuera del repositorio. La primera descarga quedó cortada (116 MB) y se reanudó hasta completar el fichero. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/valencia-*.json`, derivadas de las de Castilla-La Mancha (castellano, con los términos en catalán/valenciano que ya llevaban: «ajuntament», «jutjat», «correus»…) con `solo_provincias` 03, 12 y 46 y `region: valencia`. En `generar_lote.py` se añadieron los códigos 03, 12 y 46 y el nombre de fichero pasa a ASCII puro (antes «València» salía con acento).
- **Revisión tras la extracción:** el filtro de Hospital dejaba pasar 18 que no lo son: 11 («Asisa València», «Dua Clinic», «Metge Fontanars dels Alforins», «Sermesa Mislata», una delegación de Cruz Roja, un centro de especialidades, un centro de parálisis cerebral, un centro de rehabilitación, una unidad básica de salud, «el Raval» y las urgencias duplicadas del Hospital Vega Baja) y 7 «Torre A–G València» (edificios sin más dato). Se quitaron del lote (anotados en `excepciones.csv`) y se añadieron esas exclusiones a la definición de Resto de Valencia. Ningún código postal de otra provincia y ninguna coordenada fuera de la Comunidad.

## Municipios (N0)
- `supabase/seeds/valencia/municipios/import_municipios_03_12_46.sql`: **542 municipios** con código INE (141 de Alicante, 135 de Castellón y 266 de Valencia, las cifras oficiales). El fichero trae además municipios de Albacete, Cuenca, Murcia y Teruel (borde): quedan fuera por `solo_provincias`. Hoy las tres provincias tienen 0 municipios y 0 puntos y **están activas** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (3.537)
| Lote | Puntos |
|---|---|
| Correos | 208 |
| Estaciones | 140 |
| Grandes superficies (Carrefour 95, Leroy Merlin 20, Decathlon 20, MediaMarkt 12, El Corte Inglés 12, IKEA 3) | 162 |
| Resto (Supermercado 1.659, Entidad oficial 634, Gimnasios 293, Centro de salud 230, Centro comercial 97, Hospital 65, Bricolaje 49) | 3.027 |
| **Total** | **3.537** |

Por provincia: Alicante 1.377, Castellón 532 y Valencia 1.628. Un SQL por lote y provincia en `supabase/seeds/valencia/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (517 filas en total). `source_ref` con el prefijo `catalogo-valencia:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **94 puntos sin calle y 800 sin código postal** (el 23 %): Alicante 314 y 44, Castellón 154 y 9, Valencia 332 y 41 (código y calle). Se completan con Nominatim tras la carga.
- Estaciones: 8 entran «por revisar»: las estaciones de autobuses de Alacant y de Guardamar del Segura (cada una con una repetición), «Santa Magdalena de Pulpis» (tren, dos entradas), la estación de tren de Sax y una «Parada de autobus (Manuel)».
- Hospital (65): hay nombres repetidos que no se fusionan por estar a más de 150 m («Hospital General d'Ontinyent» y «Hospital Universitari i Politècnic La Fe», cada uno dos veces). Dudosos tras la carga: «Instituto Social de la Marina - Casa del Mar», «Hospital Centro Médico Acuario» (Beniarbeig), «Instituto de Traumatología Unión de Mutuas» y «Hospital Complementario de Segorbe».
- Centro comercial (97) incluye hipermercados («Carrefour Gandia», «Alcampo Alboraia») que ya están en otras categorías y algún comercio mal etiquetado («24h Indian Supermarket», «Anticrisis del Hogar»).
- Carrefour (95) entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, con `main` actualizada (`git pull origin main`), en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/valencia/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/valencia/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/valencia/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/valencia/grandes-superficies grandes-superficies catalogo-valencia:valencia-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/valencia/resto resto catalogo-valencia:valencia-resto:
```
Previsto en solo lectura: 542 municipios nuevos y 3.537 puntos (la base pasaría de 28.633 a 32.170 y los municipios de 5.040 a 5.582). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (26/10/2026)
- **Carga verificada en solo lectura:** 542 municipios (Alicante 141, Castellón 135, Valencia 266) y 3.537 puntos (1.377, 532 y 1.628), 3.537 `source_ref` `catalogo-valencia:` distintos, todos activos, ninguno sin coordenadas y ningún código postal con formato erróneo. Por categoría: Supermercado 1.659, Entidad oficial 634, Gimnasios 293, Centro de salud 230, Correos 208, Estaciones 140, Centro comercial 97, Carrefour 95, Hospital 65, Bricolaje 49, Decathlon 20, Leroy Merlin 20, MediaMarkt 12, El Corte Inglés 12, IKEA 3. Total de la base 28.633 -> 32.170 y municipios 5.040 -> 5.582.
- **Pendiente:** 800 códigos postales (Alicante 314, Castellón 154, Valencia 332) y 94 calles (44, 9 y 41), por completar con Nominatim por provincia (`completar_cp_desde_base.py --prov NN --con-calle`) y `admin_set_postal_codes`; revisar los dudosos de «Calidad y límites». Sin asignar a usuarios hasta terminar España.
