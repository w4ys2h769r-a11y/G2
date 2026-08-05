-- Supprime toutes les lignes "Chiffres" du 4 août 2026 (données de test identifiées).
-- ATTENTION : irréversible. Vérifiez la date avant d'exécuter.
delete from public.chiffres
where date = '2026-08-04';
