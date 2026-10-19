# Carga N2: Correos de Andalucía

Estado: **preparada y probada en local; pendiente de aprobación del titular para producción** (19/10/2026). Cadena: la de la N1 (`scripts/catalogue/README.md`) con la definición `scripts/catalogue/categorias/correos.json`. Lote: `supabase/seeds/correos-andalucia/` (JSON de origen, `excepciones.csv` y un SQL por provincia).

Fuente: `andalucia-latest.osm.pbf` (base de OpenStreetMap del 17/10/2026 20:20:51 UTC). Puntos ya existentes de la categoría en la base: 81 (todos de Granada, sin identificador de OpenStreetMap), comparados por distancia.

## Decisiones del titular

- Calles y códigos postales completados con Nominatim inverso (323 consultas, 1 cada 1,2 s, sin errores) y cargados en el propio INSERT, de modo que no choca con `guard_sensitive_updates`.
- Granada: queda fuera porque su catálogo está revisado a mano (65 elementos descartados), salvo **Orce** y **Puebla de Don Fadrique** (opción B), dos oficinas sin ninguna oficina propia en varios kilómetros. Quedan fuera Cenes de la Vega y Pinos Puente (a ~170 m de una existente) y Motril (a 1.090 m de la más cercana, puede ser otra oficina).

## Decisiones de extracción

- Entran las oficinas (`amenity=post_office`) cuyo nombre, operador o marca contiene «Correos». Quedan fuera buzones (~720), taquillas (CityPaq y de otras empresas), Correos Express, MRW, UPS, GLS, DHL, Tipsa, Mail Boxes, calles y paradas con «Correos» en el nombre.
- Nombre: «Correos <municipio>» y, si hay calle, « – <calle>», como en Granada. No se exige nombre en OpenStreetMap.
- Dos oficinas a menos de 60 m se consideran la misma (nodo y edificio), cualquiera que sea el nombre; a menos de 120 m de una existente se descarta como ya existente.
- Las calles de Nominatim son la vía más cercana (orientativas). Se descartan las que no son una calle (carriles, accesos, rotondas, códigos de carretera).
- 19 de las 81 oficinas existentes no tienen equivalente en OpenStreetMap a menos de 120 m (faltan allí o sus coordenadas son imprecisas).

## Pruebas en local (PostgreSQL 17)

- Carga de los 8 trozos: 400 puntos nuevos (81 existentes intactos). Segunda carga sin cambios.
- Sin puntos sin municipio o coordenadas; 3 sin calle, 26 sin código postal; todos con precisión `address`; ningún nombre repetido.
- Regresión de la cadena: las estaciones (N1) se regeneran byte a byte idénticas.


Origen: OpenStreetMap (ODbL 1.0, © colaboradores de OpenStreetMap). Criterio: Oficinas de Correos (amenity=post_office cuyo nombre, operador o marca contiene «Correos»). Excluidos: buzones (post_box), taquillas de paqueteria (parcel_locker, incluidas las CityPaq), Correos Express, puntos de otras empresas (MRW, UPS, GLS, DHL, Tipsa, Mail Boxes…), calles y paradas que solo llevan «Correos» en el nombre, y elementos en desuso. El nombre se compone «Correos <municipio>» como en Granada; no se exige nombre en OpenStreetMap. Dos oficinas a menos de 60 m se consideran la misma (nodo y edificio, cualquiera que sea el nombre). Granada queda fuera del lote porque su catalogo esta revisado a mano, salvo Orce y Puebla de Don Fadrique (altas reales sin oficina en la base, elegidas por el titular); a menos de 120 m de un punto ya existente se considera que ya esta en la base.

- Elementos extraídos: 469. Entran: 400 (por revisar: 0). Descartados: 69.

## Entran por provincia

| Provincia | Total |
|---|---|
| Almería | 35 |
| Cádiz | 51 |
| Córdoba | 50 |
| Granada | 2 |
| Huelva | 45 |
| Jaén | 73 |
| Málaga | 69 |
| Sevilla | 75 |
| **Total** | 400 |

## Descartados por motivo

- provincia ya cubierta por el catalogo revisado a mano (18): 65
- texto excluido (express|citypaq|mail boxes): 2
- duplicado en el lote  (): 2

## Datos que faltan en lo que entra

- Sin calle (OpenStreetMap no la trae): 3 de 400. El campo dirección queda vacío; no se inventa.
- Sin código postal: 26 de 400.
- Calle completada con Nominatim (via mas cercana, orientativa): 297 de 400.
- Las oficinas de OpenStreetMap pueden estar cerradas, trasladadas o duplicadas; OpenStreetMap no indica el horario vigente.

## Muestra aleatoria (semilla 1)

| Nombre | Subtipo | Municipio | Coordenadas | Origen |
|---|---|---|---|---|
| Correos Abla – Calle Adolfo Martinez | - | Abla | 37.143994, -2.777296 | node/2409738795 |
| Correos Aljaraque – Calle Antonio Ponce | - | Aljaraque | 37.271281, -7.022733 | node/4124071381 |
| Correos Almería – Calle Tabernas | - | Almería | 36.842621, -2.437703 | way/642610716 |
| Correos Andújar – 12 | - | Andújar | 38.037532, -4.054365 | way/579785032 |
| Correos Antequera – Plaza Virgen de Los Dolores | - | Antequera | 37.036994, -4.727003 | node/8552329981 |
| Correos Campillo de Arenas – Calle de la Virgen | - | Campillo de Arenas | 37.554871, -3.635365 | node/3685389479 |
| Correos Carcabuey – Calle Pilar | - | Carcabuey | 37.443412, -4.27327 | node/1413482571 |
| Correos Castilleja de Guzmán – Plaza San Benito | - | Castilleja de Guzmán | 37.408991, -6.05605 | node/4212527129 |
| Correos Huelva – Avenida de Italia | - | Huelva | 37.254374, -6.953949 | node/5162599425 |
| Correos La Puebla del Río – Calle La Niña | - | La Puebla del Río | 37.269911, -6.061183 | node/12697370977 |
| Correos Moguer – Calle Almoraduj | - | Moguer | 37.138132, -6.828984 | node/1712571095 |
| Correos Porcuna – Calle Doctor Fernán Pérez | - | Porcuna | 37.86968, -4.185446 | node/3012411660 |
| Correos Salteras – Plaza del Consejo | - | Salteras | 37.418462, -6.109061 | node/4280923180 |
| Correos Tocina – Calle Reina Sofía | - | Tocina | 37.606798, -5.734211 | node/4250270935 |
| Correos Utrera – Calle Álvarez Quintero | - | Utrera | 37.18348, -5.781699 | node/1235353272 |
