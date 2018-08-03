# Create virtual machine

resource "azurerm_virtual_machine" "dsterraformvm" {
  name                  = "${var.hostname}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.dsgroup.name}"
  network_interface_ids = ["${azurerm_network_interface.dsnic.id}"]
  vm_size               = "${var.vm_sku}"

  storage_os_disk {
    name              = "${var.osdisk}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_disk}"
  }

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.ubuntu_os_version}"
    version   = "latest"
  }

  plan {
    publisher = "${var.image_publisher}"
    product   = "${var.image_offer}"
    name      = "${var.ubuntu_os_version}"
  }

  os_profile {
    computer_name  = "${var.compname}"
    admin_username = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlnI2t+Vds2cZL5469meKCODeR/1dkUPlvPGY35znI0g/RXZqmsU/gcwjDfBb7x05UbaNtdKF3BgSif05FXXczKL9GUZ/Zuq19nUKn9YoL/m7Xfv6yQ080VI9lB9e5TzVCuI/0Tm5gvNcIBXdJ5L4m3uoDVChKe/lUArett9DPjDZ0PSfpdMMBFp9K5LPEnyY033OlV15ljaK+XjuFuQhzAQtLFlIukMGPU4+GxoEDaxUxeZYdAcDP+hWKZEXaEypAhXP7pbf3o3C8Kg/y1aWwvLqXOntjg9bsr0rSUMl47i86jLXyEtiA1nn9lLO9nUhjMd8lIR8tkszyCoHZ7NNf mark.t.oregan@mycit.ie"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.dsstorageaccount.primary_blob_endpoint}"
  }

  tags {
    environment = "${var.tag}"
  }

  provisioner "local-exec" {
    command = "az vm user update --resource-group ${azurerm_resource_group.dsgroup.name} --name ${var.compname} --username oreganm --password Lilly16Python"
  }

  provisioner "local-exec" {
    command = "az vm user update --resource-group ${azurerm_resource_group.dsgroup.name} --name ${var.compname} --username moloneyg --password Lilly16Python"
  }

  provisioner "local-exec" {
    command = "az vm user update --resource-group ${azurerm_resource_group.dsgroup.name} --name ${var.compname} --username pentonym --password Lilly16Python"
  }
}
