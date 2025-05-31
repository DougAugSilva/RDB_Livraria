USE LIVRARIADB;
GO

CREATE PROCEDURE dbo.insere_atendente_livrariadb
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
