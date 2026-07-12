-- ============================================================
-- G2 CONNECT — table des alertes d'urgence (bouton ALERTE)
-- (à coller dans Supabase > SQL Editor > New query, puis "Run")
-- ============================================================

create table if not exists public.panic_events (
  id text primary key,
  name text,
  "agentId" text,
  created_at timestamptz default now()
);

alter table public.panic_events disable row level security;

grant select, insert, update, delete on public.panic_events to anon, authenticated;

alter publication supabase_realtime add table public.panic_events;
