environment         = "prod"
resource_group_name = "rg-nuaura-tech-prod"
location            = "northeurope"

hub = {
  name                       = "vnet-nuau-prod-hub"
  address_space              = ["10.30.0.0/16"]
  gateway_subnet_cidr        = "10.30.0.0/27"
  runner_subnet_cidr         = "10.30.0.32/26"
  dns_resolver_inbound_cidr  = "10.30.0.96/27"
  dns_resolver_outbound_cidr = "10.30.0.128/27"
}

spoke = {
  name                    = "vnet-nuau-prod-spoke"
  address_space           = ["10.31.0.0/16"]
  appsvc_integration_cidr = "10.31.0.0/26"
  aca_env_cidr            = "10.31.0.64/26"
}

dns_resolver_enabled = true

peering_options = {
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  hub_allow_gateway_transit    = true
  spoke_use_remote_gateway     = true
}

tags = {
  workload    = "nuau"
  cost_center = "prod"
}

