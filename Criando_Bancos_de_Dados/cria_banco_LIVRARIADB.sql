CREATE DATABASE LIVRARIADB;
GO

USE LIVRARIADB;
GO

CREATE TABLE LIVRO(
    ID_LIVRO                INT            IDENTITY (1,1), --
    TITULO                  VARCHAR(100)   NOT NULL, --
    GENERO                  VARCHAR(100)   NOT NULL, --
    VALOR                   DECIMAL(10,2)  NOT NULL, --
    QUANTIDADE              INT            NOT NULL, --
    CONSTRAINT PK_LIVRO     PRIMARY KEY (ID_LIVRO)
);
GO

CREATE TABLE AUTOR(
    NOME                VARCHAR(100)            NOT NULL,
    ID_AUTOR            INT                     IDENTITY (1,1),
    CONSTRAINT PK_AUTOR PRIMARY KEY (ID_AUTOR)
);
GO

CREATE TABLE LIVRO_AUTOR(
    CONSTRAINT PK_LIVRO_AUTOR    PRIMARY KEY (ID_LIVRO, ID_AUTOR),
    ID_LIVRO                     INT                    NOT NULL,
    ID_AUTOR                     INT                    NOT NULL,
    CONSTRAINT FK_LIVRO          FOREIGN KEY (ID_LIVRO) REFERENCES LIVRO(ID_LIVRO),
    CONSTRAINT FK_AUTOR          FOREIGN KEY (ID_AUTOR) REFERENCES AUTOR(ID_AUTOR)
);
GO

CREATE TABLE ITEM_VENDA(
    ID_VENDA                INT IDENTITY (1,1),
    ID_LIVRO                INT NOT NULL,
    QUANTIDADE              INT NOT NULL,
    CONSTRAINT PK_VENDA     PRIMARY KEY (ID_VENDA),
    CONSTRAINT FK_LIVRO_2   FOREIGN KEY (ID_LIVRO) REFERENCES LIVRO(ID_LIVRO)
);
GO

CREATE TABLE TIPO_PAGAMENTO(
    ID_TIPO_PAGAMENTO               INT             IDENTITY (1,1),
    TIPO                            VARCHAR(25)     NOT NULL,
    DESCRICAO                       VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_TIPO_PAGAMENTO    PRIMARY KEY (ID_TIPO_PAGAMENTO)
);
GO

CREATE TABLE CLIENTE(
    ID_CLIENTE              INT             IDENTITY (1,1),
    NOME_CLIENTE            VARCHAR(100)    NOT NULL ,
    CPF                     VARCHAR(14)     NOT NULL,
    TELEFONE                VARCHAR(20)     NOT NULL,
    EMAIL                   VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_CLIENTE   PRIMARY KEY (ID_CLIENTE)
);
GO

CREATE TABLE NOTA_FISCAL(
    ID_NF                       INT                             IDENTITY (1,1),
    ID_TIPO_PAGAMENTO           INT                             NOT NULL,
    ID_CLIENTE                  INT                             NOT NULL,
    DATA_NOTA                   DATE                            NOT NULL,
    NUMERO_NOTA_FISCAL          INT                             NULL,
    CONSTRAINT PK_DATA_NOTA     PRIMARY KEY (ID_NF),
    CONSTRAINT FK_TIPO_DESCONTO FOREIGN KEY (ID_TIPO_PAGAMENTO) REFERENCES TIPO_PAGAMENTO(ID_TIPO_PAGAMENTO),
    CONSTRAINT FK_CLIENTE       FOREIGN KEY (ID_CLIENTE)        REFERENCES CLIENTE(ID_CLIENTE)
);
GO

CREATE TABLE PROG_RECEBIMENTO(
    ID_PROG_RECEBIMENTO INT                     IDENTITY (1,1),
    ID_NF               INT                     NOT NULL,
    NUM_PARCELA         INT                     NOT NULL,
    VAL_PARCELA         DECIMAL(10,2)           NOT NULL,
    DATA_VENCIMENTO     DATE                    NOT NULL,
    PAGO                INT                     NOT NULL,
    CONSTRAINT PK_PROG_RECEBIMENTO              PRIMARY KEY (ID_PROG_RECEBIMENTO),
    CONSTRAINT FK_NF    FOREIGN KEY (ID_NF)     REFERENCES NOTA_FISCAL(ID_NF)
);
GO

CREATE TABLE TIPO_DESCONTO(
    ID_TIPO_DESCONTO            INT                 IDENTITY (1,1),
    MINIMO_DIA                  DATE                NOT NULL,
    MAXIMO_DIA                  DATE                NOT NULL,
    PERCENT_MIN                 DECIMAL(10,2)       NOT NULL,
    PERCENT_MAX                 DECIMAL(10,2)       NOT NULL,
    DESC_DESCONTO               VARCHAR(30)        NOT NULL,
    DATA_APROVACAO              DATE                NOT NULL,
    APROVADOR                   VARCHAR(50)         NOT NULL,
    TIPO                        VARCHAR(25)         NOT NULL,
    ESTATUS                     VARCHAR(30)         NOT NULL,
    CONSTRAINT PK_TIPO_DESCONTO PRIMARY KEY (ID_TIPO_DESCONTO)
);
GO

CREATE TABLE HISTORICO_DIVERGENTE(
    ID_H_DIVERGENTE                 INT                                 IDENTITY (1,1),
    ID_PROG_RECEBIMENTO             INT                                 NULL,
    ID_TIPO_DESCONTO                INT                                 NULL,
    DATA_PROCESSAMENTO              DATE                                NULL,
    VALOR_TOTAL                     DECIMAL(10,2)                       NOT NULL,
    MOTIVO                          VARCHAR(100)                        NULL, --
    CONDICAO_PAGAMENTO              VARCHAR(100)                        NULL,
    CONSTRAINT PK_H_DIVERGENTE      PRIMARY KEY (ID_H_DIVERGENTE),
    CONSTRAINT FK_PROG_RECEBIMENTO  FOREIGN KEY (ID_PROG_RECEBIMENTO)   REFERENCES PROG_RECEBIMENTO(ID_PROG_RECEBIMENTO),
    CONSTRAINT FK_TIPO_DESCONTO_HRD FOREIGN KEY (ID_TIPO_DESCONTO)      REFERENCES TIPO_DESCONTO(ID_TIPO_DESCONTO)
);
GO

CREATE TABLE HISTORICO_RECEBIMENTO(
    ID_PROG_RECEBIMENTO             INT                                 NOT NULL,
    ID_TIPO_DESCONTO                INT                                 NOT NULL,
    ID_H_RECEBIMENTO                INT                                 IDENTITY (1,1),
    DATA_RECEBIMENTO                DATE                                NOT NULL,
    VALOR_RECEBIDO                  DECIMAL(10,2)                       NOT NULL,
    CONSTRAINT PK_H_RECEBIMENTO     PRIMARY KEY (ID_H_RECEBIMENTO),
    CONSTRAINT FK_RECEBIMENTO       FOREIGN KEY (ID_PROG_RECEBIMENTO)   REFERENCES PROG_RECEBIMENTO(ID_PROG_RECEBIMENTO),
    CONSTRAINT FK_TIPO_DESCONTO_HR  FOREIGN KEY (ID_TIPO_DESCONTO)      REFERENCES TIPO_DESCONTO(ID_TIPO_DESCONTO)
);
GO

CREATE TABLE LOJA(
    ID_LOJA             INT             IDENTITY (1,1),
    NOME                VARCHAR(50)     NOT NULL,
    CIDADE              VARCHAR(25)     NOT NULL,
    ENDERECO            VARCHAR(100)    NOT NULL,
    CNPJ                BIGINT          NOT NULL,
    CONSTRAINT PK_LOJA  PRIMARY KEY (ID_LOJA)
);
GO

CREATE TABLE ATENDENTE(
    ID_ATENDENTE            INT                     IDENTITY (1,1),
    NOME                    VARCHAR(50)             NOT NULL,
    TELEFONE                BIGINT                  NOT NULL,
    EMAIL                   VARCHAR(50)             NOT NULL,
    ID_LOJA                 INT                     NOT NULL,
    CONSTRAINT PK_ATENDENTE PRIMARY KEY (ID_ATENDENTE),
    CONSTRAINT FK_LOJA      FOREIGN KEY (ID_LOJA)   REFERENCES LOJA(ID_LOJA)
);
GO

CREATE TABLE ENDERECOS_CLIENTES (
    ID_ENDERECO_CLIENTE                 INT             IDENTITY (1,1),
    ID_CLIENTE                          INT             NULL, 
    TIPO_ENDERECO                       INT             NOT NULL,
    CEP                                 VARCHAR(20)     NOT NULL,
    NUMERO                              INT             NOT NULL,
    COMPLEMENTO                         VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_ENDERECOS_CLIENTES    PRIMARY KEY (ID_ENDERECO_CLIENTE)
);
GO

CREATE TABLE CEP (
    CEP                 VARCHAR(20)     NOT NULL,
    UF                  VARCHAR(5)      NOT NULL,
    CIDADE              VARCHAR(150)    NOT NULL,
    BAIRRO              VARCHAR(150)    NOT NULL,
    LOGRADOURO          VARCHAR(150)    NOT NULL,
    CONSTRAINT PK_CEP   PRIMARY KEY (CEP)
);
GO

CREATE TABLE TIPO_ENDERECO (
    ID_TIPO_ENDERECO            INT             IDENTITY (1,1),
    DESCRICAO                   VARCHAR(100)    NOT NULL,
    SIGLA                       VARCHAR(20)     NOT NULL,
    CONSTRAINT PK_TIPO_ENDERECO PRIMARY KEY (ID_TIPO_ENDERECO)
);