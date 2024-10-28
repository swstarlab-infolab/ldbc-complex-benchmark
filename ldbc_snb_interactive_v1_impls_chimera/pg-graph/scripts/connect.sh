#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/vars.sh

docker exec -it ${PG_GRAPH_CONTAINER_NAME} psql --username=${PG_GRAPH_USER} --dbname=${PG_GRAPH_DATABASE}
