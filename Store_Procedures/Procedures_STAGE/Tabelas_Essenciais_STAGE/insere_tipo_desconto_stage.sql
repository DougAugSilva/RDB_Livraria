USE STAGE;
GO

CREATE OR ALTER PROCEDURE dbo.insere_tipo_desconto_stage
AS
BEGIN
	BULK INSERT TIPO_DESCONTO
		FROM 'C:\Arquivos_banco_dados\tipo_desconto.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			CODEPAGE = 65001
		);
END;