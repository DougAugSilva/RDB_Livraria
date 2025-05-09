USE master;
GO
-- PROCEDURE INSERE CLIENTE
-- ========================================================
IF OBJECT_ID('dbo.insere_cliente') IS NOT NULL
    DROP PROCEDURE dbo.insere_cliente;
GO

CREATE PROCEDURE dbo.insere_cliente
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE db_cursor CURSOR FOR
		SELECT	NOME_CLIENTE, CPF, EMAIL_CLIENTE, TELEFONE_CLIENTE
		FROM	STAGE.dbo.MOVIMENTACAO_LIVROS
	
	DECLARE @nome_cliente		VARCHAR(100);
	DECLARE @cpf				VARCHAR(14);
	DECLARE @email_cliente		VARCHAR(100);
	DECLARE @telefone_cliente	VARCHAR(20);

	OPEN db_cursor;
	FETCH NEXT FROM db_cursor INTO @nome_cliente, @cpf, @email_cliente, @telefone_cliente;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS (SELECT CPF FROM LIVRARIADB.dbo.CLIENTE WHERE CPF = @cpf)
		BEGIN
			INSERT INTO LIVRARIADB.dbo.CLIENTE (NOME_CLIENTE, CPF, TELEFONE, EMAIL)
			VALUES (@nome_cliente, @cpf, @telefone_cliente, @email_cliente)
		END
		FETCH NEXT FROM db_cursor INTO @nome_cliente, @cpf, @email_cliente, @telefone_cliente;
	END
	CLOSE db_cursor;
	DEALLOCATE db_cursor;
	SET NOCOUNT OFF;
END;
-- ========================================================




/*
# CRIANDO PROCEDURE

1. Lê o CPF do primeiro cliente na tabela "MOVIMENTACAO_LIVROS".
2. Verifica se o CPF deste cliente já existe na tabela "CLIENTE" do banco "LIVRARIADB".
3. Caso não exista, insere os dasdos deste usuario na tabela "CLIENTE".
4. Caso já existe passa para a próxima linha.

# DADOS DO CLIENTE TABELA "MOVIMENTACAO_LIVROS"

- NOME_CLIENTE
- TELEFONE
- CPF
- EMAIL
/*

/*
TABELAS A SEREM INSERIDOS OS VALORES

# ENDERECOS_CLIENTES
	-> MOVIMENTACAO_LIVROS.NUMERO_ENDERECO = ENDERECOS_CLIENTES.NUMERO		~verificar valores nulos
	-> MOVIMENTACAO_LIVROS.TIPO_ENDERECO = ENDERECOS_CLIENTES.TIPO_ENDERECO ~verificar valores nulos
# CEP
	-> MOVIMENTACAO_LIVROS.CEP = ENDERECOS_CLIENTES.CEP

# NOTA_FISCAL
	-> MOVIMENTACAO_LIVROS.NUMERO_NOTA_FISCAL = NOTA_FISCAL.NUMERO_NOTA_FISCAL ~verificar valores nulos
	-> MOVIMENTACAO_LIVROS.DATA_VENDA = NOTA_FISCAL.DATA_NOTA ~verificar valores nulos

# ITEM_VENDA
	-> MOVIMENTACAO_LIVROS.QUANTIDADE = ITEM_VENDA.QUANTIDADE ~verificar valores nulos

# HISTORICO_RECEBIMENTO
	-> MOVIMENTACAO_LIVROS.VALOR_RECEBIDO = HISTORICO_RECEBIMENTO.VALOR_RECEBIDO	  ~verificar valores nulos

# HISTORICO_DIVERGENTE
	-> MOVIMENTACAO_LIVROS.VALOR_TOTAL = HISTORICO_DIVERGENTE.VALOR_TOTAL				~verificar valores nulos
	-> MOVIMENTACAO_LIVROS.CONDICAO_PAGAMENTO = HISTORICO_DIVERGENTE.CONDICAO_PAGAMENTO ~verificar valores nulos
	-> MOVIMENTACAO_LIVROS.DATA_PROCESSAMENTO = HISTORICO_DIVERGENTE.DATA_PROCESSAMENTO ~verificar valores nulos

# LIVRO
	-> MOVIMENTACAO_LIVROS.TITULO = LIVRO.TITULO ~verificar valores nulos

# AUTOR
	-> MOVIMENTACAO_LIVROS.AUTOR = AUTOR.NOME ~verificar valores nulos

# LOJA 
	-> MOVIMENTACAO_LIVROS.ID_LOJA = LOJA.ID_LOJA ~verificar valores nulos

# ATENDENTE
	-> MOVIMENTACAO_LIVROS.ID_ATENDENTE = ATENDENTE.ID_ATENDENTE ~verificar valores nulos
/*