	CREATE MATERIALIZED VIEW CLASSIFICA_CLIENTI
	AS
		SELECT tes_cli.IDT, tes_cli.NomeP, tes_cli.CognomeP,COUNT(*) as acquisti
		FROM(
			SELECT tes.IDT, cli.NomeP, cli.CognomeP
			FROM (SELECT p.cf,p.NomeP,p.CognomeP, c.email 
			FROM Persona p 
			JOIN Cliente c ON p.CF=c.ClienteCF
			) cli JOIN Tessera tes
			ON cli.cf = tes.CF_Cliente
		) tes_cli JOIN utilizza uti
		ON tes_cli.IDT = uti.IDT_Tessera
		GROUP BY  tes_cli.IDT, tes_cli.NomeP, tes_cli.CognomeP
		ORDER BY acquisti DESC;
