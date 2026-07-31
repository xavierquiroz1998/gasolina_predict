#!/bin/bash
set -e

echo "=========================================="
echo "  GasPredict Ecuador — Arranque unificado"
echo "=========================================="

# ── 1. PostgreSQL ─────────────────────────────
PG_VER=$(ls /etc/postgresql/ | head -1)
PGDATA="/var/lib/postgresql/${PG_VER}/main"
PG_HBA="/etc/postgresql/${PG_VER}/main/pg_hba.conf"

echo "[1/3] Iniciando PostgreSQL ${PG_VER}..."

# Ajustar pg_hba.conf para permitir login local sin password del OS
sed -i "s/^local.*all.*postgres.*peer/local all postgres trust/" $PG_HBA
sed -i "s/^local.*all.*all.*peer/local all all trust/" $PG_HBA

service postgresql start
sleep 4

# Crear usuario y BD si no existen
su -c "psql -tc \"SELECT 1 FROM pg_roles WHERE rolname='${POSTGRES_USER}'\" | grep -q 1 || psql -c \"CREATE USER ${POSTGRES_USER} WITH PASSWORD '${POSTGRES_PASSWORD}';\"" postgres
su -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname='${POSTGRES_DB}'\" | grep -q 1 || psql -c \"CREATE DATABASE ${POSTGRES_DB} OWNER ${POSTGRES_USER};\"" postgres
su -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_USER};\"" postgres
echo "[1/3] PostgreSQL listo."

# ── 2. Backend FastAPI ────────────────────────
echo "[2/3] Iniciando Backend FastAPI (puerto 8001)..."
cd /app/backend
uvicorn app.main:app --host 0.0.0.0 --port 8001 --log-level info &
BACKEND_PID=$!
echo "[2/3] Backend PID=${BACKEND_PID}"

# ── 3. Frontend Next.js ───────────────────────
echo "[3/3] Iniciando Frontend Next.js (puerto 3001)..."
cd /app/frontend
node server.js &
FRONTEND_PID=$!
echo "[3/3] Frontend PID=${FRONTEND_PID}"

echo "=========================================="
echo "  Todos los servicios corriendo:"
echo "  Frontend → http://localhost:3001"
echo "  Backend  → http://localhost:8001"
echo "  DB       → localhost:5432"
echo "=========================================="

# Mantener el contenedor vivo y manejar señales de cierre
trap "echo 'Deteniendo servicios...'; kill $BACKEND_PID $FRONTEND_PID; service postgresql stop; exit 0" SIGTERM SIGINT

# Esperar a que algún proceso muera (si muere, relanzar)
while true; do
    if ! kill -0 $BACKEND_PID 2>/dev/null; then
        echo "[WARN] Backend muerto, relanzando..."
        cd /app/backend
        uvicorn app.main:app --host 0.0.0.0 --port 8001 --log-level info &
        BACKEND_PID=$!
    fi
    if ! kill -0 $FRONTEND_PID 2>/dev/null; then
        echo "[WARN] Frontend muerto, relanzando..."
        cd /app/frontend
        node server.js &
        FRONTEND_PID=$!
    fi
    sleep 10
done
