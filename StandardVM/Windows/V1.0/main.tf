# Version Number #
# V1.0
# Change Notes #

provider "azurerm" {
}
###################### Resource Group ###########################################
resource "azurerm_resource_group" "terraform" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "Production"
  }
}
######################## Virtual Networks #######################################
resource "azurerm_virtual_network" "VirtualNetwork" {
  name                = "Production"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.terraform.location}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"
}
resource "azurerm_subnet" "Subnets" {
  name                 = "acctsub"
  resource_group_name  = "${azurerm_resource_group.terraform.name}"
  virtual_network_name = "${azurerm_virtual_network.VirtualNetwork.name}"
  address_prefix       = "10.0.2.0/24"
}
resource "azurerm_network_interface" "Nic_Interface" {
  name                = "nic-${format("%02d", count.index+1)}"
  count               = "${var.confignode_count}"
  location            = "${azurerm_resource_group.terraform.location}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"

  ip_configuration {
    name                          = "terraformconfiguration1"
    subnet_id                     = "${azurerm_subnet.Subnets.id}"
    private_ip_address_allocation = "dynamic"
    }
  }
  ########################## Availability Sets #####################################
  resource "azurerm_availability_set" "test" {
  name                          = "AV-${format("%02d", count.index+1)}"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.terraform.name}"
  platform_fault_domain_count   = 2
  platform_update_domain_count  = 5
  managed                       = true
  count                         = "1"

  tags {
    environment = "Production"
    }
  }
############################### Virtual Machine ##################################
resource "azurerm_virtual_machine" "terraform" {
  name                  = "${var.Virtual_Machine_Name}${format("%02d", count.index+1)}"
  location              = "${azurerm_resource_group.terraform.location}"
  resource_group_name   = "${azurerm_resource_group.terraform.name}"
  network_interface_ids = ["${element(azurerm_network_interface.Nic_Interface.*.id, count.index)}"]
  vm_size               = "${lookup(var.VMSize, 1)}"
  availability_set_id   = "${azurerm_availability_set.test.id}"

  tags {
    environment = "Production"
  }

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
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
    computer_name  = "${var.Virtual_Machine_Name}"
    admin_username = "DaisyAdmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {
  }
    count = "${var.confignode_count}"
}
