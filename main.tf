##-----------------------------------------------------------------------------
# Standard Tagging Module – Applies standard tags to all resources for traceability
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/tags/azurerm"
  version         = "1.0.2"
  name            = var.custom_name == null ? var.name : var.custom_name
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

##-----------------------------------------------------------------------------
# Private DNS Resolver
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver" "main" {
  count               = var.enabled ? 1 : 0
  name                = var.resource_position_prefix ? format("dnspr-%s", local.name) : format("%s-dnspr", local.name)
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.virtual_network_id
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
# Private DNS Resolver - Inbound Endpoints
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver_inbound_endpoint" "main" {
  for_each                = var.enabled ? var.inbound_endpoint_map : {}
  name                    = "${each.value.inbound_endpoint_name}-in"
  private_dns_resolver_id = azurerm_private_dns_resolver.main[0].id
  location                = var.location
  tags                    = module.labels.tags
  ip_configurations {
    private_ip_allocation_method = each.value.private_ip_allocation_method
    private_ip_address           = each.value.private_ip_address
    subnet_id                    = each.value.inbound_subnet_id
  }
}

##-----------------------------------------------------------------------------
# Private DNS Resolver - Outbound Endpoints
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver_outbound_endpoint" "main" {
  for_each                = var.enabled ? var.outbound_endpoint_map : {}
  name                    = "${each.value.outbound_endpoint_name}-out"
  private_dns_resolver_id = azurerm_private_dns_resolver.main[0].id
  location                = var.location
  subnet_id               = each.value.outbound_subnet_id
  tags                    = module.labels.tags
}

##-----------------------------------------------------------------------------
# Private DNS Resolver - DNS Forwarding Rulesets
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "main" {
  for_each = var.enabled ? {
    for frs in var.outbound_endpoint_forwarding_rule_sets :
    "${frs.outbound_endpoint_key}-${frs.forwarding_ruleset_name}" => frs
  } : {}
  name                                       = each.value.forwarding_ruleset_name
  resource_group_name                        = var.resource_group_name
  location                                   = var.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.main[each.value.outbound_endpoint_key].id]
  tags                                       = module.labels.tags
}