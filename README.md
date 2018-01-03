Projet de BDAv 2017 - Le Théâtre du Chrysantème
par Samuel ELBEZ & Romain STASYSZYN

A LANCER DANS L'ORDRE AVEC '\i [script].sql'

Lancer init.sql

 OU
 
1. base.sql contient les tables ainsi que les triggers
2. insert.sql ajoute des données dans les tables
3. interface.sql qui simplifie quelques actions
4. Lancer la fonction clean() avec 'SELECT clean()' pour nettoyer la base des réservations périmées

Dans interface.sql :

 - buyFullPrice(n, i) -> achat de n places au tarif plein pour la représentation i
 - buyHalfPrice(n, i) -> achat de n places au tarif réduit pour la représentation i
 - multipleReservation -> faire la réservation de n places pour la représentation i

---- POUR LES TESTS DES TRIGGERS ET DES FONCTIONS D'HISTORIQUE ----

	- Pour tester la politique 1 : script_pol1 puis script_trigger_5 puis script_pol1 puis script trigg6 puis script_pol1
	- Pour tester la politique 2 : script_pol2 puis script trigger15 puis script pol_2 puis script_trigger_duree puis script_pol2 puis script_pol2
	- Pour tester la politique 3 : script_pol3 puis script_pol3 puis script_pol3
	- Test de remplissage : script_achat_plein
	- Test réservation dépassée : script_reservation_depassee apres avoir exécuté achat_plein (de préférence)
	- Test dépenses spectacles externes : script_depenses
	- Test plusieurs subventions : script_subvention
	- Test vente spectacle achetés : script_vente_externe
	- Afficher les recette/depenses par annee : script_historique_annee
	- Afficher les recette/depenses par mois : script_historique_mois
	- Afficher les billets vendus par représentation : script_historique_billets
	- Afficher les tournées : script_historique_tournee
	- Afficher les informations par spectacle : script_historique_spectacle
