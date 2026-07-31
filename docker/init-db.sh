#!/bin/bash
# Inicializa PostgreSQL si no existe data directory previo

PG_VERSION=$(pg_lsclusters -h | awk 'NR==1{print $1}')
PG_CLUSTER="main"
PGDATA="/var/lib/postgresql/${PG_VERSION}/${PG_CLUSTER}"

# Iniciar cluster si no existe
if [ ! -f "$PGDATA/PG_VERSION" ]; then
    echo "[init-db] Inicializando cluster PostgreSQL..."
    pg_ctlcluster $PG_VERSION $PG_CLUSTER start
    sleep 3

    echo "[init-db] Creando usuario y base de datos..."
    su -c "psql -c \"CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';\"" postgres
    su -c "psql -c \"CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;\"" postgres
    su -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;\"" postgres
    echo "[init-db] BD lista."
else
    echo "[init-db] Data directory existe, arrancando cluster..."
    pg_ctlcluster $PG_VERSION $PG_CLUSTER start
    sleep 2
fi
