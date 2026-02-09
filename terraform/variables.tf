# Commn
  variable "subscription_id" {
    type        = string
    description = "Azure Subscription ID"
  }

# remote states
  variable "videocore-backend-resource-group" {
    type        = string
    description = "Nome do resource group onde o backend está armazenado"
  }

  variable "videocore-backend-storage-account" {
    type        = string
    description = "Nome da conta de armazenamento onde o backend está armazenado"
  }

  variable "videocore-backend-container" {
    type        = string
    description = "Nome do contêiner onde o backend está armazenado"
  }

  variable "videocore-backend-infra-key" {
    type        = string
    description = "Chave do arquivo tfstate do videocore-infra"
  }

# Cosmos DB

  variable "az_cosmos_db_ha_location" {
    type        = string
    description = "A localização secundária para alta disponibilidade do Cosmos DB."
    default     = "westus3"
  }

  variable "azcosmosdb_offer_type" {
    type        = string
    description = "O tipo de oferta para a conta do Cosmos DB. Exemplo: Standard."
    default     = "Standard"
  }

  variable "azcosmosdb_kind" {
    type        = string
    description = "O tipo de conta do Cosmos DB. Exemplo: GlobalDocumentDB, MongoDB, Cassandra, Gremlin, Table."
    default     = "GlobalDocumentDB"
  }

  variable "azcosmosdb_automatic_failover" {
    type        = bool
    description = "Habilita ou desabilita o failover automático para a conta do Cosmos DB."
    default     = true
  }

  variable "azcosmosdb_failover_priority" {
    type        = number
    description = "Define a prioridade de failover para a localização secundária do Cosmos DB."
    default     = 0
  }

  variable "azcosmosdb_consistency_level" {
    type        = string
    description = "O nível de consistência para a conta do Cosmos DB. Exemplo: Eventual, Session, BoundedStaleness, Strong, ConsistentPrefix."
    default     = "Session"
  }

# VNET

  variable "cosmosdb_subnet_prefix" {
    description = "Prefixo de endereço da subrede para Azure Cosmos DB"
    type        = list(string)
    default     = ["10.0.7.0/24"]
  }
  