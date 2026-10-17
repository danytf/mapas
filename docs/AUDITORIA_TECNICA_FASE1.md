# Auditoría técnica de la aplicación actual — Fase 1

**Repositorio:** `danytf/mapas`  
**Archivo revisado:** `index.html`  
**Referencia auditada:** blob `4a002c76a78f87e1c6bfc1a0bfe4635bd64890bf`  
**Fecha:** 16 de octubre de 2026  
**Alcance:** lectura estática del archivo completo (1.894 líneas; ~310 KB). No se ha modificado la aplicación ni se ha desplegado ningún cambio.

## 1. Decisión de datos confirmada

**No se migrará ningún dato procedente del almacenamiento de los navegadores.** Los valores de `localStorage`, `sessionStorage`, copias JSON o CSV exportadas desde esas pruebas, y cualquier estado generado durante su uso se consideran datos experimentales y quedan fuera de la migración.

La migración partirá de cero para los datos operativos y de usuarios. En particular, no se importarán permisos, solicitudes, seguimientos, puntos añadidos/eliminados, ubicaciones corregidas, revisiones ni gamificación que procedan del navegador.

Esto no implica desechar automáticamente el catálogo estático versionado en el propio repositorio. Los registros definidos en `CENTERS`, `PROV`, `SUPER`, `OFICIALES`, `GYMS`, `BIGS`, las coordenadas `PRECOMPUTED` y otras listas explícitas del código son **fuentes de catálogo en el repositorio**, no datos recuperados de los navegadores. Se podrán usar como semilla inicial, tras validación y normalización. La lista `REVIEWED_BASE` también está escrita en el código; debe revisarse como dato editorial versionado, no mezclarse con estados locales.

## 2. Qué hace hoy la aplicación

- Aplicación de una sola página: HTML, CSS y JavaScript concentrados en `index.html`.
- Mapa con Leaflet, agrupación de marcadores, filtros por categoría/estado/valoración/cadena, búsqueda, fichas, estadísticas y panel de resumen semanal.
- Catálogo de recursos de la provincia de Granada, construido a partir de listas estáticas y ampliaciones de diferentes categorías.
- Geocodificación/búsqueda de direcciones y posibilidad de añadir puntos manualmente.
- Seguimiento de permisos por punto: estado calculado, solicitudes, concesiones e historial, ONG, fechas, número de captadores, contacto, notas, valoración y fecha de seguimiento.
- Exportación CSV y copia de seguridad JSON; restauración/importación desde JSON.
- Funciones de gamificación: XP, niveles, insignias, álbum y progreso.
- Capa visual de inicio de sesión y opción de mantener la sesión.

## 3. Hallazgos críticos

### P0 — El acceso actual no protege los datos

El propio código lo advierte en el comentario de la línea final de acceso: el inicio de sesión es un filtro de pantalla, no una barrera de seguridad. La comprobación se ejecuta íntegramente en el navegador y el catálogo/código se entrega al cliente. El hash de la contraseña y la variable de sesión no equivalen a autenticación/autorización de servidor.

**Consecuencia:** no debe considerarse apta para información operativa corporativa multiusuario ni utilizarse como modelo de seguridad. La futura versión necesita autenticación real y autorización en el servidor/base de datos, con políticas RLS verificadas. Las credenciales privilegiadas nunca deben ir en el frontend.

### P0 — No existe persistencia compartida

El estado operativo se carga y guarda en `localStorage`; la sesión utiliza `localStorage` o `sessionStorage`. Cada navegador/dispositivo mantiene su propia copia, sin sincronización ni fuente de verdad compartida.

**Consecuencia:** dos usuarios no comparten de forma fiable permisos, cambios, ubicaciones o seguimientos. Limpiar los datos del navegador puede perder el estado; usar otro dispositivo crea otro conjunto independiente.

### P1 — La identidad de los puntos no es estable

Los permisos, puntos retirados, revisiones y correcciones de ubicación se relacionan por el **nombre** del establecimiento. Además, los identificadores numéricos se vuelven a asignar según el orden de los registros de catálogo y de los puntos personalizados.

**Consecuencia:** un cambio de nombre, un duplicado o una alteración del orden puede asociar datos al punto incorrecto. La base de datos futura debe usar UUID/IDs persistentes y resolver cada recurso con datos auxiliares (municipio, dirección y coordenadas), sin asumir que un nombre es único.

### P1 — La importación JSON no es una migración segura

El importador actual fusiona datos por coincidencia de nombre, acepta un esquema heredado y mezcla permisos, puntos, revisiones, ubicaciones y gamificación. No ofrece una previsualización de conflictos ni un proceso transaccional con informe de errores por registro.

**Decisión para la nueva plataforma:** no reutilizar este importador como migrador corporativo. No importar archivos de prueba. Si en el futuro se necesita importar un catálogo legítimo, debe ser un proceso independiente, con vista previa, validación, detección de duplicados, registro de incidencias e idempotencia.

## 4. Persistencia local detectada

Las claves observadas en el código incluyen:

| Clave | Contenido aparente | Decisión |
|---|---|---|
| `permisos-captacion-granada-v1` | Estados, solicitudes, historial y datos de seguimiento | No migrar |
| `puntos-propios-granada-v1` | Puntos añadidos manualmente | No migrar |
| `puntos-quitados-granada-v1` | Puntos ocultados/retirados | No migrar |
| `puntos-revisados-granada-v1` | Puntos marcados como revisados | No migrar |
| `ubicaciones-corregidas-granada-v1` | Coordenadas corregidas manualmente | No migrar |
| `cs-granada-geo-v3` | Caché de coordenadas/geocodificación | No migrar; regenerable |
| `logros-granada-v1` | Insignias/progreso | No migrar |
| `gamificacion-granada-v1` | XP, niveles y progreso | No migrar |
| `rgr-auth` | Indicador local de sesión | No migrar; sustituir por Auth real |

Las listas estáticas y las coordenadas incrustadas en el propio archivo no son claves de almacenamiento del navegador. Deben tratarse por separado como contenido fuente del repositorio.

## 5. Modelo funcional que conviene conservar

La nueva aplicación debe preservar el valor de negocio, no la implementación local:

1. **Catálogo de establecimientos:** nombre, categoría, subtipo, municipio, dirección, coordenadas, precisión, fuente y estado de verificación.
2. **Permisos:** una entidad operativa relacionada por ID estable con el establecimiento, con solicitudes, concesiones e historial separados cuando corresponda.
3. **Seguimientos:** fecha, responsable, estado y resultado, relacionados con establecimiento y usuario.
4. **Usuarios y ámbito territorial:** perfil, rol y asignaciones explícitas a provincias; administración global reservada a administradores autorizados.
5. **Auditoría:** quién creó/modificó/archivó cada dato y cuándo.
6. **Importación de catálogo:** lotes reproducibles con prevalidación, errores revisables y sin duplicados.
7. **Búsqueda, mapa, filtros y paneles:** reconstruidos sobre datos autorizados que lleguen desde el backend.

La gamificación no es un requisito de persistencia corporativa confirmado. No debe migrarse ni incorporarse automáticamente a la nueva base de datos; primero debe decidirse si sigue teniendo sentido para el producto.

## 6. Riesgos y observaciones adicionales

- **Datos y reglas mezclados:** catálogo, interfaz, lógica de permisos, estadísticas, importación y persistencia conviven en un único archivo grande. Dificulta probar y cambiar una parte sin afectar a otras.
- **Datos heterogéneos:** algunas entradas tienen dirección incompleta, municipio implícito o coordenadas aproximadas. La carga inicial debe marcar incertidumbre y no convertir aproximaciones en ubicaciones verificadas.
- **Dependencia de servicios externos:** el mapa y la geocodificación usan proveedores externos. En la arquitectura nueva habrá que documentar límites de uso, atribución, privacidad y política de reintentos/caché.
- **Fechas:** varias funciones usan `toISOString().slice(0, 10)`, que trabaja en UTC. Conviene centralizar fechas operativas y probar casos en la zona horaria peninsular para evitar cambios de día inesperados.
- **Datos introducidos por usuarios:** al generar HTML dinámico debe mantenerse escape contextual riguroso. En la nueva arquitectura hay que revisar XSS en todos los campos editables y en la visualización de notas/contactos.
- **Copias de seguridad:** CSV/JSON son útiles para exportación controlada, pero no deben ser la fuente de verdad ni un mecanismo de autorización.
- **Despliegue:** no tocar la versión publicada durante el desarrollo de la arquitectura compartida. Trabajar en rama/entorno de prueba y desplegar solo después de pruebas funcionales y de permisos.

## 7. Arquitectura objetivo recomendada

- **Frontend:** mantener una interfaz web ligera; se puede seguir usando Leaflet. No añadir PWA.
- **Autenticación:** proveedor real de identidad, con sesión gestionada de forma segura.
- **Base de datos:** PostgreSQL gestionado, con IDs estables y relaciones normalizadas.
- **Autorización:** políticas RLS para limitar lectura y escritura a las provincias asignadas; comprobaciones del lado servidor y rol administrador explícito. Las políticas deben probarse con usuarios de provincias distintas y con un administrador.
- **Concurrencia:** definir reglas para actualizaciones simultáneas (por ejemplo, versión del registro o `updated_at`) y registrar cambios relevantes.
- **Entornos:** desarrollo/pruebas separado de producción; secretos fuera del repositorio y del código cliente.
- **Migración inicial:** semilla controlada solo desde el catálogo del repositorio validado. Cero migración de datos locales de navegador.

## 8. Plan de trabajo derivado

1. Cerrar el inventario del catálogo estático y normalizar sus campos, municipios y coordenadas.
2. Diseñar el esquema SQL y las restricciones, incluidas las relaciones entre establecimientos, solicitudes, concesiones, seguimientos y usuarios.
3. Implementar autenticación y RLS antes de conectar datos operativos.
4. Construir un importador **solo para el catálogo estático validado**, con modo de simulación e informe de incidencias. No leer almacenamiento del navegador ni importar copias de pruebas.
5. Adaptar la interfaz para leer/escribir en backend; eliminar progresivamente las escrituras de estado operativo en `localStorage`.
6. Probar aislamiento entre provincias, privilegios de administrador, cambios concurrentes, importación repetida y restauración.
7. Desplegar tras revisión; mantener la versión actual intacta hasta superar las pruebas.

## 9. Fuera del alcance de esta fase

Esta auditoría no modifica `index.html`, no configura un proveedor de autenticación, no crea tablas, no carga datos en una base de datos y no despliega nada. Es un diagnóstico estático para guiar la fase de diseño y construcción.
