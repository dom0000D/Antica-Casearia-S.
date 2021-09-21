CREATE OR REPLACE PROCEDURE sostituisci_cassiere(in_data_tl DATE,in_reparto_tl VARCHAR) IS turno TurnoLavorativo%ROWTYPE;
    BEGIN

    -- Selezioniamo il turno in base alla data ed al reparto
    SELECT *
    INTO turno
    FROM TurnoLavorativo
    WHERE Data_Ora = in_data_tl AND CodiceReparto = in_reparto_tl;
    
	-- Procediamo con la modifica del cassiere sulla base delle prestazioni effettuate
    UPDATE TurnoLavorativo SET (CassiereTess) = 
	(SELECT NumTesserino FROM (
	    SELECT cass_disp.NumTesserino,COUNT(*) as prestazioni
	    FROM (SELECT NumTesserino
	    FROM DipendenteCaseificio
	    WHERE ruolo = 'Cassiere' AND NumTesserino <> turno.CassiereTess
	    AND NOT EXISTS (SELECT * 
	                    FROM TurnoLavorativo 
	                    WHERE Numtesserino = CassiereTess AND Data_Ora = in_data_tl)
	                    ) cass_disp
	   JOIN TurnoLavorativo tl ON tl.CassiereTess = cass_disp.Numtesserino
	   GROUP BY cass_disp.Numtesserino
	   ORDER BY prestazioni)
	WHERE ROWNUM = 1)
	
	WHERE Data_Ora = in_data_tl AND CodiceReparto = in_reparto_tl;
	
	EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	        RAISE_APPLICATION_ERROR(-20021,'Non sono soddisfatti i requisiti per sostituire il cassiere.');
		ROLLBACK;
 END;
/