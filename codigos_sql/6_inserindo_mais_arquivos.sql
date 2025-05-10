USE STAGE;

DROP TABLE CEP;

CREATE TABLE CEP (
    CEP                 VARCHAR(15)     NOT NULL,
    UF                  VARCHAR(5)      NULL,
    CIDADE              VARCHAR(150)    NULL,
    BAIRRO              VARCHAR(150)    NULL,
    LOGRADOURO          VARCHAR(255)    NULL,
);

--================================
USE STAGE;

IF OBJECT_ID('dbo.insere_cep_stage') IS NOT NULL
	DROP PROCEDURE dbo.insere_cep_stage;
GO

ALTER PROCEDURE dbo.insere_cep_stage
AS
BEGIN
	BULK INSERT CEP
		FROM 'C:\Arquivos_banco_dados\cep_clientes.csv' 
		WITH(
			FIELDTERMINATOR = ';',
			ROWTERMINATOR = '\n',
			CODEPAGE = 65001,
			FIRSTROW = 1
		);
END;

-- ================================
USE LIVRARIADB;
GO

IF OBJECT_ID('dbo.insere_cep_livrariadb') IS NOT NULL
	DROP PROCEDURE dbo.insere_cep_livrariadb;

CREATE PROCEDURE dbo.insere_cep_livrariadb
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
			
		IF NOT EXISTS (SELECT CEP FROM LIVRARIADB.dbo.ENDERECOS_CLIENTES WHERE CEP = @cep)
		
			INSERT INTO LIVRARIADB.dbo.CEP (CEP, UF, CIDADE, BAIRRO, LOGRADOURO)
			VALUES (@cep, @uf, @cidade, @bairro, @logradouro)
			
		FETCH NEXT FROM db_cursor INTO @cep, @uf, @cidade, @bairro, @logradouro;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;

-- ===================================================
CREATE TABLE LIVRO (
	AUTOR		VARCHAR(100)	NULL,
	TITULO		VARCHAR(100)	NULL,
	GENERO		VARCHAR(100)	NULL,
	QUANTIDADE	INT				NULL,
	VALOR		DECIMAL(10,2)	NULL
);

-- ================================
ALTER PROCEDURE dbo.insere_livro_stage
AS
BEGIN
	BULK INSERT LIVRO
		FROM 'C:\Arquivos_banco_dados\livros.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		);
END;

