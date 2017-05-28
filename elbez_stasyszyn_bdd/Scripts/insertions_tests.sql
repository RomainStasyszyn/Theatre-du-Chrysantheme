-- TUPLES QUI NOUS SERVENT POUR LES REPRESENTATIONS TESTS.


-- Insertion de notre représentation test pour la politique 1.
INSERT INTO Representation(pol, date_debut, date_representation, nb_places_max, nb_tarif_plein, nb_tarif_reduit, nb_places_reservees, duree, gain, id_spectacle)
VALUES (1, '2017-05-24', '2017-06-24', 100, 0, 0, 0, 90, 0, 1);


-- Insertion de notre représentation test pour la politique 2.
INSERT INTO Representation(pol, date_debut, date_representation, nb_places_max, nb_tarif_plein, nb_tarif_reduit, nb_places_reservees, duree, gain, id_spectacle)
VALUES (2, '2017-05-24', '2017-06-24', 100, 0, 0, 0, 90, 0, 1);


-- Insertion de notre représentation test pour la politique 3.
INSERT INTO Representation(pol, date_debut, date_representation, nb_places_max, nb_tarif_plein, nb_tarif_reduit, nb_places_reservees, duree, gain, id_spectacle)
VALUES (3, '2017-05-24', '2017-06-24', 100, 0, 0, 0, 90, 0, 1);


-- Insertion de notre représentation test pour le remplissage des achats de billets.
INSERT INTO Representation(pol, date_debut, date_representation, nb_places_max, nb_tarif_plein, nb_tarif_reduit, nb_places_reservees, duree, gain, id_spectacle)
VALUES (3, '2017-05-24', '2017-06-24', 10, 0, 0, 0, 90, 0, 1);


-- Insetion du spectacle sur lequel on teste une double subvention d'un même mécène.
INSERT INTO Spectacle (nom_spectacle, tarif_plein, tarif_reduit, rentabilite)
VALUES
('Tartuffe', 40, 20, 15000);
