locals {
  common_tags = merge({
    "environment" = var.environment
  }, var.tags)
}

module "hub_spoke_network" {
  source = "./modules/hub_spoke_network"

  # module expects the resource group object (name, location, create), so pass
  # the entire object from root variables.
  resource_group = var.resource_group
  #location            = var.location

  hub   = var.hub
  spoke = var.spoke

  dns_resolver_enabled = var.dns_resolver_enabled
  peering_options      = var.peering_options
  tags                 = local.common_tags
}
