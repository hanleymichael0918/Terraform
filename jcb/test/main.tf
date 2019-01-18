provider "azurerm" {

   subscription_id = "7f2dcecb-e3cb-4020-a98c-13e65875ea64"
   client_id       = "02ab08d2-969e-458c-b4b3-87b1cad32bc2"
   client_secret   = "dvQ9Kwr+fFZNPXUs1TZXoqVulEAnvIB5xlMpOL0n0S4="
   tenant_id       = "2f55424d-e376-451c-8056-7bd6e3dc76b7"
}   
###################### 1.0 Resource Group ###########################################

 # Create a resource group containter
resource "azurerm_resource_group" "terraform" {
  name     = "sqlpoc1"
  location = "uk South"

  tags {
    Resouce_Group = "Production"
  }
}
resource "azurerm_resource_group" "RGWest" {
  name     = "sqlpocwest2"
  location = "Uk West"

  tags {
    Resouce_Group = "Production"
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
    resource_group_name         = "sqlpoc"
    depends_on                  =  ["azurerm_resource_group.terraform"]

    tags {
        Storage = "Boot"
    }
}
resource "azurerm_storage_account" "CloudQuorum" {
    name                        = "cloudquorumsa123"
    location                    = "West Europe"
    account_tier                = "${var.storage_account_tier}"
    account_replication_type    = "${var.storage_replication_type}"
    resource_group_name         = "sqlpoc"
    depends_on                  =  ["azurerm_resource_group.terraform"]

    tags {
        Storage = "CloudQuorum"
    }
}
############################################ 3.0 Virtual Networks ###########################################################################
resource "azurerm_virtual_network" "VirtualNetwork" {
  name                = "Production"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.terraform.location}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"
  dns_servers         = "${var.dns_servers}"

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
resource "azurerm_virtual_network_peering" "Peer1" {
  name                      = "Production-to-ProductionWest"
  resource_group_name       = "${azurerm_resource_group.terraform.name}"
  virtual_network_name      = "${azurerm_virtual_network.VirtualNetwork.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.VirtualNetworkWest.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}
resource "azurerm_virtual_network" "VirtualNetworkWest" {
  name                = "ProductionWest"
  address_space       = ["10.100.0.0/16"]
  location            = "${azurerm_resource_group.RGWest.location}"
  resource_group_name = "${azurerm_resource_group.RGWest.name}"
  dns_servers         = "${var.dns_servers_west}"

tags {
        Network = "Production"
    }
}
resource "azurerm_subnet" "SubnetsWest" {
  name                 = "InternalWest"
  resource_group_name  = "${azurerm_resource_group.RGWest.name}"
  virtual_network_name = "${azurerm_virtual_network.VirtualNetworkWest.name}"
  address_prefix       = "10.100.2.0/24"
}
resource "azurerm_virtual_network_peering" "Peer2" {
  name                      = "ProductionWest-to-Production"
  resource_group_name       = "${azurerm_resource_group.RGWest.name}"
  virtual_network_name      = "${azurerm_virtual_network.VirtualNetworkWest.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.VirtualNetwork.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}
resource "azurerm_public_ip" "VMPIP" {
  name                         = "vm-pip"
  location                     = "${azurerm_resource_group.terraform.location}"
  resource_group_name          = "${azurerm_resource_group.terraform.name}"
  public_ip_address_allocation = "Dynamic"
}