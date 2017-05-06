DROP TABLE IF EXISTS Vente ;
DROP TABLE IF EXISTS Reservation ;
DROP TABLE IF EXISTS Interne ;
DROP TABLE IF EXISTS Externe ;
DROP TABLE IF EXISTS Subvention ;
DROP TABLE IF EXISTS Depenses ;
DROP TABLE IF EXISTS Creation ;
DROP TABLE IF EXISTS Achat ;
DROP TABLE IF EXISTS Representation ;
DROP TABLE IF EXISTS Spectacle ;
DROP TABLE IF EXISTS Compagnie ;
DROP TABLE IF EXISTS Historique ;

CREATE TABLE Spectacle (
	id_spectacle SERIAL PRIMARY KEY,
	nom_spectacle VARCHAR NOT NULL UNIQUE,
	tarif_plein REAL CHECK (tarif_plein > 0),
	tarif_reduit REAL CHECK ((tarif_reduit > 0) AND (tarif_plein >= tarif_reduit)),
	rentabilite REAL
);

CREATE TABLE Compagnie (
	id_compagnie SERIAL PRIMARY KEY,
	nom_compagnie VARCHAR NOT NULL UNIQUE,
	metteur_en_scene VARCHAR
);

CREATE TABLE Representation (
	id_representation SERIAL PRIMARY KEY,
	date_representation DATE NOT NULL,
	nb_places_max INTEGER CHECK (nb_places_max > 0),
	nb_tarif_plein INTEGER DEFAULT 0,
	nb_tarif_reduit INTEGER DEFAULT 0,
	nb_places_reservees INTEGER DEFAULT 0,
	duree INTEGER CHECK (duree > 0),
	gain REAL CHECK (gain >= 0),
	id_spectacle INTEGER REFERENCES Spectacle
);

CREATE TABLE Creation (
	id_spectacle INTEGER PRIMARY KEY REFERENCES Spectacle
);

CREATE TABLE Achat (
	id_spectacle INTEGER PRIMARY KEY REFERENCES Spectacle,
	date_achat DATE NOT NULL,
	valeur REAL NOT NULL CHECK (valeur > 0),
	id_compagnie INTEGER REFERENCES Compagnie
);

CREATE TABLE Vente (
	id_vente SERIAL PRIMARY KEY,
	date_vente DATE NOT NULL,
	valeur REAL CHECK (valeur > 0),
	id_spectacle INTEGER REFERENCES Spectacle,
	id_compagnie INTEGER REFERENCES Compagnie
);

CREATE TABLE Subvention (
	id_subvention SERIAL PRIMARY KEY,
	nom_mecene VARCHAR NOT NULL UNIQUE,
	valeur REAL CHECK (valeur > 0),
	id_spectacle INTEGER REFERENCES Spectacle
);

CREATE TABLE Depenses (
	id_depense SERIAL PRIMARY KEY,
	date_depense DATE NOT NULL,
	description VARCHAR NOT NULL,
	cout REAL CHECK (cout > 0),
	id_spectacle INTEGER REFERENCES Spectacle
);

CREATE TABLE Interne (
	id_representation INTEGER PRIMARY KEY REFERENCES Representation
);

CREATE TABLE Externe (
	id_representation INTEGER PRIMARY KEY REFERENCES Representation,
	lieu VARCHAR NOT NULL,
	ville VARCHAR NOT NULL,
	pays VARCHAR NOT NULL
);

CREATE TABLE Reservation (
	id_reservation SERIAL PRIMARY KEY,
	date_reservation DATE NOT NULL,
	date_limite DATE NOT NULL,
	id_representation INTEGER REFERENCES Representation
);

CREATE TABLE Historique (
	entree DATE PRIMARY KEY,
	depense REAL CHECK (depense >= 0),
	recette REAL CHECK (recette >= 0),
	total REAL
);

CREATE OR REPLACE FUNCTION politique(prix REAL) RETURNS REAL AS $$
BEGIN
    RETURN prix * 0.06;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE check_place_plein() RETURNS TRIGGER AS $$
	DECLARE
		cur_date = '2017-05-06';
	BEGIN
		IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) <= 0 THEN
			DELETE FROM Reservation WHERE old.date_limite = cur_date;
	END;
$$ LANGUAGE plpgsql;


/*
	Avant avoir acheté un billet au tarif plein,
	on vérifie qu'il reste de la place
*/
CREATE TRIGGER achat_tarif_plein_bef
    BEFORE UPDATE OF nb_tarif_plein ON Representation
    FOR EACH ROW
    EXECUTE PROCEDURE check_place_plein()
;

CREATE OR REPLACE FUNCTION add_place_plein() RETURNS TRIGGER AS $$
	DECLARE
		prix REAL;
    BEGIN
        IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) > 0  THEN
			SELECT tarif_plein INTO prix FROM representation JOIN spectacle ON old.id_spectacle = spectacle.id_spectacle;
			UPDATE Representation SET gain = old.gain + politique(prix);
			UPDATE Spectacle SET rentabilite = rentabilite + politique(prix) WHERE old.id_spectacle = spectacle.id_spectacle;
        end if;
        return new;
    END;
$$ LANGUAGE plpgsql;

/*
	Après avoir acheté un billet au tarif plein,
	on met à jour les comptes.
 */
CREATE TRIGGER achat_tarif_plein_aft
    AFTER UPDATE OF nb_tarif_plein ON Representation
    FOR EACH ROW
    EXECUTE PROCEDURE add_place_plein()
;







/*
CREATE TRIGGER achat_tarif_reduit
    BEFORE UPDATE OF nb_tarif_reduit ON Representation
    FOR EACH ROW
    EXECUTE PROCEDURE check_place_reduit()
;
*/

INSERT INTO Spectacle (nom_spectacle, tarif_plein, tarif_reduit, rentabilite)
VALUES
('test1', 2, 1, 0),
('test2', 2, 1, 0),
('test3', 2, 1, 0),
('test4', 2, 1, 0),
('test5', 2, 1, 0)
;

INSERT INTO Compagnie (nom_compagnie, metteur_en_scene)
VALUES
('Diderot', 'Denis')
;

INSERT INTO Creation(id_spectacle)
VALUES
(1),
(2)
;

INSERT INTO Achat(id_spectacle, date_achat, valeur, id_compagnie)
VALUES
(3, '2017-02-25', 300, 1)
;

INSERT INTO Representation(date_representation, nb_places_max, nb_tarif_plein, nb_tarif_reduit, nb_places_reservees, duree, gain, id_spectacle)
VALUES
('2017-03-03', 60, 0, 0, 0, 30, 0, 1)
;

UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_spectacle = 1;
