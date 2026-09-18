-- Rulează acest script în Supabase SQL Editor înainte de a folosi categoria elevului.
-- Valorile sunt ID-uri stabile folosite de interfață și de funcțiile Netlify.

alter table public.accounts
  add column if not exists study_category text;

update public.accounts
set study_category = '2-3'
where study_category is null
  and role in ('student', 'participant');

alter table public.accounts
  alter column study_category set default '2-3';

alter table public.accounts
  drop constraint if exists accounts_study_category_check;

alter table public.accounts
  add constraint accounts_study_category_check
  check (study_category is null or study_category in ('2-3', '4-5', '6-7', '8-9', '10-11', '12-plus'));

alter table public.accounts
  drop constraint if exists accounts_student_study_category_required;

alter table public.accounts
  add constraint accounts_student_study_category_required
  check (role not in ('student', 'participant') or study_category is not null);
