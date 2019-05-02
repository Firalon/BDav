CREATE OR REPLACE FUNCTION log_user() RETURNS trigger AS $$
BEGIN
INSERT INTO archive (id_utilisateur,date_operation,operation)
       VALUES(NEW.id, (SELECT time FROM time), 'INSCRIPTION');
       RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER log_user
AFTER INSERT ON utilisateur
FOR EACH ROW
EXECUTE PROCEDURE log();

CREATE OR REPLACE FUNCTION don() RETURNS trigger AS $$
BEGIN
INSERT INTO archive(id_utilisateur, date_operation,operation,valeur, cible)
       VALUES (NEW.id_donateur, (SELECT time FROM time), 'DON', NEW.somme, NEW.id_projet);
       RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER don
AFTER INSERT ON don
FOR EACH ROW
EXECUTE PROCEDURE don();


CREATE OR REPLACE FUNCTION update_pref() RETURNS TRIGGER AS $$
BEGIN
IF ((SELECT id_categorie FROM preference WHERE id_utilisateur = NEW.id_donateur) is NOT NULL)
THEN
	UPDATE preference
	SET somme = (somme +NEW.somme)
	WHERE id_utilisateur = NEW.id_donateur
	      AND id_categorie =
	      (SELECT projet.id_categorie FROM projet
	      WHERE projet.id = NEW.id_projet);
ELSE
	INSERT INTO preference (id_utilisateur, id_categorie, somme)
	VALUES (NEW.id_donateur, (SELECT projet.id_categorie FROM projet
	      WHERE projet.id = NEW.id_projet), NEW.somme);
END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_pref
AFTER INSERT ON don
FOR EACH ROW
EXECUTE PROCEDURE update_pref();
