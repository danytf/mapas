# Memoria del proyecto (copia a 18/10/2026)

Contexto guardado sobre este proyecto y sobre cómo trabaja el titular. Si algo contradice lo que Dani diga en la sesión, manda lo que diga Dani.

## El proyecto (palabras del titular)

- Mapa interactivo independiente de lugares de Granada (ciudad y provincia) donde pedir permiso para colocar equipos de captación de socios; es el mapa del responsable de gestión de recursos.
- Hospitales, centros de salud y clínicas privadas sí conceden permisos, por eso se quedan en el mapa.
- Las categorías deben coincidir con su lista de 17 recursos: hospital, centro de salud, supermercado, centro comercial, entidad oficial, gimnasios, IKEA, Leroy Merlin, Decathlon, Carrefour, Correos, El Corte Inglés, bricolaje, MediaMarkt, estaciones, tiendas, eventos. Los va añadiendo uno a uno.
- Publicado en GitHub Pages: `danytf/mapas` (https://danytf.github.io/mapas/).
- Flujo de permisos: primero se solicita (fechas pedidas, ONG, captadores); al aceptarse se marca concedido (fechas y captadores editables). Caducado = solicitud cuyas fechas pasaron sin respuesta. Cancelado = permiso concedido que luego se canceló.
- Un mismo lugar se solicita varias veces para rangos de fechas distintos (otras semanas, días del mes, trimestre o año), así que cada punto puede tener varias solicitudes.
- Auditoría integral en curso (seguridad, persistencia, E2E, backups). Decidió seguir la fase de navegador/E2E desde Visual Studio Code conectado a Claude, con carpeta local en su ordenador. Decidió que los equipos de provincia pueden seguir editando los registros de permisos de los demás (se mantiene como diseño) y añadir control de conflicto en el cliente para guardados concurrentes en esa fase.

## Preferencias de trabajo

- Español directo, conciso y orientado a la acción; sin emojis decorativos.
- Ficheros completos actualizados antes que fragmentos; ediciones quirúrgicas antes que reescrituras.
- Pasos de uno en uno cuando se le guía con Claude Code; prompts copiables.
- Muy orientado al resultado; rechaza lo genérico.
- Verificación exhaustiva de los datos antes de concluir; avisar de duplicados o anomalías antes de presentarlos; aplica el criterio "¿son las mejores conclusiones posibles?" a todo entregable analítico; autocrítica siempre antes de entregar.
- Prudencia especial en temas médicos: nunca falsas certezas; derivar al especialista.

## Entorno

- Equipo Windows; carpeta de trabajo `Escritorio\proyectos ia\mapas`. Zona horaria Europe/Madrid.
