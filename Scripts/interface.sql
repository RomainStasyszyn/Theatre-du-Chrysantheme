/*
	Fonction pour afficher les tournées des spectacles
*/
CREATE OR REPLACE FUNCTION lieux_spectacles() RETURNS VOID AS $$
	DECLARE
		ligne_spectacle Spectacle%ROWTYPE;
		ligne_representation Representation%ROWTYPE;
		ligne_representation_externe Externe%ROWTYPE;
	BEGIN
		FOR ligne_spectacle IN SELECT * FROM Spectacle
		LOOP
			FOR ligne_representation IN SELECT * FROM Representation where id_spectacle=ligne_spectacle.id_spectacle
			LOOP
				FOR ligne_representation_externe IN SELECT * FROM Externe where id_representation=ligne_representation.id_representation
				LOOP
					RAISE NOTICE 'Nom spectacle : % --- id representation : % --- Date representation : % --- Lieu : % --- Ville : % --- Pays : %', ligne_spectacle.nom_spectacle, ligne_representation.id_representation, ligne_representation.date_representation, ligne_representation_externe.lieu, ligne_representation_externe.ville, ligne_representation_externe.pays;
				END LOOP;
			END LOOP;
		END LOOP;
	RETURN;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mois_history(mois INTEGER, annee INTEGER) RETURNS VOID AS $$
	DECLARE
	ligne_representation Representation%ROWTYPE;
	ligne_depenses Depenses%ROWTYPE;
	depenses REAL = 0;
	recettes REAL = 0;
	spectacle_courant VARCHAR;
	spectacle_courant_depenses VARCHAR;
	annee_dep INTEGER;
	mois_dep INTEGER;
	annee_repr INTEGER;
	mois_repr INTEGER;
	BEGIN
		FOR ligne_representation IN SELECT * FROM Representation
		LOOP
			annee_repr = EXTRACT(YEAR FROM ligne_representation.date_representation);
			mois_repr = EXTRACT(MONTH FROM ligne_representation.date_representation);
			IF annee_repr=annee AND mois_repr=mois THEN
				SELECT nom_spectacle INTO spectacle_courant FROM Spectacle where ligne_representation.id_spectacle=id_spectacle;
				recettes = recettes + ligne_representation.gain;
				RAISE NOTICE 'Annee : % --- Mois : % --- Nom spectacle : % --- Representation numero : % --- recettes : %',annee_repr, mois_repr, spectacle_courant, ligne_representation.id_representation, ligne_representation.gain;
			END IF;
		END LOOP;
		FOR ligne_depenses IN SELECT * FROM Depenses
		LOOP
			annee_dep = EXTRACT(YEAR FROM ligne_depenses.date_depense);
			mois_dep = EXTRACT(MONTH FROM ligne_depenses.date_depense);
			IF annee_dep=annee AND mois_dep=mois THEN
				SELECT nom_spectacle INTO spectacle_courant_depenses FROM Spectacle where ligne_depenses.id_spectacle=id_spectacle;
				depenses = depenses + ligne_depenses.cout;
				RAISE NOTICE 'Annee : % --- Mois : % --- Nom spectacle : % --- depense : %', annee, mois, spectacle_courant_depenses, ligne_depenses.cout;
			END IF;
		END LOOP;
		RAISE NOTICE 'Recettes totales : % --- Depenses totales : %', recettes, depenses;
		RETURN;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION annee_history(annee INTEGER) RETURNS VOID AS $$
	DECLARE
	ligne_representation Representation%ROWTYPE;
	ligne_depenses Depenses%ROWTYPE;
	depenses REAL = 0;
	recettes REAL = 0;
	spectacle_courant VARCHAR;
	spectacle_courant_depenses VARCHAR;
	annee_dep INTEGER;
	annee_repr INTEGER;
	BEGIN
		FOR ligne_representation IN SELECT * FROM Representation
		LOOP
			annee_repr = EXTRACT(YEAR FROM ligne_representation.date_representation);
			IF annee_repr=annee THEN
				SELECT nom_spectacle INTO spectacle_courant FROM Spectacle where ligne_representation.id_spectacle=id_spectacle;
				recettes = recettes + ligne_representation.gain;
				RAISE NOTICE 'Annee : % --- Nom spectacle : % --- Representation numero : % --- recettes : %',annee_repr, spectacle_courant, ligne_representation.id_representation, ligne_representation.gain;
			END IF;
		END LOOP;
		FOR ligne_depenses IN SELECT * FROM Depenses
		LOOP
			annee_dep = EXTRACT(YEAR FROM ligne_depenses.date_depense);
			IF annee_dep=annee THEN
				SELECT nom_spectacle INTO spectacle_courant_depenses FROM Spectacle where ligne_depenses.id_spectacle=id_spectacle;
				depenses = depenses + ligne_depenses.cout;
				RAISE NOTICE 'Annee : % --- Nom spectacle : % --- depense : %', annee, spectacle_courant_depenses, ligne_depenses.cout;
			END IF;
		END LOOP;
		RAISE NOTICE 'Recettes totales : % --- Depenses totales : %', recettes, depenses;
		RETURN;
	END;
$$ LANGUAGE plpgsql;


/*
	Fonction pour l'historique des gains par représentation
*/
CREATE OR REPLACE FUNCTION gains_representation_history() RETURNS VOID AS $$
	DECLARE
		ligne_spectacle Spectacle%ROWTYPE;
		ligne_representation Representation%ROWTYPE;
		ligne_depenses Depenses%ROWTYPE;
		depenses REAL = 0;
		recettes REAL = 0;
	BEGIN
		FOR ligne_spectacle IN SELECT * FROM Spectacle
		LOOP
			FOR ligne_depenses IN SELECT * FROM Depenses where id_spectacle=ligne_spectacle.id_spectacle
			LOOP
				depenses = depenses + ligne_depenses.cout;
				RAISE NOTICE 'Nom spectacle : % --- depense : %', ligne_spectacle.nom_spectacle, ligne_depenses.cout;
			END LOOP;
			FOR ligne_representation IN SELECT * FROM Representation where id_spectacle=ligne_spectacle.id_spectacle
			LOOP
				recettes = recettes + ligne_representation.gain;
				RAISE NOTICE 'Nom spectacle : % --- Representation numero : % --- recettes : %', ligne_spectacle.nom_spectacle, ligne_representation.id_representation, ligne_representation.gain;
			END LOOP;
			RAISE NOTICE 'Recettes totales : % --- Depenses totales : % --- Gains totaux : %', recettes, depenses, ligne_spectacle.rentabilite;
			depenses = 0;
			recettes = 0;
		END LOOP;
		RETURN;
	END;
$$ LANGUAGE plpgsql;


/*
	Fonction pour l'historique des billets vendus
*/
CREATE OR REPLACE FUNCTION tickets_history() RETURNS VOID AS $$
	DECLARE
		ligne Representation%ROWTYPE;
		spectacle Spectacle%ROWTYPE;
		ligne_billetterie Billetterie%ROWTYPE;
		tp VARCHAR = 'tarif plein';
	BEGIN
		FOR ligne IN SELECT * FROM Representation
		LOOP
			SELECT * INTO spectacle FROM Spectacle where id_spectacle=ligne.id_spectacle;
			RAISE NOTICE 'Spectacle : % --- Date représentation : % --- Tarifs pleins : % --- Tarifs réduits : % --- Tarif plein de base : % --- Tarif reduit de base : %',spectacle.nom_spectacle,ligne.date_representation, ligne.nb_tarif_plein, ligne.nb_tarif_reduit, spectacle.tarif_plein, spectacle.tarif_reduit;
			FOR ligne_billetterie IN SELECT * FROM Billetterie where id_representation=ligne.id_representation
			LOOP
				IF ligne_billetterie.tarif = tp THEN
					RAISE NOTICE 'Prix (tarif plein) : %', ligne_billetterie.prix;
				ELSE
					RAISE NOTICE 'Prix (tarif reduit) : %', ligne_billetterie.prix;
				END IF;
			END LOOP;
		END LOOP;
		RETURN;
	END;
$$ LANGUAGE plpgsql;


/*
	Fonction qui permet d'acheter n places au tarif plein
*/
CREATE OR REPLACE FUNCTION buyFullPrice(n INTEGER, i INTEGER) RETURNS VOID AS $$
DECLARE
	r INTEGER;
BEGIN
	FOR r IN 1..n LOOP
		UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = i;
	END LOOP;
	RETURN;
END;
$$ LANGUAGE plpgsql;


/*
	Fonction qui permet d'acheter n places au tarif reduit
*/
CREATE OR REPLACE FUNCTION buyHalfPrice(n INTEGER, i INTEGER) RETURNS VOID AS $$
DECLARE
	r INTEGER;
BEGIN
	FOR r IN 1..n LOOP
		UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = i;
	END LOOP;
	RETURN;
END;
$$ LANGUAGE plpgsql;

/*
	Fonction qui permet de faire n réservations
*/
CREATE OR REPLACE FUNCTION multipleReservation(n INTEGER, i INTEGER) RETURNS VOID AS $$
DECLARE
	r INTEGER;
BEGIN
	FOR r IN 1..n LOOP
		UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = i;
	END LOOP;
	RETURN;
END;
$$ LANGUAGE plpgsql;



/*
    Fonction qui nettoie la base de données
*/
CREATE OR REPLACE FUNCTION clean() RETURNS VOID AS $$
	DECLARE
		cur_date DATE = '2017-05-24';
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
		cur_date DATE = '2017-05-24';
		p INTEGER;
    BEGIN
        SELECT COUNT(*) INTO p FROM Reservation WHERE Reservation.id_representation = old.id_representation;
        UPDATE Representation SET nb_places_reservees = p WHERE id_representation = old.id_representation;
        return new;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER aft_clean
    AFTER DELETE ON Reservation
    FOR EACH ROW
    EXECUTE PROCEDURE update_reservation()
;
