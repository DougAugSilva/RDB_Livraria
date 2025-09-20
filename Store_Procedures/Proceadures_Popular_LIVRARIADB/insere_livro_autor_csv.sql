USE LIVRARIADB;
GO

CREATE PROCEDURE dbo.insere_livroautor_livrariadb
AS
BEGIN
    MERGE LIVRARIADB.dbo.LIVRO_AUTOR Destino
    USING (
        SELECT
            LV.ID_LIVRO,
            AUT.ID_AUTOR
        FROM 
            STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS AS TRA
            JOIN LIVRARIADB.dbo.LIVRO AS LV
                ON TRA.TITULO_TRATADOS = LV.TITULO
            JOIN LIVRARIADB.dbo.AUTOR AS AUT
                ON TRA.AUTOR_TRATADOS = AUT.NOME
    ) Origem ON (Destino.ID_AUTOR = Origem.ID_AUTOR)

    WHEN MATCHED THEN
        UPDATE
        SET ID_LIVRO = Origem.ID_LIVRO,
            ID_AUTOR = Origem.ID_AUTOR
    WHEN NOT MATCHED THEN
        INSERT (
            ID_LIVRO,
            ID_AUTOR
        )
        VALUES (
            Origem.ID_LIVRO,
            Origem.ID_AUTOR
        );
END

-- OK