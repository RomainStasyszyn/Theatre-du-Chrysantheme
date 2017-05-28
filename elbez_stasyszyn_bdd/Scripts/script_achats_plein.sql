SELECT * FROM Representation where id_representation=24;

-- Ajouts de tickets au tarif plein et réduit pour la nouvelle représentation crée.
-- cinq au tarif réduit.
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 24;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 24;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 24;
--UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 24;
--UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 24;


-- trois autres au tarif plein.
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 24;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 24;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 24;


-- deux réservations.
UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = 24;
UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = 24;
UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = 24;
UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = 24;


-- Essais d'achat une fois plein.
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 24;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 24;
UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = 24;


-- Affichage des billets achetés et de leur tarif respectifs en fonction des trente-quatre billets.
SELECT * FROM Representation where id_representation = 24;
SELECT * FROM Billetterie where id_representation = 24;
SELECT * FROM Reservation where id_representation = 24;
