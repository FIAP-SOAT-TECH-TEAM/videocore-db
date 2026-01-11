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

# VNET
  variable "vnet_aks_node_subnet_prefix" {
    description = "Prefixo de endereço da subrede de nós do AKS"
    type        = list(string)
  }
  variable "vnet_name" {
    description = "Nome da rede virtual"
    type        = string
  }
  variable "vnet_id" {
    description = "ID da rede virtual"
    type        = string
  }
  variable "pgsql_flex_subnet_prefix" {
    description = "Prefixo de endereço da subrede para PostgreSQL Flexible Server"
    type        = list(string)
  }
  variable "cosmosdb_subnet_prefix" {
    description = "Prefixo de endereço da subrede para Azure Cosmos DB"
    type        = list(string)
  }