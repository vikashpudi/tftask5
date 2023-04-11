
resource "azurerm_virtual_network" "task5vnet" {
    name = "${var.enviroment}-vnet"
    resource_group_name = azurerm_resource_group.resourgegroup.name
    location = azurerm_resource_group.resourgegroup.location
    address_space = var.virtual_network_details.address_space
    depends_on = [
      azurerm_resource_group.resourgegroup
    ]
}
resource "azurerm_subnet" "subnet" {
    count                   = length(var.subnet_details.name)
    name                    = var.subnet_details.name[count.index]
    resource_group_name = azurerm_resource_group.resourgegroup.name
    virtual_network_name = azurerm_virtual_network.task5vnet.name
    address_prefixes  = [var.subnet_details.address_prefixes[count.index]]
  depends_on = [
    azurerm_virtual_network.task5vnet
  ]
}
#publics for dev environment
resource "azurerm_public_ip" "publicipdev" {
    count = var.enviroment == "dev" ? var.numberofvms:0
    name =  "${var.enviroment}pubip-${count.index}"
    location = azurerm_resource_group.resourgegroup.location
    resource_group_name = azurerm_resource_group.resourgegroup.name
    allocation_method = "Dynamic"
    depends_on = [
      azurerm_resource_group.resourgegroup
    ]
}
#publics for qa environment
resource "azurerm_public_ip" "publicipqa" {
    count = var.enviroment == "qa" ? 1:0
    name =  "${var.enviroment}pubip-${count.index}"
    location = azurerm_resource_group.resourgegroup.location
    resource_group_name = azurerm_resource_group.resourgegroup.name
    allocation_method = "Dynamic"
    depends_on = [
      azurerm_resource_group.resourgegroup
    ]
}
resource "azurerm_network_interface" "nicsdev" {
    count = var.enviroment == "dev" ? var.numberofvms:0
    name =  "${var.enviroment}nic-${count.index}"
    location = var.resourcegroup_details.location
    resource_group_name = azurerm_resource_group.resourgegroup.name
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet[0].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.publicipdev[count.index].id

      #public_ip_address_id = var.enviroment == "dev" ? azurerm_public_ip.publicipdev[count.index].id : null
    }
    depends_on = [
      azurerm_public_ip.publicipdev ,
      azurerm_virtual_network.task5vnet,
      azurerm_subnet.subnet
    ]
}
resource "azurerm_network_interface" "nicsqa" {
    count = var.enviroment == "qa" ? var.numberofvms:0
    name =  "${var.enviroment}nic-${count.index}"
    location = var.resourcegroup_details.location
    resource_group_name = azurerm_resource_group.resourgegroup.name
    ip_configuration {
      name = "nicqaipconfig${count.index}"
      subnet_id = azurerm_subnet.subnet[0].id
      private_ip_address_allocation = "Dynamic"
       
    }
    depends_on = [
      azurerm_virtual_network.task5vnet,
      azurerm_subnet.subnet
    ]
}
resource "azurerm_network_interface_security_group_association" "mySecGroupAssociation1" {
    count = var.numberofvms
    network_interface_id      =  var.enviroment=="dev" ? azurerm_network_interface.nicsdev[ count.index].id : azurerm_network_interface.nicsqa[count.index].id 
    network_security_group_id = azurerm_network_security_group.nsg.id
depends_on = [
  
  azurerm_network_security_group.nsg
]
}
 




