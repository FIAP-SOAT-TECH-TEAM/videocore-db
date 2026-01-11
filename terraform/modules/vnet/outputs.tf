# PGSql Flexible Server
  output "pgsql_flex_subnet_id" {
    description = "O ID da subnet delegada para o PGSql Flexible Server."
    value       = azurerm_subnet.pgsql_flex_subnet.id
  }

  output "pgsql_flex_private_dns_id" {
    description = "O ID do Private DNS Zone para o PGSql Flexible Server."
    value       = azurerm_private_dns_zone.pgsql_flex_private_dns.id
  }
  

# Azure Cosmos DB
  output "cosmosdb_subnet_id" {
    description = "O ID da subnet onde o Private Endpoint do Cosmos DB será criado."
    value       = azurerm_subnet.cosmosdb_subnet.id
  }

  output "cosmosdb_private_dns_id" {
    description = "O ID do Private DNS Zone para o Cosmos DB."
    value       = azurerm_private_dns_zone.cosmosdb_private_dns.id
  }

