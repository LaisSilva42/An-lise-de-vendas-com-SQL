# Verifica os valores mínimos e máximos e atualiza para a mediana os valores fora do intervalo aceitável.

SELECT nome_produto, MIN(preco), MAX(preco) from produtos
GROUP BY nome_produto;

UPDATE produtos
SET preco = CASE
	WHEN nome_produto = 'Bola de Futebol' AND preco NOT BETWEEN 20 AND 100 THEN 60
    WHEN nome_produto = 'Camisa' AND preco Not BETWEEN 80 and 200 THEN 140
    WHEN nome_produto = 'Celular' and preco not BETWEEN 80 and 5000 THEN 2540
    WHEN nome_produto = 'Chocolate' AND preco Not BETWEEN 10 and 50 THEN 30
    WHEN nome_produto = 'Livro de Ficção' AND preco Not BETWEEN 10 and 200 THEN 105
    ELSE preco
END;