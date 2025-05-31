--======================================
-- Deleta uma Proceadure caso necessario
-- =====================================
IF OBJECT_ID('nome_proceadure') IS NOT NULL
	DROP PROCEDURE nome_proceadure;
--============================================================
-- Executa proceadures de inserção tabelas essenciais no STAGE
--============================================================
USE STAGE;

EXEC dbo.insere_cep_stage

EXEC dbo.insere_livro_stage

EXEC dbo.insere_loja_stage

EXEC dbo.insere_atendente_stage

EXEC dbo.insere_tipo_endereco_stage

EXEC dbo.insere_tipo_desconto_stage

EXEC dbo.insere_tipo_pagamento_stage

EXEC dbo.insere_autor_stage

--====================================================================================
-- Executa proceadures para inserção das tabelas essenciais do STAGE para o LIVRARIADB
--====================================================================================
USE LIVRARIADB;

EXEC dbo.insere_cep_livrariadb

EXEC dbo.insere_livro_livrariadb

EXEC dbo.insere_loja_livrariadb

EXEC dbo.insere_atendente_livrariadb

EXEC dbo.insere_tipo_endereco_livrariadb

EXEC dbo.insere_tipo_desconto_livrariadb

EXEC dbo.insere_tipo_pagamento_livrariadb

EXEC dbo.insere_autor_livrariadb

--============================================================
-- Executa proceadure inserção da MOVIMENTACAO_LIVROS no STAGE
--============================================================
USE STAGE;

EXEC dbo.insere_csv_movimentacao_livros_stage

--==============================================================================
-- Executa proceadure inserção da MOVIMENTACAO_LIVROS do STAGE para o LIVRARIADB
--==============================================================================
USE LIVRARIADB;

EXEC dbo.insere_endereco_cliente_livrariadb

EXEC dbo.insere_cliente_livrariadb

EXEC dbo.insere_nota_fiscal_livrariadb

EXEC dbo.insere_item_venda_livrariadb

EXEC dbo.insere_historico_recebimento_livrariadb

EXEC dbo.insere_historico_divergente_livrariadb

EXEC dbo.insere_livro_e_autor_livrariadb

EXEC dbo.insere_loja_e_atendentes_livrariadb

-- ======================================================
-- Verifica valores inseridos da tabelas essenciais STAGE
-- ======================================================
USE STAGE;

-- dbo.insere_cep_stage
SELECT * FROM CEP;

-- dbo.insere_livro_stage
SELECT * FROM LIVRO;

--dbo.insere_loja_stage
SELECT * FROM LOJA;

--dbo.insere_tipo_desconto_stage
SELECT * FROM TIPO_DESCONTO;

--dbo.insere_atendente_stage
SELECT * FROM ATENDENTE;

-- dbo.insere_tipo_endereco_stage
SELECT * FROM TIPO_ENDERECO;

-- dbo.insere_tipo_pagamento_stage
SELECT * FROM TIPO_PAGAMENTO;

-- dbo.insere_autor_stage
SELECT * FROM AUTOR;

-- ===========================================================
-- Verifica valores inseridos da tabelas essenciais LIVRARIADB
-- ===========================================================
USE LIVRARIADB;

-- dbo.insere_cep_livrariadb
SELECT * FROM CEP;

-- dbo.insere_livro_livrariadb
SELECT * FROM LIVRO;

--dbo.insere_loja_livrariadb
SELECT * FROM LOJA;

--dbo.insere_tipo_desconto_livrariadb
SELECT * FROM TIPO_DESCONTO;

--dbo.insere_atendente_livrariadb
SELECT * FROM ATENDENTE;

-- dbo.insere_tipo_endereco_livrariadb
SELECT * FROM TIPO_ENDERECO;

-- dbo.insere_tipo_pagamento_livrariadb
SELECT * FROM TIPO_PAGAMENTO;

-- dbo.insere_autor_livrariadb
SELECT * FROM AUTOR;

-- ==========================================================
-- Verifica valores inseridos da MOVIMENTACAO_LIVROS no STAGE
-- ==========================================================
USE STAGE;

SELECT * FROM MOVIMENTACAO_LIVROS;

-- ===============================================================
-- Verifica valores inseridos da MOVIMENTACAO_LIVROS no LIVRARIADB
-- ===============================================================
USE LIVRARIADB;

-- dbo.insere_cliente_livrariadb
SELECT * FROM CLIENTE;

-- dbo.insere_endereco_cliente_livrariadb
SELECT * FROM ENDERECOS_CLIENTES;

-- dbo.insere_nota_fiscal_livrariadb
SELECT * FROM NOTA_FISCAL;

-- dbo.insere_item_venda_livrariadb
SELECT * FROM ITEM_VENDA;

-- dbo.insere_historico_recebimento_livrariadb
SELECT * FROM HISTORICO_RECEBIMENTO;

-- dbo.insere_historico_divergente_livrariadb
SELECT * FROM HISTORICO_DIVERGENTE;

-- dbo.insere_livro_e_autor_livrariadb
SELECT * FROM LIVRO;
SELECT * FROM AUTOR;

-- dbo.insere_loja_e_atendentes_livrariadb
SELECT * FROM LOJA
SELECT * FROM ATENDENTE

