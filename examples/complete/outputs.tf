##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------
output "dns_resolver_id" {
  value       = module.dns-private-resolver.private_dns_resolver_id
  description = "The resource ID of the Azure Private DNS Resolver."
}

output "dns_resolver_name" {
  value       = module.dns-private-resolver.private_dns_resolver_name
  description = "The resource ID of the Azure Private DNS Resolver."
}

output "dns_inbound_ips" {
  value       = module.dns-private-resolver.inbound_endpoint_ip_addresses
  description = "Map of inbound endpoint keys to their assigned private IP addresses. Use these IPs as DNS forwarder targets on on-premises DNS servers."
}

output "dns_outbound_ids" {
  value       = module.dns-private-resolver.outbound_endpoint_ids
  description = "Map of outbound endpoint keys to their resource IDs. Used to associate forwarding rulesets and route DNS queries from Azure to on-premises or custom resolvers."
}

output "dns_forwarding_ruleset_ids" {
  value       = module.dns-private-resolver.forwarding_ruleset_ids
  description = "Map of DNS forwarding ruleset keys to their resource IDs. Used to link rulesets to VNets for conditional DNS forwarding."
}