# Herramientas de carga de catálogo

Código que genera los ficheros de carga a partir de OpenStreetMap. No contiene datos: los ficheros de OpenStreetMap y las salidas intermedias viven fuera del repositorio (carpeta `~/osm-trabajo`).

Entorno (aprobado por el titular el 19/10/2026): `python -m venv ~/osm-trabajo/venv` y `pip install osmium shapely` (osmium 4.3.2, shapely 2.2.0 con Python 3.14). Fichero de Andalucía: `https://download.geofabrik.de/europe/spain/andalucia-latest.osm.pbf` (195.327.579 bytes, MD5 `fc5f4003e4840d4f91e702005cc25e40` el 19/10/2026).

| Script | Qué hace |
|---|---|
| `explorar_limites.py` | Cuenta los límites administrativos por nivel (exploración, solo lectura). |
| `referencia.py` | Extrae municipios con código INE y su geometría; compara con los nombres de una provincia de la base. |
| `buscar.py` | Busca puntos por etiqueta y nombre dentro de una provincia y les asigna el municipio oficial (INE) por geometría. |
| `enriquecer.py` | Completa calle y código postal con Nominatim inverso (1 petición por segundo, solo lo que falta). |
| `generar_carga.py` | Genera el JSON de origen y el SQL de carga de una categoría desde candidatos revisados. |
| `extraer.py` | Aplica una definición de categoría (`categorias/<categoria>.json`) a todo el fichero y asigna municipio/provincia (INE) por geometría. |
| `validar.py` | Control de calidad: descarta sin nombre, ya existentes y duplicados; marca «por revisar»; genera `informe.md` y `excepciones.csv`. |
| `generar_lote.py` | Genera el JSON de origen y un SQL por provincia (idempotente, transaccional) desde `validados.json`. |
| `cargar.sh` | Aplica los SQL de un directorio con `psql` (conexión pedida sin eco), con recuento antes y después (tercer argumento opcional: prefijo de `source_ref` para lotes de varias categorías). |
| `completar_direcciones_local.py` | Completa calle (punto con dirección o vía más cercana) y código postal (punto con dirección más cercano, de la provincia) con el propio pbf, sin servicios externos. |
| `inferir_cp_municipio.py` | Asigna el código postal a los puntos que no lo tienen en municipios con un único código observado en el lote (origen anotado). |
| `generar_municipios.py` | Genera el SQL de carga de municipios oficiales (idempotente, no cambia nombres ni borra). |

Diseño completo en `docs/DISENO_CARGA_NACIONAL.md`.

Cadena de una categoría para Andalucía (N1): `extraer.py` → `validar.py` → `generar_lote.py` → prueba local → `cargar.sh` con aprobación. Ejemplo y resultados en `docs/CARGA_N1_ESTACIONES_ANDALUCIA.md`.

Una definición puede cubrir varias categorías (sin `categoria` raíz; cada regla lleva la suya y `nombre_por_categoria`): ver `categorias/grandes-superficies.json` y `docs/CARGA_N2_GRANDES_SUPERFICIES_ANDALUCIA.md`.
