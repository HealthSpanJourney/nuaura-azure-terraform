variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, test, prod)."
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
    create   = optional(bool, false)
  })
  description = "Existing resource group where networking resources will be managed."
}

# variable "location" {
#   type        = string
#   description = "Azure region for the deployment."
# }

variable "hub" {
  type = object({
    name                       = string
    address_space              = list(string)
    gateway_subnet_cidr        = string
    runner_subnet_cidr         = string
    dns_resolver_inbound_cidr  = optional(string)
    dns_resolver_outbound_cidr = optional(string)
    private_endpoints_cidr     = string
  })
  description = "Hub virtual network configuration passed to the module."
}

variable "spoke" {
  type = object({
    name                    = string
    address_space           = list(string)
    appsvc_integration_cidr = string
    aca_env_cidr            = string
  })
  description = "Spoke virtual network configuration passed to the module."
}

variable "dns_resolver_enabled" {
  type        = bool
  default     = false
  description = "Toggle deployment of the DNS resolver subnets in the hub."
}

variable "peering_options" {
  type = object({
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    hub_allow_gateway_transit    = bool
    spoke_use_remote_gateway     = bool
  })
  default = {
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    hub_allow_gateway_transit    = false
    spoke_use_remote_gateway     = false
  }
  description = "Controls connectivity flags on the hub ↔ spoke VNet peerings."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to all created resources."
}

