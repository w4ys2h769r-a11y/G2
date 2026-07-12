-- ============================================================
-- G2 CONNECT — table des codes d'accès des résidences
-- (à coller dans Supabase > SQL Editor > New query, puis "Run")
-- ============================================================

create table if not exists public.codes (
  id text primary key,
  commune text not null,
  adresse text not null,
  code text
);

alter table public.codes disable row level security;

grant select, insert, update, delete on public.codes to anon, authenticated;

alter publication supabase_realtime add table public.codes;
