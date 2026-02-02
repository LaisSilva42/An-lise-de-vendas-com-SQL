-- Métricas Black Friday

SELECT COUNT(*) Qtd_Vendas, strftime('%Y', data_venda) as Ano
FROM vendas
WHERE strftime('%m', data_venda) LIKE '11' AND Ano not like '2022'
GROUP BY Ano;
----
SELECT AVG(Qtd_Vendas) as Media_Qtd_Venda
FROM(
  SELECT COUNT(*) Qtd_Vendas, strftime('%Y', data_venda) as Ano
  FROM vendas
  WHERE strftime('%m', data_venda) LIKE '11' AND Ano not like '2022'
  GROUP BY Ano) as Tabela;
----
SELECT Qtd_Vendas AS Qtd_Vendas_Atual
FROM(
  SELECT COUNT(*) Qtd_Vendas, strftime('%Y', data_venda) as Ano
  FROM vendas
  WHERE strftime('%m', data_venda) LIKE '11' AND Ano like '2022'
  GROUP BY Ano) as Tabela;
---- 
WITH Media_Vendas_Anteriores AS (SELECT AVG(Qtd_Vendas) as Media_Qtd_Venda
  FROM(
    SELECT COUNT(*) Qtd_Vendas, strftime('%Y', data_venda) as Ano
    FROM vendas
    WHERE strftime('%m', data_venda) LIKE '11' AND Ano not like '2022'
    GROUP BY Ano) as Tabela),
    Vendas_Atual AS (SELECT Qtd_Vendas AS Qtd_Vendas_Atual
  FROM(
    SELECT COUNT(*) Qtd_Vendas, strftime('%Y', data_venda) as Ano
    FROM vendas
    WHERE strftime('%m', data_venda) LIKE '11' AND Ano like '2022'
    GROUP BY Ano) as Tabela)
  SELECT
  mva.Media_Qtd_Venda,
  va.Qtd_Vendas_Atual,
  ROUND((va.Qtd_Vendas_Atual - mva.Media_Qtd_Venda)/mva.Media_Qtd_Venda*100.0, 2) || '%' as Variacao_Desempenho
 FROM Vendas_Atual va, Media_Vendas_Anteriores mva