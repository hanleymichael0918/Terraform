# v1.0 First Draft
# V1.1 Change Line 16 to uk south
# V1.1 Change Line 25 to RGWest
# V1.1 Change Line 26 to sqlpocwest
# V1.1 Change Line 27 to UK West
# V1.1 Change Line 88 to VirtualNetworkWest
# V1.1 Change Line 89 to ProductionWest
# V1.1 Change Line 93 to "${azurerm_resource_group.RGWest.location}"
# V1.1 Change line 95 to "${azurerm_resource_group.RGWest.name}"
# V1.1 Change Line 102 to resource "azurerm_subnet" "SubnetsWest"
# V1.1 Change Line 103 to  "InternalWest"
# V1.1 Change Line 105 to  "${azurerm_resource_group.RGWest.name}"
# V1.1 Change Line 107 to "${azurerm_virtual_network.VirtualNetworkWest.name}"
# V1.1 Change Line 108 to  "${azurerm_virtual_network.VirtualNetworkWest.name}"
# V1.1 Change Line 116 to  "${azurerm_virtual_network.VirtualNetworkWest.id}"
# V1.1 Change Line 127 to  "${azurerm_resource_group.RGWest.name}"
# V1.1 Change Line 128 to  "${azurerm_virtual_network.VirtualNetworkWest.name}"
# V1.1 Change Line 133 to   ["azurerm_virtual_network.VirtualNetworkWest"]
# V1.1 Change Line 144 to   # Creates a Load Balancer in the UK South Region
# V1.1 Change Line 147 to   "uk south"
# V1.1 Change Line 174 to   # Creates a Load Balancer in the UK West Region
# V1.1 Change Line 175 to resource "azurerm_lb" "testWest"
# V1.1 Change Line 179 to   "UK South"
# V1.1 Change Line 181 to  resource_group_name = "${azurerm_resource_group.RGWest.name}"
# V1.1 Change Line 189 to   "${azurerm_subnet.SubnetsWest.id}"  
# V1.1 Change Line 193 to  "azurerm_lb_probe" "testwest"
# V1.1 Change Line 195 to  "${azurerm_resource_group.RGWest.name}"
# V1.1 Change Line 190 to  "InternalIPAddressWest"
# V1.1 Change Line 198 to  "${azurerm_lb.testswest.id}"
# V1.1 Change Line 206 to  "azurerm_lb_backend_address_pool" "testwest"
# V1.1 Chnage Line 208 to  "${azurerm_resource_group.RGWest.name}"
# V1.1 Change Line 210 to  "${azurerm_lb.testwest.id}"
# V1.1 Change Line 212 to  "BackEndAddressPoolWest"
# V1.1 Change Line 220 to  "UK South"
# V1.1 Change Line 234 to  "UK South"
# V1.1 Change Line 248 to  "UK South"
# V1.1 Change Line 260 to  "azurerm_availability_set" "AVSQLWEST"
# V1.1 Change Line 263 to  "AVSQLWest"
# V1.1 Change Line 264 to  "UK West"
# V1.1 Chnage Line 266 to  "${azurerm_resource_group.RGWest.name}"
# V1.1 Change Line 281 to  "Uk South"
# V1.1 Change Line 325 to  "UK South"
# V1.1 Change Line 338 to  "UK South"
# V1.1 Change Line 383 to  "Uk South"
# V1.1 Change Line 395 to  "UK South"
# V1.1 Change Line 440 to  "UK South"
# V1.1 Change Line 452 to  "UK South"
# V1.1 Change Line 497 to  "UK South"
# V1.1 Change Line 509 to  "UK West"
# V1.1 Change Line 552 to  "azurerm_network_interface" "Nic2SQLWest"
# V1.1 Change Line 555 to  "UK West"
# V1.1 Change Line 561 to  "${azurerm_subnet.SubnetsWest.id}"
# V1.1 Change Line 558 to   resource_group_name = "sqlpocwest"
# V1.1 Change Line 557 to   "nic2West-SQL01"
# V1.1 Change Line 520 to   "${azurerm_availability_set.AVSQLWEST.id}"
# V1.1 Change Line 519 to   "${azurerm_network_interface.Nic2SQLWest.id}"]
# V1.2 Added new load balancer probes in the load balancer sections.
# V1.3 Change the Load Balancers to Static ip address.
# V1.4 Added the Custom scripts in to the code
# V1.5 Added DNS Servers ip address to both virtual networks
# V1.6 Removed the SQL VMs from as agreed by myself a Dean

provider "azurerm" {

   subscription_id = "ed2ea9c8-c231-47ad-b10c-4fe229801665"
   client_id       = "3d087301-0610-4d15-b935-923525cb993c"
   client_secret   = "dvQ9Kwr+fFZNPXUs1TZXoqVulEAnvIB5xlMpOL0n0S4="
   tenant_id       = "942bb8fa-ffa5-4064-b8c1-0d25d651a68a"
}   
###################### 1.0 Resource Group ###########################################

 # Create a resource group containter
resource "azurerm_resource_group" "RGSouth" {
  name     = "SQLPOC-RG"
  location = "uk South"

  tags {
    Resouce_Group = "sqlpoc"
  }
}
resource "azurerm_resource_group" "RGWest" {
  name     = "SQLPOCWEST-RG"
  location = "Uk West"

  tags {
    Resouce_Group = "sqlpocwest"
  }
}
 # Create a randomised id every time a new resource group is created
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "sqlpoc"
    }

    byte_length = 8
}

###################### 2.0 Storage Account ###########################################

 # Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage" {
    name                        = "diag${random_id.randomId.hex}"
    location                    = "uk South"
    account_tier                = "${var.storage_account_tier}"
    account_replication_type    = "${var.storage_replication_type}"
    resource_group_name         = "SQLPOC-RG"
    depends_on                  =  ["azurerm_resource_group.RGSouth"]

    tags {
        Storage = "Boot"
    }
}
resource "azurerm_storage_account" "CloudQuorum" {
    name                        = "jcbcloudquorumsa123"
    location                    = "West Europe"
    account_tier                = "${var.storage_account_tier}"
    account_replication_type    = "${var.storage_replication_type}"
    resource_group_name         = "SQLPOC-RG"
    depends_on                  =  ["azurerm_resource_group.RGSouth"]

    tags {
        Storage = "CloudQuorum"
    }
}
############################################ 3.0 Virtual Networks ###########################################################################
resource "azurerm_virtual_network" "VirtualNetwork" {
  name                = "SQLPOC-RG"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.RGSouth.location}"
  resource_group_name = "${azurerm_resource_group.RGSouth.name}"
  # dns_servers         = "${var.dns_servers}"

tags {
        Network = "sqlpoc"
    }
}
resource "azurerm_subnet" "Subnets" {
  name                 = "Internal"
  resource_group_name  = "${azurerm_resource_group.RGSouth.name}"
  virtual_network_name = "${azurerm_virtual_network.VirtualNetwork.name}"
  address_prefix       = "10.0.2.0/24"
}
resource "azurerm_virtual_network_peering" "test1" {
  name                      = "sqlpoc-to-sqlpocwest"
  resource_group_name       = "SQLPOC-RG"
  virtual_network_name      = "${azurerm_virtual_network.VirtualNetwork.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.VirtualNetworkWest.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  depends_on                   = ["azurerm_virtual_network.VirtualNetwork"]
  depends_on                   = ["sqlpoc"]
  
}
resource "azurerm_virtual_network" "VirtualNetworkWest" {
  name                = "SQLPOCWEST-RG"
  address_space       = ["10.100.0.0/16"]
  location            = "${azurerm_resource_group.RGWest.location}"
  resource_group_name = "${azurerm_resource_group.RGWest.name}"
  # dns_servers         = "${var.dns_servers_west}"

tags {
        Network = "sqlpocwest"
    }
}
resource "azurerm_subnet" "SubnetsWest" {
  name                 = "sqlpocwestDev"
  resource_group_name  = "${azurerm_resource_group.RGWest.name}"
  virtual_network_name = "${azurerm_virtual_network.VirtualNetworkWest.name}"
  address_prefix       = "10.100.2.0/24"
}
resource "azurerm_virtual_network_peering" "test2" {
  name                      = "sqlpocwest-to-sqlpoc"
  resource_group_name       = "SQLPOCWEST-RG"
  virtual_network_name      = "${azurerm_virtual_network.VirtualNetworkWest.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.VirtualNetwork.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  depends_on                   = ["azurerm_virtual_network.VirtualNetworkWest"]
}
resource "azurerm_public_ip" "VMPIP" {
  name                         = "vm-pip"
  location                     = "${azurerm_resource_group.RGSouth.location}"
  resource_group_name          = "${azurerm_resource_group.RGSouth.name}"
  public_ip_address_allocation = "Dynamic"
}
############################################ 4.0 Load Balancer ###########################################################################

# Creates a Load Balancer in the UK South Region
resource "azurerm_lb" "LB01" {
  name                = "ILB01"
  location            = "uk South"
  resource_group_name = "${azurerm_resource_group.RGSouth.name}"
  depends_on           =  ["azurerm_virtual_network_peering.test1"]

  frontend_ip_configuration {
    name                            = "InternalIPAddress"
    private_ip_address_allocation   = "Static"
    private_ip_address              = "10.0.2.200"
    subnet_id                       = "${azurerm_subnet.Subnets.id}"  
  }
}
resource "azurerm_lb_probe" "Probe1" {
  resource_group_name = "${azurerm_resource_group.RGSouth.name}"
  loadbalancer_id     = "${azurerm_lb.LB01.id}"
  name                = "SQLAlwaysOnEndPointProbe"
  protocol            = "tcp"
  port                = 59999
  interval_in_seconds = 5
  number_of_probes    = 2
}
resource "azurerm_lb_probe" "Probe2" {
  resource_group_name = "${azurerm_resource_group.RGSouth.name}"
  loadbalancer_id     = "${azurerm_lb.LB01.id}"
  name                = "SQLAlwaysOnEndPointListener"
  protocol            = "tcp"
  port                = 1433
  interval_in_seconds = 5
  number_of_probes    = 2
}
resource "azurerm_lb_backend_address_pool" "test" {
  resource_group_name = "${azurerm_resource_group.RGSouth.name}"
  loadbalancer_id     = "${azurerm_lb.LB01.id}"
  name                = "BackEndAddressPool"
}
# Creates a Load Balancer in the Uk West Region
resource "azurerm_lb" "testwest" {
  name                = "ILB02"
  location            = "Uk West"
  resource_group_name = "${azurerm_resource_group.RGWest.name}"
  depends_on           =  ["azurerm_virtual_network_peering.test2"]

  frontend_ip_configuration {
    name                            = "InternalIPAddressWest"
    private_ip_address_allocation   = "Static"
    private_ip_address              = "10.100.2.200"
    subnet_id                       = "${azurerm_subnet.SubnetsWest.id}"  
  }
}
resource "azurerm_lb_probe" "Probe1West" {
  resource_group_name = "${azurerm_resource_group.RGWest.name}"
  loadbalancer_id     = "${azurerm_lb.testwest.id}"
  name                = "SQLAlwaysOnEndPointProbe"
  protocol            = "tcp"
  port                = 59999
  interval_in_seconds = 5
  number_of_probes    = 2
}
resource "azurerm_lb_probe" "Probe2West" {
  resource_group_name = "${azurerm_resource_group.RGWest.name}"
  loadbalancer_id     = "${azurerm_lb.testwest.id}"
  name                = "SQLAlwaysOnEndPointListener"
  protocol            = "tcp"
  port                = 1433
  interval_in_seconds = 5
  number_of_probes    = 2
}
resource "azurerm_lb_backend_address_pool" "testwest" {
  resource_group_name = "${azurerm_resource_group.RGWest.name}"
  loadbalancer_id     = "${azurerm_lb.testwest.id}"
  name                = "BackEndAddressPoolWest"
}

######################################## 5.0 Availability Sets #############################################################################

resource "azurerm_availability_set" "AVVM" {
  name                          = "AVVM"
  location                      = "UK South"
  resource_group_name           = "SQLPOC-RG"
  platform_fault_domain_count   = 2
  platform_update_domain_count  = 5
  managed                       = true
  depends_on                    =  ["azurerm_resource_group.RGSouth"]

  tags {
    Availability = "VM Server"
    }
  }
  resource "azurerm_availability_set" "AVDC" {
  name                          = "AVDC"
  location                      = "UK South"
  resource_group_name           = "SQLPOC-RG"
  platform_fault_domain_count   = 2
  platform_update_domain_count  = 5
  managed                       = true
  depends_on                    =  ["azurerm_resource_group.RGSouth"]

  tags {
    Availability = "DC Server"
    }
  }
  resource "azurerm_availability_set" "AVSQL" {
  name                          = "AVSQL"
  location                      = "UK South"
  resource_group_name           = "SQLPOC-RG"
  platform_fault_domain_count   = 2
  platform_update_domain_count  = 5
  managed                       = true
  depends_on                    =  ["azurerm_resource_group.RGSouth"]

  tags {
    Availability = "sqlpoc"
    }
  }
  resource "azurerm_availability_set" "AVSQLWEST" {
  name                          = "AVSQLWest"
  location                      = "UK West"
  resource_group_name           = "${azurerm_resource_group.RGWest.name}"
  platform_fault_domain_count   = 2
  platform_update_domain_count  = 5
  managed                       = true
  depends_on                   = ["azurerm_resource_group.RGWest"]

  tags {
    Availability = "sqlpocwest"
    }
  }
  ############################################## 6.0 Virtual Machines ###################################################################
resource "azurerm_virtual_machine" "vm" {
  name                  = "VM01"
  location              = "Uk South"
  resource_group_name   = "SQLPOC-RG"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_D2_v3"
  availability_set_id   = "${azurerm_availability_set.AVVM.id}"
  depends_on           = ["azurerm_virtual_network.VirtualNetwork"]
  tags {
    Servers = "sqlpoc"
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
    name              = "osdisk01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_Disk_Type}"
  }
  os_profile {
    computer_name  = "VM"
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
}
resource "azurerm_network_interface" "main" {
  name                = "vm01-nic"
  location            = "UK South"
  resource_group_name = "${azurerm_resource_group.RGSouth.name}"
  depends_on           =  ["azurerm_virtual_network_peering.test1"]

  ip_configuration {
    name                          = "sqlpocIP"
    subnet_id                     = "${azurerm_subnet.Subnets.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.7"
    public_ip_address_id          = "${azurerm_public_ip.VMPIP.id}"
  }
}
resource "azurerm_virtual_machine" "DC" {
  name                  = "DC01"
  location              = "UK South"
  resource_group_name   = "SQLPOC-RG"
  network_interface_ids = ["${azurerm_network_interface.DCNic1.id}"]
  vm_size               = "Standard_D1_v2"
  availability_set_id   = "${azurerm_availability_set.AVDC.id}"
  depends_on          =  ["azurerm_virtual_network.VirtualNetwork"]
  
  
  tags {
    Servers = "sqlpoc"
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
    name              = "osdisk02"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_Disk_Type}"
  }
  os_profile {
    computer_name  = "DC01"
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
}
# Creates the Network Interface for the DC Server
resource "azurerm_network_interface" "DCNic1" {
  name                = "DCnic1"
  location            = "Uk South"
  resource_group_name = "${azurerm_resource_group.RGSouth.name}"
  depends_on           =  ["azurerm_virtual_network_peering.test1"]

  ip_configuration {
    name                          = "DCIP1"
    subnet_id                     = "${azurerm_subnet.Subnets.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"
    }
  }
  resource "azurerm_virtual_machine_extension" "vmex" {
  name                 = "UKRegion"
  location             = "uk south"
  resource_group_name  = "${azurerm_resource_group.RGSouth.name}"
  virtual_machine_name = "${azurerm_virtual_machine.DC.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on           =  ["azurerm_virtual_machine.DC"]

    settings = <<SETTINGS
    {
        "fileUris": [
           "https://sapowershellcontainer.blob.core.windows.net/scripts/ConfigureRemotingForAnsible.ps1?sp=r&st=2019-01-16T10:23:10Z&se=2019-06-30T17:23:10Z&spr=https&sv=2018-03-28&sig=GYADwj3R3gXqe64aWzWIT59dgCPUGN36ERzzGNX0SXY%3D&sr=b"
        ],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File \"ConfigureRemotingForAnsible.ps1\""
    }
    SETTINGS
}