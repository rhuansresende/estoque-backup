#!/bin/bash
set -e

# Seleciona pasta do ambiente
case "$ENVIRONMENT" in
  dev)   ENV_PATH="/app/dev" ;;
  hom)    ENV_PATH="/app/hom" ;;
  prod)  ENV_PATH="/app/prod" ;;
  *)
    echo "ENVIRONMENT inválido: $ENVIRONMENT (use dev, hom ou prod)"
    exit 1
    ;;
esac

# Copia o script e crontab corretos para /app ativo
cp "$ENV_PATH/run_backup.sh" /app/run_backup.sh
cp "$ENV_PATH/crontab.txt" /etc/cron.d/postgres_backup

# Corrige possíveis CRLF do Git (Windows)
dos2unix /app/run_backup.sh
dos2unix /etc/cron.d/postgres_backup

chmod +x /app/run_backup.sh
chmod 0644 /etc/cron.d/postgres_backup

# Instala cron
crontab /etc/cron.d/postgres_backup

echo "===> Iniciando cron para ambiente: $ENVIRONMENT"

# Garante que o arquivo de log exista
touch /backups/cron_logs_"$ENVIRONMENT".log

cron

tail -f /backups/cron_logs_"$ENVIRONMENT".log
