/*
data "template_file" "cloudinitdata" {
  template = file("apacheconfig.sh")
}
*/

data "template_file" "linux-vm-cloud-init" {
  template = file("apacheconfig.sh")
}

resource "azurerm_linux_virtual_machine" "myvm" {
  name                  = var.vm_name
  computer_name         = var.vm_name
  location              = azurerm_resource_group.myrg.location
  resource_group_name   = azurerm_resource_group.myrg.name
  network_interface_ids = [azurerm_network_interface.mynic.id]
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  custom_data           = base64encode(data.template_file.linux-vm-cloud-init.rendered)

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/D:/Lakshmikanth/Study/Devops/Azure Devops/SSH Keys/id_rsa.pub")
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

