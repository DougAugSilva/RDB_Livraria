USE STAGE;
GO

CREATE PROCEDURE dbo.insere_livro_stage
AS
BEGIN
	BULK INSERT LIVRO
		FROM 'C:\Arquivos_banco_dados\livros.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		);
END;