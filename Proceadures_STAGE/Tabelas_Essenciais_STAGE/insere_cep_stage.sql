USE STAGE;
GO

CREATE PROCEDURE dbo.insere_cep_stage
AS
BEGIN
	BULK INSERT CEP
		FROM 'C:\Arquivos_banco_dados\cep_clientes.csv' 
		WITH(
			FIELDTERMINATOR = ';',
			ROWTERMINATOR = '\n',
			CODEPAGE = 65001,
			FIRSTROW = 1
		);
END;