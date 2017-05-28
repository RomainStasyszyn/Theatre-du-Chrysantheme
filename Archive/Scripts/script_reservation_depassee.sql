SELECT * FROM Representation where id_representation=24;
SELECT * FROM Reservation where id_representation=24;


\i script_trigger_jours3.sql
SELECT clean();


UPDATE Representation SET nb_places_reservees = nb_places_reservees + 1 where id_representation = 24;
SELECT * FROM Representation where id_representation=24;
SELECT * FROM Reservation where id_representation=24;
