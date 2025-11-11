# Private DNS Zones for Azure services
resource "azurerm_private_dns_zone" "services" {
  for_each            = local.private_dns_zones
  name                = each.value
  resource_group_name = local.rg_name
  tags                = var.tags
}

# Link private DNS zones to the hub VNet
resource "azurerm_private_dns_zone_virtual_network_link" "hub_links" {
  for_each              = azurerm_private_dns_zone.services
  name                  = "${azurerm_virtual_network.hub.name}-link"
  resource_group_name   = local.rg_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  registration_enabled  = false
  tags                  = var.tags
}

# Add these locals to support private endpoints
locals {
  private_dns_zones = {
    key_vault           = "privatelink.vaultcore.azure.net"
    container_registry  = "privatelink.azurecr.io"
    blob_storage        = "privatelink.blob.core.windows.net"
    cognitive_services  = "privatelink.cognitiveservices.azure.com"
    redis_cache        = "privatelink.redis.cache.windows.net"
    search_service     = "privatelink.search.windows.net"
    openai             = "privatelink.openai.azure.com"
  }
}

