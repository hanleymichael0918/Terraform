resource "azurerm_resource_group" "terraform" {
  name     = "Terraform-deploy-RG"
  location = "${var.Loc[1]}"
}