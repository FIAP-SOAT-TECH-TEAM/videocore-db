#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

echo "===== Parando banco de dados ====="

# Verificar se o Docker está rodando
docker info &>/dev/null
if [ $? -ne 0 ]; then
  echo "ERRO: O Docker não está rodando."
  exit 1
fi

cd "$PROJECT_ROOT/docker"

# Verificar se o contêiner do banco está rodando
DB_CONTAINER=$(docker ps --filter "name=videocore-reports-ms-db" --format "{{.Names}}")

if [ -z "$DB_CONTAINER" ]; then
  echo "Nenhum contêiner do banco em execução."
  exit 0
fi

echo "Contêiner do banco em execução: $DB_CONTAINER"
echo "-> Parando contêiner..."
docker-compose stop reports-ms-db

# Verificação final
STILL_RUNNING=$(docker ps --filter "name=videocore-reports-ms-db" --format "{{.Names}}")
if [ -z "$STILL_RUNNING" ]; then
  echo "===== Banco de dados parado com sucesso! ====="
else
  echo "ERRO: Não foi possível parar o contêiner do banco."
fi