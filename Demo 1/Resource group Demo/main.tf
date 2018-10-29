# Configure the Azure Provider
provider "azurerm" { }

# Create a resource group
resource "azurerm_resource_group" "RG" {
  name     = "Terraform-Deploy-RG"
  location = "eastus"
}