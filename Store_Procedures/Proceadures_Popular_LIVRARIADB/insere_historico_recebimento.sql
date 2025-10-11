-- 1 DEPOIS DE TODAS FEITAS ANTES DE 11/10/2025
USE LIVRARIADB;
GO
CREATE OR ALTER PROCEDURE dbo.insere_historico_recebimento
AS
BEGIN
    MERGE LIVRARIADB.dbo.HISTORICO_RECEBIMENTO  Destino
    USING (
        SELECT
            PROG.ID_PROG_RECEBIMENTO,
            TDES.ID_TIPO_DESCONTO
        FROM 
            LIVRARIADB.dbo.PROG_RECEBIMENTO AS PROG
            JOIN LIVRARIADB.dbo.NOTA_FISCAL AS NOFI
                ON PROD.ID_NF = NOFI.ID_NF
            JOIN LIVRARIADB.dbo.TIPO_DESCONTO AS TDES
                ON PROG.ID_NF = TDES. --não soube como continuar

            
    )

/*

*/