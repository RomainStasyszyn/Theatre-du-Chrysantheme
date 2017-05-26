/*

Montre qu'il n'est pas possible d'insérer une représentation externe qui est
déjà interne ou qui n'a pas été vendu.

*/

INSERT INTO Interne(id_representation)
VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(20)
;

INSERT INTO Externe(id_representation, lieu, ville, pays)
VALUES
(19, 'Théâtre Icare', 'Paris', 'France')
;
