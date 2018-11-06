variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
}
variable "prefix" {
  description = "The Prefix used for all resources in this example"
}
variable "vm_size" {
  description = "Specifies the size of the virtual machine."
}
variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}
variable "NetworkName" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}
variable "confignode_count" {default = 2}