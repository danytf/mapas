# Carga N2 de Ceuta (cargada)

Estado: **cargada en producción el 25/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Primera ciudad autónoma con el mismo procedimiento que las regiones anteriores (ver `docs/CARGA_N2_CANTABRIA.md`).

## Origen
- Fichero: `ceuta-latest.osm.pbf` (Geofabrik, edición del 24/10/2026 20:20 UTC, 641.000 bytes, MD5 `c2ff22fad58453036829ddbf8f83d7d0` verificado contra el `.md5` de Geofabrik), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/ceuta-*.json` (derivadas de las de Cantabria, `solo_provincias` 51 y `region: ceuta`). En `generar_lote.py` se añadió el código 51.

## Municipio (N0) — diferencia con las demás regiones
- El fichero de Ceuta **no trae ninguna área administrativa** (ni nivel 8 con `ine:municipio` ni otro nivel), así que `referencia.py` no encuentra municipios. Ceuta es un único municipio con código INE **51001**. Como el fichero de Geofabrik está recortado a su territorio, se construyó el `ref.json` a mano con ese código y, como geometría, el **polígono de recorte público de Geofabrik** (`ceuta.poly`, 8 vértices, no es el límite municipal exacto). Todo lo que contiene el fichero cae dentro. Está fuera del repositorio, junto al fichero.
- `supabase/seeds/ceuta/municipios/import_municipios_51.sql`: 1 municipio («Ceuta», INE 51001). Hoy la provincia 51 tiene 0 municipios y 0 puntos y **está activa** (`is_active = true`, comprobado en solo lectura el 25/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (21)
| Lote | Puntos |
|---|---|
| Correos | 0 |
| Estaciones | 0 |
| Grandes superficies (Carrefour 3, Decathlon 1) | 4 |
| Resto (Supermercado 6, Entidad oficial 6, Centro comercial 2, Centro de salud 2, Hospital 1) | 17 |
| **Total** | **21** |

Un SQL por lote en `supabase/seeds/ceuta/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (5 filas en total). `source_ref` con el prefijo `catalogo-ceuta:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **0 puntos sin calle y 11 sin código postal**. Los códigos presentes son 51001, 51002 y 51003.
- **Correos: 0.** La única oficina postal de OpenStreetMap (`node/9156016046`) no tiene nombre ni operador, así que la regla de Correos (que exige «Correos» o «Correus» en el nombre, el operador o la marca) la deja fuera. No se inventa. Si el titular quiere Correos de Ceuta, hay que decidirlo aparte.
- **Estaciones: 0.** No hay estaciones de tren ni de autobús en el fichero.
- Bricolaje, Gimnasios, IKEA, Leroy Merlin, MediaMarkt y El Corte Inglés: ningún elemento de OpenStreetMap cumple las reglas (el «El Corte Inglés Outlet» se excluye por la regla de «outlet»).
- Excepciones: un Carrefour repetido por la regla de Resto (entra por Grandes superficies), el nodo de Supeco y el área de Decathlon repetidos, «Juzgados» (nombre genérico) y el «El Corte Inglés Outlet».
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/ceuta/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/ceuta/grandes-superficies grandes-superficies catalogo-ceuta:ceuta-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/ceuta/resto resto catalogo-ceuta:ceuta-resto:
```
Previsto en solo lectura: 1 municipio nuevo y 21 puntos (la base pasaría de 10.505 a 10.526 y los municipios de 1.594 a 1.595). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (25/10/2026)
- **Carga verificada en solo lectura:** 1 municipio (Ceuta) y 21 puntos, 21 `source_ref` `catalogo-ceuta:` distintos, todos activos, ninguno sin coordenadas, ningún código postal con formato distinto de 51xxx. Por categoría: Supermercado 6, Entidad oficial 6, Carrefour 3, Centro de salud 2, Centro comercial 2, Decathlon 1, Hospital 1. Total de la base 10.505 -> 10.526 y municipios 1.594 -> 1.595.
- **Provincia:** Ceuta (51) ya estaba activa (`is_active = true`).
- **Pendiente:** 11 códigos postales (0 calles). Sin asignar a usuarios hasta terminar España.
