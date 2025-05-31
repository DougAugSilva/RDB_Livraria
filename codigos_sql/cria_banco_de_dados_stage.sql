CREATE DATABASE STAGE;
GO

USE STAGE;
GO

CREATE TABLE MOVIMENTACAO_LIVROS (
    NOME_CLIENTE         VARCHAR(100)   NULL,   
    NUMERO_ENDERECO      INT            NULL,
    COMPLEMENTO          VARCHAR(100)   NULL,
    CEP                  VARCHAR(15)    NULL,
    TIPO_ENDERECO        INT            NULL,
    EMAIL_CLIENTE        VARCHAR(100)   NULL,    
    TELEFONE_CLIENTE     VARCHAR(20)    NULL,      
    CPF                  VARCHAR(14)    NULL,    
    NUMERO_NOTA_FISCAL   INT            NULL,
    QUANTIDADE           INT            NULL,
    VALOR_ITEM           DECIMAL(10,2)  NULL,
    VALOR_TOTAL          DECIMAL(10,2)  NULL,
    CONDICAO_PAGAMENTO   VARCHAR(100)   NULL,
    TITULO               VARCHAR(100)   NULL,
    AUTOR                VARCHAR(100)   NULL,
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
