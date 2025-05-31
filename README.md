# RDB Livraria
Banco de dados relacional (RDB) de uma livraria que permite a venda e o aluguel de livros

![Modelo_Conceitual](https://github.com/DougAugSilva/RDB_BIBLIOTECA/blob/main/modelo_conceitual/Diagrama%20Biblioteca%20RDB.png)

## Passos do Projeto
1. Criação dos modelos para o banco de dados *LIVRARIADB*
   - Modelo Teórico
   - Modelo Lógico
   - Modelo Físico
     
2. Criação do código no Sql Server para a implementação do banco de Dados *LIVRARIADB*
   - Instalando e configurando o *Sql Server* o *Sql Manegament Studio*
     
3. Cração banco de dados *STAGE* para receber CSV com os dados
   
4. Criação do código sql para inserir dados do CSV na tabela *MOVIMENTACAO_LIVROS* do banco de dados *STAGE*
   - Habilitando permições para a leitura da pasta com os dados dop Csv pelo *Sql Manegament Studio*
     
5. Criação de *Proceadures* para a inserção dos dados da tabela *MOVIMENTACAO_LIVROS* do banco de dados *STAGE* nas tabelas do banco de dados *LIVRARIADB*
