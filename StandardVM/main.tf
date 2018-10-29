provider "azurerm" {
}
#This count allows to create mulitiples of VMs
variable "confignode_count" {default = 5}
resource "azurerm_resource_group" "terraform" {
  name     = "Terraform-deploy-RG"
  location = "${var.Loc[1]}"
}
# Create the network stack and 1 Subnet
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
# This creates allow you to create multilpe networks insterfaces, please make sure that
# this would need to be the same of the Vms you create. 
resource "azurerm_network_interface" "test" {
  name                = "nic-${format("%02d", count.index+1)}"
  count               = "5"
  location            = "${azurerm_resource_group.terraform.location}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"

  ip_configuration {
    name                          = "terraformconfiguration1"
    subnet_id                     = "${azurerm_subnet.terraform.id}"
    private_ip_address_allocation = "dynamic"
    }
  }
  # This sections creates the VM and what OS it uses.
resource "azurerm_virtual_machine" "terraform" {
  name                  = "MyVm-${format("%02d", count.index+1)}"
  location              = "${azurerm_resource_group.terraform.location}"
  resource_group_name   = "${azurerm_resource_group.terraform.name}"
  network_interface_ids = ["${element(azurerm_network_interface.test.*.id, count.index)}"]
  vm_size               = "Standard_B1ms"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    # name              = "osdisk1"
    name              = "osdisk-${format("%02d", count.index+1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "DC01"
    admin_username = "DaisyAdmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {
  }
  count = "${var.confignode_count}"
}