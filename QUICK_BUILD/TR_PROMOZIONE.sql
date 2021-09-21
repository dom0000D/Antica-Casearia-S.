CREATE OR REPLACE TRIGGER trigger_promozione
	BEFORE INSERT OR UPDATE ON Promozione 
	FOR EACH ROW

		DECLARE
			promozione_scaduta EXCEPTION;

		BEGIN
			IF (:NEW.DataScadenzaP <= trunc(SYSDATE)) THEN
				RAISE promozione_scaduta;
			END IF;

		EXCEPTION
			WHEN promozione_scaduta THEN
				RAISE_APPLICATION_ERROR (-20004,'La promozione risulta scaduta, riprovare.');
END;
/