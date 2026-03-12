-- Tabela pentru rezultatele testelor studentilor
create table if not exists public.student_test_attempts (
  id bigserial primary key,
  student_auth_id uuid not null,
  student_username text not null,

  total_questions integer not null default 0,
  total_correct_answers integer not null default 0,

  points_total integer not null default 0,
  max_points integer not null default 0,
  duration_seconds integer not null default 0,

  tf_total integer not null default 0,
  tf_correct integer not null default 0,
  abc_one_total integer not null default 0,
  abc_one_correct integer not null default 0,
  abc_multi_total integer not null default 0,
  abc_multi_correct integer not null default 0,
  match_pairs_total integer not null default 0,
  match_pairs_correct integer not null default 0,

  breakdown jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_student_test_attempts_student
  on public.student_test_attempts (student_auth_id, created_at desc);

create index if not exists idx_student_test_attempts_created_at
  on public.student_test_attempts (created_at desc);

create index if not exists idx_student_test_attempts_username
  on public.student_test_attempts (student_username);

alter table public.student_test_attempts enable row level security;

-- Studentul poate insera doar rezultate pe user-ul propriu
drop policy if exists "Students can insert own attempts" on public.student_test_attempts;
create policy "Students can insert own attempts"
  on public.student_test_attempts
  for insert
  to authenticated
  with check (auth.uid() = student_auth_id);

-- Studentul isi poate vedea propriul istoric
drop policy if exists "Students can select own attempts" on public.student_test_attempts;
create policy "Students can select own attempts"
  on public.student_test_attempts
  for select
  to authenticated
  using (auth.uid() = student_auth_id);

-- Toti utilizatorii autentificati pot vedea rezultatele pentru clasament
drop policy if exists "Authenticated can select leaderboard" on public.student_test_attempts;
create policy "Authenticated can select leaderboard"
  on public.student_test_attempts
  for select
  to authenticated
  using (true);
