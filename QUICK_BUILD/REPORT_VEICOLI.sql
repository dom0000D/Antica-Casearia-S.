	CREATE MATERIALIZED VIEW REPORT_VEICOLI
	AS
		SELECT vei.Targa, vei.TipoUnita, COUNT(*) as utilizzi
		FROM (SELECT *
			FROM Veicolo) vei
		JOIN si_adopera sa
		ON vei.Targa = sa.Targa
		GROUP BY vei.Targa, vei.TipoUnita
		ORDER BY utilizzi DESC;