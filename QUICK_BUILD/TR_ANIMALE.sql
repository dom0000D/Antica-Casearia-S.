CREATE OR REPLACE TRIGGER trigger_animale
	BEFORE INSERT ON Animale
        FOR EACH ROW

        DECLARE
        	animal Animale%ROWTYPE;
		Bovinop_non_valido EXCEPTION;
		Ovinop_non_valido EXCEPTION;
		Caprinop_non_valido EXCEPTION;
        
        BEGIN
        
        	SELECT *
		INTO animal
        	FROM Animale
		WHERE Specie = :new.Specie AND ROWNUM=1;
        	

        	CASE
        		WHEN :NEW.Specie = 'Bovino' AND :new.Peso NOT BETWEEN 200 AND 250  THEN
				RAISE Bovinop_non_valido;
			
			WHEN :NEW.Specie = 'Ovino' AND :new.Peso NOT BETWEEN 100 AND 150 THEN
                		RAISE Ovinop_non_valido;
			
			WHEN :NEW.Specie = 'Caprino' AND :new.Peso NOT BETWEEN 50 AND 100 THEN
                		RAISE Caprinop_non_valido;
			ELSE
				animal.Peso := :new.Peso;

		END CASE;

        	EXCEPTION

        		WHEN Bovinop_non_valido THEN
            			RAISE_APPLICATION_ERROR(-20018, 'Il peso del bovino deve essere compreso tra i 200 KG - 250 KG.');
			WHEN Ovinop_non_valido THEN
            			RAISE_APPLICATION_ERROR(-20019, 'Il peso dell''ovino deve essere compreso tra i 100 KG - 150 KG.');
			WHEN Caprinop_non_valido THEN
            			RAISE_APPLICATION_ERROR(-20020, 'Il peso del caprino deve essere compreso tra i 50 KG - 100 KG.');
END;
/