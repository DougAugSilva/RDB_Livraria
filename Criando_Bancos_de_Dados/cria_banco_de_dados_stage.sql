CREATE DATABASE STAGE;
GO

USE STAGE;
GO

CREATE TABLE MOVIMENTACAO_LIVROS (
    NOME_CLIENTE         NVARCHAR(100)  NULL,   
    NUMERO_ENDERECO      INT            NULL,
    COMPLEMENTO          NVARCHAR(100)  NULL,
    CEP                  NVARCHAR(15)   NULL,
    TIPO_ENDERECO        VARCHAR(5)     NULL,
    EMAIL_CLIENTE        NVARCHAR(100)  NULL,    
    TELEFONE_CLIENTE     NVARCHAR(20)   NULL,      
    CPF                  NVARCHAR(14)   NULL,    
    NUMERO_NOTA_FISCAL   INT            NULL,
    QUANTIDADE           INT            NULL,
    VALOR_ITEM           DECIMAL(10,2)  NULL,
    VALOR_TOTAL          DECIMAL(10,2)  NULL,
    CONDICAO_PAGAMENTO   NVARCHAR(100)  NULL,
    TITULO               NVARCHAR(100)  NULL,
    AUTOR                NVARCHAR(100)  NULL,
    ID_LOJA              INT            NULL,
    ID_ATENDENTE         INT            NULL,
    DATA_VENDA           DATE           NULL,
    DATA_PROCESSAMENTO   DATE           NULL
);
GO

CREATE TABLE CEP (
    CEP         VARCHAR(15)     NOT NULL,
    UF          VARCHAR(5)      NULL,
    CIDADE      VARCHAR(150)    NULL,
    BAIRRO      VARCHAR(150)    NULL,
    LOGRADOURO  VARCHAR(255)    NULL,
);
GO

CREATE TABLE LIVRO (
	AUTOR		VARCHAR(100)	NULL,
	TITULO		VARCHAR(100)	NULL,
	GENERO		VARCHAR(100)	NULL,
	QUANTIDADE	INT				NULL,
	VALOR		DECIMAL(10,2)	NULL
);
GO

CREATE TABLE LOJA(
    NOME       VARCHAR(50)     NULL,
    CIDADE     VARCHAR(25)     NULL,
    ENDERECO   VARCHAR(100)    NULL,
    CNPJ       BIGINT          NULL
);
GO

CREATE TABLE TIPO_DESCONTO(
    MINIMO_DIA         DATE                NULL,
    MAXIMO_DIA         DATE                NULL,
    PERCENT_MIN        DECIMAL(10,2)       NULL,
    PERCENT_MAX        DECIMAL(10,2)       NULL,
    DESC_DESCONTO      VARCHAR(30)         NULL,
    DATA_APROVACAO     DATE                NULL,
    APROVADOR          VARCHAR(50)         NULL,
    TIPO               VARCHAR(25)         NULL,
    ESTATUS            VARCHAR(30)         NULL
);
GO

CREATE TABLE ATENDENTE(
    NOME        VARCHAR(50)     NULL,
    TELEFONE    BIGINT          NULL,
    EMAIL       VARCHAR(50)     NULL,
    ID_LOJA     INT             NULL
);
GO

CREATE TABLE TIPO_ENDERECO (
    DESCRICAO    VARCHAR(100)    NULL,
    SIGLA        VARCHAR(20)     NULL
);
GO

CREATE TABLE TIPO_PAGAMENTO(
    TIPO          VARCHAR(25)    NULL,
    DESCRICAO     VARCHAR(100)   NULL
);
GO

CREATE TABLE AUTOR(
    NOME    VARCHAR(100)    NULL,
);

--##### TABELAS NOVAS PARA A VALIDACAO ####

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
    MOTIVO_REJEICAO                 VARCHAR(100)   NOT NULL
);
GO

-- ARMAZENA AS NOTAS QUE JA FORAM TRATADAS
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
GO

--  ARMAZENA AS NOTAS FISCAIS JA TRATADAS
CREATE TABLE VALIDACAO (
    NUMERO_NOTA_FISCAL      INT     NOT NULL,
    DATA_PROCESSAMENTO      DATE    NOT NULL
);