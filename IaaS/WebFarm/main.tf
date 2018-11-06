###################### Resource Group ###########################################

module "RG" {
  source = "c:/terraform/github/Terraform/IaaS/WebFarm/rg"
}
###################### Virtual Networks #######################################
module "Network" {
  source = "c:/terraform/github/Terraform/IaaS/WebFarm/network"
}
module "VM" {
  source = "c:/terraform/github/Terraform/IaaS/WebFarm/VMs"
}