	CREATE MATERIALIZED VIEW ANDAMENTO_PROMO
	AS
		SELECT elenco_prod.coupon, p.NomeProdotto, COUNT(*) as utilizzi
		FROM(
			SELECT promo_attive.coupon, promo_attive.CodEanProd
			FROM (SELECT *
				FROM promozione
				WHERE DataScadenzaP > SYSDATE) promo_attive
			JOIN utilizza uti
			ON promo_attive.coupon = uti.codCoupon
		)elenco_prod
		JOIN Prodotto p ON elenco_prod.CodEanProd = p.EAN
		GROUP BY elenco_prod.coupon, p.NomeProdotto
		ORDER BY utilizzi DESC;