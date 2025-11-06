-- 2 DEPOIS DE TODAS FEITAS DEPOIS DE 11/10/2025
USE LIVRARIADB;
GO
CREATE OR ALTER PROCEDURE dbo.insere_historico_divergente
AS
BEGIN
    WITH DADOS_CALC AS (
        SELECT
            -- dados para a inserção
            HR.ID_PROG_RECEBIMENTO,
            HR.ID_TIPO_DESCONTO,
            HR.DATA_RECEBIMENTO,
            PR.DATA_VENCIMENTO,
            HR.VALOR_RECEBIDO,
            PR.VAL_PARCELA,
            -- dados para calculos
            TD.TIPO,
            DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) AS DIAS_CORRIDOS,
            CASE
                -- Caso esteje tudo certo com o desconto aplicado
                WHEN
                    --verifica se a porcentagem do  desconto condiz com os dias
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) >= TD.MINIMO_DIA
                    AND
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MAXIMO_DIA
                    -- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
                    AND
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) <= 0
                    AND
                    TD.TIPO = 1
                THEN 'Desconto bem aplicado'

                -- Caso esteja tudo certo com a multa aplicada
                WHEN
                    --verifica se a porcentagem do  desconto condiz com os dias
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) >= TD.MINIMO_DIA
                    AND
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MAXIMO_DIA
                    -- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
                    AND
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) > 0
                    AND
                    TD.TIPO = 0
                THEN 'Multa bem aplicada'

                -- Caso aplique multa onde devia ser desconto
                WHEN	
                    -- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) <= 0 -- deve ser desconto
                    AND
                    TD.TIPO = 0 -- mas é multa
                THEN 'Aplicou multa onde deveria ser desconto'

                -- Caso aplique desconto onde devia ser multa
                WHEN
                    -- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) > 0 -- deve ser multa
                    AND
                    TD.TIPO = 1 -- mas é desconto
                THEN 'Aplicou desconto onde deveria ser multa'

                -- Caso aplique uma multa de valor indevido
                WHEN
                    -- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) > 0 -- deve ser multa
                    AND
                    TD.TIPO = 0 -- é multa
                    AND
                    --verifica se a porcentagem do  desconto condiz com os dias
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MINIMO_DIA
                    OR
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) > TD.MAXIMO_DIA
                THEN 'Valor da multa indevido'

                -- Caso aplique um desconto de valor indevido
                WHEN
                    -- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) <= 0 -- deve ser desconto
                    AND
                    TD.TIPO = 1 -- é desconto
                    AND
                    --verifica se a porcentagem do  desconto condiz com os dias
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MINIMO_DIA
                    OR
                    DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) > TD.MAXIMO_DIA
                THEN 'Valor do desconto indevido'
            END AS MOTIVO
        FROM 
            HISTORICO_RECEBIMENTO AS HR
        JOIN 
            TIPO_DESCONTO AS TD
            ON TD.ID_TIPO_DESCONTO = HR.ID_TIPO_DESCONTO
        JOIN 
            PROG_RECEBIMENTO AS PR
            ON PR.ID_PROG_RECEBIMENTO = HR.ID_PROG_RECEBIMENTO
    )
    INSERT INTO LIVRARIADB.dbo.HISTORICO_DIVERGENTE
    (ID_PROG_RECEBIMENTO, ID_TIPO_DESCONTO, DATA_RECEBIMENTO, VALOR_RECEBIDO, MOTIVO)
    SELECT 
        DC.ID_PROG_RECEBIMENTO,
        DC.ID_TIPO_DESCONTO,
        DC.DATA_RECEBIMENTO,
        DC.VALOR_RECEBIDO,
        DC.MOTIVO
    FROM 
        DADOS_CALC AS DC
    WHERE NOT EXISTS(
        SELECT 
            1
        FROM 
            LIVRARIADB.dbo.HISTORICO_DIVERGENTE
        WHERE 
            DC.ID_PROG_RECEBIMENTO = ID_PROG_RECEBIMENTO
            AND DC.ID_TIPO_DESCONTO = ID_TIPO_DESCONTO
            AND DC.DATA_RECEBIMENTO = DATA_RECEBIMENTO
            AND DC.VALOR_RECEBIDO = VALOR_RECEBIDO
            AND DC.MOTIVO = MOTIVO
    ) AND
    MOTIVO != 'Desconto bem aplicado'
    AND  MOTIVO != 'Multa bem aplicada'
END