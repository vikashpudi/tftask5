resource "azurerm_network_security_group" "nsg" {
name                = "${var.enviroment}-nsg"
  location            = azurerm_resource_group.resourgegroup.location
  resource_group_name = azurerm_resource_group.resourgegroup.name

  security_rule {
    name                       = "alltrafic"
    priority                   = 800
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.enviroment
  }
}