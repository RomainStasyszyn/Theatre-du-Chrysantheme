-- Script pour tester l'historique des gains, recettes et dépenses par spectacle

\i init.sql
\i script_politique1.sql
\i script_politique2.sql
\i script_politique3.sql
\i script_achats_plein.sql
SELECT gains_representation_history();
