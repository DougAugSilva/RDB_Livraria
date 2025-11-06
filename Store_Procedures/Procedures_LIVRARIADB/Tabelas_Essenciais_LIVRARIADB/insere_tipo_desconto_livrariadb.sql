USE LIVRARIADB;
GO

CREATE OR ALTER PROCEDURE dbo.insere_tipo_desconto_livrariadb
AS
BEGIN
	DECLARE db_cursor CURSOR FOR
		SELECT MINIMO_DIA, MAXIMO_DIA, PERCENT_MIN, PERCENT_MAX, DESC_DESCONTO, TIPO, STATUS
		FROM STAGE.dbo.TIPO_DESCONTO
	
	DECLARE @minimo_dia		INT;
	DECLARE @maximo_dia		INT;
	DECLARE @percent_min	DECIMAL(10,2);
	DECLARE @percent_max	DECIMAL(10,2);
	DECLARE @desc_desconto	VARCHAR(100);
	DECLARE @tipo			INT;
	DECLARE @status			INT;

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @minimo_dia, @maximo_dia, @percent_min, @percent_max, @desc_desconto, @tipo, @status;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @desc_desconto IS NULL
				SET @desc_desconto = 'nao informado';

		INSERT INTO LIVRARIADB.dbo.TIPO_DESCONTO (MINIMO_DIA, MAXIMO_DIA, PERCENT_MIN, PERCENT_MAX, DESC_DESCONTO, TIPO, STATUS)
		VALUES (@minimo_dia, @maximo_dia, @percent_min, @percent_max, @desc_desconto, @tipo, @status)

		FETCH NEXT FROM db_cursor INTO @minimo_dia, @maximo_dia, @percent_min, @percent_max, @desc_desconto, @tipo, @status;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;