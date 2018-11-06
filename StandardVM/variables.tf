variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
}
variable "Virtual_Machine_prefix" {
  description = "The Prefix used for all resources in this example"
}
variable "vm_size" {
  description = "Specifies the size of the virtual machine."
}
variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}
variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
}
variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "UbuntuServer"
}
variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}
variable "confignode_count" {
description = "How many Virtual would you like to create"
}
