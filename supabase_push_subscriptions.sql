-- ============================================================
-- G2 CONNECT — table des abonnements aux notifications push
-- (à coller dans Supabase > SQL Editor > New query, puis "Run")
-- ============================================================

create table if not exists public.push_subscriptions (
  id text primary key,
  "agentId" text,
  endpoint text not null unique,
  p256dh text not null,
  auth text not null,
  created_at timestamptz default now()
);

alter table public.push_subscriptions disable row level security;

grant select, insert, update, delete on public.push_subscriptions to anon, authenticated;
