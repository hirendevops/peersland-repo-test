location = "eastus"
prefix = "demo"
rg_name = "demo-np-rg"

storage_account_name = "peerstateterraform"
container_name = "tfstate"

vnet_name = "demo-np-vnet"
address_space = ["10.1.0.0/16"]
subnets = {
aks = { cidr = "10.1.1.0/24" }
app = { cidr = "10.1.2.0/24" }
}

aks_node_count = 1
aks_node_vm_size = "Standard_D2s_v3"
