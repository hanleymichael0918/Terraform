provider "azurerm" {
}
resource "azurerm_resource_group" "terraform" {
  name     = "VM-Deploy-RG"
  location = "East Us"
}
resource "azurerm_virtual_network" "terraform" {
  name                = "${var.virtual_network}"
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
resource "azurerm_network_interface" "terraform" {
  name                = "acctni"
  location            = "${azurerm_resource_group.terraform.location}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"

  ip_configuration {
    name                          = "terraformconfiguration1"
    subnet_id                     = "${azurerm_subnet.terraform.id}"
    private_ip_address_allocation = "dynamic"
  }
}
resource "azurerm_virtual_machine" "terraform" {
  name                  = "DC01"
  location              = "${azurerm_resource_group.terraform.location}"
  resource_group_name   = "${azurerm_resource_group.terraform.name}"
  network_interface_ids = ["${azurerm_network_interface.terraform.id}"]
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
    name              = "osdisk1"
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
    provision_vm_agent = "true"
    enable_automatic_upgrades = "false"
    winrm {
    protocol = "http"
    certificate_url =""
  }
  }
}