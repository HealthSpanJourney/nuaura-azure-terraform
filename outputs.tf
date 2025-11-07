output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = module.hub_spoke_network.hub_vnet_id
}

output "spoke_vnet_id" {
  description = "Resource ID of the spoke virtual network."
  value       = module.hub_spoke_network.spoke_vnet_id
}

output "hub_subnet_ids" {
  description = "Map of hub subnet names to resource IDs."
  value       = module.hub_spoke_network.hub_subnet_ids
}

output "spoke_subnet_ids" {
  description = "Map of spoke subnet names to resource IDs."
  value       = module.hub_spoke_network.spoke_subnet_ids
}

