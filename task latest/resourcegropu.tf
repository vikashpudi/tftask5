resource "azurerm_resource_group" "resourgegroup" {
    name = "${var.enviroment}${var.resourcegroup_details.name}"
    location = var.resourcegroup_details.location
  
}