CREATE OR REPLACE TRIGGER trigger_turno_lavorativo
		BEFORE INSERT ON TurnoLavorativo
		FOR EACH ROW

		DECLARE 
			non_cassiere EXCEPTION;
			cassiere_occupato EXCEPTION;
			turno_recente EXCEPTION;

			dipcase DipendenteCaseificio%ROWTYPE;
			u_turno DATE;
		BEGIN
			-- Controllo che il dipendente del caseificio sia un cassiere
			SELECT *
			INTO dipcase
			FROM DipendenteCaseificio
			WHERE NumTesserino = :New.CassiereTess;
	
			IF dipcase.ruolo <> 'Cassiere' THEN
				RAISE non_cassiere;
			END IF;
		
			-- Seleziona l'ultimo turno lavorativo del cassiere
			SELECT MAX(Data_Ora)
			INTO u_turno
			FROM TurnoLavorativo
			WHERE CassiereTess=:NEW.CassiereTess;

			IF (:NEW.Data_Ora = u_turno) THEN
				RAISE cassiere_occupato;
			END IF;

			IF ((:NEW.Data_Ora-u_turno)/7) < 1 THEN
				RAISE turno_recente;
			END IF;

			EXCEPTION
				WHEN non_cassiere THEN
					RAISE_APPLICATION_ERROR
					(-20008,'Il dipendente del caseificio non e'' un cassiere.');
				WHEN cassiere_occupato THEN
					RAISE_APPLICATION_ERROR
					(-20009,'Il cassiere risulta assegnato ad un altro turno lavorativo.');
				WHEN turno_recente THEN
					RAISE_APPLICATION_ERROR
					(-20010,'Il cassiere ha fatto un turno lavorativo questa settimana.');
				WHEN NO_DATA_FOUND THEN
					NULL;
		END;
/