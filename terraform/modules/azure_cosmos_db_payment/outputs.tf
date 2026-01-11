output "azcosmosdb_endpoint_payment" {
  description = "Endpoint URI do Cosmos DB"
  value       = azurerm_cosmosdb_account.azcosmosdb_account_payment.endpoint
}

output "azcosmosdb_database_payment" {
  description = "Nome do banco de dados Cosmos DB"
  value       = azurerm_cosmosdb_sql_database.azcosmosdb_db_payment.name
}

output "azcosmosdb_key_payment" {
  description = "Cosmos DB primary master key"
  value       = azurerm_cosmosdb_account.azcosmosdb_account_payment.primary_key
  sensitive   = true
}