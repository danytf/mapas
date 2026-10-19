# Mapa del Responsable de Gestión de Recursos de Wesser

Lee este fichero entero al empezar y después `docs/traspaso/ESTADO.md` y `docs/traspaso/ROADMAP.md`. Con eso puedes continuar sin pedir contexto al titular (Dani). Idioma de trabajo y de la aplicación: español.

## Qué es

Aplicación web estática (`index.html` + Leaflet) publicada en GitHub Pages: https://danytf.github.io/mapas/ . Mapa de lugares de Granada donde solicitar permisos para equipos de captación de socios. Datos en Supabase (PostgreSQL con RLS), proyecto `wwoczmihhupofwmlmgga`. Repositorio `danytf/mapas`, rama `main`.

Estamos en una auditoría integral por fases A-F (ver `docs/traspaso/ROADMAP.md`). A, B, C, D y E están cerradas y la Fase F (informe final, `docs/AUDITORIA_INFORME_FINAL_2026-10-19.md`) también: **la auditoría A-F está cerrada**. Lo que queda (auditorías futuras y tareas del titular) está en `docs/traspaso/ROADMAP.md`.

## Reglas inviolables (del titular)

- No rehacer la aplicación ni sustituir su arquitectura sin necesidad.
- No introducir PWA, service workers, caché offline ni nuevas formas de persistencia local.
- No persistir datos de negocio, catálogo, ubicaciones, preferencias operativas ni estado de aplicación en localStorage, sessionStorage, IndexedDB, Cache Storage o cookies. La persistencia de negocio vive solo en Supabase; las variables en memoria durante la sesión sí valen.
- No recuperar ni migrar datos de prueba antiguos de los navegadores. No crear fallback al catálogo local.
- No inventar establecimientos, coordenadas, resultados de pruebas, métricas, usuarios, permisos ni estados de despliegue.
- No modificar datos reales para simular pruebas. Pruebas con escritura o destructivas, solo en un entorno aislado.
- No exponer claves, tokens, contraseñas ni credenciales en código, commits, informes ni logs.
- No modificar `main` directamente con cambios de riesgo: rama + PR. No publicar en producción sin checks en verde y sin verificar el impacto.
- No eliminar índices, tablas, columnas, políticas ni funciones por intuición (incluidos los 23 índices sin uso). No activar FORCE RLS de forma indiscriminada.
- No cambiar el comportamiento funcional sin necesidad demostrada y pruebas de regresión. No añadir funciones o pantallas sin necesidad real.
- No cambiar la protección contra contraseñas filtradas sin autorización (aviso conocido y aceptado).
- No crear recursos de pago ni tocar producción sin confirmar coste y permisos con el titular (en Supabase, `create_project` y `create_branch` presentan el coste al llamarlas; el MCP actual no tiene `get_cost`/`confirm_cost`. La organización está en plan gratuito, sin ramas).
- No afirmar que un PR, prueba o despliegue existe o pasa sin haberlo verificado. No decir que falta CSP sin comprobar las cabeceras reales.
- Si algo depende de su autorización, de credenciales que no tienes o de una prueba manual: déjalo identificado y sigue con lo independiente.

## Cómo trabaja Dani (aplicar siempre)

Español directo, conciso y orientado a la acción; sin emojis decorativos. Prefiere ficheros completos o ediciones quirúrgicas, nunca fragmentos sueltos. Exige verificación exhaustiva de datos antes de concluir, autocrítica antes de entregar y ninguna falsa certeza. Una acción por paso cuando le guías. Prompts copiables. Si algo es dudoso, dilo.

## Git y despliegue

- Ramas con prefijo `fix/`, `feat/`, `docs/`, `audit/`, `security/`; PR hacia `main`; fusión con squash (merge commit solo para PR apilados).
- `main` está protegida: PR obligatorio, checks `audit` y `postgres-smoke` obligatorios, ramas actualizadas con `main` antes de fusionar, sin saltarse reglas ni siquiera el administrador, sin force push ni borrado.
- Tocar `index.html` en `main` despliega en producción (workflow Deploy GitHub Pages). Tras fusionar, verifica en el navegador la URL pública.
- No ejecutes las auditorías dentro de la raíz con `git add -A` sin revisar: `scripts/audit-static-catalog.mjs` genera `catalog-audit-output/` (ya está en `.gitignore`).
- Las migraciones de `supabase/migrations/` deben llevar la versión que Supabase registra al aplicarlas (`list_migrations`), y el workflow `schema-smoke.yml` debe aplicarlas todas (hay un paso que lo comprueba). Los scripts de `supabase/bootstrap/` no son migraciones pendientes de producción.
- Atribución de commits: usa la que indique el entorno actual. No reutilices la URL de sesión de la sesión en la nube anterior.

## Primera sesión en esta carpeta (hazlo tú, sin preguntar)

Si la carpeta no contiene `.git`, conecta el repositorio sin perder nada:

```
git init -b main
git remote add origin https://github.com/danytf/mapas.git
git config core.autocrlf false
git fetch origin main
git reset origin/main
git checkout -- .github
git status
```

La carpeta es una copia de `main` a 18/10/2026, sin la carpeta `.github` (las herramientas remotas no pueden escribir ficheros de workflows); `git checkout -- .github` la restaura desde `origin/main`. Después `git status` debe salir limpio. Si muestra diferencias, compáralas con `git diff` antes de tocar nada y cuéntaselo a Dani. Después `git pull origin main`. Para ver las ramas de trabajo: `git config --add remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'`.

## Herramientas esperadas

`gh` (REST; GraphQL puede estar bloqueado), Node 22 para los scripts `scripts/*.mjs`, PostgreSQL local para las pruebas SQL, el MCP de Supabase (proyecto `wwoczmihhupofwmlmgga`) y la extensión Claude in Chrome para las pruebas en navegador. Si falta alguna, pídesela a Dani indicando qué necesitas y para qué.

## Comprobaciones antes de cualquier PR

```
node scripts/audit-persistence.mjs index.html
node scripts/audit-xss.mjs index.html
node scripts/audit-a11y.mjs index.html
node scripts/audit-cdn-integrity.mjs index.html
node scripts/audit-csp.mjs index.html
node scripts/audit-static-catalog.mjs index.html
node scripts/test-shared-state-sanitizers.mjs
node scripts/test-paged-fetch.mjs
node scripts/test-multiprovince.mjs
node scripts/test-ui-fixes.mjs
node scripts/test-list-performance.mjs
node scripts/test-admin-panel.mjs
node scripts/test-app-mejoras.mjs
node scripts/test-calendario.mjs
node scripts/test-cabecera-filtros.mjs
node scripts/test-texto-minimo.mjs
node scripts/test-ficha.mjs
node scripts/test-favoritos.mjs
node scripts/test-a11y-fase-d.mjs index.html
```

Pruebas SQL: ver `docs/traspaso/PRUEBAS.md`. Un cambio de esquema exige migración + prueba + paso en `schema-smoke.yml`.

## Qué no hay en el repositorio

Credenciales de cualquier tipo (claves de Supabase, contraseñas, cuentas de prueba reales). Las cuentas de prueba de la Fase C son sintéticas y se crean en una rama aislada de Supabase; nunca se usan las cuentas reales. El texto literal del primer encargo (prompt inicial) no se conservó; las reglas están arriba y las fases en `docs/traspaso/ROADMAP.md`.
