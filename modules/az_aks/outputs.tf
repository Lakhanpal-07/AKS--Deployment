output "aks_clusters" {
  value     = azurerm_kubernetes_cluster.tf_aks
  sensitive = true
}

output "aks_cluster_ids" {
  value = { for k, v in azurerm_kubernetes_cluster.tf_aks : k => v.id }
}

output "aks_cluster_names" {
  value = { for k, v in azurerm_kubernetes_cluster.tf_aks : k => v.name }
}

output "aks_kube_config_raw" {
  value     = { for k, v in azurerm_kubernetes_cluster.tf_aks : k => v.kube_config_raw }
  sensitive = true
}

output "aks_kubelet_identity_object_id" {
  value = { for k, v in azurerm_kubernetes_cluster.tf_aks : k => v.kubelet_identity[0].object_id }
}
