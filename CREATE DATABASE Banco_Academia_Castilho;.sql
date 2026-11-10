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