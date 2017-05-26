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
