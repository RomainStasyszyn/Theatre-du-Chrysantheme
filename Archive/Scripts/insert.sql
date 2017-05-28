/*************************************/

INSERT INTO Spectacle (nom_spectacle, tarif_plein, tarif_reduit, rentabilite)
VALUES
('Des souris et des hommes', 40, 28, 150000), ('Hôtel des deux mondes', 45, 30, 50000), ('Les Faux British', 35, 15, 100000), ('J aime beaucoup ce que vous faites', 24, 20, 200000),
('La Guerre des sexes', 24, 18, 180000), ('Le Portrait de Dorian Gray', 30, 15, 45000), ('Cyrano de Bergerac', 35, 30, 350000), ('Le Clan', 43, 31, 170000),
('Et pendant ce temps Simone veille', 32, 26, 270000), ('Si je t attrape, je te mort !', 22, 10, 150000)
;

INSERT INTO Compagnie (nom_compagnie, metteur_en_scene)
VALUES
('Théâtre POM', 'Brigitte Verlière'), ('Cie du Gestuaire', 'Danielle Maxent'), ('Théâtre Icare', 'Christophe Rouxel')
;

INSERT INTO Creation(id_spectacle)
VALUES
(1), (2), (4), (5), (6), (9), (10)
;

INSERT INTO Achat(id_spectacle, date_achat, valeur, id_compagnie)
VALUES
(3, '2015-01-25', 3000, 1), (7, '2016-10-06', 4018, 2), (8, '2017-02-02', 2850, 3)
;

INSERT INTO Vente(date_vente, valeur, id_spectacle, id_compagnie)
VALUES
('2017-02-15', 50000, 9, 3)
;

INSERT INTO Representation(pol, date_debut, date_representation, nb_places_max, nb_tarif_plein, nb_tarif_reduit, nb_places_reservees, duree, gain, id_spectacle)
VALUES
(1, '2017-05-08', '2017-06-03', 250, 0, 0, 0, 90, 0, 1), (1, '2017-05-08', '2017-06-04', 225, 0, 0, 0, 90, 0, 1), (1, '2017-05-08', '2017-06-07', 225, 0, 0, 0, 90, 0, 1),
(2, '2017-05-08', '2017-06-08', 150, 0, 0, 0, 45, 0, 2), (2, '2017-05-08', '2017-06-10', 150, 0, 0, 0, 45, 0, 2),
(3, '2017-05-08', '2017-06-11', 60, 0, 0, 0, 60, 0, 3), (3, '2017-05-08', '2017-06-15', 80, 0, 0, 0, 60, 0, 3), (3, '2017-05-08', '2017-06-17', 100, 0, 0, 0, 60, 0, 3),
(1, '2017-05-08', '2017-06-18', 300, 0, 0, 0, 45, 0, 4),
(2, '2017-05-08', '2017-06-19', 75, 0, 0, 0, 60, 0, 5), (2, '2017-05-08', '2017-06-21', 80, 0, 0, 0, 60, 0, 5),
(3, '2017-05-08', '2017-06-22', 180, 0, 0, 0, 45, 0, 6),
(1, '2017-05-08', '2017-06-23', 200, 0, 0, 0, 120, 0, 7),
(2, '2017-05-08', '2017-06-24', 130, 0, 0, 0, 90, 0, 8), (2, '2017-05-08', '2017-06-26', 150, 0, 0, 0, 90, 0, 8), (2, '2017-05-08', '2017-06-28', 100, 0, 0, 0, 90, 0, 8),
(3, '2017-05-08', '2017-07-01', 140, 0, 0, 0, 105, 0, 9), (3, '2017-05-08', '2017-07-03', 150, 0, 0, 0, 105, 0, 9),
(1, '2017-05-08', '2017-07-08', 170, 0, 0, 0, 90, 0, 10), (1, '2017-05-08', '2017-07-10', 180, 0, 0, 0, 90, 0, 10)
;

INSERT INTO Interne(id_representation)
VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(19),(20)
;

INSERT INTO Externe(id_representation, lieu, ville, pays)
VALUES
(18, 'Théâtre Icare', 'Paris', 'France')
;

INSERT INTO Subvention(nom_mecene, valeur, id_spectacle)
VALUES
    ('Ministère de la Culture', 50000, 7),
    ('Ministère de la Culture', 30000, 1),
    ('Pierre Dupont', 15000, 6),
    ('Pierre Dupond', 10000, 6),
    ('Sarah Cohen', 10000, 9)
;

INSERT INTO Depenses(date_depense, description, cout, id_spectacle)
VALUES
('2015-09-22', 'Costumes & Décors', 15000, 1),
('2015-10-29', 'Costumes & Décors', 25000, 2),
('2016-02-18', 'Costumes & Décors', 10000, 4),
('2016-07-04', 'Costumes & Décors', 5000, 5),
('2016-11-11', 'Costumes & Décors', 7000, 6),
('2017-01-16', 'Costumes', 4000, 9),
('2017-02-01', 'Décors', 10000, 9),
('2017-03-03', 'Costumes & Décors', 6000, 10)
;

/*
    Achat d'un billet à tarif plein
*/
--UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 1;
--UPDATE Representation SET nb_tarif_plein = nb_tarif_plein + 1 where id_representation = 2;

/*
    Achat d'un billet à tarif réduit
*/
--UPDATE Representation SET nb_tarif_reduit = nb_tarif_reduit + 1 where id_representation = 1;

/*
    Faire une réservation
*/
--UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = 1;
--UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = 1;
