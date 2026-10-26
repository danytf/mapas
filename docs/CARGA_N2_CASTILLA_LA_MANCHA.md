# Carga N2 de Castilla-La Mancha (cargada)

Estado: **cargada en producción el 26/10/2026** por el titular con `cargar.sh` y verificada en solo lectura (ver «Cierre»). Decimocuarta comunidad con el mismo procedimiento (ver `docs/CARGA_N2_ARAGON.md` y `docs/CARGA_N2_MADRID.md`). Las cinco provincias (02 Albacete, 13 Ciudad Real, 16 Cuenca, 19 Guadalajara y 45 Toledo) se cargan de una vez.

## Origen
- Fichero: `castilla-la-mancha-latest.osm.pbf` (Geofabrik, edición del **25/10/2026 21:21 UTC**, 107.455.262 bytes, MD5 `340e8788836b54719ca5fd6bf3a94d62` verificado contra el `.md5` de Geofabrik; guardado como `clm-latest.osm.pbf`), fuera del repositorio. OpenStreetMap, licencia ODbL.
- Definiciones: `scripts/catalogue/categorias/castilla-la-mancha-*.json`, derivadas de las de Madrid (castellano, con los filtros de Hospital afinados) con `solo_provincias` 02, 13, 16, 19 y 45 y `region: castilla-la-mancha`. En `generar_lote.py` se añadieron los códigos 02, 13, 16, 19 y 45.
- **Revisión tras la extracción:** (1) el filtro de Hospital dejaba pasar 3 que no lo son («Doctora Beatriz Valero», una consulta; «Entrada General Tomelloso», un acceso; y «Clínica ErgoTerapia»): se quitaron del lote (anotados en `excepciones.csv`) y se añadieron a la definición. (2) **4 ayuntamientos de Guadalajara** (El Cardoso de la Sierra, Colmenar de la Sierra, Peñalba de la Sierra y Bocígano) traían el código postal **28190**, que es de Madrid (error de OpenStreetMap): se dejaron sin código para no cargar un dato falso.

## Municipios (N0)
- `supabase/seeds/castilla-la-mancha/municipios/import_municipios_02_13_16_19_45.sql`: **919 municipios** con código INE (87 de Albacete, 102 de Ciudad Real, 238 de Cuenca, 288 de Guadalajara y 204 de Toledo, las cifras oficiales). El fichero trae además municipios de otras provincias (borde): quedan fuera por `solo_provincias`. Hoy las cinco provincias tienen 0 municipios y 0 puntos y **están activas** (`is_active = true`, comprobado en solo lectura el 26/10/2026): en cuanto se cargue, el administrador verá los puntos.

## Puntos (1.960)
| Lote | Puntos |
|---|---|
| Correos | 113 |
| Estaciones | 89 |
| Grandes superficies (Carrefour 26, Leroy Merlin 6, Decathlon 6, El Corte Inglés 4, MediaMarkt 4, IKEA 1) | 47 |
| Resto (Entidad oficial 802, Supermercado 584, Gimnasios 148, Centro de salud 112, Hospital 26, Centro comercial 26, Bricolaje 13) | 1.711 |
| **Total** | **1.960** |

Por provincia: Albacete 354, Ciudad Real 306, Cuenca 283, Guadalajara 416 y Toledo 601. Un SQL por lote y provincia en `supabase/seeds/castilla-la-mancha/<lote>/` (transaccionales e idempotentes) y `excepciones.csv` por lote (329 filas en total). `source_ref` con el prefijo `catalogo-castilla-la-mancha:`.

## Calidad y límites
- Umbrales de siempre. Calle y código postal calculados con el propio fichero. Quedan **41 puntos sin calle y 818 sin código postal** (el 42 %), sobre todo en pueblos pequeños, donde OpenStreetMap trae pocas direcciones con código. Se completan con Nominatim tras la carga.
- Entidad oficial (802) es la categoría más grande: ayuntamientos de casi todos los municipios.
- Estaciones: 7 entran «por revisar»: estaciones de autobuses de Albacete (repetida) y de Quintanar de la Orden («Puerta Este», «Puerta Sur», «Puerta Oeste») y una «Parada para autobuses» de Toledo.
- Hospital (26), dudosos tras la carga: «Hospital Solimat» (Toledo, una mutua), «Instituto Valenciano de Oncología» (Cuenca), «Sanatorio de Alcohete» (Yebes) e «Instituto de Enfermedades Neurológicas» (Guadalajara).
- Centro comercial (26) incluye hipermercados («Carrefour Villarrobledo», «Centro Comercial Alcampo») que ya están en otras categorías.
- Carrefour (26) entra completo (Market y Express), por decisión del titular.
- No probado en el PostgreSQL local (sin la contraseña en esta sesión).

## Cómo se cargó (con aprobación)
Desde la raíz del repositorio, con `main` actualizada (`git pull origin main`), en este orden:
```
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-la-mancha/municipios municipios
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-la-mancha/correos postal_service
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-la-mancha/estaciones estaciones
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-la-mancha/grandes-superficies grandes-superficies catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:
bash scripts/catalogue/cargar.sh supabase/seeds/castilla-la-mancha/resto resto catalogo-castilla-la-mancha:castilla-la-mancha-resto:
```
Previsto en solo lectura: 919 municipios nuevos y 1.960 puntos (la base pasaría de 26.670 a 28.630 y los municipios de 4.119 a 5.038). Sin asignar a usuarios hasta terminar toda España (decisión del titular, 23/10/2026).

## Cierre (26/10/2026)
- **Carga verificada en solo lectura:** 919 municipios (Albacete 87, Ciudad Real 102, Cuenca 238, Guadalajara 288, Toledo 204) y 1.960 puntos (354, 306, 283, 416 y 601), 1.960 `source_ref` `catalogo-castilla-la-mancha:` distintos, ninguno sin coordenadas y ningún código postal con formato erróneo. Total de la base 26.670 -> 28.630 y municipios 4.119 -> 5.038.
- **Pendiente:** 818 códigos postales (Albacete 89, Ciudad Real 119, Cuenca 160, Guadalajara 246, Toledo 204) y 41 calles (7, 4, 5, 7 y 18), por completar con Nominatim por provincia (`completar_cp_desde_base.py --prov NN --con-calle`) y `admin_set_postal_codes`; revisar los dudosos de «Calidad y límites». Sin asignar a usuarios hasta terminar España.
- **Códigos postales y calles (26/10/2026):** 822 puntos consultados con Nominatim (`completar_cp_desde_base.py --prov NN --con-calle`, lanzado por el titular). Se escribieron **529 códigos** con `admin_set_postal_codes` desde la sesión de administrador (Albacete 52, Ciudad Real 82, Cuenca 94, Guadalajara 141 y Toledo 160; 529 actualizados, 0 omitidos, auditados) y **14 calles** (solo en puntos con la dirección vacía). Se dejaron sin escribir **18 dudosos** (el código no coincide con los conocidos del municipio: Cuenca, Cabanillas del Campo, Yebes, El Romeral, Orgaz, Oropesa, Seseña y Toledo), 2 repetidos (Villarrobledo) y **269 sin respuesta** de Nominatim; se descartaron 3 calles que son vías pecuarias («Cañada Real Soriana Oriental», «Cañada Real Galiana» y «Cañada de Alcohete»).
- **Estado tras escribir (solo lectura):** **289 sin código postal** (Albacete 37, Ciudad Real 37, Cuenca 66, Guadalajara 105 y Toledo 44) y **27 sin calle** (5, 3, 3, 6 y 10); ningún código con formato erróneo. Verificado por recuentos (818 − 529 y 41 − 14); esta vez no se comparó la huella md5 de los pares id:código.

