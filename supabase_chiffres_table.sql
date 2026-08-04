-- ============================================================
-- G2 CONNECT — table des chiffres (statistiques d'infractions)
-- (à coller dans Supabase > SQL Editor > New query, puis "Run")
-- ============================================================

create table if not exists public.chiffres (
  id text primary key,
  date date not null,
  type text not null,
  count integer not null default 0,
  "agentId" text,
  created_at timestamptz default now()
);

alter table public.chiffres disable row level security;

grant select, insert, update, delete on public.chiffres to anon, authenticated;

alter publication supabase_realtime add table public.chiffres;

-- Recharge le cache de schéma PostgREST pour que la nouvelle table
-- soit immédiatement reconnue par l'API (évite l'erreur
-- "Could not find the table 'chiffres' in the schema cache")
NOTIFY pgrst, 'reload schema';
