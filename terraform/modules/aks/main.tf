

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = var.name

  default_node_pool {
    name       = "agentpool"
    vm_size    = var.node_vm_size
    node_count = var.node_count
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }


}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}