# -------------------------------------------------------------------
# Network Resource Group
# -------------------------------------------------------------------

resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# -------------------------------------------------------------------
# Virtual Network
# -------------------------------------------------------------------

resource "azurerm_virtual_network" "this" {
  name                = "${var.name_prefix}-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  address_space = [
    var.vnet_cidr
  ]

  tags = var.tags
}

# -------------------------------------------------------------------
# Azure Container Apps Infrastructure Subnet
#
# This subnet is exclusively for the Container Apps Environment.
# -------------------------------------------------------------------

resource "azurerm_subnet" "aca" {
  name = "${var.name_prefix}-aca-snet"

  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [
    var.aca_subnet_cidr
  ]

  delegation {
    name = "container-apps-delegation"

    service_delegation {
      name = "Microsoft.App/environments"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# -------------------------------------------------------------------
# Private Endpoint Subnet
#
# Future:
#   Key Vault
#   Storage
#   ACR
#   databases
#   other PaaS services
# -------------------------------------------------------------------

resource "azurerm_subnet" "private_endpoints" {
  name = "${var.name_prefix}-private-endpoints-snet"

  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [
    var.private_endpoint_subnet_cidr
  ]

  private_endpoint_network_policies = "Disabled"
}