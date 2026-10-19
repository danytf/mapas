# Carga N2: grandes superficies de Andalucía

Estado: **preparada y probada en local; NO cargada en producción. Pendiente de aprobación explícita del titular.** Lote: `supabase/seeds/grandes-superficies-andalucia/` (JSON de origen, `excepciones.csv` y un SQL por provincia). Definición: `scripts/catalogue/categorias/grandes-superficies.json`.

Fuente: `andalucia-latest.osm.pbf` (base de OpenStreetMap del 17/10/2026 20:20:51 UTC). Origen: OpenStreetMap (ODbL 1.0, © colaboradores de OpenStreetMap).

## Qué entra

258 puntos de seis marcas, cada uno en la categoría que ya existe en la aplicación:

| Categoría | Puntos |
|---|---|
| Carrefour (todos: hiper, Market, Express, City) | 187 |
| Decathlon | 20 |
| El Corte Inglés (incluye Hipercor) | 19 |
| Leroy Merlin | 16 |
| MediaMarkt | 11 |
| IKEA | 5 |

Por provincia: Málaga 88, Sevilla 55, Cádiz 54, Almería 22, Córdoba 16, Huelva 13, Jaén 10. Granada queda fuera (catálogo revisado a mano, `excluir_provincias`).

## Decisiones de extracción

- Nombre: «<marca> <municipio>» y, si hay calle, « – <calle>», como en Granada. No se exige nombre en OpenStreetMap, pero sí que la marca aparezca en nombre, operador o marca.
- Se excluyen puntos de recogida (click & collect), elementos en desuso o abandonados y, en El Corte Inglés, Supercor, Opencor, viajes, seguros, bricolaje, gourmet, outlet y aparcamientos.
- IKEA se busca como palabra completa: un comercio llamado «Mobikeay» quedó fuera.
- Dos puntos de la misma marca a menos de 150 m se consideran el mismo (nodo y edificio); a menos de 150 m de uno existente se descarta como ya existente.
- **Carrefour entra completo** por decisión del titular («métetelos todos»): 187 puntos, incluidos Market, Express y City, porque OpenStreetMap no distingue de forma fiable el tamaño. Van a la categoría Carrefour (ya existente). Se pueden archivar después los que no interesen. Los Carrefour de Granada quedan fuera (catálogo revisado a mano).

## Direcciones

- No se usó Nominatim (no se envía ningún dato a servicios externos). Se creó `completar_direcciones_local.py`, que toma la vía con nombre más cercana del propio fichero pbf (≤ 120 m): 139 de las 167 que no traían calle (el informe de `validar.py` las rotula «Nominatim»; en este lote el origen es `osm-local`). Es la vía más cercana, orientativa, no una dirección postal verificada.
- Quedan **28 puntos sin calle** y **197 sin código postal** (no se completa sin fuente fiable). El campo queda vacío; no se inventa. Completarlos con Nominatim requiere autorización del titular.

## Pruebas en local (PostgreSQL)

- Carga de los 7 trozos en la base `mapas_test`: 258 puntos; segunda carga sin cambios (idempotente). Hay dos pares de nombres repetidos (Carrefour Algeciras y Carrefour Roquetas de Mar – Carretera de Alicún), en ubicaciones distintas a más de 150 m.
- La generalización a varias categorías (columna `categoria` en `_carga`, comprobación de categorías por nombre) no altera las cadenas anteriores: la regeneración de estaciones y Correos debe seguir siendo idéntica byte a byte.

## Para cargar (cuando el titular lo apruebe)

```
bash scripts/catalogue/cargar.sh supabase/seeds/grandes-superficies-andalucia grandes-superficies catalogo-andalucia:grandes-superficies:
```

Pide la cadena de conexión sin eco y muestra el recuento antes y después (esperado: +258 en total y 258 con ese prefijo). Los puntos nacen con estado activo; revisar la muestra de `excepciones.csv` antes.

Nota: OpenStreetMap puede tener tiendas cerradas, trasladadas o duplicadas, y no indica el horario vigente.
