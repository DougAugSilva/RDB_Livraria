USE STAGE;
GO

CREATE OR ALTER PROCEDURE dbo.insere_recebimento_stage
AS
BEGIN
	BULK INSERT RECEBIMENTO
	FROM 'C:\Arquivos_banco_dados\input\recebimentos.csv'
		WITH (
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '\n',
				FIRSTROW = 2,
				CODEPAGE = 65001
			);
END;