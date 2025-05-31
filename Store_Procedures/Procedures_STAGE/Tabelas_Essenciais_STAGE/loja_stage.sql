USE STAGE;
GO

CREATE PROCEDURE dbo.insere_loja_stage
AS
BEGIN
	BULK INSERT LOJA
		FROM 'C:\Arquivos_banco_dados\lojas.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		);
END;