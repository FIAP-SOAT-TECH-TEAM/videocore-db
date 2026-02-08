output "azcosmosdb_endpoint_reports" {
  description = "Endpoint URI do Cosmos DB"
  value       = azurerm_cosmosdb_account.azcosmosdb_account_reports.endpoint
}

output "azcosmosdb_database_reports" {
  description = "Nome do banco de dados Cosmos DB"
  value       = azurerm_cosmosdb_sql_database.azcosmosdb_db_reports.name
}

output "azcosmosdb_key_reports" {
  description = "Cosmos DB primary master key"
  value       = azurerm_cosmosdb_account.azcosmosdb_account_reports.primary_key
  sensitive   = true
}