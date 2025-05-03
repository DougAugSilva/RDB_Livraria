USE STAGE;

SELECT * FROM MOVIMENTACAO_LIVROS;

BULK INSERT MOVIMENTACAO_LIVROS 
FROM 'C:\Arquivos_banco_dados\carregar.csv' 
WITH(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
);

-- criar banco de dados livraria
-- criar store procidure debntro do livraria db que vai ler os arquivos dio stage
-- esta procidure vai popular o banco de dados do livraria db
-- cadastrat manualmente loja e atendente para poder ler o stage
-- caso o cliente não esteja caastrado, ele deve cadastrar como novo cliente
-- (verificar irtem por item se está cadastrado)
-- (caso já esteja cadastrado não faz insert)
-- criar arquivos .csv pelo vs code por conta de quebra de linha
