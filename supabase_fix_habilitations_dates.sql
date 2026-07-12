-- ============================================================
-- G2 CONNECT — correction des dates d'expiration déjà enregistrées
-- (à coller dans Supabase > SQL Editor > New query, puis "Run")
--
-- Ne touche que les habilitations concernées par les erreurs de durée :
-- PIE et UMP9 passent à 3 ans, COUGAR n'expire plus jamais (99 ans).
-- La date d'obtention n'est pas modifiée, seule l'expiration est recalculée.
-- ============================================================

update public.habilitations
set "dateExpiration" = ("dateObtention"::date + interval '3 years')::date::text
where type = 'PIE';

update public.habilitations
set "dateExpiration" = ("dateObtention"::date + interval '3 years')::date::text
where type = 'UMP9';

update public.habilitations
set "dateExpiration" = ("dateObtention"::date + interval '99 years')::date::text
where type = 'COUGAR';
