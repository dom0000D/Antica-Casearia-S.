    CREATE OR REPLACE PROCEDURE genera_turno_lavorativo (in_data DATE,in_reparto CHAR, in_casaro CHAR) IS
    
    CURSOR get_cassiere (in_data DATE) IS 
    SELECT NumTesserino
    FROM(
    SELECT cas_disp.Numtesserino,COUNT(*) as prestazioni
    FROM (SELECT NumTesserino 
            FROM DipendenteCaseificio
            WHERE ruolo = 'Cassiere'
            AND NOT EXISTS (SELECT * FROM TurnoLavorativo
                            WHERE Numtesserino = CassiereTess AND Data_Ora = in_data)
                            ) cas_disp
    JOIN TurnoLavorativo TL
    ON TL.CassiereTess = cas_disp.NumTesserino 
    GROUP BY cas_disp.NumTesserino
    ORDER BY prestazioni)
    
    WHERE ROWNUM = 1;

    CURSOR get_addetto (in_data DATE) IS 
    SELECT * FROM (
    SELECT NumTesserino,COUNT(*) as prestazioni
    FROM (SELECT NumTesserino
            FROM DipendenteCaseificio
		    WHERE ruolo = 'Addetto'
		    AND NOT EXISTS (SELECT * FROM assiste WHERE AddettoTess = NumTesserino
		    AND DataOraTL = in_data)
    ) add_disp
    LEFT OUTER JOIN assiste 
    ON assiste.AddettoTess = NumTesserino
    GROUP BY NumTesserino
    ORDER BY prestazioni)
    WHERE ROWNUM <= 5;
    
    CURSOR get_trasportatore (in_data DATE) IS 
    SELECT * FROM (
        SELECT NumTesserino,COUNT(*) as prestazioni
        FROM (SELECT NumTesserino
                FROM DipendenteCaseificio
                WHERE ruolo = 'Trasportatore'
                AND NOT EXISTS (SELECT * FROM consegna WHERE TrasportatoreTess = NumTesserino
                AND DataOraTL = in_data)
        ) tra_disp
    LEFT OUTER JOIN consegna 
    ON consegna.TrasportatoreTess = NumTesserino
    GROUP BY NumTesserino
    ORDER BY prestazioni)
    WHERE ROWNUM <= 2;
    
    cas_disp get_cassiere%ROWTYPE;
    add_disp get_addetto%ROWTYPE;
    tra_disp get_trasportatore%ROWTYPE;
    addetti_insufficienti EXCEPTION;
    trasportatori_insufficienti EXCEPTION;
    
    BEGIN
    -- Cerco il turno lavorativo ed inserisco il cassiere
    OPEN get_cassiere(in_data);
    FETCH get_cassiere INTO cas_disp;
    INSERT INTO TurnoLavorativo VALUES(in_data,in_reparto,cas_disp.NumTesserino,in_casaro);
    CLOSE get_cassiere;
    
    -- Cerco e inserisco almeno 5 addetti disponibili in un turno lavorativo
    OPEN get_addetto(in_data);
    LOOP
    FETCH get_addetto INTO add_disp; 
    EXIT WHEN get_addetto%notfound;
    INSERT INTO assiste VALUES(add_disp.NumTesserino,in_reparto,in_data);
    END LOOP;
    
    IF get_addetto%ROWCOUNT < 5 THEN
        RAISE addetti_insufficienti;
    END IF;
  	CLOSE get_addetto;

    -- Cerco e inserisco almeno 2 trasportatori disponibili in un turno lavorativo
    OPEN get_trasportatore(in_data);
    LOOP
    FETCH get_trasportatore INTO tra_disp; 
    EXIT WHEN get_trasportatore%notfound;
    INSERT INTO consegna VALUES (tra_disp.NumTesserino,in_reparto,in_data);
    END LOOP;
    
    IF get_trasportatore%ROWCOUNT < 2 THEN
        RAISE trasportatori_insufficienti;
    END IF;

    CLOSE get_trasportatore;
	
	COMMIT;
	
	EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	        RAISE_APPLICATION_ERROR(-20022,'Non sono soddisfatti i requisiti per creare un nuovo turno.');
	        ROLLBACK;
        WHEN addetti_insufficienti THEN
		    RAISE_APPLICATION_ERROR(-20023,'Non ci sono addetti sufficienti.');
			ROLLBACK;
		WHEN trasportatori_insufficienti THEN
		    RAISE_APPLICATION_ERROR(-20024,'Non ci sono trasportatori sufficienti.');
		    ROLLBACK;
    END;
/