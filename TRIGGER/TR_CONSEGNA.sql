	CREATE OR REPLACE TRIGGER trigger_consegna
		BEFORE INSERT OR UPDATE ON consegna
		FOR EACH ROW

		DECLARE
			trasportatore_occupato EXCEPTION;
			occupato NUMBER;
		BEGIN

			SELECT COUNT(*)
			INTO occupato
			FROM consegna
			WHERE TrasportatoreTess = :NEW.TrasportatoreTess
			AND DataOraTL = :NEW.DataOraTL
			AND CodiceRep  = :NEW.CodiceRep;

			IF occupato > 0 THEN
				RAISE trasportatore_occupato;
			END IF;

		EXCEPTION

			WHEN trasportatore_occupato THEN
				RAISE_APPLICATION_ERROR
				(-20015,'Il trasportatore risulta occupato per quel turno lavorativo.');
		END;
/