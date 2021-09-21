	CREATE OR REPLACE TRIGGER trigger_latte
		BEFORE INSERT ON Latte
		FOR EACH ROW

		DECLARE
			offset NUMBER;
			latt Latte%ROWTYPE;
			latte_nonscaduto EXCEPTION;
			latte_scaduto EXCEPTION;

		BEGIN
			IF INSERTING THEN
			-- Controllo se il latte non e'' scaduto. 
			-- Nel caso non ci sia verra' sollevata un eccezione
			-- del tipo NOT_DATA_FOUND
			SELECT * 
			INTO latt
			FROM Latte
			WHERE NumBollino = :NEW.NumBollino;

			-- Controllo se e' scaduta. 
			IF (latt.DataScadenza > TRUNC(SYSDATE)) THEN
				RAISE latte_nonscaduto;
			END IF;
			END IF;
			RAISE latte_scaduto;
		
		EXCEPTION

            WHEN NO_DATA_FOUND THEN

			-- Imposto la data di scadenza customizzata
			:NEW.DataScadenza := ADD_MONTHS(:NEW.DataProduzione,12*offset);


        WHEN latte_nonscaduto THEN
				RAISE_APPLICATION_ERROR (-20011,'Il latte non e'' ancora scaduto.');
		WHEN latte_scaduto THEN 
				RAISE_APPLICATION_ERROR (-20012,'Il latte e'' scaduto.');
		END;
/