# Proceadures que Populam o LIVRARIADB a partir do STAGE

Procedures para inserção dos dados, provenientes dos Csvs, e que estão armazenados nas tabelas do STAGE, no banco LIVRARIADB. 

## Ordem de Execução das Proceadures

As procedures possuem uma ordem de exewcução específica, dados que algumas utilizam dados de tabelas povoadas por outras.

- `EXEC dbo.tratamento_dados; ->`
- `EXEC dbo.carregar_validacao; ->`
- `EXEC dbo.insere_cliente_livrariadb; ->`
- `EXEC dbo.insere_endereco_livrariadb; ->`
- `EXEC dbo.insere_item_venda_livrariadb; ->` -- novo
- `EXEC dbo.insere_nota_fiscal_livrariadb; ->`
- `EXEC dbo.insere_livroautor_livrariadb; ->`



## Descricao das Procedures

Dividi as proceadures em dois grupos principais, o primeiro grupo, denominado de **Tratamento**, é para realizar o tratamento e validação dos dados a serem utilizados pelas demias proceadures. O segundo grupo recebe o nome de **Inserção**, sendo este que insere os valores de fato nas tabelas do LIVRARIADB, ou atualiza os valores já existentes, caso ocorra alguma mudança em algum dos valores.

### Tratamento

- `dbo.tratamento_dados`: Realiza o tratamento dos dados presentes na tabela MOVIMENTACAO_LIVROS, rejeitando assim valores invalido para a inserção na MOVIMENTACAO_LIVROS_REJEITADOS, especificando o motivo da rejeicao, e inserindo os valores não rejeiotados e tratados na tebala MOVIMENTACAO_LIVROS_TRATADOS. <br>
Os dados passam por quatro processos de tratamento dentro da procedure:
    - Tratamento das strings para joins com as tabelas CODICAO_PAGAMENTO e TIPO_ENDERECO.
    - Seleção das notas fiscais ainda não processadas, rejeitando aquelas que já foram inseridas anteriormemnte, e atribuindo o código de rejeição 1.
    - Verifica e seleciona se as notas possuem datas de processamento válidas, rejeitando aquelas que possuem todos os dados iguais, exceto pela data de processamento, atribuindo o código de rejeição 2.
    - Seleção das notas com Ceps validos, segundo a tabela LIVRARIADB.dbO.CEP, aquelas com ceps são rejeitadas e atribuidas o código de erro 3.

- `dbo.carregar_validacao`: Insere na tabela STAGE.dbo.VALIDACAO a o numero da nota e a data de processamento das notas fiscaias já passaram pela procedure de tratamento dos dados, para assim evitar processar a mesma nota várias vezes.

### Inserção

- `dbo.insere_cliente_livrariadb`: Insere os dados dos clientes provindos das notas fiscais armazenadas no STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS. Esta deve ser a primeira proceadure das de inserção a ser executada, dado que as demais dependem dos dados dos clientes na tabela LIVRARIADB.dbo.CLIENTE.

- `dbo.insere_endereco_livrariadb`: Insere ou atualiza as informações dos endereços dos clientes, utilizando os valores da tabela STAGE.dbo.MOVIMENTACAO_LIVROS_TRATADOS para inserção na LIVRARIADB.dbo.ENDERECOS_CLIENTES. 

- `dbo.insere_nota_fiscal`: Insere dados das notas fiscais na tabela LIVRARIADB.dbo.NOTAS_FISCAIS.

- `dbo.insere_livroautor_livrariadb`: Insere os id's dos livros e autores, presentas nas tabelas LIVRARIADB.dbo.LIVRO e LIVRARIADB.dbo.AUTOR, criando assim uma tabela intermediaria que facilita Joins e consultas posteriores.