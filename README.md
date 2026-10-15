# Encuesta para remeseros

Encuesta anónima de validación de producto. Página estática publicada con GitHub Pages: https://remsas.github.io/encuesta/

- `index.html`: la encuesta (HTML, CSS y JS en un solo archivo). Las respuestas se envían a Supabase (configuración en `CONFIG`, al inicio del script).
- `supabase.sql`: crea la tabla `survey_responses` con seguridad por filas; la página solo puede insertar.
