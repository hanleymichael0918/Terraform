# Version Number V1.0

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
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
###################### App Service Plan ###########################################
resource "azurerm_app_service_plan" "default" {
  name                = "tfex-appservice-${random_integer.ri.result}-plan"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  depends_on          =  ["azurerm_resource_group.terraform"]

  sku {
    tier = "${var.app_service_plan_sku_tier}"
    size = "${var.app_service_plan_sku_size}"
  }
}
###################### App Service ###########################################
resource "azurerm_app_service" "default" {
  name                = "tfex-appservice-${random_integer.ri.result}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  app_service_plan_id = "${azurerm_app_service_plan.default.id}"

  site_config {
    dotnet_framework_version = "v4.0"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2015"
  }
}
###################### Redis Cache ###########################################
resource "azurerm_redis_cache" "test" {
  name                = "tf-redis-basic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  depends_on          =  ["azurerm_resource_group.terraform"]

redis_configuration {
    maxmemory_delta    = 2
    maxmemory_policy   = "allkeys-lru"
  }
}