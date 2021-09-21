	CREATE OR REPLACE TRIGGER trigger_tessera
		BEFORE INSERT ON tessera
		FOR EACH ROW

		DECLARE
			offset NUMBER;
			tess tessera%ROWTYPE;
			tessera_attiva EXCEPTION;
			tessera_scaduta EXCEPTION;
		BEGIN
			IF INSERTING THEN
			-- Controllo se e' presente gia' una tessera associata al cf. 
			-- Nel caso non ci sia verra' sollevata un eccezione
			-- del tipo NOT_DATA_FOUND
			SELECT * 
			INTO tess
			FROM tessera
			WHERE CF_Cliente = :NEW.CF_Cliente;

			-- Controllo se e' scaduta. 
			IF (tess.DataScadenza > TRUNC(SYSDATE)) THEN
				RAISE tessera_attiva;
			END IF;
			END IF;
			RAISE tessera_scaduta;
			
			EXCEPTION
		
			WHEN NO_DATA_FOUND THEN

			-- Imposto la data di scadenza customizzata
			:NEW.DataScadenza := ADD_MONTHS(:NEW.DataErogazione,12*offset);

			WHEN tessera_attiva THEN
				RAISE_APPLICATION_ERROR (-20002,'Esiste una tessera attiva associata alla persona.');
			WHEN tessera_scaduta THEN 
				RAISE_APPLICATION_ERROR (-20003,'Tessera esistente ma risulta scaduta.');
		END;
/