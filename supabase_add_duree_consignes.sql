-- ============================================================
-- G2 CONNECT — ajout du délai de parution sur les consignes
-- (à coller dans Supabase > SQL Editor > New query, puis "Run")
-- ============================================================

alter table public.consignes
  add column if not exists duree text default 'permanente';

alter table public.consignes
  add column if not exists "dateExpiration" date;
