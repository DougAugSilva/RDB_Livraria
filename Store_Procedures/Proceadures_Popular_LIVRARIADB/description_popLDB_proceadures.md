# Proceadures de Povoamento do LIVRARIADB a partir do STAGE

Proceadures para inserção dos dados dos Csvs armazenados nas tabelas do STAGE nas tabelas do LIVRARIADB.

# Descricao das Proceadures

- `dbo.tratamento_dados`: Realiza o tratamento dos dados presentes na tabela MOVIMENTACAO_LIVROS, rejeitando assim valores invalido para a inserção na MOVIMENTACAO_LIVROS_REJEITADOS, especificando o motivo da rejeicao, e inserindo os valores não rejeiotados e tratados na tebala MOVIMENTACAO_LIVROS_TRATADOS. <br>
Os dados passam por quatro processos de tratamento dentro da proceadure:
    - Tratamento das strings para joins com as tabelas CODICAO_PAGAMENTO e TIPO_ENDERECO.
    - Seleção das notas fiscais ainda não processadas, rejeitando aquelas que já foram inseridas anteriormemnte, e atribuindo o código de rejeição 1.
    - Verifica e seleciona se as notas possuem datas de processamento válidas, rejeitando aquelas que possuem todos os dados iguais, exceto pela data de processamento, atribuindo o código de rejeição 2.
    - Seleção das notas com Ceps validos, segundo a tabela LIVRARIADB.dbO.CEP, aquelas com ceps são rejeitadas e atribuidas o código de erro 3.

- `dbo.carregar_validacao`: Insere na tabela validacao a o numero da nota e a data de processamento das notas fiscaias já passaram pela proceadure de tratamento dos dados, para assim evitar processar a mesma nota várias vezes.






