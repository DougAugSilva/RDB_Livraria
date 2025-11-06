USE LIVRARIADB;
GO

CREATE OR ALTER PROCEDURE dbo.insere_tipo_pagamento_livrariadb
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
			SET @tipos = 'nao informado';

		IF @descricao IS NULL
			SET @descricao = 'nao informado';
		
		INSERT INTO LIVRARIADB.dbo.TIPO_PAGAMENTO (TIPO, DESCRICAO)
		VALUES (@tipos, @descricao)

		FETCH NEXT FROM db_cursor INTO @tipos, @descricao;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;