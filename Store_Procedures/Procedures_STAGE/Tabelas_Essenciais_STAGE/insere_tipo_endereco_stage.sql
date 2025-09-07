USE STAGE;
GO

CREATE PROCEDURE dbo.insere_tipo_endereco_stage
AS
BEGIN
	BULK INSERT TIPO_ENDERECO
		FROM 'C:\Arquivos_banco_dados\tipo_endereco.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			CODEPAGE = 65001
		);
END;