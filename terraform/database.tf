resource "azurerm_mssql_server" "sql" {
  name                         = "sql-talha-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "db" {
  name      = "appdb-${var.environment}"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "S2"
}

resource "azurerm_mssql_server" "sql_secondary" {
  name                         = "sql-talha-${var.environment}-dr"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.dr_location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_failover_group" "failover" {
  name      = "failover-${var.environment}"
  server_id = azurerm_mssql_server.sql.id
  databases = [azurerm_mssql_database.db.id]
  
  partner_servers {
    id = azurerm_mssql_server.sql_secondary.id
  }
  
  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}
