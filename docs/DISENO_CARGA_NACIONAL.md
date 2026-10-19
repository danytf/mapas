# Diseño de la carga nacional de puntos

Estado: **propuesta para aprobación del titular** (19/10/2026). Todavía no hay código. Decisiones ya tomadas por el titular: fuente = descarga completa de OpenStreetMap de España; revisión = resumen y excepciones; primera ola = datos de referencia más una categoría piloto.

Objetivo: incorporar miles de puntos de toda España de forma rápida, repetible y trazable, sin inventar datos y sin pasar volúmenes grandes por el chat.

## 1. Principios (no cambian)

- Cada punto lleva su origen y su identificador (`location_source` = `openstreetmap:<tipo>/<id>`) y una referencia única (`source_ref`).
- Nada se inventa: un campo que la fuente no trae queda vacío.
- Cargas idempotentes: repetir un lote no duplica ni sobrescribe.
- Escritura en producción solo con aprobación explícita del titular, tras revisar el resumen del lote y probar la carga en local.
- Licencia: los datos de OpenStreetMap son ODbL 1.0 (© colaboradores de OpenStreetMap); se conserva la atribución y el identificador de cada elemento.

## 2. Piezas

1. **Datos de referencia (una vez).** Las 52 provincias y los ~8.000 municipios con su código oficial (el INE aparece en OpenStreetMap como `ine:municipio` en las relaciones administrativas) y sus límites. Se extraen del mismo fichero de OpenStreetMap, con una revisión de cifras contra los totales oficiales conocidos (52 provincias, municipios por provincia). Se cargan como migración de datos de referencia, con prueba. Provincias nuevas entran **inactivas** (`is_active = false`) hasta decidir activarlas desde el panel de administración.
2. **Definición de categoría** (`scripts/catalogue/categorias/<categoria>.json`): qué etiquetas u marcas de OpenStreetMap entran, qué se excluye, nombre del punto, subtipo y reglas de revisión. Una definición sirve para toda España.
3. **Extracción** (`scripts/catalogue/extraer.py`): lee el fichero de OpenStreetMap, aplica la definición, calcula el municipio y la provincia de cada punto por geometría (punto dentro del polígono municipal; sin geocodificar uno a uno), normaliza nombre y dirección y genera el `source_ref`.
4. **Control de calidad** (`scripts/catalogue/validar.py`): duplicados dentro del lote y contra la base (mismo `source_ref`; mismo nombre a menos de ~50 m), coordenadas fuera de España, sin municipio, nombres vacíos o raros, direcciones vacías. Reglas automáticas: pasa limpio (`address`), pasa pero dudoso (`approximate`, «por revisar») o se descarta con motivo.
5. **Informe del lote** (`informe.md` + `excepciones.csv`): cifras por provincia y categoría, muestra aleatoria y la lista de excepciones. Es lo que revisa el titular.
6. **Carga en bloque** (`scripts/catalogue/cargar.sh`): genera SQL en trozos por provincia y lo aplica con `psql` desde el equipo del titular (la cadena de conexión se pide sin eco y no se guarda, como en la copia de seguridad), en una transacción por trozo, con recuento antes y después. Los datos no pasan por el chat.
7. **Trazabilidad.** Un registro por lote en `docs/CARGA_CATALOGO_GRANADA.md` (se renombrará a `CARGA_CATALOGO.md`) y filas en `import_batches` / `import_records` (tablas que ya existen y están vacías) si se decide usarlas como área de preparación.

## 3. Herramientas necesarias en el equipo del titular

- Python 3.14 (instalado) y estas bibliotecas de Python: `osmium` (lector del fichero de OpenStreetMap) y `shapely` (geometría). Se instalan con `pip` en un entorno virtual dentro de la carpeta de trabajo, fuera del repositorio. **Requiere aprobación**: instala software de terceros.
- Descarga de `spain-latest.osm.pbf` desde Geofabrik (del orden de 1 GB; tamaño a confirmar) en una carpeta fuera del repositorio. **Requiere aprobación**: es una descarga de un fichero grande.
- `psql` (instalado). Espacio en disco: 79 GB libres; el trabajo necesita unos pocos GB.

## 4. Plan por fases (un PR por fase)

1. **Fase N0, referencia.** Extraer provincias y municipios con límites; comprobar cifras; migración de datos de referencia (provincias inactivas) con prueba en local y aplicación en producción con aprobación.
2. **Fase N1, categoría piloto.** Una categoría para toda España (propuesta: Estaciones de tren y autobús, la ya conocida en Granada, para poder comparar con los 14 puntos cargados a mano). Pasar la cadena completa y medir tiempos.
3. **Fase N2, ampliación.** Añadir categorías una a una (Supermercado, Correos, Hospital, Centro de salud, cadenas…) reutilizando la cadena; cada una con su definición, informe y aprobación.
4. **Fase N3, fuentes oficiales.** Para categorías donde OpenStreetMap no es la mejor fuente (hospitales, centros de salud, entidades oficiales) estudiar catálogos oficiales abiertos con su licencia.

## 5. Riesgos y controles

| Riesgo | Control |
|---|---|
| Datos incompletos o desactualizados en OpenStreetMap | Se declara en cada informe; lo dudoso entra «por revisar»; la app permite corregir ubicaciones con historial |
| Duplicados a gran escala | Regla de nombre y distancia dentro del lote y contra la base; informe de posibles duplicados |
| Municipio mal asignado en límites | Comprobación de cifras por provincia y muestra aleatoria en el informe |
| Carga masiva que falle a medias | Transacción por trozo, idempotencia, recuento antes y después, parada ante el primer error |
| Rendimiento con decenas de miles de puntos | Ya medido con 50.000 puntos (H-26, H-27); se vuelve a medir tras la primera carga grande |
| Licencia ODbL | Atribución y identificadores conservados; revisión legal si el volumen derivado crece mucho |
| Software de terceros (`osmium`, `shapely`) | Solo en un entorno aislado del equipo, no entra al repositorio ni a la aplicación |
| Cuota de datos del plan gratuito (500 MB) | A razón de ~1 KB por punto con índices, 100.000 puntos ocupan ~100 MB; se vigila el tamaño tras cada carga (H-24) |

## 6. Decisiones pendientes del titular

1. Aprobar la instalación de `osmium` y `shapely` en un entorno virtual.
2. Aprobar la descarga de `spain-latest.osm.pbf` (Geofabrik) y dónde guardarla.
3. Elegir la categoría piloto (propuesta: Estaciones).
4. Confirmar que las provincias nuevas entran inactivas hasta activarlas desde el panel.
