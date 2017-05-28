-- Script de test pour la politique tarifaire numéro 3 : -20% sur les 30% premiers billets vendus.


-- Insertion de notre représentation test pour la politique 1.
INSERT INTO Representation(pol, date_debut, date_representation, nb_places_max, nb_tarif_plein, nb_tarif_reduit, nb_places_reservees, duree, gain, id_spectacle)
VALUES (3, '2017-05-24', '2017-06-20', 100, 0, 0, 0, 90, 0, 1);


-- Affichage des informations sur la nouvelle représentation et le spectacle auxquel elle est lié.
SELECT * FROM Representation where id_representation = 23;
SELECT * FROM Spectacle where id_spectacle = 1;


-- Ajouts de tickets au tarif plein et réduit pour la nouvelle représentation crée.
-- quinze au tarif réduit.
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;


-- quinze autres au tarif plein.
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;


-- deux au tarif réduit.
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 23;


-- deux tarif plein.
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 23;


-- Affichage des billets achetés et de leur tarif respectifs en fonction des trente-quatre billets.
SELECT * FROM Representation where id_representation = 23;
SELECT * FROM Billetterie where id_representation = 23;
