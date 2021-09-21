    CREATE OR REPLACE PROCEDURE rinnovo_tessera(IDT_T VARCHAR, in_email VARCHAR) IS
    ds DATE;
    tessera_non_scaduta EXCEPTION;
    offset NUMBER := 1;
    acquisti_eff NUMBER;
    IDT_cli CHAR(8);
    cf_cli CHAR(16);
    
    BEGIN
    
    -- Selezioniamo la Data di Scadenza della tessera interessata
    SELECT DataScadenza
    INTO ds
    FROM Tessera
    WHERE IDT=IDT_T;
    
    -- Verifichiamo se la tessera non e' scaduta
    IF ds > TRUNC(SYSDATE) THEN
        RAISE tessera_non_scaduta;
    END IF;
    
    -- Selezioniamo la tessera ed il codice fiscale del Cliente
    SELECT IDT
    INTO IDT_cli
    FROM Tessera
    WHERE IDT = IDT_T;
    
    SELECT CF_Cliente
    INTO cf_cli
    FROM Tessera
    WHERE IDT = IDT_T;

    -- Calcoliamo gli utilizzi della Tessera del Cliente durante la sua attivazione
    SELECT SUM(COUNT(*)) as utilizzi
    INTO acquisti_eff
    FROM utilizza
    WHERE IDT_Tessera = IDT_Cli
    GROUP BY DataUtilizzo
    ORDER BY utilizzi;
    
    -- Se il Cliente ha effettuato piu' di 3 acquisiti, sara' incrementata di 1 anno la sua scadenza
    IF acquisti_eff >= 3 THEN
        offset := offset+1; 
    END IF;
    
    -- Aggiornamento della Tessera ed Email
    UPDATE Tessera
    SET DataScadenza = ADD_MONTHS(TRUNC(SYSDATE),12*offset)
    WHERE IDT = IDT_T;
    UPDATE Cliente SET Email = in_email
    WHERE ClienteCF = (SELECT ClienteCF FROM Cliente JOIN Tessera ON Cliente.ClienteCF = Tessera.CF_Cliente WHERE ClienteCF = cf_cli);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20029,'Tessera non trovata');
        ROLLBACK;
        WHEN tessera_non_scaduta THEN
            RAISE_APPLICATION_ERROR(-20030, 'La tessera risulta attiva.');
        ROLLBACK;
    END;

/