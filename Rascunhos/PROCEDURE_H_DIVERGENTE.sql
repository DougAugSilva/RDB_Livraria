USE LIVRARIADB;

SELECT * FROM HISTORICO_DIVERGENTE;
SELECT * FROM HISTORICO_RECEBIMENTO;

SELECT * FROM PROG_RECEBIMENTO;
SELECT * FROM TIPO_DESCONTO;
-----------------------
SELECT
	-- dados para a inserção
	HR.ID_PROG_RECEBIMENTO,
	HR.ID_TIPO_DESCONTO,
	HR.DATA_RECEBIMENTO,
	PR.DATA_VENCIMENTO,
	HR.VALOR_RECEBIDO,
	PR.VAL_PARCELA,
	-- dados para calculos
	--PR.DATA_VENCIMENTO,
	TD.TIPO,
	DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) AS DIAS_CORRIDOS,
	CASE
		-- Caso esteje tudo certo com o desconto aplicado
		WHEN
			--verifica se a porcentagem do  desconto condiz com os dias
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) >= TD.MINIMO_DIA
			AND
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MAXIMO_DIA
			-- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
			AND
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) <= 0
			AND
			TD.TIPO = 1
		THEN 'Desconto bem aplicado'

		-- Caso esteja tudo certo com a multa aplicada
		WHEN
			--verifica se a porcentagem do  desconto condiz com os dias
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) >= TD.MINIMO_DIA
			AND
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MAXIMO_DIA
			-- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
			AND
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) > 0
			AND
			TD.TIPO = 0
		THEN 'Multa bem aplicada'

		-- Caso aplique multa onde devia ser desconto
		WHEN
			--verifica se a porcentagem do  desconto condiz com os dias
			--DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) >= TD.MINIMO_DIA
			--AND
			--DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MAXIMO_DIA
			-- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
			--AND
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) <= 0 -- deve ser desconto
			AND
			TD.TIPO = 0 -- mas é multa
		THEN 'Aplicou multa onde deveria ser desconto'

		-- Caso aplique desconto onde devia ser multa
		WHEN
			--verifica se a porcentagem do  desconto condiz com os dias
			--DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) >= TD.MINIMO_DIA
			--AND
			--DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MAXIMO_DIA
			-- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
			--AND
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) > 0 -- deve ser multa
			AND
			TD.TIPO = 1 -- mas é desconto
		THEN 'Aplicou desconto onde deveria ser multa'

		-- Caso aplique uma multa de valor indevido
		WHEN
			-- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) > 0 -- deve ser multa
			AND
			TD.TIPO = 0 -- é multa
			AND
			--verifica se a porcentagem do  desconto condiz com os dias
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MINIMO_DIA
			OR
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) >= TD.MAXIMO_DIA
		THEN 'Valor da multa indevido'

		-- Caso aplique um desconto de valor indevido
		WHEN
			-- verifica se a a atribuição do TIPO está correta (se é multa ou desconto)
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) <= 0 -- deve ser desconto
			AND
			TD.TIPO = 1 -- é desconto
			AND
			--verifica se a porcentagem do  desconto condiz com os dias
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) < TD.MINIMO_DIA
			OR
			DATEDIFF(DAY, PR.DATA_VENCIMENTO, HR.DATA_RECEBIMENTO) >= TD.MAXIMO_DIA
		THEN 'Valor do desconto indevido'
	END VALIDA_DECONTOS_E_MULTAS
FROM 
	HISTORICO_RECEBIMENTO AS HR
JOIN 
	TIPO_DESCONTO AS TD
	ON TD.ID_TIPO_DESCONTO = HR.ID_TIPO_DESCONTO
JOIN 
	PROG_RECEBIMENTO AS PR
	ON PR.ID_PROG_RECEBIMENTO = HR.ID_PROG_RECEBIMENTO

-- Tipo = 1 : Desconto
-- Tipo = 0 : Multa

-- Planejando a QUery
-- 1: Verificar se é multa ou desconto, e se a atribuição do desconto/multa está no tipo certo
	--> Caso sim, ignora
	--> Caso não, e se for uma multa onde era desconto, seta MOTIVO = "Aplicou multa onde era desconto" 
	--> Caso não, e se for desconto onde era pra ser multa, seta MOTIVO = "Aplicou desconto onde era para ser multa"
-- 2: Verifica se a porcentagem do desconrto está correta, segundo o intervalo de dias
	--> Caso não, 