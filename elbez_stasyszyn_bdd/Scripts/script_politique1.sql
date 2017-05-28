-- Script de test pour la politique tarifaire numéro 1 : -20% sur les 5 premiers jours de vente.


-- Affichage des informations sur la nouvelle représentation et le spectacle auxquel elle est lié.
SELECT * FROM Representation where id_representation = 21;
SELECT * FROM Spectacle where id_spectacle = 1;


-- Ajouts de tickets au tarif plein et réduit pour la nouvelle représentation crée.
-- cinq au tarif réduit.
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 21;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 21;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 21;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 21;
UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 21;


-- cinq autres au tarif plein.
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 21;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 21;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 21;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 21;
UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 21;


-- Affichage des billets achetés et de leur tarif respectifs en fonction des trente-quatre billets.
SELECT * FROM Representation where id_representation = 21;
SELECT * FROM Billetterie where id_representation = 21;
