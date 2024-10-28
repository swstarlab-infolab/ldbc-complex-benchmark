#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/vars.sh

python3 -c 'import psycopg' || (echo "psycopg Python package is missing or broken" && exit 1)

scripts/stop.sh

if [ -n "${PG_GRAPH_CSV_DIR-}" ]; then
    if [ ! -d "${PG_GRAPH_CSV_DIR}" ]; then
        echo "Directory ${PG_GRAPH_CSV_DIR} does not exist."
        exit 1
    fi
    export MOUNT_CSV_DIR="--volume=${PG_GRAPH_CSV_DIR}:/data:z"
else
    export PG_GRAPH_CSV_DIR="<unspecified>"
    export MOUNT_CSV_DIR=""
fi

if [ -n "${POSTGRES_CUSTOM_CONFIGURATION-}" ]; then
    if [ ! -f "${POSTGRES_CUSTOM_CONFIGURATION}" ]; then
        echo "Configuration file ${POSTGRES_CUSTOM_CONFIGURATION} does not exist."
        exit 1
    fi
    export POSTGRES_CUSTOM_MOUNTS="--volume=${POSTGRES_CUSTOM_CONFIGURATION}:/etc/postgresql.conf:z"
    export POSTGRES_CUSTOM_ARGS="--config_file=/etc/postgresql.conf"
else
    export POSTGRES_CUSTOM_CONFIGURATION="<unspecified>"
    export POSTGRES_CUSTOM_MOUNTS=""
    export POSTGRES_CUSTOM_ARGS=""
fi

# ensure that ${POSTGRES_DATA_DIR} exists
mkdir -p "${PG_GRAPH_DATA_DIR}"

echo "==============================================================================="
echo "Starting pg-graph container"
echo "-------------------------------------------------------------------------------"
echo "PG_GRAPH_VERSION: ${PG_GRAPH_VERSION}"
echo "PG_GRAPH_CONTAINER_NAME: ${PG_GRAPH_CONTAINER_NAME}"
echo "PG_GRAPH_PASSWORD: ${PG_GRAPH_PASSWORD}"
echo "PG_GRAPH_DATABASE: ${PG_GRAPH_DATABASE}"
echo "PG_GRAPH_USER: ${PG_GRAPH_USER}"
echo "PG_GRAPH_PORT: ${PG_GRAPH_PORT}"
echo "POSTGRES_CUSTOM_CONFIGURATION: ${POSTGRES_CUSTOM_CONFIGURATION}"
echo "PG_GRAPH_DATA_DIR (on the host machine):"
echo "  ${PG_GRAPH_DATA_DIR}"
echo "PG_GRAPH_CSV_DIR (on the host machine):"
echo "  ${PG_GRAPH_CSV_DIR}"
echo "==============================================================================="

docker run --rm \
    --publish=${PG_GRAPH_PORT}:5432 \
    ${PG_GRAPH_DOCKER_PLATFORM_FLAG} \
    --name ${PG_GRAPH_CONTAINER_NAME} \
    --shm-size=${PG_GRAPH_SHM_SIZE} \
    --env POSTGRES_DATABASE=${PG_GRAPH_DATABASE} \
    --env POSTGRES_USER=${PG_GRAPH_USER} \
    --env POSTGRES_PASSWORD=${PG_GRAPH_PASSWORD} \
    ${MOUNT_CSV_DIR} \
    --volume=${PG_GRAPH_DATA_DIR}:/var/lib/postgresql/data:z \
    ${POSTGRES_CUSTOM_MOUNTS} \
    --detach \
    ${PG_GRAPH_DOCKER_IMAGE}:${PG_GRAPH_VERSION} \
    ${POSTGRES_CUSTOM_ARGS}

echo -n "Waiting for the database to start ."
until python3 scripts/test-db-connection.py; do
    docker ps | grep ${PG_GRAPH_CONTAINER_NAME} 1>/dev/null 2>&1 || (
        echo
        echo "Container lost."
        exit 1
    )
    echo -n " ."
    sleep 1
done
echo
echo "Database started"
