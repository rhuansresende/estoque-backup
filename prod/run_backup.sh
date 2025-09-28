#!/bin/bash
set -e

export PGHOST="postgres"
export PGUSER="bsemporio"
export PGPASSWORD="YmFuY29kZWRhZG9zYnNlbXBvcmlv"
export PGDATABASE="estoquedbprod"

echo "[DEBUG] HOST=$PGHOST USER=$PGUSER DB=$PGDATABASE" >> /backups/cron_logs_prod.log

echo "[BACKUP START][$ENVIRONMENT] $(date)" >> /backups/cron_logs_prod.log

pg_dump -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -F c \
  -f /backups/backup_$(date +\%Y\%m\%d_%H%M).dump

if [ $? -eq 0 ]; then
  echo "[BACKUP OK] $(date)" >> /backups/cron_logs_prod.log
else
  echo "[BACKUP FAIL] $(date)" >> /backups/cron_logs_prod.log
fi
