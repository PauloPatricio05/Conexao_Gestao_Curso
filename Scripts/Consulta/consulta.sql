#ÁREA DE CONSULTA
-- Lista todas as pessoas cadastradas no sistema
SELECT * 
FROM pessoa;

-- Lista todos os alunos cadastrados
SELECT * 
FROM aluno;

-- Lista todos os professores cadastrados
SELECT * 
FROM professor;

-- Lista todos os cursos cadastrados
SELECT * 
FROM curso;

-- Lista todas as disciplinas cadastradas
SELECT * 
FROM disciplina;

-- Lista todas as turmas cadastradas
SELECT * 
FROM turma;

-- Lista todo o histórico escolar dos alunos
SELECT * 
FROM historico;

-- Busca uma pessoa específica pelo CPF
SELECT * 
FROM pessoa 
WHERE cpf = '111.111.111-11';

-- Busca um aluno específico pela matrícula
SELECT *
FROM aluno
WHERE matricula = 202601;

-- Busca um professor específico pela matrícula
SELECT *
FROM professor 
WHERE matricula_professor = 9001;

-- Lista todas as pessoas que possuem Doutorado
SELECT *
FROM pessoa
WHERE nivel_escolaridade = 'Doutorado';

-- Lista todos os alunos matriculados no curso de código 2
SELECT *
FROM aluno
WHERE codigo_curso = 2;
-- Disciplinas de um determinado período
SELECT *
FROM disciplina
WHERE periodo = 1;

-- Turmas de um curso específico
SELECT *
FROM turma
WHERE codigo_curso = 1;

-- Históricos com nota maior que 7
SELECT *
FROM historico
WHERE nota > 7;

-- Históricos reprovados
SELECT *
FROM historico
WHERE situacao = 'Reprovado';

-- Disciplinas obrigatórias
SELECT *
FROM disciplina
WHERE tipo_disciplina = 'Obrigatória';

-- Disciplinas optativas
SELECT *
FROM disciplina
WHERE tipo_disciplina = 'Optativa';

-- Lista o nome de cada aluno junto com sua matrícula
SELECT p.nome, a.matricula
FROM pessoa p
INNER JOIN aluno a ON a.cpf_pessoa = p.cpf;

-- Lista o nome do aluno, sua matrícula e o curso em que está matriculado
SELECT p.nome, a.matricula, c.nome_curso
FROM aluno a
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN curso c ON a.codigo_curso = c.codigo_curso;

-- Lista o nome e o CPF de cada aluno
SELECT p.nome, a.cpf_pessoa
FROM pessoa p
INNER JOIN aluno a ON a.cpf_pessoa = p.cpf;

-- Alunos que não possuem endereço cadastrado
SELECT *
FROM aluno a
LEFT JOIN pessoa p ON a.cpf_pessoa = p.cpf
LEFT JOIN endereco_pessoa e ON p.cpf = e.cpf_pessoa
WHERE e.cpf_pessoa IS NULL;

-- Lista o nome de todos os professores
SELECT p.nome
FROM pessoa p
INNER JOIN professor pr ON p.cpf = pr.cpf_pessoa;

-- Lista o nome e a matrícula de cada professor
SELECT p.nome, pr.matricula_professor
FROM pessoa p
INNER JOIN professor pr ON p.cpf = pr.cpf_pessoa;

-- Lista o nome e o CPF de cada professor
SELECT p.nome, pr.cpf_pessoa
FROM pessoa p
INNER JOIN professor pr ON p.cpf = pr.cpf_pessoa;

-- Lista cada curso e suas respectivas disciplinas
SELECT c.nome_curso, d.nome
FROM disciplina d
INNER JOIN curso c ON c.codigo_curso = d.codigo_curso;

-- Mostra a quantidade de disciplinas existentes em cada curso
SELECT c.nome_curso, COUNT(d.codigo) AS quantidade_disciplinas
FROM disciplina d
INNER JOIN curso c ON d.codigo_curso = c.codigo_curso
GROUP BY c.codigo_curso, c.nome_curso;

-- Curso com maior número de disciplinas
SELECT c.nome_curso, COUNT(d.codigo) AS quantidade_disciplinas
FROM disciplina d
INNER JOIN curso c ON d.codigo_curso = c.codigo_curso
GROUP BY c.codigo_curso, c.nome_curso
ORDER BY quantidade_disciplinas DESC
LIMIT 1;

-- Mostra a carga horária total de cada curso
SELECT c.nome_curso, SUM(d.carga_horaria) AS carga_horaria
FROM disciplina d
INNER JOIN curso c ON d.codigo_curso = c.codigo_curso
GROUP BY c.codigo_curso, c.nome_curso;

-- Lista todas as disciplinas do curso de código 1
SELECT c.nome_curso, d.nome
FROM disciplina d
INNER JOIN curso c ON d.codigo_curso = c.codigo_curso
WHERE c.codigo_curso = 1;

-- Lista todas as turmas e seus respectivos cursos
SELECT t.codigo_turma, c.nome_curso
FROM turma t
INNER JOIN curso c ON t.codigo_curso = c.codigo_curso;

-- Lista os alunos de cada turma
SELECT t.codigo_turma, p.nome
FROM turma t
INNER JOIN aluno_turma t2 ON t.codigo_turma = t2.codigo_turma
INNER JOIN aluno a ON t2.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf;

-- Mostra a quantidade de alunos por turma
SELECT t2.codigo_turma, COUNT(t2.matricula_aluno) AS quantidade_aluno
FROM aluno_turma t2
GROUP BY t2.codigo_turma;

-- Mostra a turma com a maior quantidade de alunos
SELECT t2.codigo_turma, COUNT(t2.matricula_aluno) AS quantidade_aluno
FROM aluno_turma t2
GROUP BY t2.codigo_turma
ORDER BY quantidade_aluno DESC
LIMIT 1;

-- Lista os professores e as turmas em que lecionam
SELECT pt.codigo_turma, p.nome
FROM professor_turma pt
INNER JOIN professor pr ON pt.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf;

-- Lista os professores de uma turma específica (Turma 10)
SELECT pt.codigo_turma, p.nome
FROM professor_turma pt
INNER JOIN professor pr ON pt.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf
WHERE pt.codigo_turma = 10;

-- Mostra a quantidade de turmas em que cada professor leciona
SELECT COUNT(pt.codigo_turma) AS quantidade_turma, p.nome
FROM professor_turma pt
INNER JOIN professor pr ON pt.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf
GROUP BY p.nome;

-- Lista as disciplinas ministradas por cada professor
SELECT d.nome, p.nome
FROM professor_disciplina pd
INNER JOIN disciplina d ON pd.codigo_disciplina = d.codigo
INNER JOIN professor pr ON pd.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf;

-- Mostra a quantidade de disciplinas ministradas por cada professor
SELECT COUNT(d.codigo) AS quantidade_disciplinas, p.nome
FROM professor_disciplina pd
INNER JOIN disciplina d ON pd.codigo_disciplina = d.codigo
INNER JOIN professor pr ON pd.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf
GROUP BY p.nome;

-- Histórico completo de um aluno
SELECT p.nome, d.nome AS disciplina, h.nota, h.situacao, h.semestre, h.ano
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE a.matricula = 202601;

-- Notas de um aluno específico
SELECT p.nome, d.nome AS disciplina, h.nota
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE a.matricula = 202601;

-- Média de notas de um aluno
SELECT p.nome, AVG(h.nota) AS media
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
WHERE a.matricula = 202601
GROUP BY p.nome;

-- Média geral das notas por turma
SELECT t.codigo_turma, AVG(h.nota) AS media_turma
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN aluno_turma at ON a.matricula = at.matricula_aluno
INNER JOIN turma t ON at.codigo_turma = t.codigo_turma
GROUP BY t.codigo_turma;

-- Lista os alunos aprovados e suas respectivas disciplinas
SELECT p.nome, d.nome AS disciplina, h.nota
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE h.situacao = 'Aprovado';

-- Lista os alunos reprovados e suas respectivas disciplinas
SELECT p.nome, d.nome AS disciplina, h.nota
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE h.situacao = 'Reprovado';

-- Mostra a maior nota obtida em cada disciplina
SELECT d.nome AS disciplina, MAX(h.nota) AS maior_nota
FROM historico h
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
GROUP BY d.codigo, d.nome;

-- Mostra a menor nota obtida em cada disciplina
SELECT d.nome AS disciplina, MIN(h.nota) AS menor_nota
FROM historico h
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
GROUP BY d.codigo, d.nome;

-- Mostra a média de notas de cada disciplina
SELECT d.nome AS disciplina, AVG(h.nota) AS media_disciplina
FROM historico h
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
GROUP BY d.codigo, d.nome;

-- Mostra a quantidade de reprovações por disciplina
SELECT d.nome AS disciplina, COUNT(*) AS quantidade_reprovacoes
FROM historico h
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE h.situacao = 'Reprovado'
GROUP BY d.codigo, d.nome;

-- Mostra os pré-requisitos de uma disciplina específica
SELECT d.nome AS disciplina, dr.nome AS pre_requisito
FROM pre_requisito pr
INNER JOIN disciplina d ON pr.codigo_disciplina = d.codigo
INNER JOIN disciplina dr ON pr.codigo_disciplina_requisito = dr.codigo
WHERE d.codigo = 104;

-- Lista todas as disciplinas que exigem pré-requisitos
SELECT d.nome AS disciplina
FROM pre_requisito pr
INNER JOIN disciplina d ON pr.codigo_disciplina = d.codigo;

-- Lista todas as disciplinas que não possuem pré-requisitos
SELECT d.nome AS disciplina
FROM disciplina d
LEFT JOIN pre_requisito pr
ON d.codigo = pr.codigo_disciplina
WHERE pr.codigo_disciplina IS NULL;

-- Mostra a quantidade de pré-requisitos por disciplina
SELECT d.nome AS disciplina, COUNT(pr.codigo_disciplina_requisito) AS quantidade_pre_requisitos
FROM disciplina d
LEFT JOIN pre_requisito pr
ON d.codigo = pr.codigo_disciplina
GROUP BY d.codigo, d.nome;

-- Telefones de uma pessoa
SELECT tp.telefone, p.nome
FROM telefone_pessoa tp
INNER JOIN pessoa p ON tp.cpf_pessoa = p.cpf
WHERE cpf_pessoa = '111.111.111-11';

-- E-mails de uma pessoa
SELECT ep.email, p.nome
FROM email_pessoa ep
INNER JOIN pessoa p ON ep.cpf_pessoa = p.cpf
WHERE cpf_pessoa = '111.111.111-11';

-- Endereços de uma pessoa
SELECT enp.endereco, p.nome
FROM endereco_pessoa enp
INNER JOIN pessoa p ON enp.cpf_pessoa = p.cpf
WHERE cpf_pessoa = '111.111.111-11';

-- Pessoas que possuem telefone
SELECT p.nome, tp.telefone
FROM pessoa p
INNER JOIN telefone_pessoa tp ON p.cpf = tp.cpf_pessoa;

-- Pessoas sem telefone
SELECT p.nome
FROM pessoa p
LEFT JOIN telefone_pessoa tp ON p.cpf = tp.cpf_pessoa
WHERE tp.cpf_pessoa IS NULL;

-- Pessoas sem e-mail
SELECT p.nome
FROM pessoa p
LEFT JOIN email_pessoa ep ON p.cpf = ep.cpf_pessoa
WHERE ep.cpf_pessoa IS NULL;

-- Pessoas sem endereço
SELECT p.nome
FROM pessoa p
LEFT JOIN endereco_pessoa ep ON p.cpf = ep.cpf_pessoa
WHERE ep.cpf_pessoa IS NULL;

-- Quantidade total de alunos
SELECT COUNT(*) AS quantidade_alunos
FROM aluno;

-- Quantidade total de professores
SELECT COUNT(*) AS quantidade_professores
FROM professor;

-- Quantidade total de cursos
SELECT COUNT(*) AS quantidade_cursos
FROM curso;

-- Quantidade total de disciplinas
SELECT COUNT(*) AS quantidade_disciplinas
FROM disciplina;

-- Quantidade total de turmas
SELECT COUNT(*) AS quantidade_turmas
FROM turma;

-- Média geral das notas
SELECT AVG(nota) AS media_geral
FROM historico;

-- Soma das cargas horárias
SELECT SUM(carga_horaria) AS carga_horaria_total
FROM disciplina;

-- Curso com maior carga horária
SELECT c.nome_curso, SUM(d.carga_horaria) AS carga_horaria_total
FROM curso c
INNER JOIN disciplina d ON c.codigo_curso = d.codigo_curso
GROUP BY c.codigo_curso, c.nome_curso
ORDER BY carga_horaria_total DESC
LIMIT 1;

-- Alunos matriculados em determinada disciplina
SELECT p.nome, d.nome AS disciplina
FROM aluno_disciplina ad
INNER JOIN aluno a ON ad.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON ad.codigo_disciplina = d.codigo
WHERE d.codigo = 101;

-- Disciplinas cursadas por um aluno
SELECT p.nome, d.nome AS disciplina
FROM aluno_disciplina ad
INNER JOIN aluno a ON ad.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON ad.codigo_disciplina = d.codigo
WHERE a.matricula = 202601;

-- Professores que lecionam para determinado aluno
SELECT DISTINCT p.nome AS professor, ad.matricula_aluno 
FROM aluno_disciplina ad
INNER JOIN professor_disciplina pd ON ad.codigo_disciplina = pd.codigo_disciplina
INNER JOIN professor pr ON pd.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf
WHERE ad.matricula_aluno = 202601;

-- Curso de um aluno
SELECT p.nome, c.nome_curso
FROM aluno a
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN curso c ON a.codigo_curso = c.codigo_curso
WHERE a.matricula = 202601;

-- Nome do aluno + curso + turma
SELECT p.nome, c.nome_curso, t.codigo_turma
FROM aluno a
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN curso c ON a.codigo_curso = c.codigo_curso
INNER JOIN aluno_turma at ON a.matricula = at.matricula_aluno
INNER JOIN turma t ON at.codigo_turma = t.codigo_turma;

-- Professor + disciplina + turma
SELECT p.nome AS professor, d.nome AS disciplina, t.codigo_turma
FROM professor_turma pt
INNER JOIN professor pr ON pt.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf
INNER JOIN professor_disciplina pd ON pr.matricula_professor = pd.matricula_professor
INNER JOIN disciplina d ON pd.codigo_disciplina = d.codigo
INNER JOIN turma t ON pt.codigo_turma = t.codigo_turma;

-- Alunos que cursaram determinada disciplina
SELECT p.nome, d.nome AS nome_disciplina
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE h.codigo_disciplina = 101;

-- Disciplinas ainda não cursadas por um aluno
SELECT d.nome
FROM disciplina d
WHERE d.codigo NOT IN (
SELECT h.codigo_disciplina
FROM historico h
WHERE h.matricula_aluno = 202601
);

-- Boletim completo de um aluno
SELECT p.nome, d.nome AS disciplina, h.nota, h.situacao
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE a.matricula = 202601;

-- Grade curricular de um curso
SELECT c.nome_curso, d.nome AS disciplina, d.periodo, d.carga_horaria
FROM curso c
INNER JOIN disciplina d ON c.codigo_curso = d.codigo_curso
WHERE c.codigo_curso = 1;

-- Relação professor-disciplina-turma
SELECT p.nome AS professor, d.nome AS disciplina, t.codigo_turma
FROM professor_turma pt
INNER JOIN professor pr ON pt.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf
INNER JOIN professor_disciplina pd ON pr.matricula_professor = pd.matricula_professor
INNER JOIN disciplina d ON pd.codigo_disciplina = d.codigo
INNER JOIN turma t ON pt.codigo_turma = t.codigo_turma;

-- Relação aluno-turma-disciplina
SELECT p.nome AS aluno, t.codigo_turma, d.nome AS disciplina
FROM aluno a
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN aluno_turma at ON a.matricula = at.matricula_aluno
INNER JOIN turma t ON at.codigo_turma = t.codigo_turma
INNER JOIN aluno_disciplina ad ON a.matricula = ad.matricula_aluno
INNER JOIN disciplina d ON ad.codigo_disciplina = d.codigo;

-- Histórico acadêmico completo
SELECT p.nome, d.nome AS disciplina, h.nota, h.situacao, h.semestre, h.ano
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo;

-- Relatório de aprovação por disciplina
SELECT d.nome, COUNT(*) AS aprovados
FROM historico h
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE h.situacao = 'Aprovado'
GROUP BY d.codigo, d.nome;

-- Relatório de reprovação por curso
SELECT c.nome_curso, COUNT(*) AS reprovacoes
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN curso c ON a.codigo_curso = c.codigo_curso
WHERE h.situacao = 'Reprovado'
GROUP BY c.codigo_curso, c.nome_curso;

-- Relatório de carga horária por curso
SELECT c.nome_curso, SUM(d.carga_horaria) AS carga_horaria
FROM curso c
INNER JOIN disciplina d ON c.codigo_curso = d.codigo_curso
GROUP BY c.codigo_curso, c.nome_curso;

-- Relatório de professores por curso
SELECT c.nome_curso, COUNT(DISTINCT pr.matricula_professor) AS quantidade_professores
FROM curso c
INNER JOIN disciplina d ON c.codigo_curso = d.codigo_curso
INNER JOIN professor_disciplina pd ON d.codigo = pd.codigo_disciplina
INNER JOIN professor pr ON pd.matricula_professor = pr.matricula_professor
GROUP BY c.codigo_curso, c.nome_curso;

-- Relatório de alunos por curso
SELECT c.nome_curso, COUNT(a.matricula) AS quantidade_alunos
FROM curso c
INNER JOIN aluno a ON c.codigo_curso = a.codigo_curso
GROUP BY c.codigo_curso, c.nome_curso;

-- Aluno com maior média
SELECT p.nome, AVG(h.nota) AS media
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
GROUP BY p.nome
ORDER BY media DESC
LIMIT 1;

-- Aluno com menor média
SELECT p.nome, AVG(h.nota) AS media
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
GROUP BY p.nome
ORDER BY media ASC
LIMIT 1;

-- Disciplina com maior média
SELECT d.nome, AVG(h.nota) AS media
FROM historico h
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
GROUP BY d.codigo, d.nome
ORDER BY media DESC
LIMIT 1;

-- Disciplina com mais reprovações
SELECT d.nome, COUNT(*) AS reprovacoes
FROM historico h
INNER JOIN disciplina d ON h.codigo_disciplina = d.codigo
WHERE h.situacao = 'Reprovado'
GROUP BY d.codigo, d.nome
ORDER BY reprovacoes DESC
LIMIT 1;

-- Curso com mais alunos
SELECT c.nome_curso, COUNT(a.matricula) AS quantidade_alunos
FROM curso c
INNER JOIN aluno a ON c.codigo_curso = a.codigo_curso
GROUP BY c.codigo_curso, c.nome_curso
ORDER BY quantidade_alunos DESC
LIMIT 1;

-- Curso com menos alunos
SELECT c.nome_curso, COUNT(a.matricula) AS quantidade_alunos
FROM curso c
INNER JOIN aluno a ON c.codigo_curso = a.codigo_curso
GROUP BY c.codigo_curso, c.nome_curso
ORDER BY quantidade_alunos ASC
LIMIT 1;

-- Professor que ministra mais disciplinas
SELECT p.nome, COUNT(pd.codigo_disciplina) AS quantidade_disciplinas
FROM professor_disciplina pd
INNER JOIN professor pr ON pd.matricula_professor = pr.matricula_professor
INNER JOIN pessoa p ON pr.cpf_pessoa = p.cpf
GROUP BY p.nome
ORDER BY quantidade_disciplinas DESC
LIMIT 1;

-- Turma com maior quantidade de alunos
SELECT codigo_turma, COUNT(matricula_aluno) AS quantidade_alunos
FROM aluno_turma
GROUP BY codigo_turma
ORDER BY quantidade_alunos DESC
LIMIT 1;

-- Alunos acima da média geral
SELECT p.nome, AVG(h.nota) AS media
FROM historico h
INNER JOIN aluno a ON h.matricula_aluno = a.matricula
INNER JOIN pessoa p ON a.cpf_pessoa = p.cpf
GROUP BY p.nome
HAVING AVG(h.nota) > (
SELECT AVG(nota)
FROM historico
);

-- Disciplinas com carga horária acima da média
SELECT nome, carga_horaria
FROM disciplina
WHERE carga_horaria > (
SELECT AVG(carga_horaria)
FROM disciplina
);




