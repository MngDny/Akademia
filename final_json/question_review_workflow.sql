-- Supports the instructor review queue and keeps student-facing lookups fast.
-- Generated questions use status='pending_review' until an instructor approves them.
create index if not exists questions_tf_status_created_at_idx
  on public.questions_tf (status, created_at);

create index if not exists questions_abc_one_status_created_at_idx
  on public.questions_abc_one (status, created_at);

create index if not exists questions_abc_multi_status_created_at_idx
  on public.questions_abc_multi (status, created_at);

create index if not exists questions_match_status_created_at_idx
  on public.questions_match (status, created_at);
