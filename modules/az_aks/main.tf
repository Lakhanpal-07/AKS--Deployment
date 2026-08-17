variable "aks_clusters" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    dns_prefix          = string
    kubernetes_version  = optional(string)

    # Node Pool settings
    node_pool_name      = optional(string, "default")
    node_count          = optional(number, 2)
    vm_size             = optional(string, "Standard_D2s_v7")
    vnet_subnet_id      = optional(string)
    os_disk_size_gb     = optional(number, 30)
    enable_auto_scaling = optional(bool, true)
    min_count           = optional(number, 1)
    max_count           = optional(number, 3)

    # Networking settings
    network_plugin = optional(string, "azure")
    network_policy = optional(string, "azure")
    dns_service_ip = optional(string, "10.0.0.10")
    service_cidr   = optional(string, "10.0.0.0/16")

    # Integrations
    log_analytics_workspace_id = optional(string)
    acr_id                     = optional(string)
    attach_acr                 = optional(bool, false)
    tags                       = optional(map(string), {})
  }))
}

resource "azurerm_kubernetes_cluster" "tf_aks" {
  for_each            = var.aks_clusters
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version

  default_node_pool {
    name                 = each.value.node_pool_name
    node_count           = each.value.enable_auto_scaling ? null : each.value.node_count
    vm_size              = each.value.vm_size
    vnet_subnet_id       = each.value.vnet_subnet_id
    os_disk_size_gb      = each.value.os_disk_size_gb
    auto_scaling_enabled = each.value.enable_auto_scaling
    min_count            = each.value.enable_auto_scaling ? each.value.min_count : null
    max_count            = each.value.enable_auto_scaling ? each.value.max_count : null
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = each.value.network_plugin
    network_policy = each.value.network_policy
    dns_service_ip = each.value.dns_service_ip
    service_cidr   = each.value.service_cidr
  }

  dynamic "oms_agent" {
    for_each = each.value.log_analytics_workspace_id != null ? [each.value.log_analytics_workspace_id] : []
    content {
      log_analytics_workspace_id = oms_agent.value
    }
  }

  tags = each.value.tags
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  for_each = {
    for k, v in var.aks_clusters : k => v
    if v.attach_acr
  }

  principal_id                     = azurerm_kubernetes_cluster.tf_aks[each.key].kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = each.value.acr_id
  skip_service_principal_aad_check = true
}
