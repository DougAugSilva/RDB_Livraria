USE LIVRARIADB;
GO

CREATE PROCEDURE dbo.insere_livro_livrariadb
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