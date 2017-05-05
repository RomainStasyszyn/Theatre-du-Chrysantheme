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
	tarif_plein INTEGER CHECK (tarif_plein > 0),
	tarif_reduit INTEGER CHECK ((tarif_reduit > 0) AND (tarif_plein >= tarif_reduit)),
	rentabilite INTEGER
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
	nb_place_vendues INTEGER DEFAULT 0,
	nb_places_reservees INTEGER DEFAULT 0,
	duree INTEGER CHECK (duree > 0),
	id_spectacle INTEGER REFERENCES Spectacle
);

CREATE TABLE Creation (
	id_spectacle INTEGER PRIMARY KEY REFERENCES Spectacle
);

CREATE TABLE Achat (
	id_spectacle INTEGER PRIMARY KEY REFERENCES Spectacle,
	date_achat DATE NOT NULL,
	valeur INTEGER NOT NULL CHECK (valeur > 0),
	id_compagnie INTEGER REFERENCES Compagnie
);

CREATE TABLE Vente (
	id_vente SERIAL PRIMARY KEY,
	date_vente DATE NOT NULL,
	valeur INTEGER CHECK (valeur > 0),
	id_spectacle INTEGER REFERENCES Spectacle,
	id_compagnie INTEGER REFERENCES Compagnie
);

CREATE TABLE Subvention (
	id_subvention SERIAL PRIMARY KEY,
	nom_mecene VARCHAR NOT NULL UNIQUE,
	valeur INTEGER CHECK (valeur > 0),
	id_spectacle INTEGER REFERENCES Spectacle
);

CREATE TABLE Depenses (
	id_depense SERIAL PRIMARY KEY,
	date_depense DATE NOT NULL,
	description VARCHAR NOT NULL,
	cout INTEGER CHECK (cout > 0),
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
	depense INTEGER CHECK (depense >= 0),
	recette INTEGER CHECK (recette >= 0),
	total INTEGER
);

INSERT INTO Spectacle (nom_spectacle, tarif_plein, tarif_reduit, rentabilite) VALUES
('test1', 2, 1, 0),
('test2', 2, 1, 0),
('test3', 2, 1, 0),
('test4', 2, 1, 0),
('test5', 2, 1, 0)
;

INSERT INTO Compagnie (nom_compagnie, metteur_en_scene) VALUES ('Diderot', 'Denis') ;

INSERT INTO Creation(id_spectacle) VALUES
(1),
(2)
;

INSERT INTO Achat(id_spectacle, date_achat, valeur, id_compagnie) VALUES
(3, '2017-02-25', 300, 1)
;
