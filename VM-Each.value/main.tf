
resource "azurerm_resource_group" "rg-b" {
  for_each = var.rgs
  name = each.value.name
  location = each.value.location
}
resource "azurerm_storage_account" "stg-block" { 
  for_each = var.stgs
  depends_on = [azurerm_resource_group.rg-b]
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}

resource "azurerm_virtual_network" "vnet-b" {
  depends_on = [ azurerm_resource_group.rg-b ]
  for_each = var.vnets
  name                = each.value.vnet_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
}

resource "azurerm_subnet" "subnet-b" {
for_each = var.subnets
 depends_on = [ azurerm_virtual_network.vnet-b ]
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_interface" "nic-b" {

  for_each = var.nics
  depends_on = [ azurerm_subnet.subnet-b ]
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "frontend-ip"
    subnet_id                     = azurerm_subnet.subnet-b[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public-b[each.value.pip_name].id
}
}

resource "azurerm_network_security_group" "nsg-b" {
  depends_on = [azurerm_resource_group.rg-b]
  for_each = var.nsgs
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = each.value.name
    priority                   = each.value.priority
    direction                  = each.value.direction
    access                     = each.value.access
    protocol                   = each.value.protocol
    source_port_range          = each.value.source_port_range
    destination_port_range     = each.value.destination_port_range
    source_address_prefix      = each.value.source_address_prefix
    destination_address_prefix = each.value.destination_address_prefix
  }

}

resource "azurerm_linux_virtual_machine" "vm-b" {

  for_each = var.vms
  depends_on = [  azurerm_network_interface.nic-b ]
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password = each.value.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic-b[each.value.nic_name].id,
  ]
disable_password_authentication =  false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  provisioner "remote-exec" {
    inline = [
        "sleep 30",
        "sudo apt-get update -y",
        "sudo apt-get install -y nginx"
     ]

    connection {
      type = "ssh"
      user = "vikram"
      password = "Vikram@12345678"
      host = self.public_ip_address
    }
  }
}

resource "azurerm_network_interface_security_group_association" "asso-b" {
  depends_on = [azurerm_resource_group.rg-b]
  for_each = var.associations
  network_interface_id      = azurerm_network_interface.nic-b[each.value.nic_name].id
  network_security_group_id = azurerm_network_security_group.nsg-b[each.value.nsg_name].id
}


resource "azurerm_public_ip" "public-b" {
  depends_on = [azurerm_resource_group.rg-b]
  for_each = var.pips
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
}
 







