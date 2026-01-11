#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

echo "===== Iniciando banco de dados ====="

# Verificar se o Docker está rodando
docker info &>/dev/null
if [ $? -ne 0 ]; then
  echo "ERRO: O Docker não está rodando."
  exit 1
fi

cd "$PROJECT_ROOT/docker"

# Verificar se já existe container do banco rodando
RUNNING_DB=$(docker ps --filter "name=videocore-reports-ms-db" --format "{{.Names}}")

if [ -n "$RUNNING_DB" ]; then
  echo "AVISO: O container do banco já está em execução: $RUNNING_DB"

  if [ "$1" != "--force" ]; then
    read -p "Deseja reiniciar o container do banco? (s/n): " resposta
    if [[ ! "$resposta" =~ ^[Ss]$ ]]; then
      echo "Operação cancelada."
      exit 0
    fi
  fi

  echo "-> Parando container existente..."
  docker-compose stop reports-ms-db
fi

# Iniciar o PostgreSQL
echo "-> Iniciando PostgreSQL..."
docker-compose up -d reports-ms-db

# Verificar se o PostgreSQL está pronto
echo "-> Verificando status do PostgreSQL..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if docker-compose exec reports-ms-db pg_isready -q; then
        echo "-> PostgreSQL está pronto!"
        break
    fi

    RETRY_COUNT=$((RETRY_COUNT+1))
    echo "Aguardando PostgreSQL inicializar... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "AVISO: Tempo limite excedido aguardando o PostgreSQL inicializar"
fi

echo "===== Banco de dados iniciado com sucesso! ====="
echo "Acesso: localhost:5432 (usuário: postgres)"