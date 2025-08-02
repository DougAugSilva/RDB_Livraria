-- criando tabelas tempoirarias para filtragem dos dados
USE STAGE;
GO
-- validacao por DATA INVALIDA
WITH pegar_data AS (
    SELECT
        NUMERO_NOTA_FISCAL,
        MIN(DATA_PROCESSAMENTO) AS MENOR_DATA,
        MAX(DATA_PROCESSAMENTO) AS MAIOR_DATA
    FROM 
        STAGE.dbo.MOVIMENTACAO_LIVROS
    GROUP BY 
        NUMERO_NOTA_FISCAL
)

--SELECT * FROM pegar_data;

SELECT pegar_data.NUMERO_NOTA_FISCAL,
  (CASE 
    WHEN MENOR_DATA != MAIOR_DATA THEN 'REJEITADO'
    ELSE 'OK'
  END) AS VERIFICADOS
FROM pegar_data
WHERE VERIFICADOS == 'REJEITADO'

--====================================================================
-- TESTANDO

-- 1 etapa de filtragem (seleciona notas com datas válidas)
WITH pegar_data_2 AS (
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

SELECT * FROM pegar_data_2 WHERE VERIFICADOS = 'REJEITADO';

-- validacao por CEP INVALIDO

-- 2 etapa de filtragem (seleciona os ceps validos dos valores que são validos pela etapa 1)
--DECLARE @cep                NVARCHAR(15);
--SET     @cep = '01311000'

WITH pegar_cep AS (
    SELECT
        CEP
    FROM 
        STAGE.dbo.MOVIMENTACAO_LIVROS
    WHERE
          NUMERO_NOTA_FISCAL != (SELECT NUMERO_NOTA_FISCAL FROM pegar_data_2 WHERE VERIFICADOS = 'REJEITADO')
          --AND @cep IN (SELECT CEP FROM LIVRARIADB.dbo.CEP)
)
-- ======================================================================
-- testandooutro tipo de tabelas temporarias

-- 1 tabela temporaria de filtro (seleciona as notas com datas de verificação válidas)
DROP TABLE IF EXISTS #pegar_data_3;
DROP TABLE IF EXISTS #seleciona_cep;

SELECT
    NUMERO_NOTA_FISCAL,
    (CASE
      WHEN  MIN(DATA_PROCESSAMENTO) != MAX(DATA_PROCESSAMENTO) THEN 'REJEITADO'
      ELSE 'OK'
      END) AS VERIFICADOS
INTO #pegar_data_3       
FROM 
    STAGE.dbo.MOVIMENTACAO_LIVROS
GROUP BY 
    NUMERO_NOTA_FISCAL

-- 2 tabela temporaria de filtro (seleciona as noitas da tabela anterior com ceps certos)
--DECLARE @cep                NVARCHAR(15);
--SET     @cep = 01311000
SELECT
      CEP
  INTO #seleciona_cep
  FROM 
      STAGE.dbo.MOVIMENTACAO_LIVROS
  WHERE
      NUMERO_NOTA_FISCAL != (SELECT NUMERO_NOTA_FISCAL FROM #pegar_data_3  WHERE VERIFICADOS = 'REJEITADO')
      AND @cep IN (SELECT CEP FROM LIVRARIADB.dbo.CEP)




SELECT * FROM #seleciona_cep;

--SELECT CEP FROM LIVRARIADB.dbo.CEP WHERE CEP = 01311000;

-- TESTANDO FILTROS

-- FILTRO 1
DECLARE @numero_nota_fiscal INT;
DECLARE @data_processamento DATE;

SET @numero_nota_fiscal = 1001;
SET @data_processamento = '2025-05-15';

SELECT *
INTO #pegar_notas_nao_processadas
FROM 
    STAGE.dbo.MOVIMENTACAO_LIVROS
WHERE NOT EXISTS (
    SELECT 1 
    FROM STAGE.dbo.VALIDACAO
    WHERE NUMERO_NOTA_FISCAL = @numero_nota_fiscal
    AND DATA_PROCESSAMENTO  = @data_processamento
)

SELECT * FROM #pegar_notas_nao_processadas;

--==================================================================
-- retorno do GEMINI

CREATE  PROCEDURE dbo.tratamento_dados_3
AS
BEGIN
    -- Ativa o modo que não conta as linhas afetadas, melhorando a performance em operações grandes.
    -- CTE (Common Table Expression) para identificar as notas fiscais que têm mais de uma data de processamento.
    -- Esta é a nossa primeira regra de rejeição.
    WITH NotasComDatasInvalidas AS (
        SELECT
            NUMERO_NOTA_FISCAL
        FROM
            STAGE.dbo.MOVIMENTACAO_LIVROS
        GROUP BY
            NUMERO_NOTA_FISCAL
        HAVING
            MIN(DATA_PROCESSAMENTO) <> MAX(DATA_PROCESSAMENTO) -- Pega apenas notas com datas de processamento diferentes
    )
    -- Insere os dados válidos na tabela de destino de uma só vez.
    INSERT INTO STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS 
    SELECT
        sl.NOME_CLIENTE,
        sl.NUMERO_ENDERECO,
        sl.COMPLEMENTO,
        sl.CEP,
        UPPER(sl.TIPO_ENDERECO), -- A função UPPER é aplicada aqui
        sl.EMAIL_CLIENTE,
        sl.TELEFONE_CLIENTE,
        sl.CPF,
        sl.NUMERO_NOTA_FISCAL,
        sl.QUANTIDADE,
        sl.VALOR_ITEM,
        sl.VALOR_TOTAL,
        sl.CONDICAO_PAGAMENTO,
        sl.TITULO,
        sl.AUTOR,
        sl.ID_LOJA,
        sl.ID_ATENDENTE,
        sl.DATA_VENDA,
        sl.DATA_PROCESSAMENTO
    FROM
        STAGE.dbo.MOVIMENTACAO_LIVROS AS sl -- 'sl' é um alias para a tabela de origem (Source Livros)
    WHERE
        -- Validação 1: Garante que a nota fiscal ainda não foi processada e inserida na tabela de validação.
        NOT EXISTS (
            SELECT 1
            FROM STAGE.dbo.VALIDACAO AS v
            WHERE v.NUMERO_NOTA_FISCAL = sl.NUMERO_NOTA_FISCAL
              AND v.DATA_PROCESSAMENTO = sl.DATA_PROCESSAMENTO
        )
        -- Validação 2: Garante que a nota fiscal não tem datas de processamento diferentes (usando a CTE).
        AND sl.NUMERO_NOTA_FISCAL NOT IN (
            SELECT NUMERO_NOTA_FISCAL FROM NotasComDatasInvalidas
        )
        -- Validação 3: Garante que o CEP do registro existe na tabela de CEPs do banco de dados principal.
        AND EXISTS (
            SELECT 1
            FROM LIVRARIADB.dbo.CEP AS c
            WHERE c.CEP = sl.CEP
        );
END;

EXEC dbo.tratamento_dados_3;

-- TESTANDO ==============================================================

-- INSERE DADOS BRUTOS NO LIVRARIA DB DO STAGE
EXEC dbo.insere_csv_movimentacao_livros_stage;

-- INSERE NAS TABELAS MOVIMENTACAO TRATAODS OU REJEITADOS
--EXEC dbo.tratamento_dados_2;

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

