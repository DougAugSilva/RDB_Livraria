-- Executa a inserção
USE master;
GO
EXEC dbo.insere_cliente;

-- Verifica se os valores foram inseridos em "LIVRARIADB"
USE LIVRARIADB;
GO
SELECT * FROM CLIENTE;

-- Verifica os valores no "STAGE"
USE STAGE;
GO
SELECT * FROM MOVIMENTACAO_LIVROS;
