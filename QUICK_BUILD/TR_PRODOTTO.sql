	CREATE OR REPLACE TRIGGER trigger_prodotto
		BEFORE UPDATE ON prodotto
        FOR EACH ROW

        DECLARE
        prezzo_non_valido EXCEPTION;
        FLAG boolean := FALSE;
        
        BEGIN
        IF :NEW.Prezzo < :OLD.Prezzo * 1.1 THEN
            FLAG := TRUE;
        END IF;
        IF NOT FLAG THEN
            RAISE prezzo_non_valido;
        END IF;

        EXCEPTION
        
        WHEN prezzo_non_valido THEN
            RAISE_APPLICATION_ERROR(-20016, 'Impossibile inserire un prezzo maggiore del 10% rispetto al precedente.');
    END;
/