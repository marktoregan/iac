# Create public IPs
resource "azurerm_public_ip" "dspublicip" {
  name                         = "${var.ipname}"
  location                     = "${var.location}"
  resource_group_name          = "${var.ip_resource_group_name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "${var.domain_name_label}"

  tags {
    environment = "${var.tag}"
  }
}

# Create network interface
resource "azurerm_network_interface" "dsnic" {
  name                      = "${var.nic}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.dsgroup.name}"
  network_security_group_id = "${azurerm_network_security_group.dsnsg.id}"

  ip_configuration {
    name                          = "dsNicConfiguration"
    subnet_id                     = "${azurerm_subnet.dssubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.dspublicip.id}"
  }

  tags {
    environment = "${var.tag}"
  }
}
