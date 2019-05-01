CREATE TABLE utilisateur (
	id serial PRIMARY KEY,
	mail varchar(50) UNIQUE NOT NULL,
	nom varchar(50) NOT NULL,
	prenom varchar(50) NOT NULL,
	dateInscr timestamp NOT NULL,
	inscritNewsletter BOOLEAN NOT NULL
);

CREATE TABLE categorie (
	id serial PRIMARY KEY,
	nom varchar(20) NOT NULL
);

CREATE TABLE projet (
	id serial PRIMARY KEY,
	id_createur integer NOT NULL REFERENCES utilisateur(id),
	id_categorie integer NOT NULL REFERENCES categorie(id),
	description varchar(500),
	date_creation TIMESTAMP NOT NULL
);

CREATE TABLE news (
	id serial PRIMARY KEY,
	id_projet integer NOT NULL REFERENCES projet(id),
	date_publication TIMESTAMP NOT NULL,
	estPublique boolean NOT NULL,
	contenu varchar(1000) NOT NULL
);

CREATE TABLE palier(
	id_projet integer NOT NULL REFERENCES projet(id),
	somme integer NOT NULL,
	objectif varchar(200) NOT NULL,
	PRIMARY KEY(id_projet,somme)
	
);

CREATE TABLE contrepartie (
	id_projet integer NOT NULL REFERENCES projet(id),
	somme integer NOT NULL,
	contrepartie varchar(200) NOT NULL,
	PRIMARY KEY(id_projet,somme)
);

CREATE TABLE commentaire (
	id serial PRIMARY KEY,
	id_utilisateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id),
	date_creation TIMESTAMP NOT NULL,
	message varchar(500) NOT NULL
);

CREATE TABLE don (
       	id serial PRIMARY KEY,
	id_donateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id),
	somme integer NOT NULL,
	date_don TIMESTAMP NOT NULL,
	estMensuel boolean NOT NULL
);

CREATE TABLE mensualite(
	id_donateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id),
	somme integer NOT NULL,
	PRIMARY KEY(id_donateur,id_projet)
);

CREATE TABLE preference(
	id_utilisateur integer NOT NULL REFERENCES utilisateur(id),
	id_categorie integer NOT NULL REFERENCES categorie(id),
	somme integer,
	PRIMARY KEY(id_utilisateur,id_categorie)
);

CREATE TABLE archivage(
	id serial PRIMARY KEY,
	id_utilisateur integer NOT NULL REFERENCES utilisateur(id),
	date_operation TIMESTAMP NOT NULL,
	operation varchar(10) NOT NULL,
	montant integer
	
);
	
