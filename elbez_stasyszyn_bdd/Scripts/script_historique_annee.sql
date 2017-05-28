-- Script pour tester l'historique des recettes et dépenses par année

\i init.sql
\i script_politique1.sql
\i script_politique2.sql
\i script_politique3.sql
\i script_achats_plein.sql
SELECT annee_history(2017);
