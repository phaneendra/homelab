#!/bin/bash
set -e
set -u

user_password="${DB_PASSWORD:-$POSTGRES_PASSWORD}"

if [ -n "$MULTIPLE_DATABASES" ]; then
  echo "Creating additional databases: $MULTIPLE_DATABASES"
  IFS=',' read -r -a db_names <<< "$MULTIPLE_DATABASES"
  for db in "${db_names[@]}"; do
    db=$(echo "$db" | xargs)
    if [ -n "$db" ]; then
      echo "Creating database and user for: $db"
      psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        DO \$
        BEGIN
          IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$db') THEN
            CREATE ROLE "$db" WITH LOGIN PASSWORD '$user_password';
          END IF;
        END
        \$;

        SELECT 'CREATE DATABASE "$db" OWNER "$db"' 
        WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$db')\gexec

        \c "$db"
        CREATE EXTENSION IF NOT EXISTS vector;
EOSQL
    fi
  done
fi
