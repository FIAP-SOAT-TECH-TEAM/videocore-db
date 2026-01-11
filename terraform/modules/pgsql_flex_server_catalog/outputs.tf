output "jdbc_pgsql_uri_catalog" {
  value = "jdbc:postgresql://${azurerm_postgresql_flexible_server.psqlflexibleserver_catalog.fqdn}:5432/${azurerm_postgresql_flexible_server_database.foodcore_pgsql_database_catalog.name}?user=${var.pgsql_flex_administrator_login}&password=${var.pgsql_flex_administrator_password}"
  sensitive = true
}

output "pgsql_fqdn_catalog" {
  value = azurerm_postgresql_flexible_server.psqlflexibleserver_catalog.fqdn
}

output "pgsql_database_name_catalog" {
  value = azurerm_postgresql_flexible_server_database.foodcore_pgsql_database_catalog.name
  sensitive = true
}

output "pgsql_admin_username_catalog" {
  value = var.pgsql_flex_administrator_login
  sensitive = true
}

output "pgsql_admin_password_catalog" {
  value = var.pgsql_flex_administrator_password
  sensitive = true
}