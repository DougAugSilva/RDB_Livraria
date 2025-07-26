USE STAGE;
GO

SELECT * FROM MOVIMENTACAO_LIVROS

SELECT UPPER(EMAIL_CLIENTE) FROM MOVIMENTACAO_LIVROS

-- OBS: o tratamento pode ser feito dentro do cursos
-- sera utilizada um tabela "movimentação dados tratados" somente com os dados limpos e tratados
-- essa tabela sera utilizada para inserir na validação e na LIVRARIADB
-- a validação sera feita no insert into, as que não podem ser nulos eu rejeito 

-- PROCESSO
-- chegam os dados bruitos em movimentacao
-- uso uma proceadure para rejeitar os dados incorretes
-- uso uma proceadure opara um tratamento (dentro do select do insert)
-- uso uma proceadure para inserir na validação (essa aqui)
-- depois eu carrego em LIVRARIADB