USE LIVRARIADB;
GO
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
			
		IF NOT EXISTS (SELECT CEP FROM LIVRARIADB.dbo.CEP WHERE CEP = @cep)
		
			INSERT INTO LIVRARIADB.dbo.CEP (CEP, UF, CIDADE, BAIRRO, LOGRADOURO)
			VALUES (@cep, @uf, @cidade, @bairro, @logradouro)
			
		FETCH NEXT FROM db_cursor INTO @cep, @uf, @cidade, @bairro, @logradouro;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;

USE LIVRARIADB;
GO
ALTER PROCEDURE dbo.insere_cep_livrariadb_2
AS
BEGIN
	INSERT INTO LIVRARIADB.dbo.CEP
	SELECT *
	FROM STAGE.dbo.CEP
END