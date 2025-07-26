--conserte a seguinte proceadure em sql server
USE LIVRARIADB;
GO

CREATE PROCEDURE dbo.insere_endereco_cliente_livrariadb
AS
BEGIN
--===================================================================
	-- >Inserindo enderecos dos cliente na base de dados< --
	MERGE LIVRARIADB.dbo.ENDERECOS_CLIENTES Destino
	USING (
		SELECT DISTINCT (SELECT ID_CLIENTE FROM LIVRARIADB.dbo.CLIENTE WHERE STAGE.dbo.MOVIMENTACAO_LIVROS.CPF = LIVRARIADB.dbo.CLIENTE.CPF) AS ID_CLIENTE
		--, (SELECT CEP FROM LIVRARIADB.dbo.CEP WHERE STAGE.dbo.MOVIMENTACAO_LIVROS.CEP = LIVRARIADB.dbo.CEP.CEP) AS CEP
		, CEP
		, NUMERO_ENDERECO, COMPLEMENTO, 
		(SELECT ID_TIPO_ENDERECO FROM LIVRARIADB.dbo.TIPO_ENDERECO WHERE UPPER(STAGE.dbo.MOVIMENTACAO_LIVROS.TIPO_ENDERECO) = LIVRARIADB.dbo.TIPO_ENDERECO.SIGLA) AS ID_TIPO_ENDERECO
		FROM STAGE.dbo.MOVIMENTACAO_LIVROS
	) Origem ON (Destino.ID_CLIENTE = Origem.ID_CLIENTE)

	WHEN MATCHED THEN
	UPDATE
	SET ID_CLIENTE = Origem.ID_CLIENTE,
		CEP = Origem.CEP,
		NUMERO = Origem.NUMERO_ENDERECO,
		COMPLEMENTO = Origem.COMPLEMENTO,
		ID_TIPO_ENDERECO = Origem.ID_TIPO_ENDERECO

	WHEN NOT MATCHED THEN
	INSERT (
		ID_CLIENTE,
		CEP, 
		NUMERO, 
		COMPLEMENTO,
		ID_TIPO_ENDERECO
	)
	VALUES(
		Origem.ID_CLIENTE,
		Origem.CEP,
		Origem.NUMERO_ENDERECO,
		Origem.COMPLEMENTO,
		Origem.ID_TIPO_ENDERECO
	);
END

EXEC dbo.insere_endereco_cliente_livrariadb

USE LIVRARIADB;

SELECT * FROM LIVRO_AUTOR;




--Estando ciente do seguinte erro 

--"Msg 547, Nível 16, Estado 0, Procedimento dbo.insere_endereco_cliente_livrariadb, Linha 33 [Linha de Início do Lote 66]
--A instrução MERGE conflitou com a restrição do FOREIGN KEY "FK_CEP". O conflito ocorreu no banco de dados "LIVRARIADB", tabela "dbo.CEP", column 'CEP'."