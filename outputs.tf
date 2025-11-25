##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------
output "label_order" {
  value       = local.label_order
  description = "Label order."
}

output "private_dns_resolver_id" {
  value       = azurerm_private_dns_resolver.this[0].id
  description = "ID of the Private DNS Resolver"
}

output "inbound_endpoint_ids" {
  value = {
    for name, endpoint in azurerm_private_dns_resolver_inbound_endpoint.this :
    name => endpoint.id
  }
  description = "IDs of all inbound endpoints"
}

output "inbound_endpoint_subnets" {
  value = {
    for ep in var.dns_resolver_inbound_endpoints :
    ep.inbound_endpoint_name => ep.inbound_subnet_id
  }
  description = "Subnet IDs passed to the module for inbound endpoints"
}

# Outbound Endpoint IDs
output "outbound_endpoint_ids" {
  value = {
    for name, endpoint in azurerm_private_dns_resolver_outbound_endpoint.this :
    name => endpoint.id
  }
  description = "Map of outbound endpoint name to resource ID"
}

# Forwarding Ruleset ID (only if forwarding rules exist)
output "dns_forwarding_ruleset_id" {
  value       = length(azurerm_private_dns_resolver_dns_forwarding_ruleset.this) > 0 ? azurerm_private_dns_resolver_dns_forwarding_ruleset.this[0].id : null
  description = "ID of the DNS Forwarding Ruleset (if created)"
}

# Forwarding Rule IDs
output "dns_forwarding_rule_ids" {
  value = {
    for name, rule in azurerm_private_dns_resolver_forwarding_rule.this :
    name => rule.id
  }
  description = "Map of forwarding rule name to forwarding rule ID"
}
