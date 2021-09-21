    CREATE OR REPLACE PROCEDURE sostituisci_veicolo(in_tipo_unita VARCHAR,in_reparto CHAR,in_data DATE) IS adopera si_adopera%ROWTYPE;
    BEGIN
    
    -- Selezioniamo il veicolo utilizzato durante uno specifico turno lavorativo
    SELECT *
    INTO adopera
    FROM si_adopera
    WHERE Data_Ora_TL = in_data AND CodReparto = in_reparto;
    
    -- Si aggiorna il veicolo in base ai minor utilizzi degli altri veicoli disponibili
    UPDATE si_adopera
    SET (si_adopera.Targa) = 
    (SELECT Targa FROM (
        SELECT veicolo_disp.Targa,COUNT(*) as utilizzo
	    FROM (SELECT Targa
	            FROM Veicolo
	            WHERE TipoUnita = in_tipo_unita
	    ) veicolo_disp
	    JOIN si_adopera sa
	    ON sa.Targa = veicolo_disp.Targa 
	    GROUP BY veicolo_disp.Targa
	    ORDER BY utilizzo)
    WHERE ROWNUM = 1)
    
    WHERE Data_Ora_TL = in_data AND CodReparto = in_reparto;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20025,'Non e'' possibile sostituire il veicolo.');
        ROLLBACK;
    END;
/