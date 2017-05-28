SELECT * FROM Spectacle where id_spectacle=11;

SELECT * FROM Subvention;

INSERT INTO Subvention(nom_mecene, valeur, id_spectacle)
VALUES
    ('Ministère de la Culture', 50000, 11);
INSERT INTO Subvention(nom_mecene, valeur, id_spectacle)
VALUES
    ('Ministère de la Culture', 30000, 11);

SELECT * FROM Spectacle where id_spectacle=11;

SELECT * FROM Subvention;
