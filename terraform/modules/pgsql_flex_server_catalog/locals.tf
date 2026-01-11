locals {
    pgsql_jdbc_url_catalog = "jdbc:postgresql://${azurerm_postgresql_flexible_server.psqlflexibleserver_catalog.fqdn}:5432/${azurerm_postgresql_flexible_server_database.foodcore_pgsql_database_catalog.name}?user=${var.pgsql_flex_administrator_login}&password=${var.pgsql_flex_administrator_password}"   
}