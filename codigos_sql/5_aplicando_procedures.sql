-- EXECUTA PROCEADURES
USE master;
GO
EXEC dbo.insere_cliente;

USE master;
GO
EXEC dbo.insere_endereco_cliente;
-- ==========================================================
-- VERIFICA SE OS VALORES FORAM INSERIDOS EM "LIVRARIADB"
-- ==========================================================
USE LIVRARIADB;
GO
-- dbo.insere_cliente
SELECT * FROM CLIENTE;

-- dbo.insere_endereco_cliente;
SELECT * FROM ENDERECOS_CLIENTES;

-- ==================================================
-- VERIFICA OS VALORES NO STAGE "STAGE"
-- =================================================
USE STAGE;
GO
SELECT * FROM MOVIMENTACAO_LIVROS;
