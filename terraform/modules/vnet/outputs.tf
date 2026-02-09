# Azure Cosmos DB
  output "cosmosdb_subnet_id" {
    description = "O ID da subnet onde o Private Endpoint do Cosmos DB será criado."
    value       = azurerm_subnet.cosmosdb_subnet.id
  }

  output "cosmosdb_private_dns_id" {
    description = "O ID do Private DNS Zone para o Cosmos DB."
    value       = azurerm_private_dns_zone.cosmosdb_private_dns.id
  }

