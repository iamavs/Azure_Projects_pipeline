#Front end Public IP
resource "azurerm_public_ip" "mypip2" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.myrg ]
}

#Azure Load balancer Config
resource "azurerm_lb" "mylb" {
  name                = "Apachelb"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.mypip2.id
  }
  depends_on = [ azurerm_linux_virtual_machine.myvm ]
}

#Azure Load balancer Rule
resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.mylb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.mylb.frontend_ip_configuration[0].name
  backend_address_pool_ids   = [azurerm_lb_backend_address_pool.mylbbackend.id]
  probe_id = azurerm_lb_probe.healthprobe.id
  depends_on = [ azurerm_lb_backend_address_pool.mylbbackend, azurerm_lb_probe.healthprobe ]
}

#Azure Load Balancer Backend
resource "azurerm_lb_backend_address_pool" "mylbbackend" {
  loadbalancer_id = azurerm_lb.mylb.id
  #resource_group_name = azurerm_resource_group.myrg.name
  name            = "BackEndAddressPool"
}

#Azure Backend association with Network Interface
resource "azurerm_network_interface_backend_address_pool_association" "lbassociation" {
  count = var.no_instances
  network_interface_id = azurerm_network_interface.mynic[count.index].id
  ip_configuration_name = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.mylbbackend.id
  depends_on = [ azurerm_network_interface.mynic, azurerm_lb_backend_address_pool.mylbbackend ]
}

#Azure Load Balancer Health probe
resource "azurerm_lb_probe" "healthprobe" {
  loadbalancer_id = azurerm_lb.mylb.id
  name            = "http"
  port            = 80
}