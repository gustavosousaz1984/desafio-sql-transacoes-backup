# ============================================================
#  PARTE 3 — BACKUP E RECOVERY com mysqldump (Windows)
#  Desafio DIO · SQL Database Specialist
#  02_backup_recovery.ps1
# ============================================================
#  Uso:  .\02_backup_recovery.ps1
#  A senha é pedida na hora (nada fica salvo no script).
#
#  Equivalente ao 01_backup_recovery.sh — mesma operação,
#  PowerShell no lugar do bash.
# ============================================================

$MysqlBin = "C:\Program Files\MySQL\MySQL Server 26.7\bin"
$User     = "root"
$Date     = Get-Date -Format "yyyy-MM-dd"
$Out      = "backup_full_$Date.sql"

Write-Host "== 1) BACKUP (3 bancos + routines + events + triggers) =="
& "$MysqlBin\mysqldump.exe" -u $User -p `
  --databases ecommerce_db first_example oficina_mecanica `
  --routines --events --triggers `
  --add-drop-database --add-drop-trigger `
  --set-gtid-purged=OFF `
  --single-transaction `
  --result-file=$Out
if ($LASTEXITCODE -ne 0) { throw "Falha no backup (mysqldump)" }
Write-Host "Arquivo gerado: $Out"

Write-Host "== 2) RECOVERY =="
# O dump já contém DROP TABLE IF EXISTS / CREATE DATABASE IF NOT
# EXISTS — basta reexecutá-lo para restaurar o estado do backup.
$sec  = Read-Host "Senha do MySQL" -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
$env:MYSQL_PWD = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
cmd /c "mysql -u $User < `"$Out`""
if ($LASTEXITCODE -ne 0) { throw "Falha no recovery (mysql)" }

Write-Host "== 3) VERIFICACAO pos-recovery =="
& "$MysqlBin\mysql.exe" -u $User -e @"
SELECT TABLE_SCHEMA AS banco, COUNT(*) AS tabelas
FROM information_schema.TABLES
WHERE TABLE_SCHEMA IN ('ecommerce_db','first_example','oficina_mecanica')
GROUP BY TABLE_SCHEMA;
SELECT COUNT(*) AS procedures FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA='ecommerce_db';
SELECT COUNT(*) AS events     FROM information_schema.EVENTS    WHERE EVENT_SCHEMA='ecommerce_db';
SELECT COUNT(*) AS triggers   FROM information_schema.TRIGGERS  WHERE TRIGGER_SCHEMA='ecommerce_db';
"@

Remove-Item Env:\MYSQL_PWD -ErrorAction SilentlyContinue
Write-Host "OK - backup e recovery concluidos."
