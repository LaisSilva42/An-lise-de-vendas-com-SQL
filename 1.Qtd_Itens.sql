-- Schema para visualizar Qtd de cada item de cada tabela em uma única vez

SELECT COUNT(*) AS QTD, 'Categorias' as Tabela FROM categorias
UNION ALL
SELECT COUNT(*) AS QTD, 'Clientes' as Tabela FROM clientes
UNION ALL
SELECT COUNT(*) AS QTD, 'Fornecedores' AS Tabela FROM fornecedores
UNION ALL
SELECT COUNT(*) AS QTD, 'Itens Venda' as Tabela FROM itens_venda
UNION ALL
SELECT COUNT(*) AS QTD, 'Marcas' AS Tabela FROM marcas
UNION ALL
SELECT COUNT(*) AS QTD, 'Produtos' AS Tabela FROM produtos
UNION ALL
SELECT COUNT(*) AS QTD, 'Vendas' as Tabela FROM vendas;