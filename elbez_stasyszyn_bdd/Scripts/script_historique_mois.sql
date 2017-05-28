-- Script pour tester l'historique des recettes et dépenses par périodes

\i init.sql
\i script_politique1.sql
\i script_politique2.sql
\i script_politique3.sql
\i script_achats_plein.sql
SELECT mois_history(06, 2017);
