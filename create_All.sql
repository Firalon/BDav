CREATE TABLE time (
       time timestamp NOT NULL
);
INSERT INTO time (time)
       VALUES ('2019-05-01 12:00:00'::timestamp);
       

CREATE TABLE utilisateur (
	id serial PRIMARY KEY,
	mail varchar(50) UNIQUE NOT NULL,
	nom varchar(50) NOT NULL,
	prenom varchar(50) NOT NULL,
	dateInscr timestamp NOT NULL,
	inscritNewsletter BOOLEAN DEFAULT false
);

CREATE TABLE informations_banquaires(
       id_utilisateur integer PRIMARY KEY REFERENCES utilisateur(id),
       numero integer NOT NULL,
       mois_expiration integer NOT NULL CHECK (mois_expiration>=1 AND mois_expiration<=12),
       annee_expiration integer NOT NULL CHECK (annee_expiration>=0 AND annee_expiration<=99),
       cryptogramme integer NOT NULL
);
       

CREATE TABLE categorie (
	id serial PRIMARY KEY,
	nom varchar(20) NOT NULL
);

CREATE TABLE projet (
	id serial PRIMARY KEY,
	id_createur integer UNIQUE NOT NULL REFERENCES utilisateur(id),
	id_categorie integer NOT NULL REFERENCES categorie(id),
	description varchar(500),
	date_creation TIMESTAMP NOT NULL
);

CREATE TABLE news (
	id serial PRIMARY KEY,
	id_projet integer NOT NULL REFERENCES projet(id) ON DELETE CASCADE,
	date_publication TIMESTAMP NOT NULL,
	estPublique boolean NOT NULL,
	contenu varchar(1000) NOT NULL
);

CREATE TABLE palier(
	id_projet integer NOT NULL REFERENCES projet(id) ON DELETE CASCADE,
	somme integer NOT NULL CHECK(somme>=10 AND somme <=50000),
	objectif varchar(200) NOT NULL,
	PRIMARY KEY(id_projet,somme)
	
);

CREATE TABLE contrepartie (
	id_projet integer NOT NULL REFERENCES projet(id) ON DELETE CASCADE,
	somme integer NOT NULL CHECK (somme>=1 AND somme <=1000),
	contrepartie varchar(200) NOT NULL,
	PRIMARY KEY(id_projet,somme)
);

CREATE TABLE commentaire (
	id serial PRIMARY KEY,
	id_utilisateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id) ON DELETE CASCADE,
	date_creation TIMESTAMP NOT NULL,
	message varchar(500) NOT NULL
);

CREATE TABLE don (
       	id serial PRIMARY KEY,
	id_donateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id) ON DELETE CASCADE,
	somme integer NOT NULL CHECK (somme >=1 AND somme <=1000),
	date_don TIMESTAMP NOT NULL,
	estMensuel boolean DEFAULT false
);

CREATE TABLE mensualite(
	id_donateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id) ON DELETE CASCADE,
	somme integer NOT NULL CHECK (somme >=1 AND somme <=1000),
	PRIMARY KEY(id_donateur,id_projet)
);

CREATE TABLE preference(
	id_utilisateur integer NOT NULL REFERENCES utilisateur(id) ON DELETE CASCADE,
	id_categorie integer NOT NULL REFERENCES categorie(id) ON DELETE CASCADE,
	somme integer,
	PRIMARY KEY(id_utilisateur,id_categorie)
);

CREATE TABLE archive(
	id serial PRIMARY KEY,
	id_utilisateur integer NOT NULL,
	date_operation TIMESTAMP NOT NULL,
	operation varchar(15) NOT NULL
	CHECK (operation in ('INSCRIPTION','OUVERTURE_PROJET','DON',
			'CHGT_MENSUALITE','FERMETURE_PROJET','DESINSCRIPTION')),
	valeur integer,
	cible integer	
);
	
