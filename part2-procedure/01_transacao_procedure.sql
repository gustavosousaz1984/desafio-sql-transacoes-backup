-- ============================================================
--  PARTE 2 — TRANSAÇÃO COM PROCEDURE
--  Desafio DIO · SQL Database Specialist
--  Arquivo único — procedure com transação, verificação de
--  erro, ROLLBACK total e ROLLBACK parcial (SAVEPOINT)
-- ============================================================
--  A transação agora vive DENTRO de uma procedure. Dentro
--  dela, a VERIFICAÇÃO DE ERRO pode acarretar:
--
--    · ROLLBACK TOTAL   → exceção SQL (EXIT HANDLER) ou
--                         validação de negócio falhou
--    · ROLLBACK PARCIAL → SAVEPOINT desfaz apenas o trecho
--                         arriscado, mantendo o que foi feito
--                         antes do ponto de segurança
--
--  Cenário: sp_criar_pedido valida cliente/produto e cria o
--  pedido. Frete grátis é benefício CONDICIONADO — só pedidos
--  >= R$ 100 podem usá-lo. Se a regra for violada, o
--  SAVEPOINT desfaz só a tentativa de frete; o pedido é
--  mantido (rollback parcial).
-- ============================================================

USE ecommerce_db;

DROP PROCEDURE IF EXISTS sp_criar_pedido;

DELIMITER $$

CREATE PROCEDURE sp_criar_pedido(
  IN p_idCliente   INT,
  IN p_idProduto   INT,
  IN p_qtd         INT,
  IN p_freteGratis TINYINT   -- 1 = cliente solicita frete grátis
)
BEGIN
  DECLARE v_cliente INT;
  DECLARE v_preco   DECIMAL(10,2);
  DECLARE v_pedido  INT;
  DECLARE v_total   DECIMAL(10,2);
  DECLARE v_frete   DECIMAL(10,2) DEFAULT 15.90;  -- frete padrão

  -- --------------------------------------------------------
  -- VERIFICAÇÃO DE ERRO 1 — qualquer exceção SQL
  -- (coluna NOT NULL, FK violada, tipo inválido...)
  -- → ROLLBACK TOTAL: nada é persistido
  -- --------------------------------------------------------
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SELECT 'ERRO SQL: transacao revertida (ROLLBACK total)' AS resultado;
  END;

  START TRANSACTION;

    -- validações por consulta ANTES de gravar qualquer coisa
    -- (SELECT sem linhas gera aviso 1329 e a variável fica NULL)
    SELECT idCliente INTO v_cliente
    FROM cliente WHERE idCliente = p_idCliente;

    SELECT valor INTO v_preco
    FROM produto WHERE idProduto = p_idProduto;

    IF v_cliente IS NULL OR v_preco IS NULL THEN
      -- VERIFICAÇÃO DE ERRO 2 — regra de negócio
      ROLLBACK;
      SELECT 'ERRO: cliente ou produto inexistente (ROLLBACK total)' AS resultado;

    ELSE
      -- ---------- grupo A: operações essenciais ----------
      INSERT INTO pedido (idCliente, statusPedido, descricao, frete)
      VALUES (p_idCliente, 'Em processamento',
              'Pedido criado pela procedure sp_criar_pedido', v_frete);

      SET v_pedido = LAST_INSERT_ID();

      INSERT INTO item_pedido (idPedido, idProduto, quantidade, precoUnitario)
      VALUES (v_pedido, p_idProduto, p_qtd, v_preco);

      SET v_total = p_qtd * v_preco;

      -- ---------- grupo B: trecho arriscado (frete grátis) ----------
      IF p_freteGratis = 1 THEN

        -- PONTO DE SEGURANÇA: a partir daqui, dá para
        -- desfazer SÓ este trecho e manter o pedido
        SAVEPOINT sp_antes_frete;

          UPDATE pedido SET frete = 0.00 WHERE idPedido = v_pedido;

          IF v_total < 100.00 THEN
            -- VERIFICAÇÃO DE ERRO 3 — regra "frete grátis
            -- só para pedidos >= R$ 100"
            -- → ROLLBACK PARCIAL: desfaz apenas a tentativa
            --   de frete; o pedido criado acima do savepoint
            --   é MANTIDO
            ROLLBACK TO SAVEPOINT sp_antes_frete;

            SELECT CONCAT('REGRA: frete gratis negado (total R$ ',
                          FORMAT(v_total, 2), ' < R$ 100,00) — ',
                          'ROLLBACK parcial; pedido ', v_pedido,
                          ' mantido com frete padrao') AS resultado;
          ELSE
            SELECT CONCAT('REGRA: frete gratis concedido ao pedido ',
                          v_pedido, ' (total R$ ', FORMAT(v_total, 2),
                          ' >= R$ 100,00)') AS resultado;
          END IF;

      END IF;

      COMMIT;   -- persiste o pedido (frete padrão ou grátis)

      SELECT CONCAT('OK: pedido ', v_pedido, ' confirmado — total R$ ',
                    FORMAT(v_total, 2), ', frete R$ ',
                    (SELECT frete FROM pedido WHERE idPedido = v_pedido))
      AS resultado;
    END IF;

END$$

DELIMITER ;


-- ============================================================
--  TESTES — executar para verificar cada caminho da procedure
-- ============================================================

-- Caminho 1: regra do frete VIOLADA → rollback parcial
--   (3 x R$ 19,99 = R$ 59,97 < R$ 100 → frete volta a R$ 15,90)
CALL sp_criar_pedido(1, 2, 3, 1);

-- Caminho 2: frete grátis VÁLIDO → commit com frete zero
--   (1 x R$ 649,99 = R$ 649,99 >= R$ 100)
CALL sp_criar_pedido(1, 1, 1, 1);

-- Caminho 3: sem frete grátis → commit com frete padrão
CALL sp_criar_pedido(2, 3, 2, 0);

-- Caminho 4: cliente inexistente → rollback total (validação)
CALL sp_criar_pedido(9999, 1, 1, 0);

-- Caminho 5: produto inexistente → rollback total (validação)
CALL sp_criar_pedido(1, 9999, 1, 0);

-- Caminho 6: exceção SQL (quantidade NULL viola NOT NULL)
--            → EXIT HANDLER → rollback total
CALL sp_criar_pedido(1, 2, NULL, 0);

-- Evidência: só os pedidos válidos persistiram
SELECT idPedido, idCliente, statusPedido, frete, descricao
FROM pedido
WHERE descricao = 'Pedido criado pela procedure sp_criar_pedido'
ORDER BY idPedido;


-- ============================================================
--  Limpeza dos dados de teste (mantém a base limpa para o
--  backup da Parte 3; opcional — pode comentar)
-- ============================================================
DELETE i FROM item_pedido i
JOIN pedido p ON p.idPedido = i.idPedido
WHERE p.descricao = 'Pedido criado pela procedure sp_criar_pedido';

DELETE FROM pedido
WHERE descricao = 'Pedido criado pela procedure sp_criar_pedido';

SELECT 'Limpeza concluida' AS status, COUNT(*) AS pedidos_restantes
FROM pedido;
