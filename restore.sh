#!/bin/bash

if [ -f .env ]; then
    # Source the .env file to load the variables
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found!"
    exit 1
fi

DB_HOST="pg-0"
DB_USER=${POSTGRESQL_USERNAME}
DB_PASSWORD=${POSTGRESQL_PASSWORD}
DB_NAME=${POSTGRESQL_DATABASE}
BACKUP_PATH="/backups"

# Specify the file name or get the latest one
BACKUP_FILE="$BACKUP_PATH/$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file $BACKUP_FILE not found!"
  exit 1
fi

# Export the password so pg_restore can use it
export PGPASSWORD=$DB_PASSWORD

echo "Dropping and recreating the database: $DB_NAME"
psql -h $DB_HOST -U $DB_USER -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"
psql -h $DB_HOST -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME;"

echo "Restoring from backup: $BACKUP_FILE"
pg_restore -h $DB_HOST -U $DB_USER -d $DB_NAME -v $BACKUP_FILE

echo "Restore completed successfully."
