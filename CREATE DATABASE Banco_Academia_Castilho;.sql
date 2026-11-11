
CREATE DATABASE Banco_Academia_Castilho; -- Criar banco de dados
GO

USE Banco_Academia_Castilho; -- Selecionar o banco de dados
GO

SELECT name
FROM sys.databases
ORDER BY name;

-- Comando para listar o banco de dados atual
SELECT DB_NAME() AS BancoAtual;

-- Criando tabela Professores
CREATE TABLE Professores (
    IdProfessor INT PRIMARY KEY IDENTITY(1,1), -- Identificador único de professor
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(200) NOT NULL UNIQUE, -- UNIQUE para não permitir emails duplicados
    Especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE Cursos (
    IdCurso INT PRIMARY KEY IDENTITY(1,1), -- IDENTITY para incrementar o IdCurso
    NomeCurso VARCHAR(100) NOT NULL UNIQUE, -- UNIQUE para não permitir cursos duplicados
    CargaHoraria INT NOT NULL CHECK (CargaHoraria > 0 AND CargaHoraria <= 200),
    IdProfessor INT NOT NULL,
    Ativo BIT NOT NULL DEFAULT 1, -- Valor padrão: 1 (ativo)

    CONSTRAINT FK_Cursos_Professores
        FOREIGN KEY (IdProfessor) REFERENCES Professores(IdProfessor)
);

CREATE TABLE Alunos (
    IdAluno INT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Turma VARCHAR(50) NOT NULL,
    DataNascimento DATE NOT NULL,
    Ativo BIT NOT NULL CONSTRAINT DF_Alunos_Ativo DEFAULT 1
);

CREATE TABLE Matricula (
    IdMatricula INT PRIMARY KEY IDENTITY(1,1),
    IdAluno INT NOT NULL,
    IdCurso INT NOT NULL,
    DataMatricula DATE NOT NULL DEFAULT GETDATE(), -- Data atual como valor padrão
    NotaFinal DECIMAL(4,2) NULL CHECK (NotaFinal BETWEEN 0 AND 10),
    StatusMatricula VARCHAR(20) NOT NULL
        CONSTRAINT DF_Matricula_Status DEFAULT 'Ativa',

    -- Impede que um aluno se matricule no mesmo curso mais de uma vez
    CONSTRAINT UQ_Matricula_AlunoCurso UNIQUE (IdAluno, IdCurso),

    CONSTRAINT FK_Matricula_Aluno
        FOREIGN KEY (IdAluno) REFERENCES Alunos(IdAluno),

    CONSTRAINT FK_Matricula_Cursos
        FOREIGN KEY (IdCurso) REFERENCES Cursos(IdCurso)
);

SELECT * FROM Professores; -- Listar todos os professores cadastrados
SELECT * FROM Cursos; -- Listar todos os cursos cadastrados
SELECT * FROM Alunos; -- Listar todos os alunos cadastrados
SELECT * FROM Matricula;

-- Visualiza todas as tabelas do banco de dados
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

INSERT INTO Professores (Nome, Email, Especialidade)
VALUES
('Ana Martins',    'ana.martins@academia.com',    'Banco de Dados'),
('Carlos Ribeiro', 'carlos.ribeiro@academia.com', 'Programação'),
('Fernanda Lima',  'fernanda.lima@academia.com',  'Desenvolvimento Web'),
('Rafael Souza',   'rafael.souza@academia.com',   'Redes de Computadores');

INSERT INTO Cursos (NomeCurso, CargaHoraria, IdProfessor)
VALUES
('Banco de Dados Inicial', 40, 1),
('SQL Server Essencial',   36, 1),
('Lógica de Programação',  40, 2),
('JavaScript para Jovens', 32, 2),
('HTML e CSS',             30, 3),
('Fundamentos de Redes',   24, 4);

INSERT INTO Alunos (Nome, Email, Turma, DataNascimento)
VALUES
('Alice Pereira',  'alice.pereira@escola.com',  '2INFO-A', '2008-03-14'),
('Bruno Alves',    'bruno.alves@escola.com',    '2INFO-A', '2008-07-22'),
('Camila Rocha',   'camila.rocha@escola.com',   '2INFO-A', '2008-01-30'),
('Diego Santos',   'diego.santos@escola.com',   '2INFO-B', '2007-11-09'),
('Elisa Nunes',    'elisa.nunes@escola.com',    '2INFO-B', '2008-05-18'),
('Felipe Costa',   'felipe.costa@escola.com',   '2INFO-B', '2008-09-02'),
('Gabriela Melo',  'gabriela.melo@escola.com',  '2INFO-C', '2007-12-12'),
('Henrique Luz',   'henrique.luz@escola.com',   '2INFO-C', '2008-06-28'),
('Isabela Torres', 'isabela.torres@escola.com', '2INFO-C', '2008-02-06'),
('João Mendes',    'joao.mendes@escola.com',    '2INFO-C', '2007-08-25');

INSERT INTO Matricula (IdAluno, IdCurso, DataMatricula, NotaFinal, StatusMatricula)
VALUES
(1, 1, '2026-02-03', 8.50, 'Concluída'),
(1, 5, '2026-02-03', 9.00, 'Concluída'),
(2, 1, '2026-02-03', 7.00, 'Concluída'),
(2, 3, '2026-02-04', 8.00, 'Ativa'),
(3, 2, '2026-02-04', 9.50, 'Concluída'),
(3, 4, '2026-02-04', NULL, 'Ativa'),
(4, 3, '2026-02-05', 6.50, 'Concluída'),
(5, 5, '2026-02-05', 8.50, 'Concluída'),
(6, 6, '2026-02-06', NULL, 'Ativa'),
(7, 1, '2026-02-06', 7.50, 'Concluída'),
(8, 2, '2026-02-07', 10.00, 'Concluída'),
(8, 6, '2026-02-07', 8.00, 'Concluída'),
(9, 4, '2026-02-08', NULL, 'Ativa'),
(9, 5, '2026-02-08', 9.00, 'Concluída'),
(10, 3, '2026-02-09', 7.00, 'Concluída'),
(10, 2, '2026-02-09', NULL, 'Ativa');

SELECT * FROM Professores;
SELECT * FROM Cursos;
SELECT * FROM Alunos;
SELECT * FROM Matricula;

-- Selecionar somente colunas específicas na tabela Professores
SELECT Nome FROM Professores;

-- Apelidos para deixar os títulos mais claros nas respostas
SELECT Nome AS NomeDoAluno, Turma AS Sala FROM Alunos;

SELECT Nome, Turma
FROM Alunos
ORDER BY Nome ASC; -- ASC: ordem crescente; DESC: ordem decrescente

-- Os 5 primeiros alunos em ordem alfabética
SELECT TOP 5 Nome, Turma, DataNascimento
FROM Alunos
ORDER BY Nome;

SELECT * FROM Alunos;

-- Filtros com WHERE
-- Seleciona os nomes e turmas dos alunos cuja turma seja igual a '2INFO-A'

-- IGUAL A
SELECT Nome, Turma
FROM Alunos
WHERE Turma = '2INFO-A';

-- DIFERENTE DE
SELECT Nome, Turma
FROM Alunos
WHERE Turma <> '2INFO-A'; -- Seleciona alunos de turmas diferentes de '2INFO-A'

-- AND: as duas condições devem ser verdadeiras
SELECT Nome, Turma, DataNascimento
FROM Alunos
WHERE Turma <> '2INFO-A' AND DataNascimento > '2008-01-01';

-- Seleciona alunos de turmas diferentes de '2INFO-A'
-- e com data de nascimento posterior a '2008-01-01'

-- IN: versão mais curta para vários valores
SELECT Nome, Turma
FROM Alunos
WHERE Turma IN ('2INFO-A', '2INFO-B');

-- Seleciona alunos da turma '2INFO-A' ou '2INFO-B'

-- LIKE: % significa qualquer quantidade de caracteres
-- e _ significa um único caractere
SELECT Nome, Email
FROM Alunos
WHERE Email LIKE '%@escola.com';

-- Seleciona alunos cujo email termina com '@escola.com'

UPDATE Alunos
SET Turma = '2INFO-B'
WHERE IdAluno = 3; -- Altera a turma do aluno com IdAluno igual a 3 para '2INFO-B'

SELECT * FROM Alunos;

-- REGISTRAR UMA NOTA E ENCERRAR A MATRICULA DO ALUNO 2 NO CURSO 3
UPDATE Matricula
SET NotaFinal = 8.75, StatusMatricula = 'Concluída'
WHERE IdAluno = 2 AND IdCurso = 3;

-- Altera a nota final e o status da matricula do aluno com IdAluno igual a 2 e IdCurso igual a 3

SELECT * FROM Alunos;
SELECT * FROM Matricula;

-- CONFERIR A ALTERACAO DA MATRICULA DO ALUNO 2 NO CURSO 3
SELECT * FROM Matricula
WHERE IdAluno = 2 AND IdCurso = 3;

-- ATUALIZANDO OS ALUNOS DA TURMA 2INFO-B
UPDATE Alunos
SET Ativo = 0
WHERE Turma = '2INFO-B';

-- Altera o status de ativo para 0 (inativo) para todos os alunos da turma '2INFO-B'

SELECT * FROM Alunos;

UPDATE Alunos
SET Ativo = 1
WHERE Turma = '2INFO-B';

INSERT INTO Alunos (Nome, Email, Turma, DataNascimento)
VALUES ('Alunos de Teste', 'teste.remover@escola.com', '2INFO-B', '2008-01-01');

SELECT * FROM Alunos
WHERE Email = 'teste.remover@escola.com';

SELECT * FROM Alunos
WHERE Email = 'teste.remover@escola.com';

SELECT * FROM Alunos;

DELETE FROM Alunos
WHERE Email = 'teste.remover@escola.com';

SELECT * FROM Alunos
WHERE Email = 'teste.remover@escola.com';

-- FUNÇÕES DE TEXTO E DATA
SELECT
    Nome,
    UPPER(Nome) AS NomeEmMaiusculo, -- Converte o nome para maiusculo
    LOWER(Nome) AS NomeEmMinusculo, -- Deixa minusculo
    LEN(Nome) AS QuantidadeDeCaracteres,
    CONCAT(Nome, ' - ', Turma) AS NomeETurma,
    FORMAT(DataNascimento, 'dd/MM/yyyy') AS DataNascimentoFormatada,
    DATEDIFF(YEAR, DataNascimento, GETDATE()) AS IdadeAproximada
FROM Alunos;

-- FUNCOES DE CALCULO E AGRUPAMENTO

-- QUANTIDADE DE ALUNOS CADASTRADOS
SELECT COUNT(*) AS QuantidadeDeAlunos
FROM Alunos;

-- QUANTIDADE DE MATRICULAS QUE JA POSSUEM NOTA FINAL
SELECT COUNT(NotaFinal) AS QuantidadeDeMatriculasComNota
FROM Matricula;

-- MÉDIA, MAIOR E MENOR NOTA; OBS: DADOS NULOS (NULL) NAO SAO CONSIDERADOS NOS CALCULOS
SELECT
    AVG(NotaFinal) AS MediaDasNotas,
    MAX(NotaFinal) AS MaiorNota,
    MIN(NotaFinal) AS MenorNota
FROM Matricula;

-- Troca NULL POR UM TEXTO PARA EXIBIR O RESULTADO DE FORMA MAIS CLARA
SELECT
    IdMatricula,
    ISNULL(CONVERT(VARCHAR(10), NotaFinal), 'Sem Nota') AS NotaFinal,
    StatusMatricula
FROM Matricula;

-- GROUP BY E HAVING: AGRUPA OS REGISTROS POR UMA OU MAIS COLUNAS E PERMITE FILTRAR OS GRUPOS COM BASE EM UMA CONDIÇAO

-- QUANTOS ALUNOS ESTAO MATRICULADOS EM CADA TURMA
SELECT Turma, COUNT(*) AS QuantidadeDeAlunos
FROM Alunos
GROUP BY Turma
ORDER BY QuantidadeDeAlunos DESC;

-- CURSOS QUE TEM DUAS OU MAIS MATRICULAS
SELECT IdCurso, COUNT(*) AS QuantidadeDeMatriculas
FROM Matricula
GROUP BY IdCurso
HAVING COUNT(*) >= 2
ORDER BY QuantidadeDeMatriculas DESC;

-- RELACIONANDO TABELAS COM JOIN: COMBINAR REGISTROS DE DUAS OU MAIS TABELAS COM BASE EM UMA CONDIÇAO DE CORRESPONDENCIA
SELECT
    a.Nome AS NomeDoAluno,
    c.NomeCurso AS NomeDoCurso,
    m.NotaFinal,
    m.StatusMatricula
FROM Matricula AS m
INNER JOIN Alunos AS a
    ON m.IdAluno = a.IdAluno
INNER JOIN Cursos AS c
    ON m.IdCurso = c.IdCurso
ORDER BY a.Nome;

-- JOIN COM 4 TABELAS
SELECT
    a.Nome AS Aluno,
    a.Turma,
    c.NomeCurso,
    p.Nome AS Professor,
    m.NotaFinal,
    m.StatusMatricula
FROM Matricula AS m
INNER JOIN Alunos AS a
    ON m.IdAluno = a.IdAluno
INNER JOIN Cursos AS c
    ON m.IdCurso = c.IdCurso
INNER JOIN Professores AS p
    ON c.IdProfessor = p.IdProfessor
ORDER BY p.Nome, c.NomeCurso, a.Nome;

-- LEFT JOIN: Retorna todos os registros da tabela à esquerda e os registros correspondentes da tabela à direita.
-- Se não houver correspondência, os valores da tabela à direita serão nulos.
SELECT
    a.Nome AS NomeDoAluno,
    c.NomeCurso AS NomeDoCurso,
    m.NotaFinal,
    m.StatusMatricula
FROM Alunos AS a
LEFT JOIN Matricula AS m
    ON a.IdAluno = m.IdAluno -- Relaciona a tabela Alunos com a tabela Matricula
LEFT JOIN Cursos AS c
    ON m.IdCurso = c.IdCurso -- Relaciona a tabela Matricula com a tabela Cursos
WHERE m.IdMatricula IS NULL; -- Filtra os alunos que não possuem matrícula

-- SE A CONSULTA NÃO RETORNAR LINHAS, SIGNIFICA QUE TODOS OS ALUNOS POSSUEM PELO MENOS UMA MATRÍCULA


SELECT
c.NomeCurso AS Curso,
COUNT(m.IdMatricula) AS TotlaDeMatriculas,
AVG(m.NotaFinal) AS mediaDoCurso
FROM Cursos AS C
LEFT JOIN Matriculas AS m
ON c.IdCurso = m.IdCurso
WHERE m.NotaFinal IS NOT NULL
GRUOP BY c.NomeCurso
ORDER BY c.NomeCurso;


INSERT INTO Alunos (Nome, Email, Turma)
VALUES ('Outra Alice', 'alice.perereira@escola.com', '2INFO-1');

-- Erro: Não existe aluno de ID 999
INSERT INTO Matriculas (IdAluno, IdCurso, NotaFinal)
values (999, 1, 8.00);

--ERRO: a nota não pode ser maior que 10

UPDATE Matriculas
SET NotaFinal = 12.00
WHERE IdMatricula = 1;