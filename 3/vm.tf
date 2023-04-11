count = var.numberofvms
#nic for each vm is created
resource "azurerm_network_interface" "vmnic" {
  name                = "nic-${var.evn}-${local.vm}-${count.index} "
  location            = azurerm_resource_group.resgroup.location
  resource_group_name = azurerm_resource_group.resgroup.name
  subnet_id                     = azurerm_subnet.subnet1.id
  private_ip_address_allocation = local.privateipaddressallocation
  }
 
resource "azurerm_virtual_machine" "main" {
  name                  = "${terraform.workspace}-${local.vm}-${count.index}"
  location              = azurerm_resource_group.resgroup.location
  resource_group_name   = azurerm_resource_group.resgroup.name
  network_interface_ids = [azurerm_network_interface.mynic.id]
  vm_size               = local.vmsize













storage_image_reference {
    publisher = local.publisher
    offer     = local.offer
    sku       = local.sku
    version   = local.version
  }
   storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
}
os_profile {
    computer_name  = "murali"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
tags = {
    environment = terraform.workspace
  }
}