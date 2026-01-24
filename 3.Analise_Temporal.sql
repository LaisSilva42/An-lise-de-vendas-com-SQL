SELECT * from Vendas limit 5;

SELECT DISTINCT(strftime('%Y', data_venda)) Ano from vendas
order BY Ano;

SELECT (strftime('%Y', data_venda)) Ano, COUNT(id_venda) total_vendas
from vendas
group by Ano
order BY Ano;

SELECT (strftime('%Y', data_venda)) Ano, STRFTIME('%m', data_venda) Mes, COUNT(id_venda) total_vendas
from vendas
group by Ano, Mes
order BY Ano;

SELECT (strftime('%Y', data_venda)) Ano, STRFTIME('%m', data_venda) Mes, COUNT(id_venda) total_vendas
from vendas
WHERE Mes in ('01', '11' ,'12')
group by Ano, Mes
order BY Ano;