# Carga N2 de Cantabria (cargada)

Estado: **cargada en producción el 25/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Sexta región con el mismo procedimiento (Andalucía, Extremadura, La Rioja, Murcia y Canarias; ver `docs/CARGA_N2_CANARIAS.md`).

## Origen
- Fichero: `cantabria-latest.osm.pbf` (Geofabrik, edición del 24/10/2026 20:20 UTC, 35.648.189 bytes, MD5 `11341d2b6fadcb2a3ae01c4b24627636` verificado contra el `.md5` de Geofabrik), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/cantabria-*.json`. Correos, Estaciones y Grandes superficies derivan de las de Murcia; Resto, de las de Canarias (filtro de Hospital afinado y «Centro Salud» / «CS» en Centro de salud), todas con `solo_provincias` 39 y `region: cantabria`. En `generar_lote.py` se añadió el código 39.

## Municipios (N0)
- `supabase/seeds/cantabria/municipios/import_municipios_39.sql`: 102 municipios con código INE (los 102 oficiales de Cantabria). Antes de la carga la provincia 39 tiene 0 municipios y 0 puntos y **está desactivada** (`is_active = false`, comprobado en solo lectura el 25/10/2026); la carga no la activa. Las áreas de otras provincias que aparecen en el fichero (Burgos, Palencia, Bizkaia) quedan fuera por `solo_provincias`.

## Puntos (723)
| Lote | Puntos |
|---|---|
| Correos | 30 |
| Estaciones (tren 85, autobús 19) | 104 |
| Grandes superficies (Carrefour 18, Decathlon 2, Leroy Merlin 2, El Corte Inglés 1, IKEA 1, MediaMarkt 1) | 25 |
| Resto (Supermercado 302, Entidad oficial 124, Gimnasios 61, Centro de salud 47, Hospital 14, Bricolaje 9, Centro comercial 7) | 564 |
| **Total** | **723** |

Un SQL por lote en `supabase/seeds/cantabria/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (69 filas en total). `source_ref` con el prefijo `catalogo-cantabria:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero (`completar_direcciones_local.py` e `inferir_cp_municipio.py`). Quedan **25 puntos sin calle y 114 sin código postal** (el 16 %).
- Comprobado antes de entregar: 723 `source_ref` distintos, todas las coordenadas dentro de Cantabria, todos los códigos postales con formato 39xxx y ningún nombre con caracteres rotos.
- No se ha probado en el PostgreSQL local (sin la contraseña en esta sesión).
- Estaciones: 7 entran «por revisar»; hay dos pares que parecen la misma estación: Reinosa (nodo y relación a 67 m, «Estación de tren de Reinosa» y «Estación de Renfe, ADIF (Reinosa)») y Renedo de Piélagos (nodo y área a 5 m). Otros dudosos por nombre: Mar (Polanco), Boo (El Astillero) y Parada Riocorvo (Cartes). OpenStreetMap no indica si una estación tiene servicio.
- Hospital (14), dudosos tras la carga: las 3 «Base del 061 Cantabria» (Santander, El Astillero y Laredo), Fundación Hospitalarias Cantabria, Cotolino II y Hospital Santa Cruz de Liencres.
- Bricolaje (9): ruido probable en Porcelanosa, Alufasa, Suministros Monte y Gutiérrez-Fernández Potes (el filtro de Bricolaje sigue pendiente de afinar).
- Centro comercial (7): «Johnson Control Camargo» no parece un centro comercial, y el Corte Inglés de Santander aparece dos veces (nodo y área).
- Carrefour entra completo (18, con Market y Express) por decisión del titular.

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/cantabria/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/cantabria/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/cantabria/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/cantabria/grandes-superficies grandes-superficies catalogo-cantabria:cantabria-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/cantabria/resto resto catalogo-cantabria:cantabria-resto:
```
Previsto en solo lectura: 102 municipios nuevos y 723 puntos (la base pasaría de 9.782 a 10.505 y los municipios de 1.492 a 1.594). Para verlos hay que activar Cantabria desde «Usuarios y provincias». Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (25/10/2026)
- **Carga verificada en solo lectura:** 102 municipios (102 códigos INE distintos) y 723 puntos, 723 `source_ref` `catalogo-cantabria:` distintos, todos activos, ninguno sin coordenadas, todos en su provincia, ningún código postal con formato distinto de 39xxx y ninguna coordenada fuera de Cantabria. Por categoría: Supermercado 302, Entidad oficial 124, Estaciones 104, Gimnasios 61, Centro de salud 47, Correos 30, Carrefour 18, Hospital 14, Bricolaje 9, Centro comercial 7, Decathlon 2, Leroy Merlin 2, MediaMarkt 1, El Corte Inglés 1, IKEA 1. Total de la base 9.782 -> 10.505 y municipios 1.492 -> 1.594.
- **Provincia:** Cantabria sigue desactivada (`is_active = false`); activarla desde «Usuarios y provincias» cuando el titular lo decida.
- **Pendiente:** 114 códigos postales y 25 calles; revisar los dudosos de «Calidad y límites». Sin asignar a usuarios hasta terminar España.
