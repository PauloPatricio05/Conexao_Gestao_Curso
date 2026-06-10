
-- Cadastro de pessoas
INSERT INTO pessoa (cpf, nome, data_nascimento, nivel_escolaridade) VALUES
-- Alunos
('111.111.111-11', 'Paulo Patrício', '2004-05-15', 'Ensino Médio completo'),
('222.222.222-22', 'Adriel Silva', '2003-08-20', 'Ensino Médio completo'),
('333.333.333-33', 'Carlos Godoy', '2004-02-10', 'Ensino Médio completo'),
('444.444.444-44', 'Isaque Souza', '2005-01-30', 'Ensino Médio completo'),
('555.555.555-55', 'Cecilia Andrade', '2004-11-12', 'Ensino Médio completo'),
-- Professores
('666.666.666-66', 'Dr. Carlos Jonson', '1980-03-25', 'Doutorado'),
('777.777.777-77', 'Dra. Maria Jonsoum', '1985-07-14', 'Doutorado'),
('888.888.888-88', 'Me. Gisele Jonsoza', '1988-09-02', 'Mestrado'),
('999.999.999-99', 'Dra. Pedra Jonsinha', '1982-12-05', 'Doutorado'),
('000.000.000-00', 'Me. Jonsons Baby', '1990-06-18', 'Mestrado');


-- Cadastro dos cursos
INSERT INTO curso (codigo_curso, nome_curso, descricao, modalidade) VALUES
(1, 'Licenciatura em Computação', 'Formação de educadores para o ensino de tecnologia e informática.', 'Presencial'),
(2, 'Engenharia de Software', 'Foco em arquitetura, construção e manutenção de grandes sistemas.', 'Presencial'),
(3, 'Pedagogia', 'Formação de professores para educação infantil e gestão escolar.', 'Presencial');



-- Alunos vinculados aos seus respectivos cursos
INSERT INTO aluno (matricula, cpf_pessoa, codigo_curso) VALUES
(202601, '111.111.111-11', 1), 
(202602, '222.222.222-22', 1), 
(202603, '333.333.333-33', 2),
(202604, '444.444.444-44', 2),
(202605, '555.555.555-55', 3);

-- Professores
INSERT INTO professor (matricula_professor, cpf_pessoa) VALUES
(9001, '666.666.666-66'),
(9002, '777.777.777-77'),
(9003, '888.888.888-88'),
(9004, '999.999.999-99'),
(9005, '000.000.000-00');

-- Escolaridade (Vinculada aos Professores conforme o seu modelo)
INSERT INTO escolaridade (matricula, cpf_pessoa) VALUES
(3001, '666.666.666-66'),
(3002, '777.777.777-77'),
(3003, '888.888.888-88'),
(3004, '999.999.999-99'),
(3005, '000.000.000-00');


-- Cadastro de disciplinas que foram 5

INSERT INTO disciplina (codigo, codigo_curso, nome, carga_horaria, tipo_disciplina, periodo) VALUES
(101, 1, 'Algoritmos e Estruturas de Dados', 80, 'Obrigatória', 1),
(102, 1, 'Redes de Computadores', 60, 'Obrigatória', 2),
(103, 1, 'Informática ', 60, 'Obrigatória', 3),
(104, 2, 'Arquitetura de Software', 80, 'Obrigatória', 3),
(105, 3, 'Psicologia do Desenvolvimento', 60, 'Obrigatória', 1);


-- Cadastro das turmas e os Pré-requisitos 
-- Pré-requisito: Para fazer Arquitetura (104), precisa ter feito Algoritmos (101)
INSERT INTO pre_requisito (codigo_disciplina, codigo_disciplina_requisito) VALUES
(104, 101);

-- Turmas
INSERT INTO turma (codigo_turma, periodo, sala, codigo_curso) VALUES
(10, 'Matutino', 'Sala 101 - Bloco A', 1),
(20, 'Noturno', 'Lab de Redes', 1),
(30, 'Vespertino', 'Sala 205 - Bloco B', 2),
(40, 'Matutino', 'Sala 302', 3);

-- Oferta das Disciplinas
INSERT INTO oferta_disciplina (codigo_turma, codigo_disciplina, semestre, ano) VALUES
(10, 101, 1, 2026),
(20, 102, 1, 2026),
(10, 103, 1, 2026),
(30, 104, 1, 2026),
(40, 105, 1, 2026);


-- RELACIONAMENTOS

-- Um mesmo professor lecionando mais de uma disciplina:
-- Dr. Carlos Jhonson (9001) vai dar Algoritmos (101) e Informática     (103)
INSERT INTO professor_disciplina (matricula_professor, codigo_disciplina) VALUES
(9001, 101),
(9001, 103),
(9002, 102),
(9003, 104),
(9004, 105);

-- Alunos matriculados nas Disciplinas
INSERT INTO aluno_disciplina (matricula_aluno, codigo_disciplina) VALUES
(202601, 101), -- Paulo
(202601, 103), -- Paulo
(202602, 101), -- Adriel
(202603, 104), -- Godoy
(202604, 104), -- Isaque
(202605, 105); -- Cecilia

-- Alunos nas Turmas
INSERT INTO aluno_turma (matricula_aluno, codigo_turma) VALUES
(202601, 10),
(202602, 10),
(202603, 30),
(202604, 30),
(202605, 40);

-- Professores nas Turmas
INSERT INTO professor_turma (matricula_professor, codigo_turma) VALUES
(9001, 10),
(9002, 20),
(9003, 30),
(9004, 40);


-- Historico Escolar

INSERT INTO historico (matricula_aluno, codigo_disciplina, nota, situacao, semestre, ano) VALUES
(202601, 101, 9.5, 'Aprovado', 1, 2025), -- Paulo Aprovado
(202602, 101, 8.2, 'Aprovado', 1, 2025), -- Adriel Aprovado
(202605, 105, 9.0, 'Aprovado', 1, 2025), -- Cecilia Aprovada
-- Os 2 Reprovados pedidos no cenário:
(202603, 104, 4.0, 'Reprovado', 1, 2025), -- Godoy Reprovado
(202604, 104, 5.5, 'Reprovado', 1, 2025); -- Isaque Reprovado


-- Atributos multivalorados

INSERT INTO email_pessoa (cpf_pessoa, email) VALUES
('111.111.111-11', 'paulo@faculdade.edu'),
('222.222.222-22', 'adriel@faculdade.edu'),
('333.333.333-33', 'godoy@faculdade.edu'),
('444.444.444-44', 'isaque@faculdade.edu'),
('555.555.555-55', 'cecilia@faculdade.edu');

INSERT INTO telefone_pessoa (cpf_pessoa, telefone) VALUES
('111.111.111-11', '(81) 98888-0001'),
('222.222.222-22', '(81) 98888-0002'),
('333.333.333-33', '(81) 98888-0003'),
('444.444.444-44', '(81) 98888-0004'),
('555.555.555-55', '(81) 98888-0005');

INSERT INTO endereco_pessoa (cpf_pessoa, endereco) VALUES
('111.111.111-11', 'Rua Principal, 100'),
('222.222.222-22', 'Rua da Faculdade, 250'),
('333.333.333-33', 'Av. das Tecnologias, 404'),
('444.444.444-44', 'Alameda dos Códigos, 12'),
('555.555.555-55', 'Rua dos Professores, 88');