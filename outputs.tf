##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------
output "private_dns_resolver_id" {
  description = "The ID of the Private DNS Resolver."
  value       = try(azurerm_private_dns_resolver.main[0].id, null)
}

output "private_dns_resolver_name" {
  description = "The name of the Private DNS Resolver."
  value       = try(azurerm_private_dns_resolver.main[0].name, null)
}

output "inbound_endpoint_ids" {
  description = "Map of inbound endpoint keys to their IDs."
  value = {
    for k, v in azurerm_private_dns_resolver_inbound_endpoint.main :
    k => v.id
  }
}

output "inbound_endpoint_names" {
  description = "Map of inbound endpoint keys to their names."
  value = {
    for k, v in azurerm_private_dns_resolver_inbound_endpoint.main :
    k => v.name
  }
}

output "inbound_endpoint_ip_addresses" {
  description = "Map of inbound endpoint keys to their private IP addresses."
  value = {
    for k, v in azurerm_private_dns_resolver_inbound_endpoint.main :
    k => v.ip_configurations[0].private_ip_address
  }
}

output "outbound_endpoint_ids" {
  description = "Map of outbound endpoint keys to their IDs."
  value = {
    for k, v in azurerm_private_dns_resolver_outbound_endpoint.main :
    k => v.id
  }
}

output "outbound_endpoint_names" {
  description = "Map of outbound endpoint keys to their names."
  value = {
    for k, v in azurerm_private_dns_resolver_outbound_endpoint.main :
    k => v.name
  }
}

output "forwarding_ruleset_ids" {
  description = "Map of forwarding ruleset keys to their IDs."
  value = {
    for k, v in azurerm_private_dns_resolver_dns_forwarding_ruleset.main :
    k => v.id
  }
}

output "forwarding_ruleset_names" {
  description = "Map of forwarding ruleset keys to their names."
  value = {
    for k, v in azurerm_private_dns_resolver_dns_forwarding_ruleset.main :
    k => v.name
  }
}