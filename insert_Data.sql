INSERT INTO utilisateur (mail, nom, prenom, dateinscr, inscritnewsletter)
       VALUES
       ('floszc@orange.fr', 'szczepanski', 'florian', '1998-06-03 03:03:03'::timestamp, true),
       ('jean.michel@gmail.com','michel','jean','2000-10-05 12:56:34'::timestamp,true),
       ('yagami@gmail.com','yagami','light','2005-01-01 01:01:01'::timestamp,true),
       ('alex.moix@gmail.com','moix','alex','2006-12-28 16:30:21'::timestamp,true),
       ('sup.crea@wanadoo.fr','createur','super','2007-10-15 18:20:12'::timestamp,true),
       ('ad.couturier@domaine.ru','couturier','andre','2007-10-15 18:19:01'::timestamp,true),
       ('co.funke@wanadoo.fr','funke','cornellia','2008-06-24 11:16:03'::timestamp,true),
       ('eli.anderson@orange.fr','anderson','eli','2008-07-02 16:15:17'::timestamp,true),
       ('is.eifuku@hotmail.fr','eifuku','issei','2008-10-05 19:25:04'::timestamp,true),
       ('yusuke.murata@gmail.fr','murata','yusuke','2009-02-27'::timestamp,true),
       ('o.pill@wanadoo.fr','pill','oscar','2009-05-28'::timestamp,true),
       ('karl.popper@hotmail.fr','popper','karl','2009-06-03'::timestamp,true),
       ('manu77@orange.fr','macron','emmanuel','2017-05-14'::timestamp,true);

INSERT INTO categorie (nom)
       VALUES
       ('video'),
       ('dessin'),
       ('cuisine'),
       ('politique'),
       ('jeux video');

INSERT INTO projet (id_createur, id_categorie, description, date_creation)
       VALUES
       (13,4,'NOTRE PROJET!!!', '2017-05-14 02:00:05'::timestamp),
       (5,1,'Des supers trucs', '2007-10-15 19:12:26'::timestamp),
       (9,2,'Publication hebdomaire du manga Evil Eater', '2012-09-30 22:56:43'::timestamp);

INSERT INTO palier(id_projet, somme, objectif)
       VALUES
       (1,10000,'Baisse du prix de l''essence'),
       (2,1000,'Achat d''une caméra HD'),
       (2,2500,'Financement de cours métrage'),
       (2,5000,'Embauche d''un salarié'),
       (3,1500,'Mise à temps pleins'),
       (3,5000,'Embauche d''assistans');

INSERT INTO contrepartie(id_projet,somme,contrepartie)
       VALUES
       (1,1000,'reduction des impôts'),
       (2,1,'Merci !'),
       (2,5,'Merci beaucoup ! Vous seriez remercier en fin de vidéo'),
       (3,10,'Merci pour votre soutien !'),
       (3,50,'Merci ! Vous avez le droit à 1 dessin perso');

INSERT INTO news(id_projet, date_publication, estPublique, contenu)
       VALUES
       (1,'2019-01-15'::timestamp,true,'Départ du grand débat'),
       (2,'2010-07-01'::timestamp,true,'Nouvelle vidéo sur les chevals'),
       (2,'2010-06-25'::timestamp,false,'Teasing de la prochaine vidéo'),
       (2,'2009-05-06'::timestamp,false,'Vidéo special set-up'),
       (3,'2013-02-07'::timestamp,true,'Publication du tome 9'),
       (3,'2013-01-06'::timestamp,false,'Dessin perso pour Light Yagami');

INSERT INTO commentaire(id_utilisateur, id_projet, date_creation, message)
       VALUES
       (9,1,'2019-01-23'::timestamp,'Moi je préférais mélenchon.'),
       (6,1,'2019-02-16'::timestamp,'Très bon programme.'),
       (3,2,'2019-02-13'::timestamp,'J''adore tes vidéos, j''aime vraiment ta patte artistique.'),
       (10,3,'2019-02-27'::timestamp,'La qualité graphique est vraiment génial.'),
       (12,3,'2019-03-02'::timestamp,'Trop stylé.');


