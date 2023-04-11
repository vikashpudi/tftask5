resource "azurerm_resource_group" "rgroup_name" {
  name     = var.rgp
  location = var.loc
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = azurerm_resource_group.rgroup_name.location
  resource_group_name = azurerm_resource_group.rgroup_name.name
}

resource "azurerm_virtual_network" "myvnet" {
  name                = var.vnet.name
  location            = azurerm_resource_group.rgroup_name.location
  resource_group_name = azurerm_resource_group.rgroup_name.name
  address_space       = var.vnet.address_space


  subnet {
    name           = var.subnet1
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = var.subnet2
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.nsg.id
  }
  subnet {
    name           = var.subnet3
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.nsg.id
  }
  tags = {
    environment = "Production"
  }
}