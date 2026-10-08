-- Secure question/account tables and expose a small, RLS-aware review queue.
-- Applied to Supabase project pdkfqytododevpilpxet.

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;
grant usage on schema private to authenticated;

create or replace function private.current_role()
returns text
language sql
stable
security definer
set search_path = ''
as $function$
  select account.role
  from public.accounts as account
  where account.id = (select auth.uid())
  limit 1;
$function$;

alter function private.current_role() owner to postgres;
revoke all on function private.current_role() from public, anon, authenticated;
grant execute on function private.current_role() to authenticated;

revoke all on table public.accounts from public, anon, authenticated;
grant select on table public.accounts to authenticated;
grant all on table public.accounts to service_role;
alter table public.accounts enable row level security;

drop policy if exists accounts_select_own on public.accounts;
create policy accounts_select_own
  on public.accounts for select to authenticated
  using (id = (select auth.uid()));

drop policy if exists accounts_select_admin on public.accounts;
create policy accounts_select_admin
  on public.accounts for select to authenticated
  using ((select private.current_role()) = 'admin');

drop policy if exists accounts_select_students_for_instructors on public.accounts;
create policy accounts_select_students_for_instructors
  on public.accounts for select to authenticated
  using (
    (select private.current_role()) in ('instructor', 'indrumator')
    and role in ('student', 'participant')
  );

do $block$
declare
  question_table text;
begin
  foreach question_table in array array[
    'questions_tf',
    'questions_abc_one',
    'questions_abc_multi',
    'questions_match'
  ] loop
    execute format('revoke all on table public.%I from public, anon', question_table);
    execute format('grant select, insert, update, delete on table public.%I to authenticated', question_table);
    execute format('grant all on table public.%I to service_role', question_table);
    execute format('alter table public.%I enable row level security', question_table);

    execute format('drop policy if exists question_read_access on public.%I', question_table);
    execute format(
      'create policy question_read_access on public.%I for select to authenticated using (' ||
      ' (select private.current_role()) in (''admin'', ''instructor'', ''indrumator'')' ||
      ' or ((select private.current_role()) in (''student'', ''participant'') and status = ''active'')' ||
      ')',
      question_table
    );

    execute format('drop policy if exists question_staff_manage on public.%I', question_table);
    execute format(
      'create policy question_staff_manage on public.%I for all to authenticated using (' ||
      ' (select private.current_role()) in (''admin'', ''instructor'', ''indrumator'')' ||
      ') with check (' ||
      ' (select private.current_role()) in (''admin'', ''instructor'', ''indrumator'')' ||
      ')',
      question_table
    );
  end loop;
end;
$block$;

create or replace view public.question_review_queue
with (security_invoker = true)
as
  select
    'tf'::text as type,
    question.id,
    question.text,
    question.options,
    null::jsonb as pairs,
    question.chapter,
    question.difficulty,
    question.book,
    question.source_references,
    question.status,
    question.added_by,
    question.created_at::timestamptz as created_at,
    translate(lower(concat_ws(
      ' ', question.text, question.book, question.chapter::text, question.added_by,
      array_to_string(question.source_references, ' '), question.options::text
    )), 'ăâîșț', 'aaist') as search_text,
    (
      select min((regexp_match(reference.value, '^[0-9]+:([0-9]+)$'))[1]::integer)
      from unnest(coalesce(question.source_references, '{}'::text[])) as reference(value)
      where reference.value ~ '^[0-9]+:[0-9]+$'
    ) as sort_verse
  from public.questions_tf as question
  where question.status = 'pending_review'

  union all

  select
    'abc_one'::text, question.id, question.text, question.options, null::jsonb,
    question.chapter, question.difficulty, question.book, question.source_references,
    question.status, question.added_by, question.created_at::timestamptz,
    translate(lower(concat_ws(
      ' ', question.text, question.book, question.chapter::text, question.added_by,
      array_to_string(question.source_references, ' '), question.options::text
    )), 'ăâîșț', 'aaist'),
    (
      select min((regexp_match(reference.value, '^[0-9]+:([0-9]+)$'))[1]::integer)
      from unnest(coalesce(question.source_references, '{}'::text[])) as reference(value)
      where reference.value ~ '^[0-9]+:[0-9]+$'
    )
  from public.questions_abc_one as question
  where question.status = 'pending_review'

  union all

  select
    'abc_multi'::text, question.id, question.text, question.options, null::jsonb,
    question.chapter, question.difficulty, question.book, question.source_references,
    question.status, question.added_by, question.created_at::timestamptz,
    translate(lower(concat_ws(
      ' ', question.text, question.book, question.chapter::text, question.added_by,
      array_to_string(question.source_references, ' '), question.options::text
    )), 'ăâîșț', 'aaist'),
    (
      select min((regexp_match(reference.value, '^[0-9]+:([0-9]+)$'))[1]::integer)
      from unnest(coalesce(question.source_references, '{}'::text[])) as reference(value)
      where reference.value ~ '^[0-9]+:[0-9]+$'
    )
  from public.questions_abc_multi as question
  where question.status = 'pending_review'

  union all

  select
    'match'::text, question.id, null::text, null::jsonb, question.pairs,
    question.chapter, question.difficulty, question.book, question.source_references,
    question.status, question.added_by, question.created_at::timestamptz,
    translate(lower(concat_ws(
      ' ', question.book, question.chapter::text, question.added_by,
      array_to_string(question.source_references, ' '), question.pairs::text
    )), 'ăâîșț', 'aaist'),
    (
      select min((regexp_match(reference.value, '^[0-9]+:([0-9]+)$'))[1]::integer)
      from unnest(coalesce(question.source_references, '{}'::text[])) as reference(value)
      where reference.value ~ '^[0-9]+:[0-9]+$'
    )
  from public.questions_match as question
  where question.status = 'pending_review';

create or replace view public.question_review_books
with (security_invoker = true)
as
  select book from public.questions_tf where status = 'pending_review' and book is not null
  union
  select book from public.questions_abc_one where status = 'pending_review' and book is not null
  union
  select book from public.questions_abc_multi where status = 'pending_review' and book is not null
  union
  select book from public.questions_match where status = 'pending_review' and book is not null;

revoke all on table public.question_review_queue, public.question_review_books from public, anon, authenticated;
grant select on table public.question_review_queue, public.question_review_books to authenticated;
