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
| `generar_municipios.py` | Genera el SQL de carga de municipios oficiales (idempotente, no cambia nombres ni borra). |

Diseño completo en `docs/DISENO_CARGA_NACIONAL.md`.
