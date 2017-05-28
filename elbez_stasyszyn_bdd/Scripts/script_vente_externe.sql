-- Script testant l'impossibilité de vendre une pièce qui ne nous appartient pas.


SELECT * FROM Achat;


INSERT INTO Vente(date_vente, valeur, id_spectacle, id_compagnie)
VALUES
('2017-02-15', 50000, 3, 3)
;


-- Ici on vend une pièce qui nous appartient.

SELECT * FROM Vente;
SELECT * FROM Spectacle where id_spectacle=2;


INSERT INTO Vente(date_vente, valeur, id_spectacle, id_compagnie)
VALUES
('2017-02-15', 50000, 2, 3)
;


SELECT * FROM Vente;
SELECT * FROM Spectacle where id_spectacle=2;
