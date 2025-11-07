environment = "dev"

resource_group = {
  name     = "rg-nuaura-tech-dev"
  location = "westeurope"
  create   = true
}

hub = {
  name                       = "vnet-nuau-dev-hub"
  address_space              = ["10.0.0.0/16"]
  gateway_subnet_cidr        = "10.0.0.0/27"
  runner_subnet_cidr         = "10.0.0.32/27"
  dns_resolver_inbound_cidr  = "10.0.0.96/27"
  dns_resolver_outbound_cidr = "10.0.0.128/27"
}

spoke = {
  name                    = "vnet-nuau-dev-spoke"
  address_space           = ["10.1.0.0/16"]
  appsvc_integration_cidr = "10.1.0.0/26"
  aca_env_cidr            = "10.1.0.64/26"
}

dns_resolver_enabled = false

peering_options = {
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  hub_allow_gateway_transit    = false
  spoke_use_remote_gateway     = false
}

tags = {
  workload    = "nuau"
  cost_center = "poc"
  owner       = "nuaura-tech"
  project     = "nuaura-tech"
  environment = "dev"
}
