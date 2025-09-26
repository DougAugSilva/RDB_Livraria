USE LIVRARIADB;

-------------------------------------
-- CRIANDO TABELA
CREATE TABLE #TESTE_PROG_RECB(
	ID_PROG_RECEBIMENTO INT                     IDENTITY (1,1),
    ID_NF               INT                     NOT NULL,
    NUM_PARCELA         INT                     NOT NULL,
    VAL_PARCELA         DECIMAL(10,2)           NOT NULL,
    DATA_VENCIMENTO     DATE                    NOT NULL,
    PAGO                INT                     NOT NULL,
);

-------------------------------
-- DECLARANDO VARIÁVEIS
DECLARE @contador			INT = 1;

DECLARE @id_nf				INT;
DECLARE @num_parcela		INT;
DECLARE @val_parcela		DECIMAL(10,2);
DECLARE	@data_vencimento	DATE;
DECLARE @pago				INT = 0;

DECLARE @tipo_pag			VARCHAR(25);
--------------------------
-- SELEÇÃO DOS VALORES
SELECT 
	NF.ID_NF, 
	TP.NUMERO_PARCELAS AS NUM_PARCELA,
	CAST(SUM(NF.VALOR_NF * 1/TP.NUMERO_PARCELAS) AS DECIMAL(10,2)) AS VAL_PARCELA,
	NF.DATA_NOTA AS DATA_VENCIMENTO,
	LEFT(TP.TIPO, 7) AS TIPO_PAG -- para verificação se há ou não entrada
FROM 
	NOTA_FISCAL AS NF
	JOIN TIPO_PAGAMENTO AS TP
	ON NF.ID_TIPO_PAGAMENTO = TP.ID_TIPO_PAGAMENTO
GROUP BY
	NF.ID_NF,
	TP.NUMERO_PARCELAS,
	NF.DATA_NOTA,
	TP.TIPO
----------------------------
-- INSERÇÃO DOS VALORES
IF (@num_parcela == 1) -- caso tenha apenas 1 parcela, insere normalmente
BEGIN
	INSERT INTO #TESTE_PROG_RECB(
	ID_NF, NUM_PARCELA, VAL_PARCELA, DATA_VENCIMENTO, PAGO
	)
	VALUES(
	@id_nf, @num_parcela, @val_parcela, @data_vencimento, @pago
	)
END
ELSE --caso tenha mais de uma parcela
BEGIN
	IF @tipo_pag == 'Entrada' -- caso ten ha sido feito um pagamaneto com entarda
	BEGIN
		WHILE @contador =< @num_parcela
		BEGIN
			INSERT INTO #TESTE_PROG_RECB(
			ID_NF, NUM_PARCELA, VAL_PARCELA, DATA_VENCIMENTO, PAGO
			)
			VALUES(
			@id_nf, @num_parcela + (@contador - 1), @val_parcela,
			DATEADD(MONTH, (@contador - 1), @data_vencimento), @pago
			)
			SET @contador = @contador + 1
		END
	END
	ELSE -- caso o pagamento tenha sido sem entrada
	BEGIN
		WHILE @contador =< @num_parcela
		BEGIN
			INSERT INTO #TESTE_PROG_RECB(
			ID_NF, NUM_PARCELA, VAL_PARCELA, DATA_VENCIMENTO, PAGO
			)
			VALUES(
			@id_nf, @num_parcela + (@contador), @val_parcela,
			DATEADD(MONTH, (@contador), @data_vencimento), @pago
			)
			SET @contador = @contador + 1
		END
	END
END

------------------------------------
-- CRIANDO A PROCEADURE
USE LIVRARIADB;
GO

CREATE OR ALTER PROCEDURE dbo.insere_prog_recebimento
AS
BEGIN
	DECLARE db_cursor CURSOR FOR
		SELECT 
			NF.ID_NF, 
			TP.NUMERO_PARCELAS AS NUM_PARCELA,
			CAST(SUM(NF.VALOR_NF * 1/TP.NUMERO_PARCELAS) AS DECIMAL(10,2)) AS VAL_PARCELA,
			NF.DATA_NOTA AS DATA_VENCIMENTO,
			LEFT(TP.TIPO, 7) AS TIPO_PAG -- para verificação se há ou não entrada
		FROM 
			LIVRARIADB.dbo.NOTA_FISCAL AS NF
			JOIN LIVRARIADB.dbo.TIPO_PAGAMENTO AS TP
			ON NF.ID_TIPO_PAGAMENTO = TP.ID_TIPO_PAGAMENTO
		GROUP BY
			NF.ID_NF,
			TP.NUMERO_PARCELAS,
			NF.DATA_NOTA,
			TP.TIPO

	DECLARE @contador			INT;
	DECLARE @pago				INT;
	DECLARE @id_nf				INT;
	DECLARE @num_parcela		INT;
	DECLARE @val_parcela		DECIMAL(10,2);
	DECLARE	@data_vencimento	DATE;
	DECLARE @tipo_pag			VARCHAR(25);

	SET @pago = 0;

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @id_nf, @num_parcela, 
	@val_parcela,@data_vencimento, @tipo_pag;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@num_parcela = 1) -- caso tenha apenas 1 parcela, insere normalmente
		BEGIN
			IF NOT EXISTS ( --PARTE QUE MUDEI #####
			SELECT 1 
			FROM LIVRARIADB.dbo.PROG_RECEBIMENTO
			WHERE ID_NF = @id_nf AND NUM_PARCELA = @num_parcela)
				)BEGIN
				INSERT INTO LIVRARIADB.dbo.PROG_RECEBIMENTO(
				ID_NF, NUM_PARCELA, VAL_PARCELA, DATA_VENCIMENTO, PAGO
				)
				VALUES(
				@id_nf, @num_parcela, @val_parcela, @data_vencimento, @pago
				)
				END
		END
		ELSE --caso tenha mais de uma parcela
		BEGIN
			SET @contador = 1
			IF (@tipo_pag = 'Entrada') -- caso ten ha sido feito um pagamaneto com entarda
			BEGIN
				WHILE @contador <= @num_parcela
				BEGIN
					INSERT INTO LIVRARIADB.dbo.PROG_RECEBIMENTO(
					ID_NF, NUM_PARCELA, VAL_PARCELA, DATA_VENCIMENTO, PAGO
					)
					VALUES(
					@id_nf, @contador, @val_parcela,
					DATEADD(MONTH, (@contador - 1), @data_vencimento), @pago
					)
					SET @contador = @contador + 1
				END
			END
			ELSE -- caso o pagamento tenha sido sem entrada
			BEGIN
				WHILE @contador <= @num_parcela
				BEGIN
					INSERT INTO LIVRARIADB.dbo.PROG_RECEBIMENTO(
					ID_NF, NUM_PARCELA, VAL_PARCELA, DATA_VENCIMENTO, PAGO
					)
					VALUES(
					@id_nf, @contador, @val_parcela,
					DATEADD(MONTH, (@contador), @data_vencimento), @pago
					)
					SET @contador = @contador + 1
				END
			END
		END
		----
	FETCH NEXT FROM db_cursor INTO @id_nf, @num_parcela, 
	@val_parcela,@data_vencimento, @tipo_pag;

	END
	CLOSE db_cursor;
	DEALLOCATE	db_cursor;
END

DELETE FROM PROG_RECEBIMENTO;

SELECT * FROM PROG_RECEBIMENTO;

EXEC dbo.insere_prog_recebimento;
EXEC dbo.teste_insere_pr;

SELECT * FROM #TESTE_PROG_RECB;

DELETE FROM #TESTE_PROG_RECB;