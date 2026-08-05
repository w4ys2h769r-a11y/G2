-- Affiche toutes les lignes "MAD" et "AFD routier" enregistrées en août 2026,
-- pour identifier quelle(s) date(s) contiennent les valeurs qui faussent le total du mois.
select date, type, count, "agentId", created_at
from public.chiffres
where date >= '2026-08-01' and date <= '2026-08-31'
  and (type like 'mad|%' or type like 'afd|Défaut%')
order by date, type;
