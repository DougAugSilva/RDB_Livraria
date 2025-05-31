USE STAGE;
GO

CREATE PROCEDURE dbo.insere_tipo_pagamento_stage
AS
BEGIN
	BULK INSERT TIPO_PAGAMENTO
		FROM 'C:\Arquivos_banco_dados\tipo_pagamento.csv' 
		WITH(
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		);
END;