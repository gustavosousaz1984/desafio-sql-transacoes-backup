-- ============================================================
--  PARTE 1 — TRANSAÇÕES
--  Desafio DIO · SQL Database Specialist
--  Arquivo único — autocommit + transações (COMMIT / ROLLBACK)
-- ============================================================
--  Objetivo: executar statements de CONSULTA e MODIFICAÇÃO de
--  dados persistidos no banco dentro de uma transação, SEM
--  usar procedures.
--
--  Regra de ouro do desafio: ANTES de tudo, desabilitar o
--  autocommit do MySQL. Com autocommit=1 (padrão), cada
--  instrução é confirmada sozinha — não existiria transação.
--
--  Cenário: criação de um pedido (COMMIT) e reajuste de preço
--  que será desfeito (ROLLBACK) no banco ecommerce_db.
-- ============================================================

USE ecommerce_db;

-- ------------------------------------------------------------
-- 0. Desabilita o autocommit (obrigatório para transações)
-- ------------------------------------------------------------
SET autocommit = 0;   -- a partir daqui, nada é confirmado sem COMMIT

-- Estado atual (consulta inicial)
SELECT idPedido, idCliente, statusPedido, frete
FROM pedido
ORDER BY idPedido;


-- ------------------------------------------------------------
-- 1. TRANSACAO COM COMMIT — criação completa de um pedido
--    (consultas + modificações + confirmação única)
-- ------------------------------------------------------------
START TRANSACTION;

  -- modificação 1: cabeçalho do pedido
  INSERT INTO pedido (idCliente, statusPedido, descricao, frete)
  VALUES (1, 'Em processamento', 'Pedido criado via transacao (teste)', 0.00);

  SET @novo_pedido = LAST_INSERT_ID();

  -- modificação 2: itens do pedido
  INSERT INTO item_pedido (idPedido, idProduto, quantidade, precoUnitario)
  VALUES (@novo_pedido, 2, 3, 19.99);

  -- consulta: os dados já aparecem para ESTA sessão,
  -- mas ainda não foram persistidos no banco
  SELECT p.idPedido, p.descricao, i.idProduto, i.quantidade,
         i.precoUnitario, (i.quantidade * i.precoUnitario) AS total
  FROM pedido p
  JOIN item_pedido i ON i.idPedido = p.idPedido
  WHERE p.idPedido = @novo_pedido;

COMMIT;   -- confirma TUDO de uma vez (era ROLLBACK para desfazer tudo)

-- consulta após o COMMIT: dados persistidos no banco
SELECT 'Apos COMMIT' AS momento, idPedido, statusPedido, frete
FROM pedido
WHERE idPedido = @novo_pedido;


-- ------------------------------------------------------------
-- 2. TRANSACAO COM ROLLBACK — alteração desfeita por completo
-- ------------------------------------------------------------
START TRANSACTION;

  -- modificação: reajuste de 10% nos eletrônicos
  UPDATE produto
  SET valor = ROUND(valor * 1.10, 2)
  WHERE categoria = 'Eletronico';

  -- consulta: a alteração JÁ aparece para esta sessão...
  SELECT 'Dentro da transacao' AS momento, idProduto, nome, valor
  FROM produto
  WHERE categoria = 'Eletronico'
  ORDER BY idProduto;

ROLLBACK;  -- ...e some depois do ROLLBACK (nenhuma linha persistida)

SELECT 'Apos ROLLBACK' AS momento, idProduto, nome, valor
FROM produto
WHERE categoria = 'Eletronico'
ORDER BY idProduto;


-- ------------------------------------------------------------
-- 3. Restaura o autocommit (fim da demonstração)
-- ------------------------------------------------------------
SET autocommit = 1;   -- volta ao padrão: cada statement confirma sozinho

-- ------------------------------------------------------------
-- 4. Limpeza dos dados de teste (mantém a base limpa para o
--    backup da Parte 3; opcional — pode comentar as linhas)
-- ------------------------------------------------------------
DELETE FROM item_pedido WHERE idPedido = @novo_pedido;
DELETE FROM pedido      WHERE idPedido = @novo_pedido;

SELECT 'Limpeza concluida' AS status, COUNT(*) AS pedidos_restantes
FROM pedido;
