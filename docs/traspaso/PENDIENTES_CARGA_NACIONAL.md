# Carga nacional N2: estado final y pendientes (26/10/2026)

La carga nacional N2 de OpenStreetMap está **completa**: las 17 comunidades autónomas, Ceuta y Melilla (52 provincias, todas activas). Este documento recoge el estado verificado en solo lectura el 26/10/2026, el resultado de la auditoría final y lo que queda por hacer. El detalle de cada comunidad está en `docs/CARGA_N2_<COMUNIDAD>.md` y en `docs/traspaso/ROADMAP.md` (entradas 12 a 12 quindecies).

## Cifras de la base (consulta en solo lectura)
- **39.122 puntos** (39.050 activos y 72 archivados), todos del catálogo (`source_ref` `catalogo-...`), y **8.131 municipios** (tras retirar los 12 heredados de Granada el 26/10/2026, ver «Decisiones»).
- **2.294 sin código postal** y **844 sin calle** (tras escribir los de Castilla y León).
- 52 provincias, todas activas. 9 perfiles de usuario, 2 administradores.

| Comunidad | Puntos | Municipios | Sin código postal | Sin calle |
|---|---|---|---|---|
| Andalucía | 5.897 | 785 | 153 | 81 |
| Extremadura | 1.230 | 388 | 219 | 18 |
| La Rioja | 246 | 174 | 15 | 7 |
| Murcia | 782 | 45 | 111 | 32 |
| Canarias | 1.627 | 88 | 153 | 28 |
| Cantabria | 723 | 102 | 28 | 18 |
| Cataluña | 6.310 | 947 | 60 | 69 |
| Asturias | 1.028 | 78 | 116 | 114 |
| Navarra | 672 | 272 | 23 | 16 |
| Illes Balears | 1.119 | 67 | 27 | 23 |
| País Vasco | 1.778 | 251 | 16 | 15 |
| Madrid | 3.622 | 179 | 51 | 35 |
| Aragón | 1.594 | 731 | 254 | 63 |
| Castilla-La Mancha | 1.960 | 919 | 289 | 27 |
| Comunidad Valenciana | 3.537 | 542 | 156 | 56 |
| Galicia | 2.737 | 313 | 146 | 188 |
| Castilla y León | 4.215 | 2.248 | 477 | 54 |
| Ceuta y Melilla | 45 | 2 | 0 | 0 |
| **Total** | **39.122** | **8.131** | **2.294** | **844** |

Por categoría: Supermercado 16.929, Entidad oficial 8.426, Gimnasios 2.998, Centro de salud 2.631, Estaciones 2.260, Correos 2.236, Carrefour 947, Centro comercial 915, Hospital 753, Bricolaje 457, Decathlon 175, Leroy Merlin 129, El Corte Inglés 102, MediaMarkt 100, IKEA 57 y Tiendas 7.

## Auditoría de integridad (26/10/2026, solo lectura)
Resultado: **sin incidencias en los datos de los puntos.**
- 0 puntos sin provincia, municipio o categoría; 0 sin coordenadas; 0 fuera de España (caja de las Canarias a Baleares); 0 con el municipio de otra provincia.
- 0 `source_ref` duplicados; 0 códigos INE duplicados; 0 códigos postales cuyo prefijo no coincide con la provincia.
- Los totales por comunidad de la tabla suman exactamente los de la base (39.122 puntos y, antes de escribir Castilla y León, 3.315 sin código y 874 sin calle; la tabla ya refleja 2.294 y 844).
- **Un hallazgo:** 12 municipios de Granada sin código INE, resueltos después (ver «Decisiones»).

## Pendientes

### A. Completar códigos postales y calles (Nominatim, lo lanza el titular)
1. **Castilla y León:** consulta hecha el 26/10/2026 (1.021 códigos y 30 calles escritos).
2. **Reconsulta de los que no respondieron (26/10/2026, hecha por un agente en solo lectura y escrita por el titular con su sesión):** 1.481 puntos de Aragón, Castilla-La Mancha, Extremadura, Murcia y Castilla y León consultados con Nominatim inverso (1 petición cada 1,4 s, sin errores ni bloqueos). Casi no hay nada que escribir porque los nodos de OpenStreetMap de esos pueblos no traen código y las calles son tramos de carretera: 14 propuestas, de las que se escribieron **8** (6 códigos postales: Centro Comercial Augusta de Zaragoza 50011, los dos Carrefour de Villarrobledo 02600, Albalá 10187, la estación de Sorriba en Cistierna 24800 y Mercadona León 24005; y 2 calles: Hospital Virgen del Puerto de Plasencia y Mercadona Cartagena). **Quedan sin escribir 7** a propósito (3 códigos de municipios sin ningún código conocido: Villar y Velasco 16190, Mirandilla 06891 y Roales de Campos 47673; y 3 calles que empiezan por Camino, Cañada o Lugar: Alcohete, Cabeza del Buey y Mazarrón) y **205 dudosos** (100 de Murcia) se mantienen sin código, según la decisión del titular. Una pasada a menor zoom solo serviría con otra regla de validación. No hay más reconsultas pendientes.
3. **Asturias:** 114 sin calle: decidido el 26/10/2026 dejarlas (Nominatim solo devuelve tramos de carretera para esos puntos, y 78 son apeaderos rurales); 116 sin código, casi todos dudosos.
4. El resto de comunidades tiene pocos huecos (ver tabla).

### B. Decisiones del titular
- **Dudosos de código postal sin escribir** (el código de Nominatim no coincide con los conocidos del municipio): unos 820 repartidos (Galicia 141, Canarias 136, Valencia 111, Asturias 111, Murcia 100, Cataluña 51, Madrid 44, Baleares 27, Cantabria 27, Aragón 19, Castilla-La Mancha 18, Extremadura 16, País Vasco 14, Navarra 9). Se probó cruzar 418 de ellos (los de las comunidades anteriores a Canarias) con los puntos vecinos de la base: solo 11 tienen apoyo, unos 85 los contradicen y unos 316 no tienen vecinos. Recomendación: dejarlos sin código. **Decidido el 26/10/2026 por el titular: se dejan sin código postal.**
- **Granada, 12 municipios heredados sin INE: RESUELTO el 26/10/2026** (decisión del titular, opción A). Los 12 puntos (un Covirán por municipio en 7 casos, 2 Mercadona, 1 Dia y 3 ayuntamientos) se reasignaron al municipio oficial donde caen: Valle del Zalabí, Guadix, Polopos, Cacín, Algarinejo, Las Gabias, Almuñécar, Moraleda de Zafayona, Villa de Otura, La Taha, Alhama de Granada y Loja. Se escribió desde la sesión de administrador (12 `update` con comprobación del municipio anterior, 12 filas afectadas) y después se borraron los 12 municipios vacíos (0 puntos, sin INE). Verificado en solo lectura: 8.131 municipios, 0 sin INE, 174 en Granada, 39.122 puntos, 0 sin municipio y 0 con el municipio de otra provincia. Los tres ayuntamientos (Bácor-Olivar, El Turro y Ventas de Zafarraya) conservan su nombre dentro del municipio que los absorbió.
- **Hospitales dudosos** (solo por el nombre, sin archivar): Castilla-La Mancha (Hospital Solimat, Instituto Valenciano de Oncología, Sanatorio de Alcohete, Instituto de Enfermedades Neurológicas), Aragón (Clínica Manzanera, Hospital Militar), Valencia (Instituto Social de la Marina - Casa del Mar, Hospital Centro Médico Acuario, Instituto de Traumatología Unión de Mutuas, Hospital Complementario de Segorbe), Galicia (Centro Oncolóxico de Galicia, Centro Materno Infantil Nosa Sra. de Belén, Hospital Naval, Sanatorio Hestia La Robleda, Hospital Montecelo y Hospital Gran Montecelo) y Castilla y León (Policlínica Santa Marta, Centro Hospitalario Benito Menni, San Juan de Dios en San Andrés del Rabanedo, Virgen del Mirón).
- **Hospitales dudosos, decidido el 26/10/2026 (titular): se mantienen los 22, sin archivar.** Comprobados en fuentes públicas siete de ellos: Hospital Naval de Ferrol (hospital civil y militar integrado en el SERGAS), Hospital Militar de Zaragoza (hoy Hospital General de la Defensa, con convenio con Aragón), Virgen del Mirón de Soria (hospital público del Complejo Asistencial; su calle oficial es Carretera de Logroño 8, no Avenida), Sanatorio de Alcohete (unidad de salud mental en funcionamiento) y Hestia La Robleda (psiquiátrico activo) son centros reales. **Quedan en revisión, sin confirmar, Clínica Manzanera (Teruel; no se halló ninguna clínica con ese nombre en el pueblo) e Instituto Social de la Marina - Casa del Mar (Valencia; las Casas del Mar del ISM son centros administrativos y asistenciales, no hospitales).** Comprobar con el mapa delante. Sin nada posterior a 2022 en varias fuentes.
- **Estaciones «por revisar» de Cataluña, decidido el 26/10/2026 (titular):** (1) **Tarragona:** se mantienen las dos; el Intercanviador de Battestini es la estación de autobuses urbanos de la EMT, junto a la interurbana (no son duplicados). (2) **El Prat:** «Estación de tren de Aeroport» y «Aeroport T2» son la misma estación de Rodalies R2 Nord (a 115 m, por fuentes públicas; probable, no certeza): se archivó «Aeroport» (sin solicitudes, concesiones, seguimientos ni estado asociado) y se conserva «Aeroport T2». Base: 39.048 activos y 74 archivados. La marca «por revisar» (ubicación aproximada) de los demás sigue; «Marcar revisión visual» de la ficha es personal de cada usuario.

### C. Revisiones menores
- **Categorías antiguas sin puntos (12):** Agencia tributaria, Ayuntamiento, Clínica o centro médico, Consultorio, Eventos, Gimnasio o centro deportivo, Gran superficie, Juzgados, Oficina pública, Otros, Seguridad Social y Tráfico. Decidido el 26/10/2026 dejarlas: 0 puntos (activos o archivados), 0 revisiones asociadas, invisibles en la aplicación (solo lee la categoría a través de los puntos). Eventos es de las 17 categorías de la aplicación y se mantiene vacía por decisión del titular. No volver a plantearlo.
- Prueba en un móvil real del plegado de «Puntos archivados» (comprobado en escritorio: sale cerrado) y del zoom mínimo del mapa (lo cubre `scripts/test-mapa-limites.mjs`).
- Datos antiguos de Andalucía, Canarias, Murcia, Extremadura y La Rioja «por completar»: no consta qué faltaba exactamente; comprobarlo con las cifras de la tabla.
- Categoría «Tiendas» (7 puntos de Granada): decidido el 26/10/2026 ampliarla a nivel nacional con seis cadenas (170 puntos preparados en `supabase/seeds/tiendas`, ver `docs/CARGA_N2_TIENDAS_MASCOTAS.md`); cargada el 26/10/2026 (177 puntos en Tiendas).
- `.claude/settings.local.json`: conserva un permiso de lectura de las pestañas de Chrome (decisión del titular: dejarlo).
- Copias de seguridad en `~/backups-mapas`: quedan dos completas (`20261025T165228Z`, sin copia fuera de esa carpeta, y `20261025T211312Z`, que contiene datos de prueba).

## Límites de lo verificado
- Los municipios de cada comunidad coinciden con las cifras que se conocen de los municipios oficiales; no se han contrastado una a una con el INE en estas sesiones.
- Las cargas no se probaron en un PostgreSQL local con el esquema real (solo las comprobaciones automáticas del repositorio).
- Varias escrituras de códigos postales se verificaron por recuentos, no por huella md5 de los pares id:código (sí en Madrid y Aragón).
