resource "azurerm_virtual_network" "myvnet" {
    name = var.vnet_info.name
    address_space =var.vnet_info.address_space
    location = azurerm_resource_group.MYRGP.location
    resource_group_name = azurerm_resource_group.MYRGP.name
    depends_on = [
      azurerm_resource_group.MYRGP
    ]
   }
  resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.MYRGP.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["192.168.1.0/24"]
  depends_on = [
    azurerm_virtual_network.myvnet
  ]
  
}
resource "azurerm_public_ip" "lb_pubip" {
  name                = "lb_frontpool_public_ip"
  location            = azurerm_resource_group.MYRGP.location
  resource_group_name = azurerm_resource_group.MYRGP.name
  allocation_method   = "Dynamic"
   

  tags = {
    environment = terraform.workspace
  }
}