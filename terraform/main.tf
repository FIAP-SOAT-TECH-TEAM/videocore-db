module "vnet" {
  source                      = "./modules/vnet"
  dns_prefix                  = data.terraform_remote_state.infra.outputs.dns_prefix
  location                    = data.terraform_remote_state.infra.outputs.location
  vnet_aks_node_subnet_prefix = data.terraform_remote_state.infra.outputs.vnet_aks_node_subnet_prefix
  resource_group_name         = data.terraform_remote_state.infra.outputs.resource_group_name
  vnet_name                   = data.terraform_remote_state.infra.outputs.vnet_name
  vnet_id                     = data.terraform_remote_state.infra.outputs.vnet_id
  pgsql_flex_subnet_prefix    = var.pgsql_flex_subnet_prefix
  cosmosdb_subnet_prefix      = var.cosmosdb_subnet_prefix
}

module "pgsql_flex_server_catalog" {
  source                              = "./modules/pgsql_flex_server_catalog"
  dns_prefix                          = data.terraform_remote_state.infra.outputs.dns_prefix
  resource_group_name                 = data.terraform_remote_state.infra.outputs.resource_group_name
  location                            = data.terraform_remote_state.infra.outputs.location
  akv_id                              = data.terraform_remote_state.infra.outputs.akv_id
  pgsql_flex_subnet_id                = module.vnet.pgsql_flex_subnet_id
  pgsql_flex_private_dns_zone_id      = module.vnet.pgsql_flex_private_dns_id
  pgsql_flex_db_charset               = var.pgsql_flex_db_charset
  pgsql_flex_db_collation             = var.pgsql_flex_db_collation
  pgsql_flex_db_version               = var.pgsql_flex_db_version
  pgsql_flex_administrator_login      = var.pgsql_flex_administrator_login
  pgsql_flex_administrator_password   = var.pgsql_flex_administrator_password
  pgsql_flex_db_storage_mb            = var.pgsql_flex_db_storage_mb
  pgsql_flex_db_sku_name              = var.pgsql_flex_db_sku_name
}

module "pgsql_flex_server_order" {
  source                              = "./modules/pgsql_flex_server_order"
  dns_prefix                          = data.terraform_remote_state.infra.outputs.dns_prefix
  resource_group_name                 = data.terraform_remote_state.infra.outputs.resource_group_name
  location                            = data.terraform_remote_state.infra.outputs.location
  akv_id                              = data.terraform_remote_state.infra.outputs.akv_id 
  pgsql_flex_subnet_id                = module.vnet.pgsql_flex_subnet_id
  pgsql_flex_private_dns_zone_id      = module.vnet.pgsql_flex_private_dns_id
  pgsql_flex_db_charset               = var.pgsql_flex_db_charset
  pgsql_flex_db_collation             = var.pgsql_flex_db_collation
  pgsql_flex_db_version               = var.pgsql_flex_db_version
  pgsql_flex_administrator_login      = var.pgsql_flex_administrator_login
  pgsql_flex_administrator_password   = var.pgsql_flex_administrator_password
  pgsql_flex_db_storage_mb            = var.pgsql_flex_db_storage_mb
  pgsql_flex_db_sku_name              = var.pgsql_flex_db_sku_name 
}

module "cosmosdb_payment" {
  source                        = "./modules/azure_cosmos_db_payment"
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