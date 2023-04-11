resource "azurerm_lb" "my_lb" {
  name                = "mylb"
  resource_group_name = azurerm_resource_group.MYRGP.name
    location = azurerm_resource_group.MYRGP.location

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pubip.ip_address
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id     = azurerm_lb.my_lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.MYRGP.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.my_lb.id
  protocol                       = "All"
  frontend_port_start            = 80
  frontend_port_end              = 80
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "my_healthprob" {
  
  loadbalancer_id     = azurerm_lb.my_lb.id
  name                = "http-probe"
  protocol            = "Tcp"
  port                = 80
}