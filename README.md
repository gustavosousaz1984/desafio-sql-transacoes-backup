# 🔒 Desafio SQL — Transações, Procedure com Rollback e Backup/Recovery

Projeto do curso **SQL Database Specialist (DIO)** cobrindo três competências:

- **Parte 1 — Transações:** desabilitar o `autocommit` e executar consultas + modificações dentro de uma transação, com `COMMIT` e `ROLLBACK`.
- **Parte 2 — Transação com Procedure:** transação embutida em uma procedure, com verificação de erro que dispara **ROLLBACK total** (exceção/validação) ou **ROLLBACK parcial via `SAVEPOINT`**.
- **Parte 3 — Backup e Recovery:** backup de **diferentes bancos** com `mysqldump` incluindo **procedures, eventos, triggers e views** + recovery executado e verificado; o **arquivo de backup** está versionado no GitHub junto dos scripts.

> **Autor:** Gustavo Sousa · [LinkedIn](https://www.linkedin.com/in/gustavosousaz/) · [GitHub](https://github.com/gustavosousaz1984)

---

## 📁 Estrutura do projeto

```
desafio-sql-transacoes-backup/
├── README.md                              ← este arquivo
├── part1-transacoes/
│   └── 01_transacoes.sql                  ← autocommit + COMMIT + ROLLBACK
├── part2-procedure/
│   └── 01_transacao_procedure.sql         ← sp_criar_pedido (transação + handlers + SAVEPOINT)
└── part3-backup/
    ├── 00_recursos_para_backup.sql        ← trigger + evento (para o backup incluí-los)
    ├── 01_backup_recovery.sh              ← script de backup/recovery (bash)
    ├── 02_backup_recovery.ps1             ← script de backup/recovery (PowerShell)
    └── backup_full_2026-11-23.sql         ← ARQUIVO DE BACKUP (mysqldump real)
```

---

## ▶️ Como executar

Ordem: **Parte 1 → Parte 2 → recursos da Parte 3 → backup** (cada script seleciona o banco com `USE` antes de criar objetos):

```bash
mysql -u root -p < part1-transacoes/01_transacoes.sql
mysql -u root -p < part2-procedure/01_transacao_procedure.sql
mysql -u root -p < part3-backup/00_recursos_para_backup.sql
```

Também funciona colando no **MySQL Workbench** (Execute SQL). Bases usadas: `ecommerce_db` (banco e-commerce do curso), `first_example` e `oficina_mecanica`.

---

## 🔁 Parte 1 — Transações

**Regra de ouro do desafio:** `SET autocommit = 0;` antes de tudo — com autocommit ligado (padrão), cada instrução é confirmada sozinha e não existiria transação.

| Demo | O que acontece |
|---|---|
| **COMMIT** | `INSERT` do pedido + `INSERT` dos itens + `SELECT` de conferência → tudo confirmado de uma vez; após o `COMMIT` os dados permanecem no banco |
| **ROLLBACK** | `UPDATE` de +10% nos eletrônicos → visível **dentro** da transação → `ROLLBACK` → valores originais restaurados |

Ao final: `SET autocommit = 1` (restaura o padrão) e limpeza opcional dos dados de teste.

---

## ⚡ Parte 2 — Transação dentro de Procedure

**`sp_criar_pedido(p_idCliente, p_idProduto, p_qtd, p_freteGratis)`**

Regra de negócio: **frete grátis só para pedidos ≥ R$ 100**. A verificação de erro acarreta dois tipos de rollback:

| Verificação | Tipo de erro | Ação |
|---|---|---|
| `DECLARE EXIT HANDLER FOR SQLEXCEPTION` | exceção SQL (NOT NULL, FK, tipo) | **ROLLBACK total** |
| cliente/produto inexistente (validação) | regra de negócio | **ROLLBACK total** |
| total < R$ 100 com frete grátis solicitado | regra de negócio | **ROLLBACK parcial** (`SAVEPOINT sp_antes_frete`) |

O **savepoint** fica entre o grupo A (cabeçalho + itens do pedido, que **permanecem**) e o grupo B (tentativa de frete grátis, que é **desfeita**).

### Testes executados (6 caminhos)

| # | Chamada | Resultado |
|---|---|---|
| 1 | `CALL sp_criar_pedido(1, 2, 3, 1)` | total R$ 59,97 < 100 → **rollback parcial**; pedido mantido com frete padrão R$ 15,90 |
| 2 | `CALL sp_criar_pedido(1, 1, 1, 1)` | total R$ 649,99 ≥ 100 → frete **R$ 0,00** concedido |
| 3 | `CALL sp_criar_pedido(2, 3, 2, 0)` | sem frete grátis → frete padrão R$ 15,90 |
| 4 | `CALL sp_criar_pedido(9999, 1, 1, 0)` | cliente inexistente → **rollback total** |
| 5 | `CALL sp_criar_pedido(1, 9999, 1, 0)` | produto inexistente → **rollback total** |
| 6 | `CALL sp_criar_pedido(1, 2, NULL, 0)` | `NULL` viola `NOT NULL` → exceção SQL → **rollback total** |

---

## 💾 Parte 3 — Backup e Recovery (mysqldump)

### Recursos incluídos no backup

O desafio pede que o backup contenha "procedures, eventos e outros". Como o banco do curso não tinha nenhum, foram criados:

| Recurso | Objeto | Origem |
|---|---|---|
| **Procedure** | `sp_criar_pedido` | Parte 2 |
| **Trigger** | `trg_pedido_status_auditoria` (auditoria de status do pedido) | `00_recursos_para_backup.sql` |
| **Evento** | `evt_rotina_diaria` (rotina diária agendada) | `00_recursos_para_backup.sql` |
| **View** | `v_today` | já existia no banco |

### Comando de backup (executado de verdade)

```bash
mysqldump -u root -p \
  --databases ecommerce_db first_example oficina_mecanica \
  --routines --events --triggers \
  --add-drop-database --add-drop-trigger \
  --set-gtid-purged=OFF \
  --single-transaction \
  --result-file=backup_full_2026-11-23.sql
```

| Flag | Por quê |
|---|---|
| `--databases A B C` | **backup de diferentes bancos** em um único arquivo |
| `--routines --events --triggers` | inclui procedures, eventos e triggers |
| `--add-drop-database` | recovery completo: recria o estado exato do backup |
| `--add-drop-trigger` | evita erro "trigger already exists" no restore |
| `--set-gtid-purged=OFF` | dump portátil (restaurável em outra instância) |
| `--single-transaction` | snapshot consistente em InnoDB sem bloquear as tabelas |

> 💡 **Workbench:** o *Data Export* (Administration → Data Export) executa exatamente o `mysqldump` por baixo dos panos — mesmas opções de *Include routines, events, triggers* pela interface gráfica.

### Recovery executado e verificado

```bash
mysql -u root -p < backup_full_2026-11-23.sql
```

| Verificação | Antes | Depois do recovery |
|---|---|---|
| `ecommerce_db` (objetos) | 17 | 17 ✅ |
| `first_example` (tabelas) | 2 | 2 ✅ |
| `oficina_mecanica` (tabelas) | 11 | 11 ✅ |
| procedures | 1 | 1 ✅ |
| events | 1 (ENABLED) | 1 ✅ |
| triggers | 1 | 1 ✅ |
| pedidos | 5 | 5 ✅ |

---

## 🛠️ Tecnologias

- **MySQL** (SGBD) · **mysqldump** (backup/recovery)
- **MySQL Workbench** (interface gráfica)
- **SQL** — transações, procedures, handlers, savepoints, triggers, eventos
- **Git / GitHub** (versionamento — scripts + arquivo de backup)

---

## 📚 O que este projeto demonstra

| Competência | Aplicação |
|---|---|
| **Transações ACID** | `COMMIT`/`ROLLBACK` com autocommit desabilitado |
| **Programação em SQL** | procedure com `EXIT HANDLER`, validações e `SAVEPOINT` |
| **Controle de erro** | rollback total × rollback parcial conforme o tipo de falha |
| **Backup e recovery** | `mysqldump` multi-banco com routines/events/triggers + restore verificado |
| **Boas práticas** | scripts reexecutáveis, limpeza de dados de teste, flags corretas de dump |
