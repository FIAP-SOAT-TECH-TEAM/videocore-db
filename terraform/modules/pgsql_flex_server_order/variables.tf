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

# PostgreSQL Flexible Server

  variable "pgsql_flex_db_charset" {
    type        = string
    description = "Charset do banco de dados"
  }

  variable "pgsql_flex_db_collation" {
    type        = string
    description = "Collation do banco de dados"
  }

  variable "pgsql_flex_db_version" {
    type        = string
    description = "Versão do banco de dados"
  }

  variable "pgsql_flex_administrator_login" {
    type        = string
    description = "Login do administrador do banco de dados"
  }

  variable "pgsql_flex_administrator_password" {
    type        = string
    description = "Senha do administrador do banco de dados"
  }

  variable "pgsql_flex_db_storage_mb" {
    type        = number
    description = "Tamanho do armazenamento do banco de dados em MB"
  }

  variable "pgsql_flex_db_sku_name" {
    type        = string
    description = "SKU do banco de dados"
  }

# VNET
  variable "pgsql_flex_subnet_id" {
    description = "ID da subrede do banco de dados"
    type        = string
  }

  variable "pgsql_flex_private_dns_zone_id" {
    description = "ID da zona DNS privada"
    type        = string
  }