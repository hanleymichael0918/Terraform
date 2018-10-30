resource "azurerm_resource_group" "terraform" {
  name     = "Terraform-deploy-RG"
  location = "${var.Loc[1]}"

  tags {
    environment = "Production"
  }
}
resource "azurerm_virtual_network" "terraform" {
  name                = "ProductionS"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.terraform.location}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"
}
resource "azurerm_subnet" "terraform" {
  name                 = "acctsub"
  resource_group_name  = "${azurerm_resource_group.terraform.name}"
  virtual_network_name = "${azurerm_virtual_network.terraform.name}"
  address_prefix       = "10.0.2.0/24"
}