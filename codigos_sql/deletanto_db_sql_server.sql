USE master;
GO
ALTER DATABASE LivrariaDB
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE LivrariaDB;

-- Este comando deleta o banco de dados a qualquer custo, no slql maneger studio.

-- criar banco e tabelas
-- insert tabelas essenciais
-- ler CSV e carregar stages
-- livraria DB ler stages e carregar procidures
--nome tabela e colunas em caixa alta
