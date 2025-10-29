variable "location" { type = string }
variable "prefix" { type = string }
variable "rg_name" { type = string }


variable "storage_account_name" { type = string }
variable "container_name" { type = string }

variable "vnet_name" { type = string }
variable "address_space" { type = list(string) }
variable "subnets" { type = map(any) }

variable "aks_node_count" { type = number }
variable "aks_node_vm_size" { type = string }