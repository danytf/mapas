# Carga N2 de tiendas de mascotas (preparada, pendiente de cargar)

Estado: **preparada el 26/10/2026, sin cargar**. Lotes de SQL generados, revisados y comprobados en solo lectura (ver «Comprobaciones»). La carga la ejecuta el titular con `cargar.sh` tras fusionar el PR de los seeds.

## Alcance
- Decisión del titular (26/10/2026): carga nacional de **seis cadenas** de tiendas de mascotas, en la categoría **Tiendas** (subtipo «Mascotas»), el mismo criterio que en Granada («cadenas tipo Tiendanimal»): Kiwoko, Tiendanimal, Miscota, Guaw, Mundo Animal y Cash Mascota. Se descartaron las otras dos opciones: todas las tiendas con nombre (unas 1.040, muchos comercios sueltos) y las cadenas más las marcas con 3 o más locales.
- Origen: ficheros regionales de Geofabrik ya usados en las cargas N2 (`shop=pet` cuyo nombre, marca u operador es una de las seis cadenas; se excluyen elementos en desuso o abandonados y los de recogida, en línea, veterinarios o peluquerías). OpenStreetMap, licencia ODbL.
- **Cobertura incompleta:** OpenStreetMap recoge solo una parte de las tiendas reales de cada cadena (en Granada ya constaba solo 1 Tiendanimal). El lote es una base, no el censo completo. No se ha contrastado con la lista oficial de tiendas de cada cadena.
- Granada queda fuera: su catálogo está revisado a mano y ya tiene 7 tiendas de mascotas (la extracción las encontró y se descartaron por provincia).
- Definiciones: `scripts/catalogue/categorias/<comunidad>-tiendas.json` (17 comunidades, con `solo_provincias`; Ceuta y Melilla no tienen). Origen y SQL en `supabase/seeds/tiendas/` (16 JSON de origen, 16 `excepciones-<comunidad>.csv` y un SQL por comunidad y provincia, transaccionales e idempotentes). `source_ref` con el prefijo `catalogo-<comunidad>:<comunidad>-tiendas:`.

## Cifras (170 puntos)
- **Por cadena:** Kiwoko 82, Tiendanimal 54, Miscota 17, Guaw 13 y Mundo Animal 4. Cash Mascota no suma: las 3 de OpenStreetMap están en Granada, ya cargadas.
- **Por comunidad:** Madrid 32, Valencia 30, Cataluña 27, Andalucía (sin Granada) 18, Castilla y León 12, Galicia 9, Murcia 9, País Vasco 7, Castilla-La Mancha 5, Asturias 4, Baleares 4, Canarias 4, Aragón 3, Cantabria 3, Extremadura 2 y Navarra 1. La Rioja no tiene ninguna.
- **Por provincia:** Madrid 32, Barcelona 20, Valencia 17, Alicante 11, Murcia 9, Sevilla 5, A Coruña 5, Bizkaia 5, Asturias 4, Illes Balears 4, Girona 4, Almería 3, Jaén 3, Málaga 3, Zaragoza 3, Santa Cruz de Tenerife 3, Cantabria 3, Albacete 3, Salamanca 3, Tarragona 3, Pontevedra 3, Córdoba 2, Burgos 2, Valladolid 2, León 2, Badajoz 2, Araba/Álava 2, Castellón 2, y una en Huelva, Cádiz, Las Palmas, Ciudad Real, Toledo, Segovia, Palencia, Soria, Lugo y Navarra.
- Todos con ubicación «address» (coordenadas de OpenStreetMap con dirección), ninguno por revisar.

## Calidad y límites
- **20 sin calle y 47 sin código postal** (Madrid 4 y 8, Murcia 4 y 6, Andalucía 3 y 6, Valencia 2 y 9, Galicia 1 y 5, Cataluña 2 y 3, Castilla y León 2 y 2, Castilla-La Mancha 1 y 1, Canarias 1 y 0; sin código además Aragón 1, Asturias 2, Baleares 1, Extremadura 2 y País Vasco 1). Se completan con el propio fichero (calle y código del punto con dirección más cercano, orientativos); lo que quede se podrá completar con Nominatim por provincia.
- El nombre es el de OpenStreetMap con el municipio añadido si no lo contiene; algunos conservan la capitalización original (por ejemplo «miscota Barcelona»). Nunca se inventan.
- Un mismo nombre a menos de 150 m cuenta como un único punto.
- No probado en el PostgreSQL local con el esquema real (como el resto de cargas N2); las comprobaciones son las automáticas del repositorio y las de solo lectura de abajo.

## Comprobaciones (solo lectura, 26/10/2026)
- Los 116 códigos INE del lote existen en `municipalities` (116 de 116).
- Ningún `source_ref` del lote existe ya en la base (0 de 170) y no hay `source_ref` repetidos dentro del lote.
- Hoy hay 7 puntos en la categoría Tiendas (Granada). **Previsto tras la carga: 177**, y la base pasaría de 39.122 a 39.292 puntos.

## Cómo cargar (con aprobación)
Desde la raíz del repositorio, con `main` actualizada (`git pull origin main`):
```
bash scripts/catalogue/cargar.sh supabase/seeds/tiendas tiendas
```
Muestra el recuento antes y después (total y de la categoría Tiendas): debe pasar de `39122|7` a `39292|177`. Cada SQL es una transacción y el script se detiene en el primer error. Después se verifica en solo lectura y se actualiza este documento.
