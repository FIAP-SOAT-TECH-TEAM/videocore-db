#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

echo "===== Iniciando banco de dados ====="

# Verificar se o Docker está rodando
if ! docker info &>/dev/null; then
  echo "ERRO: O Docker não está rodando."
  exit 1
fi

cd "$PROJECT_ROOT/docker" || exit 1

# Verificar se já existe container do banco rodando
RUNNING_DB=$(docker ps --filter "name=videocore-reports-ms-db" --format "{{.Names}}")

if [ -n "$RUNNING_DB" ]; then
  echo "AVISO: O container do banco já está em execução: $RUNNING_DB"

  if [ "$1" != "--force" ]; then
    read -r -p "Deseja reiniciar o container do banco? (s/n): " resposta
    if [[ ! "$resposta" =~ ^[Ss]$ ]]; then
      echo "Operação cancelada."
      exit 0
    fi
  fi

  echo "-> Parando container existente..."
  docker-compose stop reports-ms-db
fi

# Iniciar o Cosmos DB Emulator
echo "-> Iniciando Cosmos DB Emulator..."
docker-compose up -d reports-ms-db

# Verificar se o Cosmos DB Emulator está pronto
echo "-> Verificando status do Cosmos DB Emulator..."
MAX_RETRIES=120
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    # Verifica se a porta do Data Explorer está respondendo
    if curl -k -f https://localhost:8079/_explorer/emulator.pem &> /dev/null; then
        echo "-> Cosmos DB Emulator está pronto!"
        echo ""
        echo "====== Instruções para configuração do certificado (Powershell - Administrador) ======"
        echo "-> Baixe o certificado;"
        echo "-> Importe o certificado para o Truststore da JVM;"
        echo "-> Exclua o arquivo de certificado baixado."
        echo ""
        echo "Exclua certificado antigo, se existir: keytool -delete -alias videocorereportsCosmosEmulator -cacerts -storepass changeit"
        echo "Comando: curl --insecure https://localhost:8079/_explorer/emulator.pem > ~/videocore_reports_az_cosmos_emulator.crt && keytool -importcert -file videocore_reports_az_cosmos_emulator.crt -alias videocorereportsCosmosEmulator -cacerts -storepass changeit --noprompt && rm videocore_reports_az_cosmos_emulator.crt"
        echo "Observação: lembre-se de declarar a variável JAVA_HOME no seu ambiente, e acrescentar a pasta JAVA_HOME/bin ao PATH."
        echo ""
        break
    fi

    RETRY_COUNT=$((RETRY_COUNT+1))
    echo "Aguardando Cosmos DB inicializar... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "AVISO: Tempo limite excedido aguardando o Cosmos DB inicializar. Verifique a situação manualmente."
fi

echo "===== Banco de dados iniciado com sucesso! ====="
echo "Acesso: https://localhost:8079/_explorer/index.html (Azure CosmosDB Emulator Data Explorer)"