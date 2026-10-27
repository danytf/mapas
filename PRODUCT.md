# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Responsables de Gestión de Recursos (RGR) de Wesser, en oficina y con pantalla de ordenador. Cada RGR trabaja las provincias que tiene asignadas: solicita permisos a establecimientos y organismos para que los equipos de captación de socios de las ONG puedan trabajar allí, sigue cada solicitud hasta que se concede o se deniega, y decide dónde se envía a cada equipo cada día.

Los administradores (el titular y la cuenta de formación) gestionan además las cuentas, las provincias activas y el catálogo de puntos (altas, archivado, municipio y código postal). Los captadores no usan la aplicación.

El móvil es secundario: sirve para consultar un punto o marcar un seguimiento, no para el trabajo principal.

## Product Purpose

Es el puesto de trabajo del RGR: un mapa de los lugares donde se puede pedir permiso de captación, junto con el Centro de permisos (solicitudes, concesiones, seguimientos y avisos de datos). El Centro es la única vía para gestionar los permisos.

El Calendario mensual es el centro de mando y se abre al entrar. El flujo real: el RP o coordinador crea las solicitudes («por solicitar», naranja); el RGR las mira y manda los correos («solicitada», amarillo); cuando llega la respuesta las pasa a «concedida» (verde) o «denegada» (roja). Una solicitud se pide para un periodo, o para varios (semanas, mes, trimestre o año).

Funciona bien cuando:

- **Ningún seguimiento se escapa:** cada solicitud recibe respuesta o tiene un seguimiento a tiempo, y nada caduca por olvido.
- **Se conceden más permisos:** más concesiones y más días de captación autorizados por zona y por ONG.
- **El RGR sabe dónde enviar a los equipos:** ve de un vistazo qué puntos están disponibles cada día y cuántos captadores caben en ellos.

## Positioning

Es una herramienta interna de Wesser y no compite con ningún producto. La une al trabajo real tres cosas:

- el catálogo de puntos de captación de toda España;
- las reglas de expediente propias de Wesser: capacidad frente a demanda por punto y ONG, que nunca se suman; solicitudes estancadas a los 15 días; ninguna solicitud se deniega ni se cancela sola;
- la bandeja Mi jornada, que ordena el trabajo del día por urgencia y explica por qué está cada fila.

## Operating Context

- Jornada de oficina. Al entrar se abre Mi jornada si hay algo pendiente; el mapa está a un clic.
- Recorrido de un permiso: solicitud (ONG, periodo y captadores), seguimientos con fecha y responsable, concesión o denegación. Después, la concesión vigente con su periodo.
- Vistas de planificación: Panel resumen, Calendario (semana, día por ONG y mes) y Centro de permisos con su resumen. Exportación a CSV de las cuatro listas.
- Trabajo por provincia y por ONG. Un RGR puede tener una provincia o varias.
- Las acciones en bloque (marcar seguimientos como hechos, reprogramarlos, asignar un responsable) muestran un resumen antes de ejecutarse y se verifican después volviendo a leer cada registro.

## Capabilities and Constraints

- Aplicación web estática: un único `index.html` con Leaflet, publicado en GitHub Pages. Los datos están en Supabase (PostgreSQL con RLS por provincia y por rol).
- Sin persistencia de negocio en el navegador (ni localStorage, ni sessionStorage, ni IndexedDB, ni cookies) y sin PWA ni caché offline. La sesión vive solo en memoria.
- Catálogo nacional de unos 39.000 puntos con categorías como supermercado, entidad oficial, gimnasio, centro de salud, centro comercial, hospital, bricolaje, estación, Correos o grandes superficies. Los datos salen de OpenStreetMap y de correcciones del titular. Las direcciones y los códigos postales son orientativos, no una verificación postal.
- Estados de un permiso: solicitado, concedido, denegado, caducado y cancelado.
- Gamificación personal (nivel, XP, logros y retos), siempre separada del flujo de permisos.
- Cambios en `index.html` por rama y PR, con los checks `audit`, `postgres-smoke` y `e2e-centro` en verde. Sin pantallas ni funciones nuevas que no respondan a una necesidad real.
- Política de seguridad de contenido (CSP) en un `<meta>` del HTML, con recursos externos de versión fija y SRI. Las fuentes se cargan de Google Fonts.

## Brand Commitments

- Nombre: «Centro de Gestión de Recursos» de Wesser.
- Idioma de la aplicación: español. Tono directo y cercano. Las reglas se explican en la propia pantalla (por ejemplo, «Cómo se ordena y qué entra en Mi jornada»).
- Logo de Wesser en versión transparente y rojo Wesser como color corporativo. El sistema visual está en `DESIGN.md`.

## Evidence on Hand

- Datos reales en Supabase: catálogo, perfiles, provincias y permisos. No se usan para pruebas con escritura.
- Demostración local con datos sintéticos (PR #278) y Supabase simulado (`scripts/dev/mock-supabase.mjs`) para revisiones visuales. Capturas del Centro con `node scripts/dev/capturas-centro.mjs <carpeta>`.
- Documentación de diseño en `docs/DISENO_*.md`. La crítica anterior está en `.impeccable/critique/`.
- No hay métricas de uso, encuestas ni testimonios. No se inventan.

## Product Principles

1. **Lo urgente primero y explicado.** Toda priorización dice por qué está ahí cada cosa y con qué regla se ordena.
2. **Datos verdaderos o ninguno.** No se inventan cifras ni históricos, y una solicitud caducada se señala, pero nunca se deniega ni se cancela sola. Si un dato falta, se dice que falta.
3. **Una sola fuente de reglas.** El Panel, el Calendario, el Centro y Mi jornada calculan con las mismas funciones y nunca se contradicen.
4. **Sin perder el contexto.** El detalle se abre al lado de la lista y el mapa queda a un clic.
5. **Escritura segura.** Las acciones destructivas o en bloque piden confirmación con un resumen previo y se comprueban después volviendo a leer los registros.

## Accessibility & Inclusion

- Contraste WCAG AA en modo claro y oscuro, comprobado con `scripts/test-a11y-fase-d.mjs`.
- Los estados y la gravedad nunca se indican solo con color: llevan siempre texto, y la gravedad además una forma.
- Texto de 12 px como mínimo, objetivos táctiles de 44 px y la aplicación completa usable con teclado.
- Sin probar todavía con lectores de pantalla reales ni con zoom.
