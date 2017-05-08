DROP TABLE IF EXISTS Vente ;
DROP TABLE IF EXISTS Reservation ;
DROP TABLE IF EXISTS Interne ;
DROP TABLE IF EXISTS Externe ;
DROP TABLE IF EXISTS Subvention ;
DROP TABLE IF EXISTS Depenses ;
DROP TABLE IF EXISTS Creation ;
DROP TABLE IF EXISTS Achat ;
DROP TABLE IF EXISTS Billeterie ;
DROP TABLE IF EXISTS Representation ;
DROP TABLE IF EXISTS Spectacle ;
DROP TABLE IF EXISTS Compagnie ;

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
	pol INTEGER CHECK (pol < 4 AND pol > 0),
	date_debut DATE CHECK (date_debut < date_representation),
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
	nom_mecene VARCHAR NOT NULL,
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

CREATE TABLE Billeterie (
	entree SERIAL PRIMARY KEY,
	date_entree DATE NOT NULL,
	tarif VARCHAR NOT NULL,
	prix REAL CHECK (prix > 0),
	id_representation INTEGER REFERENCES Representation
);

/*************************************/

/*
	Fonction qui applique les politiques tarifaires à l'achat d'un billet
*/
CREATE OR REPLACE FUNCTION politique(choix INTEGER, prix REAL, date_b DATE, date_f DATE, max INTEGER, n INTEGER) RETURNS REAL AS $$
DECLARE
	cur_date DATE = '2017-05-06';
BEGIN
	case
	WHEN choix = 1 THEN
		IF ((date_b + 5) >= cur_date) THEN
			return (prix - (prix*0.2));
		END IF;
		return prix;
	WHEN choix = 2 THEN
	 	IF ((date_f - 15) <= cur_date) THEN
			IF ((max - (max*0.3)) >= n) THEN
				return (prix - (prix*0.5));
			ELSIF ((max - (max*0.5)) >= n) THEN
				return (prix - (prix*0.3));
			ELSE
				return prix;
			END IF;
		END IF;
		return prix;
	ELSE
		IF ((max - (max*0.3)) >= n) THEN
			return (prix - (prix*0.2));
		END IF;
		return prix;
	END CASE;
END;
$$ LANGUAGE plpgsql;

/*************************************/

/*
	Fonction qui vérifie qu'il reste de la place
*/
CREATE OR REPLACE FUNCTION check_place() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-06';
		tmp INTEGER;
	BEGIN
		IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) <= 0 THEN
			DELETE FROM Reservation WHERE date_limite <= cur_date AND old.id_representation = Reservation.id_representation;
			SELECT COUNT(*) INTO tmp FROM Reservation WHERE old.id_representation = Reservation.id_representation;
			UPDATE Representation SET nb_places_reservees = tmp WHERE old.id_representation = id_representation;
			IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + new.nb_places_reservees)) <= 0 THEN
				RAISE NOTICE 'Plus de place';
				return null;
			END IF;
		END IF;
		return new;
	END;
$$ LANGUAGE plpgsql;

/*
	Avant avoir acheté un billet au tarif plein,
	on vérifie qu'il reste de la place
*/
CREATE TRIGGER achat_tarif_plein_bef
    BEFORE UPDATE OF nb_tarif_plein ON Representation
    FOR EACH ROW
    EXECUTE PROCEDURE check_place()
;

/*
	Avant avoir acheté un billet au tarif réduit,
	on vérifie qu'il reste de la place
*/
CREATE TRIGGER achat_tarif_reduit_bef
    BEFORE UPDATE OF nb_tarif_reduit ON Representation
    FOR EACH ROW
    EXECUTE PROCEDURE check_place()
;

/*************************************/

/*
	Fonction qui met à jour les comptes pour un billet à tarif plein
*/
CREATE OR REPLACE FUNCTION add_place_plein() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-06';
		p REAL;
    BEGIN
        IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) > 0  THEN
			SELECT tarif_plein INTO p FROM Spectacle WHERE old.id_spectacle = id_spectacle;
			UPDATE Representation
				SET gain = old.gain + politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees))
				WHERE id_representation = old.id_representation;
			UPDATE Spectacle SET rentabilite = rentabilite + politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) WHERE old.id_spectacle = spectacle.id_spectacle;
			INSERT INTO Billeterie(date_entree, tarif, prix, id_representation) VALUES (cur_date, 'tarif plein', politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)), old.id_representation);
        END IF;
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

/*************************************/

/*
	Fonction qui met à jour les comptes pour un billet à tarif réduit
*/
CREATE OR REPLACE FUNCTION add_place_reduit() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-06';
		p REAL;
    BEGIN
        IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) > 0  THEN
			SELECT tarif_reduit INTO p FROM Spectacle WHERE old.id_spectacle = id_spectacle;
			UPDATE Representation
				SET gain = old.gain + politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees))
				WHERE id_representation = old.id_representation;
			UPDATE Spectacle SET rentabilite = rentabilite + politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) WHERE old.id_spectacle = spectacle.id_spectacle;
			INSERT INTO Billeterie(date_entree, tarif, prix, id_representation) VALUES (cur_date, 'tarif reduit', politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)), old.id_representation);
        end if;
        return new;
    END;
$$ LANGUAGE plpgsql;

/*
	Après avoir acheté un billet au tarif reduit,
	on met à jour les comptes.
 */
CREATE TRIGGER achat_tarif_reduit_aft
    AFTER UPDATE OF nb_tarif_reduit ON Representation
    FOR EACH ROW
    EXECUTE PROCEDURE add_place_reduit()
;

/*************************************/

/*
	Fonction qui vérifie qu'il reste de la place et que la date est correcte
*/
CREATE OR REPLACE FUNCTION check_place_reservation() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-06';
		tmp INTEGER;
		limite INTEGER = 3;
	BEGIN
		IF ((cur_date + limite) > old.date_representation) THEN
			RAISE NOTICE 'Il est trop tard pour faire une réservation pour ce spectacle';
			return null;
		END IF;

		IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) <= 0 THEN
			DELETE FROM Reservation WHERE date_limite <= cur_date AND old.id_representation = Reservation.id_representation;
			SELECT COUNT(*) INTO tmp FROM Reservation WHERE old.id_representation = Reservation.id_representation;
			UPDATE Representation SET nb_places_reservees = tmp WHERE old.id_representation = id_representation;
			IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + new.nb_places_reservees)) <= 0 THEN
				RAISE NOTICE 'Plus de place';
				return null;
			END IF;
		END IF;
		return new;
	END;
$$ LANGUAGE plpgsql;

/*
	Avant de faire une réservation,
	on vérifie qu'il reste de la place.
	Ne s'active pas si lancé par un autre TRIGGER grâce à pg_trigger_depth
*/
CREATE TRIGGER make_reservation_bef
    BEFORE UPDATE OF nb_places_reservees ON Representation
    FOR EACH ROW
	WHEN (pg_trigger_depth() < 1)
    EXECUTE PROCEDURE check_place_reservation()
;

/*************************************/

/*
	Fonction qui ajoute une réservation pour une Representation
*/
CREATE OR REPLACE FUNCTION add_reservation() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-06';
		limite INTEGER = 3;
    BEGIN
		INSERT INTO Reservation(date_reservation, date_limite, id_representation) VALUES (cur_date, (cur_date + limite), old.id_representation);
		return new;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER make_reservation_aft
    AFTER UPDATE OF nb_places_reservees ON Representation
    FOR EACH ROW
	WHEN (pg_trigger_depth() < 1)
    EXECUTE PROCEDURE add_reservation()
;

CREATE OR REPLACE FUNCTION unmake_reservation() RETURNS TRIGGER AS $$
	BEGIN
		UPDATE Representation SET nb_places_reservees = nb_places_reservees - 1 WHERE id_representation = old.id_representation;
		return old;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER undo_reservation
	BEFORE DELETE ON Reservation
	FOR EACH ROW
	WHEN (pg_trigger_depth() < 1)
	EXECUTE PROCEDURE unmake_reservation()
;

/*************************************/

/*
	Fonction qui ajoute à la rentabilite d'un Spectacle, la valeur des subventions qu'il reçoit.
*/
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

/*
	Fonction qui gère la suppression et la modification d'une subvention
*/
CREATE OR REPLACE FUNCTION unmake_subvention() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT valeur INTO val FROM Subvention WHERE id_spectacle = old.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite - val WHERE id_spectacle = old.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER undo_subvention
	BEFORE UPDATE OR DELETE ON Subvention
	FOR EACH ROW
	EXECUTE PROCEDURE unmake_subvention()
;

/*************************************/

/*
	Fonction qui vérifie que la pièce vendue nous appartient.
*/
CREATE OR REPLACE FUNCTION check_appartenance() RETURNS TRIGGER AS $$
	BEGIN
		IF ((SELECT COUNT(*) FROM Achat WHERE id_spectacle = new.id_spectacle) > 0) THEN
			RAISE NOTICE 'On ne peut pas vendre un spectacle qui ne nous appartient pas.';
			return null;
		END IF;
		return new;
	END;
$$ LANGUAGE plpgsql;

/*
	On vérifie que l'on ne vend pas un spectacle qui ne nous appartient pas.
*/
CREATE TRIGGER do_vente_bef
	BEFORE INSERT ON Vente
	FOR EACH ROW
	EXECUTE PROCEDURE check_appartenance()
;


/*
	On ne fait pas de dépenses pour une pièce que l'on a acheté.
*/
CREATE TRIGGER do_depense_bef
	BEFORE INSERT ON Depenses
	FOR EACH ROW
	EXECUTE PROCEDURE check_appartenance()
;

/*************************************/

/*
	Fonction qui enlève à la rentabilite d'un Spectacle, la valeur des dépenses dont il est l'objet.
*/
CREATE OR REPLACE FUNCTION make_depense() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT cout INTO val FROM Depenses WHERE id_spectacle = new.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite - val WHERE id_spectacle = new.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER do_depense
	AFTER INSERT OR UPDATE ON Depenses
	FOR EACH ROW
	EXECUTE PROCEDURE make_depense()
;

/*
	Fonction qui gère la suppression et la modification d'une dépense
*/
CREATE OR REPLACE FUNCTION unmake_depense() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT cout INTO val FROM Depenses WHERE id_spectacle = old.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite + val WHERE id_spectacle = old.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER undo_depense
	BEFORE UPDATE OR DELETE ON Depenses
	FOR EACH ROW
	EXECUTE PROCEDURE unmake_depense()
;

/*************************************/

/*
	Fonction qui ajoute à la rentabilite d'un Spectacle, la valeur des ventes dont il est l'objet.
*/
CREATE OR REPLACE FUNCTION make_vente() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT valeur INTO val FROM Vente WHERE id_spectacle = new.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite + val WHERE id_spectacle = new.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER do_vente
	AFTER INSERT OR UPDATE ON Vente
	FOR EACH ROW
	EXECUTE PROCEDURE make_vente()
;

/*
	Fonction qui gère la suppression et la modification d'une vente
*/
CREATE OR REPLACE FUNCTION unmake_vente() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT valeur INTO val FROM Vente WHERE id_spectacle = old.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite - val WHERE id_spectacle = old.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER undo_vente
	BEFORE UPDATE OR DELETE ON Vente
	FOR EACH ROW
	EXECUTE PROCEDURE unmake_vente()
;

/*************************************/

/*
	Fonction qui soustrait à la rentabilite d'un Spectacle, la valeur d'achat dont il est l'objet.
*/
CREATE OR REPLACE FUNCTION make_achat() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT valeur INTO val FROM Achat WHERE id_spectacle = new.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite - val WHERE id_spectacle = new.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER do_achat
	AFTER INSERT OR UPDATE ON Achat
	FOR EACH ROW
	EXECUTE PROCEDURE make_achat()
;

/*
	Fonction qui gère la suppression et la modification d'un achat.
*/
CREATE OR REPLACE FUNCTION unmake_achat() RETURNS TRIGGER AS $$
	DECLARE
		val REAL;
	BEGIN
		SELECT valeur INTO val FROM Achat WHERE id_spectacle = old.id_spectacle;
		UPDATE Spectacle SET rentabilite = rentabilite + val WHERE id_spectacle = old.id_spectacle;
		return new;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER undo_vente
	BEFORE UPDATE OR DELETE ON Achat
	FOR EACH ROW
	EXECUTE PROCEDURE unmake_achat()
;
