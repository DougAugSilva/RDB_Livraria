-- Cria LIVRARIADB TODO
CREATE DATABASE LIVRARIADB;
GO

USE LIVRARIADB;
GO

CREATE TABLE LIVRO(
    ID_LIVRO                INT            IDENTITY (1,1),
    TITULO                  VARCHAR(100)   NOT NULL, 
    GENERO                  VARCHAR(100)   NOT NULL, 
    VALOR                   DECIMAL(10,2)  NOT NULL, 
    QUANTIDADE              INT            NOT NULL, 
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

CREATE TABLE NOTA_FISCAL(
    ID_NF                       INT                             IDENTITY (1,1),
    ID_TIPO_PAGAMENTO           INT                             NOT NULL,
    ID_CLIENTE                  INT                             NOT NULL,
    ID_LIVRO                    INT                             NOT NULL,
    ID_ATENDENTE                INT                             NOT NULL,
    DATA_NOTA                   DATE                            NOT NULL,
    NUMERO_NOTA_FISCAL          INT                             NULL,
    CONSTRAINT PK_ID_NF       PRIMARY KEY (ID_NF),
    CONSTRAINT FK_TIPO_PAGAMENTO FOREIGN KEY (ID_TIPO_PAGAMENTO) REFERENCES TIPO_PAGAMENTO(ID_TIPO_PAGAMENTO),
    CONSTRAINT FK_CLIENTE       FOREIGN KEY (ID_CLIENTE)        REFERENCES CLIENTE(ID_CLIENTE),
    CONSTRAINT FK_LIVRO_3         FOREIGN KEY (ID_LIVRO)          REFERENCES LIVRO(ID_LIVRO),
    CONSTRAINT FK_ATENDENTE     FOREIGN KEY (ID_ATENDENTE)      REFERENCES ATENDENTE(ID_ATENDENTE)
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
    DESC_DESCONTO               VARCHAR(30)         NOT NULL,
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

CREATE TABLE CEP (
    ID_CEP              INT             IDENTITY (1,1),
    CEP                 VARCHAR(15)     NOT NULL,
    UF                  VARCHAR(5)      NOT NULL,
    CIDADE              VARCHAR(150)    NOT NULL,
    BAIRRO              VARCHAR(150)    NOT NULL,
    LOGRADOURO          VARCHAR(150)    NOT NULL,
    CONSTRAINT PK_CEP   PRIMARY KEY (ID_CEP)
);
GO

CREATE TABLE TIPO_ENDERECO (
    ID_TIPO_ENDERECO            INT             IDENTITY (1,1),
    DESCRICAO                   VARCHAR(100)    NOT NULL,
    SIGLA                       VARCHAR(20)     NOT NULL,
    CONSTRAINT PK_TIPO_ENDERECO PRIMARY KEY (ID_TIPO_ENDERECO)
);
GO

CREATE TABLE ENDERECOS_CLIENTES (
    ID_ENDERECO_CLIENTE                 INT             IDENTITY (1,1),
    ID_CLIENTE                          INT             NOT NULL, 
    ID_TIPO_ENDERECO                    INT             NOT NULL,
    ID_CEP                              INT             NOT NULL,
    NUMERO                              INT             NOT NULL,
    COMPLEMENTO                         VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_ENDERECOS_CLIENTES    PRIMARY KEY (ID_ENDERECO_CLIENTE),
    CONSTRAINT FK_ID_TIPO_ENDERECO      FOREIGN KEY (ID_TIPO_ENDERECO) REFERENCES TIPO_ENDERECO(ID_TIPO_ENDERECO),
    CONSTRAINT FK_ID_CEP                FOREIGN KEY (ID_CEP)           REFERENCES CEP(ID_CEP),
    CONSTRAINT FK_ID_CLIENTE            FOREIGN KEY (ID_CLIENTE)       REFERENCES CLIENTE(ID_CLIENTE)
);
--######################################################
USE LIVRARIADB;
GO

ALTER PROCEDURE dbo.insere_atendente_livrariadb
AS
BEGIN

	DECLARE db_cursor CURSOR FOR
		SELECT NOME, TELEFONE, EMAIL, ID_LOJA
		FROM STAGE.dbo.ATENDENTE

	DECLARE @nome	 	VARCHAR(50);
	DECLARE @telefone  	BIGINT;
	DECLARE @email   	VARCHAR(50);
	DECLARE @id_loja    INT;

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @nome, @telefone, @email, @id_loja;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @nome IS NULL
				SET @nome = 'não informado';
	
		IF @email IS NULL
			SET @email = 'não informado';
	
		IF NOT EXISTS (SELECT NOME FROM LIVRARIADB.dbo.ATENDENTE WHERE EMAIL = @email)
				INSERT INTO LIVRARIADB.dbo.ATENDENTE (NOME, TELEFONE, EMAIL, ID_LOJA)
				VALUES (@nome, @telefone, @email, @id_loja)
	
		FETCH NEXT FROM db_cursor INTO @nome, @telefone, @email, @id_loja;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;
GO
--=======================================================
USE LIVRARIADB;
GO
ALTER PROCEDURE dbo.insere_autor_livrariadb
AS
BEGIN
	DECLARE db_cursor CURSOR FOR
		SELECT NOME
		FROM STAGE.dbo.AUTOR

	DECLARE @nome	VARCHAR(25);

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @nome;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @nome IS NULL
			SET @nome = 'năo informado';
		
		INSERT INTO LIVRARIADB.dbo.AUTOR (NOME)
		VALUES (@nome)

		FETCH NEXT FROM db_cursor INTO @nome;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;
GO
--=======================================================
USE LIVRARIADB;
GO
ALTER PROCEDURE dbo.insere_cep_livrariadb
AS
BEGIN

	DECLARE db_cursor CURSOR FOR
		SELECT CEP, UF, CIDADE, BAIRRO, LOGRADOURO
		FROM STAGE.dbo.CEP

	DECLARE @cep		VARCHAR(15);
	DECLARE @uf			VARCHAR(15);
	DECLARE @cidade		VARCHAR(150);
	DECLARE @bairro		VARCHAR(150);
	DECLARE @logradouro VARCHAR(255);

	OPEN db_cursor;
	FETCH NEXT FROM db_cursor INTO @cep, @uf, @cidade, @bairro, @logradouro;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @uf IS NULL
			SET @uf = 'não infromado';

		IF @cidade IS NULL
			SET @cidade = 'não infromado';

		IF @bairro IS NULL
			SET @bairro = 'não infromado';

		IF @logradouro IS NULL
			SET @logradouro = 'não infromado';
			
		IF NOT EXISTS (SELECT CEP FROM LIVRARIADB.dbo.CEP WHERE CEP = @cep)
		
			INSERT INTO LIVRARIADB.dbo.CEP (CEP, UF, CIDADE, BAIRRO, LOGRADOURO)
			VALUES (@cep, @uf, @cidade, @bairro, @logradouro)
			
		FETCH NEXT FROM db_cursor INTO @cep, @uf, @cidade, @bairro, @logradouro;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;
GO
--=======================================================
USE LIVRARIADB;
GO
ALTER PROCEDURE dbo.insere_livro_livrariadb
AS
BEGIN

	DECLARE db_cursor CURSOR FOR
		SELECT AUTOR, TITULO, GENERO, QUANTIDADE, VALOR
		FROM STAGE.dbo.LIVRO
	
	DECLARE @autor		VARCHAR(100);
	DECLARE @titulo		VARCHAR(100);
	DECLARE @genero		VARCHAR(100);
	DECLARE @quantidade	VARCHAR(100);
	DECLARE @valor 		DECIMAL(10,2);

	OPEN db_cursor;
	FETCH NEXT FROM db_cursor INTO @autor, @titulo, @genero, @quantidade, @valor;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @genero IS NULL
			SET @genero = 'não informado';
	
		IF @autor IS NULL
			SET @autor = 'não informado';
	
		IF NOT EXISTS (SELECT TITULO FROM LIVRARIADB.dbo.LIVRO WHERE TITULO = @titulo)
			INSERT INTO LIVRARIADB.dbo.LIVRO (TITULO, GENERO, QUANTIDADE, VALOR)
			VALUES (@titulo, @genero, @quantidade, @valor)
	
		IF NOT EXISTS (SELECT NOME FROM LIVRARIADB.dbo.AUTOR WHERE NOME = @autor)
			INSERT INTO LIVRARIADB.dbo.AUTOR (NOME)
			VALUES (@autor)
	
		FETCH NEXT FROM db_cursor INTO @autor, @titulo, @genero, @quantidade, @valor;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;
GO
--=======================================================
USE LIVRARIADB;
GO
ALTER PROCEDURE dbo.insere_loja_livrariadb
AS
BEGIN

	DECLARE db_cursor CURSOR FOR
		SELECT NOME, CIDADE, ENDERECO, CNPJ
		FROM STAGE.dbo.LOJA

	DECLARE @nome		VARCHAR(50);
	DECLARE @cidade		VARCHAR(25);
	DECLARE @endereco	VARCHAR(100);
	DECLARE @cnpj		BIGINT;

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @nome, @cidade, @endereco, @cnpj;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @nome IS NULL
				SET @nome = 'não informado';
	
		IF @cidade IS NULL
			SET @cidade = 'não informado';

		IF @endereco IS NULL
			SET @endereco = 'não informado';
	
		IF NOT EXISTS (SELECT NOME FROM LIVRARIADB.dbo.LOJA WHERE CNPJ = @cnpj)
				INSERT INTO LIVRARIADB.dbo.LOJA (NOME, CIDADE, ENDERECO, CNPJ)
				VALUES (@nome, @cidade, @endereco, @cnpj)
	
		FETCH NEXT FROM db_cursor INTO @nome, @cidade, @endereco, @cnpj;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;
GO
--=======================================================
USE LIVRARIADB;
GO
ALTER PROCEDURE dbo.insere_tipo_desconto_livrariadb
AS
BEGIN
	DECLARE db_cursor CURSOR FOR
		SELECT MINIMO_DIA, MAXIMO_DIA, PERCENT_MIN, PERCENT_MAX, DESC_DESCONTO, DATA_APROVACAO, APROVADOR, TIPO, ESTATUS
		FROM STAGE.dbo.TIPO_DESCONTO
	
	DECLARE @minimo_dia		DATE;
	DECLARE @maximo_dia		DATE;
	DECLARE @percent_min	DECIMAL(10,2);
	DECLARE @percent_max	DECIMAL(10,2);
	DECLARE @desc_desconto	VARCHAR(30);
	DECLARE @data_aprovacao	DATE;
	DECLARE @aprovador		VARCHAR(50);
	DECLARE @tipo			VARCHAR(25);
	DECLARE @estatus		VARCHAR(30);

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @minimo_dia, @maximo_dia, @percent_min, @percent_max, @desc_desconto, @data_aprovacao, @aprovador, @tipo, @estatus;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @desc_desconto IS NULL
				SET @desc_desconto = 'não informado';

		IF @aprovador IS NULL
				SET @aprovador = 'não informado';
	
		IF @tipo IS NULL
				SET @tipo = 'não informado';
	
		IF @estatus IS NULL
				SET @estatus = 'não informado';

		INSERT INTO LIVRARIADB.dbo.TIPO_DESCONTO (MINIMO_DIA, MAXIMO_DIA, PERCENT_MIN, PERCENT_MAX, DESC_DESCONTO, DATA_APROVACAO, APROVADOR, TIPO, ESTATUS)
		VALUES (@minimo_dia, @maximo_dia, @percent_min, @percent_max, @desc_desconto, @data_aprovacao, @aprovador, @tipo, @estatus)

		FETCH NEXT FROM db_cursor INTO @minimo_dia, @maximo_dia, @percent_min, @percent_max, @desc_desconto, @data_aprovacao, @aprovador, @tipo, @estatus;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;
GO
--=======================================================
USE LIVRARIADB;
GO
ALTER PROCEDURE dbo.insere_tipo_endereco_livrariadb
AS
BEGIN

	DECLARE db_cursor CURSOR FOR
		SELECT DESCRICAO, SIGLA
		FROM STAGE.dbo.TIPO_ENDERECO
	
	DECLARE @descricao 	VARCHAR(100);
	DECLARE @sigla		VARCHAR(20);

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @descricao, @sigla;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @descricao IS NULL
			SET @descricao = 'não informado';
		
		IF @sigla IS NULL
			SET @sigla = 'não informado';
		
		IF NOT EXISTS (SELECT SIGLA FROM LIVRARIADB.dbo.TIPO_ENDERECO WHERE SIGLA = @sigla)
			INSERT INTO LIVRARIADB.dbo.TIPO_ENDERECO (DESCRICAO, SIGLA)
			VALUES (@descricao, @sigla)

		FETCH NEXT FROM db_cursor INTO @descricao, @sigla;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;
GO
--=======================================================
USE LIVRARIADB;
GO
ALTER PROCEDURE dbo.insere_tipo_pagamento_livrariadb
AS
BEGIN
	DECLARE db_cursor CURSOR FOR
		SELECT TIPO, DESCRICAO
		FROM STAGE.dbo.TIPO_PAGAMENTO

	DECLARE @tipos 		VARCHAR(25);
	DECLARE @descricao 	VARCHAR(100);

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @tipos, @descricao;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @tipos IS NULL
			SET @tipos = 'não informado';

		IF @descricao IS NULL
			SET @descricao = 'não informado';
		
		INSERT INTO LIVRARIADB.dbo.TIPO_PAGAMENTO (TIPO, DESCRICAO)
		VALUES (@tipos, @descricao)

		FETCH NEXT FROM db_cursor INTO @tipos, @descricao;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;
GO
USE LIVRARIADB;
--######################################################
USE LIVRARIADB;
GO
EXEC dbo.insere_cep_livrariadb
GO
EXEC dbo.insere_livro_livrariadb
GO
EXEC dbo.insere_loja_livrariadb
GO
EXEC dbo.insere_atendente_livrariadb
GO
EXEC dbo.insere_tipo_endereco_livrariadb
GO
EXEC dbo.insere_tipo_desconto_livrariadb
GO
EXEC dbo.insere_tipo_pagamento_livrariadb
GO
EXEC dbo.insere_autor_livrariadb

INSERT INTO LIVRO_AUTOR (ID_LIVRO, ID_AUTOR)
VALUES 
(1,1),
(2,1),
(3,2),
(4,3),
(5,4),
(6,5)