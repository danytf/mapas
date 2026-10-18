# Registro de decisiones

| Fecha | Decisión | Quién | Motivo / efecto |
|---|---|---|---|
| 18/10/2026 | La Fase A se da por cerrada antes de pasar a la B | Titular | Reconstrucción del estado real completada |
| 18/10/2026 | Fusionar los PR #79-#82 y aplicar la migración H-10 en producción | Titular | Checks en verde; migración probada en local y CI |
| 18/10/2026 | H-12: opción C (tabla de historial con trigger) primero, opción A después | Titular | Aditiva y segura; hace recuperable lo sobrescrito |
| 18/10/2026 | H-04: se mantiene que los equipos de una provincia editen los registros de permisos de los demás | Titular | Diseño: el equipo trabaja sobre los mismos puntos. La matriz RLS lo fija |
| 18/10/2026 | H-11 opción A (control de conflicto en el cliente) se hará en la Fase C | Titular | Hay que probarlo en navegador con sesión |
| 18/10/2026 | La Fase C y siguientes se hacen desde Visual Studio Code con Claude y carpeta local `Escritorio/proyectos ia/mapas` | Titular | Pruebas en navegador con sesión y cuentas sintéticas |
| 18/10/2026 | Activar "Require branches to be up to date before merging" en `main` | Titular | El CI corre sobre el resultado real de la fusión |
| 17/10/2026 | No cambiar la protección frente a contraseñas filtradas | Titular | Aviso aceptado |
| 17/10/2026 | No eliminar los 23 índices sin uso ni activar FORCE RLS indiscriminadamente | Titular | Regla de no actuar por intuición |
| 17/10/2026 | La persistencia de negocio vive solo en Supabase; sin fallback local ni migración de datos antiguos de navegador | Titular | Fuente única de verdad |
| 18/10/2026 | Un administrador no puede borrar su propio perfil si es autor de registros (queda rechazado a propósito) | Claude, no objetado | Fuera del alcance de H-10; fijado en `rls_matrix.sql` |
| 18/10/2026 | `user_app_state` queda fuera del historial de H-12 | Claude, no objetado | Un único escritor, sin conflicto entre usuarios |
