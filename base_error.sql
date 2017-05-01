------------------------------------------------------------
--        Script Postgre 
------------------------------------------------------------



------------------------------------------------------------
-- Table: Spectacle
------------------------------------------------------------
CREATE TABLE public.Spectacle(
	id_spec      SERIAL NOT NULL ,
	nom_spec     CHAR (25)  NOT NULL ,
	tarif_plein  INT  NOT NULL ,
	tarif_reduit INT  NOT NULL ,
	id_sub       INT  NOT NULL ,
	id_dep       INT  NOT NULL ,
	id_repr      INT  NOT NULL ,
	CONSTRAINT prk_constraint_Spectacle PRIMARY KEY (id_spec)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Compagnie
------------------------------------------------------------
CREATE TABLE public.Compagnie(
	id_comp          SERIAL NOT NULL ,
	nom_comp         VARCHAR (25) NOT NULL ,
	metteur_en_scene VARCHAR (25) NOT NULL ,
	id_spec          INT  NOT NULL ,
	CONSTRAINT prk_constraint_Compagnie PRIMARY KEY (id_comp)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Subvention
------------------------------------------------------------
CREATE TABLE public.Subvention(
	id_sub     SERIAL NOT NULL ,
	nom_mecene VARCHAR (25) NOT NULL ,
	valeur     INT  NOT NULL ,
	CONSTRAINT prk_constraint_Subvention PRIMARY KEY (id_sub)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Depense
------------------------------------------------------------
CREATE TABLE public.Depense(
	id_dep      SERIAL NOT NULL ,
	date_dep    DATE  NOT NULL ,
	description VARCHAR (25) NOT NULL ,
	cout        INT  NOT NULL ,
	CONSTRAINT prk_constraint_Depense PRIMARY KEY (id_dep)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Reservation
------------------------------------------------------------
CREATE TABLE public.Reservation(
	id_reser    SERIAL NOT NULL ,
	date_reser  DATE  NOT NULL ,
	date_limite DATE  NOT NULL ,
	CONSTRAINT prk_constraint_Reservation PRIMARY KEY (id_reser)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Representation
------------------------------------------------------------
CREATE TABLE public.Representation(
	id_repr             SERIAL NOT NULL ,
	nb_places_max       INT  NOT NULL ,
	date_repr           DATE  NOT NULL ,
	duree               INT  NOT NULL ,
	nb_place_vendues    INT  NOT NULL ,
	nb_places_reservees INT  NOT NULL ,
	id_reser            INT  NOT NULL ,
	CONSTRAINT prk_constraint_Representation PRIMARY KEY (id_repr)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Historique
------------------------------------------------------------
CREATE TABLE public.Historique(
	entrees  SERIAL NOT NULL ,
	annee    INT  NOT NULL ,
	mois     INT  NOT NULL ,
	depenses FLOAT  NOT NULL ,
	recettes FLOAT  NOT NULL ,
	profits  FLOAT  NOT NULL ,
	CONSTRAINT prk_constraint_Historique PRIMARY KEY (entrees)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Création
------------------------------------------------------------
CREATE TABLE public.Creation(
	id_spec    INT  NOT NULL ,
	date_vente DATE  NOT NULL ,
	valeur     INT  NOT NULL ,
	id_comp    INT  NOT NULL ,
	CONSTRAINT prk_constraint_Creation PRIMARY KEY (id_spec)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Achats
------------------------------------------------------------
CREATE TABLE public.Achats(
	date_achat DATE  NOT NULL ,
	valeur     INT  NOT NULL ,
	id_spec    INT  NOT NULL ,
	CONSTRAINT prk_constraint_Achats PRIMARY KEY (id_spec)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: interne
------------------------------------------------------------
CREATE TABLE public.interne(
	id_repr INT  NOT NULL ,
	CONSTRAINT prk_constraint_interne PRIMARY KEY (id_repr)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: externe
------------------------------------------------------------
CREATE TABLE public.externe(
	lieu    VARCHAR (25)  ,
	ville   VARCHAR (25)  ,
	pays    VARCHAR (25)  ,
	id_repr INT  NOT NULL ,
	CONSTRAINT prk_constraint_externe PRIMARY KEY (id_repr)
)WITHOUT OIDS;



ALTER TABLE public.Spectacle ADD CONSTRAINT FK_Spectacle_id_sub FOREIGN KEY (id_sub) REFERENCES public.Subvention(id_sub);
ALTER TABLE public.Spectacle ADD CONSTRAINT FK_Spectacle_id_dep FOREIGN KEY (id_dep) REFERENCES public.Depense(id_dep);
ALTER TABLE public.Spectacle ADD CONSTRAINT FK_Spectacle_id_repr FOREIGN KEY (id_repr) REFERENCES public.Representation(id_repr);
ALTER TABLE public.Compagnie ADD CONSTRAINT FK_Compagnie_id_spec FOREIGN KEY (id_spec) REFERENCES public.Spectacle(id_spec);
ALTER TABLE public.Representation ADD CONSTRAINT FK_Representation_id_reser FOREIGN KEY (id_reser) REFERENCES public.Reservation(id_reser);
ALTER TABLE public.Creation ADD CONSTRAINT FK_Creation_id_spec FOREIGN KEY (id_spec) REFERENCES public.Spectacle(id_spec);
ALTER TABLE public.Creation ADD CONSTRAINT FK_Creation_id_comp FOREIGN KEY (id_comp) REFERENCES public.Compagnie(id_comp);
ALTER TABLE public.Achats ADD CONSTRAINT FK_Achats_id_spec FOREIGN KEY (id_spec) REFERENCES public.Spectacle(id_spec);
ALTER TABLE public.interne ADD CONSTRAINT FK_interne_id_repr FOREIGN KEY (id_repr) REFERENCES public.Representation(id_repr);
ALTER TABLE public.externe ADD CONSTRAINT FK_externe_id_repr FOREIGN KEY (id_repr) REFERENCES public.Representation(id_repr);
