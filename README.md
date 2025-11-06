# RDB Livraria
Banco de dados relacional (RDB) de uma livraria em SQL Server

![Modelo_Conceitual](https://github.com/DougAugSilva/RDB_Livraria/blob/main/modelo_conceitual/Diagrama%20Biblioteca%20RDB.drawio.png)
> Banco de dados *LIVRARIADB*


## Sobre o projeto
Este projeto tem como objetivo desenvolver um banco de dados relacional (RDB) para uma biblioteca fictícia, utilizada como caso de estudos, em SQL Server. A criação do banco de dados foi feita desde o zero, sendo planejado os modelos teóricos, físicos e lógicos e  etc, conforme a seção *Passos do Projeto*. <br>
O banco de dados foi pensado para receber um arquivo .csv contendo informações sobre a venda de um ou mais livros, sendo necessário primeiro a passagem por banco **STAGE**, onde será realizado um tratamento inicial dos dados e preenchimento de tabelas essenciais por meio de Stored procedures, realizando assim um processo de ETL para com os dados na inserção destes no banco **LIVRARIADB**.

## Habilidades Desenvolvidas e Tecnologias Empregadas
- Planejamento de banco de dados
- SQL Server
- SQL Manegament Studio
- Criação de stored proceadures
- Tratamento e validação de dados
- Processo de ETL (extract, transform, load)

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
