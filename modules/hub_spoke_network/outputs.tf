output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  description = "Resource ID of the spoke virtual network."
  value       = azurerm_virtual_network.spoke.id
}

output "resource_group_name" {
  description = "Name of the resouce group"
  value       = local.rg_name
}

output "resource_group_id" {
  description = "Resource ID of the managed resource group when created "
  value       = local.create_resource_group ? azurerm_resource_group.this[0].id : null
}

output "hub_subnet_ids" {
  description = "Map of hub subnet names to their resource IDs."
  value = merge(
    {
      "GatewaySubnet" = azurerm_subnet.gateway.id
      "RunnerSubnet"  = azurerm_subnet.runner.id
    },
    var.dns_resolver_enabled ? {
      "DnsResolver-Inbound"  = azurerm_subnet.dns_resolver_inbound[0].id
      "DnsResolver-Outbound" = azurerm_subnet.dns_resolver_outbound[0].id
    } : {}
  )
}

output "spoke_subnet_ids" {
  description = "Map of spoke subnet names to their resource IDs."
  value = {
    "AppSvc-Integration" = azurerm_subnet.appsvc_integration.id
    "ACA-Env"            = azurerm_subnet.aca_env.id
  }
}

