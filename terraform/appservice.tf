resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "app" {
  name                      = "webapp-talha-${var.environment}"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  service_plan_id           = azurerm_service_plan.plan.id
  virtual_network_subnet_id = azurerm_subnet.app.id
  
  identity {
    type = "SystemAssigned"
  }
  
  site_config {
    always_on = true
    application_stack {
      node_version = "18-lts"
    }
  }

  connection_string {
    name  = "Database"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.db.name};User ID=sqladmin;Password=${var.sql_password};Encrypt=true;TrustServerCertificate=false;"
  }
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "autoscale-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  target_resource_id  = azurerm_service_plan.plan.id

  profile {
    name = "defaultProfile"
    capacity {
      default = 2
      minimum = 2
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
