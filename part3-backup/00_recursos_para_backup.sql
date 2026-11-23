-- ============================================================
--  PARTE 3 — BACKUP E RECOVERY (complemento)
--  Desafio DIO · SQL Database Specialist
--  Arquivo: recursos que o backup deve incluir
-- ============================================================
--  O desafio pede: "Realize o backup de diferentes bancos de
--  dados e insira os recursos como: procedures, eventos e
--  outros."
--
--  · procedures → sp_criar_pedido (criada na Parte 2)
--  · eventos    → evt_rotina_diaria  (criada aqui)
--  · triggers   → trg_pedido_status_auditoria (aqui)
--  · views      → v_today já existente no banco
--
--  Assim o mysqldump com --routines --events --triggers
--  realmente tem o que exportar.
-- ============================================================

USE ecommerce_db;


-- ============================================================
--  1. TRIGGER — auditoria de mudança de status do pedido
--     (BEFORE UPDATE; só registra quando o status muda)
-- ============================================================
CREATE TABLE IF NOT EXISTS pedido_auditoria (
  idAuditoria    INT AUTO_INCREMENT PRIMARY KEY,
  idPedido       INT NOT NULL,
  statusAnterior ENUM('Em processamento','Em transporte','Entregue','Cancelado') NOT NULL,
  statusNovo     ENUM('Em processamento','Em transporte','Entregue','Cancelado') NOT NULL,
  dataAlteracao  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

DROP TRIGGER IF EXISTS trg_pedido_status_auditoria;

DELIMITER $$

CREATE TRIGGER trg_pedido_status_auditoria
BEFORE UPDATE ON pedido
FOR EACH ROW
BEGIN
  IF NEW.statusPedido <> OLD.statusPedido THEN
    INSERT INTO pedido_auditoria (idPedido, statusAnterior, statusNovo)
    VALUES (OLD.idPedido, OLD.statusPedido, NEW.statusPedido);
  END IF;
END$$

DELIMITER ;

-- Teste da trigger: muda o status do pedido 3 e restaura
UPDATE pedido SET statusPedido = 'Entregue'   WHERE idPedido = 3;  -- era 'Em transporte'
UPDATE pedido SET statusPedido = 'Em transporte' WHERE idPedido = 3;  -- restaura

SELECT idPedido, statusAnterior, statusNovo, dataAlteracao
FROM pedido_auditoria
WHERE idPedido = 3;

-- Limpeza do teste (a trigger em si permanece no banco)
DELETE FROM pedido_auditoria WHERE idPedido = 3;


-- ============================================================
--  2. EVENT — rotina diária agendada
--     (heartbeat em linha única: atualiza 1 registro por dia
--      em vez de acumular linhas)
-- ============================================================
CREATE TABLE IF NOT EXISTS log_rotina (
  idLog     INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(100) NOT NULL,
  dataLog   DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE EVENT IF NOT EXISTS evt_rotina_diaria
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
  INSERT INTO log_rotina (idLog, descricao, dataLog)
  VALUES (1, 'Rotina diaria executada com sucesso', NOW())
  ON DUPLICATE KEY UPDATE descricao = VALUES(descricao), dataLog = VALUES(dataLog);

-- Verificação dos recursos criados (é o que o backup deve conter)
SELECT EVENT_NAME, STATUS, INTERVAL_VALUE, INTERVAL_FIELD
FROM information_schema.EVENTS
WHERE EVENT_SCHEMA = 'ecommerce_db';

SHOW TRIGGERS FROM ecommerce_db;

SELECT ROUTINE_NAME, ROUTINE_TYPE
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ecommerce_db';
