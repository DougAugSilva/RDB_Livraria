USE STAGE;
GO

CREATE PROCEDURE dbo.insere_autor_stage
AS
BEGIN
	BULK INSERT AUTOR
		FROM 'C:\Arquivos_banco_dados\autor.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			CODEPAGE = 65001
		);
END;