--  Script testant qu'on ne peut faire une dépense pour un spectacle acheté.

SELECT * FROM Depenses;


INSERT INTO Depenses(date_depense, description, cout, id_spectacle)
VALUES
('2015-09-22', 'Costumes & Décors', 15000, 3);


SELECT * FROM Depenses;


-- Ici on teste que l'on fait bien une dépense pour un spectacle qui nous appartient.

SELECT * FROM Spectacle where id_spectacle=2;


INSERT INTO Depenses(date_depense, description, cout, id_spectacle)
VALUES
('2015-09-22', 'Costumes & Décors', 15000, 2);


SELECT * FROM Depenses;
SELECT * FROM Spectacle where id_spectacle=2;
