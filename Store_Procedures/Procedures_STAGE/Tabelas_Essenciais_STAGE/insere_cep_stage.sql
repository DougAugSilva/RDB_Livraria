USE STAGE;
GO

CREATE OR ALTER PROCEDURE dbo.insere_cep_stage
AS
BEGIN
	BULK INSERT CEP
		FROM 'C:\Arquivos_banco_dados\cep.csv' 
		WITH(
			FIELDTERMINATOR = ';',
			ROWTERMINATOR = '\n',
			CODEPAGE = 65001,
			FIRSTROW = 1
		);
END;