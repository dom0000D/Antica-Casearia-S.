    CREATE OR REPLACE PROCEDURE genera_certificato(in_certificato CHAR, in_idoneita CHAR, in_data_emissione DATE ,in_cf_veterinario CHAR, in_eartag CHAR) IS 
    dataE DATE;
    vet_TDS VARCHAR(30);
    spec_animal VARCHAR(30);
    vet_non_idoneo EXCEPTION;
    cert_ancora_valido EXCEPTION;
    
    BEGIN
    
    -- Selezioniamo la Data di Emissione del Certificato interessato
    SELECT DataEmissione
    INTO dataE
    FROM Certificato
    JOIN Animale ON Certificato.NumCertificato = Animale.CertificatoA
    WHERE Animale.EarTag = in_eartag;
    
    -- Verifica se il certificato risulta essere ancora valido
    IF dataE > add_months( trunc(sysdate), -12*2 ) THEN
        RAISE cert_ancora_valido;
    END IF;
    
    -- Selezioniamo il Titolo di Studio del Veterinario e la Specie dell'animale da certificare
    SELECT TitoloDiStudio
    INTO vet_TDS
    FROM Veterinario
    WHERE VeterinarioCF = in_cf_veterinario;
    
    SELECT Specie
    INTO spec_animal
    FROM Animale
    WHERE EarTag = in_eartag;
    
    -- Verifichiamo se il veterinario ha le competenze adatte per certificare l'animale
    IF (vet_TDS = 'Laurea Triennale' AND spec_animal = 'Ovino' ) THEN
        -- Aggiornamento del Certificato
        UPDATE Certificato SET Idoneita=in_idoneita, DataEmissione=in_data_emissione, 
        CF_Veterinario=in_cf_veterinario WHERE NumCertificato=in_certificato;
    ELSE
        IF (vet_TDS = 'Laurea Magistrale') THEN
            -- Aggiornamento del Certificato
            UPDATE Certificato SET Idoneita=in_idoneita, DataEmissione=in_data_emissione, 
            CF_Veterinario=in_cf_veterinario WHERE NumCertificato=in_certificato;
        ELSE
            RAISE vet_non_idoneo;
        END IF;	
    END IF;
	
	EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	        RAISE_APPLICATION_ERROR(-20033,'Il cf inserito non e'' di un veterinario.');
	    ROLLBACK;
	    WHEN vet_non_idoneo THEN
	        RAISE_APPLICATION_ERROR(-20034, 'Il veterinario inserito non e'' abilitato a 
	        generare certificati su questa specie.');
	    ROLLBACK;
	    WHEN cert_ancora_valido THEN
	        RAISE_APPLICATION_ERROR(-20035, 'Il certificato dell''animale risulta ancora 
	        valido.');
	    ROLLBACK;
    END;
/