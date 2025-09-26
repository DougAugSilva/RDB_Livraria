USE LIVRARIADB;
GO

CREATE OR ALTER PROCEDURE dbo.insere_tipo_desconto_livrariadb
AS
BEGIN
	DECLARE db_cursor CURSOR FOR
		SELECT MINIMO_DIA, MAXIMO_DIA, PERCENT_MIN, PERCENT_MAX, DESC_DESCONTO, DATA_APROVACAO, APROVADOR, TIPO, ESTATUS
		FROM STAGE.dbo.TIPO_DESCONTO
	
	DECLARE @minimo_dia		INT;
	DECLARE @maximo_dia		INT;
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
				SET @desc_desconto = 'nao informado';

		IF @aprovador IS NULL
				SET @aprovador = 'nao informado';
	
		IF @tipo IS NULL
				SET @tipo = 'nao informado';
	
		IF @estatus IS NULL
				SET @estatus = 'nao informado';

		INSERT INTO LIVRARIADB.dbo.TIPO_DESCONTO (MINIMO_DIA, MAXIMO_DIA, PERCENT_MIN, PERCENT_MAX, DESC_DESCONTO, DATA_APROVACAO, APROVADOR, TIPO, ESTATUS)
		VALUES (@minimo_dia, @maximo_dia, @percent_min, @percent_max, @desc_desconto, @data_aprovacao, @aprovador, @tipo, @estatus)

		FETCH NEXT FROM db_cursor INTO @minimo_dia, @maximo_dia, @percent_min, @percent_max, @desc_desconto, @data_aprovacao, @aprovador, @tipo, @estatus;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
END;