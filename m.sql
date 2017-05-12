
DROP TABLE IF EXISTS Subvention ;
DROP TABLE IF EXISTS Spectacle ;

CREATE TABLE Spectacle (
	id_spectacle SERIAL PRIMARY KEY,
	nom_spectacle VARCHAR NOT NULL UNIQUE,
	tarif_plein REAL CHECK (tarif_plein > 0),
	tarif_reduit REAL CHECK ((tarif_reduit > 0) AND (tarif_plein >= tarif_reduit)),
	rentabilite REAL
);

CREATE TABLE Subvention (
	id_subvention SERIAL PRIMARY KEY,
	nom_mecene VARCHAR NOT NULL,
	valeur REAL CHECK (valeur > 0),
	id_spectacle INTEGER REFERENCES Spectacle
);

CREATE OR REPLACE FUNCTION make_subvention() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT valeur INTO val FROM Subvention WHERE id_spectacle = new.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite + val WHERE id_spectacle = new.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER do_subvention
	AFTER INSERT OR UPDATE ON Subvention
	FOR EACH ROW
	EXECUTE PROCEDURE make_subvention()
;

CREATE OR REPLACE FUNCTION unmake_subvention() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT valeur INTO val FROM Subvention WHERE id_spectacle = new.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite - val WHERE id_spectacle = new.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER undo_subvention
	BEFORE UPDATE OR DELETE ON Subvention
	FOR EACH ROW
	EXECUTE PROCEDURE unmake_subvention()
;

INSERT INTO Spectacle (nom_spectacle, tarif_plein, tarif_reduit, rentabilite)
VALUES
('test1', 2, 1, 0),
('test2', 2, 1, 0),
('test3', 2, 1, 0),
('test4', 2, 1, 0),
('test5', 2, 1, 0)
;


INSERT INTO Subvention(nom_mecene, valeur, id_spectacle) VALUES ('paul', 300, 1);
UPDATE Subvention SET valeur = 200 where id_subvention = 1;
INSERT INTO Subvention(nom_mecene, valeur, id_spectacle) VALUES ('paul', 100, 2);
