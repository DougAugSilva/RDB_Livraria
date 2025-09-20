--======================================
-- Deleta uma Proceadure caso necessario
-- =====================================
IF OBJECT_ID('nome_proceadure') IS NOT NULL
	DROP PROCEDURE nome_proceadure;
--============================================================
-- Executa proceadures de inserção tabelas essenciais no STAGE
--============================================================
USE STAGE;

EXEC dbo.insere_cep_stage;
GO
EXEC dbo.insere_livro_stage;
GO
EXEC dbo.insere_loja_stage;
GO
EXEC dbo.insere_atendente_stage;
GO
EXEC dbo.insere_tipo_endereco_stage;
GO
EXEC dbo.insere_tipo_desconto_stage;
GO
EXEC dbo.insere_tipo_pagamento_stage;
GO
EXEC dbo.insere_autor_stage;
GO
EXEC dbo.insere_tipos_de_erros_stage;

--====================================================================================
-- Executa proceadures para inserção das tabelas essenciais do STAGE para o LIVRARIADB
--====================================================================================
USE LIVRARIADB;

EXEC dbo.insere_cep_livrariadb;
GO
EXEC dbo.insere_livro_livrariadb;
GO
EXEC dbo.insere_loja_livrariadb;
GO
EXEC dbo.insere_atendente_livrariadb;
GO
EXEC dbo.insere_tipo_endereco_livrariadb;
GO
EXEC dbo.insere_tipo_desconto_livrariadb;
GO
EXEC dbo.insere_tipo_pagamento_livrariadb;
GO
EXEC dbo.insere_autor_livrariadb;
--============================================================================
-- Executa proceadures que populam o LIVRARIADB pelo STAGE com dados das notas
--============================================================================
USE LIVRARIADB;

EXEC dbo.tratamento_dados;
GO
EXEC dbo.carregar_validacao;
GO
EXEC dbo.insere_cliente_livrariadb;
GO
EXEC dbo.insere_endereco_livrariadb;
GO
EXEC dbo.insere_item_venda_livrariadb;
GO
EXEC dbo.insere_nota_fiscal_livrariadb;
GO
EXEC dbo.insere_livroautor_livrariadb;

-- =======================================================
-- Verifica valores inseridos nas tabelas essenciais STAGE
-- =======================================================
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

-- ============================================================
-- Verifica valores inseridos nas tabelas essenciais LIVRARIADB
-- ============================================================
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

-- ===================================================================
-- Verifica valores inseridos pelas procedures de popular o LIVRARIADB
-- ===================================================================
USE LIVRARIADB;

-- dbo.tratamento_dados
SELECT * FROM STAGE.dbo.MOVIMENTACAO_LIVROS;
SELECT * FROM STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS;
SELECT * FROM STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS;

-- dbo.carregar_validacao
SELECT * FROM STAGE.dbo.VALIDACAO;

-- dbo.insere_cliente_livrariadb
SELECT * FROM CLIENTE;

-- dbo.insere_endereco_livrariadb
SELECT * FROM ENDERECOS_CLIENTES;

-- dbo.insere_nota_fiscal
SELECT * FROM NOTA_FISCAL;

-- dbo.insere_livroautor_livrariadb
SELECT * FROM LIVRO_AUTOR;