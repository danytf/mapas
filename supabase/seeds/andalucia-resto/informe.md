# Informe del lote: Bricolaje, Centro comercial, Centro de salud, Entidad oficial, Gimnasios, Hospital, Supermercado (Andalucía)

Origen: OpenStreetMap (ODbL 1.0, © colaboradores de OpenStreetMap). Criterio: Siete categorias de una vez: Hospital (amenity o healthcare = hospital), Centro de salud (clinica o consulta cuyo nombre es «centro de salud» o «centro de atencion primaria»; los consultorios no entran), Supermercado (shop=supermarket sin Carrefour ni Hipercor, que tienen su categoria), Centro comercial (shop=mall), Gimnasios (leisure=fitness_centre), Bricolaje (shop=doityourself sin Leroy Merlin) y Entidad oficial (ayuntamientos, juzgados y oficinas de la AEAT, la Seguridad Social, la DGT y similares). Se excluyen los elementos en desuso o abandonados. El nombre se compone con el de OpenStreetMap y, si no contiene el municipio, se le anade; nunca se inventa. Un punto de la misma categoria y el mismo nombre a menos de 150 m se considera el mismo. Un nombre generico («Supermercado», «Gimnasio»…) no entra y va a excepciones. Granada queda fuera porque su catalogo esta revisado a mano.

- Elementos extraídos: 5624. Entran: 4175 (por revisar: 0). Descartados: 1449.

## Entran por provincia

| Provincia | Bricolaje | Centro comercial | Centro de salud | Entidad oficial | Gimnasios | Hospital | Supermercado | Total |
|---|---|---|---|---|---|---|---|---|
| Almería | 14 | 13 | 27 | 123 | 47 | 12 | 270 | 506 |
| Cádiz | 12 | 36 | 47 | 102 | 86 | 19 | 386 | 688 |
| Córdoba | 1 | 7 | 21 | 97 | 23 | 14 | 182 | 345 |
| Huelva | 2 | 16 | 20 | 90 | 11 | 8 | 166 | 313 |
| Jaén | 36 | 6 | 27 | 130 | 30 | 12 | 331 | 572 |
| Málaga | 20 | 41 | 52 | 132 | 79 | 33 | 500 | 857 |
| Sevilla | 13 | 41 | 74 | 158 | 77 | 28 | 503 | 894 |
| **Total** | 98 | 160 | 268 | 832 | 353 | 126 | 2338 | 4175 |

## Descartados por motivo

- provincia ya cubierta por el catalogo revisado a mano (18): 890
- sin nombre en OpenStreetMap: 288
- texto excluido (carrefour|hipercor|el corte ingl[eé]s|mercado de abastos|mercado municipal|plaza de abastos): 132
- duplicado en el lote  (): 50
- nombre generico o dudoso en OpenStreetMap: 32
- texto excluido (leroy merlin|click|recogida): 20
- texto excluido (pabell[oó]n|campo de f[uú]tbol|pista de|piscina municipal): 19
- fuera de los municipios oficiales cargados: 9
- texto excluido (veterinari|dental|residencia|geri[aá]trico|centro de salud|edificio|administraci[oó]n|mantenimiento|consultorio|lavander[ií]a|aparcamiento): 4
- etiqueta abandoned=yes: 2
- texto excluido (aparcamiento|parking|duty free): 1
- etiqueta disused:amenity: 1
- fuera de las provincias del lote (06): 1

## Datos que faltan en lo que entra

- Sin calle (OpenStreetMap no la trae): 78 de 4175. El campo dirección queda vacío; no se inventa.
- Sin código postal: 1060 de 4175.
- Calle completada desde la direccion o la via mas cercana (orientativa; origen osm-local o nominatim): 2663 de 4175.
- Codigo postal completado desde la direccion mas cercana (orientativo): 1960 de 4175.
- OpenStreetMap puede tener puntos cerrados, trasladados o duplicados, y no indica el horario vigente. El codigo postal y, en parte, la calle son los del punto con direccion mas cercano: orientativos, no una direccion postal verificada.

## Muestra aleatoria (semilla 1)

| Nombre | Subtipo | Municipio | Coordenadas | Origen |
|---|---|---|---|---|
| Ayuntamiento de Chiclana de Segura – Calle Olguinas | Entidad oficial | Chiclana de Segura | 38.312084, -3.042247 | way/640627285 |
| Ayuntamiento de Ohanes – Calle Iglesia | Entidad oficial | Ohanes | 37.037289, -2.745137 | way/867064085 |
| Ayuntamiento de Villamartín – Plaza del Ayuntamiento | Entidad oficial | Villamartín | 36.861263, -5.64143 | way/477724951 |
| Ayuntamiento de Zahara de los Atunes Barbate – Calle Almadraba | Entidad oficial | Barbate | 36.136354, -5.845859 | way/285423035 |
| Brooklyn Fixboxing Málaga – Calle Pacífico | Gimnasios | Málaga | 36.698044, -4.437993 | node/12927293247 |
| Centro de Salud Santa Rosa Córdoba – Avenida Cruz de Juárez | Centro de salud | Córdoba | 37.898589, -4.780536 | node/11626433916 |
| Coviran Ojén – Avenida Pablo Picasso | Supermercado | Ojén | 36.563519, -4.854582 | node/13846462919 |
| Covirán Cabra del Santo Cristo – Calle Cristo de Burgos | Supermercado | Cabra del Santo Cristo | 37.701941, -3.286152 | node/2408297645 |
| Covirán Vélez-Blanco – c/ San Francisco | Supermercado | Vélez-Blanco | 37.693119, -2.097243 | node/10152030317 |
| Dia El Ejido – Calle Río Júcar | Supermercado | El Ejido | 36.774541, -2.810047 | node/4635198491 |
| Mercadona Alcalá de Guadaíra – Plaza de los Calderones | Supermercado | Alcalá de Guadaíra | 37.34166, -5.833452 | node/1906723995 |
| Mercadona Córdoba – Calle Compositor Handel | Supermercado | Córdoba | 37.875187, -4.841952 | way/409579216 |
| Mercadona Málaga – Calle Doctor Ramos Acosta | Supermercado | Málaga | 36.662083, -4.498588 | way/241106253 |
| Supermercados Mas Almonte – Sector Palmito | Supermercado | Almonte | 36.991585, -6.542347 | node/6910679187 |
| Training Extreme Úbeda – Avenida de Don Cristóbal Cantero | Gimnasios | Úbeda | 38.019296, -3.372442 | way/781670567 |
