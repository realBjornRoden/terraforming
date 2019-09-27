provider "azurerm" {
}

resource "azurerm_resource_group" "rg" {
	name     = "rg-default-01"
	location = "eastus"
}

variable "vmname" {
	default     = "vm-solo-01"
}
variable "ssh_key" {
	default     = "~/.ssh/id_rsa.pub"
}
variable "admin_username" {
	default     = "az-user"
}

resource "azurerm_virtual_machine" "example" {
	name                          = "${var.vmname}"
	location                      = "${azurerm_resource_group.rg.location}"
	resource_group_name           = "${azurerm_resource_group.rg.name}"
	primary_network_interface_id  = "${azurerm_network_interface.external.id}"
	network_interface_ids         = ["${azurerm_network_interface.external.id}", "${azurerm_network_interface.internal.id}"]

	vm_size                       = "Standard_B1s"
	delete_os_disk_on_termination = true

	storage_image_reference {
		publisher = "OpenLogic"
		offer     = "CentOS"
		sku       = "7.5"
		version   = "latest"
	}

	storage_os_disk {
		name              = "${var.vmname}-bootdisk"
		caching           = "ReadWrite"
		create_option     = "FromImage"
		managed_disk_type = "Standard_LRS"
	}

	os_profile {
		computer_name  = "${var.vmname}"
		admin_username = "${var.admin_username}"
	}

	os_profile_linux_config {
		disable_password_authentication = true
		ssh_keys {
			path     = "/home/${var.admin_username}/.ssh/authorized_keys"
			key_data = "${file("~/.ssh/id_rsa.pub")}"
		}
	}
}

resource "azurerm_virtual_network" "vnet" {
	name                = "vnet-172-16-0-0--16"
	address_space       = ["172.16.0.0/16"]
	resource_group_name = "${azurerm_resource_group.rg.name}"
	location            = "${azurerm_resource_group.rg.location}"
}

resource "azurerm_subnet" "external" {
	name                 = "vsubnet-172-16-1-0--24-external"
	virtual_network_name = "${azurerm_virtual_network.vnet.name}"
	resource_group_name  = "${azurerm_resource_group.rg.name}"
	address_prefix       = "172.16.1.0/24"
}

resource "azurerm_subnet" "internal" {
	name                 = "vsubnet-172-16-2-0--24-internal"
	virtual_network_name = "${azurerm_virtual_network.vnet.name}"
	resource_group_name  = "${azurerm_resource_group.rg.name}"
	address_prefix       = "172.16.2.0/24"
}

resource "azurerm_public_ip" "public" {
	name                = "${var.vmname}-publicip"
	location            = "${azurerm_resource_group.rg.location}"
	resource_group_name = "${azurerm_resource_group.rg.name}"
	allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
	name                = "nsg-default-01"
	location            = "${azurerm_resource_group.rg.location}"
	resource_group_name = "${azurerm_resource_group.rg.name}"
	security_rule {
		name                       = "allow_SSH"
		description                = "Allow SSH access"
		priority                   = 100
		direction                  = "Inbound"
		access                     = "Allow"
		protocol                   = "Tcp"
		source_address_prefix      = "*"
		source_port_range          = "*"
		destination_address_prefix = "*"
		destination_port_range     = "22"
	}
}

resource "azurerm_network_interface" "external" {
	name                      = "${var.vmname}-external"
	location                  = "${azurerm_resource_group.rg.location}"
	resource_group_name       = "${azurerm_resource_group.rg.name}"
	network_security_group_id = "${azurerm_network_security_group.nsg.id}"
	ip_configuration {
		name                          = "primary"
		subnet_id                     = "${azurerm_subnet.external.id}"
		public_ip_address_id          = "${azurerm_public_ip.public.id}"
		private_ip_address_allocation = "Dynamic"
	}
}

resource "azurerm_network_interface" "internal" {
	name                = "${var.vmname}-internal"
	location            = "${azurerm_resource_group.rg.location}"
	resource_group_name = "${azurerm_resource_group.rg.name}"
	ip_configuration {
		name                          = "primary"
		subnet_id                     = "${azurerm_subnet.internal.id}"
		private_ip_address_allocation = "Dynamic"
	}
}

