-- Remove the mutable search_path warning without changing the trigger body.
alter function public.set_updated_at() set search_path = '';
