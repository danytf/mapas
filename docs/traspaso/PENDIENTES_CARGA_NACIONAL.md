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
1. **Castilla y León:** consulta hecha el 26/10/2026 (1.021 códigos y 30 calles escritos); quedan 477 sin código y 54 sin calle, sobre todo sin respuesta de Nominatim (421) y 52 dudosos.
2. **Reconsultar los que no respondieron** y los dudosos que no se escribieron (Nominatim puede dar otra respuesta, sin garantía): Aragón (235 sin respuesta), Castilla-La Mancha (269), Extremadura (Badajoz 155, Cáceres 64) y Murcia (111).
3. **Asturias:** 114 sin calle (116 sin código, casi todos dudosos).
4. El resto de comunidades tiene pocos huecos (ver tabla).

### B. Decisiones del titular
- **Dudosos de código postal sin escribir** (el código de Nominatim no coincide con los conocidos del municipio): unos 820 repartidos (Galicia 141, Canarias 136, Valencia 111, Asturias 111, Murcia 100, Cataluña 51, Madrid 44, Baleares 27, Cantabria 27, Aragón 19, Castilla-La Mancha 18, Extremadura 16, País Vasco 14, Navarra 9). Se probó cruzar 418 de ellos (los de las comunidades anteriores a Canarias) con los puntos vecinos de la base: solo 11 tienen apoyo, unos 85 los contradicen y unos 316 no tienen vecinos. Recomendación: dejarlos sin código.
- **Granada, 12 municipios heredados sin INE: RESUELTO el 26/10/2026** (decisión del titular, opción A). Los 12 puntos (un Covirán por municipio en 7 casos, 2 Mercadona, 1 Dia y 3 ayuntamientos) se reasignaron al municipio oficial donde caen: Valle del Zalabí, Guadix, Polopos, Cacín, Algarinejo, Las Gabias, Almuñécar, Moraleda de Zafayona, Villa de Otura, La Taha, Alhama de Granada y Loja. Se escribió desde la sesión de administrador (12 `update` con comprobación del municipio anterior, 12 filas afectadas) y después se borraron los 12 municipios vacíos (0 puntos, sin INE). Verificado en solo lectura: 8.131 municipios, 0 sin INE, 174 en Granada, 39.122 puntos, 0 sin municipio y 0 con el municipio de otra provincia. Los tres ayuntamientos (Bácor-Olivar, El Turro y Ventas de Zafarraya) conservan su nombre dentro del municipio que los absorbió.
- **Hospitales dudosos** (solo por el nombre, sin archivar): Castilla-La Mancha (Hospital Solimat, Instituto Valenciano de Oncología, Sanatorio de Alcohete, Instituto de Enfermedades Neurológicas), Aragón (Clínica Manzanera, Hospital Militar), Valencia (Instituto Social de la Marina - Casa del Mar, Hospital Centro Médico Acuario, Instituto de Traumatología Unión de Mutuas, Hospital Complementario de Segorbe), Galicia (Centro Oncolóxico de Galicia, Centro Materno Infantil Nosa Sra. de Belén, Hospital Naval, Sanatorio Hestia La Robleda, Hospital Montecelo y Hospital Gran Montecelo) y Castilla y León (Policlínica Santa Marta, Centro Hospitalario Benito Menni, San Juan de Dios en San Andrés del Rabanedo, Virgen del Mirón).
- **Estaciones «por revisar» de Cataluña:** los pares marcados como posible duplicado (aeropuerto de El Prat, estación e intercambiador de autobuses de Tarragona); la app tiene el filtro «Por revisar» para decidirlo con el mapa delante.
- **Asignar provincias a usuarios:** decidido no hacerlo hasta terminar España. La carga ya está terminada: ahora puede decidirse. Hay 9 perfiles (2 administradores).

### C. Revisiones menores
- Prueba en un móvil real del plegado de «Puntos archivados» (comprobado en escritorio: sale cerrado) y del zoom mínimo del mapa (lo cubre `scripts/test-mapa-limites.mjs`).
- Datos antiguos de Andalucía, Canarias, Murcia, Extremadura y La Rioja «por completar»: no consta qué faltaba exactamente; comprobarlo con las cifras de la tabla.
- Categoría «Tiendas» (7 puntos): herencia de la carga inicial; revisar si debe mantenerse.
- `.claude/settings.local.json`: conserva un permiso de lectura de las pestañas de Chrome (decisión del titular: dejarlo).
- Copias de seguridad en `~/backups-mapas`: quedan dos completas (`20261025T165228Z`, sin copia fuera de esa carpeta, y `20261025T211312Z`, que contiene datos de prueba).

## Límites de lo verificado
- Los municipios de cada comunidad coinciden con las cifras que se conocen de los municipios oficiales; no se han contrastado una a una con el INE en estas sesiones.
- Las cargas no se probaron en un PostgreSQL local con el esquema real (solo las comprobaciones automáticas del repositorio).
- Varias escrituras de códigos postales se verificaron por recuentos, no por huella md5 de los pares id:código (sí en Madrid y Aragón).
