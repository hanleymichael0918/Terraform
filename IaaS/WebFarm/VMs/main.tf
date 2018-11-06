variable "confignode_count" {default = 2}

module "Network" {
  source = "c:/terraform/github/Terraform/IaaS/WebFarm/network"
}
############################### Virtual Machine ##################################
resource "azurerm_virtual_machine" "terraform" {
  name                  = "MyVm-${format("%02d", count.index+1)}"
  location              = "ukwest"
  resource_group_name   = "Terraform-deploy-RG"
  network_interface_ids = ["${element(azurerm_network_interface.Nic_Interface.*.id, count.index)}"]
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
    computer_name  = "MyVm"
    admin_username = "DaisyAdmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {
  }
    count = "${var.confignode_count}"
}