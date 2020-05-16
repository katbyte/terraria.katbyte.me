locals {
  public_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuRBwojvKE0auGE0GXmA80qZHVWKRbhaT/+9PEGwXzX0yi33ikT6nAYLdbjc9/1H4Tf7/5jBFJv/uI5L3zPSCIF048Kiajc4PSFgJp8EVj2LLsp20dhvqh8M5KmLBAGqWuqspnll5XPqOZtqEN4FM4Sw/Fr6CkhYF6v9RD7T0ZPtUg51xsP5NjK6U6syyCKehBfwAOKxnk9hAQC+vK9Rw9HiMlCEHfwNAJOBLBucAOJd8SjWBE22YxmpNYex6TfnopfLgoQ/DJ2dDkTQ8h5lXvzSc9O2jvm9w7vWhVE9sRyGsE+R/3MxAkvdTj+RMW91YTBF9C7XGSGsvlVgtxB0EIGHmRoUupkAD7DdaCoWS+sgfIO7XomTshB6HOmtiAqKO5Utu1YDJI27qzgqpVCAQLMipxKBSGStQAuSIobKYfA8nTSjDTwX5ZbYpQpqGEz5d+N7OfEM2F8CoYSlTg6m6dl/3qi8wdLhcPoO4TxzMP8rZokCm+KwILnaXfNM+3DWNqp5GT7t77PcPq4OCwn2piPw9UH2D4j6AAlsuFkyAQIl39xD/uc7/WNES4D71Twlo/Sk3tTbowDXrHMbar9bmmfRXCb/OcW1caUpRsmwPbH1+WcOjJYSzcFL1lvJoFrLpiQWK9yUTdKBt3zrVZFpEZBTfMAtbMw6YPtEEG7C/iPw== kt@snowbook"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "westus2"
  name     = "terraria.azure.katbyte.me"
}

resource "azurerm_virtual_network" "vn" {
  name                = "terraria-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "sn" {
  name                 = "terraria-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "terraria-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "terraria-azure-katbyte-me"
}

resource "azurerm_network_interface" "nic" {
  name                = "terraria-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "terraria-nic-ip"
    subnet_id                     = azurerm_subnet.sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "terraria.azure.katbyte.me"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = local.public_ssh_key

  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

output "ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "fqdn" {
  value = azurerm_public_ip.pip.fqdn
}