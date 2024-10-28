#!/bin/bash

MODE=$1
SF=$2
PG_GRAPH_ROOT=$3
shm_size=128g
PG_GRAPH_VERSION=0.4.1
PYENV_NAME=ldbc_snb_chimera
SCRIPT_DIR=`pwd`/scripts/
BENCHMARK_DIR=`pwd`/ldbc_snb_interactive_v1_impls_chimera/pg-graph
PG_GRAPH_CSV_DIR=${PG_GRAPH_ROOT}/out-interactive-sf${SF}
PG_GRAPH_CONTAINER_DIR=${PG_GRAPH_ROOT}/data-interactive-sf${SF}
PG_GRAPH_DATA_DIR=${PG_GRAPH_CONTAINER_DIR}/data
POSTGRES_CUSTOM_CONFIGURATION=${SCRIPT_DIR}/config/postgresql.conf


echo "=============================================================="
echo "Setting LDBC SNB csv files"
echo "=============================================================="
if [ $MODE = "init" ]; then
    sudo rm -rf ${PG_GRAPH_CSV_DIR}
    sudo rm -rf ${PG_GRAPH_CONTAINER_DIR}
    mkdir -p ${PG_GRAPH_CONTAINER_DIR}/data

    ${SCRIPT_DIR}/download-data-set.sh \
        https://repository.surfsara.nl/datasets/cwi/snb/files/social_network-csv_merge_foreign/social_network-csv_merge_foreign-sf${SF}.tar.zst
    tar --use-compress-program=unzstd -xvf social_network-csv_merge_foreign-sf${SF}.tar.zst
    mv social_network-csv_merge_foreign-sf${SF}/ ${PG_GRAPH_CSV_DIR}
    rm social_network-csv_merge_foreign-sf${SF}.tar.zst
    mkdir ${PG_GRAPH_CSV_DIR}/update_streams
    mv ${PG_GRAPH_CSV_DIR}/updateStream* ${PG_GRAPH_CSV_DIR}/update_streams/
    mv ${PG_GRAPH_CSV_DIR}/.updateStream* ${PG_GRAPH_CSV_DIR}/update_streams/

    ${SCRIPT_DIR}/download-data-set.sh \
         https://repository.surfsara.nl/datasets/cwi/snb/files/substitution_parameters/substitution_parameters-sf${SF}.tar.zst
    tar --use-compress-program=unzstd -xvf substitution_parameters-sf${SF}.tar.zst
    mv substitution_parameters-sf${SF}/ ${PG_GRAPH_CSV_DIR}/substitution_parameters
    rm substitution_parameters-sf${SF}.tar.zst
fi 


echo "=============================================================="
echo "Setting environment files"
echo "=============================================================="
cd ${BENCHMARK_DIR}
rm scripts/vars.sh
rm scripts/backup-database.sh
rm scripts/restore-database.sh
rm .env
cp scripts/vars.sh.base scripts/vars.sh
cp scripts/backup-database.sh.base scripts/backup-database.sh
cp scripts/restore-database.sh.base scripts/restore-database.sh
cp .env.base .env

sed -i "s@(PG_GRAPH_DATA_DIR)@${PG_GRAPH_DATA_DIR}@g" scripts/vars.sh
sed -i "s@(PG_GRAPH_VERSION)@${PG_GRAPH_VERSION}@g" scripts/vars.sh
sed -i "s@(PG_GRAPH_CONTAINER_DIR)@${PG_GRAPH_CONTAINER_DIR}@g" scripts/backup-database.sh
sed -i "s@(PG_GRAPH_CONTAINER_DIR)@${PG_GRAPH_CONTAINER_DIR}@g" scripts/restore-database.sh
sed -i "s@(POSTGRES_CUSTOM_CONFIGURATION)@${POSTGRES_CUSTOM_CONFIGURATION}@g" .env
sed -i "s@(PG_GRAPH_DATA_DIR)@${PG_GRAPH_DATA_DIR}@g" .env
sed -i "s@(PG_GRAPH_CSV_DIR)@${PG_GRAPH_CSV_DIR}@g" .env
sed -i "s@(PG_GRAPH_VERSION)@${PG_GRAPH_VERSION}@g" .env
export PG_GRAPH_CSV_DIR=${PG_GRAPH_CSV_DIR}
export POSTGRES_CUSTOM_CONFIGURATION=${POSTGRES_CUSTOM_CONFIGURATION}


echo "=============================================================="
echo "Setting docker environment"
echo "=============================================================="
sed -i "s@(PG_GRAPH_SHM_SIZE)@${shm_size}@g" scripts/vars.sh


echo "=============================================================="
echo "Create database container"
echo "=============================================================="
if [ $MODE = "init" ]; then
    pyenv local ${PYENV_NAME}
    chmod +x scripts/*.sh
    scripts/load-in-one-step.sh
    scripts/backup-database.sh
    pyenv local system
fi

if [ $MODE = "recycle" ]; then
    pyenv local ${PYENV_NAME}
    chmod +x scripts/*.sh
    scripts/restore-database.sh
    pyenv local system
fi