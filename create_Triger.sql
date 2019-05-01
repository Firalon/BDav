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
