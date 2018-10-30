resource "azurerm_resource_group" "terraform" {
  name     = "Terraform-deploy-RG"
  location = "${var.Loc[1]}"

tags {
    environment = "Production"
  }
}
resource "azurerm_availability_set" "test" {
  name                          = "AVSet"
  location                      = "${azurerm_resource_group.terraform.location}"
  resource_group_name           = "${azurerm_resource_group.terraform.name}"
  platform_fault_domain_count   = 2
  platform_update_domain_count  = 5
  managed                       = true
  count                         = "2"

  tags {
    environment = "Production" }
}