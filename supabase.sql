-- Encuesta de validación para remeseros: tabla de respuestas en Supabase.
-- Ejecutar una sola vez en el editor SQL del proyecto de Supabase.

-- Respuestas anónimas: solo versión de la encuesta, respuestas y fecha de registro.
create table if not exists public.survey_responses (
  id             bigint generated always as identity primary key,
  survey_version varchar(10) not null,
  answers        jsonb       not null,
  created_at     timestamptz not null default now(),
  -- Las respuestas deben ser un objeto JSON y de tamaño acotado (evita abuso).
  constraint survey_responses_answers_object_chk check (jsonb_typeof(answers) = 'object'),
  constraint survey_responses_answers_size_chk   check (pg_column_size(answers) < 20000)
);

comment on table public.survey_responses is 'Respuestas anónimas de la encuesta de validación para remeseros.';

-- Seguridad a nivel de fila: sin políticas, nadie (salvo service_role) puede leer ni escribir.
alter table public.survey_responses enable row level security;

-- El rol anónimo (la página pública) solo puede insertar.
-- No se crean políticas de SELECT, UPDATE ni DELETE para anon: las respuestas
-- se consultan desde el panel de Supabase o con la clave service_role.
drop policy if exists survey_responses_anon_insert on public.survey_responses;
create policy survey_responses_anon_insert
  on public.survey_responses
  for insert
  to anon
  with check (true);

-- Privilegios mínimos: anon solo puede insertar (las columnas id y created_at se generan solas).
revoke all on public.survey_responses from anon;
grant insert (survey_version, answers) on public.survey_responses to anon;
