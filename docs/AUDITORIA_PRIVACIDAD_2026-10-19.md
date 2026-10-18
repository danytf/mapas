# Auditoría de privacidad y datos personales (19/10/2026)

Alcance: qué datos personales hay o puede haber, quién accede, cuánto se conservan, cómo se atienden acceso y supresión, y qué terceros reciben datos. Evidencia: consultas de solo lectura a producción (recuentos y nombres de claves, sin leer valores), políticas RLS, el código de `index.html` y la documentación del repositorio.

**Esto no es asesoramiento legal.** Lo que depende de la normativa de protección de datos (base jurídica, avisos, contratos con proveedores, plazos) queda marcado como decisión del titular o de quien lleve la protección de datos en Wesser.

Estado de la capa: **Parcial** (inventario, accesos y retención técnica comprobados; falta la parte jurídica).

## 1. Inventario de datos personales (producción, 19/10/2026)

| Dato | Dónde | Cantidad hoy | Observaciones |
|---|---|---|---|
| Correo y hash de contraseña de usuarios | `auth.users` (Supabase Auth) | 3 | Datos personales de los usuarios de la app. |
| Nombre visible | `profiles.display_name` | 0 filas con valor | Campo existente, sin uso. |
| Rol, provincia asignada, quién la asignó | `profiles`, `user_provinces` | 3 y 2 filas | Identificadores internos (uuid). |
| Estado personal (puntos propios, revisiones, logros) | `user_app_state` | 3 filas | Sin texto libre de terceros: claves `badges`, `customPermits`, `customs`, `gamification`, `removed`, `reviewed`. |
| Contacto, notas, historial, valoración y fechas de permisos | `establishment_app_state.state` (JSONB) | 3 filas, 0 con `contacto` y 0 con `notas` rellenos | Es donde se guardaría el nombre y los datos de contacto de personas de los establecimientos (terceros). Hoy no hay ninguno. |
| Lo mismo en tablas normalizadas | `permit_applications`, `permit_grants`, `followups` (`contact_name`, `contact_details`, `notes`) | 0 filas | Tablas sin uso por ahora. |
| Copia de estados anteriores | `establishment_app_state_history.old_state` | 1 fila | Copia íntegra del estado antes de cada sobrescritura (incluiría contacto y notas). |
| Quién cambió qué | `audit_log` | 856 filas | Solo guarda los **nombres** de los campos cambiados (`changed_fields`), no los valores; desde H-03, cuando no hay usuario, también el rol de la base. |
| Cambios de ubicación | `establishment_location_history`, `establishment_location_reviews` | 43 filas de historial de ubicación (revisiones no contadas; 0 con notas) | Direcciones y coordenadas de establecimientos; 0 notas rellenas. |
| Establecimientos | `establishments` | 791 | Datos de empresas y lugares, no de personas; `notes` sin usar. |

Resumen: hoy los únicos datos personales reales son los 3 correos de usuario. La estructura admite datos personales de terceros (contacto y notas en texto libre) cuando se use.

## 2. Quién puede acceder

Comprobado con la matriz RLS (`rls_matrix.sql`, 973 celdas) y las políticas de lectura:

- `audit_log` y `establishment_app_state_history`: solo administrador (`is_admin()`).
- `profiles` y `user_provinces`: cada usuario ve lo suyo; el administrador, todo; solo el administrador escribe.
- `user_app_state`: solo su dueño.
- Estados compartidos, permisos y ubicaciones: usuarios autenticados con la provincia activa asignada, y el administrador.
- Ningún permiso de tabla para `anon`.
- Los 3 correos solo los ve el administrador desde el panel de Supabase o por SQL; la app no los muestra a otros usuarios.

## 3. Conservación y supresión

- **No hay política de conservación**: `audit_log`, `establishment_app_state_history` e historiales de ubicación se conservan indefinidamente, y la app no tiene pantalla para borrarlos.
- **Baja de un usuario**: borrar su cuenta de `auth.users` borra en cascada su perfil, sus provincias y su estado personal. En `audit_log` el actor pasa a vacío (`ON DELETE SET NULL`); los registros se conservan sin nombre (H-10, probado). `establishment_app_state_history.changed_by` guarda el identificador sin clave foránea: queda un uuid huérfano, no un nombre.
- **Supresión de datos de un tercero** (por ejemplo, un contacto de un establecimiento que lo pidiera): habría que editar el estado compartido **y** borrar las copias en `establishment_app_state_history` (y, en su caso, en las copias de seguridad). No hay procedimiento escrito ni pantalla; solo por SQL del administrador.
- **Acceso por parte del interesado**: tampoco hay procedimiento; se atendería manualmente con consultas del administrador.

## 4. Salidas de datos

- **Exportaciones de la app**: el CSV y el JSON incluyen contactos, notas, solicitudes e historial. Piden confirmación; son responsabilidad de quien exporta (`docs/import-export-backups.md`).
- **Copias de seguridad**: `scripts/backup-supabase.sh` genera `data.sql` con todos los datos, sin cifrar; hay que cifrar la copia antes de subirla a un sitio externo (recomendado y explicado al titular). Las copias contienen también los estados anteriores.
- **Terceros que reciben datos al usar la app** (comprobado en la lista de recursos de la página):
  - Google Fonts (`fonts.googleapis.com`): recibe la IP de cada visitante, también en la pantalla de acceso, antes de iniciar sesión.
  - Mosaicos del mapa (ArcGIS): reciben la IP y las zonas consultadas.
  - CDN de Leaflet (unpkg) y de supabase-js (jsDelivr): reciben la IP al cargar.
  - Búsqueda de direcciones (Nominatim público de OpenStreetMap): recibe las direcciones de establecimientos que se geocodifican (no datos de personas).
  - Supabase (`eu-west-1`, Irlanda): aloja los datos. GitHub Pages: sirve el HTML.
- Los visitantes de la app son equipo de Wesser autenticado, pero las peticiones a Google Fonts, los CDN y los mosaicos ocurren al abrir la página.

## 5. Hallazgos

| ID | Prio | Estado | Hallazgo | Acción propuesta |
|---|---|---|---|---|
| H-39 | P3 | Abierto (decisión del titular) | El estado compartido admite contacto y notas de terceros, sin política de conservación, procedimiento de supresión ni de acceso; las copias de estados anteriores (`old_state`) y las copias de seguridad los conservarían aunque se edite el original. Hoy hay 0 datos de este tipo. | Antes de empezar a registrar contactos reales: decidir conservación (p. ej. plazo para `old_state` y `audit_log`), escribir el procedimiento de supresión y de acceso, e incluir las copias en él. |
| H-40 | P3 | Abierto (decisión del titular; se corrige con cambio en `index.html`) | La página carga recursos de terceros (Google Fonts, mosaicos de mapa, CDN) que reciben la IP de cada visitante, también antes de iniciar sesión. Es la práctica habitual de las apps con mapas, pero conviene decidir si es aceptable. | Opciones: aceptar y documentarlo en el aviso de privacidad; alojar la fuente en el repositorio (cambia la CSP y el SRI); mantener el resto. No se cambia sin autorización. |

## 6. No verificado / depende del titular o de la asesoría de protección de datos

- Base jurídica del tratamiento, información a los usuarios (aviso de privacidad) y registro de actividades de tratamiento.
- Contratos de encargado de tratamiento con Supabase y GitHub, y su ubicación real de datos (la base está en `eu-west-1`; el almacenamiento de copias de Supabase y los servidores de GitHub no se han comprobado).
- Si los contactos de establecimientos que se registren serán personas físicas identificables y qué plazo de conservación se aplicaría.
- Qué dice el tratamiento de datos de las otras apps de Wesser que comparten el origen `danytf.github.io` (H-09).
- Logs de Supabase (retención, contenido): no revisados.
