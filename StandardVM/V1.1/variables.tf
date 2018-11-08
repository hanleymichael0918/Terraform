# Version Number #
# V1.1
# Change Notes #
 
variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
}
variable "Virtual_Machine_Name" {
  description = "The Prefix used for all resources in this example"
}
variable "VMSize" {
    type = "map"
    default = {
      "0" = "Standard_B1s"
      "1" = "Standard_F2s"
      }
    }
variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}
variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
}
variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "WindowsServer"
}
variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}
variable "confignode_count" {
description = "How many Virtual would you like to create"
}
variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}
variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}
