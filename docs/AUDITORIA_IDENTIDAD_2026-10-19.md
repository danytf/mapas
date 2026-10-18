# Auditoría de identidad y gestión de cuentas (19/10/2026)

Alcance: ciclo de vida de las cuentas, sesiones, recuperación de acceso y revocación de permisos. Evidencia: código de `index.html`, `supabase/tests/rls_matrix.sql`, `docs/ADMINISTRACION_CUENTAS.md` y el estado de producción. No se ha usado ninguna cuenta real ni se ha escrito en producción.

Estado de la capa: **Parcial**. La revocación en base de datos y el diseño de las sesiones están verificados; el comportamiento de Supabase Auth (caducidad, recuperación por correo, límites de intentos) no se puede comprobar con las herramientas de esta auditoría y queda como dependencia del titular.

## 1. Lo verificado

| Aspecto | Resultado | Evidencia |
|---|---|---|
| Sesión en el navegador | Solo en memoria: `persistSession: true` usa un almacenamiento propio (`authStorage`/`authSessionMemory`), sin `localStorage` ni cookies; `detectSessionInUrl: false`; `autoRefreshToken: true` | `index.html` (creación del cliente), `audit-persistence.mjs` en CI |
| Validación tras iniciar sesión | La app comprueba que existe un perfil y que está activo, y que el usuario no administrador tiene al menos una provincia activa; si falla, cierra la sesión | `index.html` (carga del perfil y de `user_provinces`) |
| Sesión caducada | El cliente muestra un mensaje en español y pide volver a entrar (H-16) | `friendlyError` en `index.html` |
| Revocar a un usuario (`is_active = false`) | La base le niega el acceso aunque su sesión siga abierta: la autorización se calcula en cada consulta (`has_province_access` requiere perfil activo); la cuenta conserva sus datos | `rls_matrix.sql` (usuario inactivo), `province_active.sql` |
| Quitar una provincia o desactivarla | El acceso a sus puntos y estados desaparece en la siguiente consulta, sin esperar a que caduque el token | `province_active.sql` (23 comprobaciones) |
| Borrar la cuenta | Borra en cascada perfil, provincias y estado personal; la auditoría queda sin actor | H-10, `schema_smoke.sql` |
| Privilegios | Un usuario no puede cambiar su propio rol ni su identidad (`protect_profile_identity`); solo el administrador escribe en `profiles` y `user_provinces` | `rls_matrix.sql` |

Conclusión: la revocación **efectiva** de permisos no depende de la vida del token; es inmediata en base de datos.

## 2. Lo que no se puede dar por verificado

| Aspecto | Estado | Motivo |
|---|---|---|
| Recuperación de contraseña por el usuario | La app **no tiene** pantalla de «he olvidado mi contraseña» (no hay `resetPasswordForEmail`). La recuperación es un procedimiento del administrador con el flujo oficial de Supabase (`ADMINISTRACION_CUENTAS.md`) | Decisión de diseño; no es un defecto, pero hay que saberlo |
| Prueba real de ese flujo (correo, enlace, redirección) | **Bloqueada** | Exige una cuenta con correo real y el proveedor de correo de Supabase; el documento de administración ya pide probarlo «en una ventana acordada» |
| Duración del token de acceso y rotación del token de refresco | **Bloqueada** | Se leen en el panel de Supabase (Authentication), no con las herramientas de esta auditoría |
| Cierre de sesión forzado en Auth al desactivar a un usuario | No comprobado | La base ya le niega los datos; falta saber si su sesión sigue siendo válida en Auth hasta que caduque |
| Límites de intentos de inicio de sesión y de envío de correos | **Bloqueada** | No visibles desde la API de gestión |
| Protección contra contraseñas filtradas | Desactivada, aceptada por el titular | Aviso conocido del asesor de seguridad |
| Segundo factor (MFA) | No evaluado | No está activado en la app |

No se creó ninguna cuenta ni se usaron contraseñas para estas pruebas: las pruebas con cuentas sintéticas contra un Supabase alojado están fuera de lo que puede hacer esta auditoría sin una cuenta de pruebas controlada por el titular.

## 3. Hallazgo

| ID | Prio | Estado | Hallazgo | Acción propuesta |
|---|---|---|---|---|
| H-41 | P3 (informativo) | Abierto (decisión del titular) | No hay recuperación de contraseña por el propio usuario y la caducidad de la sesión en Auth no está documentada; un usuario sin acceso depende del administrador | Valorar un flujo de restablecimiento en la app (cambia `index.html` y la CSP) o mantener el procedimiento manual; anotar en `ADMINISTRACION_CUENTAS.md` la duración del token y la política de sesión leídas del panel |

## 4. Lo que puede hacer el titular (10 minutos, sin riesgo)

En el panel de Supabase, proyecto de producción, apunta (sin pegar ningún enlace ni clave) y pásalo para documentarlo:
1. Authentication → Sessions: si hay límite de duración o de inactividad configurado.
2. Project Settings → JWT: caducidad del token de acceso.
3. Authentication → Providers → Email: si «Confirm email» está activado.
4. Authentication → Rate limits: límites de inicio de sesión y de correos.
