-- Création de la base des tables.
\i base.sql

-- Mise en place des triggers et des fonctions associées.
\i interface.sql

-- Insertion des données de bases.
\i insert.sql

-- Nettoyer la base
SELECT clean();

-- Insertion des tuples sur lesquels sont basés les tests.
\i insertions_tests.sql
