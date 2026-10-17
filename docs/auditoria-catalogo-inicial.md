# Auditoría del catálogo inicial de Granada

**Fecha:** 2026-10-17  
**Rama:** `architecture/fase-2-supabase-schema`  
**Estado:** bloqueado para importación hasta completar la revisión de cobertura.

## Hallazgos verificados en el código

| Fuente | Registros en el código | Observación |
|---|---:|---|
| `CENTERS` estático | 48 | Incluye centros y otros establecimientos definidos al inicio del archivo. |
| `PROV` | 35 | Los 35 registros son tipo `C` (centro de salud); no hay consultorios tipo `L`. |
| `SUPER` | 320 | Registros de supermercados. |
| `PRECOMPUTED` | 791 claves | Diccionario de coordenadas precalculadas; no equivale al número de establecimientos que exportará el catálogo. |

Las 48 entradas iniciales de `CENTERS` tienen una clave coincidente en `PRECOMPUTED`. En las 791 entradas de `PRECOMPUTED` inspeccionadas, las coordenadas tienen formato numérico válido y están dentro de los rangos geográficos permitidos. Esto **no** verifica que cada coordenada corresponda al lugar correcto.

No se encontraron duplicados exactos entre las 48 entradas iniciales de `CENTERS` al comparar nombre, municipio, tipo y dirección normalizados.

## Incidencia de cobertura

El comentario anterior de `index.html` afirmaba que el bloque `PROV` correspondía a un catálogo de 331 centros. El contenido real del array tiene solo 35 registros, todos de tipo centro de salud, sin consultorios. Se corrigió el comentario para no presentar ese bloque como un catálogo provincial completo.

La diferencia no debe interpretarse automáticamente como que faltan exactamente 296 centros: el número citado podría referirse a otro universo de datos. Hay que descargar y filtrar el directorio oficial antes de calcular faltantes.

## Fuente oficial para completar la revisión

El Servicio Andaluz de Salud publica el directorio de centros y permite descargarlo en CSV/XLS:

- [Información por centros — Servicio Andaluz de Salud](https://www.sspa.juntadeandalucia.es/servicioandaluzdesalud/el-sas/servicios-y-centros/informacion-por-centros)

La página oficial muestra centros de salud y consultorios de la provincia de Granada, entre ellos centros que no figuran en el bloque `PROV`. La descarga CSV de la página no se pudo recuperar durante esta revisión, por lo que no se ha generado una lista oficial de faltantes ni se han añadido registros inferidos.

## Resultado de la generación estática (2026-10-17)

Se reconstruyó el catálogo a partir de todas las fuentes estáticas de `index.html`: `CENTERS` (48), `PROV` (35), `OFICIALES` (207), `GYMS` (89), `BIGS` (92) y `SUPER` (320). Total: 791 puntos. No se ha leído `localStorage` ni `sessionStorage`, no se han incorporado puntos personalizados y no se han recalculado coordenadas mediante geocodificación.

| Control | Resultado |
|---|---:|
| Puntos antes y después de deduplicar | 791 |
| Duplicados eliminados | 0 |
| Pares de coordenadas ausentes | 0 |
| Coordenadas numéricamente inválidas | 0 |
| Referencias `source_ref` duplicadas | 0 |
| Coordenadas marcadas como aproximadas | 27 |
| Municipios distintos | 185 |
| Categorías definidas en la aplicación | 17 |
| Categorías con puntos estáticos en el catálogo | 13 |

Las 17 categorías de la aplicación son: Hospital, Centro de salud, Supermercado, Centro comercial, Entidad oficial, Gimnasios, IKEA, Leroy Merlin, Decathlon, Carrefour, Correos, El Corte Inglés, Bricolaje, MediaMarkt, Estaciones, Tiendas y Eventos. Las categorías sin puntos estáticos no se han rellenado con registros inventados.

El JSON `supabase/seeds/catalogo-inicial-granada.json` se ha actualizado y vuelto a leer desde GitHub. El SQL `supabase/seeds/import_catalogue_granada.sql` se ha regenerado para los 791 puntos y las 17 categorías. Valida el número de filas, referencias duplicadas y coordenadas antes de insertar, y omite conflictos sin sobrescribir establecimientos existentes.

**Limitación:** esta validación reproduce las fuentes estáticas del código; no ejecuta `window.exportarCatalogoInicial()` en un navegador real. Las coordenadas pasan controles numéricos y conservan su marca de aproximación, pero no se ha vuelto a comprobar su exactitud geográfica.

## Preparación de importación

Migraciones previas requeridas: `202610170007_unique_establishment_source_ref.sql` y `202610170008_seed_granada_province.sql`.

El SQL y las migraciones **todavía no se han ejecutado en Supabase**; no se ha importado ningún establecimiento y los registros de prueba siguen sin cambios.

## Criterios para desbloquear la importación

1. Obtener el CSV oficial y filtrar provincia = Granada.
2. Distinguir centros de salud, consultorios y otros tipos de centro; no mezclar universos.
3. Comparar el directorio oficial con `CENTERS` y `PROV` por nombre normalizado, municipio y tipo, revisando manualmente las coincidencias ambiguas.
4. Validar direcciones y coordenadas; no considerar exacta una coordenada solo porque esté dentro del rango válido.
5. Ejecutar el exportador en un entorno de navegador limpio y revisar recuentos, coordenadas ausentes/inválidas y colisiones de `source_ref`.
6. Importar primero en una fase de staging con clave idempotente y reporte de conflictos; no insertar directamente en las tablas maestras hasta aprobar el resultado.
