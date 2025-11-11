locals {
  peering = var.peering_options

  dns_inbound_cidr      = try(var.hub.dns_resolver_inbound_cidr, null)
  dns_outbound_cidr     = try(var.hub.dns_resolver_outbound_cidr, null)
  create_resource_group = try(var.resource_group.create, false)
}

resource "azurerm_resource_group" "this" {
  count    = local.create_resource_group ? 1 : 0
  name     = var.resource_group.name
  location = var.resource_group.location

  tags = var.tags
}

locals {
  rg_name     = local.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group.name
  rg_location = local.create_resource_group ? azurerm_resource_group.this[0].location : var.resource_group.location
}

resource "azurerm_virtual_network" "hub" {
  name                = var.hub.name
  location            = local.rg_location
  resource_group_name = local.rg_name
  address_space       = var.hub.address_space

  tags = var.tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke.name
  location            = local.rg_location
  resource_group_name = local.rg_name
  address_space       = var.spoke.address_space

  tags = var.tags
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub.gateway_subnet_cidr]
}

resource "azurerm_subnet" "runner" {
  name                 = "RunnerSubnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub.runner_subnet_cidr]
}

resource "azurerm_subnet" "dns_resolver_inbound" {
  count                = var.dns_resolver_enabled ? 1 : 0
  name                 = "DnsResolver-Inbound"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [local.dns_inbound_cidr]
}

resource "azurerm_subnet" "dns_resolver_outbound" {
  count                = var.dns_resolver_enabled ? 1 : 0
  name                 = "DnsResolver-Outbound"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [local.dns_outbound_cidr]
}

resource "azurerm_subnet" "private_endpoints" {
  name                = "PrivateEndpoints"
  resource_group_name = local.rg_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes    = [var.hub.private_endpoints_cidr]

  # This subnet will be used for private endpoints
  service_endpoints = ["Microsoft.KeyVault", 
                      "Microsoft.ContainerRegistry",
                      "Microsoft.Storage",
                      "Microsoft.CognitiveServices"]

  # Private endpoint network policies are now controlled at the private endpoint level
  private_link_service_network_policies_enabled = false  # Allows private endpoints to be created


}


resource "azurerm_subnet" "appsvc_integration" {
  name                 = "AppSvc-Integration"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.spoke.appsvc_integration_cidr]

  delegation {
    name = "appsvc-integration"

    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "aca_env" {
  name                 = "ACA-Env"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.spoke.aca_env_cidr]

  delegation {
    name = "aca-env"

    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "${azurerm_virtual_network.hub.name}-to-${azurerm_virtual_network.spoke.name}"
  resource_group_name       = local.rg_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_forwarded_traffic      = local.peering.allow_forwarded_traffic
  allow_gateway_transit        = local.peering.hub_allow_gateway_transit
  allow_virtual_network_access = local.peering.allow_virtual_network_access
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "${azurerm_virtual_network.spoke.name}-to-${azurerm_virtual_network.hub.name}"
  resource_group_name       = local.rg_name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_forwarded_traffic      = local.peering.allow_forwarded_traffic
  allow_virtual_network_access = local.peering.allow_virtual_network_access
  use_remote_gateways          = local.peering.spoke_use_remote_gateway
}
