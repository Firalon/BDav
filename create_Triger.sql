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


CREATE OR REPLACE FUNCTION prevent_self_don() RETURNS TRIGGER AS $$
BEGIN
IF (NEW.id_donateur = (SELECT utilisateur.id FROM utilisateur, projet WHERE
utilisateur.id = projet.id_createur AND projet.id = NEW.id_projet)) THEN	RAISE EXCEPTION 'Tentative de don a son propre projet';
ELSE
	RETURN NEW; 
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_self_don
BEFORE INSERT ON don
FOR EACH ROW
EXECUTE PROCEDURE prevent_self_don();


CREATE OR REPLACE FUNCTION prevent_self_com() RETURNS TRIGGER AS $$
BEGIN
IF (NEW.id_utilisateur = (SELECT utilisateur.id FROM utilisateur, projet WHERE
utilisateur.id = projet.id_createur AND projet.id = NEW.id_projet)) THEN	RAISE EXCEPTION 'Tentative de commentaire a son propre projet';
ELSE
	RETURN NEW; 
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_self_com
BEFORE INSERT ON commentaire
FOR EACH ROW
EXECUTE PROCEDURE prevent_self_com();

CREATE OR REPLACE FUNCTION check_infos_banquaires() RETURNS TRIGGER AS $$
BEGIN
IF (SELECT id_utilisateur FROM informations_banquaires WHERE id_utilisateur = NEW.id_donateur ) THEN
    RETURN NEW;
ELSE
	RAISE EXCEPTION 'L''utilisateur n''as pas d''informations banquaires associes';	
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_infos_banquaires
BEFORE INSERT on mensualite
FOR EACH ROW
EXECUTE PROCEDURE check_infos_banquaires();


CREATE OR REPLACE FUNCTION send_mail(mail varchar(50)) RETURNS VOID AS $$
BEGIN
	RAISE NOTICE 'Mail envoye a: %',mail;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_projet() RETURNS TRIGGER AS $$
BEGIN
	PERFORM (SELECT mail FROM utilisateur,mensualite, LATERAL send_mail(mail) WHERE utilisateur.id = mensualite.id_donateur AND mensualite.id_projet = OLD.id); 
	RETURN OLD;
END;
$$ language plpgsql;

CREATE TRIGGER delete_projet
BEFORE DELETE on projet
FOR EACH ROW
EXECUTE PROCEDURE delete_projet();



CREATE OR REPLACE FUNCTION monthly_payment() RETURNS VOID AS $$
BEGIN
RAISE NOTICE 'Paiement mensuel';
IF ((SELECT id_donateur FROM mensualite) IS NOT NULL) THEN
INSERT INTO don (id_donateur,id_projet,somme,date_don,estMensuel)
	VALUES(
	(SELECT id_donateur FROM mensualite),
	(SELECT id_projet FROM mensualite),
	(SELECT somme FROM mensualite)*95/100,
	(SELECT time FROM time),
	true
	);
END IF;
	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION send_newsletter() RETURNS VOID as $$
BEGIN
	PERFORM mail FROM utilisateur, LATERAL send_mail(mail) WHERE inscritNewsletter = true;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION recap_mail_donateur(mail varchar(50)) RETURNS VOID AS $$
#variable_conflict use_variable
DECLARE
total integer;
BEGIN
total = (SELECT SUM(somme) FROM don,utilisateur WHERE don.id_donateur = utilisateur.id AND utilisateur.mail=mail AND don.date_don > (SELECT time FROM time ) - interval '30 days');
RAISE NOTICE 'mail envoyé à %, qui a donne %e ce mois ci',mail,total;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION recap_mail_createur(mail varchar(50)) RETURNS VOID AS $$
#variable_conflict use_variable
DECLARE
total integer;
BEGIN
total = (SELECT SUM(somme) FROM don,projet WHERE don.id_projet = projet.id AND projet.id_createur = (SELECT id FROM utilisateur WHERE mail = utilisateur.mail) AND don.date_don > (SELECT time FROM time ) - interval '30 days');
RAISE NOTICE 'mail envoyé à %, qui a recu %e pour son projet ce mois ci',mail,total;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION recap_mail() RETURNS VOID AS $$
BEGIN
RAISE NOTICE 'Envois de mails aux donateurs:';
	PERFORM mail FROM utilisateur, LATERAL recap_mail_donateur(mail);
RAISE NOTICE 'Envois de mails aux createurs:';	
	PERFORM mail FROM utilisateur,projet, LATERAL recap_mail_createur(mail) WHERE utilisateur.id = projet.id_createur;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION palier_mail(mail varchar(50),palier integer) RETURNS VOID AS $$
BEGIN
RAISE NOTICE 'Mail envoye a % pour avoir atteint le palier %',mail,palier;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_palier() RETURNS TRIGGER AS $$
DECLARE
	total integer;
	palier integer;
BEGIN
total = (SELECT SUM(somme) FROM don WHERE don.id_projet = NEW.id_projet);
FOR palier in (SELECT somme FROM palier WHERE palier.id_projet = NEW.id_projet) LOOP
    IF (total - NEW.somme < palier AND total >= palier) THEN
       EXECUTE palier_mail((SELECT mail FROM utilisateur, projet WHERE utilisateur.id = projet.id_createur AND projet.id = NEW.id_projet),palier);
    END IF;
END LOOP;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_palier
AFTER INSERT on don
FOR EACH ROW
EXECUTE PROCEDURE check_palier();
