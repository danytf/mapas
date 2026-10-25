# Carga N2 de Melilla (cargada)

Estado: **cargada en producción el 25/10/2026** y verificada en solo lectura (ver «Cierre»). Segunda ciudad autónoma, con el mismo procedimiento que Ceuta (`docs/CARGA_N2_CEUTA.md`) y las regiones anteriores.

## Origen
- Fichero: `melilla-latest.osm.pbf` (Geofabrik, edición del 24/10/2026 20:20 UTC, 800.319 bytes, MD5 `6c7f9bb3fce4ebd2e280eafb4367154d` verificado contra el `.md5` de Geofabrik), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/melilla-*.json` (derivadas de las de Ceuta, `solo_provincias` 52 y `region: melilla`). En `generar_lote.py` se añadió el código 52.

## Municipio (N0)
- A diferencia de Ceuta, el fichero **sí trae** el límite de Melilla con su código INE: `referencia.py` encuentra 1 municipio (INE 52001). `supabase/seeds/melilla/municipios/import_municipios_52.sql`: 1 municipio. Hoy la provincia 52 tiene 0 municipios y 0 puntos y **está activa** (`is_active = true`, comprobado en solo lectura el 25/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (22)
| Lote | Puntos |
|---|---|
| Correos | 1 |
| Estaciones | 0 |
| Grandes superficies (Carrefour 1, Decathlon 1, MediaMarkt 1) | 3 |
| Resto (Supermercado 9, Hospital 3, Centro de salud 3, Centro comercial 2, Gimnasios 1; Entidad oficial 0) | 18 |
| **Total** | **22** |

Un SQL por lote en `supabase/seeds/melilla/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (3 filas en total). `source_ref` con el prefijo `catalogo-melilla:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **0 puntos sin calle y 14 sin código postal**. Los códigos presentes son 52001, 52005 y 52006.
- **Estaciones: 0** (no hay estaciones de tren ni de autobús en el fichero). **Entidad oficial: 0**: ningún elemento oficial de OpenStreetMap cumple las reglas de nombre (ayuntamiento, juzgado, AEAT, Seguridad Social…), p. ej. el gobierno de la ciudad autónoma no se llama «Ayuntamiento». No se inventa.
- Dudoso en Hospital: **«Acceso Hospital Melilla – Calle del Ramal del Docker»** parece un acceso, no un hospital, y conviene archivarlo tras la carga. «Hospital Comarcal» (Calle Vista Hermosa) y «Hospital Universitario de Melilla» (Calle Monumental) son elementos distintos en OpenStreetMap (a unos 700 m), pero podrían ser el mismo hospital con su nombre antiguo y el actual: no está verificado, revisar si ambos siguen en servicio.
- Excepciones: «Urgencias» (excluido por nombre), un área sin nombre y un duplicado de «Parque Murias» (se queda el nodo).
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/melilla/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/melilla/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/melilla/grandes-superficies grandes-superficies catalogo-melilla:melilla-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/melilla/resto resto catalogo-melilla:melilla-resto:
```
Previsto en solo lectura: 1 municipio nuevo y 22 puntos (la base pasaría de 10.528 a 10.550, antes de cargar Cataluña, y los municipios de 1.595 a 1.596). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (25/10/2026)
- **Carga verificada en solo lectura:** 1 municipio (Melilla) y 22 puntos, 22 `source_ref` `catalogo-melilla:` distintos, todos activos, ninguno sin coordenadas y ningún código postal con formato distinto de 52xxx. Por categoría: Supermercado 9, Centro de salud 3, Hospital 3, Centro comercial 2, Carrefour 1, MediaMarkt 1, Gimnasios 1, Correos 1, Decathlon 1. Total de la base 10.528 -> 10.550 y municipios 1.595 -> 1.596.
- **Provincia:** Melilla (52) ya estaba activa.
- **Códigos postales: no completados.** Se consultó Nominatim inverso para los 14 puntos sin código y devolvió **52001 para todos**, el código genérico de la ciudad, también para puntos que el propio fichero sitúa en 52005 o 52006. No es informativo y no se escribe. Quedan **14 sin código postal y 0 sin calle**; hacen falta los códigos reales (los facilita el titular o una fuente postal fiable). Sin asignar a usuarios hasta terminar España.
