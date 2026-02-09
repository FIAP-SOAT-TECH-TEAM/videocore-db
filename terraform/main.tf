module "vnet" {
  source                      = "./modules/vnet"
  dns_prefix                  = data.terraform_remote_state.infra.outputs.dns_prefix
  location                    = data.terraform_remote_state.infra.outputs.location
  vnet_aks_node_subnet_prefix = data.terraform_remote_state.infra.outputs.vnet_aks_node_subnet_prefix
  resource_group_name         = data.terraform_remote_state.infra.outputs.resource_group_name
  vnet_name                   = data.terraform_remote_state.infra.outputs.vnet_name
  vnet_id                     = data.terraform_remote_state.infra.outputs.vnet_id
  cosmosdb_subnet_prefix      = var.cosmosdb_subnet_prefix
}

module "cosmosdb_reports" {
  source                        = "./modules/azure_cosmos_db_reports"
  dns_prefix                    = data.terraform_remote_state.infra.outputs.dns_prefix
  resource_group_name           = data.terraform_remote_state.infra.outputs.resource_group_name
  location                      = data.terraform_remote_state.infra.outputs.location
  akv_id                        = data.terraform_remote_state.infra.outputs.akv_id
  az_cosmos_db_ha_location      = var.az_cosmos_db_ha_location
  azcosmosdb_subnet_id          = module.vnet.cosmosdb_subnet_id
  azcosmosdb_private_dns_id     = module.vnet.cosmosdb_private_dns_id
  azcosmosdb_automatic_failover = var.azcosmosdb_automatic_failover
  azcosmosdb_consistency_level  = var.azcosmosdb_consistency_level
  azcosmosdb_failover_priority  = var.azcosmosdb_failover_priority
  azcosmosdb_offer_type         = var.azcosmosdb_offer_type
  azcosmosdb_kind               = var.azcosmosdb_kind
}