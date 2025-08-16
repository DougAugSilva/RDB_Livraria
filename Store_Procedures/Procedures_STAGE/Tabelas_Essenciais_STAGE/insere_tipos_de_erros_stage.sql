USE STAGE;
GO

CREATE PROCEDURE dbo.insere_tipos_de_erros_stage
AS
BEGIN
	BULK INSERT TIPO_PAGAMENTO
		FROM 'C:\Arquivos_banco_dados\tipos_de_erros.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		);
END;