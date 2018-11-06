resource "azurerm_resource_group" "RG" {
  name     = "Terraform-deploy-RG"
  location = "${var.Loc[1]}"

  tags {
    environment = "Production"
  }
}
