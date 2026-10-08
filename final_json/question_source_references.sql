-- Run this migration once in the Supabase SQL Editor before saving questions
-- that include one or more explicit Bible verse references.
alter table public.questions_tf
  add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one
  add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi
  add column if not exists source_references text[] not null default '{}';

alter table public.questions_match
  add column if not exists source_references text[] not null default '{}';
