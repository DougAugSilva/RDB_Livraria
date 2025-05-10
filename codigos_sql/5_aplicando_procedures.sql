-- EXECUTA PROCEADURES
USE master;

EXEC dbo.insere_cliente;

EXEC dbo.insere_endereco_cliente;

EXEC dbo.insere_nota_fiscal;

EXEC dbo.insere_item_venda;

EXEC dbo.insere_historico_recebimento;

-- ==========================================================
-- VERIFICA SE OS VALORES FORAM INSERIDOS EM "LIVRARIADB"
-- ==========================================================
USE LIVRARIADB;
GO
-- dbo.insere_cliente
SELECT * FROM CLIENTE;

-- dbo.insere_endereco_cliente;
SELECT * FROM ENDERECOS_CLIENTES;

-- dbo.insere_nota_fiscal;
SELECT * FROM NOTA_FISCAL;

-- dbo.insere_item_venda;
SELECT * FROM ITEM_VENDA;

-- dbo.insere_historico_recebimento;
SELECT * FROM HISTORICO_RECEBIMENTO;

-- ==================================================
-- VERIFICA OS VALORES NO STAGE "STAGE"
-- =================================================
USE STAGE;
GO
SELECT * FROM MOVIMENTACAO_LIVROS;
