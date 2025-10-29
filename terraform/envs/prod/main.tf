locals {
  prefix = var.prefix
}






resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}


module "network" {
  source       = "../../modules/network"
  rg_name      = azurerm_resource_group.rg.name
  location     = var.location
  vnet_name    = var.vnet_name
  address_space= var.address_space
  subnets      = var.subnets
}


module "aks" {
  source = "../../modules/aks"
  rg_name = azurerm_resource_group.rg.name
  location = var.location
  name = "${local.prefix}-aks"
  subnet_id = module.network.subnet_ids["aks"]
  node_count = var.aks_node_count
  node_vm_size = var.aks_node_vm_size
  
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}