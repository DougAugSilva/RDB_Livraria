USE STAGE;
GO

SELECT * FROM MOVIMENTACAO_LIVROS

SELECT UPPER(EMAIL_CLIENTE) FROM MOVIMENTACAO_LIVROS

-- OBS: o tratamento pode ser feito dentro do cursor
-- sera utilizada um tabela "movimentação dados tratados" somente com os dados limpos e tratados
-- essa tabela sera utilizada para inserir na validação e na LIVRARIADB
-- a validação sera feita no insert into, as que não podem ser nulos eu rejeito 

-- PROCESSO
-- chegam os dados brutos em movimentacao
-- uso uma proceadure para rejeitar os dados incorretes
-- uso uma proceadure para um tratamento (dentro do select do insert)
-- uso uma proceadure para inserir na validação (essa aqui)
-- depois eu carrego em LIVRARIADB

USE STAGE;
GO

CREATE TABLE MOVIMENTACAO_LIVROS_TRATADOS (
    NOME_CLIENTE_TRATADOS         NVARCHAR(100)  NULL,   
    NUMERO_ENDERECO_TRATADOS      INT            NULL,
    COMPLEMENTO_TRATADOS          NVARCHAR(100)  NULL,
    CEP_TRATADOS                  NVARCHAR(15)   NULL,
    TIPO_ENDERECO_TRATADOS        VARCHAR(5)     NULL,
    EMAIL_CLIENTE_TRATADOS        NVARCHAR(100)  NULL,    
    TELEFONE_CLIENTE_TRATADOS     NVARCHAR(20)   NULL,      
    CPF_TRATADOS                  NVARCHAR(14)   NULL,    
    NUMERO_NOTA_FISCAL_TRATADOS   INT            NULL,
    QUANTIDADE_TRATADOS           INT            NULL,
    VALOR_ITEM_TRATADOS           DECIMAL(10,2)  NULL,
    VALOR_TOTAL_TRATADOS          DECIMAL(10,2)  NULL,
    CONDICAO_PAGAMENTO_TRATADOS   NVARCHAR(100)  NULL,
    TITULO_TRATADOS               NVARCHAR(100)  NULL,
    AUTOR_TRATADOS                NVARCHAR(100)  NULL,
    ID_LOJA_TRATADOS              INT            NULL,
    ID_ATENDENTE_TRATADOS         INT            NULL,
    DATA_VENDA_TRATADOS           DATE           NULL,
    DATA_PROCESSAMENTO_TRATADOS   DATE           NULL
);
