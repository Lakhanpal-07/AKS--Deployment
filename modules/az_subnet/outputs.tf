output "subnets" {
  value = azurerm_subnet.tf_subnet
}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.tf_subnet : k => v.id }
}
