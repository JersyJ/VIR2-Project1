#!/bin/sh

DB_HOST="${POSTGRES_HOST}"
DB_USER="${POSTGRES_USER}"
DB_PASSWORD="${POSTGRES_PASSWORD}"
DB_NAME="${POSTGRES_DB}"
BACKUP_PATH="/backups"

TIMESTAMP=$(date +"%Y%m%d%H%M")
BACKUP_FILE="$BACKUP_PATH/postgres_backup_$TIMESTAMP.dump"

# Export the password so pg_dump can use it
export PGPASSWORD=$DB_PASSWORD

pg_dump -h $DB_HOST -U $DB_USER -F c -b -v -f $BACKUP_FILE $DB_NAME

echo "Backup created: $BACKUP_FILE"
