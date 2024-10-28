#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$PG_GRAPH_USER" --dbname "$PG_GRAPH_DB" <<-EOSQL
    DO
    \$do\$
    BEGIN
    IF EXISTS (
        SELECT FROM pg_catalog.pg_roles
        WHERE  rolname = '${PG_GRAPH_USER}') THEN
        RAISE NOTICE 'Role ${PG_GRAPH_USER} already exists. Skipping.';
    ELSE
        BEGIN   -- nested block
            CREATE ROLE ${PG_GRAPH_USER} LOGIN PASSWORD '${PG_GRAPH_PASSWORD}';
        EXCEPTION
            WHEN duplicate_object THEN
                RAISE NOTICE 'Role ${PG_GRAPH_USER} was just created by a concurrent transaction. Skipping.';
        END;
    END IF;
	GRANT ALL PRIVILEGES ON DATABASE ${PG_GRAPH_DB} TO ${PG_GRAPH_USER};
    END
    \$do\$;
EOSQL