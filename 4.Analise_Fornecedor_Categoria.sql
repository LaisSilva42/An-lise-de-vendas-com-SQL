-- papel dos fornecedores na black friday

SELECT strftime('%Y/%m', v.data_venda) AS "Ano/Mes", f.nome AS Nome_Fornecedor, COUNT(p.id_produto) as Qtd_Vendas
from itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP by "Ano/Mes", Nome_Fornecedor
ORDER by "Ano/Mes";

-- categoria de produtos na black friday

SELECT strftime('%Y/%m', v.data_venda) AS "Ano/Mes", c.nome_categoria AS Categoria, COUNT(p.id_produto) as Qtd_Vendas
from itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP by "Ano/Mes", Categoria
ORDER by "Ano/Mes";

-- Análise da performance de vendas do fornecedor "NebulaNetworks" ao longo do tempo

SELECT strftime('%Y/%m', v.data_venda) AS "Ano/Mes", COUNT(iv.produto_id) AS Qtd_Vendas
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE f.nome='NebulaNetworks'
GROUP BY "Ano/Mes"
ORDER BY "Ano/Mes", Qtd_Vendas;

-- Análise da performance de vendas do fornecedor "NebulaNetworks" ao longo do tempo e comparando outros fornecedores.

SELECT strftime('%Y/%m', v.data_venda) AS "Ano/Mes", f.nome AS Nome_Fornecedor, COUNT(p.id_produto) as Qtd_Vendas
from itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE Nome_Fornecedor IN ('NebulaNetworks', 'AstroSupply', 'NebulaNetworks')
GROUP by "Ano/Mes", Nome_Fornecedor
ORDER by "Ano/Mes";

-- Extraindo Dados para montar um gráfico de linhas comparando os fornecedores.
SELECT "Ano/Mes",
SUM( CASE WHEN Nome_fornecedor = 'NebulaNetworks' THEN Qtd_vendas ELSE 0 END) as Qtd_vendas_NebulaNetworks,
SUM( CASE WHEN Nome_fornecedor = 'AstroSupply' THEN Qtd_vendas ELSE 0 END) as Qtd_vendas_AstroSupply,
SUM( CASE WHEN Nome_fornecedor = 'HorizonDistributors' THEN Qtd_vendas ELSE 0 END) as Qtd_vendas_HorizonDistributors
FROM(
  SELECT strftime('%Y/%m', v.data_venda) AS "Ano/Mes", f.nome AS Nome_Fornecedor, COUNT(p.id_produto) as Qtd_Vendas
  from itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON p.id_produto = iv.produto_id
  JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
  WHERE Nome_Fornecedor IN ('NebulaNetworks', 'AstroSupply', 'HorizonDistributors')
  GROUP by "Ano/Mes", Nome_Fornecedor
  ORDER by "Ano/Mes", Qtd_Vendas
  ) AS tabela_resumo
GROUP by "Ano/Mes";

-- Porcentagem de categorias

SELECT Categoria, Qtd_Vendas, ROUND(100.0*Qtd_Vendas/(SELECT COUNT(*) from itens_venda), 2) || '%' AS Porcentagem
FROM(
  SELECT c.nome_categoria AS Categoria, COUNT(p.id_produto) as Qtd_Vendas
  from itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON p.id_produto = iv.produto_id
  JOIN categorias c ON c.id_categoria = p.categoria_id
  GROUP by Categoria
  )
AS tabela_resumo
ORDER by Qtd_Vendas DESC
;

-- Porcentagem de Marcas Análise de Marcas:

SELECT Marca, Qtd_Vendas, ROUND(100.0*Qtd_Vendas/(SELECT COUNT(*) from itens_venda), 2) || '%' AS Porcentagem
FROM(
  SELECT m.nome AS Marca, COUNT(p.id_produto) as Qtd_Vendas
  from itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON p.id_produto = iv.produto_id
  JOIN marcas m ON m.id_marca = p.marca_id
  GROUP by Marca
  )
AS tabela_resumo
ORDER by Qtd_Vendas DESC
;

-- Porcentagem de Marcas Análise de fornecedor:

SELECT Fornecedor, Qtd_Vendas, ROUND(100.0*Qtd_Vendas/(SELECT COUNT(*) from itens_venda), 2) || '%' AS Porcentagem
FROM(
  SELECT f.nome AS Fornecedor, COUNT(p.id_produto) as Qtd_Vendas
  from itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON p.id_produto = iv.produto_id
  JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
  GROUP by Fornecedor
  )
AS tabela_resumo
ORDER by Qtd_Vendas DESC
;