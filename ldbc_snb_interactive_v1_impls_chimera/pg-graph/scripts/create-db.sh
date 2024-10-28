#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/vars.sh

docker exec -i ${PG_GRAPH_CONTAINER_NAME} dropdb --if-exists ${PG_GRAPH_DATABASE} --username=${PG_GRAPH_USER}
docker exec -i ${PG_GRAPH_CONTAINER_NAME} createdb ${PG_GRAPH_DATABASE} --username=${PG_GRAPH_USER} --template template0 --locale "POSIX"
