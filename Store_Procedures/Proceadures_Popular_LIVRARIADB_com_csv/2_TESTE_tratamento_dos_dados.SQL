USE STAGE;
GO

CREATE PROCEDURE dbo.tratamento_dados_2
AS
BEGIN

    DECLARE db_cursor CURSOR FOR
        SELECT NOME_CLIENTE, NUMERO_ENDERECO, COMPLEMENTO, CEP, UPPER(TIPO_ENDERECO), EMAIL_CLIENTE, 
                TELEFONE_CLIENTE, CPF, NUMERO_NOTA_FISCAL, QUANTIDADE, VALOR_ITEM, VALOR_TOTAL, 
                CONDICAO_PAGAMENTO, TITULO, AUTOR, ID_LOJA, ID_ATENDENTE, DATA_VENDA, DATA_PROCESSAMENTO
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

    DECLARE @motivo_rejeicao    NVARCHAR(100);

    OPEN db_cursor
    FETCH NEXT FROM db_cursor INTO  @nome_cliente, @numero_endereco, @complemento, @cep, 
     @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
     @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
     @data_venda, @data_processamento;

    WHILE @@FETCH_STATUS = 0
	BEGIN 
        -- DROP TABLE IF EXISTS #pegar_notas_nao_processadas;
        -- DROP TABLE IF EXISTS #seleciona_cep;

        -- 1 validação (seleciona as notas não processadas)
        SELECT NOME_CLIENTE, NUMERO_ENDERECO, COMPLEMENTO, CEP, UPPER(TIPO_ENDERECO), EMAIL_CLIENTE, 
                TELEFONE_CLIENTE, CPF, NUMERO_NOTA_FISCAL, QUANTIDADE, VALOR_ITEM, VALOR_TOTAL, 
                CONDICAO_PAGAMENTO, TITULO, AUTOR, ID_LOJA, ID_ATENDENTE, DATA_VENDA, DATA_PROCESSAMENTO
        INTO 
            #pegar_notas_nao_processadas
        FROM 
            STAGE.dbo.MOVIMENTACAO_LIVROS
        WHERE NOT EXISTS (
            SELECT 1 
            FROM STAGE.dbo.VALIDACAO
            WHERE NUMERO_NOTA_FISCAL = @numero_nota_fiscal
            AND DATA_PROCESSAMENTO  = @data_processamento
            );
        
        -- 2 validação (seleciona as notas com as datas de processamento válidas)
       WITH pegar_notas_datas_certas AS (
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
        )

        -- 3 validação (seleciona as notas com ceps na tabeela CEP da LIVRARIADB)
        SELECT *
        INTO 
            #seleciona_cep
        FROM 
            #pegar_notas_nao_processadas
        WHERE 
            NUMERO_NOTA_FISCAL != (SELECT NUMERO_NOTA_FISCAL FROM pegar_notas_datas_certas WHERE VERIFICADOS = 'REJEITADO')
            AND @cep IN (SELECT CEP FROM LIVRARIADB.dbo.CEP)

        INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS
        SELECT *
        FROM #seleciona_cep;

        FETCH NEXT FROM db_cursor INTO  @nome_cliente, @numero_endereco, @complemento, @cep, 
        @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
        @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
        @data_venda, @data_processamento;
    END
CLOSE db_cursor;
DEALLOCATE db_cursor;
END;


-- TESTANDO ==============================================================

-- INSERE DADOS BRUTOS NO LIVRARIA DB DO STAGE
EXEC dbo.insere_csv_movimentacao_livros_stage;

-- INSERE NAS TABELAS MOVIMENTACAO TRATAODS OU REJEITADOS
EXEC dbo.tratamento_dados_2;

-- CARREGA NA VALIDACAO QUAIS NOTAS ESTÃO NA TABELA MOVIMENTACAO TRATADOS
EXEC dbo.carregar_validacao;


SELECT * FROM MOVIMENTACAO_LIVROS;

SELECT * FROM MOVIMENTACAO_LIVROS_REJEITADOS;

SELECT * FROM MOVIMENTACAO_LIVROS_TRATADOS;

SELECT * FROM VALIDACAO;

--================================
DELETE FROM MOVIMENTACAO_LIVROS_REJEITADOS;
GO

DELETE FROM  VALIDACAO;
GO

DELETE FROM  MOVIMENTACAO_LIVROS_TRATADOS;

        
        
        
