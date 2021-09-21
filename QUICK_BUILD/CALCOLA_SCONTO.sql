CREATE OR REPLACE PROCEDURE calcola_sconto(in_coupon CHAR, in_data_scadenza DATE, in_sconto NUMBER, in_prodEAN CHAR) IS
    sconto_riferimento NUMBER;
	sconto_non_valido EXCEPTION;
    BEGIN
    
	IF in_sconto > 60 THEN
        RAISE sconto_non_valido;
    END IF;
	
    -- Seleziono lo sconto piu' consono
    SELECT MAX(sconto_max) as SCONTO
    INTO sconto_riferimento
    FROM utilizza 
    JOIN (
		SELECT Promozione.Coupon,MAX(promozione.sconto) as sconto_max
		FROM Promozione JOIN (SELECT * FROM Prodotto WHERE Prodotto.NomeProdotto = (SELECT DISTINCT Prodotto.NomeProdotto FROM Prodotto
		JOIN Promozione ON Prodotto.EAN = Promozione.CodEANProd
		WHERE Prodotto.EAN = in_prodEAN)
		) p
		ON Promozione.codEANProd = p.EAN
	
		WHERE Promozione.codEANProd = p.EAN
		GROUP BY promozione.sconto,promozione.coupon
	) used_promo
    ON utilizza.CodCoupon = used_promo.coupon
    GROUP BY utilizza.CodCoupon;
	
    
    -- Applico una maggiorazione del 5% allo sconto 
    sconto_riferimento := sconto_riferimento + 5;
    
    INSERT INTO promozione VALUES (in_coupon,in_data_scadenza,sconto_riferimento,in_prodEAN);
    
    COMMIT;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20026, 'Prodotto non trovato per effettuare lo sconto.');
            INSERT INTO promozione VALUES (in_coupon,in_data_scadenza,in_sconto,in_prodEAN);
            COMMIT;
		WHEN sconto_non_valido THEN
            RAISE_APPLICATION_ERROR(-20027, 'Secondo una scelta di mercato, lo sconto inserito risulta elevato.');
    END;
	/