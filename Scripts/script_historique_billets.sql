-- Script pour tester l'historique des billets vendus

\i init.sql
\i script_politique1.sql
\i script_politique2.sql
\i script_politique3.sql
\i script_achats_plein.sql
SELECT tickets_history();
