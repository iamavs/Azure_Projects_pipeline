/*
# Deploying VMs in same Availibility set
resource "azurerm_availability_set" "vmavailabilty" {
  name                = "vmavailabiltyset"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
*/
resource "azurerm_windows_virtual_machine" "mywindowsvm" {
  count                 = var.no_instances
  name                  = "${var.vm_name}${count.index + 1}"
  resource_group_name   = azurerm_resource_group.myrg.name
  location              = azurerm_resource_group.myrg.location
  size                  = "Standard_F2"
  admin_username        = "adminuser"
  admin_password        = "P@$$w0rd1234!"
  #availability_set_id   = azurerm_availability_set.vmavailabilty.id
  network_interface_ids = [azurerm_network_interface.mynic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
