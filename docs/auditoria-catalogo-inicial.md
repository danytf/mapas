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

Se ha reproducido la lógica del exportador usando únicamente las declaraciones estáticas de `CENTERS`, `PROV`, `SUPER` y `PRECOMPUTED` de `index.html`. No se ha leído `localStorage`, no se han incorporado puntos personalizados y no se ha reemplazado ninguna coordenada por una geocodificación nueva.

| Control | Resultado |
|---|---:|
| Centros/establecimientos estáticos tras combinar `CENTERS` y `PROV` | 83 |
| Supermercados estáticos | 320 |
| Registros antes de deduplicar | 403 |
| Registros después de deduplicar | 403 |
| Duplicados eliminados | 0 |
| Coordenadas ausentes | 0 |
| Coordenadas numéricamente inválidas | 0 |
| Referencias `source_ref` duplicadas | 0 |
| Coordenadas marcadas como aproximadas | 19 |
| Municipios distintos | 76 |

El JSON se guardó en `supabase/seeds/catalogo-inicial-granada.json` y se volvió a leer desde GitHub para verificar que el contenido persistido coincide con el generado. La validación independiente del JSON confirmó 403 filas, cero campos obligatorios vacíos, cero pares de coordenadas ausentes o inválidos y cero referencias duplicadas.

**Limitación:** esto es una reproducción determinista desde el código estático, no una ejecución de `window.exportarCatalogoInicial()` dentro de un navegador real. Las coordenadas están validadas numéricamente y se conserva la marca de aproximación, pero no se ha vuelto a verificar su exactitud geográfica.

## Preparación de importación

Se generó `supabase/seeds/import_catalogue_granada.sql` con carga idempotente. El SQL:
- comprueba que existen la provincia Granada y el índice único de `source_ref`;
- prepara 5 categorías y 76 municipios a partir de los nombres presentes en el catálogo;
- inserta los 403 registros estáticos, resolviendo las claves foráneas;
- ignora conflictos de inserción para no sobrescribir establecimientos ya existentes ni sus coordenadas.

Migraciones previas requeridas: `202610170007_unique_establishment_source_ref.sql` y `202610170008_seed_granada_province.sql`.

El SQL y las migraciones **todavía no se han ejecutado en Supabase**; no se ha importado ningún establecimiento y los registros de prueba siguen sin cambios.

## Criterios para desbloquear la importación

1. Obtener el CSV oficial y filtrar provincia = Granada.
2. Distinguir centros de salud, consultorios y otros tipos de centro; no mezclar universos.
3. Comparar el directorio oficial con `CENTERS` y `PROV` por nombre normalizado, municipio y tipo, revisando manualmente las coincidencias ambiguas.
4. Validar direcciones y coordenadas; no considerar exacta una coordenada solo porque esté dentro del rango válido.
5. Ejecutar el exportador en un entorno de navegador limpio y revisar recuentos, coordenadas ausentes/inválidas y colisiones de `source_ref`.
6. Importar primero en una fase de staging con clave idempotente y reporte de conflictos; no insertar directamente en las tablas maestras hasta aprobar el resultado.
