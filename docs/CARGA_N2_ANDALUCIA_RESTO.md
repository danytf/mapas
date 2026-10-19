# Carga N2: resto de categorías de Andalucía (7 categorías en un lote)

Estado: **preparada y probada en local; pendiente de aplicar en producción.** Lote: `supabase/seeds/andalucia-resto/` (JSON de origen, `informe.md`, `excepciones.csv` y un SQL por provincia). Definición: `scripts/catalogue/categorias/andalucia-resto.json`. Se aplica con `cargar.sh` (ver abajo) bajo la aprobación permanente del titular para lotes que pasan los umbrales.

Fuente: `andalucia-latest.osm.pbf` (base de OpenStreetMap del 17/10/2026 20:20:51 UTC). Origen: OpenStreetMap (ODbL 1.0, © colaboradores de OpenStreetMap).

## Qué entra: 4.175 puntos

| Categoría | Puntos |
|---|---|
| Supermercado | 2.338 |
| Entidad oficial | 832 |
| Gimnasios | 353 |
| Centro de salud | 268 |
| Centro comercial | 160 |
| Hospital | 126 |
| Bricolaje | 98 |

Por provincia: Málaga 857, Sevilla 894, Cádiz 688, Jaén 572, Almería 506, Córdoba 345, Huelva 313. Granada queda fuera (catálogo revisado a mano).

## Decisiones (titular, 19/10/2026) y cómo se aplican

- **Sin Nominatim.** La calle sale del punto con dirección más cercano (≤ 60 m) o de la vía con nombre más cercana (≤ 120 m); el código postal, del punto o edificio con dirección más cercano (≤ 150 m), solo si tiene 5 cifras y empieza por el código de la provincia. Nuevo: `completar_direcciones_local.py`. Después, `inferir_cp_municipio.py` asigna el código a los puntos que no lo tienen en los municipios cuyo código observado es único (129 municipios, al menos 3 observaciones, 243 puntos; origen anotado). Tiempo total de cálculo: unos 10 minutos para 5.600 elementos.
- **Umbrales automáticos:** duplicado de la misma categoría y el mismo nombre a menos de 150 m (queda uno); ya existente a menos de 150 m no entra; municipio por geometría INE; nombre genérico o dudoso fuera (`nombre_sospechoso_regex`); sin calle o sin código postal **entran** y se anotan; nunca se inventan.
- **Nombre:** el de OpenStreetMap; si no nombra al municipio, se le añade; después « – <calle>». Sin nombre en OpenStreetMap no entra.
- Los consultorios no entran (solo «centro de salud» y «centro de atención primaria»). Carrefour, Hipercor y El Corte Inglés quedan en sus categorías propias; los mercados de abastos no son supermercados; los pabellones y pistas no son gimnasios.

## Datos que faltan en lo que entra

- Sin calle: 78 de 4.175. Sin código postal: 1.060 de 4.175 (25 %); se rellenan después con `admin_set_postal_codes` desde la ficha de administrador (desde la consola del navegador con la sesión del administrador).
- La calle completada (2.663) y el código postal completado (1.960) son los de lo más cercano: orientativos, no una dirección postal verificada.

## Descartados (1.449; detalle y motivo en `excepciones.csv`)

890 de Granada (catálogo a mano), 288 sin nombre, 132 por texto excluido de supermercado (Carrefour, Hipercor, El Corte Inglés y mercados), 50 duplicados, 32 nombres genéricos o dudosos, 20 Leroy Merlin y recogidas, 19 pabellones o pistas, 9 fuera de los municipios cargados, 4 hospitales mal etiquetados, 2 abandonados, 1 «duty free», 1 en desuso y 1 de otra provincia (06).

## Pruebas en local (PostgreSQL 17)

Carga de los 7 trozos en `mapas_test`: 4.175 puntos; segunda carga sin cambios (idempotente); 1.060 sin código postal y 78 sin calle, igual que el informe; sin duplicados de `source_ref`.

## Para cargar en producción

```
bash scripts/catalogue/cargar.sh supabase/seeds/andalucia-resto andalucia-resto catalogo-andalucia:andalucia-resto:
```

Pide la cadena de conexión sin eco y muestra el recuento antes y después (esperado: +4.175 en total y 4.175 con ese prefijo). Los SQL suman 1 MB, demasiado para pasarlos por el MCP sin riesgo de errores de transcripción; por eso los ejecuta el titular, un único comando.
