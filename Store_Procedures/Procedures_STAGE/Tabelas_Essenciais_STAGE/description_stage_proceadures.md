# Proceadures de Inserção no STAGE

Estras proceadures server para inserir os dados dos arquivos CSV sem um tratamento previo, em tabelas do banco de dados stage.

## Descrição das Tabelas

As tabelas do STAGE estão divididas em duas classes específicas:

 - **Tabelas de Validação:** Serão utilizadas para validar a entrada e tratamento dos vindos do Csv `carregamento`, para posteriormente inserir no banco de dados LIVRARIADB. Estas tabelas são:
 
    - `ATENDENTE`: Dados dos atendentes.
    - `AUTOR`: Dados dos autores dos livros.
    - `CEP`: Valores válidos de Ceps e endereços do Brasil todo.
    - `LIVRO`: Dados sobre os livros disponíveis no catálogo da livraria.
    - `TIPO_PAGAMENTO`: Dados sobre os tipos de pagamentos aceitos pela livraria.
    - `TIPO_DE_ERRO`: Tipos de erros que podem ocorrer ao tentar inserir uma nota fiscal inválida.
    - `LOJA`: Infomações sovbre a loja da franquia da livrararia.
    - `VALIDACAO`: Guardas quais notas já foram validadas e inseridas na tabela MOVIMENTACAO_LIVROS_TRATADOS.

- **Tabelas de Tratamento:** Servem para um tratamento prévios dos dados brutos que chegam do Csv `carregamento`, dados estes que depois de tratados utilizando as **tabelas de Validação** como paraãmetros, poderão ser utiliados pelas proceadures de inserção do STAGE para o LIVRARIADB. As tabelas são:

    - `MOVIMENTACAO_LIVROS`: Dados da nota fiscal do Csv **carregados** sem nenhum tratamento.
    - `MOVIMENTACAO_LIVROS_REJEITADOS`: Notas que foram rejeitadas na etapa de processamento.
    - `MOVIMENTACAO_LIVROS_TRATADOS`: Notas com dados tratados, prontos para serem utilizadas pelas proceadures de inserção.

## Lista de Proceadures

Cada proceadure realiza um `BULK INSERT` dos valores presentes no csv, o tratamento de possiveis valores será realizado nas proceadures de inserção `STAGE --> LIVRARIADB`. A linha de comando `CODEPAGE = 65001` serve para o reconhecimento dos valores como `Utf-8`, podendo ser trocada caso necessário, a depender dos tipos de dados disponiveis nos Csv's. Os comandos de execução de cada proceadure são:

- `EXEC dbo.insere_csv_movimentacao_livros_stage`: Insere o Csv com os dados das notas ficais na tabela STAGE.dbo.MOVIMENTACAO_LIVROS.

- `EXEC dbo.insere_atendente_stage`: Insere dados dos atentendes na tabela STAGE.dbo.ATENDENTE.

- `EXEC dbo.insere_autor_stage`: Insere dados dos autores na tabela STAGE.dbo.AUTOR.

- `EXEC dbo.insere_cep_stage`: Insere dados dos endereços dos clientes na tabela STAGE.dbo.CEP.

- `EXEC dbo.insere_livro_stage`: Insere dados dos livros na tabela STAGE.dbo.LIVRO.

- `EXEC dbo.insere_tipo_desconto_stage`: Insere dados na tabela STAGE.dbo.TIPO_DESCONTO.

- `EXEC dbo.insere_tipo_endereco_stage`: Insere dados na tabela STAGE.dbo.TIPO_ENDERECO.

- `EXEC dbo.insere_tipo_pagamento_stage`: Insere dados na tabela STAGE.dbo.TIPO_PAGAMENTO.

- `EXEC dbo.insere_tipos_de_erros_stage`: Insere dados na tabela STAGE.dbo.TIPOS_DE_ERROS

- `EXEC dbo.insere_loja_stage`: Insere dados com informações das lojas na tabela STAGE.dbo.LOJA.
