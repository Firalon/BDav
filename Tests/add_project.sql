INSERT INTO projet (id_createur, id_categorie, description, date_creation)
       VALUES
       (2,4,'chaine de vulgarisation politique','2019-06-24 14:05:06'::timestamp);
       
       \echo 'projet créé'

INSERT INTO palier(id_projet,somme,objectif)
VALUES
(SELECT id FROM projet WHERE description='chaine de vulgarisation politique',1000,'realiser des reportages');

\echo 'palier créer'
