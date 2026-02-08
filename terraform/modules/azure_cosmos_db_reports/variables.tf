# Common
  variable "dns_prefix" {
    type = string
    description = "Prefixo DNS para a conta de armazenamento. Deve ser único globalmente."
    
    validation {
      condition     = length(var.dns_prefix) >= 1 && length(var.dns_prefix) <= 54
      error_message = "O 'dns_prefix' deve ter entre 1 e 54 caracteres."
    }
  }
  variable "resource_group_name" {
    type = string
    description = "Nome do resource group"
    
    validation {
      condition = can(regex("^[a-zA-Z0-9]+$", var.resource_group_name))
      error_message = "O nome do resource group deve conter apenas letras e números."
    }
  }
  variable "location" {
    description = "Localização do recurso"
    type = string
  }

# AKV
  variable "akv_id" {
    type        = string
    description = "ID do Azure Key Vault"
  }

# Cosmos DB
  variable "az_cosmos_db_ha_location" {
    type        = string
    description = "A localização secundária para alta disponibilidade do Cosmos DB."
  }
  variable "azcosmosdb_offer_type" {
    type        = string
    description = "O tipo de oferta para a conta do Cosmos DB. Exemplo: Standard."
  }
  variable "azcosmosdb_kind" {
    type        = string
    description = "O tipo de conta do Cosmos DB. Exemplo: GlobalDocumentDB, MongoDB, Cassandra, Gremlin, Table."
  }
  variable "azcosmosdb_automatic_failover" {
      type = bool
      description = "Habilita ou desabilita o failover automático para a conta do Cosmos DB."
  }
  variable "azcosmosdb_failover_priority" {
      type = number
      description = "Define a prioridade de failover para a localização secundária do Cosmos DB."
  }
  variable "azcosmosdb_consistency_level" {
    type        = string
    description = "O nível de consistência para a conta do Cosmos DB. Exemplo: Eventual, Session, BoundedStaleness, Strong, ConsistentPrefix."
  }
  variable "azcosmosdb_subnet_id" {
    type        = string
    description = "O ID da subnet onde o Private Endpoint do Cosmos DB será criado."
  }
  variable "azcosmosdb_private_dns_id" {
    type        = string
    description = "O ID da zona DNS privada para o Private Endpoint do Cosmos DB."
  }
