# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "dsgroup" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "${var.tag}"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "dsnetwork" {
  name                = "${var.vnet}"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.dsgroup.location}"
  resource_group_name = "${azurerm_resource_group.dsgroup.name}"

  tags {
    environment = "${var.tag}"
  }
}

# Create subnet
resource "azurerm_subnet" "dssubnet" {
  name                 = "${var.subnet}"
  resource_group_name  = "${azurerm_resource_group.dsgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.dsnetwork.name}"
  address_prefix       = "10.0.1.0/24"
}