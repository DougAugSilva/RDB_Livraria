# Proceadures de Inserção no STAGE

Estras proceadures server para inserir os dados dos aqrquivos CSV sem um tratamento previo, em tabelas do banco de dados stage. As tabelas do STAGE estão divididas em duas classes específicas:

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