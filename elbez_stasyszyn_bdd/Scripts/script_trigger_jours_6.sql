/**********************************************************************************************
		  CHANGEMENT DE LA DATE COURANTE DANS LES FONCTIONS POUR POLITIQUE 1
**********************************************************************************************/


/*
	Fonction qui applique les politiques tarifaires à l'achat d'un billet
*/
CREATE OR REPLACE FUNCTION politique(choix INTEGER, prix REAL, date_b DATE, date_f DATE, max INTEGER, n INTEGER) RETURNS REAL AS $$
DECLARE
	cur_date DATE = '2017-05-29';
BEGIN
	CASE
	WHEN choix = 1 THEN
		IF ((date_b + 5) > cur_date) THEN
			return (prix - (prix*0.2));
		END IF;
		return prix;
	WHEN choix = 2 THEN
	 	IF ((date_f - 15) <= cur_date) THEN
			IF ((max - (max*0.7)) >= n) THEN
				return (prix - (prix*0.5));
			ELSIF ((max - (max*0.5)) >= n) THEN
				return (prix - (prix*0.3));
			ELSE
				return prix;
			END IF;
		END IF;
		return prix;
	ELSE
		IF ((max - ((max*0.7)+1)) >= n) THEN
			return (prix - (prix*0.2));
		END IF;
		return prix;
	END CASE;
END;
$$ LANGUAGE plpgsql;


/*
	Fonction qui met à jour les comptes pour un billet à tarif plein
*/
CREATE OR REPLACE FUNCTION add_place_plein() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-29';
		p REAL;
    BEGIN
        IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) > 0  THEN
			SELECT tarif_plein INTO p FROM Spectacle WHERE old.id_spectacle = id_spectacle;
			UPDATE Representation
				SET gain = old.gain + politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees))
				WHERE id_representation = old.id_representation;
			UPDATE Spectacle SET rentabilite = rentabilite + politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) WHERE old.id_spectacle = spectacle.id_spectacle;
			INSERT INTO Billetterie(date_entree, tarif, prix, id_representation) VALUES (cur_date, 'tarif plein', politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)), old.id_representation);
        END IF;
        return new;
    END;
$$ LANGUAGE plpgsql;


/*
	Fonction qui met à jour les comptes pour un billet à tarif réduit
*/
CREATE OR REPLACE FUNCTION add_place_reduit() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-29';
		p REAL;
    BEGIN
        IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) > 0  THEN
			SELECT tarif_reduit INTO p FROM Spectacle WHERE old.id_spectacle = id_spectacle;
			UPDATE Representation
				SET gain = old.gain + politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees))
				WHERE id_representation = old.id_representation;
			UPDATE Spectacle SET rentabilite = rentabilite + politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) WHERE old.id_spectacle = spectacle.id_spectacle;
			INSERT INTO Billetterie(date_entree, tarif, prix, id_representation) VALUES (cur_date, 'tarif reduit', politique(old.pol, p, old.date_debut, old.date_representation, old.nb_places_max, (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)), old.id_representation);
        end if;
        return new;
    END;
$$ LANGUAGE plpgsql;


/*
	Fonction qui vérifie qu'il reste de la place et que la date est correcte
*/
CREATE OR REPLACE FUNCTION check_place_reservation() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-29';
		tmp INTEGER;
		limite INTEGER = 3;
	BEGIN
		IF ((cur_date + limite) > old.date_representation) THEN
			RAISE EXCEPTION 'Il est trop tard pour faire une réservation pour ce spectacle';
			return null;
		END IF;

		IF (old.nb_places_max - (old.nb_tarif_plein + old.nb_tarif_reduit + old.nb_places_reservees)) <= 0 THEN
			RAISE EXCEPTION 'Plus de place';
			return null;
		END IF;
		return new;
	END;
$$ LANGUAGE plpgsql;


/*
	Fonction qui ajoute une réservation pour une Representation
*/
CREATE OR REPLACE FUNCTION add_reservation() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-29';
		limite INTEGER = 3;
    BEGIN
		INSERT INTO Reservation(date_reservation, date_limite, id_representation) VALUES (cur_date, (cur_date + limite), old.id_representation);
		return new;
    END;
$$ LANGUAGE plpgsql;


/*
    Fonction qui nettoie la base de données
*/
CREATE OR REPLACE FUNCTION clean() RETURNS VOID AS $$
	DECLARE
		cur_date DATE = '2017-05-29';
        n INTEGER;
    BEGIN
        SELECT COUNT(*) INTO n FROM Representation;
        for r IN 1..n LOOP
            DELETE FROM Reservation WHERE date_limite < cur_date AND Reservation.id_representation = r;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_reservation() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-29';
		p INTEGER;
    BEGIN
        SELECT COUNT(*) INTO p FROM Reservation WHERE Reservation.id_representation = old.id_representation;
        UPDATE Representation SET nb_places_reservees = p WHERE id_representation = old.id_representation;
        return new;
    END;
$$ LANGUAGE plpgsql;
