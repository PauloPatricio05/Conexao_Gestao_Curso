-- Verifica se um aluno foi aprovado em uma disciplina específica
CREATE OR REPLACE FUNCTION aluno_aprovado(
    p_matricula INTEGER,
    p_codigo_disciplina INTEGER
)
RETURNS BOOLEAN AS
$$
DECLARE
    v_situacao VARCHAR(20);
BEGIN
    SELECT situacao
    INTO v_situacao
    FROM historico
    WHERE matricula_aluno = p_matricula
      AND codigo_disciplina = p_codigo_disciplina;

    RETURN v_situacao = 'Aprovado';
END;
$$ LANGUAGE plpgsql;


-- Calcula a média das notas de um aluno
CREATE OR REPLACE FUNCTION media_aluno(
    p_matricula INTEGER
)
RETURNS NUMERIC AS
$$
DECLARE
    v_media NUMERIC;
BEGIN
    SELECT AVG(nota)
    INTO v_media
    FROM historico
    WHERE matricula_aluno = p_matricula;

    RETURN v_media;
END;
$$ LANGUAGE plpgsql;


-- Conta quantas disciplinas um aluno já cursou
CREATE OR REPLACE FUNCTION quantidade_disciplinas_cursadas(
    p_matricula INTEGER
)
RETURNS INTEGER AS
$$
DECLARE
    v_quantidade INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_quantidade
    FROM historico
    WHERE matricula_aluno = p_matricula;

    RETURN v_quantidade;
END;
$$ LANGUAGE plpgsql;


-- Conta quantas reprovações um aluno possui
CREATE OR REPLACE FUNCTION quantidade_reprovacoes(
    p_matricula INTEGER
)
RETURNS INTEGER AS
$$
DECLARE
    v_quantidade INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_quantidade
    FROM historico
    WHERE matricula_aluno = p_matricula
      AND situacao = 'Reprovado';

    RETURN v_quantidade;
END;
$$ LANGUAGE plpgsql;


-- Verifica se um aluno pode cursar uma disciplina com base nos pré-requisitos
CREATE OR REPLACE FUNCTION pode_cursar_disciplina(
    p_matricula INTEGER,
    p_codigo_disciplina INTEGER
)
RETURNS BOOLEAN AS
$$
DECLARE
    v_faltando INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_faltando
    FROM pre_requisito pr
    WHERE pr.codigo_disciplina = p_codigo_disciplina
      AND pr.codigo_disciplina_requisito NOT IN (
            SELECT h.codigo_disciplina
            FROM historico h
            WHERE h.matricula_aluno = p_matricula
              AND h.situacao = 'Aprovado'
      );

    RETURN v_faltando = 0;
END;
$$ LANGUAGE plpgsql;


-- Retorna a carga horária total de um curso
CREATE OR REPLACE FUNCTION carga_horaria_curso(
    p_codigo_curso INTEGER
)
RETURNS INTEGER AS
$$
DECLARE
    v_carga_horaria INTEGER;
BEGIN
    SELECT SUM(carga_horaria)
    INTO v_carga_horaria
    FROM disciplina
    WHERE codigo_curso = p_codigo_curso;

    RETURN v_carga_horaria;
END;
$$ LANGUAGE plpgsql;


-- Retorna a quantidade de alunos de um curso
CREATE OR REPLACE FUNCTION quantidade_alunos_curso(
    p_codigo_curso INTEGER
)
RETURNS INTEGER AS
$$
DECLARE
    v_quantidade INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_quantidade
    FROM aluno
    WHERE codigo_curso = p_codigo_curso;

    RETURN v_quantidade;
END;
$$ LANGUAGE plpgsql;


-- Retorna a quantidade de alunos de uma turma
CREATE OR REPLACE FUNCTION quantidade_alunos_turma(
    p_codigo_turma INTEGER
)
RETURNS INTEGER AS
$$
DECLARE
    v_quantidade INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_quantidade
    FROM aluno_turma
    WHERE codigo_turma = p_codigo_turma;

    RETURN v_quantidade;
END;
$$ LANGUAGE plpgsql;


-- Verifica se um aluno está matriculado em determinada disciplina
CREATE OR REPLACE FUNCTION aluno_matriculado_disciplina(
    p_matricula INTEGER,
    p_codigo_disciplina INTEGER
)
RETURNS BOOLEAN AS
$$
DECLARE
    v_quantidade INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_quantidade
    FROM aluno_disciplina
    WHERE matricula_aluno = p_matricula
      AND codigo_disciplina = p_codigo_disciplina;

    RETURN v_quantidade > 0;
END;
$$ LANGUAGE plpgsql;


-- Retorna quantas disciplinas um professor ministra
CREATE OR REPLACE FUNCTION quantidade_disciplinas_professor(
    p_matricula_professor INTEGER
)
RETURNS INTEGER AS
$$
DECLARE
    v_quantidade INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_quantidade
    FROM professor_disciplina
    WHERE matricula_professor = p_matricula_professor;

    RETURN v_quantidade;
END;
$$ LANGUAGE plpgsql;


-- Retorna quantas turmas um professor leciona
CREATE OR REPLACE FUNCTION quantidade_turmas_professor(
    p_matricula_professor INTEGER
)
RETURNS INTEGER AS
$$
DECLARE
    v_quantidade INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_quantidade
    FROM professor_turma
    WHERE matricula_professor = p_matricula_professor;

    RETURN v_quantidade;
END;
$$ LANGUAGE plpgsql;


-- Verifica se um professor está vinculado a uma disciplina
CREATE OR REPLACE FUNCTION professor_vinculado_disciplina(
    p_matricula_professor INTEGER,
    p_codigo_disciplina INTEGER
)
RETURNS BOOLEAN AS
$$
DECLARE
    v_quantidade INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_quantidade
    FROM professor_disciplina
    WHERE matricula_professor = p_matricula_professor
      AND codigo_disciplina = p_codigo_disciplina;

    RETURN v_quantidade > 0;
END;
$$ LANGUAGE plpgsql;


-- Retorna a maior nota registrada em uma disciplina
CREATE OR REPLACE FUNCTION maior_nota_disciplina(
    p_codigo_disciplina INTEGER
)
RETURNS NUMERIC AS
$$
DECLARE
    v_maior_nota NUMERIC;
BEGIN
    SELECT MAX(nota)
    INTO v_maior_nota
    FROM historico
    WHERE codigo_disciplina = p_codigo_disciplina;

    RETURN v_maior_nota;
END;
$$ LANGUAGE plpgsql;


-- Retorna a média das notas de uma disciplina
CREATE OR REPLACE FUNCTION media_disciplina(
    p_codigo_disciplina INTEGER
)
RETURNS NUMERIC AS
$$
DECLARE
    v_media NUMERIC;
BEGIN
    SELECT AVG(nota)
    INTO v_media
    FROM historico
    WHERE codigo_disciplina = p_codigo_disciplina;

    RETURN v_media;
END;
$$ LANGUAGE plpgsql;

-- Atualiza situação automaticamente

CREATE OR REPLACE FUNCTION atualizar_situacao()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.nota >= 7 THEN
        NEW.situacao := 'Aprovado';
    ELSE
        NEW.situacao := 'Reprovado';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Registrar reprovação

CREATE OR REPLACE FUNCTION registrar_reprovacao()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.situacao = 'Reprovado' THEN
        INSERT INTO ocorrencia_academica (
            matricula_aluno,
            codigo_disciplina,
            descricao
        )
        VALUES (
            NEW.matricula_aluno,
            NEW.codigo_disciplina,
            'Aluno reprovado na disciplina'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Log de alteração de nota

CREATE OR REPLACE FUNCTION log_alteracao_nota()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO log_nota (
        matricula_aluno,
        codigo_disciplina,
        nota_antiga,
        nota_nova
    )
    VALUES (
        OLD.matricula_aluno,
        OLD.codigo_disciplina,
        OLD.nota,
        NEW.nota
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Log de matrícula

CREATE OR REPLACE FUNCTION log_matricula_func()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO log_matricula (
        matricula_aluno,
        codigo_disciplina,
        operacao
    )
    VALUES (
        NEW.matricula_aluno,
        NEW.codigo_disciplina,
        'INSERT'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Log exclusão de aluno

CREATE OR REPLACE FUNCTION log_exclusao_aluno_func()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO log_exclusao_aluno (
        matricula_aluno,
        cpf
    )
    VALUES (
        OLD.matricula,
        OLD.cpf_pessoa
    );

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


-- Log alteração professor

CREATE OR REPLACE FUNCTION log_professor_func()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO log_professor (
        matricula_professor
    )
    VALUES (
        NEW.matricula_professor
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Criar histórico vazio ao cadastrar aluno

CREATE OR REPLACE FUNCTION criar_historico_aluno()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO historico (
        matricula_aluno,
        codigo_disciplina,
        nota,
        situacao,
        semestre,
        ano
    )
    VALUES (
        NEW.matricula,
        101,
        NULL,
        NULL,
        NULL,
        NULL
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Auditoria de disciplina

CREATE OR REPLACE FUNCTION auditoria_disciplina_func()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO auditoria_disciplina (
        codigo_disciplina,
        nome_disciplina
    )
    VALUES (
        NEW.codigo,
        NEW.nome
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Registrar data de criação de turma

CREATE OR REPLACE FUNCTION registrar_data_turma()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.periodo :=
        NEW.periodo || ' - Criada em ' || CURRENT_DATE;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- EXEMPLOS DE USO
-- ==========================================

SELECT quantidade_disciplinas_professor(9001);

SELECT quantidade_turmas_professor(9001);

SELECT professor_vinculado_disciplina(9001, 101);

SELECT maior_nota_disciplina(101);

SELECT media_disciplina(101);

SELECT aluno_aprovado(202601, 101);

SELECT media_aluno(202601);

SELECT quantidade_disciplinas_cursadas(202601);

SELECT quantidade_reprovacoes(202604);

SELECT pode_cursar_disciplina(202601, 104);

SELECT carga_horaria_curso(1);

SELECT quantidade_alunos_curso(1);

SELECT quantidade_alunos_turma(10);

SELECT aluno_matriculado_disciplina(202601, 101);
