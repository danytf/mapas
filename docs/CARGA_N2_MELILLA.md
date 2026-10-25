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
- **Códigos postales (25/10/2026):** Nominatim inverso devolvió **52001 para los 14 puntos sin código**, el código genérico de la ciudad, también para puntos que el propio fichero sitúa en 52005 o 52006; no es informativo y no se usa. Se recalcularon con las direcciones del propio fichero de OpenStreetMap (`completar_direcciones_local.py --max-cp-m 700`): salen códigos distintos por zona (52003, 52005, 52006). Criterio estricto: solo se aceptan las direcciones con código a **300 m o menos**. Se escribieron **9 códigos** con `admin_set_postal_codes` desde la sesión de administrador (9 actualizados, 0 omitidos, 9 entradas en `audit_log`): 52003 (Suma de General Pintos, La Fuente, Al Día y el Centro de Salud Zona Norte), 52005 (Carrefour) y 52006 (Suma de Carlos V, Acceso Hospital, Hospital Universitario y CC Parque). Son el código de la dirección más cercana, orientativo, no una verificación postal.
- **Los 5 restantes los facilitó el titular (25/10/2026)** y se escribieron con `admin_set_postal_codes` desde la sesión de administrador (5 actualizados, 0 omitidos, auditados): Decathlon 52002, MediaMarkt 52006, Parque Murias 52006, Lidl 52005 y Family Cash 52006. Mi estimación por cercanía para Decathlon era 52006: el dato del titular lo corrige, lo que confirma que los códigos de más de 300 m no eran fiables.
- **Estado final:** 22 puntos, **0 sin código postal y 0 sin calle**. Pendiente: archivar «Acceso Hospital Melilla» y revisar si el Hospital Comarcal y el Universitario son el mismo. Sin asignar a usuarios hasta terminar España.
