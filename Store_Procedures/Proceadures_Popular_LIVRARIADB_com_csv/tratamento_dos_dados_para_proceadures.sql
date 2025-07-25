USE STAGE;
GO

CREATE PROCEDURE dbo.tratamento_dados
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
        IF EXISTS (SELECT NUMERO_NOTA_FISCAL FROM STAGE.dbo.VALIDACAO WHERE NUMERO_NOTA_FISCAL = @numero_nota_fiscal)

            SET @motivo_rejeicao = 'Ja processada'

            INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_REJEITADOS (NOME_CLIENTE_REJEITADOS, NUMERO_ENDERECO_REJEITADOS, COMPLEMENTO_REJEITADOS, CEP_REJEITADOS,
            TIPO_ENDERECO_REJEITADOS, EMAIL_CLIENTE_REJEITADOS, TELEFONE_CLIENTE_REJEITADOS, CPF_REJEITADOS, NUMERO_NOTA_FISCAL_REJEITADOS, QUANTIDADE_REJEITADOS, 
            VALOR_ITEM_REJEITADOS, VALOR_TOTAL_REJEITADOS, CONDICAO_PAGAMENTO_REJEITADOS, TITULO_REJEITADOS, AUTOR_REJEITADOS, ID_LOJA_REJEITADOS,
            ID_ATENDENTE_REJEITADOS, DATA_VENDA_REJEITADOS, DATA_PROCESSAMENTO_REJEITADOS, MOTIVO_REJEICAO)

            VALUES (@nome_cliente, @numero_endereco, @complemento, @cep, 
            @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
            @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
            @data_venda, @data_processamento, @motivo_rejeicao)

            INSERT INTO STAGE.dbo.VALIDACAO (NUMERO_NOTA_FISCAL, DATA_PROCESSAMENTO)
            VALUES (@numero_nota_fiscal, @data_processamento)

        IF NOT EXISTS (SELECT NUMERO_NOTA_FISCAL FROM STAGE.dbo.VALIDACAO WHERE NUMERO_NOTA_FISCAL = @numero_nota_fiscal)

            UPDATE STAGE.dbo.MOVIMENTACAO_LIVROS
            SET TIPO_ENDERECO        =   UPPER(@tipo_endereco)
            WHERE NUMERO_NOTA_FISCAL =   @numero_nota_fiscal;

            INSERT INTO STAGE.dbo.VALIDACAO (NUMERO_NOTA_FISCAL, DATA_PROCESSAMENTO)
            VALUES (@numero_nota_fiscal, @data_processamento)
    
        FETCH NEXT FROM db_cursor INTO  @nome_cliente, @numero_endereco, @complemento, @cep, 
         @tipo_endereco, @email_cliente, @telefone_cliente, @cpf, @numero_nota_fiscal, @quantidade,
         @valor_item, @valor_total, @condicao_pagamento, @titulo, @autor, @id_loja, @id_atendente,
         @data_venda, @data_processamento;
    END
    CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;

-- TESTANDO 
EXEC dbo.tratamento_dados;

SELECT * FROM VALIDACAO;

SELECT * FROM MOVIMENTACAO_LIVROS_REJEITADOS;

SELECT * FROM MOVIMENTACAO_LIVROS;





/* 
TRATAMENTOS

1. Verificar o número da nota fiscal presente no CSV para com o numero na tabela STAGE.VALIDACAO. 
Caso o número esteja nessa tabela, a nota já foi precessada e deve ser rejeitada com a tag "Já Processada"

2. Padroniza os valores da coluna TIPO ENDERECO como letras maísculas.

3. Os dados rewjeitados dever ser inseridos na tabela STAGE.MOVIMENTACAO_LIVROS_REJEITADOS com o motivo da rejeição

*/
