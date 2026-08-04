-- ============================================================
-- G2 CONNECT — table OP (registre chronologique des télégrammes)
-- (à coller dans Supabase > SQL Editor > New query, puis "Run")
-- ============================================================

create table if not exists public.op (
  id text primary key,
  "numeroTelegramme" text,
  date date not null,
  objet text not null,
  "agentId" text,
  created_at timestamptz default now()
);

alter table public.op disable row level security;

grant select, insert, update, delete on public.op to anon, authenticated;

alter publication supabase_realtime add table public.op;

-- Recharge le cache de schéma PostgREST pour que la nouvelle table
-- soit immédiatement reconnue par l'API
NOTIFY pgrst, 'reload schema';
