resource "azurerm_linux_virtual_machine_scale_set" "myvmss" {
  name                = var.vmss_name.name
  resource_group_name = azurerm_resource_group.MYRGP.name
  location            = azurerm_resource_group.MYRGP.location
  instances           = var.vmss_name.numberofinstance
  sku                 = local.skusize 
  admin_username = var.vmss_name.username
  os_disk {
    storage_account_type = local.storage_account_type
    caching              = local.caching
  }
     admin_ssh_key {
    username   = var.vmss_name.username
    public_key = file("~/.ssh/id_rsa.pub")
  }
   source_image_reference {
    publisher = local.publisher
    offer     = local.offer
    sku       = local.sku
    version   = local.version
   }
   
   network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = local.network_interface_name
      primary   = true
      subnet_id = azurerm_subnet.internal.id
    }
  }
  tags = {
    environment = terraform.workspace
  }
  depends_on = [
    azurerm_resource_group.MYRGP,
    azurerm_subnet.internal
  ]

  
}
