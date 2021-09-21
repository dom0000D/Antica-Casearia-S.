	CREATE OR REPLACE TRIGGER trigger_assiste
		BEFORE INSERT OR UPDATE ON assiste
		FOR EACH ROW

		DECLARE 
			non_addetto EXCEPTION;
			limite_addetto EXCEPTION;
			addetto_occupato EXCEPTION;
			supporto_recente EXCEPTION;

			dipcase DipendenteCaseificio%ROWTYPE;
			num_add NUMBER;
			u_turno DATE;
		BEGIN

			SELECT *
			INTO dipcase
			FROM DipendenteCaseificio
			WHERE NumTesserino = :NEW.AddettoTess;

			SELECT COUNT(*)
			INTO num_add
			FROM assiste
			WHERE DataOraTL = :NEW.DataOraTL
			AND CodiceRep  = :NEW.CodiceRep;

			IF dipcase.ruolo <> 'Addetto' THEN
				RAISE non_addetto;
			END IF;

			IF num_add = 10 THEN
				RAISE limite_addetto;
			END IF;

			-- Seleziona l'ultimo turno lavorativo dell'addetto
			SELECT MAX(DataOraTL)
			INTO u_turno
			FROM assiste
			WHERE AddettoTess=:NEW.AddettoTess;

			IF (:NEW.DataOraTL = u_turno) THEN
				RAISE addetto_occupato;
			END IF;

			IF ((:NEW.DataOraTL-u_turno)/7) < 1 THEN
				RAISE supporto_recente;
			END IF;

			EXCEPTION
				WHEN non_addetto THEN
					RAISE_APPLICATION_ERROR
					(-20011,'Il dipendente del caseificio non risulta un addetto');
				WHEN limite_addetto THEN
					RAISE_APPLICATION_ERROR
					(-20012,'Limite di addetti raggiunti');
				WHEN supporto_recente THEN
					RAISE_APPLICATION_ERROR
					(-20013,'L''addetto ha fatto un turno lavorativo questa settimana');
				WHEN addetto_occupato THEN
					RAISE_APPLICATION_ERROR
					(-20014,'L'' addetto risulta assegnato ad un altro turno');
		END;
/