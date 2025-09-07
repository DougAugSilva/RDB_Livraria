USE LIVRARIADB;
GO

CREATE PROCEDURE dbo.insere_autor_livrariadb
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
			SET @nome = 'nao informado';
		
		INSERT INTO LIVRARIADB.dbo.AUTOR (NOME)
		VALUES (@nome)

		FETCH NEXT FROM db_cursor INTO @nome;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;