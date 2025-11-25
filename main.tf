##-----------------------------------------------------------------------------
## Standard Tagging Module – Applies standard tags to all resources for traceability
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
## Private DNS Resolver
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver" "this" {
  count               = var.enabled ? 1 : 0
  name                = var.resource_position_prefix ? format("dns-resolver-%s", local.name) : format("%s-dns-resolver", local.name)
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.virtual_network_id
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Inbound Endpoints
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  for_each = var.enabled ? {
    for ep in var.dns_resolver_inbound_endpoints :
    ep.inbound_endpoint_name => ep
  } : {}

  name                    = each.value.inbound_endpoint_name
  location                = var.location
  private_dns_resolver_id = azurerm_private_dns_resolver.this[0].id
  tags                    = module.labels.tags

  ip_configurations {
    subnet_id = each.value.inbound_subnet_id
  }
}

##-----------------------------------------------------------------------------
## Outbound Endpoints
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver_outbound_endpoint" "this" {
  for_each = var.enabled ? {
    for ep in var.dns_resolver_outbound_endpoints :
    ep.outbound_endpoint_name => ep
  } : {}

  name                    = each.value.outbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.this[0].id
  location                = var.location
  tags                    = module.labels.tags

  subnet_id = each.value.outbound_subnet_id
}

##-----------------------------------------------------------------------------
## DNS Forwarding Rulesets
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
  count               = var.enabled && length(var.dns_forwarding_rules) > 0 ? 1 : 0
  name                = var.resource_position_prefix ? format("ruleset-%s", local.name) : format("%s-ruleset", local.name)
  resource_group_name = var.resource_group_name
  location            = var.location

  private_dns_resolver_outbound_endpoint_ids = [
    for k, v in azurerm_private_dns_resolver_outbound_endpoint.this : v.id
  ]

  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## Forwarding Rules
##-----------------------------------------------------------------------------
resource "azurerm_private_dns_resolver_forwarding_rule" "this" {
  for_each = var.enabled && length(var.dns_forwarding_rules) > 0 ? {
    for rule in var.dns_forwarding_rules :
    rule.name => rule
  } : {}

  name                      = each.value.name
  domain_name               = each.value.domain_name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this[0].id

  dynamic "target_dns_servers" {
    for_each = each.value.target_dns_servers
    content {
      ip_address = target_dns_servers.value
      port       = 53
    }
  }
}
