# Version Number #
# V1.3
# Change Notes
# V1.3 Added the Subscription Details into the code.
# V1.3 Change Line 38 From Terraform Demo to Production
# V1.3 Added Comment on line 44
# V1.3 Chanage the label from acctsub to Internal on line 55
# V1.3 Added Comment on line 59
# V1.3 Change the line 74 from Test to AVSet on line 74
# V1.3 Add comment on line 18 about resource group
# V1.3 Add Comment on line 28
# V1.2 Added the VM agent tools to the VMs
# V1.1 Implemented Boot Diagnostics via a storage account
# V1.1 Change the resource label from stor to storage account

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
    environment = "Production"
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
        environment = "Production"
    }
}
######################## Virtual Networks #######################################

# Create Virtual Network and a 1 Subnet.
resource "azurerm_virtual_network" "VirtualNetwork" {
  name                = "Production"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.terraform.location}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"
}
resource "azurerm_subnet" "Subnets" {
  name                 = "Internal"
  resource_group_name  = "${azurerm_resource_group.terraform.name}"
  virtual_network_name = "${azurerm_virtual_network.VirtualNetwork.name}"
  address_prefix       = "10.0.2.0/24"
}
# Create the network interface for each virtual machines.
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
  resource "azurerm_availability_set" "AVSet" {
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
  vm_size               = "${lookup(var.VMSize, 0)}"
  availability_set_id   = "${azurerm_availability_set.AVSet.id}"

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
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }
  storage_os_disk {
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
    provision_vm_agent        = true
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.storage.primary_blob_endpoint}"
  }
    count = "${var.confignode_count}"   
}
