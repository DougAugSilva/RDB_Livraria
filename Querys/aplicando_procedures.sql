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

EXEC dbo.insere_tipos_de_erros_stage

--====================================================================================
-- Executa proceadures para inserção das tabelas essenciais do STAGE para o LIVRARIADB
--====================================================================================
USE LIVRARIADB;

EXEC dbo.insere_cep_livrariadb_2

EXEC dbo.insere_livro_livrariadb

EXEC dbo.insere_loja_livrariadb

EXEC dbo.insere_atendente_livrariadb

EXEC dbo.insere_tipo_endereco_livrariadb

EXEC dbo.insere_tipo_desconto_livrariadb

EXEC dbo.insere_tipo_pagamento_livrariadb

EXEC dbo.insere_autor_livrariadb
-- ======================================================
-- Verifica valores inseridos da tabelas essenciais STAGE
-- ======================================================
USE STAGE;

-- dbo.insere_cep_stage
SELECT TOP 100 * FROM CEP;

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

-- dbo.insere_tipos_de_erros_stage
SELECT * FROM TIPO_DE_ERRO;

-- ===========================================================
-- Verifica valores inseridos da tabelas essenciais LIVRARIADB
-- ===========================================================
USE LIVRARIADB;

-- dbo.insere_cep_livrariadb
SELECT TOP 100 * FROM CEP;

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
