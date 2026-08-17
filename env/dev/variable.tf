variable "rg_map" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "vnet_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
  }))
}

variable "subnet_map" {
  type = map(object({
    name                 = string
    virtual_network_name = string
    resource_group_name  = string
    address_prefixes     = list(string)
  }))
}

variable "log_analytics_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = optional(string, "PerGB2018")
    retention_in_days   = optional(number, 30)
  }))
  default = {}
}

variable "acr_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = optional(string, "Basic")
    admin_enabled       = optional(bool, false)
  }))
  default = {}
}

variable "aks_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    dns_prefix          = string
    kubernetes_version  = optional(string)

    node_pool_name      = optional(string, "default")
    node_count          = optional(number, 2)
    vm_size             = optional(string, "Standard_D2s_v7")
    subnet_key          = optional(string)
    os_disk_size_gb     = optional(number, 30)
    enable_auto_scaling = optional(bool, true)
    min_count           = optional(number, 1)
    max_count           = optional(number, 3)

    network_plugin = optional(string, "azure")
    network_policy = optional(string, "azure")
    dns_service_ip = optional(string, "10.0.0.10")
    service_cidr   = optional(string, "10.0.0.0/16")

    log_analytics_key = optional(string)
    acr_key           = optional(string)
    tags              = optional(map(string), {})
  }))
  default = {}
}
