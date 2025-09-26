USE STAGE;
GO

CREATE OR ALTER PROCEDURE dbo.insere_tipos_de_erros_stage
AS
BEGIN
	BULK INSERT TIPO_DE_ERRO
		FROM 'C:\Arquivos_banco_dados\tipos_de_erros.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			CODEPAGE = 65001
		);
END;