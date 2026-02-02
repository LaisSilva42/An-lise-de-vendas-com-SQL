--Quadro geral de vendas
SELECT Mes,
	SUM(CASE WHEN Ano LIKE '2020' THEN Qtd_Venda Else 0 END) AS "2020",
	SUM(CASE WHEN Ano LIKE '2021' THEN Qtd_Venda Else 0 END) AS "2021",
	SUM(CASE WHEN Ano LIKE '2022' THEN Qtd_Venda Else 0 END) AS "2022",
	SUM(CASE WHEN Ano LIKE '2023' THEN Qtd_Venda Else 0 END) AS "2023"
FROM(  
  SELECT strftime('%Y', data_venda) Ano,
  	strftime('%m', data_venda) Mes,
  	COUNT(*) Qtd_Venda
  FROM vendas
  GROUP by Ano, Mes
) as tabela
GROUP by Mes
order by Mes