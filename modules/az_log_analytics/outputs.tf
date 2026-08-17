output "log_analytics_workspaces" {
  value = azurerm_log_analytics_workspace.tf_law
}

output "log_analytics_workspace_ids" {
  value = { for k, v in azurerm_log_analytics_workspace.tf_law : k => v.id }
}
