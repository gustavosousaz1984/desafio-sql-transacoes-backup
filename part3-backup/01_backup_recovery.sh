#!/usr/bin/env bash
# ============================================================
#  PARTE 3 — BACKUP E RECOVERY com mysqldump
#  Desafio DIO · SQL Database Specialist
#  01_backup_recovery.sh  (Linux / macOS / Git Bash)
# ============================================================
#  O desafio exige:
#    · backup do banco e-commerce           → ecommerce_db
#    · backup de DIFERENTES bancos           → ecommerce_db +
#      first_example + oficina_mecanica
#    · incluir procedures, eventos e outros  → --routines
#      --events --triggers
#    · arquivo de backup no GitHub junto do script
#
#  Obs.: o "Data Export" do MySQL Workbench executa o
#  mysqldump por baixo dos panos — mesmos recursos, pela
#  interface gráfica.
# ============================================================
set -euo pipefail

MYSQL_USER="root"
DATE="$(date +%F)"
OUT="backup_full_${DATE}.sql"

echo "== 1) BACKUP (3 bancos + routines + events + triggers) =="
mysqldump -u "$MYSQL_USER" -p \
  --databases ecommerce_db first_example oficina_mecanica \
  --routines --events --triggers \
  --add-drop-database --add-drop-trigger \
  --set-gtid-purged=OFF \
  --single-transaction \
  --result-file="$OUT"
echo "Arquivo gerado: $OUT"

echo "== 2) BACKUP COMPACTADO (opcional) =="
gzip -kf "$OUT"
echo "Gerado: ${OUT}.gz"

echo "== 3) RECOVERY (restaura tudo; o dump já contém"
echo "         DROP TABLE IF EXISTS e CREATE DATABASE IF NOT EXISTS) =="
mysql -u "$MYSQL_USER" -p < "$OUT"

echo "== 4) VERIFICAÇÃO pós-recovery =="
mysql -u "$MYSQL_USER" -p -e "
  SELECT TABLE_SCHEMA AS banco, COUNT(*) AS tabelas
  FROM information_schema.TABLES
  WHERE TABLE_SCHEMA IN ('ecommerce_db','first_example','oficina_mecanica')
  GROUP BY TABLE_SCHEMA;
  SELECT COUNT(*) AS procedures FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA='ecommerce_db';
  SELECT COUNT(*) AS events     FROM information_schema.EVENTS    WHERE EVENT_SCHEMA='ecommerce_db';
  SELECT COUNT(*) AS triggers   FROM information_schema.TRIGGERS  WHERE TRIGGER_SCHEMA='ecommerce_db';"

echo "OK — backup e recovery concluídos."
