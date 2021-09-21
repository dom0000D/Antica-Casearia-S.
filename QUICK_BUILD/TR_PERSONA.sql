CREATE OR REPLACE TRIGGER trigger_eta_persona
BEFORE INSERT OR UPDATE ON Persona
FOR EACH ROW

DECLARE
non_maggiorenne EXCEPTION;

BEGIN
IF ((trunc(SYSDATE)-:NEW.DataNascitaP)/365<18) THEN 
	RAISE non_maggiorenne;
END IF;

EXCEPTION
WHEN non_maggiorenne THEN
	RAISE_APPLICATION_ERROR (-20001,'La persona deve essere necessariamente maggiorenne per ricevere una tessera.');
END;
/
