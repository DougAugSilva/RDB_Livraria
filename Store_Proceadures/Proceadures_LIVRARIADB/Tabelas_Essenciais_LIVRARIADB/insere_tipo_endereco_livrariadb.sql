USE LIVRARIADB;
GO

CREATE PROCEDURE dbo.insere_tipo_endereco_livrariadb
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