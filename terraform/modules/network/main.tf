

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  for_each            = var.subnets
  name                = each.key
  resource_group_name = var.rg_name
  virtual_network_name= azurerm_virtual_network.vnet.name
  address_prefixes    = [each.value.cidr]
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "subnet_ids" {
  value = { for k, s in azurerm_subnet.subnet : k => s.id }
}