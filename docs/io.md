## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom\_name | Optional custom name to override the base name in tags. | `string` | `null` | no |
| deployment\_mode | Deployment mode identifier (e.g., blue/green, canary). | `string` | `"terraform"` | no |
| enabled | Enable or disable creation of all Private DNS Resolver | `bool` | `true` | no |
| environment | Deployment environment (e.g., dev, stage, prod). | `string` | `null` | no |
| extra\_tags | Additional tags to apply to all resources. | `map(string)` | `{}` | no |
| inbound\_endpoint\_map | Map of inbound DNS resolver endpoints to create. Each key is a unique identifier for the endpoint. | <pre>map(object({<br>    inbound_endpoint_name        = string<br>    private_ip_allocation_method = string<br>    private_ip_address           = optional(string)<br>    inbound_subnet_id            = string<br>  }))</pre> | `{}` | no |
| label\_order | Order of labels to be used in naming/tagging. | `list(any)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| location | Azure region where resources will be deployed. | `string` | `null` | no |
| managedby | Tag to indicate the tool or team managing the resources. | `string` | `"terraform"` | no |
| name | Base name for resources. | `string` | n/a | yes |
| outbound\_endpoint\_forwarding\_rule\_sets | List of DNS forwarding rulesets to associate with outbound endpoints. Each entry requires the outbound endpoint key (matching a key in outbound\_endpoint\_map) and the ruleset name. | <pre>list(object({<br>    outbound_endpoint_key   = string<br>    forwarding_ruleset_name = string<br>  }))</pre> | `[]` | no |
| outbound\_endpoint\_map | Map of outbound DNS resolver endpoints to create. Each key is a unique identifier for the endpoint. | <pre>map(object({<br>    outbound_endpoint_name = string<br>    outbound_subnet_id     = string<br>  }))</pre> | `{}` | no |
| repository | Repository URL or identifier for traceability. | `string` | `"https://github.com/terraform-az-modules/terraform-azurerm-private-dns-resolver.git"` | no |
| resource\_group\_name | Name of the resource group where resources will be deployed. | `string` | `null` | no |
| resource\_position\_prefix | If true, prefixes resource names instead of suffixing. | `bool` | `true` | no |
| virtual\_network\_id | The ID of the Virtual Network where this Private DNS Resolver should be located in. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| forwarding\_ruleset\_ids | Map of forwarding ruleset keys to their IDs. |
| forwarding\_ruleset\_names | Map of forwarding ruleset keys to their names. |
| inbound\_endpoint\_ids | Map of inbound endpoint keys to their IDs. |
| inbound\_endpoint\_ip\_addresses | Map of inbound endpoint keys to their private IP addresses. |
| inbound\_endpoint\_names | Map of inbound endpoint keys to their names. |
| outbound\_endpoint\_ids | Map of outbound endpoint keys to their IDs. |
| outbound\_endpoint\_names | Map of outbound endpoint keys to their names. |
| private\_dns\_resolver\_id | The ID of the Private DNS Resolver. |
| private\_dns\_resolver\_name | The name of the Private DNS Resolver. |

