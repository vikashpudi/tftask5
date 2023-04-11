  resource "azurerm_lb" "lb" {
    count = var.enviroment == "qa" ? 1:0
   name                = "${var.enviroment}-lb"
   location            = azurerm_resource_group.resourgegroup.location
   resource_group_name = azurerm_resource_group.resourgegroup.name
   frontend_ip_configuration {
     name                 = "${var.enviroment}-pubip"
     public_ip_address_id = azurerm_public_ip.publicipqa[0].id
   }
 }

 resource "azurerm_lb_backend_address_pool" "be" {
   count = var.enviroment == "qa" ? 1:0
   loadbalancer_id     = azurerm_lb.lb[count.index].id
   name                = "BackEndAddressPool"
 }
 resource "azurerm_lb_probe" "lbprobe" {
   count = var.enviroment == "qa" ? 1:0
  loadbalancer_id = azurerm_lb.lb[count.index].id
  name            = "ssh-running-probe"
  protocol = "Tcp"
  port            = 80
}
resource "azurerm_lb_rule" "lbrule" {
   count = var.enviroment == "qa" ? 1:0
  loadbalancer_id                = azurerm_lb.lb[count.index].id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.enviroment}-pubip"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.be[count.index].id ]
  probe_id = azurerm_lb_probe.lbprobe[count.index].id
}
resource "azurerm_network_interface_backend_address_pool_association" "lbbackendpoolassociatin" {
count = var.enviroment == "qa" ? var.numberofvms : 0

#network_interface_id = azurerm_network_interface.nicsqa[count.index].id
network_interface_id = element(azurerm_network_interface.nicsqa.*.id,count.index) 
ip_configuration_name = "nicqaipconfig${count.index}"
backend_address_pool_id = azurerm_lb_backend_address_pool.be[0].id
  
}
resource "null_resource" "name" {
  provisioner "file" {
    connection
  }

}