CREATE OR REPLACE TRIGGER trigger_utilizza
		BEFORE INSERT OR UPDATE ON utilizza
		FOR EACH ROW

		DECLARE
			promo Promozione%ROWTYPE;
			promo_scaduta EXCEPTION;
			limite_uso_mensile EXCEPTION;
			limite_uso_giornaliero EXCEPTION;
			num_utilizzi NUMBER;
		BEGIN
			-- Controllo se la convenzione che si vuole utilizzare e' scaduta
			SELECT * 
			INTO promo
			FROM Promozione  
			WHERE Coupon = :NEW.CodCoupon;

			IF (promo.DataScadenzaP <= :NEW.DataUtilizzo) THEN
				RAISE promo_scaduta;
			END IF;

			-- Applicazione della limitazione di utilizzo tessera
			-- Controllo limite mensile (20 utilizzi)
			SELECT COUNT(*)
			INTO num_utilizzi
			FROM utilizza
			WHERE IDT_Tessera = :NEW.IDT_Tessera
			AND DataUtilizzo > ADD_MONTHS(:NEW.DataUtilizzo,-1);

			IF num_utilizzi = 20 THEN
				RAISE limite_uso_mensile;
			END IF;
			
			-- Controllo limite giornaliero (5 utilizzi)
			SELECT COUNT(*)
			INTO num_utilizzi
			FROM utilizza
			WHERE IDT_Tessera = :NEW.IDT_Tessera
			AND DataUtilizzo = :NEW.DataUtilizzo;

			IF num_utilizzi = 5 THEN
				RAISE limite_uso_giornaliero;
			END IF;
		
		EXCEPTION
			WHEN promo_scaduta THEN
				RAISE_APPLICATION_ERROR(-20005,'Promozione scaduta.');
			WHEN limite_uso_mensile THEN
				RAISE_APPLICATION_ERROR(-20006,'Limite utilizzo mensile tessera.');
			WHEN limite_uso_giornaliero THEN
				RAISE_APPLICATION_ERROR(-20007,'Limite utilizzo giornaliero tessera.');
END;
/