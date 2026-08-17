variable "rg_names" {
  type = map(object({
    name     = string
    location = string
  }))
}

resource "azurerm_resource_group" "tf_rg" {
  for_each = var.rg_names
  name     = each.value.name
  location = each.value.location

}
