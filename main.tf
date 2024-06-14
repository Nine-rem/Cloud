resource "azurerm_resource_group" "rg" { //nom du groupe dans terraform, une fois déployé on ne peut pas changer le nom
  name     = "mathist" 
  location = "West Europe"
}


resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = "${var.my_name}logworkspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
resource "azurerm_log_analytics_workspace_table" "log_analytics" {
  workspace_id            = azurerm_log_analytics_workspace.log_workspace.id
  name                    = "AppMetrics"
  retention_in_days       = 60
  total_retention_in_days = 180
}





resource "azurerm_monitor_diagnostic_setting" "diag_settings" {
  name               = "example"
  target_resource_id = azurerm_key_vault.kv.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_workspace.id

  enabled_log {
    category = "AuditEvent"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}