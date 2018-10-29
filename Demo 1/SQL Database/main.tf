provider "azurerm" {
}
resource "azurerm_resource_group" "RG" {
  name     = "Terraform-Deploy-RG"
  location = "eastus"
}
resource "azurerm_sql_server" "sql" {
  name = "mgmsql01"
  resource_group_name = "${azurerm_resource_group.RG.name}"
  location = "eastus"
  version = "12.0"
  administrator_login = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}
resource "azurerm_sql_database" "sql-Database" {
  name                = "db1"
  resource_group_name = "${azurerm_resource_group.RG.name}"
  location = "eastus"
  server_name = "${azurerm_sql_server.sql.name}"
  edition = "Premium"
  tags {
    environment = "production"
  }
}