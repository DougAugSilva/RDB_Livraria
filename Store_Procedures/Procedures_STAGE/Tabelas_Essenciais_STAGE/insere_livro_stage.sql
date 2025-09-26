USE STAGE;
GO

CREATE OR ALTER PROCEDURE dbo.insere_livro_stage
AS
BEGIN
	BULK INSERT LIVRO
		FROM 'C:\Arquivos_banco_dados\livros.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			CODEPAGE = 65001
		);
END;