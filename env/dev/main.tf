module "rg_group" {
  source   = "../../modules/az_rg"
  rg_names = var.rg_map
}

module "vnet_group" {
  depends_on = [module.rg_group]
  source     = "../../modules/az_vnet"
  vnet       = var.vnet_map
}

module "subnet_group" {
  depends_on = [module.vnet_group]
  source     = "../../modules/az_subnet"
  subnets    = var.subnet_map
}

module "log_analytics_group" {
  depends_on               = [module.rg_group]
  source                   = "../../modules/az_log_analytics"
  log_analytics_workspaces = var.log_analytics_map
}

module "acr_group" {
  depends_on           = [module.rg_group]
  source               = "../../modules/az_acr"
  container_registries = var.acr_map
}

module "aks_group" {
  depends_on = [
    module.subnet_group,
    module.log_analytics_group,
    module.acr_group
  ]
  source = "../../modules/az_aks"

  aks_clusters = {
    for k, v in var.aks_map : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      dns_prefix          = v.dns_prefix
      kubernetes_version  = v.kubernetes_version

      node_pool_name      = v.node_pool_name
      node_count          = v.node_count
      vm_size             = v.vm_size
      vnet_subnet_id      = v.subnet_key != null ? module.subnet_group.subnet_ids[v.subnet_key] : null
      os_disk_size_gb     = v.os_disk_size_gb
      enable_auto_scaling = v.enable_auto_scaling
      min_count           = v.min_count
      max_count           = v.max_count

      network_plugin = v.network_plugin
      network_policy = v.network_policy
      dns_service_ip = v.dns_service_ip
      service_cidr   = v.service_cidr

      log_analytics_workspace_id = v.log_analytics_key != null ? module.log_analytics_group.log_analytics_workspace_ids[v.log_analytics_key] : null
      attach_acr                 = v.acr_key != null
      acr_id                     = v.acr_key != null ? module.acr_group.acr_ids[v.acr_key] : null
      tags                       = v.tags
    }
  }
}
