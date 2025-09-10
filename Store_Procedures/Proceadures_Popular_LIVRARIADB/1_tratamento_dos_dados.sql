USE STAGE;
GO 

CREATE PROCEDURE dbo.tratamento_dados
AS
BEGIN

    DECLARE db_cursor CURSOR FOR
        SELECT NOME_CLIENTE, NUMERO_ENDERECO, COMPLEMENTO, CEP, 
            UPPER(TIPO_ENDERECO), 
            EMAIL_CLIENTE, TELEFONE_CLIENTE, CPF, NUMERO_NOTA_FISCAL, QUANTIDADE, VALOR_ITEM, VALOR_TOTAL, 
            REPLACE(
                REPLACE(
                    REPLACE(CONDICAO_PAGAMENTO, 'Entrada - ', 'Entrada/'), 
                    '30 60 90', '30/60/90'), 'a vista', 'A vista'),
            TITULO, AUTOR, ID_LOJA, ID_ATENDENTE, DATA_VENDA, DATA_PROCESSAMENTO
        FROM STAGE.dbo.MOVIMENTACAO_LIVROS
    
    DECLARE @nome_cliente       NVARCHAR(100);
    DECLARE @numero_endereco    INT;
    DECLARE @complemento        NVARCHAR(100);
    DECLARE @cep                NVARCHAR(15); 
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
    FETCH NEXT FROM db_cursor INTO  @nome_cliente, @numero_endereco, @complemento, @cep, 
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
            CEP                  NVARCHAR(15)   NULL,
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
        SELECT NOME_CLIENTE, NUMERO_ENDERECO, COMPLEMENTO, CEP, 
            UPPER(TIPO_ENDERECO), 
            EMAIL_CLIENTE, TELEFONE_CLIENTE, CPF, NUMERO_NOTA_FISCAL, QUANTIDADE, VALOR_ITEM, VALOR_TOTAL, 
            REPLACE(
                REPLACE(
                    REPLACE(CONDICAO_PAGAMENTO, 'Entrada - ', 'Entrada/'), 
                    '30 60 90', '30/60/90'), 'a vista', 'A vista'),
            TITULO, AUTOR, ID_LOJA, ID_ATENDENTE, DATA_VENDA, DATA_PROCESSAMENTO
        FROM 
            STAGE.dbo.MOVIMENTACAO_LIVROS
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
            COMPLEMENTO_REJEITADOS, CEP_REJEITADOS,TIPO_ENDERECO_REJEITADOS, EMAIL_CLIENTE_REJEITADOS, 
            TELEFONE_CLIENTE_REJEITADOS, CPF_REJEITADOS, NUMERO_NOTA_FISCAL_REJEITADOS, QUANTIDADE_REJEITADOS, 
            VALOR_ITEM_REJEITADOS, VALOR_TOTAL_REJEITADOS, CONDICAO_PAGAMENTO_REJEITADOS, TITULO_REJEITADOS, 
            AUTOR_REJEITADOS, ID_LOJA_REJEITADOS,ID_ATENDENTE_REJEITADOS, DATA_VENDA_REJEITADOS,
             DATA_PROCESSAMENTO_REJEITADOS, ID_ERRO)

            VALUES (@nome_cliente, @numero_endereco, @complemento, @cep, 
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
                COMPLEMENTO_REJEITADOS, CEP_REJEITADOS,TIPO_ENDERECO_REJEITADOS, EMAIL_CLIENTE_REJEITADOS, 
                TELEFONE_CLIENTE_REJEITADOS, CPF_REJEITADOS, NUMERO_NOTA_FISCAL_REJEITADOS, QUANTIDADE_REJEITADOS, 
                VALOR_ITEM_REJEITADOS, VALOR_TOTAL_REJEITADOS, CONDICAO_PAGAMENTO_REJEITADOS, TITULO_REJEITADOS, 
                AUTOR_REJEITADOS, ID_LOJA_REJEITADOS,ID_ATENDENTE_REJEITADOS, DATA_VENDA_REJEITADOS, 
                DATA_PROCESSAMENTO_REJEITADOS, ID_ERRO)

                VALUES (@nome_cliente, @numero_endereco, @complemento, @cep, 
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
                AND @cep IN (SELECT CEP FROM LIVRARIADB.dbo.CEP)
                AND @cpf NOT IN (SELECT CPF_REJEITADOS FROM STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS)

        INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS
        SELECT *
        FROM 
            #seleciona_cep
        WHERE NOT EXISTS (
            SELECT 1
            FROM 
                STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS
            WHERE 
                STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS.NUMERO_NOTA_FISCAL_TRATADOS = #seleciona_cep.NUMERO_NOTA_FISCAL
                AND STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS.TITULO_TRATADOS = #seleciona_cep.TITULO
        );
        -- inserção de ceps invalidos na MOVIMENTACAO_LIVROS_REJEITADOS
        IF NOT EXISTS (
             SELECT 1
             FROM 
                ##pegar_notas_nao_processadas
             WHERE 
                 NUMERO_NOTA_FISCAL != (
                     SELECT NUMERO_NOTA_FISCAL 
                     FROM ##pegar_notas_datas_certas 
                     WHERE VERIFICADOS = 'REJEITADO')
                     AND @cep IN (SELECT CEP FROM LIVRARIADB.dbo.CEP)
                     
        )AND @cpf NOT IN (SELECT CPF_REJEITADOS FROM STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS)
        BEGIN
            SET @id_erro = 3

            INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS (NOME_CLIENTE_REJEITADOS, NUMERO_ENDERECO_REJEITADOS, 
            COMPLEMENTO_REJEITADOS, CEP_REJEITADOS,TIPO_ENDERECO_REJEITADOS, EMAIL_CLIENTE_REJEITADOS, 
            TELEFONE_CLIENTE_REJEITADOS, CPF_REJEITADOS, NUMERO_NOTA_FISCAL_REJEITADOS, QUANTIDADE_REJEITADOS, 
            VALOR_ITEM_REJEITADOS, VALOR_TOTAL_REJEITADOS, CONDICAO_PAGAMENTO_REJEITADOS, TITULO_REJEITADOS, 
            AUTOR_REJEITADOS, ID_LOJA_REJEITADOS,ID_ATENDENTE_REJEITADOS, DATA_VENDA_REJEITADOS, 
            DATA_PROCESSAMENTO_REJEITADOS, ID_ERRO)

            VALUES (@nome_cliente, @numero_endereco, @complemento, @cep, 
            @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
            @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
            @data_venda, @data_processamento, @id_erro)
        END

        FETCH NEXT FROM db_cursor INTO  @nome_cliente, @numero_endereco, @complemento, @cep, 
        @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
        @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
        @data_venda, @data_processamento;
    END

    -- Deletando valores redundantes nas tabelas por segurança
    DELETE T1
    FROM
		STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS AS T1
	INNER JOIN
		STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS AS T2
	ON
		T1.CEP_TRATADOS = T2.CEP_REJEITADOS
		AND T2.ID_ERRO != 1;

CLOSE db_cursor;
DEALLOCATE db_cursor;
END;

-- OK