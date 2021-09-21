-- AnticaCaseariaS	
	-- Casaro
	GRANT SELECT ON DipendenteCaseificio TO Casaro;
	GRANT ALL PRIVILEGES ON CellulareDipendente TO Casaro;
	GRANT ALL PRIVILEGES ON TurnoLavorativo TO Casaro;
	GRANT ALL PRIVILEGES ON Reparto TO Casaro;
	GRANT ALL PRIVILEGES ON Veicolo TO Casaro;
	GRANT ALL PRIVILEGES ON ConsegnaCampione TO Casaro;
	GRANT SELECT  ON LabAnalisi TO Casaro;
	GRANT SELECT  ON TelefonoLab  TO Casaro;
        GRANT SELECT ON Referto TO Casaro;
        GRANT SELECT ON e_composta_da  TO Casaro;
        GRANT SELECT ON Esame TO Casaro;
        GRANT ALL PRIVILEGES ON Latte TO Casaro;
        GRANT ALL PRIVILEGES ON Promozione TO Casaro;
        GRANT ALL PRIVILEGES ON Prodotto TO Casaro;
        GRANT SELECT ON Persona TO Casaro;
        GRANT SELECT ON CellularePersona TO Casaro;
        GRANT SELECT ON Allevatore TO Casaro;
        GRANT SELECT ON Animale TO Casaro;
        GRANT SELECT ON Certificato TO Casaro;
        GRANT SELECT ON Veterinario TO Casaro;
	
	-- Cassiere
	GRANT SELECT ON DipendenteCaseificio TO Cassiere;
	GRANT ALL PRIVILEGES ON CellulareDipendente TO Cassiere;
	GRANT SELECT ON TurnoLavorativo TO Cassiere;
	GRANT SELECT ON Reparto TO Cassiere;
	GRANT SELECT ON Persona TO Cassiere;
	GRANT SELECT ON CellularePersona TO Cassiere;
	GRANT ALL PRIVILEGES ON Cliente TO Cassiere;
	GRANT ALL PRIVILEGES ON CellularePersona TO Cassiere;
	GRANT SELECT,INSERT ON Tessera TO Cassiere;
	GRANT SELECT,INSERT ON utilizza TO Cassiere;
	GRANT SELECT ON Promozione TO Cassiere;
	GRANT ALL PRIVILEGES ON Carrello  TO Cassiere;
    GRANT SELECT,UPDATE ON acquista TO Cassiere;
	GRANT ALL PRIVILEGES ON Fattura  TO Cassiere;
	
	-- Addetto
	GRANT SELECT ON DipendenteCaseificio TO Addetto;
	GRANT ALL PRIVILEGES ON CellulareDipendente TO Addetto;
	GRANT SELECT ON TurnoLavorativo TO Addetto;
	GRANT SELECT ON Reparto TO Addetto;
	GRANT SELECT ON ConsegnaCampione TO Addetto;
	GRANT SELECT ON Latte TO Addetto;
	GRANT SELECT ON Animale TO Addetto;
	GRANT SELECT ON Certificato TO Addetto;
	
	-- Trasportatore
	GRANT SELECT ON DipendenteCaseificio TO Trasportatore;
	GRANT ALL PRIVILEGES ON CellulareDipendente TO Trasportatore;
	GRANT SELECT ON TurnoLavorativo TO Trasportatore;
	GRANT SELECT ON Reparto TO Trasportatore;
	GRANT SELECT ON Veicolo TO Trasportatore;
	GRANT SELECT ON ConsegnaCampione TO Trasportatore;
	GRANT SELECT ON LabAnalisi TO Trasportatore;
	GRANT SELECT ON TelefonoLab TO Trasportatore;
	GRANT SELECT ON Latte TO Trasportatore;
	GRANT SELECT ON Animale TO Trasportatore;
	GRANT SELECT ON Allevatore TO Trasportatore;
	
	-- Allevatore
	GRANT ALL PRIVILEGES ON Allevatore TO Allevatore;
	GRANT ALL PRIVILEGES ON Latte TO Allevatore;
	GRANT ALL PRIVILEGES ON Animale TO Allevatore;
	GRANT SELECT ON Veterinario TO Allevatore;
	GRANT SELECT ON Certificato TO Allevatore;
	GRANT SELECT ON Persona TO Allevatore;
	GRANT SELECT ON CellularePersona TO Allevatore;

	-- Cliente
	GRANT CREATE SESSION TO Cliente;
	GRANT SELECT ON Persona TO Cliente;
	GRANT ALL PRIVILEGES ON CellularePersona TO Cliente;
	GRANT INSERT,SELECT,UPDATE ON Cliente TO Cliente;
	GRANT SELECT ON Tessera TO Cliente;
	GRANT SELECT ON utilizza TO Cliente;
	GRANT SELECT ON Promozione TO Cliente;
	GRANT SELECT ON Prodotto TO Cliente;
	GRANT INSERT,SELECT,UPDATE ON Carrello TO Cliente;
	GRANT ALL PRIVILEGES ON Fattura TO Cliente;
	GRANT ALL PRIVILEGES ON acquista TO Cliente;
	
	--Analista
	GRANT SELECT ON ConsegnaCampione TO Analista;
	GRANT SELECT ON LabAnalisi TO Analista;
	GRANT SELECT ON TelefonoLab TO Analista;
	GRANT ALL PRIVILEGES ON Referto TO Analista;
	GRANT ALL PRIVILEGES ON e_composta_da TO Analista;
	GRANT ALL PRIVILEGES ON Esame TO Analista;
	GRANT SELECT ON Latte TO Analista;
	
	-- Veterinario
	GRANT SELECT ON Persona TO Veterinario;
	GRANT ALL PRIVILEGES ON CellularePersona TO Veterinario;
	GRANT INSERT,UPDATE,SELECT ON Veterinario TO Veterinario;
	GRANT ALL PRIVILEGES ON Certificato TO Veterinario;
	GRANT SELECT ON Animale TO Veterinario;
	GRANT SELECT ON Allevatore TO Veterinario;