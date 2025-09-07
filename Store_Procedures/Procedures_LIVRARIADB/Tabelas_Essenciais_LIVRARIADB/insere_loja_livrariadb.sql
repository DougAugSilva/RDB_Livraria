USE LIVRARIADB;
GO

CREATE PROCEDURE dbo.insere_loja_livrariadb
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
				SET @nome = 'nao informado';
	
		IF @cidade IS NULL
			SET @cidade = 'nao informado';

		IF @endereco IS NULL
			SET @endereco = 'nao informado';
	
		IF NOT EXISTS (SELECT NOME FROM LIVRARIADB.dbo.LOJA WHERE CNPJ = @cnpj)
				INSERT INTO LIVRARIADB.dbo.LOJA (NOME, CIDADE, ENDERECO, CNPJ)
				VALUES (@nome, @cidade, @endereco, @cnpj)
	
		FETCH NEXT FROM db_cursor INTO @nome, @cidade, @endereco, @cnpj;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;