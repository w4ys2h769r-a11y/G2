-- ============================================================
-- G2 CONNECT — forcer le rechargement du cache de schéma PostgREST
-- (à exécuter après TOUT ajout/modification de colonne via SQL,
-- si l'API renvoie "Could not find the 'X' column ... in the
-- schema cache" alors que la colonne existe bien dans la table)
-- ============================================================

NOTIFY pgrst, 'reload schema';
