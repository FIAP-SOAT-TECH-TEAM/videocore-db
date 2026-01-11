# Azure PostgreSQL Flexible Server Elastic Cluster ainda não suportado pelo provider terraform azurerm
#https://github.com/hashicorp/terraform-provider-azurerm/issues/31212

# Não utilizamos Réplicas de leitura pois isso pode introduzir consistência eventual nos dados em cenários de alta carga de escrita
# https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-read-replicas#considerations

# Combinação PACELC esperada: P:C / E:C

resource "azurerm_postgresql_flexible_server" "psqlflexibleserver_order" {
  name                          = "${var.dns_prefix}-psqlflexibleserver-order"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.pgsql_flex_db_version
  administrator_login           = var.pgsql_flex_administrator_login
  administrator_password        = var.pgsql_flex_administrator_password
  storage_mb                    = var.pgsql_flex_db_storage_mb
  sku_name                      = var.pgsql_flex_db_sku_name
  delegated_subnet_id           = var.pgsql_flex_subnet_id
  private_dns_zone_id           = var.pgsql_flex_private_dns_zone_id
  public_network_access_enabled = false

  # Se a região der suporte a zonas de disponibilidade, os dados de backup serão armazenados no ZRS (armazenamento com redundância de zona) - o que não é o caso atualmente da região Brazil South
  # Por isso, a configuração de geo_redundant_backup_enabled está habilitada para garantir a replicação dos backups em uma região secundária
  # https://learn.microsoft.com/pt-br/azure/reliability/reliability-azure-database-postgresql#high-availability-features
  # https://learn.microsoft.com/pt-br/azure/reliability/reliability-azure-database-postgresql#geo-redundant-backup-and-restore
  # geo_redundant_backup_enabled  = true

  # high_availability {
  #   # ZoneRedudant temporariamente desabilitada bloqueado na região Brazil South
  #   # https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/overview#azure-regions
  #   mode = "SameZone"
  # }

  # Ignora alterações nessas propriedades para evitar recriações desnecessárias
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server#zone
  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "foodcore_pgsql_database_order" {
  name      = "${var.dns_prefix}-db-order"
  server_id = azurerm_postgresql_flexible_server.psqlflexibleserver_order.id
  collation = var.pgsql_flex_db_collation
  charset   = var.pgsql_flex_db_charset

  lifecycle {
    prevent_destroy = false # Permitir a destruição do banco de dados (apenas para fins da atividade)
  }
}

resource "azurerm_key_vault_secret" "pgsql_jdbc_url_order" {
  name         = "pgsql-jdbc-url-order"
  value        = local.pgsql_jdbc_url_order
  key_vault_id = var.akv_id

  tags = {
    microservice = "order"
    resource  = "postgresql"
  }

  depends_on = [ azurerm_postgresql_flexible_server_database.foodcore_pgsql_database_order ]
}

resource "azurerm_key_vault_secret" "pgsql_username_order" {
  name         = "pgsql-username-order"
  value        = var.pgsql_flex_administrator_login
  key_vault_id = var.akv_id

  tags = {
    microservice = "order"
    resource  = "postgresql"
  }

  depends_on = [ azurerm_postgresql_flexible_server_database.foodcore_pgsql_database_order ]
}

resource "azurerm_key_vault_secret" "pgsql_password_order" {
  name         = "pgsql-password-order"
  value        = var.pgsql_flex_administrator_password
  key_vault_id = var.akv_id

  tags = {
    microservice = "order"
    resource  = "postgresql"
  }

  depends_on = [ azurerm_postgresql_flexible_server_database.foodcore_pgsql_database_order ]
}