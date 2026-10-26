# Carga N2 de Madrid (cargada)

Estado: **cargada en producción el 26/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Duodécima comunidad con el mismo procedimiento (ver `docs/CARGA_N2_ASTURIAS.md` y `docs/CARGA_N2_PAIS_VASCO.md`). Provincia 28.

## Origen
- Fichero: `madrid-latest.osm.pbf` (Geofabrik, edición del **25/10/2026 21:21 UTC**, 85.440.296 bytes, MD5 `797a2ad83d681ab0f0ca60bb6d67aa90` verificado contra el `.md5` de Geofabrik), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/madrid-*.json`, derivadas de las de Asturias (castellano, con los filtros afinados de Cataluña) con `solo_provincias` 28 y `region: madrid`. En `generar_lote.py` se añadió el código 28.
- **Revisión tras la extracción:** el filtro de Hospital dejaba pasar centros que no son hospitales (una farmacia, sedes de Cruz Roja, el Instituto Anatómico Forense, centros de vacunación, centros de especialidades ambulatorios, SUMMA 112, clínicas estéticas…). Se quitaron 18 del lote (anotados en `excepciones.csv` con su motivo) y se añadieron esas exclusiones a la definición de Resto de Madrid.

## Municipios (N0)
- `supabase/seeds/madrid/municipios/import_municipios_28.sql`: **178 municipios** con código INE, que son los que trae OpenStreetMap. **Límite no resuelto:** los oficiales de la Comunidad de Madrid son 179 (no verificado), así que podría faltar uno; sus puntos, si los hay, quedarían fuera como «fuera de los municipios oficiales cargados». Las 3 áreas de nivel 8 sin código INE del fichero no son municipios (localidades como El Redegüelo y Los Baldíos). El fichero trae además municipios de Ávila, Cuenca, Guadalajara y Toledo (borde): quedan fuera por `solo_provincias`. Hoy la provincia 28 tiene 0 municipios y 0 puntos y **está activa** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (3.620)
| Lote | Puntos |
|---|---|
| Correos | 190 |
| Estaciones (el metro, el tranvía y el cercanías ligero quedan fuera) | 119 |
| Grandes superficies (Carrefour 204, Decathlon 25, El Corte Inglés 18, MediaMarkt 17, Leroy Merlin 16, IKEA 9) | 289 |
| Resto (Supermercado 1.643, Gimnasios 505, Entidad oficial 296, Centro de salud 268, Centro comercial 167, Hospital 88, Bricolaje 55) | 3.022 |
| **Total** | **3.620** |

Un SQL por lote en `supabase/seeds/madrid/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (715 filas en total). `source_ref` con el prefijo `catalogo-madrid:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **66 puntos sin calle y 293 sin código postal** (el 8 %). Ningún código postal de otra provincia.
- Estaciones: 8 entran «por revisar»: Atocha (Cercanías y Puerta de Atocha, repetidas), T4 y T4S del aeropuerto, los intercambiadores de Moncloa (isla 1, 2 y 3), «Sol» y «La Parada» (Collado Villalba).
- Hospital (88): hospitales reales de la Comunidad de Madrid (públicos y privados) más alguna clínica privada; dudosos «Fundación Instituto San José», «Hermanas Hospitalarias Arroyomolinos» y «Centro Clínico ATAM».
- Centro comercial (167), dudosos: incluye hipermercados y supermercados etiquetados como centro comercial («Alcampo Pío XII»…) y centros pequeños de barrio; una parte repite lo que ya está en otras categorías.
- Carrefour (204) entra completo (Market y Express), por decisión del titular: es una cifra alta, y la categoría con más peso de Grandes superficies.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, con `main` actualizada (`git pull origin main`), en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/madrid/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/madrid/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/madrid/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/madrid/grandes-superficies grandes-superficies catalogo-madrid:madrid-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/madrid/resto resto catalogo-madrid:madrid-resto:
```
Previsto en solo lectura: 178 municipios nuevos y 3.620 puntos (la base pasaría de 21.456 a 25.076 y los municipios de 3.210 a 3.388). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (26/10/2026)
- **Carga verificada en solo lectura:** 178 municipios (178 códigos INE distintos) y 3.620 puntos, 3.620 `source_ref` `catalogo-madrid:` distintos, todos activos, ninguno sin coordenadas y ningún código postal con formato distinto de 28xxx. Por categoría: Supermercado 1.643, Gimnasios 505, Entidad oficial 296, Centro de salud 268, Carrefour 204, Correos 190, Centro comercial 167, Estaciones 119, Hospital 88, Bricolaje 55, Decathlon 25, El Corte Inglés 18, MediaMarkt 17, Leroy Merlin 16, IKEA 9. Total de la base 21.456 -> 25.076 y municipios 3.210 -> 3.388.
- **Códigos postales y calles (26/10/2026):** 320 puntos consultados con Nominatim (`completar_cp_desde_base.py --prov 28 --con-calle`, lanzado por el titular). Se escribieron **244 códigos** con `admin_set_postal_codes` desde la sesión de administrador (244 actualizados, 0 omitidos, auditados; la huella md5 de los pares id:código coincide con la de la base). Se dejaron **44 dudosos sin escribir** y 5 sin respuesta. Se escribieron **32 calles** (solo en puntos con la dirección vacía); se descartaron 5: dos de «Camino Natural del Tajo - GR 113» (una ruta), dos de «Vía de Servicio» y «Calle Carretera de la Estación». Verificado en solo lectura: **49 sin código postal y 34 sin calle**, ningún código con formato erróneo.
- **Provincia:** Madrid (28) ya estaba activa. Sin asignar a usuarios hasta terminar España.
- **Municipio que falta (identificado 26/10/2026):** comparando la lista de municipios de la Comunidad de Madrid de Wikipedia (179) con los 178 cargados, el que falta es **Santa María de la Alameda** (INE 28135). Está en OpenStreetMap (relación 347595, nivel 8, `ine:municipio=28135`, wikidata Q1769405), pero el generador no construyó su área en el extracto (causa no investigada), así que sus dos puntos del lote (el Ayuntamiento, way 839379035, y la estación de tren, node 5323342058) quedaron descartados como «fuera de los municipios oficiales cargados». Sigue sin cargarse: habría que añadir el municipio y esos dos puntos con aprobación del titular.
