# Version Number #
# V1.2
# Change Notes
# Re Order the Variables
# V1.1 Added the variables for the storage account to in link into the main.tf
 
variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
}
variable "Virtual_Machine_Name" {
  description = "The Prefix used for all resources in this example"
}
variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}
variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
}
variable "image_offer" {
  default = "WindowsServer"
  description = "the name of the offer (az vm image list)"
}
variable "image_sku" {
  description = "image sku to apply (az vm image list)"
}
variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}
variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}
variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}
variable "VMSize" {
 description = "What VM Tier would need"
}
