USE STAGE;
GO

CREATE OR ALTER PROCEDURE dbo.insere_tipo_pagamento_stage
AS
BEGIN
	BULK INSERT TIPO_PAGAMENTO
		FROM 'C:\Arquivos_banco_dados\tipo_pagamento.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			CODEPAGE = 65001
		);
END;