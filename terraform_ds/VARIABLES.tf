# variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
# variable "tenant_id" {}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  default     = "ntmadsrg"
}

variable "tag" {
  description = "A tag"
  default     = "Data Science ENV"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "westeurope"
}

variable "vnet" {
  description = "The virtual network is created. Changing this forces a new resource to be created."
  default     = "ntmadsvnet"
}

variable "subnet" {
  description = "The virtual network is created. Changing this forces a new resource to be created."
  default     = "ntmadsSubnet"
}

variable "public_ip" {
  description = "Public Ip address name"
  default     = "ntmadspublicip"
}

variable "network_security_group" {
  description = "dsNetworkSecurityGroup"
  default     = "dsNetworkSecurityGroup"
}

variable "nic" {
  description = "nic"
  default     = "ntmadsNIC"
}

/* # Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${var.resource_group_name}"
  }

  byte_length = 8
} */

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}

variable "vm_sku" {
  description = "Size of VMs in the VM Scale Set."
  default     = "Standard_DS12_v2"
}

variable "vm_disk" {
  description = "Disk"
  default     = "Standard_LRS"
}

variable "ubuntu_os_version" {
  description = "The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version. Allowed values are: 15.10, 14.04.4-LTS."
  default     = "linuxdsvmubuntu"
}

variable "image_publisher" {
  description = "The name of the publisher of the image (az vm image list)"
  default     = "microsoft-ads"
}

variable "image_offer" {
  description = "The name of the offer (az vm image list)"
  default     = "linux-data-science-vm-ubuntu"
}

variable "hostname" {
  description = "A string that determines the hostname/IP address of the origin server. This string could be a domain name, IPv4 address or IPv6 address."
  default     = "dsvm"
}

variable "compname" {
  description = "A string that determines the hostname/IP address of the origin server. This string could be a domain name, IPv4 address or IPv6 address."
  default     = "dsVM"
}

variable "admin_username" {
  description = "Admin username on all VMs."
  default     = "azureuser"
}

/*
variable "admin_password" {
  description = "Admin password on all VMs."
}

variable "vmss_name_prefix" {
  description = "String used as a base for naming resources. Must be 1-9 characters in length for windows and 1-58 for linux images and globally unique across Azure. A hash is prepended to this string for some resources, and resource-specific information is appended."
}

variable "instance_count" {
  description = "Number of VM instances (100 or less)."
  default     = "5"
}

 */

