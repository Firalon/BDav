CREATE TABLE utilisateur (
	id serial PRIMARY KEY,
	mail varchar(50) UNIQUE NOT NULL,
	nom varchar(50) NOT NULL,
	prenom varchar(50) NOT NULL,
	dateInscr DATETIME NOT NULL,
	inscritNewsletter BOOLEAN NOT NULL
)

CREATE TABLE projet (
	id serial PRIMARY KEY,
	id_createur integer NOT NULL REFERENCES utilisateur(id),
	id_categorie integer NOT NULL REFERENCES categorie(id),
	descripton varchar(500),
	date_creation DATETIME NOT NULL
)

CREATE TABLE news (
	id serial PRIMARY KEY,
	id_projet integer NOT NULL REFERENCES projet(id),
	date_publication DATETIME NOT NULL,
	estPublique boolean NOT NULL,
	contenu varchar(1000) NOT NULL
)

CREATE TABLE palier(
	id_projet integer NOT NULL REFERENCES projet(id),
	somme integer NOT NULL,
	objectif varchar(200) NOT NULL
)

CREATE TABLE contrepartie (
	id_projet integer NOT NULL REFERENCES projet(id),
	somme integer NOT NULL,
	contrepartie varchar(200) NOT NULL
)

CREATE TABLE categorie (
	id serial PRIMARY KEY,
	nom varchar(20) NOT NULL
)

CREATE TABLE commentaire (
	id serial PRIMARY KEY
	id_utilisateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id),
	date_creation DATETIME NOT NULL,
	message varchar(500) NOT NULL
)

CREATE TABLE don (
	id_donateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id),
	somme integer NOT NULL,
	date_don DATETIME NOT NULL
)

CREATE TABLE mensualite(
	id_donateur integer NOT NULL REFERENCES utilisateur(id),
	id_projet integer NOT NULL REFERENCES projet(id),
	somme integer NOT NULL
)

CREATE TABLE preference(
	id_utilisateur integer NOT NULL REFERENCES utilisateur(id),
	id_categorie integer NOT NULL REFERENCES categorie(id),
	somme integer
)

CREATE TABLE archivage(
	id serial PRIMARY KEY,
	id_utilisateur integer NOT NULL REFERENCES utilisateur(id),
	date_operation DATETIME NOT NULL,
	operation varchar(10) NOT NULL,
	montant integer
	
)
	