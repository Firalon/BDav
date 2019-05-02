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
