-- Atualiza situação automaticamente

CREATE TRIGGER tg_atualizar_situacao
BEFORE INSERT OR UPDATE
ON historico
FOR EACH ROW
EXECUTE FUNCTION atualizar_situacao();


-- Registrar reprovação

CREATE TRIGGER tg_registrar_reprovacao
AFTER INSERT OR UPDATE
ON historico
FOR EACH ROW
EXECUTE FUNCTION registrar_reprovacao();


-- Log alteração de nota

CREATE TRIGGER tg_log_nota
AFTER UPDATE
ON historico
FOR EACH ROW
EXECUTE FUNCTION log_alteracao_nota();


-- Log matrícula

CREATE TRIGGER tg_log_matricula
AFTER INSERT
ON aluno_disciplina
FOR EACH ROW
EXECUTE FUNCTION log_matricula_func();


-- Log exclusão de aluno

CREATE TRIGGER tg_log_exclusao_aluno
AFTER DELETE
ON aluno
FOR EACH ROW
EXECUTE FUNCTION log_exclusao_aluno_func();


-- Log alteração professor

CREATE TRIGGER tg_log_professor
AFTER UPDATE
ON professor
FOR EACH ROW
EXECUTE FUNCTION log_professor_func();


-- Criar histórico automaticamente

CREATE TRIGGER tg_criar_historico_aluno
AFTER INSERT
ON aluno
FOR EACH ROW
EXECUTE FUNCTION criar_historico_aluno();


-- Auditoria de disciplina

CREATE TRIGGER tg_auditoria_disciplina
AFTER INSERT
ON disciplina
FOR EACH ROW
EXECUTE FUNCTION auditoria_disciplina_func();


-- Registrar criação da turma

CREATE TRIGGER tg_data_turma
BEFORE INSERT
ON turma
FOR EACH ROW
EXECUTE FUNCTION registrar_data_turma();

