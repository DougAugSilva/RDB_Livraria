USE STAGE;
GO

CREATE PROCEDURE dbo.insere_csv_movimentacao_livros_stage
AS
BEGIN

	BULK INSERT MOVIMENTACAO_LIVROS 
	FROM 'C:\Arquivos_banco_dados\carregar.csv' 
	WITH(
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	);
END;