USE PROJETO_FINANCEIRO;
GO
create or alter procedure insert_endereco_cliente as
begin tran
    DECLARE insert_endereco_cliente CURSOR FOR
    SELECT C.ID_CLIENTE, 
    E.ID_TIPO_ENDERECO, 
    V.CEP,
    V.NUM_ENDERECO,
    V.COMPLEMENTO
    FROM STAGE.DBO.TRATAMENTO_VENDAS_FINAL_CLIENTE as V
    JOIN PROJETO_FINANCEIRO.DBO.CLIENTES as C ON V.CNPJ_CLIENTE = C.CNPJ
    JOIN PROJETO_FINANCEIRO.DBO.TIPO_ENDERECO as E ON E.DESCRICAO = V.TIPO_ENDERECO

    open insert_endereco_cliente

    declare 
    @ID_CLIENTE INT,
    @ID_TIPO_ENDERECO INT,
    @CEP CHAR(100),
    @NUM_ENDERECO INT,
    @COMPLEMENTO CHAR(100);

    fetch next from insert_endereco_cliente
    into @ID_CLIENTE, @ID_TIPO_ENDERECO, @CEP, @NUM_ENDERECO, @COMPLEMENTO


    while @@FETCH_STATUS like 0

    begin
        begin tran

        if CONCAT(@ID_CLIENTE,' + ',@CEP) not in (select CONCAT(ID_CLIENTE,' + ', CEP) from PROJETO_FINANCEIRO.DBO.ENDERECOS_CLIENTES)
        begin
            INSERT INTO PROJETO_FINANCEIRO.DBO.ENDERECOS_CLIENTES 
            (ID_CLIENTE, ID_TIPO_ENDERECO, CEP, NUMERO, COMPLEMENTO)
            VALUES(@ID_CLIENTE, @ID_TIPO_ENDERECO, @CEP, @NUM_ENDERECO, @COMPLEMENTO)
        end
        ELSE
        begin
            UPDATE PROJETO_FINANCEIRO.DBO.ENDERECOS_CLIENTES 
            set ID_TIPO_ENDERECO = @ID_TIPO_ENDERECO,
            NUMERO = @NUM_ENDERECO,
            COMPLEMENTO = @COMPLEMENTO
            where @ID_CLIENTE = ID_CLIENTE and @CEP = CEP
        end

        fetch next from insert_endereco_cliente
        into @ID_CLIENTE, @ID_TIPO_ENDERECO, @CEP, @NUM_ENDERECO, @COMPLEMENTO
    commit
    end
    close insert_endereco_cliente
    deallocate insert_endereco_cliente
commit