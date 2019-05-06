\echo 'don ponctuel'

INSERT INTO don(id_donateur,id_projet,somme,date_don,estmensuel) 

VALUES
(1,2,100,'2015-10-15 18:20:12'::timestamp,false);




\echo 'don mensuel'

INSERT INTO mensualite(id_donateur,id_projet,somme) 

VALUES
(1,2,250);
