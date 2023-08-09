# Used to add shell files
data "template_file" "linux-vm-cloud-init" {
  template = file("apacheconfig.sh")
}

/*
# Used to access SSH keys from Keyvault
data "azurerm_key_vault_secret" "mysecret" {
    name         = "id-rsa"
    key_vault_id = "/subscriptions/bf7a6566-c7d3-4936-b331-55a557799448/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/keyvault03082023"
}
*/

# Used to access Public SSH keys from Azure SSH Keys 
data "azurerm_ssh_public_key" "mysshkey"{
  name = "LinuxKey"
  resource_group_name = "rg"
}

# Deploying VMs in same Availibility set
resource "azurerm_availability_set" "vmavailabilty" {
  name = "vmavailabiltyset"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "myvm" {
  count = var.no_instances
  name                  = "${var.vm_name}${count.index + 1}"
  computer_name         = "${var.vm_name}${count.index + 1}"
  location              = azurerm_resource_group.myrg.location
  resource_group_name   = azurerm_resource_group.myrg.name
  network_interface_ids = [azurerm_network_interface.mynic[count.index].id]
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  availability_set_id = azurerm_availability_set.vmavailabilty.id
  custom_data           = base64encode(data.template_file.linux-vm-cloud-init.rendered)

  admin_ssh_key {
    username = "azureuser"
    #Used for Azure Key Vault
    #public_key = data.azurerm_key_vault_secret.mysecret.value
    #Used for Azure SSH Keys
    public_key = data.azurerm_ssh_public_key.mysshkey.public_key
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