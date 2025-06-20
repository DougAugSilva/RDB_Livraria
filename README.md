# RDB Livraria
Banco de dados relacional (RDB) de uma livraria que permite a venda e o aluguel de livros

![Modelo_Conceitual](https://github.com/DougAugSilva/RDB_Livraria/blob/main/modelo_conceitual/RDB_Livrariamodelo_conceitual%20Diagrama%20Biblioteca%20RDB%20(modelo%203).png)

## Passos do Projeto
1. Criação dos modelos para o banco de dados *LIVRARIADB*.  
   - Modelo Teórico
   - Modelo Lógico
   - Modelo Físico

2. Instalando e configurando o *Sql Server* o *Sql Manegament Studio*.
  
3. Criação do banco de dados *LIVRARIADB* a partir do modelo físico.
  
4. Criação banco de dados *STAGE* para receber os dados .do Csv e informações de verificação antes da inserção no *LIVRARIADB*.
  
5. Criação de *Store Procedures* para a inserção dos dados no *STAGE* por meio dos Csv's.
  
6. Criação de *Store Procedures* para o tratamento dos dados para popular as tabelas essenciais de verificação no *LIVRARIADB*.

7. Criação de *Store Procedures* para inserção dos dados do Csv da nota fiscal no *LIVRARIADB*, fazendo:
   - Validação dos valores inseridos atraves das informaçoes pesentes nas tabelas essenciais do *STAGE*
   - As proceadures possuem tabelas temporarias com valores a serem dados *Insert* ou *Update*
