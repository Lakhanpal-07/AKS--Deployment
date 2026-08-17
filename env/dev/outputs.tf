output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks_group.aks_cluster_names
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = module.aks_group.aks_cluster_ids
}

output "acr_login_server" {
  description = "The login server for the Azure Container Registry"
  value       = module.acr_group.acr_login_servers
}

output "aks_get_credentials_command" {
  description = "Command to get kubeconfig credentials for the AKS cluster"
  value = {
    for k, v in var.aks_map : k => "az aks get-credentials --resource-group ${v.resource_group_name} --name ${v.name}"
  }
}
