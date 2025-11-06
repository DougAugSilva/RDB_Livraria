USE LIVRARIADB;
GO

CREATE OR ALTER PROCEDURE dbo.insere_nota_fiscal_livrariadb
AS
BEGIN
    MERGE LIVRARIADB.dbo.NOTA_FISCAL Destino
    USING (
        SELECT
            TPG.ID_TIPO_PAGAMENTO,
            CLI.ID_CLIENTE,
            IVE.ID_VENDA AS ID_VENDA,
            TRA.ID_ATENDENTE_TRATADOS AS ID_ATENDENTE,
            TRA.DATA_PROCESSAMENTO_TRATADOS AS DATA_NOTA,
            TRA.NUMERO_NOTA_FISCAL_TRATADOS AS NUMERO_NOTA_FISCAL,
            SUM(TRA.VALOR_ITEM_TRATADOS * TRA.QUANTIDADE_TRATADOS) AS VALOR_NF
        FROM
            STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS AS TRA
            JOIN LIVRARIADB.dbo.TIPO_PAGAMENTO AS TPG
                ON TRA.CONDICAO_PAGAMENTO_TRATADOS = TPG.TIPO
            JOIN LIVRARIADB.dbo.CLIENTE AS CLI
                ON TRA.CPF_TRATADOS = CLI.CPF
            JOIN LIVRARIADB.dbo.LIVRO AS LIV
                ON TRA.TITULO_TRATADOS = LIV.TITULO
            JOIN LIVRARIADB.dbo.ITEM_VENDA AS IVE
                ON LIV.ID_LIVRO = IVE.ID_LIVRO
        GROUP BY
            TPG.ID_TIPO_PAGAMENTO,
            CLI.ID_CLIENTE,
            IVE.ID_VENDA,
            TRA.ID_ATENDENTE_TRATADOS,
            TRA.DATA_PROCESSAMENTO_TRATADOS,
            TRA.NUMERO_NOTA_FISCAL_TRATADOS
    ) Origem ON (Destino.NUMERO_NOTA_FISCAL = Origem.NUMERO_NOTA_FISCAL)

    WHEN MATCHED THEN
        UPDATE
        SET 
            ID_TIPO_PAGAMENTO = Origem.ID_TIPO_PAGAMENTO,
            ID_CLIENTE = Origem.ID_CLIENTE,
            ID_VENDA = Origem.ID_VENDA,
            ID_ATENDENTE = Origem.ID_ATENDENTE,
            DATA_NOTA = Origem.DATA_NOTA,
            NUMERO_NOTA_FISCAL = Origem.NUMERO_NOTA_FISCAL,
            VALOR_NF = Origem.VALOR_NF

    WHEN NOT MATCHED THEN
        INSERT (
            ID_TIPO_PAGAMENTO,
            ID_CLIENTE,
            ID_VENDA,
            ID_ATENDENTE,
            DATA_NOTA,
            NUMERO_NOTA_FISCAL,
            VALOR_NF
        )
        VALUES (
            Origem.ID_TIPO_PAGAMENTO,
            Origem.ID_CLIENTE,
            Origem.ID_VENDA,
            Origem.ID_ATENDENTE,
            Origem.DATA_NOTA,
            Origem.NUMERO_NOTA_FISCAL,
            Origem.VALOR_NF
        );
END