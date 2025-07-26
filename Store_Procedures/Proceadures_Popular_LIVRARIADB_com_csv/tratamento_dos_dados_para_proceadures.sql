USE STAGE;
GO

ALTER PROCEDURE dbo.tratamento_dados
AS
BEGIN

    DECLARE db_cursor CURSOR FOR
        SELECT * FROM STAGE.dbo.MOVIMENTACAO_LIVROS
    
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
            AND DATA_PROCESSAMENTO = @data_processamento
            )
            BEGIN
                SET @motivo_rejeicao = 'Ja processada'

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
                UPDATE STAGE.dbo.MOVIMENTACAO_LIVROS
                SET TIPO_ENDERECO        =   UPPER(@tipo_endereco)
                WHERE NUMERO_NOTA_FISCAL =   @numero_nota_fiscal;
    
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
EXEC dbo.tratamento_dados;

SELECT * FROM VALIDACAO;

SELECT * FROM MOVIMENTACAO_LIVROS_REJEITADOS;

SELECT * FROM MOVIMENTACAO_LIVROS;

--================================
DROP TABLE MOVIMENTACAO_LIVROS_REJEITADOS;

DROP TABLE VALIDACAO;

EXEC dbo.insere_csv_movimentacao_livros_stage;

-- TABELA DAS NOTAS REJEITADAS
CREATE TABLE MOVIMENTACAO_LIVROS_REJEITADOS (
    NOME_CLIENTE_REJEITADOS         NVARCHAR(100)  NULL,   
    NUMERO_ENDERECO_REJEITADOS      INT            NULL,
    COMPLEMENTO_REJEITADOS          NVARCHAR(100)  NULL,
    CEP_REJEITADOS                  NVARCHAR(15)   NULL,
    TIPO_ENDERECO_REJEITADOS        VARCHAR(5)     NULL,
    EMAIL_CLIENTE_REJEITADOS        NVARCHAR(100)  NULL,    
    TELEFONE_CLIENTE_REJEITADOS     NVARCHAR(20)   NULL,      
    CPF_REJEITADOS                  NVARCHAR(14)   NULL,    
    NUMERO_NOTA_FISCAL_REJEITADOS   INT            NULL,
    QUANTIDADE_REJEITADOS           INT            NULL,
    VALOR_ITEM_REJEITADOS           DECIMAL(10,2)  NULL,
    VALOR_TOTAL_REJEITADOS          DECIMAL(10,2)  NULL,
    CONDICAO_PAGAMENTO_REJEITADOS   NVARCHAR(100)  NULL,
    TITULO_REJEITADOS               NVARCHAR(100)  NULL,
    AUTOR_REJEITADOS                NVARCHAR(100)  NULL,
    ID_LOJA_REJEITADOS              INT            NULL,
    ID_ATENDENTE_REJEITADOS         INT            NULL,
    DATA_VENDA_REJEITADOS           DATE           NULL,
    DATA_PROCESSAMENTO_REJEITADOS   DATE           NULL,
    MOTIVO_REJEICAO                 VARCHAR(100)   NULL
);
GO

--  ARMAZENA AS NOTAS FISCAIS JA PROCESSADAS
CREATE TABLE VALIDACAO (
    NUMERO_NOTA_FISCAL      INT     NOT NULL,
    DATA_PROCESSAMENTO      DATE    NOT NULL
);


/* 
TRATAMENTOS

1. Verificar o número da nota fiscal presente no CSV para com o numero na tabela STAGE.VALIDACAO. 
Caso o número esteja nessa tabela, a nota já foi precessada e deve ser rejeitada com a tag "Já Processada"

2. Padroniza os valores da coluna TIPO ENDERECO como letras maísculas.

3. Os dados rewjeitados dever ser inseridos na tabela STAGE.MOVIMENTACAO_LIVROS_REJEITADOS com o motivo da rejeição

*/

-- validar pela data de processamento, se for a mesma data e mesmo numero de nota, inserir