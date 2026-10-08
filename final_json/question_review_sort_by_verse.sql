-- Add a numeric reference sort key to the review queue.
-- Questions are ordered by book, chapter, then their earliest referenced verse.

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
