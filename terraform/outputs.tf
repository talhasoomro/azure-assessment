output "webapp_name" {
  description = "Name of the deployed Azure Web App"
  value       = azurerm_linux_web_app.app.name
}

output "resource_group_name" {
  description = "Resource group containing all resources"
  value       = azurerm_resource_group.rg.name
}
