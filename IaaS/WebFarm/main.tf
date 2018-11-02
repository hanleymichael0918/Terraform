###################### Resource Group ###########################################

  tags {
    environment = "Production"
  }
}
######################## Virtual Networks #######################################
module "Networking" {
  source = "./github/Terraform/IaaS/WebFarm/Networking/"
}