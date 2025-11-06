USE STAGE;
GO

CREATE OR ALTER PROCEDURE dbo.insere_csv_movimentacao_livros_stage
AS
BEGIN

	BULK INSERT MOVIMENTACAO_LIVROS 
	FROM 'C:\Arquivos_banco_dados\input\movimentacao_livros.csv' 
	WITH(
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		CODEPAGE = 65001
	);
END;