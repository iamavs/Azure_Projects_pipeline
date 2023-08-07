resource "azurerm_virtual_network" "myvnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = var.vnet_address
  depends_on = [ azurerm_resource_group.myrg ]
}

resource "azurerm_subnet" "mysubnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = var.subnet_address
  depends_on = [ azurerm_virtual_network.myvnet ]
}

resource "azurerm_public_ip" "mypip" {
  count = var.no_instances
  name                = "${var.pip_name}${count.index + 1}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  depends_on = [ azurerm_virtual_network.myvnet ]
}

resource "azurerm_network_interface" "mynic" {
  count = var.no_instances
  name                = "${var.nic_name}${count.index +1}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypip[count.index].id
  }
  depends_on = [ azurerm_subnet.mysubnet ]
}

