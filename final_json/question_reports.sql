-- Raportări trimise de studenți pentru întrebări care trebuie verificate.
create table if not exists public.question_reports (
  id uuid primary key default gen_random_uuid(),
  student_auth_id uuid not null references auth.users(id) on delete cascade,
  student_username text not null,
  question_type text not null check (question_type in ('tf', 'abc_one', 'abc_multi', 'match')),
  question_id text not null,
  question_book text,
  question_chapter integer,
  question_text text not null,
  reason_code text not null check (reason_code in ('incorrect', 'ambiguous', 'typo', 'other')),
  student_message text,
  status text not null default 'open' check (status in ('open', 'in_review', 'resolved', 'rejected')),
  reviewer_message text,
  reviewed_by uuid references auth.users(id) on delete set null,
  reviewed_by_username text,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_question_reports_student
  on public.question_reports (student_auth_id, created_at desc);
create index if not exists idx_question_reports_status
  on public.question_reports (status, created_at desc);
create index if not exists idx_question_reports_question
  on public.question_reports (question_type, question_id);

alter table public.question_reports enable row level security;

drop policy if exists "Students can create own question reports" on public.question_reports;
create policy "Students can create own question reports"
  on public.question_reports
  for insert
  to authenticated
  with check (auth.uid() = student_auth_id);

drop policy if exists "Students can view own question reports" on public.question_reports;
create policy "Students can view own question reports"
  on public.question_reports
  for select
  to authenticated
  using (auth.uid() = student_auth_id);

drop policy if exists "Reviewers can view question reports" on public.question_reports;
create policy "Reviewers can view question reports"
  on public.question_reports
  for select
  to authenticated
  using (
    exists (
      select 1 from public.accounts a
      where a.id = auth.uid() and lower(a.role) in ('admin', 'instructor', 'indrumator')
    )
  );

drop policy if exists "Reviewers can update question reports" on public.question_reports;
create policy "Reviewers can update question reports"
  on public.question_reports
  for update
  to authenticated
  using (
    exists (
      select 1 from public.accounts a
      where a.id = auth.uid() and lower(a.role) in ('admin', 'instructor', 'indrumator')
    )
  )
  with check (
    exists (
      select 1 from public.accounts a
      where a.id = auth.uid() and lower(a.role) in ('admin', 'instructor', 'indrumator')
    )
  );

drop policy if exists "Reviewers can delete question reports" on public.question_reports;
create policy "Reviewers can delete question reports"
  on public.question_reports
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.accounts a
      where a.id = auth.uid() and lower(a.role) in ('admin', 'instructor', 'indrumator')
    )
  );

-- Instructorii și administratorii pot corecta sau elimina întrebarea raportată.
do $$
declare
  question_table text;
begin
  foreach question_table in array array['questions_tf', 'questions_abc_one', 'questions_abc_multi', 'questions_match'] loop
    execute format('drop policy if exists "Reviewers can update questions" on public.%I', question_table);
    execute format($policy$
      create policy "Reviewers can update questions"
        on public.%I
        for update
        to authenticated
        using (
          exists (
            select 1 from public.accounts a
            where a.id = auth.uid() and lower(a.role) in ('admin', 'instructor', 'indrumator')
          )
        )
        with check (
          exists (
            select 1 from public.accounts a
            where a.id = auth.uid() and lower(a.role) in ('admin', 'instructor', 'indrumator')
          )
        )
    $policy$, question_table);

    execute format('drop policy if exists "Reviewers can delete questions" on public.%I', question_table);
    execute format($policy$
      create policy "Reviewers can delete questions"
        on public.%I
        for delete
        to authenticated
        using (
          exists (
            select 1 from public.accounts a
            where a.id = auth.uid() and lower(a.role) in ('admin', 'instructor', 'indrumator')
          )
        )
    $policy$, question_table);
  end loop;
end $$;
