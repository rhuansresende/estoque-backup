#!/bin/bash
set -e

export PGHOST="postgres"
export PGUSER="postgres"
export PGPASSWORD="aA@741859"
export PGDATABASE="estoquedb"

echo "[DEBUG] HOST=$PGHOST USER=$PGUSER DB=$PGDATABASE" >> /backups/hom.log

echo "[BACKUP START][$ENVIRONMENT] $(date)" >> /backups/cron_logs_hom.log

pg_dump -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -F c \
  -f /backups/backup_$(date +\%Y\%m\%d_%H%M).dump

if [ $? -eq 0 ]; then
  echo "[BACKUP OK] $(date)" >> /backups/cron_logs_hom.log
else
  echo "[BACKUP FAIL] $(date)" >> /backups/cron_logs_hom.log
fi
