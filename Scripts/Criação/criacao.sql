--TABELAS PRINCIPAIS

CREATE TABLE pessoa (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    nivel_escolaridade VARCHAR(50)
);

CREATE TABLE aluno (
    matricula INTEGER PRIMARY KEY,
    cpf_pessoa VARCHAR(14) UNIQUE NOT NULL,
    codigo_curso INTEGER,
    FOREIGN KEY (cpf_pessoa) REFERENCES pessoa(cpf)
);

CREATE TABLE professor (
    matricula_professor INTEGER PRIMARY KEY,
    cpf_pessoa VARCHAR(14) UNIQUE NOT NULL,
    FOREIGN KEY (cpf_pessoa) REFERENCES pessoa(cpf)
);

CREATE TABLE escolaridade (
    matricula INTEGER PRIMARY KEY,
    cpf_pessoa VARCHAR(14) UNIQUE NOT NULL,
    FOREIGN KEY (cpf_pessoa) REFERENCES pessoa(cpf)
);

CREATE TABLE curso (
    codigo_curso INTEGER PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) UNIQUE,
    modalidade VARCHAR(50)
);

CREATE TABLE disciplina (
    codigo INTEGER PRIMARY KEY,
    codigo_curso INTEGER,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INTEGER,
    tipo_disciplina VARCHAR(50),
    periodo INTEGER,
    FOREIGN KEY (codigo_curso) REFERENCES curso(codigo_curso)
);

CREATE TABLE turma (
    codigo_turma INTEGER PRIMARY KEY,
    periodo VARCHAR(20),
    sala VARCHAR(20),
    codigo_curso INT NOT NULL,
    FOREIGN KEY (codigo_curso) REFERENCES curso(codigo_curso)
);

CREATE TABLE oferta_disciplina (
    id_oferta SERIAL PRIMARY KEY,
    codigo_turma INTEGER NOT NULL,
    codigo_disciplina INTEGER NOT NULL,
    semestre INTEGER,
    ano INTEGER,
    FOREIGN KEY (codigo_turma) REFERENCES turma(codigo_turma),
    FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo)
);

CREATE TABLE historico (
    id_historico SERIAL PRIMARY KEY,
    matricula_aluno INTEGER NOT NULL,
    codigo_disciplina INTEGER NOT NULL,
    nota DECIMAL(4,2),
    situacao VARCHAR(20),
    semestre INTEGER,
    ano INTEGER,
    FOREIGN KEY (matricula_aluno) REFERENCES aluno(matricula),
    FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo)
);

CREATE TABLE pre_requisito (
    codigo_disciplina INTEGER,
    codigo_disciplina_requisito INTEGER,
    PRIMARY KEY (codigo_disciplina, codigo_disciplina_requisito),
    FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo),
    FOREIGN KEY (codigo_disciplina_requisito) REFERENCES disciplina(codigo)
);

	--TABELAS PARA OS RELACIONAMENTOS
	
	CREATE TABLE aluno_disciplina (
	    matricula_aluno INTEGER,
	    codigo_disciplina INTEGER,
	    PRIMARY KEY (matricula_aluno, codigo_disciplina),
	    FOREIGN KEY (matricula_aluno) REFERENCES aluno(matricula),
	    FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo)
	);
	
	CREATE TABLE professor_disciplina (
	    matricula_professor INTEGER,
	    codigo_disciplina INTEGER,
	    PRIMARY KEY (matricula_professor, codigo_disciplina),
	    FOREIGN KEY (matricula_professor) REFERENCES professor(matricula_professor),
	    FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo)
	);
	
	CREATE TABLE professor_turma (
	    matricula_professor INTEGER,
	    codigo_turma INTEGER,
	    PRIMARY KEY (matricula_professor, codigo_turma),
	    FOREIGN KEY (matricula_professor) REFERENCES professor(matricula_professor),
	    FOREIGN KEY (codigo_turma) REFERENCES turma(codigo_turma)
	);
	
	CREATE TABLE aluno_turma (
	    matricula_aluno INTEGER,
	    codigo_turma INTEGER,
	    PRIMARY KEY (matricula_aluno, codigo_turma),
	    FOREIGN KEY (matricula_aluno) REFERENCES aluno(matricula),
	    FOREIGN KEY (codigo_turma) REFERENCES turma(codigo_turma)
	);
	
	--TABELAS DOS ATRIBUTOS MULTIVALORADOS
	
	CREATE TABLE telefone_pessoa (
	    cpf_pessoa VARCHAR(14),
	    telefone VARCHAR(20),
	    PRIMARY KEY (cpf_pessoa),
	    FOREIGN KEY (cpf_pessoa) REFERENCES pessoa(cpf)
	);
	
	CREATE TABLE email_pessoa (
	    cpf_pessoa VARCHAR(14),
	    email VARCHAR(100),
	    PRIMARY KEY (cpf_pessoa),
	    FOREIGN KEY (cpf_pessoa) REFERENCES pessoa(cpf)
	);
	
	CREATE TABLE endereco_pessoa (
	    id_endereco SERIAL PRIMARY KEY,
	    cpf_pessoa VARCHAR(14),
	    endereco VARCHAR(255),
	    FOREIGN KEY (cpf_pessoa) REFERENCES pessoa(cpf)
	);
