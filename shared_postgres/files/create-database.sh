#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPOSE_FILE="$COMPOSE_DIR/docker-compose.yml"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required but not installed" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <database_name> [database_user] [database_password]" >&2
  exit 1
fi

db_name="$1"
db_user="${2:-$db_name}"
db_password="${3:-${DB_PASSWORD:-${POSTGRES_PASSWORD:-}}}"

if [[ -z "$db_name" ]]; then
  echo "Database name is required" >&2
  exit 1
fi

if [[ -z "$db_password" ]]; then
  echo "Database password is required. Set DB_PASSWORD or POSTGRES_PASSWORD, or pass it as the third argument." >&2
  exit 1
fi

superuser="${POSTGRES_USER:-postgres}"
superpass="${POSTGRES_PASSWORD:-${DB_PASSWORD:-}}"

if [[ -z "$superpass" ]]; then
  echo "Postgres superuser password is required. Set POSTGRES_PASSWORD or DB_PASSWORD." >&2
  exit 1
fi

if ! docker compose -f "$COMPOSE_FILE" ps --services --filter status=running | grep -q '^shared-postgres$'; then
  echo "shared-postgres container is not running" >&2
  exit 1
fi

echo "Creating database '$db_name' for user '$db_user'..."
docker compose -f "$COMPOSE_FILE" exec -T \
  -e PGPASSWORD="$superpass" \
  shared-postgres \
  psql -v ON_ERROR_STOP=1 --username "$superuser" --dbname postgres <<SQL
\set ON_ERROR_STOP on
\set db_name '$db_name'
\set db_user '$db_user'
\set db_password '$db_password'

DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'db_user') THEN
    EXECUTE format('CREATE ROLE %I WITH LOGIN PASSWORD %L', :'db_user', :'db_password');
  END IF;
END
\$\$;

SELECT format('CREATE DATABASE %I OWNER %I', :'db_name', :'db_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'db_name')\gexec

\connect :db_name
CREATE EXTENSION IF NOT EXISTS vector;
SQL

echo "Database '$db_name' is ready"
