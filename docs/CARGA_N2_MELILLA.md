# Carga N2 de Melilla (preparada)

Estado: **preparada el 25/10/2026, pendiente de carga en producción**. Segunda ciudad autónoma, con el mismo procedimiento que Ceuta (`docs/CARGA_N2_CEUTA.md`) y las regiones anteriores.

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
- Dudoso en Hospital: **«Acceso Hospital Melilla – Calle del Ramal del Docker»** parece un acceso, no un hospital, y conviene archivarlo tras la carga. «Hospital Comarcal» (Calle Vista Hermosa) y «Hospital Universitario de Melilla» (Calle Monumental) son edificios distintos en OpenStreetMap, pero el segundo sustituyó al primero: revisar si ambos siguen en servicio.
- Excepciones: «Urgencias» (excluido por nombre), un área sin nombre y un duplicado de «Parque Murias» (se queda el nodo).
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo cargar (con aprobación)
Desde la raíz del repositorio, en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/melilla/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/melilla/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/melilla/grandes-superficies grandes-superficies catalogo-melilla:melilla-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/melilla/resto resto catalogo-melilla:melilla-resto:
```
Después, en solo lectura: 1 municipio nuevo y 22 puntos (la base pasaría de 10.528 a 10.550, antes de cargar Cataluña, y los municipios de 1.595 a 1.596). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).
