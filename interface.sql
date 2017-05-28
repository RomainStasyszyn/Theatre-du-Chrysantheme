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
		cur_date DATE = '2017-05-28';
        n INTEGER;
    BEGIN
        SELECT COUNT(*) INTO n FROM Representation;
        for r IN 1..n LOOP
            DELETE FROM Reservation WHERE date_limite <= cur_date AND Reservation.id_representation = r;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_reservation() RETURNS TRIGGER AS $$
	DECLARE
		cur_date DATE = '2017-05-28';
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
