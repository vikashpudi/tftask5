resource "azurerm_resource_group" "MYRGP" {
    name = var.group_info 
    location = var.location_info 
}