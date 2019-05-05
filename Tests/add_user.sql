INSERT INTO utilisateur (mail, nom, prenom, dateinscr, inscritnewsletter)
VALUES
('philippe_said@gmail.com','said','philippe','1998-06-03 03:03:03'::timestamp,false);

\echo 'utillisateur ajoute'

INSERT INTO informations_banquaires (id_utilisateur,numero,mois_expiration,annee_expiration,cryptograme)
VALUES
(SELECT id FROM utilisateur WHERE mail='philippe_said@gmail.com',11,21,422);

\echo 'informations bancaires ajoutees'
