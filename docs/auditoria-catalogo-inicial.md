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

## Resultado de importación en Supabase

**Importación ejecutada y verificada el 17 de octubre de 2026** en el proyecto de desarrollo `mapas-dev` (`wwoczmihhupofwmlmgga`).

| Verificación posterior | Resultado |
|---|---:|
| Filas del catálogo estático importadas | 791 |
| Referencias `source_ref` únicas | 791 |
| Coordenadas ausentes o fuera de rango | 0 |
| Puntos con precisión `approximate` | 27 |
| Municipios de Granada registrados | 185 |
| Establecimientos totales en la tabla (incluye 2 pruebas) | 793 |

Se aplicaron las migraciones de índice único parcial de `source_ref` y de la provincia de Granada. El SQL de importación se ejecutó dentro de una transacción y se añadió una comprobación final que provoca rollback si no aparecen las 791 referencias esperadas.

Los dos registros de prueba permanecen intactos: `TEST RLS - Granada` y `TEST RLS - Málaga`. No se importaron datos de `localStorage`, `sessionStorage` ni copias de pruebas del navegador. La importación conserva las coordenadas estáticas existentes; no las recalcula.

La tabla `categories` tenía 16 categorías antes de la carga. Se registraron las categorías del mapa que faltaban sin eliminar ni renombrar las preexistentes; por eso la tabla contiene ahora 28 categorías en total. Las 13 categorías que tienen puntos estáticos suman las 791 filas importadas. Las otras cuatro categorías del mapa no se rellenaron con establecimientos inventados.

## Limitaciones pendientes

La validación comprueba la integridad numérica y la carga de datos, **no certifica la exactitud geográfica real** de cada coordenada. El catálogo no se volvió a generar ejecutando `window.exportarCatalogoInicial()` en un navegador real; se reconstruyó a partir de las fuentes estáticas del repositorio.

Trabajo de mejora recomendado, separado de la importación ya completada:
1. Contrastar las ubicaciones con fuentes oficiales y revisar manualmente los puntos marcados como aproximados.
2. Ejecutar el exportador en un entorno de navegador limpio y comparar su resultado con el JSON versionado.
3. Revisar por separado los nombres de categorías del mapa y la taxonomía preexistente de Supabase antes de conectar el frontend.
