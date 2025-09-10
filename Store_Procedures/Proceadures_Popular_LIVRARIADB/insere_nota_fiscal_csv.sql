USE LIVRARIADB;
GO

CREATE PROCEDURE dbo.insere_nota_fiscal
AS
BEGIN
    MERGE LIVRARIADB.dbo.NOTA_FISCAL Destino
    USING (
        SELECT
            TPG.ID_TIPO_PAGAMENTO,
            CLI.ID_CLIENTE,
            TRA.DATA_PROCESSAMENTO_TRATADOS AS DATA_NOTA,
            TRA.NUMERO_NOTA_FISCAL_TRATADOS AS NUMERO_NOTA_FISCAL
        FROM
            STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS AS TRA
            JOIN LIVRARIADB.dbo.TIPO_PAGAMENTO AS TPG
                ON TRA.CONDICAO_PAGAMENTO_TRATADOS = TPG.TIPO
            JOIN LIVRARIADB.dbo.CLIENTE AS CLI
                ON TRA.CPF_TRATADOS = CLI.CPF
    ) Origem ON (Destino.NUMERO_NOTA_FISCAL = Origem.NUMERO_NOTA_FISCAL)
    
    WHEN MATCHED THEN
        UPDATE
        SET ID_TIPO_PAGAMENTO = Origem.ID_TIPO_PAGAMENTO,
            ID_CLIENTE = Origem.ID_CLIENTE,
            DATA_NOTA = Origem.DATA_NOTA,
            NUMERO_NOTA_FISCAL = OrigeM.NUMERO_NOTA_FISCAL
    WHEN NOT MATCHED THEN
        INSERT (
            ID_TIPO_PAGAMENTO,
            ID_CLIENTE,
            DATA_NOTA,
            NUMERO_NOTA_FISCAL
        )
        VALUES (
            Origem.ID_TIPO_PAGAMENTO,
            Origem.ID_CLIENTE,
            Origem.DATA_NOTA,
            Origem.NUMERO_NOTA_FISCAL
        );
END

EXEC dbo.insere_nota_fiscal;

-- OK