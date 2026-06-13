-- Matricular um aluno em uma disciplina
CREATE OR REPLACE PROCEDURE matricular_aluno_disciplina(
    p_matricula INTEGER,
    p_codigo_disciplina INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO aluno_disciplina (
        matricula_aluno,
        codigo_disciplina
    )
    VALUES (
        p_matricula,
        p_codigo_disciplina
    );
END;
$$;


-- Matricular um aluno em uma turma
CREATE OR REPLACE PROCEDURE matricular_aluno_turma(
    p_matricula INTEGER,
    p_codigo_turma INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO aluno_turma (
        matricula_aluno,
        codigo_turma
    )
    VALUES (
        p_matricula,
        p_codigo_turma
    );
END;
$$;


-- Cancelar matrícula de uma disciplina
CREATE OR REPLACE PROCEDURE cancelar_matricula_disciplina(
    p_matricula INTEGER,
    p_codigo_disciplina INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM aluno_disciplina
    WHERE matricula_aluno = p_matricula
      AND codigo_disciplina = p_codigo_disciplina;
END;
$$;


-- Transferir aluno de turma
CREATE OR REPLACE PROCEDURE transferir_aluno_turma(
    p_matricula INTEGER,
    p_turma_origem INTEGER,
    p_turma_destino INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE aluno_turma
    SET codigo_turma = p_turma_destino
    WHERE matricula_aluno = p_matricula
      AND codigo_turma = p_turma_origem;
END;
$$;


-- Transferir aluno de curso
CREATE OR REPLACE PROCEDURE transferir_aluno_curso(
    p_matricula INTEGER,
    p_novo_curso INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE aluno
    SET codigo_curso = p_novo_curso
    WHERE matricula = p_matricula;
END;
$$;


-- Registrar nota de um aluno
CREATE OR REPLACE PROCEDURE registrar_nota(
    p_matricula INTEGER,
    p_codigo_disciplina INTEGER,
    p_nota NUMERIC
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE historico
    SET nota = p_nota
    WHERE matricula_aluno = p_matricula
      AND codigo_disciplina = p_codigo_disciplina;
END;
$$;


-- Atualizar situação do aluno
CREATE OR REPLACE PROCEDURE atualizar_situacao_aluno(
    p_matricula INTEGER,
    p_codigo_disciplina INTEGER,
    p_situacao VARCHAR(20)
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE historico
    SET situacao = p_situacao
    WHERE matricula_aluno = p_matricula
      AND codigo_disciplina = p_codigo_disciplina;
END;
$$;


-- Gerar histórico automaticamente
CREATE OR REPLACE PROCEDURE gerar_historico(
    p_matricula INTEGER,
    p_codigo_disciplina INTEGER,
    p_semestre INTEGER,
    p_ano INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO historico (
        matricula_aluno,
        codigo_disciplina,
        semestre,
        ano
    )
    VALUES (
        p_matricula,
        p_codigo_disciplina,
        p_semestre,
        p_ano
    );
END;
$$;


-- Fechar semestre e lançar resultados
CREATE OR REPLACE PROCEDURE fechar_semestre(
    p_semestre INTEGER,
    p_ano INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE historico
    SET situacao =
        CASE
            WHEN nota >= 7 THEN 'Aprovado'
            ELSE 'Reprovado'
        END
    WHERE semestre = p_semestre
      AND ano = p_ano;
END;
$$;



-- Criar uma nova disciplina
CREATE OR REPLACE PROCEDURE criar_disciplina(
    p_codigo INTEGER,
    p_codigo_curso INTEGER,
    p_nome VARCHAR(100),
    p_carga_horaria INTEGER,
    p_tipo VARCHAR(50),
    p_periodo INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO disciplina (
        codigo,
        codigo_curso,
        nome,
        carga_horaria,
        tipo_disciplina,
        periodo
    )
    VALUES (
        p_codigo,
        p_codigo_curso,
        p_nome,
        p_carga_horaria,
        p_tipo,
        p_periodo
    );
END;
$$;


-- Criar uma nova turma
CREATE OR REPLACE PROCEDURE criar_turma(
    p_codigo_turma INTEGER,
    p_periodo VARCHAR(20),
    p_sala VARCHAR(20),
    p_codigo_curso INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO turma (
        codigo_turma,
        periodo,
        sala,
        codigo_curso
    )
    VALUES (
        p_codigo_turma,
        p_periodo,
        p_sala,
        p_codigo_curso
    );
END;
$$;


-- Associar professor a disciplina
CREATE OR REPLACE PROCEDURE associar_professor_disciplina(
    p_matricula_professor INTEGER,
    p_codigo_disciplina INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO professor_disciplina (
        matricula_professor,
        codigo_disciplina
    )
    VALUES (
        p_matricula_professor,
        p_codigo_disciplina
    );
END;
$$;


-- Associar professor a turma
CREATE OR REPLACE PROCEDURE associar_professor_turma(
    p_matricula_professor INTEGER,
    p_codigo_turma INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO professor_turma (
        matricula_professor,
        codigo_turma
    )
    VALUES (
        p_matricula_professor,
        p_codigo_turma
    );
END;
$$;


-- Cadastrar pré-requisito
CREATE OR REPLACE PROCEDURE cadastrar_pre_requisito(
    p_disciplina INTEGER,
    p_requisito INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO pre_requisito (
        codigo_disciplina,
        codigo_disciplina_requisito
    )
    VALUES (
        p_disciplina,
        p_requisito
    );
END;
$$;

-- Reajustar carga horária de disciplinas
CREATE OR REPLACE PROCEDURE reajustar_carga_horaria(
    p_codigo_disciplina INTEGER,
    p_nova_carga INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE disciplina
    SET carga_horaria = p_nova_carga
    WHERE codigo = p_codigo_disciplina;
END;
$$;


-- Atualizar modalidade de um curso
CREATE OR REPLACE PROCEDURE atualizar_modalidade_curso(
    p_codigo_curso INTEGER,
    p_modalidade VARCHAR(50)
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE curso
    SET modalidade = p_modalidade
    WHERE codigo_curso = p_codigo_curso;
END;
$$;


-- Alterar dados cadastrais de uma pessoa
CREATE OR REPLACE PROCEDURE atualizar_dados_pessoa(
    p_cpf VARCHAR(14),
    p_nome VARCHAR(100),
    p_data_nascimento DATE,
    p_escolaridade VARCHAR(50)
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE pessoa
    SET nome = p_nome,
        data_nascimento = p_data_nascimento,
        nivel_escolaridade = p_escolaridade
    WHERE cpf = p_cpf;
END;
$$;


-- ==========================================
-- EXEMPLOS DE USO
-- ==========================================

CALL matricular_aluno_disciplina(202601, 102);

CALL matricular_aluno_turma(202601, 20);

CALL cancelar_matricula_disciplina(202601, 102);

CALL transferir_aluno_turma(202601, 10, 20);

CALL transferir_aluno_curso(202605, 1);

CALL registrar_nota(202601, 101, 9.8);

CALL atualizar_situacao_aluno(202601, 101, 'Aprovado');

CALL gerar_historico(202601, 102, 1, 2026);

CALL fechar_semestre(1, 2026);

CALL criar_disciplina(
    106,
    1,
    'Banco de Dados',
    60,
    'Obrigatória',
    2
);

CALL criar_turma(
    50,
    'Noturno',
    'Sala 404',
    1
);

CALL associar_professor_disciplina(9001, 106);

CALL associar_professor_turma(9001, 50);

CALL cadastrar_pre_requisito(106, 101);

CALL reajustar_carga_horaria(106, 80);

CALL atualizar_modalidade_curso(
    1,
    'EAD'
);

CALL atualizar_dados_pessoa(
    '111.111.111-11',
    'Paulo Patrício Atualizado',
    '2004-05-15',
    'Ensino Superior Incompleto'
);
