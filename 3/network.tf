resource "azurerm_virtual_network" "myvnet" {
  name = var.vnet_info.name
  resource_group_name = azurerm_resource_group.resgroup.name
  location = azurerm_resource_group.resgroup.location
  address_space = var.vnet_info.address_space
  depends_on = [
    azurerm_resource_group.resgroup
  ]
}
resource "azurerm_subnet" "subnet1" {
  name = var.subnet_info.name
resource_group_name = azurerm_resource_group.resgroup.name
virtual_network_name = azurerm_virtual_network.myvnet.id
address_prefixes = var.subnet_info.address_prefixes
depends_on = [
  azurerm_virtual_network.myvnet
]
}
resource "azurerm_network_interface" "mynic" {
  name                = local.nicname
  location            = azurerm_resource_group.resgroup.location
  resource_group_name = azurerm_resource_group.resgroup.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
