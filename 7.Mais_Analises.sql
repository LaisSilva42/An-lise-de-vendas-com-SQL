--Qual é o número de Clientes que existem na base de dados?
SELECT COUNT(*) Qtd_Clientes
From clientes;

-- Quantos produtos foram vendidos no ano de 2022 ?
SELECT Count(*) Qtd_Itens_Vendidos_2022
from produtos p
JOIN itens_venda iv ON p.id_produto = iv.produto_id
join vendas v ON v.id_venda = iv.venda_id
WHERE strftime('%Y', data_venda) = '2022';

-- Qual a categoria que mais vendeu em 2022 ?
SELECT c.nome_categoria, Count(*) Qtd_Vendas
from categorias c
JOIN produtos p ON p.categoria_id = c.id_categoria
JOIN itens_venda iv ON p.id_produto = iv.produto_id
join vendas v ON v.id_venda = iv.venda_id
WHERE strftime('%Y', data_venda) = '2022'
GROUP BY c.nome_categoria
ORDER BY Qtd_Vendas DESC
LIMIT 1;

-- Qual o primeiro ano disponível na base?
SELECT strftime('%Y', data_venda) Primeiro_Ano
FROM vendas
GROUP by Primeiro_Ano
ORDER BY Primeiro_Ano
limit 1;

-- Qual o nome do fornecedor que mais vendeu no primeiro ano disponível na base ?
SELECT f.nome
from fornecedores f
JOIN produtos p ON f.id_fornecedor = p.fornecedor_id
JOIN itens_venda iv ON p.id_produto = iv.produto_id
join vendas v ON v.id_venda = iv.venda_id
WHERE strftime('%Y', data_venda) = '2020'
GROUP BY f.id_fornecedor
ORDER BY Count(*) DESC
LIMIT 1;

-- Quanto ele vendeu no primeiro ano disponível na base de dados ?
SELECT Count(*) Qtd_Vendas
from fornecedores f
JOIN produtos p ON f.id_fornecedor = p.fornecedor_id
JOIN itens_venda iv ON p.id_produto = iv.produto_id
join vendas v ON v.id_venda = iv.venda_id
WHERE strftime('%Y', data_venda) = '2020'
GROUP BY f.id_fornecedor
ORDER BY Qtd_Vendas DESC
LIMIT 1;

-- Quais as duas categorias que mais venderam no total de todos os anos ?
SELECT c.nome_categoria, Count(*) Qtd_Vendas
from categorias c
JOIN produtos p ON p.categoria_id = c.id_categoria
JOIN itens_venda iv ON p.id_produto = iv.produto_id
join vendas v ON v.id_venda = iv.venda_id
GROUP BY c.nome_categoria
ORDER BY Qtd_Vendas DESC
LIMIT 2;

-- Crie uma tabela comparando as vendas ao longo do tempo das duas categorias que mais venderam no total de todos os anos.
SELECT nome_categoria,
	SUM(CASE WHEN Ano = '2020' THEN Qtd_Vendas ELSE 0 END) '2020',
	SUM(CASE WHEN Ano = '2021' THEN Qtd_Vendas ELSE 0 END) '2021',
	SUM(CASE WHEN Ano = '2022' THEN Qtd_Vendas ELSE 0 END) '2022',
	SUM(CASE WHEN Ano = '2023' THEN Qtd_Vendas ELSE 0 END) '2023'
FROM (
  SELECT strftime('%Y', v.data_venda) Ano, c.nome_categoria, Count(*) Qtd_Vendas
  from categorias c
  JOIN produtos p ON p.categoria_id = c.id_categoria
  JOIN itens_venda iv ON p.id_produto = iv.produto_id
  join vendas v ON v.id_venda = iv.venda_id
  WHERE c.nome_categoria IN ('Vestuário', 'Eletrônicos')
  GROUP BY Ano, c.nome_categoria
  ORDER BY Ano, Qtd_Vendas) AS tabela
GROUP BY nome_categoria;

-- Calcule a porcentagem de vendas por categorias no ano de 2022.
WITH Total_Vendas AS (
SELECT COUNT(*) as Total_Vendas_2022
From itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
WHERE strftime('%Y', v.data_venda) = '2022'
)
SELECT Nome_Categoria, Qtd_Vendas, ROUND(100.0*Qtd_Vendas/tv.Total_Vendas_2022, 2) || '%' AS Porcentagem
FROM(
  SELECT c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas
  from itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON p.id_produto = iv.produto_id
  JOIN categorias c ON c.id_categoria = p.categoria_id
  WHERE strftime('%Y', v.data_venda) = '2022'
  GROUP BY Nome_Categoria
  ORDER BY Qtd_Vendas DESC
  ), Total_Vendas tv
;

-- Crie uma métrica mostrando a porcentagem de vendas a mais que a melhor categoria tem em relação a pior no ano de 2022.

WITH Total_Vendas AS (
  SELECT COUNT(*) as Total_Vendas_2022
  FROM itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  WHERE strftime('%Y', v.data_venda) = '2022'
),
Vendas_Por_Categoria AS (
  SELECT 
    c.nome_categoria AS Nome_Categoria, 
    COUNT(iv.produto_id) AS Qtd_Vendas
  FROM itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON p.id_produto = iv.produto_id
  JOIN categorias c ON c.id_categoria = p.categoria_id
  WHERE strftime('%Y', v.data_venda) = '2022'
  GROUP BY Nome_Categoria
),
Melhor_Pior_Categorias AS (
  SELECT 
    MIN(Qtd_Vendas) AS Pior_Vendas, 
    MAX(Qtd_Vendas) AS Melhor_Vendas
  FROM Vendas_Por_Categoria
)
SELECT 
  Nome_Categoria, 
  Qtd_Vendas, 
  ROUND(100.0*Qtd_Vendas/tv.Total_Vendas_2022, 2) || '%' AS Porcentagem,
  ROUND(100.0*(Qtd_Vendas - Melhor_Vendas) / Melhor_Vendas, 2) || '%' AS Porcentagem_Mais_Que_Melhor
FROM Vendas_Por_Categoria
CROSS JOIN Total_Vendas tv
CROSS JOIN Melhor_Pior_Categorias;