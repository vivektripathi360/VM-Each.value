rgs = {
  rg1 = {
    name     = "test-rg"
    location = "centralindia"
  }
}

stgs = {
  stg1 = {
    name                     = "stg987654321"
    resource_group_name      = "test-rg"
    location                 = "centralindia"
    account_tier             = "Standard"
    account_replication_type = "LRS"
   
  }
}


vnets = {
  elearn-vnet = {
    vnet_name = "elearn-vnet"
    location = "centralindia"
    resource_group_name = "test-rg"
    address_space = ["10.0.0.0/16"]
    nic_name = "frontend-nic"
  }
}

subnets = {
  frontend-subnet = {
    subnet_name = "frontend-subnet"
    vnet_name = "elearn-vnet"
    resource_group_name = "test-rg"
    address_prefixes = ["10.0.0.0/24"]
  }
  backend-subnet = {
    subnet_name = "backend-subnet"
    vnet_name = "elearn-vnet"
    resource_group_name = "test-rg"
    address_prefixes = ["10.0.1.0/24"]
  }

}

nsgs = {
frontend-nsg = {
  name = "frontend-nsg"
  location = "centralindia"
  resource_group_name = "test-rg"
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  
}
backend-nsg = {
  name = "backend-nsg"
  location = "centralindia"
  resource_group_name = "test-rg"
    name                       = "test1234"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}
}


nics = {
  frontend-nic = {
    name = "frontend_nic"
    location = "centralindia"
    resource_group_name = "test-rg"
    subnet_name = "frontend-subnet"
    pip_name = "frontend-pip"
  }
 backend-nic = {
    name = "backend_nic"
    location = "centralindia"
    resource_group_name = "test-rg"
    subnet_name = "backend-subnet"
    pip_name = "backend-pip"
  }
}

pips = {
  frontend-pip = {
    name = "frontend-pip"
    resource_group_name = "test-rg"
    location = "centralindia"
    allocation_method = "Static"
  }
    backend-pip = {
    name = "backend-pip"
    resource_group_name = "test-rg"
    location = "centralindia"
    allocation_method = "Static"
  }
}

vms = {
  frontend-vm = {
    name = "frontend-vm"
    location = "centralindia"
    resource_group_name = "test-rg"
    size = "Standard_F2"
    admin_username = "vikram"
    admin_password = "Vikram@12345678"
    nic_name = "frontend-nic"
  }
  backend-vm = {
    name = "backend-vm"
    location = "centralindia"
    resource_group_name = "test-rg"
    size = "Standard_F2"
    admin_username = "vikram"
    admin_password = "Vikram@12345678"
    nic_name = "backend-nic"
  }

}

associations = {
  assoc1 = {
    nic_name = "frontend-nic"
    nsg_name = "frontend-nsg"
    resource_group_name = "test-rg"
  }
  assoc2 = {
    nic_name = "backend-nic"
    nsg_name = "backend-nsg"
    resource_group_name = "test-rg"
  }

}
