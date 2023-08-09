resource "azurerm_public_ip" "mypip2" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "mylb" {
  name                = "Apachelb"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.mypip2.id
  }
}

resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.mylb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.mylb.frontend_ip_configuration[0].name
  backend_address_pool_ids   = [azurerm_lb_backend_address_pool.mylbbackend.id]
  probe_id = azurerm_lb_probe.healthprobe.id
}

resource "azurerm_lb_backend_address_pool" "mylbbackend" {
  loadbalancer_id = azurerm_lb.mylb.id
  #resource_group_name = azurerm_resource_group.myrg.name
  name            = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "lbassociation" {
  count = var.no_instances
  network_interface_id = azurerm_network_interface.mynic[count.index].id
  ip_configuration_name = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.mylbbackend.id
}

/*
resource "azurerm_lb_backend_address_pool_address" "mylbbackendpool" {
  count = var.no_instances
  name                    = "BackEndAddressPooladdress"
  backend_address_pool_id = azurerm_lb_backend_address_pool.mylbbackend.id
  virtual_network_id      = azurerm_virtual_network.myvnet.id
  ip_address              = azurerm_linux_virtual_machine.myvm[count.index].private_ip_address
}
*/

resource "azurerm_lb_probe" "healthprobe" {
  loadbalancer_id = azurerm_lb.mylb.id
  name            = "http"
  port            = 80
}

