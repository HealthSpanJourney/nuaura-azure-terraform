variable "resource_group" {
  type = object({
    name     = string
    location = string
    create   = optional(bool, false)
  })
  description = "Resource group object (name, location, create) where the virtual networks will be created."
}

# variable "location" {
#   type        = string
#   description = "Azure region for the virtual networks and subnets."
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
  description = "Configuration for the hub virtual network and its subnets."
}

variable "spoke" {
  type = object({
    name                    = string
    address_space           = list(string)
    appsvc_integration_cidr = string
    aca_env_cidr            = string
  })
  description = "Configuration for the spoke virtual network and delegated subnets."
}

variable "dns_resolver_enabled" {
  type        = bool
  default     = false
  description = "Whether to create DNS resolver inbound and outbound subnets in the hub."

  validation {
    condition = var.dns_resolver_enabled ? (
      try(var.hub.dns_resolver_inbound_cidr, null) != null &&
      try(var.hub.dns_resolver_outbound_cidr, null) != null
    ) : true
    error_message = "Provide hub.dns_resolver_inbound_cidr and hub.dns_resolver_outbound_cidr when enabling DNS resolver subnets."
  }
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
  description = "Controls east-west connectivity posture between the hub and spoke virtual networks."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional tags to apply to all created resources."
}

