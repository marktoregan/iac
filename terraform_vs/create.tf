variable "resourcename" {
  default = "ntmavs"
}

# Configure the Microsoft Azure Provider
#provider "azurerm" {
#   subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#  client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "vsgroup" {
  name     = "ntmavs"
  location = "westeurope"

  tags {
    environment = "Data Science ENV"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "vsnetwork" {
  name                = "vsVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  resource_group_name = "${azurerm_resource_group.vsgroup.name}"

  tags {
    environment = "Data Science ENV"
  }
}

# Create subnet
resource "azurerm_subnet" "vssubnet" {
  name                 = "vsSubnet"
  resource_group_name  = "${azurerm_resource_group.vsgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vsnetwork.name}"
  address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "vspublicip" {
  name                         = "vsPublicIP"
  location                     = "westeurope"
  resource_group_name          = "${azurerm_resource_group.vsgroup.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "Data Science ENV"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "vsterraformnsg" {
  name                = "vsNetworkSecurityGroup"
  location            = "westeurope"
  resource_group_name = "${azurerm_resource_group.vsgroup.name}"

  security_rule {
    name                       = "RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Data Science ENV"
  }
}

# Create network interface
resource "azurerm_network_interface" "vsnic" {
  name                      = "vsNIC"
  location                  = "westeurope"
  resource_group_name       = "${azurerm_resource_group.vsgroup.name}"
  network_security_group_id = "${azurerm_network_security_group.vsterraformnsg.id}"

  ip_configuration {
    name                          = "vsNicConfiguration"
    subnet_id                     = "${azurerm_subnet.vssubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vspublicip.id}"
  }

  tags {
    environment = "Data Science ENV"
  }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.vsgroup.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "vsstorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.vsgroup.name}"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    environment = "Data Science ENV"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "vsterraformvm" {
  name                  = "vsVM"
  location              = "westeurope"
  resource_group_name   = "${azurerm_resource_group.vsgroup.name}"
  network_interface_ids = ["${azurerm_network_interface.vsnic.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "vsOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftVisualStudio"
    offer     = "VisualStudio"
    sku       = "VS-2017-Ent-Latest-Preview-WS2016"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vsvm"
    admin_username = "vsadmin"
    admin_password = "LillyWalkInW00ds"
  }

  os_profile_windows_config {}

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.vsstorageaccount.primary_blob_endpoint}"
  }

  tags {
    environment = "Data Science ENV"
  }
}
