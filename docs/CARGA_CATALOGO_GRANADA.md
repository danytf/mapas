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

| 19/10/2026 | Referencia: municipios de Andalucía | 785 municipios con código INE (Almería 103, Cádiz 45, Córdoba 77, Granada 174, Huelva 80, Jaén 97, Málaga 103, Sevilla 106) | OpenStreetMap (áreas administrativas de nivel 8 con `ine:municipio`), fichero de Andalucía del 18/10/2026; los totales por provincia coinciden con los oficiales. En Granada se asigna el código INE a 173 municipios existentes y se crea Valderrubio | `supabase/seeds/import_municipios_andalucia.sql`, `scripts/catalogue/`. **Cargado en producción el 19/10/2026** con `psql` desde el equipo del titular y verificado: 797 municipios, 785 con INE distintos, 806 puntos intactos |

| 19/10/2026 | Tiendas (mascotas) | 7 (Tiendanimal 1, Kiwoko 2, Cash Mascota 3, Mundo Animal 1) | OpenStreetMap (`shop=pet`), fichero de Andalucía del 18/10/2026; municipio por geometría (INE); calle y código postal que faltaban con Nominatim inverso. Alcance elegido por el titular: cadenas tipo Tiendanimal. OpenStreetMap recoge solo 1 Tiendanimal en la provincia (incompleto); no se verificó que Cash Mascota y Mundo Animal sean cadenas. Se ampliará con una lista del titular si la facilita | `supabase/seeds/tiendas-granada.json`, `supabase/seeds/import_tiendas_granada.sql` |

| 19/10/2026 | Altas puntuales a petición del titular (favoritos de trabajo) | 5: Hospital Materno-Infantil y Consultas Externas Materno-Infantil (H.U. Virgen de las Nieves), CS Las Gabias, CS Padul (por revisar: en OpenStreetMap es «Consultorio Padul») y Lidl de la Ctra. de Málaga 53 | OpenStreetMap (fichero de Andalucía del 17/10/2026); dirección de las Consultas Externas y del Lidl aportada por el titular. **Cargado en producción el 19/10/2026** y verificado: 1.459 → 1.464 puntos, 5 altas en la auditoría | `supabase/seeds/import_anadidos_granada_favoritos.sql` |

**Favoritos de trabajo (19/10/2026).** El titular facilitó una lista de 59 puntos que se están trabajando en Granada (hospitales, centros de salud, supermercados, gimnasios, centros comerciales, Leroy Merlin, Decathlon y El Corte Inglés). Se resolvió punto por punto con él: 54 ya existían, 5 se añadieron (fila anterior) y «Clínica Trauma» era una repetición de «Trauma». Se guardaron como favoritos (`user_app_state.favorites`, personales) de la cuenta `formacion@wesser.es`: 59 referencias, sin ninguna huérfana, sin tocar el resto de su estado ni el de otras cuentas. Equivalencias acordadas: «Alameda» = Granaita; «Hipercor» = El Corte Inglés Arabial; «Corte Inglés Acera del Darro» = El Corte Inglés Granada (Carrera de la Virgen 20); «Lidl Gabia» = «Lidl – Ctra. Gabia, 9» (la base lo asigna a Churriana de la Vega y el titular indica Las Gabias: **municipio por corregir si se desea**). Avisos: la cuenta debe cerrar sesión y volver a entrar; una sesión abierta con una versión antigua de la página podría sobrescribir los favoritos al guardar su estado.

**Granada: 12 localidades que no son municipios oficiales.** La base tenía 185 «municipios» en Granada y los oficiales son 174; tras la carga hay 186 (174 con código INE, incluido Valderrubio, más estas 12). Las 12 filas extra (Alcudia de Guadix, Bácor-Olivar, Castillo de Baños, El Turro, Fuentes de Cesna, Híjar, La Herradura, Loreto, Otura, Pitres, Ventas de Zafarraya, Ventorros de San José) vienen del catálogo inicial, tienen puntos y no se tocan; la carga nacional asignará los puntos nuevos al municipio oficial por geometría. **Málaga figura como provincia activa sin municipios ni puntos**: conviene revisarlo en el panel de administración.

Categorías activas aún sin puntos en Granada: Eventos (de momento vacía por decisión del titular).

**«Por revisar».** La aplicación marca un punto como «por revisar» cuando su `location_precision` es `approximate`. Se usa también para señalar datos de origen dudosos (no solo coordenadas); quien lo revise lo confirma desde la ficha («Marcar como revisado») o lo corrige.

## Cómo repetirlo para otra categoría

1. Acordar con el titular el alcance de la categoría y la fuente.
2. Obtener los candidatos (por ejemplo una consulta a Overpass) y enseñarlos con nombre, dirección, municipio y coordenadas; comprobar que no existen ya en la base (nombre y cercanía).
3. Escribir el JSON de origen y el SQL de carga a partir de `import_bricolaje_granada.sql`.
4. Probar en local: cargar, cargar de nuevo y comprobar que no duplica y que la auditoría registra el alta.
5. Pedir aprobación para producción, cargar, y verificar recuento y filas nuevas.
