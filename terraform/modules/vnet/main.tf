resource "azurerm_subnet" "cosmosdb_subnet" {
  name                 = "${var.dns_prefix}-cosmosdb-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.cosmosdb_subnet_prefix
}

resource "azurerm_private_dns_zone" "cosmosdb_private_dns" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb_vnet_link" {
  name                  = "${var.dns_prefix}-cosmosdb-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmosdb_private_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_network_security_group" "cosmosdb_nsg" {
  name                = "${var.dns_prefix}-cosmosdb-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowCosmosdbIngress"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.vnet_aks_node_subnet_prefix[0]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "cosmosdb_nsg_association" {
  subnet_id                 = azurerm_subnet.cosmosdb_subnet.id
  network_security_group_id = azurerm_network_security_group.cosmosdb_nsg.id
}