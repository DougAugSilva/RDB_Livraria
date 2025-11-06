USE STAGE;
GO

CREATE OR ALTER PROCEDURE dbo.insere_atendente_stage
AS
BEGIN
	BULK INSERT ATENDENTE
		FROM 'C:\Arquivos_banco_dados\atendentes.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			CODEPAGE = 65001
		);
END;