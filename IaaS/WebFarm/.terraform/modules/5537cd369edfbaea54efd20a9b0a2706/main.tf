######################## Virtual Networks #######################################
resource "azurerm_virtual_network" "VirtualNetwork" {
  name                = "ProductionS"
  address_space       = ["10.0.0.0/16"]
  location            = "ukwest"
  resource_group_name = "Terraform-deploy-RG"
}
resource "azurerm_subnet" "Subnets" {
  name                 = "acctsub"
  resource_group_name  = "Terraform-deploy-RG"
  virtual_network_name = "${azurerm_virtual_network.VirtualNetwork.name}"
  address_prefix       = "10.0.2.0/24"
}
resource "azurerm_network_interface" "Nic_Interface" {
  name                = "nic-${format("%02d", count.index+1)}"
  count               = "5"
  location            = "ukwest"
  resource_group_name = "Terraform-deploy-RG"

  ip_configuration {
    name                          = "terraformconfiguration1"
    subnet_id                     = "${azurerm_subnet.Subnets.id}"
    private_ip_address_allocation = "dynamic"
    }
  }