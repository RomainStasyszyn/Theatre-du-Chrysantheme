/*

Montre qu'il n'est pas possible d'insérer une représentation externe qui est
déjà interne ou qui n'a pas été vendu.

*/


SELECT * FROM Interne;
SELECT * FROM Externe;

INSERT INTO Externe(id_representation, lieu, ville, pays)
VALUES
(19, 'Théâtre Icare', 'Paris', 'France')
;
