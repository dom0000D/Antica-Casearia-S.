    CREATE TABLE Persona(
        CF CHAR(16) NOT NULL, 
        NomeP VARCHAR(30) NOT NULL,
        CognomeP VARCHAR(30) NOT NULL,
        DataNascitaP DATE NOT NULL,
        CONSTRAINT PK_PERSONA PRIMARY KEY (CF),
        CONSTRAINT CF_NOTVALID CHECK (REGEXP_LIKE (CF, '^[A-Za-z]{6}[0-9]{2}[A-Za-z]{1}[0-9]{2}[A-Za-z]{1}[0-9]{3}[A-Za-z]{1}$'))
    );

    CREATE TABLE CellularePersona(
        CF CHAR(16) NOT NULL,
        Cellulare VARCHAR(10),
        CONSTRAINT FK_CellulareP FOREIGN KEY (CF) REFERENCES Persona(CF),
        CONSTRAINT CELL_NOTVALID_PERSONA CHECK (LENGTH(Cellulare) >= 9 AND 
        LENGTH (Cellulare) <= 11)
    ); 

    CREATE TABLE Cliente(
        ClienteCF  CHAR(16) NOT NULL,
        Email VARCHAR(30),
        CONSTRAINT PK_CLIENTE PRIMARY KEY (ClienteCF),
        CONSTRAINT FK_CLIENTE FOREIGN KEY (ClienteCF) REFERENCES Persona(CF),
        CONSTRAINT EMAIL_NOTVALID CHECK (REGEXP_LIKE     (Email,'^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'))
    );

    CREATE TABLE Tessera(
        IDT CHAR(8) NOT NULL,
        DataScadenza DATE,
        CF_Cliente CHAR(16) NOT NULL, 
        DataErogazione DATE NOT NULL,
        CONSTRAINT PK_TESSERA PRIMARY KEY (IDT),
        CONSTRAINT FK_TESSERA FOREIGN KEY (CF_Cliente) REFERENCES Cliente(ClienteCF),
        CONSTRAINT IDT_NOTVALID CHECK (REGEXP_LIKE(IDT,'^[A-Z]{4}[0-9]{4}$'))
    );

    CREATE TABLE Veterinario(
        VeterinarioCF CHAR(16) NOT NULL,
        TitoloDiStudio VARCHAR(30),
        CONSTRAINT PK_VETERINARIO PRIMARY KEY (VeterinarioCF),
        CONSTRAINT FK_VETERINARIO FOREIGN KEY (VeterinarioCF) REFERENCES Persona(CF)
    );

    CREATE TABLE Carrello (
        Doc_N CHAR(9) NOT NULL,
        Quantita NUMBER,
        CONSTRAINT PK_CARRELLO PRIMARY KEY (Doc_N)
    ); 

    CREATE TABLE Prodotto(
        EAN CHAR(8) NOT NULL,
        NomeProdotto VARCHAR(40) NOT NULL,
        Prezzo NUMBER NOT NULL,
        CONSTRAINT PK_PRODOTTO PRIMARY KEY (EAN),
        CONSTRAINT EAN_NOTVALID CHECK (REGEXP_LIKE (EAN,'^[0-9]{8}$'))
    );

    CREATE TABLE Promozione(
        Coupon CHAR(4) NOT NULL,
        DataScadenzaP DATE NOT NULL,
        Sconto NUMBER NOT NULL,
        CodEANProd CHAR(8),
        CONSTRAINT PK_COUPON PRIMARY KEY (Coupon),
        CONSTRAINT SCONTO_PROMOZIONE CHECK (Sconto >= 10),
        CONSTRAINT COUPON_NOTVALID CHECK (REGEXP_LIKE (Coupon,'^[0-9]{4}$')),
        CONSTRAINT FK_PROMOZIONE FOREIGN KEY (CodEANProd) REFERENCES Prodotto(EAN)
    );

    CREATE TABLE utilizza(
		IDT_Tessera CHAR(8) NOT NULL,
		DataUtilizzo DATE NOT NULL,
		CodCoupon CHAR(4) NOT NULL,
		CONSTRAINT FK1_UTILIZZA FOREIGN KEY (IDT_Tessera) REFERENCES Tessera(IDT),
		CONSTRAINT FK2_UTILIZZA FOREIGN KEY (CodCoupon) REFERENCES Promozione(Coupon)
	);

    CREATE TABLE e_parte(
		ProdottoEAN CHAR(8),
		NumeroDoc CHAR(9),
		CONSTRAINT FK1_E_PARTE FOREIGN KEY (ProdottoEAN) REFERENCES Prodotto(EAN),
		CONSTRAINT FK2_E_PARTE FOREIGN KEY (NumeroDoc) REFERENCES Carrello(Doc_N)
	);

    CREATE TABLE acquista(
        CodiceFiscaleP CHAR(16) NOT NULL,
        NumeroDocumento CHAR(9) NOT NULL, 
        CONSTRAINT FK1_ACQUISTA FOREIGN KEY (CodiceFiscaleP) REFERENCES Persona(CF),
        CONSTRAINT FK2_ACQUISTA FOREIGN KEY (NumeroDocumento) REFERENCES Carrello(Doc_N)
    );

    CREATE TABLE Certificato(
        NumCertificato CHAR(6) NOT NULL,
        Idoneita CHAR(1)  not null,
        DataEmissione   DATE not null,
        CF_Veterinario Char(16) not null,
        CONSTRAINT  PK_CERTIFICATO PRIMARY KEY (NumCertificato),
        CONSTRAINT  FK_CERTIFICATO FOREIGN KEY (CF_Veterinario) REFERENCES
        Veterinario(VeterinarioCF),
        CONSTRAINT  IDO_NOTVALID  CHECK (Idoneita IN ('T','F'))
    );

    CREATE TABLE Allevatore(
        P_IVA CHAR(11) NOT NULL,
        NomeAllevamento VARCHAR(30) NOT NULL,
        MqTerreno NUMBER,
        ModAllevamento VARCHAR(30) NOT NULL,
        Via VARCHAR(30),
        Cap CHAR(5) NOT NULL,
        Citta VARCHAR(30) NOT NULL,
        CONSTRAINT PK_ALLEVATORE PRIMARY KEY (P_IVA),
        CHECK (( ModAllevamento = 'Intensivo') OR (ModAllevamento = 'Estensivo')),
        CONSTRAINT PIVA_NOTVALID CHECK (REGEXP_LIKE ( P_IVA,'^[0-9]{11}'))
    );

    CREATE TABLE Animale(
        EarTag CHAR(6) NOT NULL,
        Specie VARCHAR(30) NOT NULL,
        DataNascita DATE,
        Peso NUMBER,
        PartitaIVA CHAR(11) NOT NULL,
        CertificatoA CHAR(6) NOT NULL,
        CHECK (Specie IN ('Bovino','Caprino','Ovino')),
        CONSTRAINT PK_ANIMALE PRIMARY KEY (EarTag),
        CONSTRAINT FK1_ANIMALE FOREIGN KEY (PartitaIVA) REFERENCES Allevatore(P_IVA),
        CONSTRAINT FK2_ANIMALE FOREIGN KEY (CertificatoA) REFERENCES Certificato(NumCertificato)
    );

    CREATE TABLE DipendenteCaseificio(
        NumTesserino CHAR(5) NOT NULL,
        NomeD VARCHAR(30) NOT NULL,
        CognomeD VARCHAR(30) NOT NULL,
        DataNascitaD DATE NOT NULL,
        OreLavorative NUMBER NOT NULL,
        CostoOrario NUMBER,
        Ruolo VARCHAR(20) NOT NULL,
        CONSTRAINT PK_DIPENDENTE PRIMARY KEY (NumTesserino),
        CONSTRAINT RUOLO_DIPENDENTE CHECK (Ruolo IN ('Cassiere','Casaro','Addetto',
        'Trasportatore'))
    );

    CREATE TABLE CellulareDipendente(
        Tesserino CHAR(5) NOT NULL,
        Cellulare VARCHAR(10) NOT NULL,
        CONSTRAINT FK_CELL_DIPENDENTE FOREIGN KEY (Tesserino) REFERENCES 
        DipendenteCaseificio(NumTesserino),
        CONSTRAINT CELL_NOTVALID_DIPENDENTE CHECK (LENGTH(Cellulare) >= 9 AND 
        LENGTH (Cellulare) <= 11)
    );   

    CREATE TABLE Reparto(
        CodR CHAR(5) NOT NULL,
        NomeR VARCHAR(30) NOT NULL,
        CapienzaR NUMBER,
        CONSTRAINT PK_REPARTO PRIMARY KEY (CodR),
        CHECK (CapienzaR <= 10)
    );

    CREATE TABLE Veicolo(
        Targa CHAR(7) NOT NULL,
        CapienzaV NUMBER,
        TipoUnita VARCHAR(20) NOT NULL,
        CONSTRAINT PK_VEICOLO PRIMARY KEY (Targa),
        CHECK (TipoUnita IN ('Autocarro', 'Cisterna', 'Rimorchio', 'Scarrabile')),
        CONSTRAINT TARGA_NOTVALID CHECK (REGEXP_LIKE (Targa,'^[A-Za-z]{2}[0-9]{3}[A-Za-z]{2}$'))
    );

    CREATE TABLE TurnoLavorativo(
        Data_Ora DATE NOT NULL,
        CodiceReparto CHAR(5) NOT NULL,
        CassiereTess CHAR(5) NOT NULL,
        CasaroTess CHAR(5) NOT NULL,
        CONSTRAINT PK_TurnoL PRIMARY KEY (Data_Ora, CodiceReparto),
        CONSTRAINT FK1_TurnoL FOREIGN KEY (CodiceReparto) REFERENCES Reparto(CodR),
        CONSTRAINT FK2_TurnoL FOREIGN KEY (CassiereTess) REFERENCES 
        DipendenteCaseificio(NumTesserino),
        CONSTRAINT FK3_TurnoL FOREIGN KEY (CasaroTess) REFERENCES 
        DipendenteCaseificio (NumTesserino)
    );

    CREATE TABLE Latte(
        NumBollino CHAR(7) NOT NULL,
        DataProduzione DATE NOT NULL,
        DataScadenza DATE NOT NULL,
        Tipologia VARCHAR(30) NOT NULL,
        QuantitaL NUMBER NOT NULL,
        TempConservazione VARCHAR(30),
        Data_OraTL DATE NOT NULL,
        CodRepartoTL CHAR(5) NOT NULL,
        CONSTRAINT PK_LATTE PRIMARY KEY (NumBollino),
        CONSTRAINT FK_LATTE FOREIGN KEY (Data_OraTL, CodRepartoTL) REFERENCES TurnoLavorativo(Data_Ora, CodiceReparto)
    );

   CREATE TABLE produce(
        CodiceEarTag CHAR(6) NOT NULL,
        NumeroBollino CHAR(7) NOT NULL,
        CONSTRAINT FK1_PRODUCE FOREIGN KEY (CodiceEarTag) REFERENCES Animale (EarTag),
        CONSTRAINT FK2_PRODUCE FOREIGN KEY (NumeroBollino) REFERENCES Latte (NumBollino)
    );

    CREATE TABLE assiste(
        AddettoTess CHAR(5) NOT NULL,
        CodiceRep CHAR(5) NOT NULL,
        DataOraTL DATE NOT NULL,
        CONSTRAINT FK1_ASSISTE FOREIGN KEY (AddettoTess) REFERENCES 
        DipendenteCaseificio(NumTesserino),
        CONSTRAINT FK2_ASSISTE FOREIGN KEY (CodiceRep) REFERENCES Reparto(CodR),
        CONSTRAINT FK3_ASSISTE FOREIGN KEY (DataORATL, CodiceRep) REFERENCES 
        TurnoLavorativo(Data_Ora,CodiceReparto)
    );

    CREATE TABLE consegna(
        TrasportatoreTess CHAR(5) NOT NULL,
        CodiceRep CHAR(5) NOT NULL,
        DataOraTL DATE NOT NULL,
        CONSTRAINT FK1_CONSEGNA FOREIGN KEY (TrasportatoreTess) REFERENCES 
        DipendenteCaseificio(NumTesserino),
        CONSTRAINT FK2_CONSEGNA FOREIGN KEY (CodiceRep) REFERENCES Reparto(CodR),
        CONSTRAINT FK3_CONSEGNA FOREIGN KEY (DataOraTL, CodiceRep) REFERENCES
        TurnoLavorativo(Data_Ora,CodiceReparto)
    );

    CREATE TABLE si_adopera(
        Targa CHAR(7) NOT NULL,
        CodReparto CHAR(5) NOT NULL,
        Data_Ora_TL DATE NOT NULL,
        CONSTRAINT FK1_SI_ADOPERA FOREIGN KEY (Targa) REFERENCES Veicolo(Targa),
        CONSTRAINT FK2_SI_ADOPERA  FOREIGN KEY (CodReparto) REFERENCES Reparto(CodR),
        CONSTRAINT FK3_SI_ADOPERA  FOREIGN KEY (Data_Ora_TL, CodReparto) REFERENCES
        TurnoLavorativo(Data_Ora,CodiceReparto)
    );

    CREATE TABLE LabAnalisi(
        CUU CHAR(6)	NOT NULL, 
        NomeLab	VARCHAR(20)	NOT NULL, 
        Via VARCHAR(30), 
        Cap CHAR(5) NOT NULL, 
        Citta  VARCHAR(30) NOT NULL,
        CONSTRAINT PK_LAB_ANALISI PRIMARY KEY (CUU),
        CONSTRAINT CUU_NOTVALID CHECK (REGEXP_LIKE (CUU,'^[0-9,A-Z]{6}$'))
    );

    CREATE TABLE TelefonoLab(
        CUU_Lab	char(6)	NOT NULL, 
        Telefono VARCHAR(10) NOT NULL, 
        CONSTRAINT FK_LAB_ANALISI FOREIGN KEY (CUU_LAB) REFERENCES LabAnalisi (CUU),
        CONSTRAINT TEL_NOTVALID_LAB CHECK (LENGTH(Telefono) >=9 AND 
        LENGTH(Telefono) <=11)
    );

    CREATE TABLE Esame(
		CodMnemonico CHAR(5) NOT NULL,
		NomeEsame VARCHAR(30) NOT NULL,
		CONSTRAINT PK_ESAME PRIMARY KEY (CodMnemonico)
    );

    CREATE TABLE ConsegnaCampione(
		CodCamp CHAR(5) NOT NULL,
		Data_OraConsegna DATE NOT NULL,
		Data_Ora DATE NOT NULL,
		CodiceRepartoTL CHAR(5) NOT NULL,
		CONSTRAINT PK_CONSEGNA_CAMPIONE PRIMARY KEY (CodCamp),
		CONSTRAINT FK_CONSEGNA_CAMPIONE FOREIGN KEY (Data_Ora, CodiceRepartoTL) REFERENCES 
		TurnoLavorativo (Data_Ora, CodiceReparto)
    );

    CREATE TABLE Referto(
	    CodPrestazione CHAR(8) NOT NULL,
	    NomeAnalista VARCHAR(30),
	    CognomeAnalista VARCHAR(30),
	    CUU_LabA CHAR(6),
	    CodCampione CHAR(5),
	    CONSTRAINT PK_REFERTO PRIMARY KEY (CodPrestazione),
	    CONSTRAINT FK1_REFERTO FOREIGN KEY (CUU_LabA) REFERENCES 
	    LabAnalisi(CUU),
	    CONSTRAINT FK2_REFERTO FOREIGN KEY (CodCampione) REFERENCES
	    ConsegnaCampione(CodCamp)
    );

     CREATE TABLE Fattura(
	   CodFattura CHAR(7) NOT NULL,
	   Importo NUMBER NOT NULL,
	   DataTurnoLavorativo DATE,
	   Codice_Reparto CHAR(5),
	   Num_Doc CHAR(9),
	   CodiceFiscalePersona CHAR(16),
	   CONSTRAINT PK_FATTURA PRIMARY KEY (CodFattura),
	   CONSTRAINT FK1_FATT FOREIGN KEY (DataTurnoLavorativo,Codice_Reparto) REFERENCES
	   TurnoLavorativo(Data_Ora,CodiceReparto),
	   CONSTRAINT FK2_FATT FOREIGN KEY (Num_Doc) REFERENCES Carrello(Doc_N),
	   CONSTRAINT FK3_FATT FOREIGN KEY (CodiceFiscalePersona) REFERENCES Persona(CF),
	   CONSTRAINT FATTURA_NOTVALID CHECK (REGEXP_LIKE (CodFattura,'^FA[0-9]{2}[A-Za-z]{3}$'))
    );

    CREATE TABLE e_composta_da(
	   CodicePrestazione CHAR(8) NOT NULL,
	   CodiceMnemonico CHAR(5) NOT NULL,
	   ValEsito NUMBER NOT NULL,
	   Giudizio CHAR(3) NOT NULL,
	   CONSTRAINT FK1_COMP FOREIGN KEY (CodicePrestazione) REFERENCES Referto(CodPrestazione),
	   CONSTRAINT FK2_COMP FOREIGN KEY (CodiceMnemonico) REFERENCES Esame(CodMnemonico),
	   CONSTRAINT COMP_NOTVALID CHECK (Giudizio IN ('pos','neg'))
    );