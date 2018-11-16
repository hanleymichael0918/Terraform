# Version Number #
# V1.0
# Change Notes
# V1.0 Added os_profile_linux_config as it is required for linux deployment.

##################### Cloud Provider ###########################################

provider "azurerm" {

   subscription_id = "7f2dcecb-e3cb-4020-a98c-13e65875ea64"
   client_id       = "02ab08d2-969e-458c-b4b3-87b1cad32bc2"
   client_secret   = "dvQ9Kwr+fFZNPXUs1TZXoqVulEAnvIB5xlMpOL0n0S4="
   tenant_id       = "2f55424d-e376-451c-8056-7bd6e3dc76b7"
}   
###################### Resource Group ###########################################

 # Create a resource group containter
resource "azurerm_resource_group" "terraform" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    Resouce_Group = "Production"
  }
}
 # Create a randomised id every time a new resource group is created
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${var.resource_group_name}"
    }

    byte_length = 8
}
 # Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage" {
    name                        = "diag${random_id.randomId.hex}"
    location                    = "${var.location}"
    account_tier                = "${var.storage_account_tier}"
    account_replication_type    = "${var.storage_replication_type}"
    resource_group_name         = "${var.resource_group_name}"
    depends_on                  =  ["azurerm_resource_group.terraform"]

    tags {
        Storage = "Boot"
    }
}
######################## Virtual Networks #######################################

# Create Virtual Network with 1 Subnet.
resource "azurerm_virtual_network" "VirtualNetwork" {
  name                = "Production"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.terraform.location}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"

tags {
        Network = "Production"
    }
}
resource "azurerm_subnet" "Subnets" {
  name                 = "Internal"
  resource_group_name  = "${azurerm_resource_group.terraform.name}"
  virtual_network_name = "${azurerm_virtual_network.VirtualNetwork.name}"
  address_prefix       = "10.0.2.0/24"
}
# Create the network interface for each virtual machines.
resource "azurerm_network_interface" "Nic1" {
  name                = "nic-${format("%02d", count.index+1)}"
  count               = "${var.confignode_count}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "terraformconfiguration1"
    subnet_id                     = "${azurerm_subnet.Subnets.id}"
    private_ip_address_allocation = "dynamic"
    }
  }
  resource "azurerm_network_interface" "Nic2" {
  name                = "nic2-${format("%02d", count.index+1)}"
  count               = "${var.confignode_count}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "terraformconfiguration1"
    subnet_id                     = "${azurerm_subnet.Subnets.id}"
    private_ip_address_allocation = "dynamic"
    }
  }
  ########################## Availability Sets #####################################
  resource "azurerm_availability_set" "AVSet" {
  name                          = "AV-${format("%02d", count.index+1)}"
  location                      = "${var.location}"
  resource_group_name           = "${var.resource_group_name}"
  platform_fault_domain_count   = 2
  platform_update_domain_count  = 5
  managed                       = true
  count                         = "1"
  depends_on                    =  ["azurerm_resource_group.terraform"]

  tags {
    Availability = "Production"
    }
  }  
############################### Virtual Machine ##################################
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.Virtual_Machine_Name}${format("%02d", count.index+1)}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${element(azurerm_network_interface.Nic1.*.id, count.index)}"]
  network_interface_ids = ["${element(azurerm_network_interface.Nic2.*.id, count.index)}"]
  vm_size               = "${var.VMSize}"
  availability_set_id   = "${azurerm_availability_set.AVSet.id}"
  primary_network_interface_id = "${element(azurerm_network_interface.Nic1.*.id, count.index)}"
  count                 = "${var.confignode_count}"
  
  tags {
    Servers = "Production"
  }

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }
  storage_os_disk {
    name              = "osdisk-${format("%02d", count.index+1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_Disk_Type}"
  }
  os_profile {
    computer_name  = "${var.Virtual_Machine_Name}"
    admin_username = "DaisyAdmin"
    admin_password = "Password1234!"
  }
 os_profile_linux_config {
        disable_password_authentication = false
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.storage.primary_blob_endpoint}"
  }
    count = "${var.confignode_count}"
}
