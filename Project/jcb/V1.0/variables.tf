# Version Number #
# V1.5
# Change Notes
# Added more Varabiles to allow customer facing questions
# Re Order the Variables
# V1.1 Added the variables for the storage account to in link into the main.tf
 



variable "vm_Disk_Type" {
   description = "What Disk type would you like to use"
}
variable "image_sku" {
  description = "image sku to apply (az vm image list)"
}
variable "image_publisher" {
  default = "MicrosoftWindowsServer"
  description = "Name of the publisher of the image (az vm image list)"
}
variable "image_offer" {
  default = "WindowsServer"
  description = "the name of the offer (az vm image list)"
}
variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}
variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "GRS"
}
variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}