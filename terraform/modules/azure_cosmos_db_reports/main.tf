# Combinação PACELC esperada: P:A / E:L

resource "azurerm_cosmosdb_account" "azcosmosdb_account_reports" {
  name                          = "${var.dns_prefix}-azcomosdb-account-reports"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  offer_type                    = var.azcosmosdb_offer_type
  kind                          = var.azcosmosdb_kind
  automatic_failover_enabled    = var.azcosmosdb_automatic_failover
  public_network_access_enabled = false
  
  geo_location {
    location          = var.location
    failover_priority = 0
    # Evitar erros de: "Sorry, we are currently experiencing high demand in ... region for the zonal redundant (Availability Zones) accounts, and cannot fulfill your..."
    # Apenas para fins de atividade
    zone_redundant    = false
  }

  # geo_location {
  #   location          = var.az_cosmos_db_ha_location
  #   failover_priority = 1
  #   # Evitar erros de: "Sorry, we are currently experiencing high demand in ... region for the zonal redundant (Availability Zones) accounts, and cannot fulfill your..."
  #   # Apenas para fins de atividade
  #   zone_redundant    = false
  # }

  # Serverless suporta apenas uma região
  # https://learn.microsoft.com/en-us/azure/cosmos-db/serverless#use-serverless-resources
  # capabilities {
  #   name = "EnableServerless"
  # }

  consistency_policy {
    consistency_level = var.azcosmosdb_consistency_level
  }
}

resource "azurerm_cosmosdb_sql_database" "azcosmosdb_db_reports" {
  name                = "${var.dns_prefix}-db-reports"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.azcosmosdb_account_reports.name
}

resource "azurerm_private_endpoint" "cosmosdb_private_endpoint" {
  name                = "${var.dns_prefix}-cosmosdb-reports-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.azcosmosdb_subnet_id

  private_service_connection {
    name                           = "${var.dns_prefix}-cosmosdb-reports-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.azcosmosdb_account_reports.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.dns_prefix}-cosmosdb-reports-dns-zone-group"
    private_dns_zone_ids = [
      var.azcosmosdb_private_dns_id
    ]
  }
}

resource "azurerm_key_vault_secret" "cosmosdb_uri" {
  name         = "az-cosmosdb-uri"
  value        = azurerm_cosmosdb_account.azcosmosdb_account_reports.endpoint
  key_vault_id = var.akv_id

  tags = {
    microservice = "reports"
    resource  = "cosmosdb"
  }
}

resource "azurerm_key_vault_secret" "cosmosdb_database" {
  name         = "az-cosmosdb-database"
  value        = azurerm_cosmosdb_sql_database.azcosmosdb_db_reports.name
  key_vault_id = var.akv_id

  tags = {
    microservice = "reports"
    resource  = "cosmosdb"
  }
}

resource "azurerm_key_vault_secret" "cosmosdb_key" {
  name         = "az-cosmosdb-key"
  value        = azurerm_cosmosdb_account.azcosmosdb_account_reports.primary_key
  key_vault_id = var.akv_id

  tags = {
    microservice = "reports"
    resource  = "cosmosdb"
  }
}