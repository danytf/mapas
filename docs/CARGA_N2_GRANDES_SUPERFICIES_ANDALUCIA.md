# Carga N2: grandes superficies de Andalucía

Estado: **preparada y probada en local; NO cargada en producción. Pendiente de aprobación explícita del titular.** Lote: `supabase/seeds/grandes-superficies-andalucia/` (JSON de origen, `excepciones.csv` y un SQL por provincia). Definición: `scripts/catalogue/categorias/grandes-superficies.json`.

Fuente: `andalucia-latest.osm.pbf` (base de OpenStreetMap del 17/10/2026 20:20:51 UTC). Origen: OpenStreetMap (ODbL 1.0, © colaboradores de OpenStreetMap).

## Qué entra

71 puntos de cinco marcas, cada uno en la categoría que ya existe en la aplicación:

| Categoría | Puntos |
|---|---|
| Decathlon | 20 |
| El Corte Inglés (incluye Hipercor) | 19 |
| Leroy Merlin | 16 |
| MediaMarkt | 11 |
| IKEA | 5 |

Por provincia: Málaga 19, Sevilla 16, Cádiz 13, Almería 8, Córdoba 6, Jaén 5, Huelva 4. Granada queda fuera (catálogo revisado a mano, `excluir_provincias`).

## Decisiones de extracción

- Nombre: «<marca> <municipio>» y, si hay calle, « – <calle>», como en Granada. No se exige nombre en OpenStreetMap, pero sí que la marca aparezca en nombre, operador o marca.
- Se excluyen puntos de recogida (click & collect), elementos en desuso o abandonados y, en El Corte Inglés, Supercor, Opencor, viajes, seguros, bricolaje, gourmet, outlet y aparcamientos.
- IKEA se busca como palabra completa: un comercio llamado «Mobikeay» quedó fuera.
- Dos puntos de la misma marca a menos de 150 m se consideran el mismo (nodo y edificio); a menos de 150 m de uno existente se descarta como ya existente.
- **Carrefour queda fuera**: OpenStreetMap no distingue de forma fiable el hipermercado del supermercado de tamaño medio y en la aplicación los Carrefour normales están como Supermercado. **Decisión pendiente del titular** (si quiere hipermercados, hace falta otro criterio, p. ej. lista manual).

## Direcciones

- No se usó Nominatim (no se envía ningún dato a servicios externos). Se creó `completar_direcciones_local.py`, que toma la vía con nombre más cercana del propio fichero pbf (≤ 120 m): 36 de las 50 que no traían calle. Es la vía más cercana, orientativa, no una dirección postal verificada.
- Quedan **14 puntos sin calle** y **58 sin código postal** (no se completa sin fuente fiable). El campo queda vacío; no se inventa. Completarlos con Nominatim requiere autorización del titular.

## Pruebas en local (PostgreSQL)

- Carga de los 7 trozos en la base `mapas_test`: 71 puntos; segunda carga sin cambios (idempotente); 0 incompletos.
- La generalización a varias categorías (columna `categoria` en `_carga`, comprobación de categorías por nombre) no altera las cadenas anteriores: la regeneración de estaciones y Correos debe seguir siendo idéntica byte a byte.

## Para cargar (cuando el titular lo apruebe)

```
bash scripts/catalogue/cargar.sh supabase/seeds/grandes-superficies-andalucia grandes-superficies catalogo-andalucia:grandes-superficies:
```

Pide la cadena de conexión sin eco y muestra el recuento antes y después (esperado: +71 en total y 71 con ese prefijo). Los puntos nacen con estado activo; revisar la muestra de `excepciones.csv` antes.

Nota: OpenStreetMap puede tener tiendas cerradas, trasladadas o duplicadas, y no indica el horario vigente.
