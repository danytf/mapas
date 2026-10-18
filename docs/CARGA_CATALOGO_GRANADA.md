# Carga de categorías del catálogo de Granada

Procedimiento para completar el catálogo de Granada categoría a categoría, sin inventar establecimientos ni coordenadas. Cada carga lleva su origen, su criterio de selección y su fichero.

## Reglas

1. **Origen declarado.** Cada punto sale de una fuente identificable (OpenStreetMap, lista del titular, etc.) y lo guarda en `location_source` (por ejemplo `openstreetmap:way/311295370`). Nunca se inventan nombres, direcciones ni coordenadas.
2. **Revisión previa.** La lista de candidatos se enseña al titular antes de cargar nada; se carga solo lo que él aprueba.
3. **Idempotente y sin sobrescribir.** Cada punto lleva un `source_ref` único (`catalogo-granada:<categoria>:<nombre>:<municipio>:<calle>`); si ya existe, la carga no hace nada.
4. **Precisión `address`**, igual que el resto del catálogo: las coordenadas se verifican después desde la aplicación («Corregir ubicación»), que deja el historial.
5. **Carga en producción con aprobación del titular**, tras probarla en local (cargar, repetir la carga y comprobar que no duplica), y con verificación posterior (recuento y auditoría).
6. Un fichero JSON con el origen y un script SQL transaccional por carga en `supabase/seeds/`.

## Atribución y licencia (OpenStreetMap)

Los datos de OpenStreetMap están bajo la licencia ODbL 1.0, © colaboradores de OpenStreetMap (https://www.openstreetmap.org/copyright). Cada fichero de carga que use esa fuente lo indica y conserva el identificador del elemento. Si se llegara a cargar un volumen grande de datos derivados de OpenStreetMap, conviene revisar con quien lleve los asuntos legales de Wesser las obligaciones de atribución y de compartir igual de la licencia.

## Registro de cargas

| Fecha | Categoría | Puntos | Origen y criterio | Ficheros |
|---|---|---|---|---|
| 19/10/2026 | Bricolaje | 1 (Brico Dépôt Pulianas) | OpenStreetMap, consulta Overpass del 19/10/2026 (base del 18/10/2026 23:32 UTC). Alcance elegido por el titular: grandes cadenas distintas de Leroy Merlin. No aparecen Bricomart, Bauhaus, AKI ni Bricor; no se ha verificado que no existan | `supabase/seeds/bricolaje-granada.json`, `supabase/seeds/import_bricolaje_granada.sql` |

| 19/10/2026 | Estaciones | 14 (7 autobús, 7 tren) | OpenStreetMap, consulta Overpass del 19/10/2026 (base 18/10/2026 23:41 UTC). Alcance elegido por el titular: tren y autobús; excluidos el Metro de Granada (26 paradas), los remontes de Sierra Nevada, la estación marítima de Motril y 2 estaciones en desuso de Gorafe. Municipio y calle con Nominatim (inverso). Iznalloz, Benalúa y Huéneja-Dólar se cargan con precisión `approximate` (por revisar) porque no se ha verificado que tengan servicio de viajeros | `supabase/seeds/estaciones-granada.json`, `supabase/seeds/import_estaciones_granada.sql` |

Categorías activas aún sin puntos en Granada: Eventos y Tiendas.

**«Por revisar».** La aplicación marca un punto como «por revisar» cuando su `location_precision` es `approximate`. Se usa también para señalar datos de origen dudosos (no solo coordenadas); quien lo revise lo confirma desde la ficha («Marcar como revisado») o lo corrige.

## Cómo repetirlo para otra categoría

1. Acordar con el titular el alcance de la categoría y la fuente.
2. Obtener los candidatos (por ejemplo una consulta a Overpass) y enseñarlos con nombre, dirección, municipio y coordenadas; comprobar que no existen ya en la base (nombre y cercanía).
3. Escribir el JSON de origen y el SQL de carga a partir de `import_bricolaje_granada.sql`.
4. Probar en local: cargar, cargar de nuevo y comprobar que no duplica y que la auditoría registra el alta.
5. Pedir aprobación para producción, cargar, y verificar recuento y filas nuevas.
