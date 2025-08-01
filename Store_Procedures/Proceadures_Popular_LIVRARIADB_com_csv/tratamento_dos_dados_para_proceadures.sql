USE STAGE;
GO

ALTER PROCEDURE dbo.tratamento_dados
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
      
        IF EXISTS (
            SELECT 1 
            FROM STAGE.dbo.VALIDACAO
            WHERE NUMERO_NOTA_FISCAL = @numero_nota_fiscal
            AND DATA_PROCESSAMENTO  = @data_processamento
            AND @cep NOT IN (SELECT CEP FROM LIVRARIADB.dbo.CEP)
            )
            BEGIN
                SET @motivo_rejeicao = 'ja processada e/ou cep invalido'

                INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS (NOME_CLIENTE_REJEITADOS, NUMERO_ENDERECO_REJEITADOS, COMPLEMENTO_REJEITADOS, CEP_REJEITADOS,
                TIPO_ENDERECO_REJEITADOS, EMAIL_CLIENTE_REJEITADOS, TELEFONE_CLIENTE_REJEITADOS, CPF_REJEITADOS, NUMERO_NOTA_FISCAL_REJEITADOS, QUANTIDADE_REJEITADOS, 
                VALOR_ITEM_REJEITADOS, VALOR_TOTAL_REJEITADOS, CONDICAO_PAGAMENTO_REJEITADOS, TITULO_REJEITADOS, AUTOR_REJEITADOS, ID_LOJA_REJEITADOS,
                ID_ATENDENTE_REJEITADOS, DATA_VENDA_REJEITADOS, DATA_PROCESSAMENTO_REJEITADOS, MOTIVO_REJEICAO)

                VALUES (@nome_cliente, @numero_endereco, @complemento, @cep, 
                @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
                @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
                @data_venda, @data_processamento, @motivo_rejeicao)
            END
            
        ELSE IF EXISTS (
            SELECT 1 
            FROM STAGE.dbo.VALIDACAO
            WHERE NUMERO_NOTA_FISCAL = @numero_nota_fiscal
            AND DATA_PROCESSAMENTO  != @data_processamento
            )
            BEGIN
                SET @motivo_rejeicao = 'data invalida'

                INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS (NOME_CLIENTE_REJEITADOS, NUMERO_ENDERECO_REJEITADOS, COMPLEMENTO_REJEITADOS, CEP_REJEITADOS,
                TIPO_ENDERECO_REJEITADOS, EMAIL_CLIENTE_REJEITADOS, TELEFONE_CLIENTE_REJEITADOS, CPF_REJEITADOS, NUMERO_NOTA_FISCAL_REJEITADOS, QUANTIDADE_REJEITADOS, 
                VALOR_ITEM_REJEITADOS, VALOR_TOTAL_REJEITADOS, CONDICAO_PAGAMENTO_REJEITADOS, TITULO_REJEITADOS, AUTOR_REJEITADOS, ID_LOJA_REJEITADOS,
                ID_ATENDENTE_REJEITADOS, DATA_VENDA_REJEITADOS, DATA_PROCESSAMENTO_REJEITADOS, MOTIVO_REJEICAO)

                VALUES (@nome_cliente, @numero_endereco, @complemento, @cep, 
                @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
                @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
                @data_venda, @data_processamento, @motivo_rejeicao)
            END
        ELSE
            BEGIN
                INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS (NOME_CLIENTE_TRATADOS, NUMERO_ENDERECO_TRATADOS, COMPLEMENTO_TRATADOS, CEP_TRATADOS,
                TIPO_ENDERECO_TRATADOS, EMAIL_CLIENTE_TRATADOS, TELEFONE_CLIENTE_TRATADOS, CPF_TRATADOS, NUMERO_NOTA_FISCAL_TRATADOS, QUANTIDADE_TRATADOS, 
                VALOR_ITEM_TRATADOS, VALOR_TOTAL_TRATADOS, CONDICAO_PAGAMENTO_TRATADOS, TITULO_TRATADOS, AUTOR_TRATADOS, ID_LOJA_TRATADOS,
                ID_ATENDENTE_TRATADOS, DATA_VENDA_TRATADOS, DATA_PROCESSAMENTO_TRATADOS)

                VALUES (@nome_cliente, @numero_endereco, @complemento, @cep, 
                @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
                @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
                @data_venda, @data_processamento)
    
                FETCH NEXT FROM db_cursor INTO  @nome_cliente, @numero_endereco, @complemento, @cep, 
                @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
                @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
                @data_venda, @data_processamento;
            END
        END
    CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;

-- TESTANDO 

-- INSERE DADOS BRUTOS NO LIVRARIA DB DO STAGE
EXEC dbo.insere_csv_movimentacao_livros_stage;

-- INSERE NAS TABELAS MOVIMENTACAO TRATAODS OU REJEITADOS
EXEC dbo.tratamento_dados;

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



/* 
TRATAMENTOS

1. Verificar o número da nota fiscal presente no CSV para com o numero na tabela STAGE.VALIDACAO. 
Caso o número esteja nessa tabela, a nota já foi precessada e deve ser rejeitada com a tag "Já Processada"

2. Padroniza os valores da coluna TIPO ENDERECO como letras maísculas.

3. Os dados rewjeitados dever ser inseridos na tabela STAGE.MOVIMENTACAO_LIVROS_REJEITADOS com o motivo da rejeição

*/

-- validar pela data de processamento, se for a mesma data e mesmo numero de nota, inserir