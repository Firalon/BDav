DELETE FROM time;
INSERT INTO time VALUES('2019-06-01'::timestamp);

INSERT INTO utilisateur(nom,prenom,mail,dateInscr)
       VALUES ('dujardin','jean','jean.dujardin@hotmail.fr',(SELECT time FROM time));

INSERT INTO projet(id_createur,id_categorie,description,date_creation)
       VALUES ((SELECT id FROM utilisateur WHERE mail = 'jean.dujardin@hotmail.fr'),1,'descritption du projet de jean dujardin',(SELECT time FROM time));

INSERT INTO palier(id_projet,somme,objectif)
       VALUES ((SELECT projet.id FROM projet, utilisateur WHERE projet.id_createur = utilisateur.id AND utilisateur.mail = 'jean.dujardin@hotmail.fr'),1000,'budget SFX');

INSERT INTO contrepartie(id_projet,somme,contrepartie)
       VALUES ((SELECT projet.id FROM projet, utilisateur WHERE projet.id_createur = utilisateur.id AND utilisateur.mail = 'jean.dujardin@hotmail.fr'),50,'place de cinema gratuite');

DELETE FROM time;
INSERT INTO time VALUES('2019-06-10'::timestamp);

INSERT INTO informations_banquaires(id_utilisateur,numero,mois_expiration,annee_expiration,cryptogramme)
       VALUES (1,1354,01,20,555),
       	      (2,3541,02,21,333),
	      (3,5498,04,19,459);

INSERT INTO mensualite(id_donateur,id_projet,somme)
       VALUES (1,(SELECT projet.id FROM projet, utilisateur WHERE projet.id_createur = utilisateur.id AND utilisateur.mail = 'jean.dujardin@hotmail.fr'),10),
       	      (2,(SELECT projet.id FROM projet, utilisateur WHERE projet.id_createur = utilisateur.id AND utilisateur.mail = 'jean.dujardin@hotmail.fr'),60),
	      (3,(SELECT projet.id FROM projet, utilisateur WHERE projet.id_createur = utilisateur.id AND utilisateur.mail = 'jean.dujardin@hotmail.fr'),100);

DELETE FROM time;
INSERT INTO time VALUES('2019-06-20'::timestamp);

UPDATE mensualite
SET somme = 20
WHERE id_donateur = 3 AND id_projet = (SELECT projet.id FROM projet, utilisateur WHERE projet.id_createur = utilisateur.id AND utilisateur.mail = 'jean.dujardin@hotmail.fr');

INSERT INTO don(id_donateur,id_projet,somme,date_don)
       VALUES(4,(SELECT projet.id FROM projet, utilisateur WHERE projet.id_createur = utilisateur.id AND utilisateur.mail = 'jean.dujardin@hotmail.fr'),100,(SELECT time FROM time));

DELETE FROM time;
INSERT INTO time VALUES('2019-07-01'::timestamp);

\i monthly_operation.sql;






