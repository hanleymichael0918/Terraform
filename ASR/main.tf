provider "azurerm" {

   subscription_id = "7f2dcecb-e3cb-4020-a98c-13e65875ea64"
   client_id       = "02ab08d2-969e-458c-b4b3-87b1cad32bc2"
   client_secret   = "dvQ9Kwr+fFZNPXUs1TZXoqVulEAnvIB5xlMpOL0n0S4="
   tenant_id       = "2f55424d-e376-451c-8056-7bd6e3dc76b7"
}
resource "azurerm_resource_group" "rg" {
  name     = "tfex-recovery_vault"
  location = "West US"
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "recoveryvault1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku                 = "standard"
}