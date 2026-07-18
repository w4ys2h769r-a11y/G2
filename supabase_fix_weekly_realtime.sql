-- ============================================================
-- G2 CONNECT — activation du Realtime sur la table "weekly"
-- (à coller dans Supabase > SQL Editor > New query, puis "Run")
-- Corrige le bug : le planning hebdomadaire n'apparaît pas
-- immédiatement sur les autres profils tant qu'ils ne
-- rechargent pas la page.
-- ============================================================

alter publication supabase_realtime add table public.weekly;
