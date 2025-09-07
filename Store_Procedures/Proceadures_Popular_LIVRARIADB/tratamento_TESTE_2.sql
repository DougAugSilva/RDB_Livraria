-- arrumando os ceps do banco de dados.
USE STAGE;
GO 

ALTER PROCEDURE dbo.tratamento_dados_2
AS
BEGIN

    DECLARE db_cursor CURSOR FOR
        SELECT NOME_CLIENTE, NUMERO_ENDERECO, COMPLEMENTO, C.ID_CEP,  
            UPPER(TIPO_ENDERECO), 
            EMAIL_CLIENTE, TELEFONE_CLIENTE, CPF, NUMERO_NOTA_FISCAL, QUANTIDADE, VALOR_ITEM, VALOR_TOTAL, 
            UPPER(
                REPLACE(
                    REPLACE(
                        REPLACE(CONDICAO_PAGAMENTO, 'Entrada - ','')
                        , ' ', '')
                        , '3060', '')
                        ), 
            TITULO, AUTOR, ID_LOJA, ID_ATENDENTE, DATA_VENDA, DATA_PROCESSAMENTO
        FROM STAGE.dbo.MOVIMENTACAO_LIVROS AS MOV
        JOIN LIVRARIADB.dbo.CEP AS C ON MOV.CEP = C.CEP
        --TIPOS DE CONDICOES DE PAGAMENTO ACEITAS
        -- 30DIAS
        -- 60DIAS
        -- 90DIAS
        -- AVISTA
    
    DECLARE @nome_cliente       NVARCHAR(100);
    DECLARE @numero_endereco    INT;
    DECLARE @complemento        NVARCHAR(100);
    DECLARE @id_cep                NVARCHAR(15); 
    DECLARE @tipo_endereco      VARCHAR(5);
    DECLARE @email_cliente      NVARCHAR(100);
    DECLARE @telefone_cliente   NVARCHAR(20);
    DECLARE @cpf                NVARCHAR(14);
    DECLARE @numero_nota_fiscal INT;
    DECLARE @quantidade         INT;
    DECLARE @valor_item         DECIMAL(10,2);
    DECLARE @valor_total        DECIMAL(10,2);
    DECLARE @condicao_pagamento NVARCHAR(100);
    DECLARE @titulo             NVARCHAR(100);
    DECLARE @autor              NVARCHAR(100);
    DECLARE @id_loja            INT;
    DECLARE @id_atendente       INT;
    DECLARE @data_venda         DATE;
    DECLARE @data_processamento DATE;

    DECLARE @id_erro   INT;

    OPEN db_cursor
    FETCH NEXT FROM db_cursor INTO  @nome_cliente, @numero_endereco, @complemento, @id_cep, 
     @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
     @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
     @data_venda, @data_processamento;

    WHILE @@FETCH_STATUS = 0
	BEGIN

        -- Cria tabelas temporarias globais para tratamento dos dados
        DROP TABLE IF EXISTS ##pegar_notas_nao_processadas;
        DROP TABLE IF EXISTS ##pegar_notas_datas_certas;
        DROP TABLE IF EXISTS #seleciona_cep;
        -- tabela temporaria global
        CREATE TABLE ##pegar_notas_nao_processadas (
            NOME_CLIENTE         NVARCHAR(100)  NULL,   
            NUMERO_ENDERECO      INT            NULL,
            COMPLEMENTO          NVARCHAR(100)  NULL,
            ID_CEP               NVARCHAR(15)   NULL,
            TIPO_ENDERECO        VARCHAR(5)     NULL,
            EMAIL_CLIENTE        NVARCHAR(100)  NULL,    
            TELEFONE_CLIENTE     NVARCHAR(20)   NULL,      
            CPF                  NVARCHAR(14)   NULL,    
            NUMERO_NOTA_FISCAL   INT            NULL,
            QUANTIDADE           INT            NULL,
            VALOR_ITEM           DECIMAL(10,2)  NULL,
            VALOR_TOTAL          DECIMAL(10,2)  NULL,
            CONDICAO_PAGAMENTO   NVARCHAR(100)  NULL,
            TITULO               NVARCHAR(100)  NULL,
            AUTOR                NVARCHAR(100)  NULL,
            ID_LOJA              INT            NULL,
            ID_ATENDENTE         INT            NULL,
            DATA_VENDA           DATE           NULL,
            DATA_PROCESSAMENTO   DATE           NULL
        );
        --========================================================================
        -- 1 validação (seleciona as notas não processadas)
        INSERT INTO 
            ##pegar_notas_nao_processadas
        SELECT NOME_CLIENTE, NUMERO_ENDERECO, COMPLEMENTO, C.ID_CEP,  
            UPPER(TIPO_ENDERECO), 
            EMAIL_CLIENTE, TELEFONE_CLIENTE, CPF, NUMERO_NOTA_FISCAL, QUANTIDADE, VALOR_ITEM, VALOR_TOTAL, 
            UPPER(
                REPLACE(
                    REPLACE(
                        REPLACE(CONDICAO_PAGAMENTO, 'Entrada - ','')
                        , ' ', '')
                        , '3060', '')
                        ), 
            TITULO, AUTOR, ID_LOJA, ID_ATENDENTE, DATA_VENDA, DATA_PROCESSAMENTO
        FROM STAGE.dbo.MOVIMENTACAO_LIVROS AS MOV
        JOIN LIVRARIADB.dbo.CEP AS C ON MOV.CEP = C.CEP
        WHERE NOT EXISTS (
            SELECT 1 
            FROM STAGE.dbo.VALIDACAO
            WHERE NUMERO_NOTA_FISCAL = @numero_nota_fiscal
            AND DATA_PROCESSAMENTO  = @data_processamento
            );
        -- insere os rejeitados na MOVIMENTACAO_LIVROS_REJEITADOS  
        IF EXISTS (
            SELECT 1 
            FROM STAGE.dbo.VALIDACAO
            WHERE NUMERO_NOTA_FISCAL = @numero_nota_fiscal
            AND DATA_PROCESSAMENTO  = @data_processamento
        ) BEGIN
            SET @id_erro  = 1
        
            INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS (NOME_CLIENTE_REJEITADOS, NUMERO_ENDERECO_REJEITADOS, 
            COMPLEMENTO_REJEITADOS, ID_CEP_REJEITADOS,TIPO_ENDERECO_REJEITADOS, EMAIL_CLIENTE_REJEITADOS, 
            TELEFONE_CLIENTE_REJEITADOS, CPF_REJEITADOS, NUMERO_NOTA_FISCAL_REJEITADOS, QUANTIDADE_REJEITADOS, 
            VALOR_ITEM_REJEITADOS, VALOR_TOTAL_REJEITADOS, CONDICAO_PAGAMENTO_REJEITADOS, TITULO_REJEITADOS, 
            AUTOR_REJEITADOS, ID_LOJA_REJEITADOS,ID_ATENDENTE_REJEITADOS, DATA_VENDA_REJEITADOS,
             DATA_PROCESSAMENTO_REJEITADOS, ID_ERRO)

            VALUES (@nome_cliente, @numero_endereco, @complemento, @id_cep, 
            @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
            @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
            @data_venda, @data_processamento, @id_erro)
        END
        --========================================================================
        -- 2 validação (seleciona as notas com as datas de processamento válidas)
        CREATE TABLE ##pegar_notas_datas_certas(
            NUMERO_NOTA_FISCAL  INT    NULL,
            VERIFICADOS         VARCHAR(50)
        );

        INSERT INTO 
            ##pegar_notas_datas_certas
        SELECT
            NUMERO_NOTA_FISCAL,
            (CASE
            WHEN  MIN(DATA_PROCESSAMENTO) != MAX(DATA_PROCESSAMENTO) THEN 'REJEITADO'
            ELSE 'OK'
            END) AS VERIFICADOS       
        FROM 
            STAGE.dbo.MOVIMENTACAO_LIVROS
        GROUP BY 
            NUMERO_NOTA_FISCAL
        -- insere os rejeitados na MOVIMENTACAO_LIVROS_REJEITADOS   
        IF EXISTS (
            SELECT DISTINCT 
                1
            FROM 
                ##pegar_notas_datas_certas 
            WHERE 
                NUMERO_NOTA_FISCAL = @numero_nota_fiscal
                AND VERIFICADOS = 'REJEITADO'
        )BEGIN
            IF NOT EXISTS(
            SELECT * 
            FROM STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS
            WHERE NUMERO_NOTA_FISCAL_REJEITADOS = @numero_nota_fiscal 
            AND TITULO_REJEITADOS = @titulo
            )BEGIN
                SET @id_erro = 2

                INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS (NOME_CLIENTE_REJEITADOS, NUMERO_ENDERECO_REJEITADOS, 
                COMPLEMENTO_REJEITADOS, ID_CEP_REJEITADOS,TIPO_ENDERECO_REJEITADOS, EMAIL_CLIENTE_REJEITADOS, 
                TELEFONE_CLIENTE_REJEITADOS, CPF_REJEITADOS, NUMERO_NOTA_FISCAL_REJEITADOS, QUANTIDADE_REJEITADOS, 
                VALOR_ITEM_REJEITADOS, VALOR_TOTAL_REJEITADOS, CONDICAO_PAGAMENTO_REJEITADOS, TITULO_REJEITADOS, 
                AUTOR_REJEITADOS, ID_LOJA_REJEITADOS,ID_ATENDENTE_REJEITADOS, DATA_VENDA_REJEITADOS, 
                DATA_PROCESSAMENTO_REJEITADOS, ID_ERRO)

                VALUES (@nome_cliente, @numero_endereco, @complemento, @id_cep, 
                @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
                @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
                @data_venda, @data_processamento, @id_erro)
            END
        END
        --========================================================================
        -- 3 validação (seleciona as notas com ceps na tabela CEP da LIVRARIADB)
        SELECT *
        INTO 
            #seleciona_cep
        FROM 
            ##pegar_notas_nao_processadas
        WHERE 
            NUMERO_NOTA_FISCAL != (
                SELECT NUMERO_NOTA_FISCAL 
                FROM ##pegar_notas_datas_certas 
                WHERE VERIFICADOS = 'REJEITADO')
                AND @id_cep IN (SELECT ID_CEP FROM LIVRARIADB.dbo.CEP)

        INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS
        SELECT *
        FROM #seleciona_cep
        WHERE NOT EXISTS (
            SELECT 1
            FROM 
                STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS
            WHERE 
                STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS.NUMERO_NOTA_FISCAL_TRATADOS = #seleciona_cep.NUMERO_NOTA_FISCAL
                AND STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS.TITULO_TRATADOS = #seleciona_cep.TITULO
        );
        -- FALTA A PARTE DE REJEITAR OS CEPS INVALIDOS E INSERIR NA MOVIMENTACAO_LIVROS_REJEITADOS (DUVIDA!!!)

        FETCH NEXT FROM db_cursor INTO  @nome_cliente, @numero_endereco, @complemento, @id_cep, 
        @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
        @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
        @data_venda, @data_processamento;
    END
CLOSE db_cursor;
DEALLOCATE db_cursor;
END;

-- =======================================================================
-- TESTANDO ==============================================================

-- INSERE DADOS BRUTOS NO MOVIEMNTACAO_LIVROS DO STAGE
EXEC dbo.insere_csv_movimentacao_livros_stage;

-- INSERE NAS TABELAS MOVIMENTACAO TRATAODS OU REJEITADOS
EXEC dbo.tratamento_dados_2;

-- CARREGA NA VALIDACAO QUAIS NOTAS ESTÃO NA TABELA MOVIMENTACAO TRATADOS
EXEC dbo.carregar_validacao;


SELECT * FROM MOVIMENTACAO_LIVROS;

SELECT * FROM MOVIMENTACAO_LIVROS_REJEITADOS 
--LEFT JOIN TIPO_DE_ERRO ON MOVIMENTACAO_LIVROS_REJEITADOS.ID_ERRO = TIPO_DE_ERRO.ID_ERRO;

SELECT * FROM MOVIMENTACAO_LIVROS_TRATADOS;

SELECT * FROM VALIDACAO;

--================================
DELETE FROM MOVIMENTACAO_LIVROS;
GO

DELETE FROM MOVIMENTACAO_LIVROS_REJEITADOS;
GO

DELETE FROM  VALIDACAO;
GO

DELETE FROM  MOVIMENTACAO_LIVROS_TRATADOS;

-- livro e livro autor já no banco
-- tratar os dados do tipo pagamento para JOINS
-- alterar modelagem de dados com tabela de erros (tabela com Id do erro e descrição do erro)
SELECT TOP 10 * FROM LIVRARIADB.dbo.CEP;

-- erro por conta da tabelas dos ceps na LIVRARIADB estar inconpleta      
Select count(*) from LIVRARIADB.dbo.CEP AS Quant_ceps_LIVRARIADB; 

select count(*) from STAGE.dbo.CEP AS Quant_ceps_STAGE;

-- usar 
-- mudar cep para varchar 20
-- tratar a string desnoramalizada para uma string normalizada para ajuar a join

-- historico divergente existe quando o recebimento aconteceu de uma maneira não prevista 
-- a tabela tipo desconto é de validação se o desconto foi devidamento aplicado

--TIPOS DE CONDICOES 
-- 30DIAS
-- 60DIAS
-- 90DIAS
-- AVISTA

SELECT * FROM STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS;
SELECT * FROM STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS;

-- mudando o nome da coluna 
USE STAGE;
GO
EXEC sp_rename 'STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS.CEP_REJEITADOS', 'ID_CEP_REJEITADOS', 'COLUMN';
EXEC sp_rename 'STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS.CEP_TRATADOS', 'ID_CEP_TRATADOS', 'COLUMN';

USE STAGE;
GO
EXEC sp_rename 'STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS.ID_CEP_REJEITADOS', 'CEP_REJEITADOS', 'COLUMN';
EXEC sp_rename 'STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS.ID_CEP_TRATADOS', 'CEP_TRATADOS', 'COLUMN';


-- Errado: Está caindo em loop