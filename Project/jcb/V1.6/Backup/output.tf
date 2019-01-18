output "ResourceGroup" {
  value = "${azurerm_resource_group.terraform.name}"
}
output "ResourceGroupWest" {
  value = "${azurerm_resource_group.RGWest.name}"
}
output "StorageAccount" {
  value = "${azurerm_storage_account.storage.name}"
}
output "StorageAccountCloudQuorum" {
  value = "${azurerm_storage_account.CloudQuorum.name}"
}
output "VirtualNetworkProduction" {
  value = "${azurerm_virtual_network.VirtualNetwork.name}"
}
output "VirtualNetworkProductionWest" {
  value = "${azurerm_virtual_network.VirtualNetworkWest.name}"
}
output "VirtualNetworkProductionAddressSpace" {
  value = "${azurerm_subnet.Subnets.address_prefix}"
}
output "VirtualNetworkProductionAddressSpaceWest" {
  value = "${azurerm_virtual_network.VirtualNetworkWest.address_space}"
}
output "VnetPeeringConnections" {
  value = "${azurerm_virtual_network_peering.test1.name}"
}
output "VnetPeeringConnections2" {
  value = "${azurerm_virtual_network_peering.test2.name}"
}
output "Load_Balancers_UKSouth" {
  value = "${azurerm_lb.LB01.name}"
}
output "Load_Balancers_UKSouth_ipddress" {
  value = "${azurerm_lb.LB01.private_ip_address}"
}
output "Load_Balancers_UKWest" {
  value = "${azurerm_lb.testwest.name}"
}
output "Load_Balancers_UKWest_ipddress" {
  value = "${azurerm_lb.testwest.private_ip_address}"
}
output "AVSetsVM" {
  value = "${azurerm_availability_set.AVVM.name}"
}
output "AVSetsDC" {
  value = "${azurerm_availability_set.AVDC.name}"
}
output "AVSetsSQL" {
  value = "${azurerm_availability_set.AVSQL.name}"
}
output "AVSetsSQLWest" {
  value = "${azurerm_availability_set.AVSQLWEST.name}"
}
output "VirtualMachineVM" {
  value = "${azurerm_virtual_machine.vm.name}"
}
output "VirtualMachineVMInternalIP" {
  value = "${azurerm_network_interface.main.private_ip_address}"
}
output "VirtualMachineVMPublicIP" {
  value = "${azurerm_public_ip.VMPIP.public_ip_address_allocation}"
}
output "VirtualMachineVMRegion" {
  value = "${azurerm_virtual_machine.vm.location}"
}
output "VirtualMachineVMTier" {
  value = "${azurerm_virtual_machine.vm.vm_size}"
}
output "VirtualMachineDC" {
  value = "${azurerm_virtual_machine.DC.name}"
}
output "VirtualMachineDCIP" {
  value = "${azurerm_network_interface.DCNic1.private_ip_address}"
}
output "VirtualMachineDCTier" {
  value = "${azurerm_virtual_machine.DC.vm_size}"
}
output "VirtualMachineDCVMRegion" {
  value = "${azurerm_virtual_machine.DC.location}"
}
output "VirtualMachineSQL01" {
  value = "${azurerm_virtual_machine.SQL01.name}"
}
output "VirtualMachineSQL01IP" {
  value = "${azurerm_network_interface.Nic2SQL.private_ip_address}"
}
output "VirtualMachineSQL01DDName" {
  value = "${azurerm_managed_disk.SQL01DD.name}"
}
output "VirtualMachineSQL01DDType" {
  value = "${azurerm_managed_disk.SQL01DD.storage_account_type}"
}
output "VirtualMachineSQL01VMRegion" {
  value = "${azurerm_virtual_machine.SQL01.location}"
}
output "VirtualMachineSQL01VMTier" {
  value = "${azurerm_virtual_machine.SQL01.vm_size}"
}
output "VirtualMachineSQL02" {
  value = "${azurerm_virtual_machine.SQL02.name}"
}
output "VirtualMachineSQL02IP" {
  value = "${azurerm_network_interface.Nic3SQL.private_ip_address}"
}
output "VirtualMachineSQL02DDName" {
  value = "${azurerm_managed_disk.SQL02DD.name}"
}
output "VirtualMachineSQL02DDType" {
  value = "${azurerm_managed_disk.SQL02DD.storage_account_type}"
}
output "VirtualMachineSQL02VMTier" {
  value = "${azurerm_virtual_machine.SQL02.vm_size}"
}
output "VirtualMachineSQL02VMRegion" {
  value = "${azurerm_virtual_machine.SQL02.location}"
}
output "VirtualMachineSQL03" {
  value = "${azurerm_virtual_machine.SQL03.name}"
}
output "VirtualMachineSQL03IP" {
  value = "${azurerm_network_interface.Nic2SQLWest.private_ip_address}"
}
output "VirtualMachineSQL03DDName" {
  value = "${azurerm_managed_disk.SQL03DD.name}"
}
output "VirtualMachineSQL03DDType" {
  value = "${azurerm_managed_disk.SQL03DD.storage_account_type}"
}
output "VirtualMachineSQL03VMRegion" {
  value = "${azurerm_virtual_machine.SQL02.location}"
}
output "VirtualMachineSQL03VMTier" {
  value = "${azurerm_virtual_machine.SQL03.vm_size}"
}




# output "VirtualMachineDCVMTier" {
  # value = "${azurerm_virtual_machine.DC.vm_size}"
# }
