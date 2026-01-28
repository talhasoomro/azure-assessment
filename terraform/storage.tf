resource "azurerm_storage_account" "backup" {
  name                     = "stbackup${var.environment}talha2024" 
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}
