#!/bin/bash
set -e

export PGHOST="${POSTGRES_HOST}"
export PGUSER="${POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGDATABASE="${POSTGRES_DB}"

echo "[DEBUG] HOST=$PGHOST USER=$PGUSER DB=$PGDATABASE" >> /backups/cron_logs_"$ENVIRONMENT".log

echo "[BACKUP START][$ENVIRONMENT] $(date)" >> /backups/cron_logs_"$ENVIRONMENT".log

pg_dump -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -F c \
  -f /backups/backup_$(date +\%Y\%m\%d_%H%M).dump

if [ $? -eq 0 ]; then
  echo "[BACKUP OK] $(date)" >> /backups/cron_logs_"$ENVIRONMENT".log
else
  echo "[BACKUP FAIL] $(date)" >> /backups/cron_logs_"$ENVIRONMENT".log
fi
