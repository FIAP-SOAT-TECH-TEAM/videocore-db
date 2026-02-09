#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

echo "===== Reiniciando banco de dados ====="

# Verificar se o Docker está rodando
docker info &>/dev/null
if [ $? -ne 0 ]; then
  echo "ERRO: O Docker não está rodando."
  exit 1
fi

# Parar o banco de dados
echo "-> Parando banco de dados atual..."
"$SCRIPT_DIR/infra-down.sh"

if [ $? -ne 0 ]; then
  echo "AVISO: Problemas ao parar o banco, tentando continuar..."
fi

sleep 2

# Opção de forçar reinício
FORCE=""
if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  FORCE="--force"
fi

# Iniciar o banco de dados novamente
echo "-> Iniciando banco de dados..."
"$SCRIPT_DIR/infra-up.sh" $FORCE